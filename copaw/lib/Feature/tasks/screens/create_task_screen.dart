import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/widgets/common/appbar.dart';
import 'package:flutter/material.dart';
class CreateTaskScreen extends StatelessWidget {
  CreateTaskScreen({super.key});
  MyCustomAppBar appBar1 = MyCustomAppBar(head: 'Tasks', img: null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1,
      body: SingleChildScrollView(child: Customcontainer(
        Width: double.infinity,
        child: Column(
        children: [
        Text("To Do"),

        
        
        
        ],
        
        
        
        ),
      )),
    );
  }
}


