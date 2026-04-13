import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/model/event_info/event_attendee_model.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_list_meeting_req_button.dart';
import 'package:eventjar/page/event_info/tabs/connection/connection_attendee_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionAttendeeList extends StatefulWidget {
  const ConnectionAttendeeList({super.key});

  @override
  State<ConnectionAttendeeList> createState() => _ConnectionAttendeeListState();
}

class _ConnectionAttendeeListState extends State<ConnectionAttendeeList>
    with SingleTickerProviderStateMixin {
  final EventInfoController controller = Get.find();

  // Animation-only local state (needs setState for AnimationController)
  Offset _dragOffset = Offset.zero;
  double? _frontCardHeight;
  List<Attendee> _currentAttendees = [];
  final GlobalKey _frontCardKey = GlobalKey();

  late AnimationController _snapBackController;
  late Animation<Offset> _snapBackAnim;

  @override
  void initState() {
    super.initState();
    _snapBackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() => setState(() {}));

    _snapBackAnim = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _snapBackController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _snapBackController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_snapBackController.isAnimating) return;
    setState(() => _dragOffset += details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    const threshold = 80.0;
    if (_dragOffset.dx.abs() > threshold) {
      _exitCard(_currentAttendees);
    } else {
      _snapBack();
    }
  }

  void _snapBack() {
    _snapBackAnim = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _snapBackController, curve: Curves.elasticOut),
    );
    _snapBackController.forward(from: 0).then((_) {
      setState(() => _dragOffset = Offset.zero);
    });
  }

  void _measureFrontCard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box =
          _frontCardKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;
      final h = box.size.height;
      if (h != _frontCardHeight) setState(() => _frontCardHeight = h);
    });
  }

  void _exitCard(List<Attendee> attendees) {
    final currentIndex = controller.state.attendeeCurrentIndex.value;
    final isSwipeLeft = _dragOffset.dx < 0;

    final atLast = isSwipeLeft && currentIndex >= attendees.length - 1;
    final atFirst = !isSwipeLeft && currentIndex <= 0;
    if (atLast || atFirst) {
      _snapBack();
      if (atLast) controller.loadMoreAttendees();
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final direction = isSwipeLeft ? -1.0 : 1.0;

    _snapBackAnim =
        Tween<Offset>(
          begin: _dragOffset,
          end: Offset(direction * screenWidth * 1.5, _dragOffset.dy * 0.5),
        ).animate(
          CurvedAnimation(parent: _snapBackController, curve: Curves.easeOut),
        );

    _snapBackController.forward(from: 0).then((_) {
      if (mounted) {
        final nextIndex = isSwipeLeft ? currentIndex + 1 : currentIndex - 1;
        controller.state.attendeeCurrentIndex.value = nextIndex;
        setState(() => _dragOffset = Offset.zero);
        if (isSwipeLeft && nextIndex >= attendees.length - 2) {
          controller.loadMoreAttendees();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status filter tabs — always visible
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 0.5.hp),
          child: Obx(() {
            final selected = controller.state.attendeeStatusFilter.value;
            return Row(
              children: [
                _buildFilterChip('All', '', selected),
                SizedBox(width: 2.wp),
                _buildFilterChip('Sent', 'sent', selected),
                SizedBox(width: 2.wp),
                _buildFilterChip('Received', 'received', selected),
              ],
            );
          }),
        ),

        // Content
        Obx(() {
          final attendeeState = controller.state.attendeeList.value;
          final isLoading = controller.state.attendeeListLoading.value;
          final isClearing = controller.state.attendeeSearchClearing.value;

          if (isLoading || isClearing) {
            if (isClearing && isLoading) {
              controller.state.attendeeSearchClearing.value = false;
            }
            return buildAttendeeListShimmer();
          }

          final allAttendees = attendeeState?.attendee ?? [];
          final totalCount =
              attendeeState?.meta?.paging?.totalCount ?? allAttendees.length;

          final isSearching =
              controller.state.attendeeSearchExpanded.value ||
              controller.state.searchText.value.isNotEmpty;
          final hasFilter =
              controller.state.attendeeStatusFilter.value.isNotEmpty;

          if ((attendeeState == null || allAttendees.isEmpty) &&
              !isSearching &&
              !hasFilter) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.hp),
              child: Text(
                "No attendees found.",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textHint(context),
                ),
              ),
            );
          }

          return _buildSwipeStack(allAttendees, totalCount);
        }),
      ],
    );
  }

  Widget _buildSwipeStack(List<Attendee> attendees, int totalCount) {
    _currentAttendees = attendees;
    return Obx(() {
      var currentIndex = controller.state.attendeeCurrentIndex.value;
      final searchExpanded = controller.state.attendeeSearchExpanded.value;

      // Safety: clamp index within bounds
      if (attendees.isNotEmpty && currentIndex >= attendees.length) {
        currentIndex = attendees.length - 1;
        controller.state.attendeeCurrentIndex.value = currentIndex;
      }

      return Column(
        children: [
          // Search + Counter row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 0.5.hp),
            child: Row(
              children: [
                if (searchExpanded) ...[
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blueAccent, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow(context),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        autofocus: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: "Search name or company",
                          border: InputBorder.none,
                          isCollapsed: true,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 18,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary(context),
                        ),
                        onChanged: (val) {
                          controller.state.searchText.value = val;
                          controller.onSearchChanged(val);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.textHint(context),
                    ),
                    onPressed: () => controller.closeAttendeeSearch(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ] else ...[
                  Text(
                    "${currentIndex + 1} of $totalCount",
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.textHint(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => controller.resetAttendeeIndex(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 13,
                          color: AppColors.iconMuted(context),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: AppColors.iconMuted(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 3.wp),
                  GestureDetector(
                    onTap: () => controller.expandAttendeeSearch(),
                    child: Icon(
                      Icons.search_rounded,
                      size: 22,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 1.hp),

          if (attendees.isEmpty) ...[
            SizedBox(height: 4.hp),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 40,
                    color: AppColors.iconMuted(context),
                  ),
                  SizedBox(height: 1.hp),
                  Text(
                    searchExpanded
                        ? "No attendees match your search."
                        : "No attendees found.",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textHint(context),
                    ),
                  ),
                  if (searchExpanded) ...[
                    SizedBox(height: 2.hp),
                    TextButton.icon(
                      onPressed: () => controller.closeAttendeeSearch(),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text("Clear search"),
                    ),
                  ],
                  if (!searchExpanded &&
                      controller.state.attendeeStatusFilter.value.isNotEmpty) ...[
                    SizedBox(height: 2.hp),
                    TextButton.icon(
                      onPressed: () => controller.onStatusFilterChanged(''),
                      icon: const Icon(Icons.filter_alt_off, size: 16),
                      label: const Text("Show all attendees"),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // Measure front card height so back cards match
            Builder(
              builder: (_) {
                _measureFrontCard();
                return const SizedBox.shrink();
              },
            ),

            // Stacked cards
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                if (currentIndex + 2 < attendees.length)
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: Transform.scale(
                      scaleX: 0.84,
                      child: _buildBackCard(
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1A2A3A)
                            : const Color(0xFFBBDEFB),
                      ),
                    ),
                  ),
                if (currentIndex + 1 < attendees.length)
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Transform.scale(
                      scaleX: 0.92,
                      child: _buildBackCard(
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1E3450)
                            : const Color(0xFF90CAF9),
                      ),
                    ),
                  ),
                _buildFrontCard(attendees[currentIndex]),
              ],
            ),
          ],

          if (attendees.isNotEmpty) ...[
            SizedBox(height: 3.hp),

            // Swipe hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 11,
                  color: AppColors.iconMuted(context),
                ),
                SizedBox(width: 1.wp),
                Text(
                  "Swipe left for next",
                  style: TextStyle(fontSize: 8.sp, color: AppColors.iconMuted(context)),
                ),
                SizedBox(width: 2.wp),
                Container(width: 1, height: 10, color: AppColors.border(context)),
                SizedBox(width: 2.wp),
                Text(
                  "Swipe right for previous",
                  style: TextStyle(fontSize: 8.sp, color: AppColors.iconMuted(context)),
                ),
                SizedBox(width: 1.wp),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: AppColors.iconMuted(context),
                ),
              ],
            ),

            SizedBox(height: 0.8.hp),
          ],
        ],
      );
    });
  }

  Widget _buildFilterChip(String label, String value, String selected) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => controller.onStatusFilterChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.buttonGradient : null,
          color: isSelected ? null : AppColors.chipBg(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.border(context),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppColors.textPrimary(context),
          ),
        ),
      ),
    );
  }

  // Solid colored placeholder card for the stack depth effect
  Widget _buildBackCard(Color color) {
    return Container(
      height: _frontCardHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(Attendee attendee) {
    final Offset offset = _snapBackController.isAnimating
        ? _snapBackAnim.value
        : _dragOffset;
    final rotation = offset.dx / 2000;
    final bool isAnimating = _snapBackController.isAnimating;

    return GestureDetector(
      onPanUpdate: isAnimating ? null : _onPanUpdate,
      onPanEnd: isAnimating ? null : _onPanEnd,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(angle: rotation, child: _buildCard(attendee)),
      ),
    );
  }

  Widget _buildCard(Attendee attendee) {
    final positionText = _positionText(attendee);
    final locationText = attendee.location?.toString() ?? '';
    final bioText = attendee.bio?.toString() ?? '';

    return Container(
      key: _frontCardKey,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [const Color(0xFF1E2A3A), const Color(0xFF222E3E)]
              : [const Color(0xFFEEF4FF), const Color(0xFFF8FBFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage:
                      (attendee.avatarUrl != null &&
                          attendee.avatarUrl.toString().isNotEmpty)
                      ? NetworkImage(getFileUrl(attendee.avatarUrl.toString()))
                      : null,
                  child:
                      (attendee.avatarUrl == null ||
                          attendee.avatarUrl.toString().isEmpty)
                      ? Text(
                          (attendee.name?.isNotEmpty ?? false)
                              ? attendee.name![0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue.shade700,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              attendee.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                                color: AppColors.textPrimary(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.4.hp),
                      _infoRow(
                        icon: Icons.work_outline_rounded,
                        iconColor: positionText.isNotEmpty
                            ? Colors.blue.shade400
                            : AppColors.border(context),
                        text: positionText.isNotEmpty
                            ? positionText
                            : "No job title added",
                        isEmpty: positionText.isEmpty,
                      ),
                      SizedBox(height: 0.3.hp),
                      _infoRow(
                        icon: Icons.location_on_outlined,
                        iconColor: locationText.isNotEmpty
                            ? Colors.red.shade300
                            : AppColors.border(context),
                        text: locationText.isNotEmpty
                            ? locationText
                            : "No location added",
                        isEmpty: locationText.isEmpty,
                      ),
                      if (bioText.isNotEmpty) ...[
                        SizedBox(height: 0.4.hp),
                        Text(
                          bioText,
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: AppColors.textSecondary(context),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider(context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.2.hp),
            child: Obx(() {
              final buttonState = controller.getDynamicButtonState(attendee);
              final text = buttonState['text'] as String;
              final colorType = buttonState['color'] as String;
              final isDisabled = buttonState['disabled'] as bool;
              final isSendable = text == 'Send Request';

              if (isSendable) {
                return ConnectionAttendeeListCustomSendButton(
                  label: "Send Request",
                  attendeeId: attendee.id ?? '',
                  onPressed: () => controller.sendMeetingRequest(
                    attendee.id ?? '',
                    attendee.name ?? '',
                  ),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _statusBadge(
                    text: text,
                    colorType: colorType,
                    disabled: isDisabled,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required bool isEmpty,
  }) {
    return Row(
      children: [
        Icon(icon, size: 12, color: iconColor),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 8.5.sp,
              color: isEmpty ? AppColors.iconMuted(context) : AppColors.textSecondary(context),
              fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
              fontWeight: isEmpty ? FontWeight.normal : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _positionText(Attendee attendee) {
    final pos = attendee.jobTitle?.toString() ?? '';
    final co = attendee.company?.toString() ?? '';
    if (pos.isNotEmpty && co.isNotEmpty) return '$pos at $co';
    if (pos.isNotEmpty) return pos;
    return co;
  }

  Widget _statusBadge({
    required String text,
    required String colorType,
    bool disabled = false,
  }) {
    final colors = _badgeColors(colorType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 7.5.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  List<Color> _badgeColors(String colorType) {
    switch (colorType) {
      case 'yellow':
        return [Colors.amber.shade400, Colors.amber.shade600];
      case 'green':
        return [const Color(0xFF4CAF50), const Color(0xFF45A049)];
      case 'blue':
        return [Colors.blue.shade400, Colors.blue.shade600];
      case 'orange':
        return [Colors.orange.shade400, Colors.orange.shade700];
      case 'grey':
      default:
        return [Colors.grey.shade400, Colors.grey.shade500];
    }
  }
}
