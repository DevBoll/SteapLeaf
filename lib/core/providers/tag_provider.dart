import 'package:flutter/foundation.dart';

import '../models/enums.dart';
import '../models/tags.dart';
import '../repositories/tag_repository.dart';

/// State-Management für die drei Tag-Tabellen.
class TagProvider extends ChangeNotifier {
  final TagRepository _repo;
  TagProvider(this._repo);

  List<TeaTag> _teaTags = [];
  List<AromaTag> _aromaTags = [];
  List<TextureTag> _textureTags = [];
  bool _loading = false;
  String? _error;

  List<TeaTag> get teaTags => List.unmodifiable(_teaTags);
  List<AromaTag> get aromaTags => List.unmodifiable(_aromaTags);
  List<TextureTag> get textureTags => List.unmodifiable(_textureTags);
  bool get loading => _loading;
  String? get error => _error;

  List<AromaTag> aromaTagsByCategory(AromaCategory c) =>
      _aromaTags.where((t) => t.category == c).toList(growable: false);

  // ---------------- Load ----------------

  Future<void> loadAll() async {
    _setLoading(true);
    try {
      final results = await Future.wait([
        _repo.getAllTeaTags(),
        _repo.getAllAromaTags(),
        _repo.getAllTextureTags(),
      ]);
      _teaTags = results[0] as List<TeaTag>;
      _aromaTags = results[1] as List<AromaTag>;
      _textureTags = results[2] as List<TextureTag>;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- TeaTag ----------------

  Future<TeaTag> createTeaTag(String name) async {
    final tag = await _repo.createTeaTag(name);
    _teaTags = [..._teaTags, tag]
      ..sort((a, b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
    return tag;
  }

  Future<void> updateTeaTag(TeaTag tag) async {
    await _repo.updateTeaTag(tag);
    final i = _teaTags.indexWhere((t) => t.id == tag.id);
    if (i >= 0) _teaTags[i] = tag;
    notifyListeners();
  }

  Future<void> deleteTeaTag(String id) async {
    await _repo.deleteTeaTag(id);
    _teaTags.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ---------------- AromaTag ----------------

  Future<AromaTag> createAromaTag(String name, AromaCategory category) async {
    final tag = await _repo.createAromaTag(name, category);
    _aromaTags = [..._aromaTags, tag]
      ..sort((a, b) {
        final c = a.category.index.compareTo(b.category.index);
        if (c != 0) return c;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    notifyListeners();
    return tag;
  }

  Future<void> updateAromaTag(AromaTag tag) async {
    await _repo.updateAromaTag(tag);
    final i = _aromaTags.indexWhere((t) => t.id == tag.id);
    if (i >= 0) _aromaTags[i] = tag;
    notifyListeners();
  }

  Future<void> deleteAromaTag(String id) async {
    await _repo.deleteAromaTag(id);
    _aromaTags.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ---------------- TextureTag ----------------

  Future<TextureTag> createTextureTag(String name) async {
    final tag = await _repo.createTextureTag(name);
    _textureTags = [..._textureTags, tag]
      ..sort((a, b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
    return tag;
  }

  Future<void> updateTextureTag(TextureTag tag) async {
    await _repo.updateTextureTag(tag);
    final i = _textureTags.indexWhere((t) => t.id == tag.id);
    if (i >= 0) _textureTags[i] = tag;
    notifyListeners();
  }

  Future<void> deleteTextureTag(String id) async {
    await _repo.deleteTextureTag(id);
    _textureTags.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
