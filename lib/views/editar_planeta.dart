import 'package:flutter/material.dart';
import 'package:planetario/models/planeta.dart';
import 'package:planetario/controllers/planeta_controller.dart';

// Tela para editar os detalhes de um planeta
class EditarPlanetaPage extends StatefulWidget {
  final Planeta planeta;

  const EditarPlanetaPage({Key? key, required this.planeta})
      : super(key: key);

  @override
  State<EditarPlanetaPage> createState() => _EditarPlanetaPageState();
}

class _EditarPlanetaPageState extends State<EditarPlanetaPage> {
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário
  late final TextEditingController _nomeController; // Controlador para o campo nome
  late final TextEditingController _apelidoController; // Controlador para o campo apelido
  late final TextEditingController _distanciaSolController; // Controlador para o campo distância do sol
  late final TextEditingController _tamanhoController; // Controlador para o campo tamanho

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os valores do planeta
    _nomeController = TextEditingController(text: widget.planeta.nome);
    _apelidoController =
        TextEditingController(text: widget.planeta.apelido ?? ''); // Usando ?? para lidar com apelidos nulos
    _distanciaSolController =
        TextEditingController(text: widget.planeta.distanciaSol.toString());
    _tamanhoController = TextEditingController(text: widget.planeta.tamanho.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Planeta'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/galaxy.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: const Color.fromRGBO(255, 255, 255, 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView( // Permite rolagem se o conteúdo exceder a tela
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ocupa o mínimo de espaço possível
                    children: [
                      // Campo para o nome
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      // Campo para o apelido
                      TextFormField(
                        controller: _apelidoController,
                        decoration: const InputDecoration(
                          labelText: 'Apelido',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Campo para a distância do sol
                      TextFormField(
                        controller: _distanciaSolController,
                        decoration: const InputDecoration(
                          labelText: 'Distância do Sol',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Valor inválido';
                          }
                          return null;
                        },
                      ),
                      // Campo para o tamanho
                      TextFormField(
                        controller: _tamanhoController,
                        decoration: const InputDecoration(
                          labelText: 'Tamanho',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Valor inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Botão para salvar as alterações
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // Cria um novo objeto Planeta com os dados atualizados
                              final planetaAtualizado = widget.planeta.copyWith(
                                nome: _nomeController.text,
                                apelido: _apelidoController.text,
                                distanciaSol: double.parse(_distanciaSolController.text),
                                tamanho: double.parse(_tamanhoController.text),
                              );

                              // Chama o controlador para atualizar o planeta
                              await PlanetaController().atualizarPlaneta(planetaAtualizado);

                              if (mounted) { // Verifica se o widget ainda está montado
                                Navigator.pop(context); // Volta para a tela anterior
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Planeta atualizado com sucesso!'),
                                  ),
                                );
                              }
                            } catch (e) {
                              print('Erro ao atualizar planeta: $e');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao atualizar: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Salvar Alterações'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}