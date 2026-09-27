import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_guessr_mobile/core/network/app_exception.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_form_state.dart';

class LoginCubit extends Cubit<AuthFormState> {
  LoginCubit(this._authRepository) : super(const AuthFormIdle());

  final AuthRepository _authRepository;

  Future<void> submit({required String email, required String password}) async {
    emit(const AuthFormSubmitting());
    try {
      await _authRepository.login(email: email, password: password);
      // Pendant l'`await`, la page a pu être fermée (et le Cubit avec elle) :
      // émettre sur un Cubit fermé lève une exception.
      if (isClosed) return;
      emit(const AuthFormSuccess());
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthFormFailure(e.message));
    }
  }
}
