import 'package:flutter/foundation.dart';

import '../models/brewing_variant.dart';
import '../models/tea.dart';
import '../repositories/tea_repository.dart';

/// State-Management für die Tee-Sammlung.
class TeaProvider extends ChangeNotifier {
  final TeaRepository _repo;
  TeaProvider(this._repo);

  List<Tea> _teas = [];
  bool _loading = false;
  String? _error;

  List<Tea> get teas => List.unmodifiable(_teas);
  bool get loading => _loading;
  String? get error => _error;

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

  // ---------------- Load ----------------

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

  // ---------------- Mutations ----------------

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

  Future<void> toggleFavorite(String id) async {
    await _repo.toggleFavorite(id);
    await refresh(id);
  }

  Future<void> setOwned(String id, bool owned) async {
    await _repo.setOwned(id, owned);
    await refresh(id);
  }

  Future<void> setRating(String id, int rating) async {
    await _repo.setRating(id, rating);
    await refresh(id);
  }

  // ---------------- Brewing-Variants ----------------

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

  // ---------------- Helpers ----------------

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
