import 'package:apptarefas/database_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _tarefas = [];
  final TextEditingController _txtTarefaController = TextEditingController();

  @override /* O 'override aqui é por conta do initState' */
  void initState() {
    super.initState();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final tarefas = await DatabaseHelper.getTarefas();
    print(tarefas);
    setState(() {
      _tarefas = tarefas;
    });
  }

  Future<void> adicionarTarefa() async {
    if (_txtTarefaController.text.isNotEmpty) {
      await DatabaseHelper.adicionarTarefa(_txtTarefaController.text);
      _txtTarefaController.clear();
      carregarTarefas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _txtTarefaController,
                    decoration:
                        const InputDecoration(labelText: "  Nova Tarefa"),
                  ),
                ),
                IconButton(
                  onPressed: adicionarTarefa,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return ListTile(
                  leading: Checkbox(
                    value: false,
                    onChanged: (value) => value,
                  ),
                  title: Text(tarefa["tarefa"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
