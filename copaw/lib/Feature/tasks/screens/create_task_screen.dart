import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Feature/tasks/bloc/create_task_cubit.dart';
import 'package:copaw/Feature/tasks/bloc/create_task_state.dart';
import 'package:copaw/Feature/Projects/Model/project_model.dart';
import 'package:copaw/Feature/Auth/Models/user.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';
import 'package:copaw/Feature/widgets/common/date_picker_field.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_validator.dart';

class CreateTaskScreen extends StatelessWidget {
  final ProjectModel project;
  final UserModel user;

  CreateTaskScreen({super.key, required this.project, required this.user});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateTaskCubit(),
      child: BlocConsumer<CreateTaskCubit, CreateTaskState>(
        listener: (context, state) {
          if (state is CreateTaskSuccess) {
            Navigator.pop(context, state.task);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateTaskCubit>();

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
                child: _buildForm(context, cubit, state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    CreateTaskCubit cubit,
    CreateTaskState state,
  ) {
    DateTime? _deadline;
    String _status = 'todo';
    String? _selectedUserId;
    final projectUsers = project.users;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title
          const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          CustomTextFormField(
            controller: _titleController,
            hintText: "Enter task title",
            validator: (text) => AppValidators.nameValidator(text, context),
          ),
          const SizedBox(height: 16),

          // 🔹 Description
          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          CustomTextFormField(
            controller: _descController,
            hintText: "Enter task description",
            maxLines: 3,
            validator: (text) => (text == null || text.trim().isEmpty)
                ? "Please enter a description"
                : null,
          ),
          const SizedBox(height: 16),

          // 🔹 Deadline picker
          StatefulBuilder(
            builder: (context, setState) {
              return DatePickerField(
                label: "Deadline",
                selectedDate: _deadline,
                onDateSelected: (newDate) {
                  setState(() {
                    _deadline = newDate;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // 🔹 Status
          const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
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
              );
            },
          ),
          const SizedBox(height: 16),

          // 🔹 Assign To
          const Text(
            "Assign To",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: _selectedUserId,
                hint: const Text("Select member"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: projectUsers.map((user) {
                  return DropdownMenuItem(
                    value: user.id,
                    child: Text(user.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedUserId = value),
              );
            },
          ),
          const SizedBox(height: 24),

          // 🔹 Submit Button
          Center(
            child: state is CreateTaskLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    label: "Create Task",
                    icon: Icons.add,
                    inverted: true,
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _deadline != null) {
                        cubit.createTask(
                          project: project,
                          user: user,
                          title: _titleController.text,
                          description: _descController.text,
                          deadline: _deadline!,
                          status: _status,
                          assignedUserId: _selectedUserId,
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
