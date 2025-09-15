import 'package:flutter/foundation.dart';

enum ErrorCode {
  // Authentication Errors (AUTH_xxx)
  authInvalidCredentials('AUTH_001', 'Incorrect email or password'),
  authUserNotFound('AUTH_002', 'Incorrect email or password'),
  authEmailAlreadyExists('AUTH_003', 'Email already exists'),
  authWeakPassword('AUTH_004', 'Password does not meet security requirements'),
  authPasswordMismatch('AUTH_005', 'Passwords do not match'),
  authInvalidEmail('AUTH_006', 'Invalid email format'),
  authTokenExpired('AUTH_007', 'Session expired, please login again'),
  authTokenInvalid('AUTH_008', 'Invalid authentication token'),
  authPermissionDenied('AUTH_009', 'Permission denied'),
  authAccountDisabled('AUTH_010', 'Account has been disabled'),
  
  // Network Errors (NET_xxx)
  networkConnectionFailed('NET_001', 'Unable to connect to server'),
  networkTimeout('NET_002', 'Request timed out'),
  networkServerError('NET_003', 'Server error occurred'),
  networkBadRequest('NET_004', 'Invalid request format'),
  networkNotFound('NET_005', 'Endpoint not found'),
  networkUnauthorized('NET_006', 'Unauthorized access'),
  networkForbidden('NET_007', 'Access forbidden'),
  
  // Validation Errors (VAL_xxx)
  validationRequired('VAL_001', 'This field is required'),
  validationInvalidFormat('VAL_002', 'Invalid format'),
  validationTooShort('VAL_003', 'Input too short'),
  validationTooLong('VAL_004', 'Input too long'),
  validationTermsNotAccepted('VAL_005', 'Terms and conditions must be accepted'),
  
  // GraphQL Errors (GQL_xxx)
  graphqlParseError('GQL_001', 'Failed to parse GraphQL response'),
  graphqlFieldError('GQL_002', 'GraphQL field error'),
  graphqlQueryError('GQL_003', 'GraphQL query failed'),
  graphqlMutationError('GQL_004', 'GraphQL mutation failed'),
  
  // Unknown Error
  unknown('UNK_001', 'An unexpected error occurred');

  const ErrorCode(this.code, this.message);
  
  final String code;
  final String message;
}

class AppError implements Exception {
  final ErrorCode errorCode;
  final String? details;
  final DateTime timestamp;
  final String? stackTrace;

  AppError({
    required this.errorCode,
    this.details,
    this.stackTrace,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'AppError(${errorCode.code}): ${errorCode.message}${details != null ? ' - $details' : ''}';
  }

  String get userMessage => errorCode.message;
  String get trackingCode => '${errorCode.code}-${timestamp.millisecondsSinceEpoch}';
}

class ErrorTracker {
  static final List<AppError> _errorLog = [];

  static void logError(AppError error) {
    _errorLog.add(error);
    
    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('🚨 ERROR TRACKED: ${error.trackingCode}');
      debugPrint('   Code: ${error.errorCode.code}');
      debugPrint('   Message: ${error.errorCode.message}');
      debugPrint('   Details: ${error.details ?? 'None'}');
      debugPrint('   Time: ${error.timestamp}');
      if (error.stackTrace != null) {
        debugPrint('   Stack: ${error.stackTrace}');
      }
    }
  }

  static List<AppError> getErrorLog() => List.from(_errorLog);
  
  static void clearErrorLog() => _errorLog.clear();

  static AppError? getLastError() => _errorLog.isNotEmpty ? _errorLog.last : null;

  static List<AppError> getErrorsByCode(ErrorCode code) {
    return _errorLog.where((error) => error.errorCode == code).toList();
  }

  static Map<String, dynamic> getErrorStats() {
    final stats = <String, int>{};
    for (final error in _errorLog) {
      stats[error.errorCode.code] = (stats[error.errorCode.code] ?? 0) + 1;
    }
    return {
      'totalErrors': _errorLog.length,
      'errorBreakdown': stats,
      'lastError': _errorLog.isNotEmpty ? _errorLog.last.trackingCode : null,
    };
  }
}

// Helper function to create and log errors
AppError createError(ErrorCode code, {String? details, String? stackTrace}) {
  final error = AppError(
    errorCode: code,
    details: details,
    stackTrace: stackTrace,
  );
  ErrorTracker.logError(error);
  return error;
}
