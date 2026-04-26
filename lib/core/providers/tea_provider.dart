import 'package:flutter/foundation.dart';

import '../models/brewing_variant.dart';
import '../models/enums.dart';
import '../models/tea.dart';
import '../repositories/tea_repository.dart';

enum TeaSortOrder { byName, byRating, byNewest }

/// State-Management für die Tee-Sammlung.
class TeaProvider extends ChangeNotifier {
  final TeaRepository _repo;
  TeaProvider(this._repo);

  List<Tea> _teas = [];
  bool _loading = false;
  String? _error;
  TeaSortOrder _sortOrder = TeaSortOrder.byName;
  String _searchQuery = '';
  TeaType? _filterType;
  bool _filterFavorites = false;
  bool? _filterInStock;

  TeaSortOrder get sortOrder => _sortOrder;
  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  TeaType? get filterType => _filterType;
  bool get filterFavorites => _filterFavorites;
  bool? get filterInStock => _filterInStock;

  List<Tea> get teas {
    final query = _searchQuery.toLowerCase().trim();
    var filtered = query.isEmpty
        ? _teas
        : _teas.where((t) {
            return t.name.toLowerCase().contains(query) ||
                t.origin.toLowerCase().contains(query) ||
                t.vendor.toLowerCase().contains(query) ||
                t.tags.any((tag) => tag.name.toLowerCase().contains(query));
          }).toList();


     if (_filterType != null) {
      filtered = filtered.where((t) => t.type == _filterType).toList();
    }

    if (_filterFavorites) {
      filtered = filtered.where((t) => t.isFavorite).toList();
    }

    if (_filterInStock != null) {
      filtered = filtered.where((t) => t.isOwned == _filterInStock).toList();
    }

    final sorted = [...filtered];
    switch (_sortOrder) {
      case TeaSortOrder.byName:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case TeaSortOrder.byRating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
      case TeaSortOrder.byNewest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return List.unmodifiable(sorted);
  }

  void setSortOrder(TeaSortOrder order) {
    if (_sortOrder == order) return;
    _sortOrder = order;
    notifyListeners();
  }

  void setSearch(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    notifyListeners();
  }

 void setFilterType(TeaType? type) {
  if (_filterType == type) return;
    _filterType = type;
    notifyListeners();
  }

  void setFilterFavorites(bool value) {
     if (_filterFavorites == value) return;
    _filterFavorites = value;
    notifyListeners();
  }

  void setFilterInStock(bool? value) {
     if (_filterInStock == value) return;
    _filterInStock = value;
    notifyListeners();
  }

  void clearFilters() {
    _filterType = null;
    _filterFavorites = false;
    _filterInStock = false;
    _searchQuery = '';
    notifyListeners();
  }



  List<Tea> get favorites =>
      _teas.where((t) => t.isFavorite).toList(growable: false);
  List<Tea> get owned =>
      _teas.where((t) => t.isOwned).toList(growable: false);

  Tea? byId(String id) {
    for (final t in _teas) {
      if (t.id == id) return t;
    }
    return null;
  }

  // Load

  Future<void> loadAll() async {
    _setLoading(true);
    try {
      _teas = await _repo.getAll();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh(String id) async {
    final updated = await _repo.getById(id);
    if (updated == null) {
      _teas.removeWhere((t) => t.id == id);
    } else {
      final i = _teas.indexWhere((t) => t.id == id);
      if (i >= 0) {
        _teas[i] = updated;
      } else {
        _teas.add(updated);
      }
    }
    notifyListeners();
  }

  // Mutations

  Future<Tea> create(Tea tea) async {
    final created = await _repo.create(tea);
    // Komplett laden, damit Tags / Variants drinhängen
    await refresh(created.id);
    return byId(created.id) ?? created;
  }

  Future<void> update(Tea tea) async {
    await _repo.update(tea);
    await refresh(tea.id);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _teas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Brewing-Variants

  Future<void> addVariant(BrewingVariant v) async {
    await _repo.addVariant(v);
    await refresh(v.teaId);
  }

  Future<void> updateVariant(BrewingVariant v) async {
    await _repo.updateVariant(v);
    await refresh(v.teaId);
  }

  Future<void> removeVariant(String teaId, String variantId) async {
    await _repo.removeVariant(variantId);
    await refresh(teaId);
  }

  Future<void> setDefaultVariant(String teaId, String variantId) async {
    await _repo.setDefaultVariant(variantId, teaId);
    await refresh(teaId);
  }

  // Helpers 

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
 
}
