import 'package:flutter/material.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Feature/widgets/common/date_picker_field.dart';

class EditTaskScreen extends StatefulWidget {
  final ProjectModel project;
  final UserModel user;
  final Task task;

  const EditTaskScreen({
    super.key,
    required this.project,
    required this.user,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _status;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _status = widget.task.status;
    _dueDate = widget.task.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    widget.task.title = _titleController.text.trim();
    widget.task.description = _descriptionController.text.trim();
    widget.task.status = _status;
    widget.task.deadline = _dueDate;

    Navigator.pop(context, widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), AppColors.mainColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
        ),
        title: Row(
          children: [
            _RoundedIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 16),
            const Text(
              "Edit Task",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: _titleController,
                labelText: 'Title',
                hintText: 'Enter task title',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 20),

              CustomTextFormField(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Enter task description',
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Status Dropdown
              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grayColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _status,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'todo', child: Text('To Do')),
                      DropdownMenuItem(value: 'doing', child: Text('Doing')),
                      DropdownMenuItem(value: 'done', child: Text('Done')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _status = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              DatePickerField(
                label: "Deadline",
                selectedDate: _dueDate,
                onDateSelected: (newDate) {
                  setState(() {
                    _dueDate = newDate;
                  });
                },
              ),
              const SizedBox(height: 30),

              CustomButton(
                width: double.infinity,
                label: 'Save Task',
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundedIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
