import 'package:flutter/material.dart';

class RelatedVideoScreen extends StatefulWidget {
  const RelatedVideoScreen({super.key});

  @override
  State<RelatedVideoScreen> createState() => _RelatedVideoScreenState();
}

class _RelatedVideoScreenState extends State<RelatedVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(
        child: Text(
          'Related Video Screen',
              style: TextStyle(
            color: Colors.white,
        ),
        ),
      ),
    );
  }
}
