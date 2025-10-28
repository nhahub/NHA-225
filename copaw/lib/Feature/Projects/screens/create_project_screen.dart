import 'package:copaw/Feature/Projects/cubit/project_states.dart';
import 'package:copaw/Feature/Projects/cubit/project_view_model.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/widgets/common/custom_text_field.dart';
import 'package:copaw/Feature/widgets/common/date_picker_field.dart';
import 'package:copaw/Services/firebaseServices/auth_service.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_routes.dart';
import 'package:copaw/utils/dialog_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => ProjectViewModel(),
      child: BlocConsumer<ProjectViewModel, ProjectStates>(
        listener: (context, state) {
          if (state is ProjectLoadingState) {
            DialogUtils.showLoading(
              context: context,
              loadingText: "Creating Project...",
            );
          } else if (state is ProjectSuccessState) {
            DialogUtils.hideLoading(context: context);
            DialogUtils.showMessage(
              context: context,
              message: state.message,
              title: "Success",
              posActionName: "OK",
                posAction: () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    final userModel = await AuthService.getUserById(currentUser.uid);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (_) => false,
                      arguments: userModel, // ✅ Pass the user here
                    );
                  }
                },
              // ✅ No need to navigate manually here anymore
            );
          } else if (state is ProjectErrorState) {
            DialogUtils.hideLoading(context: context);
            DialogUtils.showMessage(
              context: context,
              message: state.error,
              title: "Error",
              posActionName: "OK",
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProjectViewModel>();

          return Scaffold(
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.03),
                    CustomTextFormField(
                      labelText: "Project Title",
                      hintText: "Enter project name",
                      controller: cubit.projectNameController,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextFormField(
                      labelText: "Project Description",
                      hintText: "Enter project description",
                      controller: cubit.projectDescreptionController,
                    ),
                    SizedBox(height: height * 0.03),
                    BlocBuilder<ProjectViewModel, ProjectStates>(
                      buildWhen: (prev, curr) =>
                          curr is ProjectDateUpdatedState,
                      builder: (context, state) {
                        final date = state is ProjectDateUpdatedState
                            ? state.date
                            : cubit.selectedDate;
                        return DatePickerField(
                          label: "Deadline",
                          selectedDate: date,
                          onDateSelected: (newDate) =>
                              cubit.updateSelectedDate(newDate),
                        );
                      },
                    ),
                    SizedBox(height: height * 0.05),
                    CustomButton(
                      label: "Create Project",
                      onPressed: () => cubit.createProject(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
