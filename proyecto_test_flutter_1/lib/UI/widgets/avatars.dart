import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget(this.avatarIndex, {super.key})
      : assert(0 <= avatarIndex && avatarIndex <= 4);

  final int avatarIndex;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/avatars/avatar$avatarIndex.jpeg'),
    );
  }
}
