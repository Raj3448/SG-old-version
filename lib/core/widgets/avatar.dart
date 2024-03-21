import 'package:flutter/material.dart';

class Avatar24 extends StatelessWidget {
  const Avatar24({required this.imgPath, super.key});

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      maxRadius: 24,
      backgroundImage: AssetImage('assets/icon/headshot.png'),
      /*
      If it is a network image use this:

      backgroundImage: NetworkImage('url'),
      
      */
    );
  }
}

class Avatar32 extends StatelessWidget {
  const Avatar32({required this.imgPath, super.key});

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      maxRadius: 32,
      backgroundImage: AssetImage('assets/icon/headshot.png'),
    );
  }
}

class Avatar44 extends StatelessWidget {
  const Avatar44({required this.imgPath, super.key});

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      maxRadius: 44,
      backgroundImage: AssetImage('assets/icon/headshot.png'),
    );
  }
}

class Avatar48 extends StatelessWidget {
  const Avatar48({required this.imgPath, super.key});

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      maxRadius: 48,
      backgroundImage: AssetImage('assets/icon/headshot.png'),
    );
  }
}

class Avatar56 extends StatelessWidget {
  const Avatar56({required this.imgPath, super.key});

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      maxRadius: 56,
      backgroundImage: AssetImage('assets/icon/headshot.png'),
    );
  }
}
