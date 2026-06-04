import 'package:flutter/foundation.dart';

/// Excepción personalizada para errores de la aplicación.
/// Se usa para envolver errores de Firestore, HTTP y SharedPreferences
/// con mensajes amigables para el usuario.
class AppException implements Exception {
  final String message;
  final String? code;
  final Object? originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

/// Envuelve una operación async con try/catch, logea el error
/// y re-lanza como [AppException].
Future<T> wrapServiceCall<T>(
  String operation,
  Future<T> Function() call, {
  String? errorCode,
}) async {
  try {
    return await call();
  } catch (e, stack) {
    debugPrint('[$operation] Error: $e');
    debugPrint('[$operation] Stack: $stack');
    throw AppException(
      e.toString(),
      code: errorCode,
      originalError: e,
    );
  }
}

/// Maneja errores en streams de Firestore, logeando sin romper el stream.
void handleStreamError(
  String operation,
  Object error,
  StackTrace stack,
) {
  debugPrint('[$operation] Stream error: $error');
  debugPrint('[$operation] Stack: $stack');
}
