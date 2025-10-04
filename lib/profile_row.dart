import 'package:flutter/material.dart';

class ProfileRow extends StatelessWidget{
  final IconData icon;
  final String text;

  const ProfileRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        //icon
        Icon(
          icon,
          size: 40,
          color: const Color(0XFF60A3D9),
        ),

        const SizedBox(width: 20,),

        //text details
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),

        //arrow icon
        const Icon(
          Icons.navigate_next_outlined,
          size: 30,
          weight: 10,
        ),
      ],
    );
  }
}
