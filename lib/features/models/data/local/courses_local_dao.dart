import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../dtos/course_dto.dart';

class CoursesLocalDaoJson {
  static const _cacheKey = 'courses_cache_v1';

  List<CourseDto>? _cache;

  Future<List<CourseDto>> _loadFromAsset() async {
    final raw = await rootBundle.loadString('assets/data/courses_seed.json');
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    return list.map((e) => CourseDto.fromJson(e)).toList();
  }

  Future<void> _saveCache(List<CourseDto> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, encoded);
  }

  Future<List<CourseDto>> _loadFromCacheOrAsset() async {
    if (_cache != null) return _cache!;
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cached) as List<dynamic>;
        _cache = decoded.map((e) => CourseDto.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        return _cache!;
      } catch (_) {
        // fallback to asset
      }
    }
    final fromAsset = await _loadFromAsset();
    _cache = fromAsset;
    return _cache!;
  }

  /// Lista cursos aplicando filtros simples (q) e paginação.
  Future<List<CourseDto>> listAll({
    Map<String, dynamic>? filters,
    int page = 1,
    int pageSize = 20,
    String sortBy = 'name',
    String sortDir = 'asc',
    List<String>? include,
  }) async {
    final all = await _loadFromCacheOrAsset();
    var filtered = all;

    // filtro 'q' simples buscando por nome e descricao
    final q = filters != null && filters['q'] != null ? (filters['q'] as String).toLowerCase() : null;
    if (q != null && q.isNotEmpty) {
      filtered = filtered.where((c) {
        final name = c.name.toLowerCase();
        final desc = (c.descricao ?? '').toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList();
    }

    // filtro por status
    if (filters != null && filters['status'] != null) {
      final s = (filters['status'] as String).toLowerCase();
      filtered = filtered.where((c) => (c.status ?? '').toLowerCase() == s).toList();
    }

    // sort
    filtered.sort((a, b) {
      final aVal = _getSortValue(a, sortBy);
      final bVal = _getSortValue(b, sortBy);
      if (aVal == null && bVal == null) return 0;
      if (aVal == null) return sortDir == 'asc' ? -1 : 1;
      if (bVal == null) return sortDir == 'asc' ? 1 : -1;
      if (aVal is num && bVal is num) {
        return sortDir == 'asc'
            ? (aVal).compareTo(bVal)
            : (bVal).compareTo(aVal);
      }
      return sortDir == 'asc' ? aVal.toString().compareTo(bVal.toString()) : bVal.toString().compareTo(aVal.toString());
    });

    // pagination (page, pageSize)
    final start = (page - 1) * pageSize;
    if (start >= filtered.length) return <CourseDto>[];
    final end = (start + pageSize) > filtered.length ? filtered.length : start + pageSize;
    return filtered.sublist(start, end);
  }

  dynamic _getSortValue(CourseDto c, String sortBy) {
    switch (sortBy) {
      case 'name':
        return c.name;
      case 'rating':
        return c.rating ?? 0;
      case 'createdAt':
        return c.createdAt?.millisecondsSinceEpoch ?? 0;
      default:
        return c.name;
    }
  }

  /// Substitui todo o conjunto local (upsertAll)
  Future<void> upsertAll(List<CourseDto> items) async {
    _cache = List<CourseDto>.from(items);
    await _saveCache(_cache!);
  }

  /// Insere ou atualiza um item individual no cache/local storage.
  Future<void> upsert(CourseDto item) async {
    final list = await _loadFromCacheOrAsset();
    final idx = list.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      list[idx] = item;
    } else {
      list.add(item);
    }
    _cache = List<CourseDto>.from(list);
    await _saveCache(_cache!);
  }

  /// Limpa o cache local
  Future<void> clear() async {
    _cache = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  /// Remove um curso pelo `id` do cache/local storage.
  ///
  /// Se o item existir, é removido e o cache é salvo. Não lança se o item
  /// não for encontrado — simplesmente persiste o estado atual.
  Future<void> remove(String id) async {
    final list = await _loadFromCacheOrAsset();
    final idx = list.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      list.removeAt(idx);
      _cache = List<CourseDto>.from(list);
      await _saveCache(_cache!);
    } else {
      // garante que o cache esteja definido mesmo se o item não existir
      _cache = List<CourseDto>.from(list);
    }
  }
}
