import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontsize;
  final Color color;
  final Alignment alignment;
  final double height;
  final String fontFamily;
  final int fontWeight;

  CustomText(
      {this.text = '',
        this.fontsize = 16,
        this.color = Colors.black,
        this.alignment = Alignment.topLeft,
        this.height = 1,
        this.fontFamily = 'Tiktok_Sans',
        this.fontWeight = 1});


  @override
  Widget build(BuildContext context) {
    return
       Container(
         alignment: alignment,
         child: Text(
           text,
           style: TextStyle(
               color: color,
               height: height,
               fontSize: fontsize,
               fontFamily: fontFamily,
               fontWeight: FontWeight.bold),
         ),
    );
  }
}
