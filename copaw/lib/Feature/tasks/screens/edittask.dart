import 'package:flutter/material.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';

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
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _status = widget.task.status;
    _dueDate = widget.task.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
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
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainColor),
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainColor),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                initialValue: _status,
                items: const [
                  DropdownMenuItem(value: 'todo', child: Text('To Do')),
                  DropdownMenuItem(value: 'doing', child: Text('Doing')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _status = val);
                },
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Due date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'No due date'
                          : 'Due: ${_dueDate!.toIso8601String()}'.split(' ')[0],
                    style: TextStyle(color: Colors.black)),
                  ),
                  CustomButton(
                    label: 'Pick Date',
                    width: 120,
                    inverted: false,
                    onPressed: _pickDueDate,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save button
              CustomButton(
                width: double.infinity,
                label: 'Save Task',
                inverted: false,
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
