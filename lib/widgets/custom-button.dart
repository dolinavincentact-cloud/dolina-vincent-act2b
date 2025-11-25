import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool loadingPa;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFFF7622),
    this.textColor = Colors.white,
    this.loadingPa = false,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:  loadingPa ? null : onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size.fromHeight(50)),
      child: loadingPa ? 
        SizedBox( 
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
          
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(backgroundColor),
          ),
          )
          :
          Text(
            text,
          style: TextStyle(fontWeight: FontWeight.bold), 
          )
    );
  }
}
