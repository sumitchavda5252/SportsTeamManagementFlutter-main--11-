import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleManagementPage extends StatefulWidget {
  @override
  _ScheduleManagementPageState createState() => _ScheduleManagementPageState();
}

class _ScheduleManagementPageState extends State<ScheduleManagementPage> {
  final Map<String, List<Map<String, dynamic>>> _schedule = {};
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _addTask() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    if (_taskController.text.isNotEmpty) {
      setState(() {
        if (_schedule[formattedDate] == null) {
          _schedule[formattedDate] = [];
        }
        _schedule[formattedDate]!
            .add({'task': _taskController.text, 'completed': false});
        _taskController.clear();
      });
    }
  }

  void _editTask(int index) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    String oldTask = _schedule[formattedDate]![index]['task'];
    _taskController.text = oldTask;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: 'Task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  setState(() {
                    _schedule[formattedDate]![index]['task'] =
                        _taskController.text;
                    _taskController.clear();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _removeTask(int index) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    setState(() {
      _schedule[formattedDate]!.removeAt(index);
    });
  }

  void _clearTasks() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    setState(() {
      _schedule[formattedDate]?.clear();
    });
  }

  void _toggleTaskCompletion(int index) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    setState(() {
      _schedule[formattedDate]![index]['completed'] =
          !_schedule[formattedDate]![index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: _clearTasks,
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Color.fromARGB(255, 243, 248, 249),
              child: ListTile(
                title: Text('Selected Date: $formattedDate',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.blue),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Task for the day',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 7, 194, 240)),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: (_schedule[formattedDate]?.map((task) {
                      int index = _schedule[formattedDate]!.indexOf(task);
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            task['task'],
                            style: TextStyle(
                              decoration: task['completed']
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task['completed']
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(task['completed']
                                    ? Icons.undo
                                    : Icons.check),
                                color: const Color.fromARGB(255, 0, 100, 150),
                                onPressed: () => _toggleTaskCompletion(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editTask(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList() ?? [ListTile(title: Text(''))]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
