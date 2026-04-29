import 'package:flutter/foundation.dart';

import '../data/models/brewing.dart';
import '../data/models/enums.dart';
import '../data/models/flavor_profile.dart';
import '../data/models/session.dart';
import '../data/repositories/session_repository.dart';

class SessionProvider extends ChangeNotifier {
  final SessionRepository _repo;

  SessionProvider(this._repo);

  List<Session> _sessions = [];
  SessionWithDetails? _activeSession;
  bool _isLoading = false;
  String? _error;

  int? _teaFilter;
  SessionStatus? _statusFilter;
  SessionType? _typeFilter;

  List<Session> get sessions => List.unmodifiable(_sessions);
  SessionWithDetails? get activeSession => _activeSession;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int? get teaFilter => _teaFilter;
  SessionStatus? get statusFilter => _statusFilter;
  SessionType? get typeFilter => _typeFilter;


  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _sessions = await _repo.getAll(
        teaId: _teaFilter,
        status: _statusFilter,
        type: _typeFilter,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openSession(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _activeSession = await _repo.getWithDetails(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void closeActiveSession() {
    _activeSession = null;
    notifyListeners();
  }

  // =====================================================================
  // Filter
  // =====================================================================

  Future<void> setTeaFilter(int? teaId) async {
    if (_teaFilter == teaId) return;
    _teaFilter = teaId;
    await loadAll();
  }

  Future<void> setStatusFilter(SessionStatus? status) async {
    if (_statusFilter == status) return;
    _statusFilter = status;
    await loadAll();
  }

  Future<void> setTypeFilter(SessionType? type) async {
    if (_typeFilter == type) return;
    _typeFilter = type;
    await loadAll();
  }

  // =====================================================================
  // Mutations
  // =====================================================================

  Future<int?> addSession(Session session) async {
    try {
      final id = await _repo.insert(session);
      await loadAll();
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<int?> addSessionWithDetails({
    required Session session,
    BrewingParameters? parameters,
    List<BrewingStep> steps = const [],
    List<BrewingAdditive> additives = const [],
    FlavorProfile? flavorProfile,
    List<FlavorProfileAromaTag> aromaTags = const [],
    List<Infusion> infusions = const [],
  }) async {
    try {
      final id = await _repo.createWithDetails(
        session: session,
        parameters: parameters,
        steps: steps,
        additives: additives,
        flavorProfile: flavorProfile,
        aromaTags: aromaTags,
        infusions: infusions,
      );
      await loadAll();
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateSession(Session session) async {
    try {
      await _repo.update(session);
      await loadAll();
      if (_activeSession?.session.id == session.id) {
        await openSession(session.id!);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSession(int id) async {
    try {
      await _repo.delete(id);
      if (_activeSession?.session.id == id) _activeSession = null;
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // =====================================================================
  // Live-Session Workflow
  // =====================================================================

  Future<void> startActiveSession() async {
    final id = _activeSession?.session.id;
    if (id == null) return;
    await _repo.startSession(id);
    await openSession(id);
  }

  Future<void> completeActiveSession() async {
    final id = _activeSession?.session.id;
    if (id == null) return;
    await _repo.completeSession(id);
    await openSession(id);
    await loadAll();
  }

  Future<int?> addInfusionToActive({
    required int infusionIndex,
    bool isRinse = false,
    int? steepSeconds,
    DateTime? start,
    DateTime? end,
    double? rating,
    String? notes,
  }) async {
    final sessionId = _activeSession?.session.id;
    if (sessionId == null) return null;
    try {
      final id = await _repo.addInfusion(Infusion(
        sessionId: sessionId,
        infusionIndex: infusionIndex,
        isRinse: isRinse,
        steepSeconds: steepSeconds,
        start: start,
        end: end,
        rating: rating,
        notes: notes,
      ));
      await openSession(sessionId);
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
