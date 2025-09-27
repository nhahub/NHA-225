import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String head; 
  final String img;  

  const MyCustomAppBar({
    Key? key,
    required this.head,
    required this.img,
  }) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          Text(
            head, // now it works
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          CircleAvatar( 
            backgroundImage: AssetImage(img ??'copaw/assets/NULLP.webp' ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
