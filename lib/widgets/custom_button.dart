import 'package:flutter/material.dart';
import 'package:note_app/globles/pallets.dart';

class CustomButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  const CustomButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: iconButtonColor,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
