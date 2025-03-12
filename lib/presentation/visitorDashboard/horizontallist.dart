import 'package:flutter/material.dart';

class HorizontalCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // Total height of the list
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: 10, // Number of items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5), // Spacing between cards
            child: Card(
              elevation: 4, // Shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: Container(
                width: 60, // Width of each card
                padding: const EdgeInsets.all(8), // Inner padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://via.placeholder.com/25x24', // Replace with your image URL
                      width: 25,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 5), // Space between image and text
                    const Text(
                      "Title", // Replace with dynamic text
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
