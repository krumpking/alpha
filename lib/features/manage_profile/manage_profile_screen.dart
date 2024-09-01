import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Documents', 'Assigned Shifts', 'Notes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NAME',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('TITLE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedIndex == index ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: _selectedIndex == index ? Colors.blue : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDocumentsTab();
      case 1:
        return _buildAssignedShiftsTab();
      case 2:
        return _buildNotesTab();
      default:
        return Container();
    }
  }

  Widget _buildDocumentsTab() {
    List<Map<String, dynamic>> documents = [
      {'name': 'Name of Document', 'type': 'Type of Document', 'expiryDate': DateTime(2023, 7, 10), 'status': 'Expired'},
      {'name': 'Name of Document', 'type': 'Type of Document', 'expiryDate': DateTime(2023, 9, 1), 'status': 'Close to due'},
      {'name': 'Name of Document', 'type': 'Type of Document', 'expiryDate': DateTime(2023, 10, 10), 'status': 'Still valid'},
    ];

    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        var document = documents[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(document['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                Text(document['type']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Expiry Date: ${DateFormat('dd MMM yyyy').format(document['expiryDate'])}'),
                    _buildStatusChip(document['status']),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Expired':
        color = Colors.red;
        break;
      case 'Close to due':
        color = Colors.orange;
        break;
      case 'Still valid':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(status),
      backgroundColor: color,
      labelStyle: TextStyle(color: Colors.white),
    );
  }

  Widget _buildAssignedShiftsTab() {
    return Column(
      children: [
        _buildPreferredWorkDays(),
        _buildAddressInfo(),
        _buildFeedbackSection(),
      ],
    );
  }

  Widget _buildPreferredWorkDays() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferred work days', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Flexible/Night'),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Monday')),
                Chip(label: Text('Tuesday')),
                Chip(label: Text('Wednesday')),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text('Add/Remove'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfo() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Number:'),
            Text('Main Employer'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Name of hospital'),
            Text('Completed shift: Time of shift'),
            TextButton(
              onPressed: () {},
              child: Text('Show'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesTab() {
    return Center(
      child: Text('Notes content goes here'),
    );
  }
}