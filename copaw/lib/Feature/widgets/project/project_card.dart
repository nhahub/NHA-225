import 'package:copaw/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final int totalTasks;
  final int completedTasks;
  final DateTime deadline;
  final List<String?> memberAvatars;
  final String? currentUserName;
  final VoidCallback? onDelete;

  const ProjectCard({
    super.key,
    required this.title,
    required this.totalTasks,
    required this.completedTasks,
    required this.deadline,
    required this.memberAvatars,
    this.onDelete,
    this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final progress = totalTasks == 0
        ? 0.0
        : (completedTasks / totalTasks).clamp(0.0, 1.0);
    final remaining = (totalTasks - completedTasks).clamp(0, totalTasks);
    final deadlineLabel = DateFormat('MMM d, yyyy').format(deadline);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FAFF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.mainColor.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondery.withOpacity(0.40),
            blurRadius: 30,
            offset: const Offset(0, 14),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$completedTasks of $totalTasks tasks completed",
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                _IconBubble(
                  icon: Icons.delete_outline,
                  gradient: const [Color(0xFFFC5C7D), Color(0xFFF857A6)],
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Project'),
                        content: const Text(
                          'Are you sure you want to delete this project?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) onDelete?.call();
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.lightGrayColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                height: 12,
                width: (width - (width * 0.14)) * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42E695), Color(0xFF3BB2B8)],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoPill(
                icon: Icons.calendar_today_outlined,
                label: deadlineLabel,
              ),
              const SizedBox(width: 10),
              _InfoPill(
                icon: Icons.timelapse_outlined,
                label: remaining == 0 ? "On track" : "$remaining left",
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team',
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          if (currentUserName != null)
                            _CurrentUserBadge(name: currentUserName!),
                          for (
                            int i = 0;
                            i < memberAvatars.length && i < 4;
                            i++
                          )
                            Positioned(
                              left:
                                  (i + (currentUserName != null ? 1 : 0)) * 28,
                              child: _AvatarBubble(avatarUrl: memberAvatars[i]),
                            ),
                          if (memberAvatars.length > 4)
                            Positioned(
                              left:
                                  (4 + (currentUserName != null ? 1 : 0)) * 28,
                              child: _OverflowBubble(
                                count: memberAvatars.length - 4,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.mainColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Progress',
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mainColor.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.mainColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final List<Color> gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _IconBubble({
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.4),
              blurRadius: 18,
              offset: const Offset(0, 10),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  final String? avatarUrl;

  const _AvatarBubble({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: AppColors.mainColor.withOpacity(0.2),
      ),
      child: ClipOval(
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.mainColor.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.mainColor,
                      size: 24,
                    ),
                  );
                },
              )
            : Container(
                color: AppColors.mainColor.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  color: AppColors.mainColor,
                  size: 24,
                ),
              ),
      ),
    );
  }
}

class _OverflowBubble extends StatelessWidget {
  final int count;

  const _OverflowBubble({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CurrentUserBadge extends StatelessWidget {
  final String name;

  const _CurrentUserBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.whiteColor, width: 2),
        gradient: const LinearGradient(
          colors: [Color(0xFF42E695), Color(0xFF3BB2B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  String _initials(String input) {
    final parts = input.trim().split(' ');
    if (parts.isEmpty) return 'YO';
    if (parts.length == 1) {
      return parts.first.isNotEmpty
          ? parts.first.substring(0, 1).toUpperCase()
          : 'U';
    }
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = parts[1].isNotEmpty ? parts[1][0] : '';
    return (first.toString() + second.toString()).toUpperCase();
  }
}
