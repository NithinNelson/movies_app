import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(context, message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.grey[200],
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(
        bottom: 50,
        right: 50,
        left: 50,
      ),
    ),
  );
}