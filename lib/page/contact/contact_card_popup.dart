import 'package:flutter/material.dart';

class ContactCardDeletePopup extends StatelessWidget {
  final String contactName;
  final VoidCallback onDelete;

  const ContactCardDeletePopup({
    super.key,
    required this.contactName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Confirm Delete'),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black),
          children: [
            const TextSpan(
              text: 'You are going to delete the contact card of ',
            ),
            TextSpan(
              text: contactName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '. This cannot be undone.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          onPressed: () {
            onDelete();
            Navigator.of(context).pop(); // Close the dialog after deleting
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
