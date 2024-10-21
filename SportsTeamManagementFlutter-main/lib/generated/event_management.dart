import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventManagementPage extends StatefulWidget {
  @override
  _EventManagementPageState createState() => _EventManagementPageState();
}

class _EventManagementPageState extends State<EventManagementPage> {
  final List<Map<String, String>> _events = [];
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  DateTime? _selectedDate;
  String _searchTerm = '';

  final _formKey = GlobalKey<FormState>();

  void _addEvent() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate != null) {
        setState(() {
          _events.add({
            'name': _eventNameController.text,
            'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
            'location': _eventLocationController.text,
            'description': _eventDescriptionController.text,
          });
          _eventNameController.clear();
          _eventLocationController.clear();
          _eventDescriptionController.clear();
          _selectedDate = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date')),
        );
      }
    }
  }

  void _removeEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  void _editEvent(int index) {
    _eventNameController.text = _events[index]['name']!;
    _eventLocationController.text = _events[index]['location']!;
    _eventDescriptionController.text = _events[index]['description']!;
    _selectedDate = DateFormat('yyyy-MM-dd').parse(_events[index]['date']!);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_eventNameController, 'Event Name'),
                SizedBox(height: 10),
                _buildTextField(_eventLocationController, 'Event Location'),
                SizedBox(height: 10),
                _buildTextField(
                    _eventDescriptionController, 'Event Description',
                    maxLines: 3),
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Select Event Date'
                        : 'Event Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                  ),
                  trailing:
                      Icon(Icons.calendar_today, color: Colors.blueAccent),
                  onTap: () => _selectDate(context),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _events[index] = {
                      'name': _eventNameController.text,
                      'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      'location': _eventLocationController.text,
                      'description': _eventDescriptionController.text,
                    };
                    _eventNameController.clear();
                    _eventLocationController.clear();
                    _eventDescriptionController.clear();
                    _selectedDate = null;
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showEventDetails(Map<String, String> event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event['name']!),
          content: Text(
            'Date: ${event['date']!}\nLocation: ${event['location']!}\nDescription: ${event['description']!}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _searchEvents(String term) {
    setState(() {
      _searchTerm = term;
    });
  }

  List<Map<String, String>> get _filteredEvents {
    if (_searchTerm.isEmpty) {
      return _events;
    } else {
      return _events
          .where((event) =>
              event['name']!.toLowerCase().contains(_searchTerm.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add sport event'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Events',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _searchEvents,
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_eventNameController, 'Event Name'),
                  SizedBox(height: 10),
                  _buildTextField(_eventLocationController, 'Event Location'),
                  SizedBox(height: 10),
                  _buildTextField(
                      _eventDescriptionController, 'Event Description',
                      maxLines: 3),
                  ListTile(
                    title: Text(
                      _selectedDate == null
                          ? 'Select Event Date'
                          : 'Event Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    ),
                    trailing:
                        Icon(Icons.calendar_today, color: Colors.blueAccent),
                    onTap: () => _selectDate(context),
                  ),
                  ElevatedButton(
                    onPressed: _addEvent,
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _filteredEvents.isEmpty
                  ? Center(
                      child: Text('',
                          style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEvents[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(event['name']!,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              'Date: ${event['date']!}\nLocation: ${event['location']!}',
                            ),
                            isThreeLine: true,
                            onTap: () => _showEventDetails(event),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editEvent(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeEvent(index),
                                ),
                              ],
                            ),
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

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
