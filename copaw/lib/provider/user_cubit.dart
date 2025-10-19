import 'package:copaw/Models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);

  void setUser(UserModel user) {
    emit(user);
  }

  void clearUser() {
    emit(null);
  }
}