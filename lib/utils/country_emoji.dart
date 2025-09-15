class CountryEmoji {
  static const Map<String, String> _countryFlags = {
    // North America
    'USA': '🇺🇸',
    'United States': '🇺🇸',
    'US': '🇺🇸',
    'Canada': '🇨🇦',
    'Mexico': '🇲🇽',
    
    // Europe
    'United Kingdom': '🇬🇧',
    'UK': '🇬🇧',
    'England': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    'Scotland': '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
    'Wales': '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
    'Ireland': '🇮🇪',
    'France': '🇫🇷',
    'Germany': '🇩🇪',
    'Italy': '🇮🇹',
    'Spain': '🇪🇸',
    'Portugal': '🇵🇹',
    'Netherlands': '🇳🇱',
    'Belgium': '🇧🇪',
    'Switzerland': '🇨🇭',
    'Austria': '🇦🇹',
    'Sweden': '🇸🇪',
    'Norway': '🇳🇴',
    'Denmark': '🇩🇰',
    'Finland': '🇫🇮',
    'Poland': '🇵🇱',
    'Czech Republic': '🇨🇿',
    'Hungary': '🇭🇺',
    'Romania': '🇷🇴',
    'Bulgaria': '🇧🇬',
    'Greece': '🇬🇷',
    'Turkey': '🇹🇷',
    'Russia': '🇷🇺',
    'Ukraine': '🇺🇦',
    
    // Asia
    'China': '🇨🇳',
    'Japan': '🇯🇵',
    'South Korea': '🇰🇷',
    'India': '🇮🇳',
    'Thailand': '🇹🇭',
    'Vietnam': '🇻🇳',
    'Singapore': '🇸🇬',
    'Malaysia': '🇲🇾',
    'Indonesia': '🇮🇩',
    'Philippines': '🇵🇭',
    'Taiwan': '🇹🇼',
    'Hong Kong': '🇭🇰',
    'Pakistan': '🇵🇰',
    'Bangladesh': '🇧🇩',
    'Sri Lanka': '🇱🇰',
    'Nepal': '🇳🇵',
    'Myanmar': '🇲🇲',
    'Cambodia': '🇰🇭',
    'Laos': '🇱🇦',
    
    // Middle East
    'Saudi Arabia': '🇸🇦',
    'UAE': '🇦🇪',
    'United Arab Emirates': '🇦🇪',
    'Qatar': '🇶🇦',
    'Kuwait': '🇰🇼',
    'Bahrain': '🇧🇭',
    'Oman': '🇴🇲',
    'Jordan': '🇯🇴',
    'Lebanon': '🇱🇧',
    'Syria': '🇸🇾',
    'Iraq': '🇮🇶',
    'Iran': '🇮🇷',
    'Israel': '🇮🇱',
    'Palestine': '🇵🇸',
    
    // Africa
    'South Africa': '🇿🇦',
    'Egypt': '🇪🇬',
    'Nigeria': '🇳🇬',
    'Kenya': '🇰🇪',
    'Ghana': '🇬🇭',
    'Morocco': '🇲🇦',
    'Algeria': '🇩🇿',
    'Tunisia': '🇹🇳',
    'Libya': '🇱🇾',
    'Ethiopia': '🇪🇹',
    'Tanzania': '🇹🇿',
    'Uganda': '🇺🇬',
    'Rwanda': '🇷🇼',
    'Zimbabwe': '🇿🇼',
    'Botswana': '🇧🇼',
    'Namibia': '🇳🇦',
    
    // Oceania
    'Australia': '🇦🇺',
    'New Zealand': '🇳🇿',
    'Fiji': '🇫🇯',
    'Papua New Guinea': '🇵🇬',
    
    // South America
    'Brazil': '🇧🇷',
    'Argentina': '🇦🇷',
    'Chile': '🇨🇱',
    'Peru': '🇵🇪',
    'Colombia': '🇨🇴',
    'Venezuela': '🇻🇪',
    'Ecuador': '🇪🇨',
    'Bolivia': '🇧🇴',
    'Paraguay': '🇵🇾',
    'Uruguay': '🇺🇾',
    'Guyana': '🇬🇾',
    'Suriname': '🇸🇷',
    
    // Caribbean
    'Jamaica': '🇯🇲',
    'Cuba': '🇨🇺',
    'Dominican Republic': '🇩🇴',
    'Haiti': '🇭🇹',
    'Trinidad and Tobago': '🇹🇹',
    'Barbados': '🇧🇧',
    'Bahamas': '🇧🇸',
  };

  /// Get the flag emoji for a country name
  /// Returns the emoji if found, otherwise returns a generic globe emoji
  static String getFlag(String country) {
    if (country.isEmpty) return '🌍';
    
    // Try exact match first
    String? flag = _countryFlags[country];
    if (flag != null) return flag;
    
    // Try case-insensitive match
    for (var entry in _countryFlags.entries) {
      if (entry.key.toLowerCase() == country.toLowerCase()) {
        return entry.value;
      }
    }
    
    // Try partial match for common variations
    final lowerCountry = country.toLowerCase();
    for (var entry in _countryFlags.entries) {
      final lowerKey = entry.key.toLowerCase();
      if (lowerKey.contains(lowerCountry) || lowerCountry.contains(lowerKey)) {
        return entry.value;
      }
    }
    
    // Default to globe emoji if no match found
    return '🌍';
  }

  /// Get country name with flag emoji
  static String getCountryWithFlag(String country) {
    if (country.isEmpty) return '';
    return '$country ${getFlag(country)}';
  }

  /// Get just the flag emoji with proper spacing
  static String getFlagWithSpace(String country) {
    if (country.isEmpty) return '';
    return ' ${getFlag(country)}';
  }
}
