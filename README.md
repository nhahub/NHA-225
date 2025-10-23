# copaw - Project a Task Mangment

Copaw is a flutter Application which helps Students or Teams to mange their project 

===============================================================

## Feature :-

- Create, update, and delete projects.
- Create tasks inside projects.
- Track task status: To Do, Doing, Done.
- Assign team members to projects.
- Project deadlines and task deadlines.
- Simple and clean UI with custom widgets.
- Clean Architecture Feature-based Architecture
===============================================================

## Tech Stack :-

- Flutter & Dart
- Firebase Firestore
- State management: Bloc / Cubit
- Custom UI components
===============================================================

## Application Structure :-

│   firebase_options.dart
│   main.dart
│
├───Feature
│   ├───Ai
│   │   ├───bloc
│   │   │       ai_bloc.dart
│   │   │
│   │   └───screens
│   │           ai_assistant_screen.dart
│   │           ai_chat_screen.dart
│   │
│   ├───Auth
│   │   ├───cubit
│   │   │       auth_states.dart
│   │   │       auth_view_model.dart
│   │   │
│   │   └───screens
│   │           forgot_password_screen.dart
│   │           login_screen.dart
│   │           register_screen.dart
│   │
│   ├───calender
│   │   ├───bloc
│   │   │       calendar_bloc.dart
│   │   │       calendar_event.dart
│   │   │       calendar_state.dart
│   │   │
│   │   └───screens
│   │           calender_screen.dart
│   │
│   ├───Home
│   │   ├───bloc
│   │   │       home_bloc.dart
│   │   │
│   │   └───screens
│   │           dashboard_screen.dart
│   │           Home_screen.dart
│   │
│   ├───Projects
│   │   ├───cubit
│   │   │       project_states.dart
│   │   │       project_view_model.dart
│   │   │
│   │   └───screens
│   │           create_project_screen.dart
│   │           projects_screen.dart
│   │           project_details_screen.dart
│   │
│   ├───tasks
│   │   ├───bloc
│   │   │       task_bloc.dart
│   │   │
│   │   └───screens
│   │           create_task_screen.dart
│   │           tasks_screen.dart
│   │
│   └───widgets
│       ├───AI
│       │       customchat.dart
│       │       CustomContainer.dart
│       │       CustomMultipleSelectChoices.dart
│       │       ProjectList.dart
│       │       SelectTasks.dart
│       │
│       ├───calender
│       │       custom_calendar.dart
│       │
│       ├───common
│       │       appbar.dart
│       │       custom_bottom_nav.dart
│       │       custom_button.dart
│       │       custom_text_field.dart
│       │       date_picker_field.dart
│       │       loading_widget.dart
│       │       team_member_field.dart
│       │
│       ├───project
│       │       project_card.dart
│       │
│       └───task
│               task_item.dart
│
├───Models
│       message.dart
│       project_model.dart
│       task.dart
│       user.dart
│
├───provider
│       user_cubit.dart
│
├───Services
│   │   ai_service.dart
│   │
│   └───firebaseServices
│           auth_service.dart
│           project_service.dart
│           task_service.dart
│
└───utils
        app_assets.dart
        app_colors.dart
        app_routes.dart
        app_styles.dart
        app_validator.dart
        dialog_utils.dart
===============================================================

### Prerequisites

- Flutter >= 3.0
- Firebase project setup
===============================================================

## dependencies:-

  cupertino_icons: ^1.0.8
  font_awesome_flutter: ^10.10.0
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  google_sign_in: ^7.2.0
  flutter_chat_ui: ^2.9.1
  table_calendar: ^3.1.2
  flutter_bloc: ^9.1.1
  equatable: ^2.0.5
  skeletonizer: ^2.1.0+1
  google_fonts: ^6.3.2
  cloud_firestore: ^6.0.3
===============================================================

## Run the App

flutter pub get
flutter run
=============================================================== 
## How Tasks Work

Tasks are embedded inside project documents in Firestore.

Project document structure:

{
  String? id;
  String? name;
  String? description;
  DateTime? deadline;
  String? leaderId;
  List<UserModel> users;
  List<Task> tasks;
  Timestamp? createdAt;
}

=============================================================== 
