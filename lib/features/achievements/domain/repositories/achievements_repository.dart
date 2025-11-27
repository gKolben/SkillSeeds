import '../../../../core/models/achievement.dart';

/// Interface de repositório para a entidade Achievement.
///
/// O repositório define as operações de acesso e sincronização de dados,
/// separando a lógica de persistência da lógica de negócio.
/// Utilizar interfaces facilita a troca de implementações (ex.: local, remota)
/// e torna o código mais testável e modular.
///
/// ⚠️ Dicas práticas:
/// - Garanta que `Achievement` possua `toMap`/`fromMap` se for serializar.
/// - Em implementações assíncronas, trate erros e registre logs para debug.
/// - Para testes, crie mocks da interface e valide os fluxos de sync/cache.
abstract class AchievementsRepository {
  // -------------------------------------------------------
  // Render inicial e cache
  // -------------------------------------------------------

  /// Render inicial rápido a partir do cache local.
  ///
  /// Retorna uma lista de `Achievement` disponível no cache local.
  /// Use este método para exibir conteúdo imediatamente na UI antes
  /// de aguardar uma sincronização com o servidor.
  Future<List<Achievement>> loadFromCache();

  // -------------------------------------------------------
  // Sincronização
  // -------------------------------------------------------

  /// Sincronização incremental (>= lastSync). Retorna quantos registros mudaram.
  ///
  /// Deve realizar uma chamada ao datasource remoto (ex.: Supabase/API)
  /// trazendo apenas os registros atualizados desde o último `sync`.
  /// Ao implementar, retorne o número de registros que foram inseridos/atualizados.
  Future<int> syncFromServer();

  // -------------------------------------------------------
  // Listagens
  // -------------------------------------------------------

  /// Listagem completa (normalmente do cache após sync).
  ///
  /// Retorna todos os `Achievement` disponíveis para exibição.
  Future<List<Achievement>> listAll();

  /// Destaques (filtrados do cache por `featured`).
  ///
  /// Retorna os achievements marcados como destaque para exposição em UI.
  Future<List<Achievement>> listFeatured();

  // -------------------------------------------------------
  // Recuperação direta
  // -------------------------------------------------------

  /// Opcional: busca direta por ID no cache.
  ///
  /// Retorna `null` se o `Achievement` não for encontrado no cache.
  Future<Achievement?> getById(int id);
}

/*
// Exemplo de uso (em comentário):

// final repo = MinhaImplementacaoDeAchievementsRepository();
// final cached = await repo.loadFromCache();
// final changed = await repo.syncFromServer();
// final all = await repo.listAll();

// Dicas para implementação:
// - Implemente usando um DAO local (cache) e um remote datasource (API/Supabase).
// - Para testes unitários, crie um mock que implementa AchievementsRepository.
// - Garanta que a entidade Achievement trate formatos diferentes (id string/int, datas etc.).

*/
