import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paloma365/model/section_model.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class SectionItemWidget extends StatelessWidget {
  const SectionItemWidget({super.key, required this.model, required this.onTap});

  final SectionModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(
              Icons.emoji_food_beverage_rounded,
              size: 30,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                model.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
