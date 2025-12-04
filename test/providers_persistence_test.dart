import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/features/providers/data/providers_local_dao_shared_prefs.dart';
import 'package:skillseeds/features/providers/data/dtos/provider_dto.dart';

void main() {
  test('ProvidersLocalDaoSharedPrefs persists and reads back providers', () async {
    // Use mock initial values so SharedPreferences works in tests
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final dao = ProvidersLocalDaoSharedPrefs(prefs);

    final dto = ProviderDto(id: 'p1', name: 'Provider One', imageUrl: null, distanceKm: 1.2, updatedAt: DateTime.now());
    await dao.upsert(dto);

    // Create a new DAO instance simulating app restart (same prefs instance though)
    final dao2 = ProvidersLocalDaoSharedPrefs(prefs);
    final list = await dao2.listAll();

    expect(list.length, 1);
    expect(list.first.id, 'p1');
    expect(list.first.name, 'Provider One');
  });
}
