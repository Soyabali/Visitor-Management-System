import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  CustomButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full-width button
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white), // Button Icon
        label: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15), // Good height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded edges
          ),
          backgroundColor: color,
        ),
        onPressed: onPressed,
      ),
    );
  }
}