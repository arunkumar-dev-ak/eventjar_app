import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget userProfileBuildSecurity() {
  return Column(
    children: [
      // Change Password
      InkWell(
        onTap: () {
          // Navigate to change password
        },
        child: Container(
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.blue.shade700),
              SizedBox(width: 3.wp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    Text(
                      "Update your password regularly",
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 2.hp),

      // Session Management
      Container(
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.devices, color: Colors.orange.shade700),
                SizedBox(width: 3.wp),
                Text(
                  "Active Sessions",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.hp),
            Text(
              "Manage your active sessions",
              style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade700),
            ),
            SizedBox(height: 2.hp),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.logout, size: 16),
                label: Text("Sign Out All Sessions"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
