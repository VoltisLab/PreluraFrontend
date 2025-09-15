import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'error_service.dart';
import 'token_service.dart';

class GraphQLService {
  static const String _endpoint = 'https://uat-api.vmodel.app/wms/graphql/';
  
  static GraphQLClient get client {
    final HttpLink httpLink = HttpLink(
      _endpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'WholesalersMarketplace/1.0',
      },
    );
    
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  static GraphQLClient getAuthenticatedClient(String token) {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    
    final HttpLink httpLink = HttpLink(_endpoint);
    
    final Link link = authLink.concat(httpLink);
    
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}

class GraphQLQueries {
  static const String register = '''
    mutation Register(\$firstName: String!, \$lastName: String!, \$password1: String!, \$password2: String!, \$email: String!, \$accountType: String!, \$termsAccepted: Boolean!) {
      register(
        firstName: \$firstName,
        lastName: \$lastName,
        password1: \$password1,
        password2: \$password2,
        email: \$email,
        accountType: \$accountType,
        termsAccepted: \$termsAccepted
      ) {
        token
        refreshToken
        success
        errors
      }
    }
  ''';

  static const String login = '''
    mutation Login(\$email: String!, \$password: String!) {
      login(
        email: \$email,
        password: \$password
      ) {
        token
        refreshToken
        user {
          accountType
        }
      }
    }
  ''';

  static const String viewMe = '''
    query ViewMe {
      viewMe {
        id
        email
        firstName
        lastName
      }
    }
  ''';

  static const String logout = '''
    mutation Logout(\$refreshToken: String!) {
      logout(refreshToken: \$refreshToken) {
        __typename
        message
      }
    }
  ''';
}

class AuthService {
  static final GraphQLClient _client = GraphQLService.client;

  static Future<Map<String, dynamic>?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String accountType,
    required bool termsAccepted,
  }) async {
    try {
      debugPrint('🔄 Starting registration for: $email');
      
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.register),
          variables: {
            'firstName': firstName,
            'lastName': lastName,
            'password1': password,
            'password2': confirmPassword,
            'email': email,
            'accountType': accountType.toUpperCase(),
            'termsAccepted': termsAccepted,
          },
        ),
      );

      if (result.hasException) {
        final exception = result.exception!;
        
        // Parse GraphQL errors
        if (exception.graphqlErrors.isNotEmpty) {
          final graphqlError = exception.graphqlErrors.first;
          final errorMessage = graphqlError.message;
          
          // Check for duplicate email errors
          if (errorMessage.toLowerCase().contains('email') && 
              (errorMessage.toLowerCase().contains('exist') ||
               errorMessage.toLowerCase().contains('already') ||
               errorMessage.toLowerCase().contains('taken') ||
               errorMessage.toLowerCase().contains('duplicate'))) {
            throw createError(ErrorCode.authEmailAlreadyExists, details: 'Email: $email');
          } else if (errorMessage.toLowerCase().contains('password')) {
            throw createError(ErrorCode.authWeakPassword, details: errorMessage);
          } else {
            throw createError(ErrorCode.graphqlMutationError, details: errorMessage);
          }
        }
        
        // Network errors
        if (exception.linkException != null) {
          throw createError(ErrorCode.networkConnectionFailed, 
            details: 'Registration endpoint unreachable');
        }
        
        throw createError(ErrorCode.unknown, details: exception.toString());
      }

      final registerData = result.data?['register'];
      
      if (registerData?['success'] != true) {
        final errors = registerData?['errors'] as List?;
        final errorDetails = errors?.join(', ') ?? 'Registration failed';
        throw createError(ErrorCode.authInvalidCredentials, details: errorDetails);
      }

      debugPrint('✅ Registration successful for: $email');
      return registerData;
      
    } catch (e) {
      if (e is AppError) {
        rethrow;
      }
      
      final error = createError(
        ErrorCode.unknown, 
        details: 'Registration exception: ${e.toString()}',
        stackTrace: StackTrace.current.toString(),
      );
      throw error;
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔄 Starting login for: $email');
      
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.login),
          variables: {
            'email': email,
            'password': password,
          },
        ),
      );

      if (result.hasException) {
        final exception = result.exception!;
        
        // Parse GraphQL errors
        if (exception.graphqlErrors.isNotEmpty) {
          final graphqlError = exception.graphqlErrors.first;
          final errorMessage = graphqlError.message;
          
          // For login, we want to show the same message for both user not found and wrong password
          // This prevents user enumeration attacks
          if (errorMessage.toLowerCase().contains('invalid') || 
              errorMessage.toLowerCase().contains('incorrect') ||
              errorMessage.toLowerCase().contains('not found') ||
              errorMessage.toLowerCase().contains('wrong') ||
              errorMessage.toLowerCase().contains('bad')) {
            throw createError(ErrorCode.authInvalidCredentials, 
              details: 'Login failed for: $email');
          } else {
            throw createError(ErrorCode.graphqlMutationError, 
              details: errorMessage);
          }
        }
        
        // Network errors
        if (exception.linkException != null) {
          throw createError(ErrorCode.networkConnectionFailed, 
            details: 'Login endpoint unreachable');
        }
        
        throw createError(ErrorCode.unknown, details: exception.toString());
      }

      final loginData = result.data?['login'];
      
      if (loginData?['token'] == null) {
        throw createError(ErrorCode.authInvalidCredentials, 
          details: 'No token received for: $email');
      }

      debugPrint('✅ Login successful for: $email');
      return loginData;
      
    } catch (e) {
      if (e is AppError) {
        rethrow;
      }
      
      final error = createError(
        ErrorCode.unknown, 
        details: 'Login exception: ${e.toString()}',
        stackTrace: StackTrace.current.toString(),
      );
      throw error;
    }
  }

  static Future<Map<String, dynamic>?> viewMe(String token) async {
    try {
      debugPrint('🔄 Fetching user profile with token: ${token.substring(0, 10)}...');
      
      final GraphQLClient authenticatedClient = GraphQLService.getAuthenticatedClient(token);
      
      final QueryResult result = await authenticatedClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.viewMe),
        ),
      );

      if (result.hasException) {
        final exception = result.exception!;
        
        // Parse GraphQL errors
        if (exception.graphqlErrors.isNotEmpty) {
          final graphqlError = exception.graphqlErrors.first;
          final errorMessage = graphqlError.message;
          
          if (errorMessage.toLowerCase().contains('unauthorized') || 
              errorMessage.toLowerCase().contains('token')) {
            throw createError(ErrorCode.authTokenInvalid, 
              details: 'Token validation failed');
          } else {
            throw createError(ErrorCode.graphqlQueryError, 
              details: errorMessage);
          }
        }
        
        // Network errors
        if (exception.linkException != null) {
          throw createError(ErrorCode.networkConnectionFailed, 
            details: 'ViewMe endpoint unreachable');
        }
        
        throw createError(ErrorCode.unknown, details: exception.toString());
      }

      final userData = result.data?['viewMe'];
      
      if (userData == null) {
        throw createError(ErrorCode.authUserNotFound, 
          details: 'User profile not found');
      }

      debugPrint('✅ User profile fetched successfully');
      return userData;
      
    } catch (e) {
      if (e is AppError) {
        rethrow;
      }
      
      final error = createError(
        ErrorCode.unknown, 
        details: 'ViewMe exception: ${e.toString()}',
        stackTrace: StackTrace.current.toString(),
      );
      throw error;
    }
  }

  static Future<Map<String, dynamic>?> logout(String refreshToken) async {
    try {
      debugPrint('🔄 Starting logout with refreshToken...');
      
      // Get current access token for authentication
      final accessToken = await TokenService.getToken();
      final authenticatedClient = accessToken != null 
          ? GraphQLService.getAuthenticatedClient(accessToken)
          : _client;
      
      final QueryResult result = await authenticatedClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.logout),
          variables: {
            'refreshToken': refreshToken,
          },
        ),
      );

      if (result.hasException) {
        final exception = result.exception!;
        
        if (exception.graphqlErrors.isNotEmpty) {
          final graphqlError = exception.graphqlErrors.first;
          final errorMessage = graphqlError.message;
          throw createError(ErrorCode.graphqlMutationError, details: errorMessage);
        }
        
        if (exception.linkException != null) {
          throw createError(ErrorCode.networkConnectionFailed, 
            details: 'Logout endpoint unreachable');
        }
        
        throw createError(ErrorCode.unknown, details: exception.toString());
      }

      final logoutData = result.data?['logout'];
      debugPrint('✅ Logout successful: ${logoutData?['message'] ?? 'Session invalidated'}');
      return logoutData;
      
    } catch (e) {
      if (e is AppError) {
        rethrow;
      }
      
      final error = createError(
        ErrorCode.unknown, 
        details: 'Logout exception: ${e.toString()}',
        stackTrace: StackTrace.current.toString(),
      );
      throw error;
    }
  }
}
