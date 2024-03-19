import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Hello, Username'),
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade400,
          // child: Image.asset('assets/splash/sg_logo.png'),
        ),
      ),
      actions: const [
        Icon(
          Icons.wallet,
          color: Colors.grey,
        ),
        SizedBox(width: 15),
        Icon(
          Icons.notifications_none,
          color: Colors.grey,
        ),
        SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
