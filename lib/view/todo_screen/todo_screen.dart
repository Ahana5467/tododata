


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tododata/controller/category_controller.dart';
import 'dart:html' as html;
import 'dart:async';

// import 'package:tododata/view/categories_screen/categories_screen.dart';

class TodoScreen extends StatefulWidget {
  final Map? todo; // Accept a todo object for editing
  const TodoScreen({super.key, this.todo});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  void _requestNotificationPermission() {
    if (html.Notification.permission != "granted") {
      html.Notification.requestPermission().then((permission) {
        if (permission != "granted") {
          print("Notification permission denied.");
        }
      });
    }
  }

  void _scheduleNotification(String title, String body, DateTime dateTime) {
    final now = DateTime.now();
    final duration = dateTime.difference(now);

    if (duration.isNegative) {
      print("Scheduled time is in the past. Cannot schedule notification.");
      return;
    }

    Timer(duration, () {
      if (html.Notification.permission == "granted") {
        html.Notification(title, body: body);
      } else {
        print("Notification permission not granted.");
      }
    });
  }




  DateTime? _parseDateTime() {
  if (dateController.text.isEmpty || timeController.text.isEmpty) {
    return null;
  }

  try {
    final date = DateFormat('yyyy-MM-dd').parse(dateController.text);
    final timeParts = timeController.text.split(":");
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1].split(" ")[0]);
    final period = timeController.text.split(" ")[1].toLowerCase();
    final adjustedHours = (period == "pm" && hours != 12) ? hours + 12 : hours;

    return DateTime(date.year, date.month, date.day, adjustedHours, minutes);
  } catch (e) {
    print("Error parsing date or time: $e");
    return null;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Add Todo",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration:  InputDecoration(
                  labelText: "Title",
                  hintText: "Add a title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Write a description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date",
                  hintText: "Pick a date",
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please pick a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Time",
                  hintText: "Pick a time",
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    timeController.text = pickedTime.format(context);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please pick a time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () async {
              //     final result = await Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => CategoriesScreen()),
              //     );
              //     if (result != null) {
              //       setState(() {
              //         categoryController.text = result; // Update selected category
              //       });
              //     }
              //   },
              //   child: Text("Select Category"),
              // ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final dateTime = _parseDateTime();
                      await CategoryController.addtodo(
                      title: titleController.text,
                      description: descriptionController.text,
                      date: dateController.text,
                      category: categoryController.text,
                    );
                    if (dateTime != null) {
                      _scheduleNotification(
                        titleController.text,
                        descriptionController.text,
                        dateTime,
                      );
                       
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Notification scheduled successfully!")),
                      );

                      Navigator.pop(context); 
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid date or time")),
                      );
                    }
                  }
                },
                
                child: Text("Save and Schedule Notification"),
              ),


            ],
          ),
        ),
      ),
    );
  }
}




