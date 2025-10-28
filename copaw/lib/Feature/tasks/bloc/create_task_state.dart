import 'package:equatable/equatable.dart';
import 'package:copaw/Models/task.dart';

abstract class CreateTaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {
  final Task task;
  CreateTaskSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

class CreateTaskError extends CreateTaskState {
  final String message;
  CreateTaskError(this.message);

  @override
  List<Object?> get props => [message];
}
