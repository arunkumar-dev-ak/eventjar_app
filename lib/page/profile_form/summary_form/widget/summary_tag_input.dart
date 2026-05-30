import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryTagInput extends StatefulWidget {
  final String title;
  final String subtitle;
  final String hintText;
  final RxList<String> items;

  const SummaryTagInput({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hintText,
    required this.items,
  });

  @override
  State<SummaryTagInput> createState() => _SummaryTagInputState();
}

class _SummaryTagInputState extends State<SummaryTagInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  void _addTag() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (widget.items.any((t) => t.toLowerCase() == text.toLowerCase())) return;
    widget.items.add(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 0.5.hp),
        Text(
          widget.subtitle,
          style: TextStyle(
            fontSize: 8.5.sp,
            color: AppColors.textSecondary(context),
          ),
        ),
        SizedBox(height: 1.5.hp),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addTag(),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textPrimary(context),
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.textHint(context),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.wp,
                    vertical: 1.2.hp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.gradientDarkStart,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.inputBg(context),
                ),
              ),
            ),
            SizedBox(width: 2.wp),
            GestureDetector(
              onTap: _addTag,
              child: Container(
                padding: EdgeInsets.all(1.2.hp),
                decoration: BoxDecoration(
                  color: AppColors.gradientDarkStart,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.hp),
        Obx(
          () => widget.items.isEmpty
              ? const SizedBox.shrink()
              : Wrap(
                  spacing: 2.wp,
                  runSpacing: 1.hp,
                  children: widget.items
                      .map(
                        (item) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.wp,
                            vertical: 0.7.hp,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gradientDarkStart.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.gradientDarkStart.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 8.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gradientDarkStart,
                                ),
                              ),
                              SizedBox(width: 1.wp),
                              GestureDetector(
                                onTap: () => widget.items.remove(item),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: AppColors.gradientDarkStart,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}
