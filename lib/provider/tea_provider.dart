import 'package:flutter/foundation.dart';

import '../data/models/brewing.dart';
import '../data/models/flavor_profile.dart';
import '../data/models/tea.dart';
import '../data/repositories/tea_repository.dart';

/// State-Provider für die Tee-Bibliothek und Detailansicht.
class TeaProvider extends ChangeNotifier {
  final TeaRepository _repo;

  TeaProvider(this._repo);

  List<Tea> _teas = [];
  TeaWithDetails? _selected;
  bool _isLoading = false;
  String? _error;

  bool _ownedOnly = false;
  bool _favoritesOnly = false;
  String? _typeFilter;
  String _searchQuery = '';

  List<Tea> get teas => List.unmodifiable(_teas);
  TeaWithDetails? get selected => _selected;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get ownedOnly => _ownedOnly;
  bool get favoritesOnly => _favoritesOnly;
  String? get typeFilter => _typeFilter;
  String get searchQuery => _searchQuery;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _teas = await _repo.getAll(
        ownedOnly: _ownedOnly ? true : null,
        favoritesOnly: _favoritesOnly ? true : null,
        type: _typeFilter,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectTea(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _selected = await _repo.getWithDetails(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelection() {
    _selected = null;
    notifyListeners();
  }

  Future<void> setOwnedOnly(bool value) async {
    if (_ownedOnly == value) return;
    _ownedOnly = value;
    await loadAll();
  }

  Future<void> setFavoritesOnly(bool value) async {
    if (_favoritesOnly == value) return;
    _favoritesOnly = value;
    await loadAll();
  }

  Future<void> setTypeFilter(String? type) async {
    if (_typeFilter == type) return;
    _typeFilter = type;
    await loadAll();
  }

  Future<void> setSearchQuery(String query) async {
    final trimmed = query.trim();
    if (_searchQuery == trimmed) return;
    _searchQuery = trimmed;
    await loadAll();
  }

  Future<int?> addTea(Tea tea) async {
    try {
      final id = await _repo.insert(tea);
      await loadAll();
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<int?> addTeaWithDetails({
    required Tea tea,
    FlavorProfile? flavorProfile,
    List<FlavorProfileAromaTag> aromaTags = const [],
    List<String> tagNames = const [],
    List<BrewingVariantWithDetails> brewingVariants = const [],
  }) async {
    try {
      final id = await _repo.createWithDetails(
        tea: tea,
        flavorProfile: flavorProfile,
        aromaTags: aromaTags,
        tagNames: tagNames,
        brewingVariants: brewingVariants,
      );
      await loadAll();
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateTea(Tea tea) async {
    try {
      await _repo.update(tea);
      await loadAll();
      if (_selected?.tea.id == tea.id) {
        await selectTea(tea.id!);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTea(int id) async {
    try {
      await _repo.delete(id);
      if (_selected?.tea.id == id) _selected = null;
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleFavorite(int id) async {
    // Optimistisches UI-Update für Listen-Performance
    final idx = _teas.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      _teas[idx] = _teas[idx].copyWith(isFavorite: !_teas[idx].isFavorite);
      notifyListeners();
    }
    try {
      await _repo.toggleFavorite(id);
    } catch (e) {
      // Rollback bei Fehler
      _error = e.toString();
      await loadAll();
    }
  }

  Future<bool> setDefaultBrewingVariant(int variantId) async {
    try {
      await _repo.setDefaultVariant(variantId);
      if (_selected != null) {
        await selectTea(_selected!.tea.id!);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addBrewingVariant(
      int teaId, BrewingVariantWithDetails details) async {
    try {
      await _repo.addBrewingVariant(teaId, details);
      if (_selected?.tea.id == teaId) {
        await selectTea(teaId);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> setTags(int teaId, List<String> tagNames) async {
    try {
      await _repo.setTags(teaId, tagNames);
      if (_selected?.tea.id == teaId) {
        await selectTea(teaId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
