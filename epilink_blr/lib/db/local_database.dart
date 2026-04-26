import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'local_database.g.dart';

class SymptomReportsTable extends Table {
  TextColumn get id => text()();
  TextColumn get wardId => text().nullable()();
  TextColumn get wardName => text().nullable()();
  IntColumn get timestamp => integer()();
  TextColumn get symptoms => text()();
  TextColumn get testResult => text().nullable()();
  RealColumn get testConfidence => real().nullable()();
  TextColumn get diseaseSuspected => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get locationSource => text().nullable()();
  TextColumn get placesApiName => text().nullable()();
  TextColumn get chwId => text().nullable()();
  IntColumn get synced => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class CivicHazardsTable extends Table {
  TextColumn get id => text()();
  TextColumn get wardId => text().nullable()();
  TextColumn get wardName => text().nullable()();
  IntColumn get timestamp => integer()();
  TextColumn get hazardType => text()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get reporterType => text().nullable()();
  TextColumn get locationSource => text().nullable()();
  TextColumn get placesApiName => text().nullable()();
  IntColumn get synced => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [SymptomReportsTable, CivicHazardsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Symptom Report Methods
  Future<int> insertSymptomReport(SymptomReportsTableCompanion report) =>
      into(symptomReportsTable).insert(report);

  Future<List<SymptomReportsTableData>> getUnsyncedSymptomReports() =>
      (select(symptomReportsTable)..where((t) => t.synced.equals(0))).get();

  Future markSymptomReportSynced(String id) =>
      (update(symptomReportsTable)..where((t) => t.id.equals(id)))
          .write(const SymptomReportsTableCompanion(synced: Value(1)));

  // Civic Hazard Methods
  Future<int> insertCivicHazard(CivicHazardsTableCompanion hazard) =>
      into(civicHazardsTable).insert(hazard);

  Future<List<CivicHazardsTableData>> getUnsyncedCivicHazards() =>
      (select(civicHazardsTable)..where((t) => t.synced.equals(0))).get();

  Future markCivicHazardSynced(String id) =>
      (update(civicHazardsTable)..where((t) => t.id.equals(id)))
          .write(const CivicHazardsTableCompanion(synced: Value(1)));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'epilink.sqlite'));
    return NativeDatabase(file);
  });
}
