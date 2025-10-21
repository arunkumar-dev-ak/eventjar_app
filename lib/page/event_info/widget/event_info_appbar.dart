import 'package:eventjar_app/page/event_info/widget/event_info_back_button.dart';
import 'package:flutter/material.dart';

class EventInfoAppBar extends StatelessWidget {
  const EventInfoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            // "https://www.shutterstock.com/image-photo/black-white-photo-festival-crowd-600nw-475397740.jpg",
            "https://thumbs.dreamstime.com/b/abstract-illuminated-light-stage-colourful-background-bokeh-143498898.jpg",
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey),
              );
            },
          ),

          //gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          //back button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 0),
                child: EventInfoBackButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
