import 'package:flutter/foundation.dart';

import '../models/enums.dart';
import '../models/infusion.dart';
import '../models/session.dart';
import '../repositories/session_repository.dart';

/// State-Management für Sessions.
class SessionProvider extends ChangeNotifier {
  final SessionRepository _repo;
  SessionProvider(this._repo);

  List<Session> _sessions = [];
  Session? _activeSession;
  bool _loading = false;
  String? _error;

  List<Session> get sessions => List.unmodifiable(_sessions);
  Session? get activeSession => _activeSession;
  bool get loading => _loading;
  String? get error => _error;

  Session? byId(String id) {
    for (final s in _sessions) {
      if (s.id == id) return s;
    }
    return null;
  }

  // ---------------- Load ----------------

  Future<void> loadAll({int? limit, int? offset}) async {
    _setLoading(true);
    try {
      _sessions = await _repo.getAll(limit: limit, offset: offset);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadByTea(String teaId) async {
    _setLoading(true);
    try {
      _sessions = await _repo.getByTeaId(teaId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadActive() async {
    _setLoading(true);
    try {
      final active = await _repo.getByStatus(SessionStatus.active);
      _activeSession = active.isEmpty ? null : active.first;
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
      _sessions.removeWhere((s) => s.id == id);
      if (_activeSession?.id == id) _activeSession = null;
    } else {
      final i = _sessions.indexWhere((s) => s.id == id);
      if (i >= 0) {
        _sessions[i] = updated;
      } else {
        _sessions.insert(0, updated);
      }
      if (_activeSession?.id == id) _activeSession = updated;
    }
    notifyListeners();
  }

  // ---------------- Lifecycle ----------------

  Future<Session> startFromVariant({
    required String teaId,
    required String variantId,
    SessionType sessionType = SessionType.simple,
  }) async {
    final s = await _repo.startFromVariant(
      teaId: teaId,
      variantId: variantId,
      sessionType: sessionType,
    );
    _activeSession = s;
    _sessions.insert(0, s);
    notifyListeners();
    return s;
  }

  Future<Session> startManual(Session draft) async {
    final s = await _repo.startManual(draft: draft);
    _activeSession = s;
    _sessions.insert(0, s);
    notifyListeners();
    return s;
  }

  Future<void> update(Session s) async {
    await _repo.update(s);
    await refresh(s.id);
  }

  Future<void> complete(String id) async {
    await _repo.complete(id);
    if (_activeSession?.id == id) _activeSession = null;
    await refresh(id);
  }

  Future<void> discard(String id) async {
    await _repo.discard(id);
    if (_activeSession?.id == id) _activeSession = null;
    await refresh(id);
  }

  Future<void> markInterrupted(String id) async {
    await _repo.markInterrupted(id);
    await refresh(id);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _sessions.removeWhere((s) => s.id == id);
    if (_activeSession?.id == id) _activeSession = null;
    notifyListeners();
  }

  // ---------------- Infusions ----------------

  Future<Infusion> addInfusion(Infusion infusion) async {
    final created = await _repo.addInfusion(infusion);
    await refresh(infusion.sessionId);
    return created;
  }

  Future<void> updateInfusion(Infusion infusion) async {
    await _repo.updateInfusion(infusion);
    await refresh(infusion.sessionId);
  }

  Future<void> removeInfusion(String sessionId, String infusionId) async {
    await _repo.removeInfusion(infusionId);
    await refresh(sessionId);
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
