import 'package:flutter/material.dart';
import 'package:planetario/models/planeta.dart';
import 'package:planetario/controllers/planeta_controller.dart';

// Tela de cadastro de planetas
class CadastroPlanetaPage extends StatefulWidget {
  const CadastroPlanetaPage({Key? key}) : super(key: key);

  @override
  State<CadastroPlanetaPage> createState() => _CadastroPlanetaPageState();
}

class _CadastroPlanetaPageState extends State<CadastroPlanetaPage> {
  // Chave global para o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  final _nomeController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _distanciaSolController = TextEditingController();
  final _tamanhoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Planeta'),
      ),
      body: Container(
        // Define a imagem de fundo
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/galaxy.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Card para o formulário
          child: Card(
            color: const Color.fromRGBO(255, 255, 255, 0.7), // Branco transparente
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView( // Permite scroll caso o conteúdo exceda a tela
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ocupa o mínimo de espaço possível
                    children: [
                      // Campo de texto para o nome do planeta
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
                      // Campo de texto para o apelido do planeta
                      TextFormField(
                        controller: _apelidoController,
                        decoration: const InputDecoration(
                          labelText: 'Apelido',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Campo de texto para a distância do sol
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
                      // Campo de texto para o tamanho do planeta
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
                      // Botão para cadastrar o planeta
                      ElevatedButton(
                        onPressed: () async {
                          // Valida o formulário
                          if (_formKey.currentState!.validate()) {
                            try {
                              // Cria um novo objeto Planeta com os dados do formulário
                              final planeta = Planeta(
                                nome: _nomeController.text,
                                apelido: _apelidoController.text,
                                distanciaSol: double.parse(_distanciaSolController.text),
                                tamanho: double.parse(_tamanhoController.text),
                              );

                              // Chama o controlador para cadastrar o planeta
                              await PlanetaController().cadastrarPlaneta(planeta);

                              // Exibe uma mensagem de sucesso
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Planeta cadastrado com sucesso!'),
                                ),
                              );

                              // Volta para a tela anterior
                              Navigator.pop(context);
                            } catch (e) {
                              // Exibe uma mensagem de erro
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao cadastrar planeta: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              // Imprime o erro no console para depuração
                              print('Erro ao cadastrar planeta: $e');
                            }
                          }
                        },
                        child: const Text('Cadastrar'),
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