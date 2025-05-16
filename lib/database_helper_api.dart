import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static const String baseUrl = "http://10.56.46.48/apptarefasweb/public/api";

  //Create
  static Future<void> adicionarTarefa(String tarefa) async {
    final url = Uri.parse('$baseUrl/tarefas');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'tarefa': tarefa,
          'status': 0,
        },
      ),
    );
  }

  //Read
  static Future<List<Map<String, dynamic>>> getTarefas() async {
    final url = Uri.parse('$baseUrl/tarefas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> listaTarefa = jsonDecode(response.body);
      return listaTarefa.cast<Map<String, dynamic>>();
    }

    throw Exception('Falha ao carregar tarefas');
  }

  //Update
  static Future<void> editarTarefa(int id, String tarefa, int status) async {
    final url = Uri.parse('$baseUrl/tarefas/$id');
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'tarefa': tarefa,
          'status': status,
        },
      ),
    );
  }

  //Delete
  static Future<void> deletarTarefa(int id) async {
    final url = Uri.parse('$baseUrl/tarefas/deletar/$id');
    await http.post(url);
  }
}
