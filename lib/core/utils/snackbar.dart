import 'package:flutter/material.dart';

import '../../theme/font_provider.dart';
import 'color_utility.dart';

void showCustomSnackbar(BuildContext context, String message, ref) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SizedBox(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                // border:
                // Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                borderRadius: BorderRadius.circular(
                  18,
                ), // Adjust the border radius as needed
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(getColorHexFromStr("#EA9F57")),
                    Color(getColorHexFromStr("#DD6F85")),
                  ],
                ),
              ),
              child: Center(
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ref.watch(fontSizesProvider).fontSize,
                    )),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.6),
                  size: 16,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor:
          Colors.transparent, // Make Snackbar background transparent
      elevation: 0, // Remove Snackbar elevation
      behavior:
          SnackBarBehavior.floating, // Floating behavior for custom height
    ),
  );
}

void successSnackBar({
  required String title,
  required String message,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
    ),
  );
}

void warningSnackBar({
  required String title,
  required String message,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.white),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.orange,
    ),
  );
}

void errorSnackBar({
  required String title,
  required String message,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Expanded(
        child: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.shade600,
    ),
  );
}
