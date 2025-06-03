import 'package:flutter/material.dart';

class ExpandedFlexiablePage
    extends StatelessWidget {
  const ExpandedFlexiablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(color: Colors.teal),
          ),
        ],
      ),
    );
  }
}
