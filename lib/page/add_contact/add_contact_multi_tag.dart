import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ===============================
/// Add Multi Select Tags Input
/// ===============================
class AddMultiSelectTagsInput extends StatelessWidget {
  AddMultiSelectTagsInput({super.key});

  final AddContactController controller = Get.find();

  void _showTagPopup() {
    Get.bottomSheet(
      const TagSearchPopup(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.wp),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Add Tags Input
          Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: controller.state.isDropDownLoading.value
                  ? null
                  : _showTagPopup,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 2.hp, horizontal: 3.wp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.label_outline, color: Colors.blue),
                    SizedBox(width: 2.wp),
                    Expanded(
                      child: Text(
                        'Add tags',
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ),
                    controller.state.isDropDownLoading.value
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.expand_more),
                  ],
                ),
              ),
            ),
          ),

          // Selected Tags
          Obx(
            () => controller.state.selectedTagsMap.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(top: 2.hp),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: controller.state.selectedTagsMap.values.map((
                        tag,
                      ) {
                        return Chip(
                          label: Text(tag, style: TextStyle(fontSize: 9.sp)),
                          backgroundColor: Colors.blue.shade50,
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            final lowerKey = tag.toLowerCase();
                            controller.state.selectedTagsMap.remove(lowerKey);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class TagSearchPopup extends StatelessWidget {
  const TagSearchPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddContactController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Add Tags',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: Get.back,
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: controller.searchTagsController,
                  autofocus: true,
                  onChanged: controller.filterTags,
                  decoration: InputDecoration(
                    hintText: 'Search or create tag',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // ✅ CREATE NEW TAG SECTION (Always visible when typing)
              Obx(() {
                final searchText = controller.searchTagsController.text.trim();
                final lowerSearch = searchText.toLowerCase();

                final existsInFiltered = controller.state.filteredTags.any(
                  (tag) => tag.toLowerCase() == lowerSearch,
                );
                final existsInSelected = controller.state.selectedTagsMap
                    .containsKey(lowerSearch);

                // ✅ 3 States:
                if (searchText.isEmpty) {
                  return const SizedBox.shrink(); // Hidden
                } else if (existsInFiltered || existsInSelected) {
                  // ✅ ALREADY CREATED - Show feedback
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50, // ✅ Green for success
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '"$searchText" is already created', // ✅ Clear feedback
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // ✅ NEW TAG - Show create
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '"$searchText" is not in the list',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.focusScope?.unfocus();
                            controller.createNewTag(searchText);
                            controller.searchTagsController.clear();
                            controller.filterTags("");
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Create',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),

              // Tags List
              Expanded(
                child: Obx(() {
                  if (controller.state.isDropDownLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final searchText = controller.searchTagsController.text
                      .trim();

                  if (controller.state.filteredTags.isEmpty &&
                      searchText.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.label_outline,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text('No tags found'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: controller.state.filteredTags.length,
                    itemBuilder: (context, index) {
                      final tag = controller.state.filteredTags[index];

                      return Obx(() {
                        final isSelected = controller.state.selectedTagsMap
                            .containsKey(tag.toLowerCase());
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            if (value == true) {
                              controller.selectTag(tag);
                            } else {
                              controller.unSelectTag(tag);
                            }
                          },
                          title: Text(tag),
                          activeColor: Colors.blue.shade700,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
