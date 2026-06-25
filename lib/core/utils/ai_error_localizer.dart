import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ai_service_exception.dart';

/// Maps an [AiErrorType] to a localized, user-facing message.
String localizeAiError(AiErrorType type, AppLocalizations l10n) {
  switch (type) {
    case AiErrorType.noApiKey:
      return l10n.aiErrorNoApiKey;
    case AiErrorType.imageTooLarge:
      return l10n.aiErrorImageTooLarge;
    case AiErrorType.invalidApiKey:
      return l10n.aiErrorInvalidApiKey;
    case AiErrorType.quotaExceeded:
      return l10n.aiErrorQuotaExceeded;
    case AiErrorType.noModelAccess:
      return l10n.aiErrorNoModelAccess;
    case AiErrorType.serviceUnavailable:
      return l10n.aiErrorServiceUnavailable;
    case AiErrorType.timeout:
      return l10n.aiErrorTimeout;
    case AiErrorType.network:
      return l10n.aiErrorNetwork;
    case AiErrorType.blockedContent:
      return l10n.aiErrorBlockedContent;
    case AiErrorType.noFood:
      return l10n.aiErrorNoFood;
    case AiErrorType.couldNotProcess:
      return l10n.aiErrorCouldNotProcess;
    case AiErrorType.emptyResponse:
      return l10n.aiErrorEmptyResponse;
    case AiErrorType.unknown:
      return l10n.aiErrorUnknown;
  }
}

/// Resolves any error thrown by an AI service into a localized message.
/// Non-[AiServiceException] errors fall back to a generic message.
String aiErrorMessage(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context);
  if (error is AiServiceException) {
    return localizeAiError(error.type, l10n);
  }
  return l10n.aiErrorUnknown;
}
