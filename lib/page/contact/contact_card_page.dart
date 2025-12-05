import 'package:confetti/confetti.dart';
import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/page/contact/contact_card_empty_page.dart';
import 'package:eventjar/page/contact/contact_card_page_card.dart';
import 'package:eventjar/page/contact/contact_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactCardPage extends StatelessWidget {
  ContactCardPage({super.key});

  final ContactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (controller.state.isLoading.value) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: 3,
              itemBuilder: (context, index) {
                return buildShimmerPlaceholderForContactCard();
              },
            );
          } else if (controller.state.contacts.isEmpty) {
            return buildEmptyStateForContact();
          } else {
            final contacts = controller.state.contacts;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: controller.state.contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return ContactCard(contact: contact, index: index);
              },
            );
          }
        }),

        // if (controller.showConfetti.value)
        // if (true)
        //   Positioned(
        //     top: 0,
        //     left: 0,
        //     right: 0,
        //     child: ConfettiWidget(
        //       confettiController: controller.confettiController,
        //       blastDirectionality: BlastDirectionality.explosive,
        //       blastDirection: 0.5,
        //       emissionFrequency: 0.1, // Higher = more particles
        //       numberOfParticles: 100,
        //       gravity: 0.1,
        //       shouldLoop: false,
        //       colors: [Colors.green, Colors.blue, Colors.yellow, Colors.purple],
        //     ),
        //   ),
        // if (controller.showConfetti.value)
        // if (true)
        //   Center(
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           colors: [Colors.green.shade600, Colors.green.shade800],
        //         ),
        //         borderRadius: BorderRadius.circular(25),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.green.shade400,
        //             blurRadius: 30,
        //             spreadRadius: 5,
        //           ),
        //         ],
        //       ),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Icon(Icons.celebration, color: Colors.white, size: 48),
        //           SizedBox(height: 12),
        //           Text(
        //             'LEAD QUALIFIED! 🎉',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 20,
        //               fontWeight: FontWeight.bold,
        //               letterSpacing: 1,
        //             ),
        //           ),
        //           SizedBox(height: 4),
        //           Text(
        //             'Great job!',
        //             style: TextStyle(color: Colors.white70, fontSize: 14),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
