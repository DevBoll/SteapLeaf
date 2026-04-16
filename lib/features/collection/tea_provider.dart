import 'package:flutter/foundation.dart';
import '../../domain/enums/enums.dart';
import '../../domain/models/tea.dart';
import '../../domain/repositories/tea_repository.dart';

class TeaProvider extends ChangeNotifier {
  final TeaRepository _repository;

  TeaProvider(this._repository);

  List<Tea> _teas = [];
  bool _loading = false;
  String _search = '';
  TeaType? _filterType;
  bool _filterFavorites = false;
  bool? _filterInStock;

  // Getters

  List<Tea> get teas => _teas;
  bool get loading => _loading;
  String get search => _search;
  TeaType? get filterType => _filterType;
  bool get filterFavorites => _filterFavorites;
  bool? get filterInStock => _filterInStock;

  /// Alle Tees nach aktiven Filtern und Suchbegriff gefiltert.
  List<Tea> get filteredTeas {
    var result = _teas;

    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result
          .where((t) =>
              t.name.toLowerCase().contains(q) ||
              (t.origin?.toLowerCase().contains(q) ?? false) ||
              (t.vendor?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    if (_filterType != null) {
      result = result.where((t) => t.type == _filterType).toList();
    }

    if (_filterFavorites) {
      result = result.where((t) => t.isFavorite).toList();
    }

    if (_filterInStock != null) {
      result = result.where((t) => t.inStock == _filterInStock).toList();
    }

    return result;
  }

  Tea? get lastUsedTea => _teas.isNotEmpty ? _teas.first : null;

  Tea? getById(String id) =>
      _teas.where((t) => t.id == id).firstOrNull;
 
  // Laden

  Future<void> loadAll() async {
    _loading = true;
    notifyListeners();
    try {
      _teas = await _repository.getAll();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Filter

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setFilterType(TeaType? type) {
    _filterType = type;
    notifyListeners();
  }

  void setFilterFavorites(bool value) {
    _filterFavorites = value;
    notifyListeners();
  }

  void setFilterInStock(bool? value) {
    _filterInStock = value;
    notifyListeners();
  }

  void clearFilters() {
    _filterType = null;
    _filterFavorites = false;
    _filterInStock = null;
    _search = '';
    notifyListeners();
  }

  // CRUD

  Future<void> addTea(Tea tea) async {
    await _repository.save(tea);
    _teas = await _repository.getAll();
    notifyListeners();
  }

  Future<void> updateTea(Tea tea) async {
    await _repository.update(tea);
    final idx = _teas.indexWhere((t) => t.id == tea.id);
    if (idx != -1) {
      _teas[idx] = tea;
      notifyListeners();
    }
  }

  Future<void> deleteTea(String id) async {
    await _repository.delete(id);
    _teas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> toggleFavorite(Tea tea) async {
    await updateTea(tea.copyWith(isFavorite: !tea.isFavorite));
  }
}
