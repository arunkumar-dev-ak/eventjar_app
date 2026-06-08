import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/page/home/widget/scorecard/networking_scorecard.dart';
import 'package:eventjar/page/home/widget/scorecard/verification_scorecard.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../global/glitter.dart';

class HomeProfile extends GetView<HomeController> {
  const HomeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = controller.isLoggedIn.value;
      final isLoading = controller.state.isLoading.value;
      final profileData = controller.state.userProfile.value;
      if (!isLoggedIn) return _buildSignInCard();
      if (isLoading || profileData == null) {
        return _buildShimmerProfile();
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Profile Card Background with Glitter
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,
              margin: EdgeInsets.only(
                bottom:
                    controller.allStepsComplete && controller.scoreCardExpanded
                    ? (9.hp + (4 * 6.5.hp) + 1) - 9.hp + 3.7.hp
                    : 3.7.hp,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [
                          const Color(0xFF1A2A3A),
                          const Color(0xFF1E3450),
                          const Color(0xFF223E5A),
                        ]
                      : [
                          const Color(0xFFE3F2FD),
                          const Color(0xFFBBDEFB),
                          const Color(0xFF90CAF9),
                        ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: GlitterPainter()),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.wp, 1.hp, 3.wp, 1.hp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: profileData.avatarUrl == null
                                    ? Image.asset(
                                        'assets/king.png',
                                        width: 24.wp,
                                        height: 28.wp,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        getFileUrl(profileData.avatarUrl!),
                                        width: 30.wp,
                                        height: 30.wp,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(width: 4.wp),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            capitalizeName(
                                              profileData.name.toString(),
                                            ),
                                            style: TextStyle(
                                              color: AppColors.textPrimary(
                                                context,
                                              ),
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final username =
                                                UserStore.to.profile['username']
                                                    ?.toString() ??
                                                '';
                                            if (username.isNotEmpty) {
                                              SharePlus.instance.share(
                                                ShareParams(
                                                  text:
                                                      'https://myeventjar.com/members/$username',
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(1.5.wp),
                                            decoration: BoxDecoration(
                                              color: AppColors.textPrimary(
                                                context,
                                              ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.share_rounded,
                                              size: 18,
                                              color:
                                                  Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : AppColors.gradientDarkStart,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.hp),
                                    Text(
                                      profileData.email!,
                                      style: TextStyle(
                                        color: AppColors.textSecondary(context),
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 1.hp),
                                    Text(
                                      profileData.phone ?? "Yet to add",
                                      style: TextStyle(
                                        color: AppColors.textSecondary(context),
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                    if (profileData.phoneParsed?.countryCode !=
                                        null) ...[
                                      SizedBox(height: 0.8.hp),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: _AnimatedFlag(
                                          countryCode: profileData
                                              .phoneParsed!
                                              .countryCode,
                                        ),
                                      ),
                                    ],
                                    //SizedBox(height: 1.hp),
                                    //_buildBadgeMedals(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.5.hp),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating Networking Score Card
            Positioned(
              left: 2.5.wp,
              right: 2.5.wp,
              bottom: 0.7.hp,
              child: _buildNetworkingScoreCard(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSignInCard() {
    return GestureDetector(
      onTap: () {
        HapticHelper.light();
        Get.toNamed(RouteName.signInPage);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.hp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1565C0).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.wp),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 7.wp,
              ),
            ),
            SizedBox(width: 4.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'sign_in_or_sign_up'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.5.hp),
                  Text(
                    'access_profile_events_contacts'.tr,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 7.5.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 4.5.wp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerProfile() {
    return Shimmer.fromColors(
      baseColor: AppColors.borderStatic,
      highlightColor: AppColors.chipBgStatic,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.fromLTRB(3.wp, 1.hp, 3.wp, 1.hp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 24.wp,
                    height: 28.wp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  SizedBox(width: 4.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.wp,
                          height: 1.7.hp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 0.8.hp),
                        Container(
                          width: 30.wp,
                          height: 1.2.hp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 0.6.hp),
                        Container(
                          width: 25.wp,
                          height: 1.2.hp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.hp),
                        Row(
                          children: List.generate(
                            6,
                            (_) => Padding(
                              padding: EdgeInsets.only(right: 0.5.wp),
                              child: Container(
                                width: 5.5.wp,
                                height: 5.5.wp,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.5.hp),
            Container(
              width: double.infinity,
              height: 9.hp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkingScoreCard() {
    if (controller.allStepsComplete) {
      // return _buildNetworkScoreCard();
      return buildNetworkScoreCard();
    }
    // return _buildVerificationScoreCard();
    return buildVerificationScoreCard();
  }
}

class _AnimatedFlag extends StatefulWidget {
  final String countryCode;

  const _AnimatedFlag({required this.countryCode});

  @override
  State<_AnimatedFlag> createState() => _AnimatedFlagState();
}

class _AnimatedFlagState extends State<_AnimatedFlag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flag = _dialCodeToFlag(widget.countryCode);
    if (flag == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Colors.transparent,
                Colors.white70,
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 2.0 * _shimmerController.value, -0.3),
              end: Alignment(0.0 + 2.0 * _shimmerController.value, 0.3),
            ).createShader(bounds);
          },
          child: child!,
        );
      },
      child: Text(flag, style: TextStyle(fontSize: 14.sp)),
    );
  }

  static String? _dialCodeToFlag(String dialCode) {
    final code = dialCode.replaceAll('+', '').trim();
    final iso = _dialCodeToIso[code];
    if (iso == null || iso.length != 2) return null;

    // Convert ISO 3166-1 alpha-2 to flag emoji
    final flagOffset = 0x1F1E6;
    final asciiOffset = 0x41;
    final first = iso.codeUnitAt(0) - asciiOffset + flagOffset;
    final second = iso.codeUnitAt(1) - asciiOffset + flagOffset;
    return String.fromCharCodes([first, second]);
  }

  static const _dialCodeToIso = {
    '1': 'US',
    '7': 'RU',
    '20': 'EG',
    '27': 'ZA',
    '30': 'GR',
    '31': 'NL',
    '32': 'BE',
    '33': 'FR',
    '34': 'ES',
    '36': 'HU',
    '39': 'IT',
    '40': 'RO',
    '41': 'CH',
    '43': 'AT',
    '44': 'GB',
    '45': 'DK',
    '46': 'SE',
    '47': 'NO',
    '48': 'PL',
    '49': 'DE',
    '51': 'PE',
    '52': 'MX',
    '53': 'CU',
    '54': 'AR',
    '55': 'BR',
    '56': 'CL',
    '57': 'CO',
    '58': 'VE',
    '60': 'MY',
    '61': 'AU',
    '62': 'ID',
    '63': 'PH',
    '64': 'NZ',
    '65': 'SG',
    '66': 'TH',
    '81': 'JP',
    '82': 'KR',
    '84': 'VN',
    '86': 'CN',
    '90': 'TR',
    '91': 'IN',
    '92': 'PK',
    '93': 'AF',
    '94': 'LK',
    '95': 'MM',
    '98': 'IR',
    '211': 'SS',
    '212': 'MA',
    '213': 'DZ',
    '216': 'TN',
    '218': 'LY',
    '220': 'GM',
    '221': 'SN',
    '222': 'MR',
    '223': 'ML',
    '224': 'GN',
    '225': 'CI',
    '226': 'BF',
    '227': 'NE',
    '228': 'TG',
    '229': 'BJ',
    '230': 'MU',
    '231': 'LR',
    '232': 'SL',
    '233': 'GH',
    '234': 'NG',
    '235': 'TD',
    '236': 'CF',
    '237': 'CM',
    '238': 'CV',
    '239': 'ST',
    '240': 'GQ',
    '241': 'GA',
    '242': 'CG',
    '243': 'CD',
    '244': 'AO',
    '245': 'GW',
    '246': 'IO',
    '247': 'AC',
    '248': 'SC',
    '249': 'SD',
    '250': 'RW',
    '251': 'ET',
    '252': 'SO',
    '253': 'DJ',
    '254': 'KE',
    '255': 'TZ',
    '256': 'UG',
    '257': 'BI',
    '258': 'MZ',
    '260': 'ZM',
    '261': 'MG',
    '262': 'RE',
    '263': 'ZW',
    '264': 'NA',
    '265': 'MW',
    '266': 'LS',
    '267': 'BW',
    '268': 'SZ',
    '269': 'KM',
    '290': 'SH',
    '291': 'ER',
    '297': 'AW',
    '298': 'FO',
    '299': 'GL',
    '350': 'GI',
    '351': 'PT',
    '352': 'LU',
    '353': 'IE',
    '354': 'IS',
    '355': 'AL',
    '356': 'MT',
    '357': 'CY',
    '358': 'FI',
    '359': 'BG',
    '370': 'LT',
    '371': 'LV',
    '372': 'EE',
    '373': 'MD',
    '374': 'AM',
    '375': 'BY',
    '376': 'AD',
    '377': 'MC',
    '378': 'SM',
    '380': 'UA',
    '381': 'RS',
    '382': 'ME',
    '385': 'HR',
    '386': 'SI',
    '387': 'BA',
    '389': 'MK',
    '420': 'CZ',
    '421': 'SK',
    '423': 'LI',
    '500': 'FK',
    '501': 'BZ',
    '502': 'GT',
    '503': 'SV',
    '504': 'HN',
    '505': 'NI',
    '506': 'CR',
    '507': 'PA',
    '508': 'PM',
    '509': 'HT',
    '590': 'GP',
    '591': 'BO',
    '592': 'GY',
    '593': 'EC',
    '594': 'GF',
    '595': 'PY',
    '596': 'MQ',
    '597': 'SR',
    '598': 'UY',
    '599': 'CW',
    '670': 'TL',
    '672': 'NF',
    '673': 'BN',
    '674': 'NR',
    '675': 'PG',
    '676': 'TO',
    '677': 'SB',
    '678': 'VU',
    '679': 'FJ',
    '680': 'PW',
    '681': 'WF',
    '682': 'CK',
    '683': 'NU',
    '685': 'WS',
    '686': 'KI',
    '687': 'NC',
    '688': 'TV',
    '689': 'PF',
    '690': 'TK',
    '691': 'FM',
    '692': 'MH',
    '850': 'KP',
    '852': 'HK',
    '853': 'MO',
    '855': 'KH',
    '856': 'LA',
    '880': 'BD',
    '886': 'TW',
    '960': 'MV',
    '961': 'LB',
    '962': 'JO',
    '963': 'SY',
    '964': 'IQ',
    '965': 'KW',
    '966': 'SA',
    '967': 'YE',
    '968': 'OM',
    '970': 'PS',
    '971': 'AE',
    '972': 'IL',
    '973': 'BH',
    '974': 'QA',
    '975': 'BT',
    '976': 'MN',
    '977': 'NP',
    '992': 'TJ',
    '993': 'TM',
    '994': 'AZ',
    '995': 'GE',
    '996': 'KG',
    '998': 'UZ',
  };
}
