import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_guessr_mobile/core/network/app_exception.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_form_state.dart';

class RegisterCubit extends Cubit<AuthFormState> {
  RegisterCubit(this._authRepository) : super(const AuthFormIdle());

  final AuthRepository _authRepository;

  Future<void> submit({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(const AuthFormSubmitting());
    try {
      await _authRepository.register(
        email: email,
        password: password,
        username: username,
      );
      if (isClosed) return;
      emit(const AuthFormSuccess());
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthFormFailure(e.message));
    }
  }
}
