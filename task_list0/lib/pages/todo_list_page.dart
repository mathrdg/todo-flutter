import 'package:flutter/material.dart';
import 'package:task_list0/models/todo.dart';
import 'package:task_list0/pages/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todocontroller = TextEditingController();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    //ocupa todo o espaço da tela, ajuda a quebrar linha
                    // propriedade flex dá mais volume, é '3x' maior que o botão
                    child: TextField(
                      controller: todocontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: 'Adiciona Tarefa, Corno',
                        hintText: 'Ex.:  Cagar em casa',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String text = todocontroller.text;
                      setState(() {
                        Todo newTodo = Todo(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        todos.add(newTodo);
                      });
                      todocontroller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (Color(0xff00d7f3)),
                      fixedSize: Size(50, 55),
                    ),
                    child: Text(
                      '+',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                //permite que o listview não quebre
                child: ListView(
                    shrinkWrap:
                        true, // permite ocupar o máximo de espaço do item
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Text(
                      'Você Possui ${todos.length} Tarefas Pendentes, degraçado',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        deleteYorN(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (Color(0xff00d7f3)),
                        padding: EdgeInsets.all(15)),
                    child: Text(
                      'Limpar Tudo',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa "${todo.title} foi removida',
        style: TextStyle(color: Color(0xff060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
          label: 'Desfazer',
          textColor: Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          }),
    ));
  }

  void limpar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Todas a(s) ${todos.length} tarefas foram apagadas')));
    todos.clear();
  }

  void deleteYorN(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Me confirma aí, desgraçado"),
          content: Text("Tu vai ter coragem de apagar todas as tarefas ?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Color(0xff00d7f3)),
              onPressed: () {
                // Fechar o diálogo sem realizar a ação.
                Navigator.of(context).pop();
              },
              child: Text("Apague não"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  limpar();
                });

                // Realizar a ação.

                // Fechar o diálogo após realizar a ação.
                Navigator.of(context).pop();
              },
              child: Text("Apaga essa porra"),
            ),
          ],
        );
      },
    );
  }
}
