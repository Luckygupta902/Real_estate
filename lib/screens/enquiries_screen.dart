import 'package:flutter/material.dart';

class EnquiriesScreen extends StatelessWidget {
  const EnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquiries / Leads'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Rahul Sharma'),
            subtitle: Text(
              'Interested in 3 BHK Apartment',
            ),
            trailing: Icon(Icons.phone),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Priya Singh'),
            subtitle: Text(
              'Interested in Luxury Villa',
            ),
            trailing: Icon(Icons.phone),
          ),
        ],
      ),
    );
  }
}
