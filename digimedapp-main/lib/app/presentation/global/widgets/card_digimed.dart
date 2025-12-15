import 'package:flutter/material.dart';

class CardDigimed extends StatelessWidget {
  final Widget child;
  final Color? color;
  const CardDigimed({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: color ?? Colors.white,
      shadowColor:  Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
