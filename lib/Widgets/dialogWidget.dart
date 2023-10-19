import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String content;
  const DialogWidget({
    Key? key,
    required this.label,
    required this.content,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(30),
      children: [
        Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 21, color: Colors.red, fontWeight: FontWeight.w400),
            ),
            Text(
              content,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialogOption(
              onPressed: onPressed,
              child: const Row(
                children: [
                  Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Yes',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(),
              child: const Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'No',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
