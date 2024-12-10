
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tododata/controller/category_controller.dart';
import 'package:tododata/view/categories_screen/categories_screen.dart';
import 'package:tododata/view/edit%20_task_dialog/edit_task_dialog.dart';
import 'package:tododata/view/todo_screen/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<int, bool> checkboxStates = {}; 
  Map<int, String> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await CategoryController.gettodo();
      setState(() {}); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:  Text(
          "My List",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoScreen()),
          );
          setState(() {});
        },
        backgroundColor: Colors.blueAccent.shade100,
        child:  Icon(Icons.add, color: Colors.white),
      ),
      body: CategoryController.todoList.isEmpty
          ?  Center(child: Text("No tasks available. Add some!"))
          : ListView.builder(
              itemCount: CategoryController.todoList.length,
              itemBuilder: (context, index) {
                final todo = CategoryController.todoList[index];
                final formattedDate = DateFormat('yyyy-MM-dd').format(
                  DateFormat('yyyy-MM-dd').parse(todo["date"]),
                );

               if (checkboxStates[todo["id"]] == null) {
                checkboxStates[todo["id"]] = todo["isChecked"] == 1;
              }
                return Card(
                  color: Colors.black,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: checkboxStates[todo["id"]],
                      onChanged: (bool? value) {
                        setState(() {
                          checkboxStates[todo["id"]] = value!;
                        });
                      },
                    ),
                    title: Text(todo["title"],style:  TextStyle(color: Colors.white),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo["description"], style:  TextStyle(color: Colors.white)),
                        Text("Due: $formattedDate", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,MaterialPageRoute(builder: (context) => CategoriesScreen(),),
                            );
                            if (result != null) {
                              setState(() {
                                selectedCategories[todo["id"]] = result;
                              });
                            }
                          },
                          child: Text(
                            selectedCategories[todo["id"]] ?? "Select Category",
                            style: TextStyle(
                              color: selectedCategories[todo["id"]] != null ? Colors.green : Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon:  Icon(Icons.edit, color: Colors.white),
                          onPressed: () async {
                            final updatedTask = await  Navigator.push(
                              context,MaterialPageRoute(builder: (context) => EditTaskDialog(todo:Map<String, dynamic>.from(todo)),),
                            );
                            if (updatedTask != null) {
                              await CategoryController.updatetodo(
                                id: todo["id"],
                                title: updatedTask["title"],
                                description: updatedTask["description"],
                                date: updatedTask["date"],
                                category: updatedTask["category"],
                                isChecked: checkboxStates[todo["id"]] ?? false,
                              );
                              setState(() {}); 
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            await CategoryController.deletetodo(todo["id"]);
                            setState(() {}); 
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


