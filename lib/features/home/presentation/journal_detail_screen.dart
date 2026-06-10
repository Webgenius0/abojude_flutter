import 'package:flutter/material.dart';

class JournalDetailScreen extends StatefulWidget {
  const JournalDetailScreen({super.key});

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Journal Detail Screen'),),
    );
  }
}