import 'package:eventjar/controller/connection/controller.dart';
import 'package:eventjar/model/connection/connection_model.dart';
import 'package:eventjar/page/connection/widget/connection_card.dart';
import 'package:eventjar/page/connection/widget/connection_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionList extends GetView<ConnectionController> {
  const ConnectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSentTab = controller.state.selectedTab.value == 0;

      final List<ConnectionRequest> requests = isSentTab
          ? controller.state.sent.value?.requests ?? const []
          : controller.state.received.value?.requests ?? const [];

      bool haveNextPage = false;

      if (isSentTab) {
        final currentPage = controller.state.sent.value?.page ?? 1;
        final totalPage = controller.state.sent.value?.totalPages ?? 1;
        haveNextPage = currentPage < totalPage;
      } else {
        final currentPage = controller.state.received.value?.page ?? 1;
        final totalPage = controller.state.received.value?.totalPages ?? 1;
        haveNextPage = currentPage < totalPage;
      }

      return ListView.separated(
        controller: isSentTab
            ? controller.sentScrollController
            : controller.receivedScrollController,
        itemCount: haveNextPage ? requests.length + 1 : requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= requests.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: _ConnectionLoadingShimmer(),
            );
          }

          final request = requests[index];

          return ConnectionCard(
            request: request,
            isSentTab: isSentTab,

            onAccept: (id, eventId) => controller.acceptRequest(
              requestId: id,
              eventId: eventId,
              index: index,
              isSent: isSentTab,
            ),

            onReject: (id, eventId) => controller.rejectRequest(
              requestId: id,
              eventId: eventId,
              index: index,
              isSent: isSentTab,
            ),

            onCancel: (id) =>
                controller.cancelRequest(requestId: id, index: index),
          );
        },
      );
    });
  }
}

class _ConnectionLoadingShimmer extends StatelessWidget {
  const _ConnectionLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 1,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => connectionShimmer(),
    );
  }
}
