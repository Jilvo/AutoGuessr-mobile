/// État d'un formulaire d'authentification (login ou inscription).
///
/// Avec des booléens (`isLoading`, `error`...), on pourrait avoir des états
/// impossibles comme "en chargement ET en erreur". Avec une classe par état,
/// ces combinaisons n'existent tout simplement pas.
sealed class AuthFormState {
  const AuthFormState();
}

final class AuthFormIdle extends AuthFormState {
  const AuthFormIdle();
}

final class AuthFormSubmitting extends AuthFormState {
  const AuthFormSubmitting();
}

final class AuthFormSuccess extends AuthFormState {
  const AuthFormSuccess();
}

final class AuthFormFailure extends AuthFormState {
  const AuthFormFailure(this.message);

  final String message;
}
