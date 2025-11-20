import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildEmptyStateForContact() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.contact_page, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'No contacts found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          // Text(
          //   'Add your contacts to get started or import from Google or Mobile.',
          //   style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          //   textAlign: TextAlign.center,
          // ),
          // const SizedBox(height: 30),
          // ElevatedButton.icon(
          //   onPressed: () {
          //     // controller.navigateToAddContact();
          //   },
          //   icon: const Icon(Icons.person_add),
          //   label: const Text('Add Contact'),
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          //   ),
          // ),
        ],
      ),
    ),
  );
}
