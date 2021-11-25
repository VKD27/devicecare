import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final String title;

  const CupertinoButtonWidget({
    this.onPressed,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }
}