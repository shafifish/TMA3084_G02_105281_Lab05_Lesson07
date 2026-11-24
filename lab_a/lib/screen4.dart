import 'package:flutter/material.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

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
              backgroundColor: Colors.purple.shade100,
              child: Icon(Icons.school, size: 56, color: Colors.purple.shade700),
            ),
            const SizedBox(height: 24),
            Text(
              'School Screen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Courses, classes and timetable.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(Icons.school),
                title: const Text('Tab 4 of 4'),
                subtitle: const Text('Tapped from the BottomNavigationBar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
