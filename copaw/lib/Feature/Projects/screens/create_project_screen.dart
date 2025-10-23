import 'package:copaw/Feature/Projects/cubit/project_states.dart';
import 'package:copaw/Feature/Projects/cubit/project_view_model.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Feature/widgets/common/date_picker_field.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:copaw/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  ProjectViewModel projectViewModel = ProjectViewModel();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocListener<ProjectViewModel, ProjectStates>(
      bloc: projectViewModel,
      listener: (context, state) {
        if (state is ProjectLoadingState) {
          DialogUtils.showLoading(
            context: context,
            loadingText: "Creating Project...",
          );
        } else if (state is ProjectSuccessState) {
          DialogUtils.hideLoading(context: context);
          // Navigate to home after success
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: "Success",
            posActionName: "OK",
            posAction: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (_) => false,
            ),
          );
        } else if (state is ProjectErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.error,
            title: "Error",
            posActionName: "OK",
            posAction: () => Navigator.pop(context),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.mainColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "New Project",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: AppColors.whiteColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.001),
            child: Container(
              color: AppColors.grayColor,
              height: height * 0.001,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),
              CustomTextFormField(
                labelText: "Project Title",
                hintText: "Enter project name",
                controller: projectViewModel.projectNameController,
              ),
              SizedBox(height: height * 0.03),
              DatePickerField(
                label: "Deadline",
                dateText: projectViewModel.selectedDate,
                onDateSelected: (newDate) {
                  setState(() {
                    projectViewModel.selectedDate = newDate;
                  });
                },
              ),
              SizedBox(height: height * 0.03),

              // TeamMembersField(
              //   members: teamMembers,
              //   onAdd: (email) {

              //   },
              // ),
              SizedBox(height: height * 0.03),
              CustomButton(
                label: "Create Project",
                onPressed: () {
                  // Handle project creation
                  projectViewModel.createProject(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
