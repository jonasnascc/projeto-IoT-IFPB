import 'package:flutter/material.dart';
import 'package:smart_condominium/core/app_constants.dart';

class IconCard extends StatelessWidget {
  final String imagePath;

  const IconCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.instance.screenHeight * 0.25,
      height: AppConstants.instance.screenHeight * 0.25,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.topLeft,
        child: Image.asset(
          imagePath,
          width: AppConstants.instance.screenHeight * 0.1,
          height: AppConstants.instance.screenHeight * 0.1,
        ),
      ),
    );
  }
}
