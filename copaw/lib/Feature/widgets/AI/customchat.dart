import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/Feature/widgets/AI/CustomContainer.dart';

class Customchat extends StatefulWidget {
  const Customchat({super.key});

  @override
  State<Customchat> createState() => _CustomchatState();
}

class _CustomchatState extends State<Customchat> {
  final _chatController = InMemoryChatController();

  @override
  void initState() {
    super.initState();

    // 🧠 Add initial AI message once the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.insertMessage(
        TextMessage(
          id: 'ai_1',
          authorId: 'ai_bot',
          createdAt: DateTime.now().toUtc(),
          text: "How can I help you?",
        ),
      );
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Customcontainer(
      Width: double.infinity,
      Height: MediaQuery.of(context).size.height * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Chat(
          chatController: _chatController,
          currentUserId: 'user1',
          onMessageSend: (text) {
            _chatController.insertMessage(
              TextMessage(
                id: '${Random().nextInt(1000) + 1}',
                authorId: 'user1',
                createdAt: DateTime.now().toUtc(),
                text: text,
              ),
            );
          },
          resolveUser: (UserID id) async {
            if (id == 'ai_bot') {
              return User(id: id, name: 'AI Assistant');
            } else {
              return User(id: id, name: 'You');
            }
          },
          theme: ChatTheme(
            colors: ChatColors(
              primary: AppColors.mainColor, // keep your brand color
              onPrimary: AppColors.whiteColor,
              surface: const Color(0xFFF9FAFB), // soft neutral background
              onSurface: AppColors.textColor,
              surfaceContainer: Colors.white, // message background
              surfaceContainerHigh: AppColors.grayColor.withOpacity(0.15),
              surfaceContainerLow: AppColors.grayColor.withOpacity(0.05),
            ),
            typography: const ChatTypography(
              bodyLarge: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                letterSpacing: 0.2,
                height: 1.4,
              ),
              bodyMedium: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.1,
                height: 1.4,
              ),
              bodySmall: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color(0xFF6B7280), // muted text color
                height: 1.4,
              ),
              labelLarge: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.5,
                color: Color(0xFF1F2937),
              ),
              labelMedium: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                letterSpacing: 0.4,
              ),
              labelSmall: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                letterSpacing: 0.2,
                color: Color(0xFF9CA3AF),
              ),
            ),
            shape: BorderRadiusGeometry.circular(16),
          ),
        ),
      ),
    );
  }
}
