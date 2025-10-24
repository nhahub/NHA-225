# CoPaw - Project & Task Management

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge\&logo=flutter\&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge\&logo=firebase\&logoColor=black)

CoPaw is a Flutter application that helps students and teams manage their projects efficiently.

---

## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [Prerequisites](#prerequisites)
5. [Dependencies](#dependencies)
6. [Running the App](#running-the-app)
7. [How Tasks Work](#how-tasks-work)


---

## Features

* Authentication By Googel And Email
* Calender View For tasks
* Create, update, and delete projects
* Create tasks inside projects
* Track task status: To Do, Doing, Done
* Assign team members to projects
* Set project deadlines and task deadlines
* Simple and clean UI with custom widgets
* Feature-based architecture for scalability

---

## Tech Stack

* Flutter & Dart
* Firebase Firestore
* State management: Bloc / Cubit
* Custom UI components

---

## Project Structure

```
│   firebase_options.dart
│   main.dart
│
├───Feature
│   ├───Ai
│   │   ├───bloc
│   │   │       ai_bloc.dart
│   │   └───screens
│   │           ai_assistant_screen.dart
│   │           ai_chat_screen.dart
│   ├───Auth
│   │   ├───cubit
│   │   │       auth_states.dart
│   │   │       auth_view_model.dart
│   │   └───screens
│   │           forgot_password_screen.dart
│   │           login_screen.dart
│   │           register_screen.dart
│   ├───Calendar
│   │   ├───bloc
│   │   │       calendar_bloc.dart
│   │   │       calendar_event.dart
│   │   │       calendar_state.dart
│   │   └───screens
│   │           calendar_screen.dart
│   ├───Home
│   │   ├───bloc
│   │   │       home_bloc.dart
│   │   └───screens
│   │           dashboard_screen.dart
│   │           home_screen.dart
│   ├───Projects
│   │   ├───cubit
│   │   │       project_states.dart
│   │   │       project_view_model.dart
│   │   └───screens
│   │           create_project_screen.dart
│   │           projects_screen.dart
│   │           project_details_screen.dart
│   ├───Tasks
│   │   ├───bloc
│   │   │       task_bloc.dart
│   │   └───screens
│   │           create_task_screen.dart
│   │           tasks_screen.dart
│   └───Widgets
│       ├───AI
│       │       custom_chat.dart
│       │       custom_container.dart
│       │       custom_multiple_select_choices.dart
│       │       project_list.dart
│       │       select_tasks.dart
│       ├───Calendar
│       │       custom_calendar.dart
│       ├───Common
│       │       appbar.dart
│       │       custom_bottom_nav.dart
│       │       custom_button.dart
│       │       custom_text_field.dart
│       │       date_picker_field.dart
│       │       loading_widget.dart
│       │       team_member_field.dart
│       ├───Project
│       │       project_card.dart
│       └───Task
│               task_item.dart
│
├───Models
│       message.dart
│       project_model.dart
│       task.dart
│       user.dart
│
├───Provider
│       user_cubit.dart
│
├───Services
│   │   ai_service.dart
│   └───firebaseServices
│           auth_service.dart
│           project_service.dart
│           task_service.dart
│
└───Utils
        app_assets.dart
        app_colors.dart
        app_routes.dart
        app_styles.dart
        app_validator.dart
        dialog_utils.dart
```

---

## Prerequisites

* Flutter >= 3.0
* Firebase project setup

---

## Dependencies

```yaml
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
```

---

## Running the App

```bash
flutter pub get
flutter run
```

---

## How Tasks Work

Tasks are embedded inside project documents in Firestore.

**Project document structure:**

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "deadline": "DateTime",
  "leaderId": "string",
  "users": ["UserModel"],
  "tasks": ["Task"],
  "createdAt": "Timestamp"
}
```

---
