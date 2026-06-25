import 'dart:io';
import 'package:flutter/material.dart';

class BusinessLogoWidget extends StatelessWidget {
  final dynamic logoData;

  const BusinessLogoWidget({super.key, required this.logoData});

  @override
  Widget build(BuildContext context) {
    if (logoData == null) {
      return Container(
        color: const Color(0xFFF3F4F6),
        child: const Icon(Icons.business, color: Color(0xFF9CA3AF)),
      );
    }
    if (logoData is File) {
      return Image.file(logoData, fit: BoxFit.cover);
    }
    if (logoData is String) {
      if (logoData.startsWith('http')) {
        return Image.network(logoData, fit: BoxFit.cover);
      } else {
        return Image.asset(logoData, fit: BoxFit.cover);
      }
    }
    return Container(color: Colors.grey);
  }
}
