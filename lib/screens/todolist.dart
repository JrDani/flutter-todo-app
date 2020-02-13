import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/screens/tododetail.dart';
import 'package:todo_app/utils/db.helper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();

}
class TodoListState extends State {
  DbHelper dbHelper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItem(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          navigateToDetail(Todo('', '', 3));
        },
        tooltip: "Novo Todo",
        child: new Icon(Icons.add)
      ),
    );
  }
  
  ListView todoListItem() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].priority),
              child: Text(this.todos[position].id.toString()),
            ),
            title: Text(this.todos[position].title),
            subtitle: Text(this.todos[position].date),
            onTap: () {
              debugPrint("tocou o " + this.todos[position].id.toString());
              navigateToDetail(this.todos[position]);
            }
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = dbHelper.initializeDb();
    dbFuture.then((db) {
      final todosFuture = dbHelper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for(int i=0; i<count; i++){
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items " + count.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch(priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default: 
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo))
    );
    if (result == true) {
      getData();
    }
  }
}   