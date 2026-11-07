import 'package:flutter/foundation.dart';
import '../models/history_item.dart';
import '../services/database_service.dart';

class HistoryProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;

  List<TranslationHistoryItem> _allItems = [];
  bool _isLoading = false;
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  HistoryProvider() {
    loadHistory();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get showFavoritesOnly => _showFavoritesOnly;

  List<TranslationHistoryItem> get allItems => List.unmodifiable(_allItems);

  List<TranslationHistoryItem> get favoriteItems =>
      _allItems.where((item) => item.isFavorite).toList();

  List<TranslationHistoryItem> get displayItems {
    var list = _showFavoritesOnly ? favoriteItems : _allItems;
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((item) {
        return item.sourceText.toLowerCase().contains(q) ||
            item.translatedText.toLowerCase().contains(q) ||
            item.sourceLang.toLowerCase().contains(q) ||
            item.targetLang.toLowerCase().contains(q);
      }).toList();
    }
    return list;
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allItems = await _dbService.getAllTranslations();
    } catch (e) {
      debugPrint('Error loading history from database: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTranslation({
    required String sourceText,
    required String translatedText,
    required String sourceLang,
    required String targetLang,
  }) async {
    final cleanSource = sourceText.trim();
    final cleanTranslated = translatedText.trim();
    if (cleanSource.isEmpty || cleanTranslated.isEmpty) return;

    final item = TranslationHistoryItem(
      sourceText: cleanSource,
      translatedText: cleanTranslated,
      sourceLang: sourceLang,
      targetLang: targetLang,
      timestamp: DateTime.now(),
    );

    try {
      final id = await _dbService.insertTranslation(item);
      final newItem = item.copyWith(id: id);

      // Remove existing matching entry if present to place it at the top
      _allItems.removeWhere(
        (e) =>
            e.sourceText.trim() == cleanSource &&
            e.translatedText.trim() == cleanTranslated &&
            e.sourceLang == sourceLang &&
            e.targetLang == targetLang,
      );
      _allItems.insert(0, newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error inserting translation to history: $e');
    }
  }

  Future<void> toggleFavorite(TranslationHistoryItem item) async {
    if (item.id == null) return;
    final newFavoriteStatus = !item.isFavorite;

    try {
      await _dbService.toggleFavorite(item.id!, newFavoriteStatus);
      final index = _allItems.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        _allItems[index] = item.copyWith(isFavorite: newFavoriteStatus);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _dbService.deleteTranslation(id);
      _allItems.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting item from history: $e');
    }
  }

  Future<void> restoreItem(TranslationHistoryItem item) async {
    try {
      final id = await _dbService.insertTranslation(item);
      _allItems.insert(0, item.copyWith(id: id));
      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring item to history: $e');
    }
  }

  Future<void> clearHistory({bool keepFavorites = false}) async {
    try {
      await _dbService.clearAllHistory(keepFavorites: keepFavorites);
      if (keepFavorites) {
        _allItems.removeWhere((item) => !item.isFavorite);
      } else {
        _allItems.clear();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setShowFavoritesOnly(bool value) {
    _showFavoritesOnly = value;
    notifyListeners();
  }
}
