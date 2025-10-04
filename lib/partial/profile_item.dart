import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../ults/functions.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final String leadingIcon;
  final Color avatarColor;
  final Color arrowColor;
  final Color? iconColor;
  final Color? titleColor;
  final double avatarRadius;
  final bool isLast;
  const ProfileItem(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.leadingIcon,
      required this.avatarColor,
      this.arrowColor = Colors.black38,
      this.iconColor = Colors.black54,
      this.titleColor,
      this.avatarRadius = 14,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // margin: const EdgeInsets.only(
      //   left: 20,
      //   right: 20,
      // ),
      onTap: onPressed,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: avatarColor,
                  child: Image.asset(
                    leadingIcon,
                    height: 20,
                  )),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  title,
                  style:
                      TextStyle(color: titleColor, fontWeight: FontWeight.w400),
                ),
              ),
              Expanded(child: Container()),
              Icon(
                Icons.arrow_forward_ios,
                color: arrowColor,
                size: 15,
              )
            ],
          ),
          if (isLast == false)
            const Divider(
              thickness: 0.4,
            )
        ],
      ),
    );
  }
}

class ProfileItemIcon extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leadingIcon;
  final Color arrowColor;
  final Color? iconColor;
  final Color? titleColor;
  final double avatarRadius;
  final double? iconSize;
  final bool isLast;

  const ProfileItemIcon({
    super.key,
    required this.title,
    required this.onPressed,
    required this.leadingIcon,
    this.arrowColor = Colors.white70,
    this.iconColor,
    this.titleColor,
    this.avatarRadius = 18,
    this.iconSize,
    this.isLast = false,
  });

  @override
  State<ProfileItemIcon> createState() => _ProfileItemIconState();
}

class _ProfileItemIconState extends State<ProfileItemIcon> {
  @override
  Widget build(BuildContext context) {
    final isDark = isDarkTheme(context);

    return InkWell(
      onTap: widget.onPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: widget.avatarRadius,
                  backgroundColor: isDark ? const Color(0xFF262A34) : const Color(0xFFF1F3F6),
                  child: Icon(
                    widget.leadingIcon,
                    color: widget.iconColor ?? (isDark ? Colors.white : Colors.black87),
                    size: widget.iconSize ?? 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.titleColor ?? (isDark ? Colors.white : Colors.black87),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: widget.arrowColor,
                ),
              ],
            ),
          ),
          if (!widget.isLast)
            Divider(
              color: isDark ? Colors.white10 : Colors.black12,
              thickness: 0.6,
              height: 0,
            ),
        ],
      ),
    );
  }
}
