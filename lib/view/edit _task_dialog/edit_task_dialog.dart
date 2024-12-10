import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTaskDialog extends StatefulWidget {
  final Map<String, dynamic> todo;
  const EditTaskDialog({Key? key, required this.todo}) : super(key: key);

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo["title"]);
    descriptionController = TextEditingController(text: widget.todo["description"]);
    selectedDate = DateFormat('yyyy-MM-dd').parse(widget.todo["date"]);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Text("Edit Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
           SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Due Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.blue),
                onPressed: () => selectDate(context), 
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              "title": titleController.text,
              "description": descriptionController.text,
              "date": widget.todo["date"],
              "category": widget.todo["category"],
            });
          },
          child: Text("Save"),
        ),
      ],
    );
  }

 
}
