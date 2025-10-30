import 'package:flutter/material.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';

class Projectlist extends StatefulWidget {
  const Projectlist({super.key});

  @override
  State<Projectlist> createState() => _ProjectlistState();
}

class _ProjectlistState extends State<Projectlist> {
  String? selectedProject = 'Project Nebula';

  final List<Map<String, String>> projects = [
    {'id': '1', 'name': 'Project Nebula'},
    {'id': '2', 'name': 'AI Research'},
    {'id': '3', 'name': 'Mobile App'},
  ];

  @override
  Widget build(BuildContext context) {
    return Customcontainer(
      Height:MediaQuery.of(context).size.width * 0.5,
      Width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Project',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'AI actions are scoped to this project.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grayColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grayColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedProject,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  items: projects.map((project) {
                    return DropdownMenuItem<String>(
                      value: project['name'],
                      child: Text(project['name']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProject = newValue;
                      print(selectedProject);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
