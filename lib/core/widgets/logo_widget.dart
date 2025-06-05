import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Not recommended for simple logo+text, but possible:
class LogoWidget extends StatelessWidget {
  final String title;
  const LogoWidget({this.title = "Essor", super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/logo.svg',
            semanticsLabel: 'Logo',
            height: 40,
            width: 40,
          ),
          SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
