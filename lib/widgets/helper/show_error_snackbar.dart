import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SizedBox(
        height: 30, // Adjust the height as needed
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black54,
      duration: const Duration(seconds: 2),
    ),
  );
}
