/// Categories of errors that the AI services can produce.
///
/// Services throw an [AiServiceException] with one of these types instead of
/// a hard-coded English message, so the UI can localize the message in the
/// user's language via `localizeAiError`.
enum AiErrorType {
  /// No API key has been configured by the user.
  noApiKey,

  /// The selected image exceeds the size limit.
  imageTooLarge,

  /// The API key is invalid or malformed.
  invalidApiKey,

  /// Daily/usage quota for the key has been exhausted.
  quotaExceeded,

  /// The key has no access/permission to the requested model.
  noModelAccess,

  /// The model is overloaded/unavailable after retries and fallback.
  serviceUnavailable,

  /// The request timed out.
  timeout,

  /// A network/connectivity error occurred.
  network,

  /// The content was blocked by safety filters.
  blockedContent,

  /// No food items could be detected in the photo.
  noFood,

  /// The response could not be parsed/processed.
  couldNotProcess,

  /// The model returned an empty response.
  emptyResponse,

  /// Any other unexpected error.
  unknown,
}

/// Exception thrown by the AI services, carrying a localizable [type].
class AiServiceException implements Exception {
  final AiErrorType type;

  const AiServiceException(this.type);

  @override
  String toString() => 'AiServiceException(${type.name})';
}
