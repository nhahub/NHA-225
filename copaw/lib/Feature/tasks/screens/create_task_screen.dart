import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/utils/app_validator.dart';
import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  final ProjectModel project;

  const CreateTaskScreen({super.key, required this.project});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _deadline;
  String _status = 'todo';

  /// Pick date function
  void _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    if (_deadline == null) return;

    final newTask = Task(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      deadline: _deadline!,
      status: _status,
      id: DateTime.now().millisecondsSinceEpoch.toString(), // or any unique ID
      createdAt: DateTime.now(),
      isCompleted: _status == 'done',
      createdBy: '',
      projectId: widget.project.id.toString(),
    );

    await TaskService.addTaskToProject(newTask, widget.project);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Customcontainer(
          Width: double.infinity,
          Height: null,
          margin: EdgeInsets.zero,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟩 Title
                const Text(
                  "Title",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                CustomTextFormField(
                  controller: _titleController,
                  hintText: "Enter task title",
                  validator: (text) =>
                      AppValidators.nameValidator(text, context),
                ),
                const SizedBox(height: 16),

                // 🟦 Description
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                CustomTextFormField(
                  controller: _descController,
                  hintText: "Enter task description",
                  maxLines: 3,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  "Deadline",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grayColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _deadline != null
                              ? "${_deadline!.day}/${_deadline!.month}/${_deadline!.year}"
                              : "Select a date",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🟧 Status
                const Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'todo', child: Text("To Do")),
                    DropdownMenuItem(value: 'doing', child: Text("Doing")),
                    DropdownMenuItem(value: 'done', child: Text("Done")),
                  ],
                  onChanged: (value) => setState(() => _status = value!),
                ),
                const SizedBox(height: 24),

                // 🟦 Button
                Center(
                  child: CustomButton(
                    label: "Create Task",
                    icon: Icons.add,
                    inverted: true,
                    onPressed: _saveTask,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
