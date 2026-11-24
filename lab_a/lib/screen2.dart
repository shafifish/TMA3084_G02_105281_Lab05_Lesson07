import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.orange.shade100,
              child: Icon(Icons.alarm, size: 56, color: Colors.orange.shade700),
            ),
            const SizedBox(height: 24),
            Text(
              'Alarm Screen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Alarms and reminders you have set.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(Icons.alarm),
                title: const Text('Tab 2 of 4'),
                subtitle: const Text('Tapped from the BottomNavigationBar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
