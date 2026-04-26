import 'package:uuid/uuid.dart';

import '../dao/aroma_tag_dao.dart';
import '../dao/tea_tag_dao.dart';
import '../dao/texture_tag_dao.dart';
import '../models/enums.dart';
import '../models/tags.dart';

/// Verwaltet die drei Tag-Master-Tabellen einheitlich.
class TagRepository {
  final TeaTagDao _teaTagDao;
  final AromaTagDao _aromaTagDao;
  final TextureTagDao _textureTagDao;
  final Uuid _uuid;

  TagRepository(
    this._teaTagDao,
    this._aromaTagDao,
    this._textureTagDao, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  // ---------- TeaTag ----------

  Future<List<TeaTag>> getAllTeaTags() => _teaTagDao.getAll();
  Future<TeaTag?> getTeaTag(String id) => _teaTagDao.getById(id);

  Future<TeaTag> createTeaTag(String name) async {
    final tag = TeaTag(id: _uuid.v4(), name: name);
    await _teaTagDao.insert(tag);
    return tag;
  }

  Future<void> updateTeaTag(TeaTag tag) => _teaTagDao.update(tag);
  Future<void> deleteTeaTag(String id) => _teaTagDao.delete(id);

  // ---------- AromaTag ----------

  Future<List<AromaTag>> getAllAromaTags() => _aromaTagDao.getAll();
  Future<List<AromaTag>> getAromaTagsByCategory(AromaCategory c) =>
      _aromaTagDao.getByCategory(c);
  Future<List<AromaTag>> getAromaTagsByIds(List<String> ids) =>
      _aromaTagDao.getByIds(ids);

  Future<AromaTag> createAromaTag(String name, AromaCategory category) async {
    final tag = AromaTag(id: _uuid.v4(), name: name, category: category);
    await _aromaTagDao.insert(tag);
    return tag;
  }

  Future<void> updateAromaTag(AromaTag tag) => _aromaTagDao.update(tag);
  Future<void> deleteAromaTag(String id) => _aromaTagDao.delete(id);

  // ---------- TextureTag ----------

  Future<List<TextureTag>> getAllTextureTags() => _textureTagDao.getAll();
  Future<TextureTag?> getTextureTag(String id) => _textureTagDao.getById(id);

  Future<TextureTag> createTextureTag(String name) async {
    final tag = TextureTag(id: _uuid.v4(), name: name);
    await _textureTagDao.insert(tag);
    return tag;
  }

  Future<void> updateTextureTag(TextureTag tag) =>
      _textureTagDao.update(tag);
  Future<void> deleteTextureTag(String id) => _textureTagDao.delete(id);
}
