import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planetario/models/planeta.dart';
import 'package:planetario/controllers/planeta_controller.dart';

class DetalhesPlanetaPage extends StatefulWidget {
  final Planeta planeta;

  const DetalhesPlanetaPage({Key? key, required this.planeta})
      : super(key: key);

  @override
  State<DetalhesPlanetaPage> createState() => _DetalhesPlanetaPageState();
}

class _DetalhesPlanetaPageState extends State<DetalhesPlanetaPage> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planeta.nome),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/galaxy.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Material(
                    elevation: _isPressed ? 2 : 4,
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      onTap: () {},
                      onHover: (value) {
                        setState(() {
                          _isHovering = value;
                        });
                      },
                      onHighlightChanged: (value) {
                        setState(() {
                          _isPressed = value;
                        });
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      child: Card(
                        elevation: 0,
                        color: _isHovering ? Colors.grey[200] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.planeta.nome,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(50, 50, 50, 1.0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.planeta.apelido ?? '-',
                                style: const TextStyle(
                                  color: Color.fromRGBO(50, 50, 50, 1.0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row( // Widget Row para alinhar texto e número
                                children: [
                                  Text(
                                    'Distância do Sol: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(50, 50, 50, 1.0),
                                    ),
                                  ),
                                  Text(
                                    '${widget.planeta.distanciaSol == 0
                                        ? widget.planeta.distanciaSol
                                        : NumberFormat('#,###').format(widget.planeta.distanciaSol)} km',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(50, 50, 50, 1.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row( // Widget Row para alinhar texto e número
                                children: [
                                  Text(
                                    'Tamanho: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(50, 50, 50, 1.0),
                                    ),
                                  ),
                                  Text(
                                    '${widget.planeta.tamanho} km',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(50, 50, 50, 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showDeleteConfirmationDialog(context);
                        },
                        onHover: (value) {
                          setState(() {
                            _isHovering = value;
                          });
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: _isHovering ? Colors.red[700] : Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir este planeta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (widget.planeta.id != null) {
                  try {
                    await PlanetaController().excluirPlaneta(widget.planeta.id!);

                    if (mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Planeta excluído com sucesso!'),
                        ),
                      );
                    }
                  } catch (e) {
                    print('Erro ao excluir planeta: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao excluir: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  print('ID do planeta é nulo. Não é possível excluir.');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Não é possível excluir. ID do planeta inválido.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}