import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_login_screen/services/authentication_service.dart';
import 'package:new_login_screen/services/firestore_service.dart';
import 'tasks_page.dart'; 

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptController.dispose();
    super.dispose();
  }

  void _openModalForm({String? docId}) async {
    if (docId != null) {
      try {
        DocumentSnapshot document = await _firestoreService.getTask(docId);
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        _titleController.text = data["title"];
        _descriptController.text = data["description"];
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar tarefa: $e")),
        );
        return;
      }
    } else {
      _titleController.clear();
      _descriptController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            docId == null ? "Adicionar Tarefa" : "Editar Tarefa",
            style: const TextStyle(fontSize: 17),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Título",
                    prefixIcon: const Icon(Icons.text_fields),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptController,
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    prefixIcon: const Icon(Icons.text_fields),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _descriptController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Preencha todos os campos!")),
                  );
                  return;
                }
                try {
                  if (docId == null) {
                    await _firestoreService.addTasks(
                      _titleController.text,
                      _descriptController.text,
                    );
                  } else {
                    await _firestoreService.updateTask(
                      docId,
                      _titleController.text,
                      _descriptController.text,
                    );
                  }
                  _titleController.clear();
                  _descriptController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tarefa salva com sucesso!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao salvar tarefa: $e")),
                  );
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.displayName ?? "Não informado"),
              accountEmail: Text(widget.user.email ?? "Não informado"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: widget.user.photoURL != null
                    ? NetworkImage(widget.user.photoURL!)
                    : null,
                child: widget.user.photoURL == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),
            ListTile(
              title: const Text("Ver Tarefas"),
              leading: const Icon(Icons.list),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasksPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Deslogar"),
              leading: const Icon(Icons.logout),
              onTap: () {
                AuthenticationService().logoutUser();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openModalForm();
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: const Text(
          "Bem-vindo! Use o menu para navegar.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
