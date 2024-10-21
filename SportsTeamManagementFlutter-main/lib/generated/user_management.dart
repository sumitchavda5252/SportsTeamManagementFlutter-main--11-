import 'package:flutter/material.dart';
import 'dart:async';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<User> _users = [

  ];

  final TextEditingController _userNameController = TextEditingController();
  String _searchTerm = '';
  final _formKey = GlobalKey<FormState>();
  User? _deletedUser;
  int? _deletedUserIndex;

  void _searchUser(String term) {
    setState(() {
      _searchTerm = term;
    });
  }

  void _addUser() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _users.add(User(name: _userNameController.text, role: 'Member'));
        _userNameController.clear();
      });
    }
  }

  void _removeUser(int index) {
    setState(() {
      _deletedUser = _users[index];
      _deletedUserIndex = index;
      _users.removeAt(index);
    });

    // Show an undo snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_deletedUser!.name} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _users.insert(_deletedUserIndex!, _deletedUser!);
              _deletedUser = null;
              _deletedUserIndex = null;
            });
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _editUser(int index) {
    _userNameController.text = _users[index].name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'User Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
              ),
              DropdownButton<String>(
                value: _users[index].role,
                items: <String>['Member', 'Admin', 'Guest']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _users[index].role = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _users[index].name = _userNameController.text;
                    _userNameController.clear();
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

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user.name),
          content: Text('Role: ${user.role}'),
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

  void _clearSearch() {
    setState(() {
      _searchTerm = '';
    });
  }

  void _sortUsers() {
    setState(() {
      _users.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users
        .where((user) =>
            user.name.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearSearch,
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _sortUsers,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                labelText: 'Search User',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchUser,
            ),
            SizedBox(height: 10),

            // User form to add a new user
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      labelText: 'New User Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: _addUser,
                    child: Text('Add User'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Total Users Display
            Text(
              'Total Users: ${_users.length}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // User List
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              filteredUsers[index].name,
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle:
                                Text('Role: ${filteredUsers[index].role}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.info, color: Colors.green),
                                  onPressed: () =>
                                      _showUserDetails(filteredUsers[index]),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editUser(
                                      _users.indexOf(filteredUsers[index])),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeUser(
                                      _users.indexOf(filteredUsers[index])),
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
}

class User {
  String name;
  String role;

  User({required this.name, required this.role});
}
