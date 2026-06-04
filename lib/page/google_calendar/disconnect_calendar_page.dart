import 'package:eventjar/controller/google_calendar/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class DisconnectCalendarPage extends GetView<GoogleCalendarController> {
  const DisconnectCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final connection = controller.state.connection.value;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.wp, vertical: 3.hp),

      child: Column(
        children: [
          SizedBox(height: 2.hp),

          SvgPicture.asset(
            'assets/expressing-icons/google_calendar_disconnect.svg',
            width: 60.wp,
          ),

          SizedBox(height: 3.5.hp),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.5.hp),

            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(22),

              border: Border.all(color: AppColors.border(context)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.hp),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withValues(alpha: 0.12),
                  ),

                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.green,
                    size: 24.sp,
                  ),
                ),

                SizedBox(height: 2.hp),

                Text(
                  "Google Calendar Connected",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),

                SizedBox(height: 1.hp),

                Text(
                  "Your events can now sync seamlessly with Google Calendar.",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 9.5.sp,
                    height: 1.5,
                  ),
                ),

                if (connection?.email != null) ...[
                  SizedBox(height: 2.5.hp),

                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.symmetric(
                      horizontal: 4.wp,
                      vertical: 1.8.hp,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg(context),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(1.hp),

                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),

                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.red.shade400,
                            size: 18.sp,
                          ),
                        ),

                        SizedBox(width: 3.wp),

                        Expanded(
                          child: Text(
                            connection!.email!,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              color: AppColors.textPrimary(context),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 2.5.hp),

                SizedBox(
                  width: double.infinity,
                  height: 6.hp,

                  child: OutlinedButton.icon(
                    onPressed: controller.disconnectGoogleCalendar,

                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.04),

                      side: BorderSide(
                        color: Colors.red.withValues(alpha: 0.25),
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    icon: Icon(
                      Icons.link_off_rounded,
                      color: Colors.red,
                      size: 18.sp,
                    ),

                    label: Text(
                      "Disconnect Calendar",

                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
