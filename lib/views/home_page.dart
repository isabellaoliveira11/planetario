import 'package:flutter/material.dart';
import 'package:planetario/models/planeta.dart';
import 'package:planetario/controllers/planeta_controller.dart';
import 'cadastro_planeta.dart';
import 'detalhes_planeta.dart' as detalhes; // Importa com alias para evitar conflitos
import 'editar_planeta.dart';

// Tela inicial do aplicativo, exibindo a lista de planetas
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Planeta>> _planetas; // Variável para armazenar a lista de planetas (Future)

  @override
  void initState() {
    super.initState();
    _planetas = PlanetaController().listarPlanetas(); // Carrega a lista de planetas ao inicializar o widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planetário'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/galaxy.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo ao Planetário',
                style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 208, 208, 208)),
              ),
              const SizedBox(height: 20),
              // Botão para cadastrar um novo planeta
              ElevatedButton(
                onPressed: () {
                  // Navega para a tela de cadastro
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroPlanetaPage(),
                    ),
                  ).then((_) {
                    // Atualiza a lista de planetas após o cadastro (usando then para esperar o retorno da tela)
                    setState(() {
                      _planetas = PlanetaController().listarPlanetas();
                    });
                  });
                },
                child: const Text('Cadastrar Planeta'),
              ),
              const SizedBox(height: 20),
              // Exibe a lista de planetas
              Expanded( // Expande para ocupar o espaço restante
                child: FutureBuilder<List<Planeta>>( // Widget para lidar com o Future<List<Planeta>>
                  future: _planetas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) { // Se os dados foram carregados
                      return ListView.builder( // Constrói a lista de planetas
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final planeta = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(planeta.nome),
                              subtitle: Text(planeta.apelido ?? ''), // Exibe o apelido ou nada se for nulo
                              trailing: IconButton( // Botão para editar o planeta
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Navega para a tela de edição
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditarPlanetaPage(planeta: planeta),
                                    ),
                                  ).then((_) {
                                    // Atualiza a lista após a edição
                                    setState(() {
                                      _planetas = PlanetaController().listarPlanetas();
                                    });
                                  });
                                },
                              ),
                              onTap: () {
                                // Navega para a tela de detalhes
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => detalhes.DetalhesPlanetaPage(planeta: planeta),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _planetas = PlanetaController().listarPlanetas();
                                  });
                                });
                              },
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) { // Se ocorreu um erro no carregamento
                      return Center(
                        child: Text('Erro: ${snapshot.error.toString()}'),
                      );
                    } else { // Enquanto os dados estão sendo carregados
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}