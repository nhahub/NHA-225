import 'package:copaw/Feature/tasks/screens/edittask.dart';
import 'package:copaw/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:copaw/Models/project_model.dart';
import 'package:copaw/Models/task.dart';
import 'package:copaw/Models/user.dart';
import 'package:copaw/Feature/widgets/task/task_item.dart';
import 'package:copaw/Feature/widgets/common/custom_button.dart';
import 'package:copaw/Feature/Projects/cubit/project_detail_cubit.dart';
import 'package:copaw/Services/firebaseServices/task_service.dart';
import 'package:copaw/Feature/tasks/screens/create_task_screen.dart';
import 'package:copaw/Feature/Projects/screens/add_member_screen.dart';
import 'package:copaw/utils/app_colors.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;
  final UserModel user;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectDetailsCubit(project),
      child: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
          final project = state.project;

          final todoTasks = project.tasks
              .where((t) => t.status == 'todo')
              .toList();
          final doingTasks = project.tasks
              .where((t) => t.status == 'doing')
              .toList();
          final doneTasks = project.tasks
              .where((t) => t.status == 'done')
              .toList();

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FB),
            extendBody: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 90,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F172A), AppColors.mainColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
              ),
              title: Row(
                children: [
                  _RoundedIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          project.name ?? 'Project',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          project.description ?? 'Keep your team aligned',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: const [SizedBox(width: 20)],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProjectInfo(
                    context,
                    project,
                    todoTasks.length,
                    doingTasks.length,
                    doneTasks.length,
                  ),
                  const SizedBox(height: 18),
                  _buildMembersSection(context, project),
                  const SizedBox(height: 18),
                  _buildTasksSection(
                    context,
                    todoTasks,
                    doingTasks,
                    doneTasks,
                    project.users,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: CustomButton(
                width: double.infinity,
                label: "Add Task",
                icon: Icons.add,
                onPressed: () async {
                  final newTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CreateTaskScreen(project: project, user: user),
                    ),
                  );

                  if (newTask != null && context.mounted) {
                    await context.read<ProjectDetailsCubit>().retrieveTasks();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectInfo(
    BuildContext context,
    ProjectModel project,
    int todoCount,
    int doingCount,
    int doneCount,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEDF2FF), Color(0xFFE0F2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 20),
            spreadRadius: -18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name ?? "Project Overview",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project.description ?? 'No description provided yet.',
            style: TextStyle(
              color: AppColors.textColor.withOpacity(0.75),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 12,
            children: [
              _InfoChip(
                label: "Deadline",
                value: project.deadline != null
                    ? "${project.deadline!.day}/${project.deadline!.month}/${project.deadline!.year}"
                    : "Not set",
                icon: Icons.calendar_today_outlined,
              ),
              _InfoChip(
                label: "To Do",
                value: '$todoCount',
                icon: Icons.radio_button_unchecked,
              ),
              _InfoChip(
                label: "In Progress",
                value: '$doingCount',
                icon: Icons.timelapse,
              ),
              _InfoChip(
                label: "Done",
                value: '$doneCount',
                icon: Icons.check_circle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context, ProjectModel project) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  "Members",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "${project.users.length} Teammate",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              Flexible(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddMemberScreen(projectId: project.id!),
                      ),
                    );
                  },
                  icon: const Icon(Icons.group_add_outlined, size: 18),
                  label: const Text("Manage", overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 360;

              return Wrap(
                spacing: 12,
                runSpacing: 16,
                children: project.users.map((member) {
                  final avatar = member.avatarUrl;

                  return SizedBox(
                    width: isSmall ? 60 : 70,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: isSmall ? 24 : 26,
                          backgroundColor: AppColors.mainColor.withOpacity(0.1),
                          child: CircleAvatar(
                            radius: isSmall ? 21 : 23,
                            backgroundImage:
                                (avatar != null && avatar.isNotEmpty)
                                ? NetworkImage(avatar)
                                : const AssetImage('assets/NULLP.webp')
                                      as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          member.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmall ? 11 : 12,
                            color: AppColors.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection(
    BuildContext context,
    List<Task> todo,
    List<Task> doing,
    List<Task> done,
    List<UserModel> projectUsers,
  ) {
    final columns = [
      _TaskColumnData("To Do", todo, AppColors.grayColor),
      _TaskColumnData("In Progress", doing, AppColors.mainColor),
      _TaskColumnData("Completed", done, AppColors.warningColor),
    ];

    return SizedBox(
      height: 420,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: columns.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final data = columns[index];
          return _buildTaskColumn(
            context,
            data.title,
            data.tasks,
            projectUsers,
            accent: data.accent,
          );
        },
      ),
    );
  }

  Widget _buildTaskColumn(
    BuildContext context,
    String title,
    List<Task> taskList,
    List<UserModel> projectUsers, {
    Color accent = AppColors.mainColor,
  }) {
    final cubit = context.read<ProjectDetailsCubit>();

    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 18),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.drag_indicator, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${taskList.length}',
                  style: TextStyle(fontWeight: FontWeight.w700, color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (taskList.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "No tasks yet",
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Image.asset(AppAssets.emptyTasks, width: 200, height: 200),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: taskList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final task = taskList[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accent.withOpacity(0.15)),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TaskItem(
                            task: task,
                            projectUsers: projectUsers,
                          ),
                        ),
                        Positioned(
                          right: 19,
                          top: 19,
                          child: PopupMenuButton<String>(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            onSelected: (value) async {
                              if (value == 'edit') {
                                final editedTask = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTaskScreen(
                                      project: cubit.state.project,
                                      user: cubit.state.project.users.first,
                                      task: task,
                                    ),
                                  ),
                                );

                                if (editedTask != null && context.mounted) {
                                  await cubit.editTask(editedTask);
                                }
                              } else if (value == 'delete') {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Task?'),
                                    content: const Text(
                                      'Are you sure you want to delete this task?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await TaskService.deleteTask(
                                    task.id,
                                    cubit.state.project,
                                  );
                                  await cubit.retrieveTasks();
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
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

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.mainColor, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textColor.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskColumnData {
  final String title;
  final List<Task> tasks;
  final Color accent;

  const _TaskColumnData(this.title, this.tasks, this.accent);
}
