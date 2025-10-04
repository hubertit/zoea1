import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Widget leadingIcon;
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: avatarColor,
                    child: leadingIcon),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: titleColor, fontWeight: FontWeight.w400),
                  ),
                ),
                Expanded(child: Container()),
                const Icon(
                  Icons.arrow_forward_ios,
                  // color: arrowColor,
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
      ),
    );
  }
}

class ProfileItemIcon extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leadingIcon;
  final Color avatarColor;
  final Color arrowColor;
  final Color? iconColor;
  final Color? titleColor;
  final double avatarRadius;
  final double? iconSize;
  final bool isLast;
  const ProfileItemIcon(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.leadingIcon,
      required this.avatarColor,
      this.arrowColor = Colors.black38,
      this.iconColor = Colors.black54,
      this.titleColor,
      this.avatarRadius = 14,
      this.iconSize,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // margin: const EdgeInsets.only(
      //   left: 20,
      //   right: 20,
      // ),
      onTap: onPressed,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: avatarColor,
                    child: Icon(
                      leadingIcon,
                      color: iconColor,
                      size: iconSize,
                    )),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: titleColor, fontWeight: FontWeight.w400),
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
      ),
    );
  }
}
