import 'package:flutter/material.dart';

class AddContactView extends StatelessWidget {
  const AddContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Implement your add contact logic
        },
        child: Text("Add Contact"),
      ),
    );
  }
}
