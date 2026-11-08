final Map<String, String> languageMap = {
  'Arabic':'ar',
  'Assamese':'as',
  'Bengali':'bn',
  'Chinese (Simplified)': 'zh-CN',
  'Chinese (Traditional)': 'zh-TW',
  'English': 'en',
  'French': 'fr',
  'German': 'de',
  'Gujarati':'gu',
  'Hebrew':'iw',
  'Hindi': 'hi',
  'Japanese':'ja',
  'Kannada': 'kn',
  'Konkani':'gom',
  'Malayalam':'ml',
  'Russian':'ru',
  'Sanskrit':'sa',
  'Spanish': 'es',
  'Tamil':'ta',
  'Telugu':'te',
  'Thai':'th',
};

final Map<String, String> talklanguageMap = {
  'Arabic':'ar-AE',
  'Assamese':'as-IN',
  'Bengali':'bn-IN',
  'Chinese (Simplified)':'zh-CN',
  'Chinese (Traditional)':'zh-TW',
  'English (India)': 'en-IN',
  'English (US)': 'en-US',
  'French': 'fr-FR',
  'German': 'de-DE',
  'Gujarati':'gu-IN',
  'Hebrew':'iw-IL',
  'Hindi': 'hi-IN',
  'Japanese':'ja-JP',
  'Kannada': 'kn-IN',
  'Konkani':'gom-IN',
  'Malayalam':'ml-IN',
  'Russian':'ru-RU',
  'Sanskrit':'sa-IN',
  'Spanish': 'es-ES',
  'Tamil':'ta-IN',
  'Telugu':'te-IN',
  'Thai':'th-TH',
};

/// Language mapping for text translation source picker, including 'Auto Detect'.
final Map<String, String> translateSourceLanguageMap = {
  'Auto Detect': 'auto',
  ...talklanguageMap,
};

List<Map<String, String>> availableVoices = [
  {"name": "Natural", "value": "natural"},
  {"name": "Male", "value": "male"},
  {"name": "Female", "value": "female"},
  {"name": "Robot", "value": "robot"},
];

/// Normalizes any legacy or custom voice string into 'natural', 'male', 'female', or 'robot'.
String normalizeVoiceChoice(String? rawVoice) {
  if (rawVoice == null || rawVoice.isEmpty) return 'natural';
  final lower = rawVoice.toLowerCase();
  if (lower.contains('female')) return 'female';
  if (lower.contains('male')) return 'male';
  if (lower.contains('robot')) return 'robot';
  if (lower == 'natural' || lower == 'default') return 'natural';
  return 'natural';
}

/// Resolves any language name, 2-letter code, or locale into a valid BCP-47 locale tag for TTS.
String getTtsLocale(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'auto') return 'en-US';
  if (trimmed.toLowerCase() == 'english' || trimmed.toLowerCase() == 'en') return 'en-US';
  if (trimmed.toLowerCase() == 'en-in' || trimmed.toLowerCase() == 'english (india)' || trimmed.toLowerCase() == 'english (in)') return 'en-IN';
  if (trimmed.toLowerCase() == 'en-us' || trimmed.toLowerCase() == 'english (us)') return 'en-US';

  // 1. Exact match with a language name in talklanguageMap (e.g., 'Kannada' -> 'kn-IN', 'English (India)' -> 'en-IN')
  if (talklanguageMap.containsKey(trimmed)) {
    return talklanguageMap[trimmed]!;
  }

  // 2. Exact match with a value in talklanguageMap (e.g., 'kn-IN', 'en-IN', 'en-US')
  if (talklanguageMap.containsValue(trimmed)) {
    return trimmed;
  }

  // 3. Match from 2-letter languageMap code (e.g., 'kn' -> 'Kannada' -> 'kn-IN')
  for (final entry in languageMap.entries) {
    if (entry.value.toLowerCase() == trimmed.toLowerCase()) {
      return talklanguageMap[entry.key] ?? trimmed;
    }
  }

  // 4. Normalized code prefix match (e.g., 'zh-cn' -> 'Chinese (Simplified)' -> 'zh-CN')
  final lower = trimmed.toLowerCase();
  for (final entry in talklanguageMap.entries) {
    final valLower = entry.value.toLowerCase();
    if (valLower == lower || valLower.startsWith(lower) || lower.startsWith(valLower)) {
      return entry.value;
    }
  }

  // Fallback to input
  return trimmed;
}


final List<Map<String,String>> questionAnswer =[
{"Q":"How do I translate text?","A":"Simply enter text and press 'Translate' button."},
{"Q": "How do I enable speech translation","A":"Go to 'Speech' tab and clic the mic button and select the language."},
  {"Q":"How to hear translated text?","A":"Click on 'Volume Icon' to hear the translated text"},
  {"Q":"Is there any way to copy translated text?","A":"Yes, there is option to copy translated text to clipboard"}
];

// Script mapping: Language -> TextRecognitionScript
final Map<String, String> languageToScript = {
  'Arabic': 'latin',
  'Assamese': 'devanagari',
  'Bengali': 'devanagari',
  'Chinese (Simplified)': 'chinese',
  'Chinese (Traditional)': 'chinese',
  'English': 'latin',
  'English (India)': 'latin',
  'English (US)': 'latin',
  'French': 'latin',
  'German': 'latin',
  'Gujarati': 'devanagari',
  'Hebrew': 'latin', // Note: Hebrew recognition may have limited support
  'Hindi': 'devanagari',
  'Japanese': 'japanese',
  'Kannada': 'devanagari',
  'Konkani': 'devanagari',
  'Malayalam': 'devanagari',
  'Russian': 'latin',
  'Sanskrit': 'devanagari',
  'Spanish': 'latin',
  'Tamil': 'devanagari',
  'Telugu': 'devanagari',
  'Thai': 'latin', // Note: Thai recognition may have limited support
};

final Map<String, String> languageFlagMap = {
  'Auto Detect': '✨',
  'Arabic': '🇸🇦',
  'Assamese': '🇮🇳',
  'Bengali': '🇧🇩',
  'Chinese (Simplified)': '🇨🇳',
  'Chinese (Traditional)': '🇹🇼',
  'English': '🇺🇸',
  'English (India)': '🇮🇳',
  'English (IN)': '🇮🇳',
  'English (US)': '🇺🇸',
  'French': '🇫🇷',
  'German': '🇩🇪',
  'Gujarati': '🇮🇳',
  'Hebrew': '🇮🇱',
  'Hindi': '🇮🇳',
  'Japanese': '🇯🇵',
  'Kannada': '🇮🇳',
  'Konkani': '🇮🇳',
  'Korean': '🇰🇷',
  'Malayalam': '🇮🇳',
  'Russian': '🇷🇺',
  'Sanskrit': '🇮🇳',
  'Spanish': '🇪🇸',
  'Tamil': '🇮🇳',
  'Telugu': '🇮🇳',
  'Thai': '🇹🇭',
};

String getLanguageFlag(String languageName) {
  if (languageFlagMap.containsKey(languageName)) {
    return languageFlagMap[languageName]!;
  }
  if (languageName.contains('India') || languageName.contains('(IN)')) {
    return '🇮🇳';
  }
  if (languageName.contains('US')) {
    return '🇺🇸';
  }
  return languageFlagMap[languageName] ?? '🌐';
}

String getLanguageNameFromValue(Map<String, String> map, String value) {
  for (final entry in map.entries) {
    if (entry.value == value) return entry.key;
  }
  for (final entry in map.entries) {
    if (entry.value.startsWith(value)) return entry.key;
  }
  return value;
}
