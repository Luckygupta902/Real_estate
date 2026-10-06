import 'package:flutter/material.dart';

class SavedPropertiesScreen extends StatelessWidget {
  const SavedPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Properties'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('3 BHK Apartment'),
            subtitle: Text('Pune - ₹85 Lakh'),
            trailing: Icon(Icons.bookmark),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('2 BHK Flat'),
            subtitle: Text('Mumbai - ₹65 Lakh'),
            trailing: Icon(Icons.bookmark),
          ),
        ],
      ),
    );
  }
}
