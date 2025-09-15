import 'package:flutter/material.dart';

enum CardType {
  visa,
  mastercard,
  amex,
  discover,
  dinersClub,
  jcb,
  unionPay,
  maestro,
  unknown,
}

class CardInfo {
  final CardType type;
  final String name;
  final String asset;
  final Color color;
  final List<int> lengths;
  final List<int> cvvLengths;
  final RegExp pattern;

  const CardInfo({
    required this.type,
    required this.name,
    required this.asset,
    required this.color,
    required this.lengths,
    required this.cvvLengths,
    required this.pattern,
  });
}

class CardUtils {
  static final Map<CardType, CardInfo> _cardInfo = {
    CardType.visa: CardInfo(
      type: CardType.visa,
      name: 'Visa',
      asset: '💳', // In a real app, use actual card icons
      color: Color(0xFF1A1F71),
      lengths: [13, 16, 19],
      cvvLengths: [3],
      pattern: RegExp(r'^4[0-9]{0,}$'),
    ),
    CardType.mastercard: CardInfo(
      type: CardType.mastercard,
      name: 'Mastercard',
      asset: '💳',
      color: Color(0xFFEB001B),
      lengths: [16],
      cvvLengths: [3],
      pattern: RegExp(r'^5[1-5][0-9]{0,}|^2[2-7][0-9]{0,}$'),
    ),
    CardType.amex: CardInfo(
      type: CardType.amex,
      name: 'American Express',
      asset: '💳',
      color: Color(0xFF006FCF),
      lengths: [15],
      cvvLengths: [4],
      pattern: RegExp(r'^3[47][0-9]{0,}$'),
    ),
    CardType.discover: CardInfo(
      type: CardType.discover,
      name: 'Discover',
      asset: '💳',
      color: Color(0xFFFF6000),
      lengths: [16, 19],
      cvvLengths: [3],
      pattern: RegExp(r'^6(?:011|5[0-9]{2})[0-9]{0,}$'),
    ),
    CardType.dinersClub: CardInfo(
      type: CardType.dinersClub,
      name: 'Diners Club',
      asset: '💳',
      color: Color(0xFF0079BE),
      lengths: [14, 16, 19],
      cvvLengths: [3],
      pattern: RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{0,}$'),
    ),
    CardType.jcb: CardInfo(
      type: CardType.jcb,
      name: 'JCB',
      asset: '💳',
      color: Color(0xFF006EBC),
      lengths: [16, 17, 18, 19],
      cvvLengths: [3],
      pattern: RegExp(r'^(?:2131|1800|35\d{3})\d{0,}$'),
    ),
    CardType.unionPay: CardInfo(
      type: CardType.unionPay,
      name: 'UnionPay',
      asset: '💳',
      color: Color(0xFFE21836),
      lengths: [16, 17, 18, 19],
      cvvLengths: [3],
      pattern: RegExp(r'^(62|88)[0-9]{0,}$'),
    ),
    CardType.maestro: CardInfo(
      type: CardType.maestro,
      name: 'Maestro',
      asset: '💳',
      color: Color(0xFF6C6BBD),
      lengths: [12, 13, 14, 15, 16, 17, 18, 19],
      cvvLengths: [3],
      pattern: RegExp(r'^(5018|5020|5038|6304|6759|6761|6763)[0-9]{0,}$'),
    ),
  };

  /// Detects card type from card number
  static CardType detectCardType(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    
    for (final cardInfo in _cardInfo.values) {
      if (cardInfo.pattern.hasMatch(cleanNumber)) {
        return cardInfo.type;
      }
    }
    
    return CardType.unknown;
  }

  /// Gets card information for a given type
  static CardInfo? getCardInfo(CardType type) {
    return _cardInfo[type];
  }

  /// Formats card number with appropriate spacing
  static String formatCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    final cardType = detectCardType(cleanNumber);
    
    if (cardType == CardType.amex) {
      // Amex format: 3782 822463 10005
      return cleanNumber.replaceAllMapped(
        RegExp(r'(\d{4})(\d{6})(\d{5})'),
        (match) => '${match[1]} ${match[2]} ${match[3]}',
      );
    } else {
      // Standard format: 1234 5678 9012 3456
      return cleanNumber.replaceAllMapped(
        RegExp(r'(\d{4})'),
        (match) => '${match[0]} ',
      ).trim();
    }
  }

  /// Formats expiry date as MM/YY
  static String formatExpiryDate(String expiry) {
    final cleanExpiry = expiry.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanExpiry.length >= 2) {
      return '${cleanExpiry.substring(0, 2)}/${cleanExpiry.substring(2)}';
    }
    
    return cleanExpiry;
  }

  /// Validates card number using Luhn algorithm
  static bool validateCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    
    if (cleanNumber.isEmpty || !RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return false;
    }

    final cardType = detectCardType(cleanNumber);
    final cardInfo = getCardInfo(cardType);
    
    if (cardInfo == null || !cardInfo.lengths.contains(cleanNumber.length)) {
      return false;
    }

    return _luhnCheck(cleanNumber);
  }

  /// Validates expiry date
  static bool validateExpiryDate(String expiry) {
    final cleanExpiry = expiry.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanExpiry.length != 4) return false;
    
    final month = int.tryParse(cleanExpiry.substring(0, 2));
    final year = int.tryParse(cleanExpiry.substring(2, 4));
    
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;
    
    if (year < currentYear) return false;
    if (year == currentYear && month < currentMonth) return false;
    
    return true;
  }

  /// Validates CVV
  static bool validateCVV(String cvv, CardType cardType) {
    final cardInfo = getCardInfo(cardType);
    if (cardInfo == null) return false;
    
    final cleanCVV = cvv.replaceAll(RegExp(r'[^\d]'), '');
    return cardInfo.cvvLengths.contains(cleanCVV.length);
  }

  /// Luhn algorithm for card number validation
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;
    
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }

  /// Gets masked card number for display
  static String getMaskedCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleanNumber.length < 4) return cleanNumber;
    
    final lastFour = cleanNumber.substring(cleanNumber.length - 4);
    return '•••• •••• •••• $lastFour';
  }

  /// Gets card brand icon
  static Widget getCardIcon(CardType cardType, {double size = 24}) {
    final cardInfo = getCardInfo(cardType);
    
    if (cardInfo == null) {
      return Icon(
        Icons.credit_card,
        size: size,
        color: Colors.grey,
      );
    }

    return Container(
      width: size * 1.5,
      height: size,
      decoration: BoxDecoration(
        color: cardInfo.color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          cardInfo.asset,
          style: TextStyle(
            fontSize: size * 0.6,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Suggests card completion
  static List<String> getCardSuggestions(String partialNumber) {
    final suggestions = <String>[];
    final cleanNumber = partialNumber.replaceAll(RegExp(r'\s+'), '');
    
    // Add common test card numbers for demo
    if (cleanNumber.isEmpty || '4111111111111111'.startsWith(cleanNumber)) {
      suggestions.add('4111 1111 1111 1111'); // Visa test card
    }
    if (cleanNumber.isEmpty || '5555555555554444'.startsWith(cleanNumber)) {
      suggestions.add('5555 5555 5555 4444'); // Mastercard test card
    }
    if (cleanNumber.isEmpty || '378282246310005'.startsWith(cleanNumber)) {
      suggestions.add('3782 822463 10005'); // Amex test card
    }
    
    return suggestions;
  }
}
