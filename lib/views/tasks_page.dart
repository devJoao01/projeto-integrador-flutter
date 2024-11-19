import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_login_screen/services/firestore_service.dart';

class TasksPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar dados: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List tasksList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasksList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = tasksList[index];
              String docId = document.id;
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String taskTitle = data["title"];
              String taskDescription = data["description"];
              Color backgroundColor = (index % 2 == 0) ? Color(0xFFDCDCDC) : Colors.white;

              return Card(
                color: backgroundColor,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(taskTitle),
                  subtitle: Text(taskDescription),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, docId);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _firestoreService.deleteTask(docId);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
