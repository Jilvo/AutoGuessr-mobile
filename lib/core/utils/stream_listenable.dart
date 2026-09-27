import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapte un [Stream] en [Listenable].
///
/// GoRouter ne sait écouter que des `Listenable` (`refreshListenable`), alors
/// qu'un Cubit expose un `Stream` : cette classe fait le pont entre les deux.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
