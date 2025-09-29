import 'package:flutter/material.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';

class AiAssistantScreen extends StatelessWidget {
  AiAssistantScreen({super.key});
MyCustomAppBar appBar1 = MyCustomAppBar(head: 'Title', img: null);  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: appBar1,


    );
  }
}
