import 'package:flutter/material.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('ABC Properties'),
            subtitle: const Text(
              'Real Estate Broker',
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text('Following'),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('XYZ Builders'),
            subtitle: const Text(
              'Builder',
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text('Following'),
            ),
          ),
        ],
      ),
    );
  }
}
