import 'package:apptarefas/database_helper_api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _tarefas = [];
  final TextEditingController _txtTarefaController = TextEditingController();
  final TextEditingController _txtEditarTarefaController =
      TextEditingController();

  @override /* O 'override aqui é por conta do initState' */
  void initState() {
    super.initState();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final tarefas = await DatabaseHelper.getTarefas();
    // print(tarefas);
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

  void editarTarefa(int index) {
    final dadosTarefa = _tarefas[index];

    _txtEditarTarefaController.text = dadosTarefa["tarefa"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Tarefa"),
          content: TextField(
            controller: _txtEditarTarefaController,
            decoration: const InputDecoration(
              labelText: "Tarefa",
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () async {
                    if (_txtEditarTarefaController.text.isNotEmpty) {
                      await DatabaseHelper.editarTarefa(
                        dadosTarefa["id"],
                        _txtEditarTarefaController.text,
                        dadosTarefa["status"],
                      );
                      carregarTarefas();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> marcarTarefa(int index) async {
    final dadosTarefa = _tarefas[index];
    final status = dadosTarefa["status"] == 0 ? 1 : 0;
    await DatabaseHelper.editarTarefa(
      dadosTarefa["id"],
      dadosTarefa["tarefa"],
      status,
    );
    carregarTarefas();
  }

  Future<void> deletarTarefas(int id) async {
    await DatabaseHelper.deletarTarefa(id);
    carregarTarefas();
  }

  void confirmarDelete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Tarefa"),
          content: const Text("Tem certeza de que deseja excluir esta tarefa?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    deletarTarefas(id);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Excluir"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
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
                      decoration: const InputDecoration(
                        labelText: "  Nova Tarefa",
                      ),
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
                      value: tarefa['status'] == 1,
                      onChanged: (value) => marcarTarefa(index),
                    ),
                    title: Text(
                      tarefa["tarefa"],
                      style: TextStyle(
                        decoration: tarefa['status'] == 1
                            ? TextDecoration.lineThrough
                            : null,
                        color: tarefa['status'] == 1 ? Colors.black54 : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            editarTarefa(index);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => confirmarDelete(tarefa['id']),
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
      ),
    );
  }
}
