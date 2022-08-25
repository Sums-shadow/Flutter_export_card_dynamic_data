import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final double height;
  final double width;
  final String text;
  final Color color;
  final Color textColor;
  final double textSize;
  final Function() onTap;
  CustomButton(
      {Key? key,
      required this.height,
      required this.text,
      required this.width,
      required this.color,
      required this.textColor,
      required this.textSize,
      required this.onTap})
      : super();

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          color: widget.color == null
              ? Theme.of(context).primaryColor
              : widget.color,
        ),
        width: widget.width == null ? double.infinity : widget.width,
        height: widget.height == null ? 50 : widget.height,
        child: Center(
          child: Text(
            widget.text == null ? '' : widget.text,
            style: TextStyle(
                color:
                    widget.textColor == null ? Colors.white : widget.textColor,
                fontWeight: FontWeight.w300,
                fontSize: widget.textSize == null ? 16 : widget.textSize),
          ),
        ),
      ),
    );
  }
}
