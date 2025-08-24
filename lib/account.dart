import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController ambulanceIdController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Accounts")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, size: 40),
              title: const Text("User"),
              subtitle: const Text("user@example.com"),
              onTap: () {
                // Navigate to profile details
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings, size: 40),
              title: const Text("Settings"),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, size: 40, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                // Handle logout functionality
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Enter Ambulance Unique ID",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ambulanceIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Unique ID",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String ambulanceId = ambulanceIdController.text;
                if (ambulanceId.isNotEmpty) {
                  // Handle ID submission logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ambulance ID: $ambulanceId")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
