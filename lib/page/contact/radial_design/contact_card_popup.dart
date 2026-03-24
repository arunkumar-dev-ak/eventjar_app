import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

// class ContactCardDeletePopup extends StatelessWidget {
//   final String contactName;
//   final VoidCallback onDelete;

//   const ContactCardDeletePopup({
//     super.key,
//     required this.contactName,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Text('Confirm Delete'),
//       content: RichText(
//         text: TextSpan(
//           style: const TextStyle(fontSize: 15, color: Colors.black),
//           children: [
//             const TextSpan(
//               text: 'You are going to delete the contact card of ',
//             ),
//             TextSpan(
//               text: contactName,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const TextSpan(text: '. This cannot be undone.'),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text(
//             'Cancel',
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red.shade700,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(7),
//             ),
//           ),
//           onPressed: () {
//             onDelete();
//             Navigator.of(context).pop(); // Close the dialog after deleting
//           },
//           child: const Text('Delete', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }

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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 90.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                size: 36,
                color: Colors.red.shade500,
              ),
            ),
            SizedBox(height: 1.hp),

            // Title
            Text(
              'Delete Contact',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),

            // Subtitle
            Text(
              'Are you sure you want to delete "$contactName"?',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),

            // Warning message
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone and will permanently delete all contact data.',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.hp),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.grey.shade700,
                      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.wp),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      onDelete(); // Execute delete
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
