import 'package:eventjar/controller/event_info/controller.dart';
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

  int _currentIndex = 0;
  bool _searchExpanded = false;
  Offset _dragOffset = Offset.zero;
  double? _frontCardHeight;
  List<EventAttendee> _currentAttendees = [];
  final GlobalKey _frontCardKey = GlobalKey();

  late AnimationController _snapBackController;
  late Animation<Offset> _snapBackAnim;
  late Worker _searchWorker;

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

    _searchWorker = ever(controller.state.searchText, (_) {
      if (mounted) setState(() => _currentIndex = 0);
    });
  }

  @override
  void dispose() {
    _snapBackController.dispose();
    _searchWorker.dispose();
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

  void _exitCard(List<EventAttendee> attendees) {
    final isSwipeLeft = _dragOffset.dx < 0;

    // At boundaries: snap back instead of advancing
    final atLast = isSwipeLeft && _currentIndex >= attendees.length - 1;
    final atFirst = !isSwipeLeft && _currentIndex <= 0;
    if (atLast || atFirst) {
      _snapBack();
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
        setState(() {
          _currentIndex = isSwipeLeft ? _currentIndex + 1 : _currentIndex - 1;
          _dragOffset = Offset.zero;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final attendeeState = controller.state.attendeeList.value;
      final isLoading = controller.state.attendeeListLoading.value;
      final searchText = controller.state.searchText.value.toLowerCase().trim();

      if (isLoading) {
        return Center(child: buildAttendeeListShimmer());
      }

      if (attendeeState == null || attendeeState.attendees.isEmpty) {
        return Center(
          child: Text(
            "No attendees found.",
            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
          ),
        );
      }

      final filteredAttendees = searchText.isEmpty
          ? attendeeState.attendees
          : attendeeState.attendees.where((a) {
              final name = a.name.toLowerCase();
              final company = (a.company ?? '').toLowerCase();
              return name.contains(searchText) || company.contains(searchText);
            }).toList();

      return _buildSwipeStack(filteredAttendees);
    });
  }

  // ─── All seen ──────────────────────────────────────────────────────────────

  // ─── Card stack ────────────────────────────────────────────────────────────

  Widget _buildSwipeStack(List<EventAttendee> attendees) {
    _currentAttendees = attendees;
    return Column(
      children: [
        // Search + Counter row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 0.5.hp),
          child: Row(
            children: [
              if (_searchExpanded) ...[
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
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
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      onChanged: (val) =>
                          controller.state.searchText.value = val,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () {
                    setState(() => _searchExpanded = false);
                    controller.searchController.clear();
                    controller.state.searchText.value = "";
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ] else ...[
                Text(
                  "${_currentIndex + 1} of ${attendees.length}",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 13,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 8.5.sp,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 3.wp),
                GestureDetector(
                  onTap: () => setState(() => _searchExpanded = true),
                  child: Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: Colors.grey.shade700,
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
            child: Text(
              "No attendees match your search.",
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
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

          // Stacked cards — back cards peek out to the RIGHT
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topLeft,
            children: [
              // depth-2: furthest back (green), shifted right most
              if (_currentIndex + 2 < attendees.length)
                Transform.translate(
                  offset: const Offset(20, 0),
                  child: _buildBackCard(const Color(0xFF43A047)),
                ),
              // depth-1: middle back (indigo), shifted right
              if (_currentIndex + 1 < attendees.length)
                Transform.translate(
                  offset: const Offset(10, 0),
                  child: _buildBackCard(const Color(0xFF5C6BC0)),
                ),
              // Front card — draggable with snap-back animation
              _buildFrontCard(attendees[_currentIndex]),
            ],
          ),
        ],

        if (attendees.isNotEmpty) ...[
          SizedBox(height: 1.2.hp),

          // Swipe hint
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 11,
                color: Colors.grey.shade400,
              ),
              SizedBox(width: 1.wp),
              Text(
                "Swipe left for next",
                style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade400),
              ),
              SizedBox(width: 2.wp),
              Container(width: 1, height: 10, color: Colors.grey.shade300),
              SizedBox(width: 2.wp),
              Text(
                "Swipe right for previous",
                style: TextStyle(fontSize: 8.sp, color: Colors.grey.shade400),
              ),
              SizedBox(width: 1.wp),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: Colors.grey.shade400,
              ),
            ],
          ),

          SizedBox(height: 0.8.hp),
        ],
      ],
    );
  }

  // Solid colored placeholder card for the stack depth effect
  Widget _buildBackCard(Color color) {
    return Container(
      height: _frontCardHeight,
      margin: EdgeInsets.only(right: 8.wp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(EventAttendee attendee) {
    final Offset offset = _snapBackController.isAnimating
        ? _snapBackAnim.value
        : _dragOffset;
    // Subtle tilt while dragging
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

  // ─── Card widget ───────────────────────────────────────────────────────────

  Widget _buildCard(EventAttendee attendee) {
    return Container(
      key: _frontCardKey,
      margin: EdgeInsets.only(right: 8.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Row 1: Avatar + Info ──
          Padding(
            padding: EdgeInsets.all(3.wp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage:
                      (attendee.avatarUrl != null &&
                          attendee.avatarUrl!.isNotEmpty)
                      ? NetworkImage(getFileUrl(attendee.avatarUrl!))
                      : null,
                  child:
                      (attendee.avatarUrl == null ||
                          attendee.avatarUrl!.isEmpty)
                      ? Text(
                          attendee.name.isNotEmpty
                              ? attendee.name[0].toUpperCase()
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

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendee.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5.sp,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_positionText(attendee).isNotEmpty) ...[
                        SizedBox(height: 0.3.hp),
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline_rounded,
                              size: 11,
                              color: Colors.blue.shade400,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                _positionText(attendee),
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (attendee.location?.isNotEmpty == true) ...[
                        SizedBox(height: 0.3.hp),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 11,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                attendee.location!,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.black45,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (attendee.bio?.isNotEmpty == true) ...[
                        SizedBox(height: 0.4.hp),
                        Text(
                          attendee.bio!,
                          style: TextStyle(
                            fontSize: 7.5.sp,
                            color: Colors.grey.shade600,
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

          // ── Row 2: Action button ──
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
            child: Obx(() {
              final buttonState = controller.getDynamicButtonState(attendee);
              final text = buttonState['text'] as String;
              final colorType = buttonState['color'] as String;
              final isActionable =
                  text == 'Send Meeting Request' || text == 'Send Request';

              if (isActionable) {
                return ConnectionAttendeeListCustomSendButton(
                  label: "Send Meeting Request",
                  attendeeId: attendee.id,
                  onPressed: () =>
                      controller.sendMeetingRequest(attendee.id, attendee.name),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_statusBadge(text: text, colorType: colorType)],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _positionText(EventAttendee attendee) {
    final pos = attendee.position ?? '';
    final co = attendee.company ?? '';
    if (pos.isNotEmpty && co.isNotEmpty) return '$pos at $co';
    if (pos.isNotEmpty) return pos;
    return co;
  }
}

// ─── Status badge ─────────────────────────────────────────────────────────────

Widget _statusBadge({required String text, required String colorType}) {
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
