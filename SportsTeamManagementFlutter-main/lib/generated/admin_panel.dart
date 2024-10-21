import 'package:flutter/material.dart';
import 'event_management.dart';
import 'user_management.dart';
import 'schedule_management.dart';

void main() {
  runApp(SportManagementApp());
}

class SportManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sport Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminPanel(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RK UNIVERSITY'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('ADD SPORT EVENT'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('USER MANAGEMENT'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('ADD SCHEDULE'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleManagementPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset('assets/finallogo.png', width: 200, height: 200),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'WELCOME TO SPORT MANAGEMENT SYSTEM',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
