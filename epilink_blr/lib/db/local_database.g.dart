// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $SymptomReportsTableTable extends SymptomReportsTable
    with TableInfo<$SymptomReportsTableTable, SymptomReportsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomReportsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wardIdMeta = const VerificationMeta('wardId');
  @override
  late final GeneratedColumn<String> wardId = GeneratedColumn<String>(
      'ward_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _wardNameMeta =
      const VerificationMeta('wardName');
  @override
  late final GeneratedColumn<String> wardName = GeneratedColumn<String>(
      'ward_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _symptomsMeta =
      const VerificationMeta('symptoms');
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
      'symptoms', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testResultMeta =
      const VerificationMeta('testResult');
  @override
  late final GeneratedColumn<String> testResult = GeneratedColumn<String>(
      'test_result', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _testConfidenceMeta =
      const VerificationMeta('testConfidence');
  @override
  late final GeneratedColumn<double> testConfidence = GeneratedColumn<double>(
      'test_confidence', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _diseaseSuspectedMeta =
      const VerificationMeta('diseaseSuspected');
  @override
  late final GeneratedColumn<String> diseaseSuspected = GeneratedColumn<String>(
      'disease_suspected', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
      'lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
      'lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _locationSourceMeta =
      const VerificationMeta('locationSource');
  @override
  late final GeneratedColumn<String> locationSource = GeneratedColumn<String>(
      'location_source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _placesApiNameMeta =
      const VerificationMeta('placesApiName');
  @override
  late final GeneratedColumn<String> placesApiName = GeneratedColumn<String>(
      'places_api_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chwIdMeta = const VerificationMeta('chwId');
  @override
  late final GeneratedColumn<String> chwId = GeneratedColumn<String>(
      'chw_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<int> synced = GeneratedColumn<int>(
      'synced', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        wardId,
        wardName,
        timestamp,
        symptoms,
        testResult,
        testConfidence,
        diseaseSuspected,
        lat,
        lng,
        locationSource,
        placesApiName,
        chwId,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_reports_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SymptomReportsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ward_id')) {
      context.handle(_wardIdMeta,
          wardId.isAcceptableOrUnknown(data['ward_id']!, _wardIdMeta));
    }
    if (data.containsKey('ward_name')) {
      context.handle(_wardNameMeta,
          wardName.isAcceptableOrUnknown(data['ward_name']!, _wardNameMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('symptoms')) {
      context.handle(_symptomsMeta,
          symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta));
    } else if (isInserting) {
      context.missing(_symptomsMeta);
    }
    if (data.containsKey('test_result')) {
      context.handle(
          _testResultMeta,
          testResult.isAcceptableOrUnknown(
              data['test_result']!, _testResultMeta));
    }
    if (data.containsKey('test_confidence')) {
      context.handle(
          _testConfidenceMeta,
          testConfidence.isAcceptableOrUnknown(
              data['test_confidence']!, _testConfidenceMeta));
    }
    if (data.containsKey('disease_suspected')) {
      context.handle(
          _diseaseSuspectedMeta,
          diseaseSuspected.isAcceptableOrUnknown(
              data['disease_suspected']!, _diseaseSuspectedMeta));
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    }
    if (data.containsKey('lng')) {
      context.handle(
          _lngMeta, lng.isAcceptableOrUnknown(data['lng']!, _lngMeta));
    }
    if (data.containsKey('location_source')) {
      context.handle(
          _locationSourceMeta,
          locationSource.isAcceptableOrUnknown(
              data['location_source']!, _locationSourceMeta));
    }
    if (data.containsKey('places_api_name')) {
      context.handle(
          _placesApiNameMeta,
          placesApiName.isAcceptableOrUnknown(
              data['places_api_name']!, _placesApiNameMeta));
    }
    if (data.containsKey('chw_id')) {
      context.handle(
          _chwIdMeta, chwId.isAcceptableOrUnknown(data['chw_id']!, _chwIdMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SymptomReportsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomReportsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      wardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ward_id']),
      wardName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ward_name']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      symptoms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptoms'])!,
      testResult: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}test_result']),
      testConfidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}test_confidence']),
      diseaseSuspected: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}disease_suspected']),
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat']),
      lng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lng']),
      locationSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_source']),
      placesApiName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}places_api_name']),
      chwId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chw_id']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $SymptomReportsTableTable createAlias(String alias) {
    return $SymptomReportsTableTable(attachedDatabase, alias);
  }
}

class SymptomReportsTableData extends DataClass
    implements Insertable<SymptomReportsTableData> {
  final String id;
  final String? wardId;
  final String? wardName;
  final int timestamp;
  final String symptoms;
  final String? testResult;
  final double? testConfidence;
  final String? diseaseSuspected;
  final double? lat;
  final double? lng;
  final String? locationSource;
  final String? placesApiName;
  final String? chwId;
  final int synced;
  const SymptomReportsTableData(
      {required this.id,
      this.wardId,
      this.wardName,
      required this.timestamp,
      required this.symptoms,
      this.testResult,
      this.testConfidence,
      this.diseaseSuspected,
      this.lat,
      this.lng,
      this.locationSource,
      this.placesApiName,
      this.chwId,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || wardId != null) {
      map['ward_id'] = Variable<String>(wardId);
    }
    if (!nullToAbsent || wardName != null) {
      map['ward_name'] = Variable<String>(wardName);
    }
    map['timestamp'] = Variable<int>(timestamp);
    map['symptoms'] = Variable<String>(symptoms);
    if (!nullToAbsent || testResult != null) {
      map['test_result'] = Variable<String>(testResult);
    }
    if (!nullToAbsent || testConfidence != null) {
      map['test_confidence'] = Variable<double>(testConfidence);
    }
    if (!nullToAbsent || diseaseSuspected != null) {
      map['disease_suspected'] = Variable<String>(diseaseSuspected);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || locationSource != null) {
      map['location_source'] = Variable<String>(locationSource);
    }
    if (!nullToAbsent || placesApiName != null) {
      map['places_api_name'] = Variable<String>(placesApiName);
    }
    if (!nullToAbsent || chwId != null) {
      map['chw_id'] = Variable<String>(chwId);
    }
    map['synced'] = Variable<int>(synced);
    return map;
  }

  SymptomReportsTableCompanion toCompanion(bool nullToAbsent) {
    return SymptomReportsTableCompanion(
      id: Value(id),
      wardId:
          wardId == null && nullToAbsent ? const Value.absent() : Value(wardId),
      wardName: wardName == null && nullToAbsent
          ? const Value.absent()
          : Value(wardName),
      timestamp: Value(timestamp),
      symptoms: Value(symptoms),
      testResult: testResult == null && nullToAbsent
          ? const Value.absent()
          : Value(testResult),
      testConfidence: testConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(testConfidence),
      diseaseSuspected: diseaseSuspected == null && nullToAbsent
          ? const Value.absent()
          : Value(diseaseSuspected),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      locationSource: locationSource == null && nullToAbsent
          ? const Value.absent()
          : Value(locationSource),
      placesApiName: placesApiName == null && nullToAbsent
          ? const Value.absent()
          : Value(placesApiName),
      chwId:
          chwId == null && nullToAbsent ? const Value.absent() : Value(chwId),
      synced: Value(synced),
    );
  }

  factory SymptomReportsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomReportsTableData(
      id: serializer.fromJson<String>(json['id']),
      wardId: serializer.fromJson<String?>(json['wardId']),
      wardName: serializer.fromJson<String?>(json['wardName']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      testResult: serializer.fromJson<String?>(json['testResult']),
      testConfidence: serializer.fromJson<double?>(json['testConfidence']),
      diseaseSuspected: serializer.fromJson<String?>(json['diseaseSuspected']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      locationSource: serializer.fromJson<String?>(json['locationSource']),
      placesApiName: serializer.fromJson<String?>(json['placesApiName']),
      chwId: serializer.fromJson<String?>(json['chwId']),
      synced: serializer.fromJson<int>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wardId': serializer.toJson<String?>(wardId),
      'wardName': serializer.toJson<String?>(wardName),
      'timestamp': serializer.toJson<int>(timestamp),
      'symptoms': serializer.toJson<String>(symptoms),
      'testResult': serializer.toJson<String?>(testResult),
      'testConfidence': serializer.toJson<double?>(testConfidence),
      'diseaseSuspected': serializer.toJson<String?>(diseaseSuspected),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'locationSource': serializer.toJson<String?>(locationSource),
      'placesApiName': serializer.toJson<String?>(placesApiName),
      'chwId': serializer.toJson<String?>(chwId),
      'synced': serializer.toJson<int>(synced),
    };
  }

  SymptomReportsTableData copyWith(
          {String? id,
          Value<String?> wardId = const Value.absent(),
          Value<String?> wardName = const Value.absent(),
          int? timestamp,
          String? symptoms,
          Value<String?> testResult = const Value.absent(),
          Value<double?> testConfidence = const Value.absent(),
          Value<String?> diseaseSuspected = const Value.absent(),
          Value<double?> lat = const Value.absent(),
          Value<double?> lng = const Value.absent(),
          Value<String?> locationSource = const Value.absent(),
          Value<String?> placesApiName = const Value.absent(),
          Value<String?> chwId = const Value.absent(),
          int? synced}) =>
      SymptomReportsTableData(
        id: id ?? this.id,
        wardId: wardId.present ? wardId.value : this.wardId,
        wardName: wardName.present ? wardName.value : this.wardName,
        timestamp: timestamp ?? this.timestamp,
        symptoms: symptoms ?? this.symptoms,
        testResult: testResult.present ? testResult.value : this.testResult,
        testConfidence:
            testConfidence.present ? testConfidence.value : this.testConfidence,
        diseaseSuspected: diseaseSuspected.present
            ? diseaseSuspected.value
            : this.diseaseSuspected,
        lat: lat.present ? lat.value : this.lat,
        lng: lng.present ? lng.value : this.lng,
        locationSource:
            locationSource.present ? locationSource.value : this.locationSource,
        placesApiName:
            placesApiName.present ? placesApiName.value : this.placesApiName,
        chwId: chwId.present ? chwId.value : this.chwId,
        synced: synced ?? this.synced,
      );
  SymptomReportsTableData copyWithCompanion(SymptomReportsTableCompanion data) {
    return SymptomReportsTableData(
      id: data.id.present ? data.id.value : this.id,
      wardId: data.wardId.present ? data.wardId.value : this.wardId,
      wardName: data.wardName.present ? data.wardName.value : this.wardName,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      testResult:
          data.testResult.present ? data.testResult.value : this.testResult,
      testConfidence: data.testConfidence.present
          ? data.testConfidence.value
          : this.testConfidence,
      diseaseSuspected: data.diseaseSuspected.present
          ? data.diseaseSuspected.value
          : this.diseaseSuspected,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      locationSource: data.locationSource.present
          ? data.locationSource.value
          : this.locationSource,
      placesApiName: data.placesApiName.present
          ? data.placesApiName.value
          : this.placesApiName,
      chwId: data.chwId.present ? data.chwId.value : this.chwId,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomReportsTableData(')
          ..write('id: $id, ')
          ..write('wardId: $wardId, ')
          ..write('wardName: $wardName, ')
          ..write('timestamp: $timestamp, ')
          ..write('symptoms: $symptoms, ')
          ..write('testResult: $testResult, ')
          ..write('testConfidence: $testConfidence, ')
          ..write('diseaseSuspected: $diseaseSuspected, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('locationSource: $locationSource, ')
          ..write('placesApiName: $placesApiName, ')
          ..write('chwId: $chwId, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      wardId,
      wardName,
      timestamp,
      symptoms,
      testResult,
      testConfidence,
      diseaseSuspected,
      lat,
      lng,
      locationSource,
      placesApiName,
      chwId,
      synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomReportsTableData &&
          other.id == this.id &&
          other.wardId == this.wardId &&
          other.wardName == this.wardName &&
          other.timestamp == this.timestamp &&
          other.symptoms == this.symptoms &&
          other.testResult == this.testResult &&
          other.testConfidence == this.testConfidence &&
          other.diseaseSuspected == this.diseaseSuspected &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.locationSource == this.locationSource &&
          other.placesApiName == this.placesApiName &&
          other.chwId == this.chwId &&
          other.synced == this.synced);
}

class SymptomReportsTableCompanion
    extends UpdateCompanion<SymptomReportsTableData> {
  final Value<String> id;
  final Value<String?> wardId;
  final Value<String?> wardName;
  final Value<int> timestamp;
  final Value<String> symptoms;
  final Value<String?> testResult;
  final Value<double?> testConfidence;
  final Value<String?> diseaseSuspected;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String?> locationSource;
  final Value<String?> placesApiName;
  final Value<String?> chwId;
  final Value<int> synced;
  final Value<int> rowid;
  const SymptomReportsTableCompanion({
    this.id = const Value.absent(),
    this.wardId = const Value.absent(),
    this.wardName = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.testResult = const Value.absent(),
    this.testConfidence = const Value.absent(),
    this.diseaseSuspected = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.locationSource = const Value.absent(),
    this.placesApiName = const Value.absent(),
    this.chwId = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomReportsTableCompanion.insert({
    required String id,
    this.wardId = const Value.absent(),
    this.wardName = const Value.absent(),
    required int timestamp,
    required String symptoms,
    this.testResult = const Value.absent(),
    this.testConfidence = const Value.absent(),
    this.diseaseSuspected = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.locationSource = const Value.absent(),
    this.placesApiName = const Value.absent(),
    this.chwId = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        timestamp = Value(timestamp),
        symptoms = Value(symptoms);
  static Insertable<SymptomReportsTableData> custom({
    Expression<String>? id,
    Expression<String>? wardId,
    Expression<String>? wardName,
    Expression<int>? timestamp,
    Expression<String>? symptoms,
    Expression<String>? testResult,
    Expression<double>? testConfidence,
    Expression<String>? diseaseSuspected,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? locationSource,
    Expression<String>? placesApiName,
    Expression<String>? chwId,
    Expression<int>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wardId != null) 'ward_id': wardId,
      if (wardName != null) 'ward_name': wardName,
      if (timestamp != null) 'timestamp': timestamp,
      if (symptoms != null) 'symptoms': symptoms,
      if (testResult != null) 'test_result': testResult,
      if (testConfidence != null) 'test_confidence': testConfidence,
      if (diseaseSuspected != null) 'disease_suspected': diseaseSuspected,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (locationSource != null) 'location_source': locationSource,
      if (placesApiName != null) 'places_api_name': placesApiName,
      if (chwId != null) 'chw_id': chwId,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomReportsTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? wardId,
      Value<String?>? wardName,
      Value<int>? timestamp,
      Value<String>? symptoms,
      Value<String?>? testResult,
      Value<double?>? testConfidence,
      Value<String?>? diseaseSuspected,
      Value<double?>? lat,
      Value<double?>? lng,
      Value<String?>? locationSource,
      Value<String?>? placesApiName,
      Value<String?>? chwId,
      Value<int>? synced,
      Value<int>? rowid}) {
    return SymptomReportsTableCompanion(
      id: id ?? this.id,
      wardId: wardId ?? this.wardId,
      wardName: wardName ?? this.wardName,
      timestamp: timestamp ?? this.timestamp,
      symptoms: symptoms ?? this.symptoms,
      testResult: testResult ?? this.testResult,
      testConfidence: testConfidence ?? this.testConfidence,
      diseaseSuspected: diseaseSuspected ?? this.diseaseSuspected,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      locationSource: locationSource ?? this.locationSource,
      placesApiName: placesApiName ?? this.placesApiName,
      chwId: chwId ?? this.chwId,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wardId.present) {
      map['ward_id'] = Variable<String>(wardId.value);
    }
    if (wardName.present) {
      map['ward_name'] = Variable<String>(wardName.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (testResult.present) {
      map['test_result'] = Variable<String>(testResult.value);
    }
    if (testConfidence.present) {
      map['test_confidence'] = Variable<double>(testConfidence.value);
    }
    if (diseaseSuspected.present) {
      map['disease_suspected'] = Variable<String>(diseaseSuspected.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (locationSource.present) {
      map['location_source'] = Variable<String>(locationSource.value);
    }
    if (placesApiName.present) {
      map['places_api_name'] = Variable<String>(placesApiName.value);
    }
    if (chwId.present) {
      map['chw_id'] = Variable<String>(chwId.value);
    }
    if (synced.present) {
      map['synced'] = Variable<int>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomReportsTableCompanion(')
          ..write('id: $id, ')
          ..write('wardId: $wardId, ')
          ..write('wardName: $wardName, ')
          ..write('timestamp: $timestamp, ')
          ..write('symptoms: $symptoms, ')
          ..write('testResult: $testResult, ')
          ..write('testConfidence: $testConfidence, ')
          ..write('diseaseSuspected: $diseaseSuspected, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('locationSource: $locationSource, ')
          ..write('placesApiName: $placesApiName, ')
          ..write('chwId: $chwId, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CivicHazardsTableTable extends CivicHazardsTable
    with TableInfo<$CivicHazardsTableTable, CivicHazardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CivicHazardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wardIdMeta = const VerificationMeta('wardId');
  @override
  late final GeneratedColumn<String> wardId = GeneratedColumn<String>(
      'ward_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _wardNameMeta =
      const VerificationMeta('wardName');
  @override
  late final GeneratedColumn<String> wardName = GeneratedColumn<String>(
      'ward_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hazardTypeMeta =
      const VerificationMeta('hazardType');
  @override
  late final GeneratedColumn<String> hazardType = GeneratedColumn<String>(
      'hazard_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
      'lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
      'lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reporterTypeMeta =
      const VerificationMeta('reporterType');
  @override
  late final GeneratedColumn<String> reporterType = GeneratedColumn<String>(
      'reporter_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _locationSourceMeta =
      const VerificationMeta('locationSource');
  @override
  late final GeneratedColumn<String> locationSource = GeneratedColumn<String>(
      'location_source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _placesApiNameMeta =
      const VerificationMeta('placesApiName');
  @override
  late final GeneratedColumn<String> placesApiName = GeneratedColumn<String>(
      'places_api_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<int> synced = GeneratedColumn<int>(
      'synced', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        wardId,
        wardName,
        timestamp,
        hazardType,
        lat,
        lng,
        photoPath,
        reporterType,
        locationSource,
        placesApiName,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'civic_hazards_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CivicHazardsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ward_id')) {
      context.handle(_wardIdMeta,
          wardId.isAcceptableOrUnknown(data['ward_id']!, _wardIdMeta));
    }
    if (data.containsKey('ward_name')) {
      context.handle(_wardNameMeta,
          wardName.isAcceptableOrUnknown(data['ward_name']!, _wardNameMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('hazard_type')) {
      context.handle(
          _hazardTypeMeta,
          hazardType.isAcceptableOrUnknown(
              data['hazard_type']!, _hazardTypeMeta));
    } else if (isInserting) {
      context.missing(_hazardTypeMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    }
    if (data.containsKey('lng')) {
      context.handle(
          _lngMeta, lng.isAcceptableOrUnknown(data['lng']!, _lngMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('reporter_type')) {
      context.handle(
          _reporterTypeMeta,
          reporterType.isAcceptableOrUnknown(
              data['reporter_type']!, _reporterTypeMeta));
    }
    if (data.containsKey('location_source')) {
      context.handle(
          _locationSourceMeta,
          locationSource.isAcceptableOrUnknown(
              data['location_source']!, _locationSourceMeta));
    }
    if (data.containsKey('places_api_name')) {
      context.handle(
          _placesApiNameMeta,
          placesApiName.isAcceptableOrUnknown(
              data['places_api_name']!, _placesApiNameMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CivicHazardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CivicHazardsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      wardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ward_id']),
      wardName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ward_name']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      hazardType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hazard_type'])!,
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat']),
      lng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lng']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      reporterType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reporter_type']),
      locationSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_source']),
      placesApiName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}places_api_name']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $CivicHazardsTableTable createAlias(String alias) {
    return $CivicHazardsTableTable(attachedDatabase, alias);
  }
}

class CivicHazardsTableData extends DataClass
    implements Insertable<CivicHazardsTableData> {
  final String id;
  final String? wardId;
  final String? wardName;
  final int timestamp;
  final String hazardType;
  final double? lat;
  final double? lng;
  final String? photoPath;
  final String? reporterType;
  final String? locationSource;
  final String? placesApiName;
  final int synced;
  const CivicHazardsTableData(
      {required this.id,
      this.wardId,
      this.wardName,
      required this.timestamp,
      required this.hazardType,
      this.lat,
      this.lng,
      this.photoPath,
      this.reporterType,
      this.locationSource,
      this.placesApiName,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || wardId != null) {
      map['ward_id'] = Variable<String>(wardId);
    }
    if (!nullToAbsent || wardName != null) {
      map['ward_name'] = Variable<String>(wardName);
    }
    map['timestamp'] = Variable<int>(timestamp);
    map['hazard_type'] = Variable<String>(hazardType);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || reporterType != null) {
      map['reporter_type'] = Variable<String>(reporterType);
    }
    if (!nullToAbsent || locationSource != null) {
      map['location_source'] = Variable<String>(locationSource);
    }
    if (!nullToAbsent || placesApiName != null) {
      map['places_api_name'] = Variable<String>(placesApiName);
    }
    map['synced'] = Variable<int>(synced);
    return map;
  }

  CivicHazardsTableCompanion toCompanion(bool nullToAbsent) {
    return CivicHazardsTableCompanion(
      id: Value(id),
      wardId:
          wardId == null && nullToAbsent ? const Value.absent() : Value(wardId),
      wardName: wardName == null && nullToAbsent
          ? const Value.absent()
          : Value(wardName),
      timestamp: Value(timestamp),
      hazardType: Value(hazardType),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      reporterType: reporterType == null && nullToAbsent
          ? const Value.absent()
          : Value(reporterType),
      locationSource: locationSource == null && nullToAbsent
          ? const Value.absent()
          : Value(locationSource),
      placesApiName: placesApiName == null && nullToAbsent
          ? const Value.absent()
          : Value(placesApiName),
      synced: Value(synced),
    );
  }

  factory CivicHazardsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CivicHazardsTableData(
      id: serializer.fromJson<String>(json['id']),
      wardId: serializer.fromJson<String?>(json['wardId']),
      wardName: serializer.fromJson<String?>(json['wardName']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      hazardType: serializer.fromJson<String>(json['hazardType']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      reporterType: serializer.fromJson<String?>(json['reporterType']),
      locationSource: serializer.fromJson<String?>(json['locationSource']),
      placesApiName: serializer.fromJson<String?>(json['placesApiName']),
      synced: serializer.fromJson<int>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wardId': serializer.toJson<String?>(wardId),
      'wardName': serializer.toJson<String?>(wardName),
      'timestamp': serializer.toJson<int>(timestamp),
      'hazardType': serializer.toJson<String>(hazardType),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'photoPath': serializer.toJson<String?>(photoPath),
      'reporterType': serializer.toJson<String?>(reporterType),
      'locationSource': serializer.toJson<String?>(locationSource),
      'placesApiName': serializer.toJson<String?>(placesApiName),
      'synced': serializer.toJson<int>(synced),
    };
  }

  CivicHazardsTableData copyWith(
          {String? id,
          Value<String?> wardId = const Value.absent(),
          Value<String?> wardName = const Value.absent(),
          int? timestamp,
          String? hazardType,
          Value<double?> lat = const Value.absent(),
          Value<double?> lng = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<String?> reporterType = const Value.absent(),
          Value<String?> locationSource = const Value.absent(),
          Value<String?> placesApiName = const Value.absent(),
          int? synced}) =>
      CivicHazardsTableData(
        id: id ?? this.id,
        wardId: wardId.present ? wardId.value : this.wardId,
        wardName: wardName.present ? wardName.value : this.wardName,
        timestamp: timestamp ?? this.timestamp,
        hazardType: hazardType ?? this.hazardType,
        lat: lat.present ? lat.value : this.lat,
        lng: lng.present ? lng.value : this.lng,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        reporterType:
            reporterType.present ? reporterType.value : this.reporterType,
        locationSource:
            locationSource.present ? locationSource.value : this.locationSource,
        placesApiName:
            placesApiName.present ? placesApiName.value : this.placesApiName,
        synced: synced ?? this.synced,
      );
  CivicHazardsTableData copyWithCompanion(CivicHazardsTableCompanion data) {
    return CivicHazardsTableData(
      id: data.id.present ? data.id.value : this.id,
      wardId: data.wardId.present ? data.wardId.value : this.wardId,
      wardName: data.wardName.present ? data.wardName.value : this.wardName,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      hazardType:
          data.hazardType.present ? data.hazardType.value : this.hazardType,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      reporterType: data.reporterType.present
          ? data.reporterType.value
          : this.reporterType,
      locationSource: data.locationSource.present
          ? data.locationSource.value
          : this.locationSource,
      placesApiName: data.placesApiName.present
          ? data.placesApiName.value
          : this.placesApiName,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CivicHazardsTableData(')
          ..write('id: $id, ')
          ..write('wardId: $wardId, ')
          ..write('wardName: $wardName, ')
          ..write('timestamp: $timestamp, ')
          ..write('hazardType: $hazardType, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('photoPath: $photoPath, ')
          ..write('reporterType: $reporterType, ')
          ..write('locationSource: $locationSource, ')
          ..write('placesApiName: $placesApiName, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wardId, wardName, timestamp, hazardType,
      lat, lng, photoPath, reporterType, locationSource, placesApiName, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CivicHazardsTableData &&
          other.id == this.id &&
          other.wardId == this.wardId &&
          other.wardName == this.wardName &&
          other.timestamp == this.timestamp &&
          other.hazardType == this.hazardType &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.photoPath == this.photoPath &&
          other.reporterType == this.reporterType &&
          other.locationSource == this.locationSource &&
          other.placesApiName == this.placesApiName &&
          other.synced == this.synced);
}

class CivicHazardsTableCompanion
    extends UpdateCompanion<CivicHazardsTableData> {
  final Value<String> id;
  final Value<String?> wardId;
  final Value<String?> wardName;
  final Value<int> timestamp;
  final Value<String> hazardType;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String?> photoPath;
  final Value<String?> reporterType;
  final Value<String?> locationSource;
  final Value<String?> placesApiName;
  final Value<int> synced;
  final Value<int> rowid;
  const CivicHazardsTableCompanion({
    this.id = const Value.absent(),
    this.wardId = const Value.absent(),
    this.wardName = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.hazardType = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.reporterType = const Value.absent(),
    this.locationSource = const Value.absent(),
    this.placesApiName = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CivicHazardsTableCompanion.insert({
    required String id,
    this.wardId = const Value.absent(),
    this.wardName = const Value.absent(),
    required int timestamp,
    required String hazardType,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.reporterType = const Value.absent(),
    this.locationSource = const Value.absent(),
    this.placesApiName = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        timestamp = Value(timestamp),
        hazardType = Value(hazardType);
  static Insertable<CivicHazardsTableData> custom({
    Expression<String>? id,
    Expression<String>? wardId,
    Expression<String>? wardName,
    Expression<int>? timestamp,
    Expression<String>? hazardType,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? photoPath,
    Expression<String>? reporterType,
    Expression<String>? locationSource,
    Expression<String>? placesApiName,
    Expression<int>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wardId != null) 'ward_id': wardId,
      if (wardName != null) 'ward_name': wardName,
      if (timestamp != null) 'timestamp': timestamp,
      if (hazardType != null) 'hazard_type': hazardType,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (photoPath != null) 'photo_path': photoPath,
      if (reporterType != null) 'reporter_type': reporterType,
      if (locationSource != null) 'location_source': locationSource,
      if (placesApiName != null) 'places_api_name': placesApiName,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CivicHazardsTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? wardId,
      Value<String?>? wardName,
      Value<int>? timestamp,
      Value<String>? hazardType,
      Value<double?>? lat,
      Value<double?>? lng,
      Value<String?>? photoPath,
      Value<String?>? reporterType,
      Value<String?>? locationSource,
      Value<String?>? placesApiName,
      Value<int>? synced,
      Value<int>? rowid}) {
    return CivicHazardsTableCompanion(
      id: id ?? this.id,
      wardId: wardId ?? this.wardId,
      wardName: wardName ?? this.wardName,
      timestamp: timestamp ?? this.timestamp,
      hazardType: hazardType ?? this.hazardType,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      photoPath: photoPath ?? this.photoPath,
      reporterType: reporterType ?? this.reporterType,
      locationSource: locationSource ?? this.locationSource,
      placesApiName: placesApiName ?? this.placesApiName,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wardId.present) {
      map['ward_id'] = Variable<String>(wardId.value);
    }
    if (wardName.present) {
      map['ward_name'] = Variable<String>(wardName.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (hazardType.present) {
      map['hazard_type'] = Variable<String>(hazardType.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (reporterType.present) {
      map['reporter_type'] = Variable<String>(reporterType.value);
    }
    if (locationSource.present) {
      map['location_source'] = Variable<String>(locationSource.value);
    }
    if (placesApiName.present) {
      map['places_api_name'] = Variable<String>(placesApiName.value);
    }
    if (synced.present) {
      map['synced'] = Variable<int>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CivicHazardsTableCompanion(')
          ..write('id: $id, ')
          ..write('wardId: $wardId, ')
          ..write('wardName: $wardName, ')
          ..write('timestamp: $timestamp, ')
          ..write('hazardType: $hazardType, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('photoPath: $photoPath, ')
          ..write('reporterType: $reporterType, ')
          ..write('locationSource: $locationSource, ')
          ..write('placesApiName: $placesApiName, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SymptomReportsTableTable symptomReportsTable =
      $SymptomReportsTableTable(this);
  late final $CivicHazardsTableTable civicHazardsTable =
      $CivicHazardsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [symptomReportsTable, civicHazardsTable];
}

typedef $$SymptomReportsTableTableCreateCompanionBuilder
    = SymptomReportsTableCompanion Function({
  required String id,
  Value<String?> wardId,
  Value<String?> wardName,
  required int timestamp,
  required String symptoms,
  Value<String?> testResult,
  Value<double?> testConfidence,
  Value<String?> diseaseSuspected,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> locationSource,
  Value<String?> placesApiName,
  Value<String?> chwId,
  Value<int> synced,
  Value<int> rowid,
});
typedef $$SymptomReportsTableTableUpdateCompanionBuilder
    = SymptomReportsTableCompanion Function({
  Value<String> id,
  Value<String?> wardId,
  Value<String?> wardName,
  Value<int> timestamp,
  Value<String> symptoms,
  Value<String?> testResult,
  Value<double?> testConfidence,
  Value<String?> diseaseSuspected,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> locationSource,
  Value<String?> placesApiName,
  Value<String?> chwId,
  Value<int> synced,
  Value<int> rowid,
});

class $$SymptomReportsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SymptomReportsTableTable,
    SymptomReportsTableData,
    $$SymptomReportsTableTableFilterComposer,
    $$SymptomReportsTableTableOrderingComposer,
    $$SymptomReportsTableTableCreateCompanionBuilder,
    $$SymptomReportsTableTableUpdateCompanionBuilder> {
  $$SymptomReportsTableTableTableManager(
      _$AppDatabase db, $SymptomReportsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$SymptomReportsTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$SymptomReportsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> wardId = const Value.absent(),
            Value<String?> wardName = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<String> symptoms = const Value.absent(),
            Value<String?> testResult = const Value.absent(),
            Value<double?> testConfidence = const Value.absent(),
            Value<String?> diseaseSuspected = const Value.absent(),
            Value<double?> lat = const Value.absent(),
            Value<double?> lng = const Value.absent(),
            Value<String?> locationSource = const Value.absent(),
            Value<String?> placesApiName = const Value.absent(),
            Value<String?> chwId = const Value.absent(),
            Value<int> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SymptomReportsTableCompanion(
            id: id,
            wardId: wardId,
            wardName: wardName,
            timestamp: timestamp,
            symptoms: symptoms,
            testResult: testResult,
            testConfidence: testConfidence,
            diseaseSuspected: diseaseSuspected,
            lat: lat,
            lng: lng,
            locationSource: locationSource,
            placesApiName: placesApiName,
            chwId: chwId,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> wardId = const Value.absent(),
            Value<String?> wardName = const Value.absent(),
            required int timestamp,
            required String symptoms,
            Value<String?> testResult = const Value.absent(),
            Value<double?> testConfidence = const Value.absent(),
            Value<String?> diseaseSuspected = const Value.absent(),
            Value<double?> lat = const Value.absent(),
            Value<double?> lng = const Value.absent(),
            Value<String?> locationSource = const Value.absent(),
            Value<String?> placesApiName = const Value.absent(),
            Value<String?> chwId = const Value.absent(),
            Value<int> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SymptomReportsTableCompanion.insert(
            id: id,
            wardId: wardId,
            wardName: wardName,
            timestamp: timestamp,
            symptoms: symptoms,
            testResult: testResult,
            testConfidence: testConfidence,
            diseaseSuspected: diseaseSuspected,
            lat: lat,
            lng: lng,
            locationSource: locationSource,
            placesApiName: placesApiName,
            chwId: chwId,
            synced: synced,
            rowid: rowid,
          ),
        ));
}

class $$SymptomReportsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SymptomReportsTableTable> {
  $$SymptomReportsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get wardId => $state.composableBuilder(
      column: $state.table.wardId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get wardName => $state.composableBuilder(
      column: $state.table.wardName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get symptoms => $state.composableBuilder(
      column: $state.table.symptoms,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get testResult => $state.composableBuilder(
      column: $state.table.testResult,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get testConfidence => $state.composableBuilder(
      column: $state.table.testConfidence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get diseaseSuspected => $state.composableBuilder(
      column: $state.table.diseaseSuspected,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get locationSource => $state.composableBuilder(
      column: $state.table.locationSource,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get placesApiName => $state.composableBuilder(
      column: $state.table.placesApiName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get chwId => $state.composableBuilder(
      column: $state.table.chwId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SymptomReportsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SymptomReportsTableTable> {
  $$SymptomReportsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get wardId => $state.composableBuilder(
      column: $state.table.wardId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get wardName => $state.composableBuilder(
      column: $state.table.wardName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get symptoms => $state.composableBuilder(
      column: $state.table.symptoms,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get testResult => $state.composableBuilder(
      column: $state.table.testResult,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get testConfidence => $state.composableBuilder(
      column: $state.table.testConfidence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get diseaseSuspected => $state.composableBuilder(
      column: $state.table.diseaseSuspected,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get locationSource => $state.composableBuilder(
      column: $state.table.locationSource,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get placesApiName => $state.composableBuilder(
      column: $state.table.placesApiName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get chwId => $state.composableBuilder(
      column: $state.table.chwId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CivicHazardsTableTableCreateCompanionBuilder
    = CivicHazardsTableCompanion Function({
  required String id,
  Value<String?> wardId,
  Value<String?> wardName,
  required int timestamp,
  required String hazardType,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> photoPath,
  Value<String?> reporterType,
  Value<String?> locationSource,
  Value<String?> placesApiName,
  Value<int> synced,
  Value<int> rowid,
});
typedef $$CivicHazardsTableTableUpdateCompanionBuilder
    = CivicHazardsTableCompanion Function({
  Value<String> id,
  Value<String?> wardId,
  Value<String?> wardName,
  Value<int> timestamp,
  Value<String> hazardType,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> photoPath,
  Value<String?> reporterType,
  Value<String?> locationSource,
  Value<String?> placesApiName,
  Value<int> synced,
  Value<int> rowid,
});

class $$CivicHazardsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CivicHazardsTableTable,
    CivicHazardsTableData,
    $$CivicHazardsTableTableFilterComposer,
    $$CivicHazardsTableTableOrderingComposer,
    $$CivicHazardsTableTableCreateCompanionBuilder,
    $$CivicHazardsTableTableUpdateCompanionBuilder> {
  $$CivicHazardsTableTableTableManager(
      _$AppDatabase db, $CivicHazardsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CivicHazardsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$CivicHazardsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> wardId = const Value.absent(),
            Value<String?> wardName = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<String> hazardType = const Value.absent(),
            Value<double?> lat = const Value.absent(),
            Value<double?> lng = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> reporterType = const Value.absent(),
            Value<String?> locationSource = const Value.absent(),
            Value<String?> placesApiName = const Value.absent(),
            Value<int> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CivicHazardsTableCompanion(
            id: id,
            wardId: wardId,
            wardName: wardName,
            timestamp: timestamp,
            hazardType: hazardType,
            lat: lat,
            lng: lng,
            photoPath: photoPath,
            reporterType: reporterType,
            locationSource: locationSource,
            placesApiName: placesApiName,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> wardId = const Value.absent(),
            Value<String?> wardName = const Value.absent(),
            required int timestamp,
            required String hazardType,
            Value<double?> lat = const Value.absent(),
            Value<double?> lng = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> reporterType = const Value.absent(),
            Value<String?> locationSource = const Value.absent(),
            Value<String?> placesApiName = const Value.absent(),
            Value<int> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CivicHazardsTableCompanion.insert(
            id: id,
            wardId: wardId,
            wardName: wardName,
            timestamp: timestamp,
            hazardType: hazardType,
            lat: lat,
            lng: lng,
            photoPath: photoPath,
            reporterType: reporterType,
            locationSource: locationSource,
            placesApiName: placesApiName,
            synced: synced,
            rowid: rowid,
          ),
        ));
}

class $$CivicHazardsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CivicHazardsTableTable> {
  $$CivicHazardsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get wardId => $state.composableBuilder(
      column: $state.table.wardId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get wardName => $state.composableBuilder(
      column: $state.table.wardName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hazardType => $state.composableBuilder(
      column: $state.table.hazardType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reporterType => $state.composableBuilder(
      column: $state.table.reporterType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get locationSource => $state.composableBuilder(
      column: $state.table.locationSource,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get placesApiName => $state.composableBuilder(
      column: $state.table.placesApiName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CivicHazardsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CivicHazardsTableTable> {
  $$CivicHazardsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get wardId => $state.composableBuilder(
      column: $state.table.wardId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get wardName => $state.composableBuilder(
      column: $state.table.wardName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hazardType => $state.composableBuilder(
      column: $state.table.hazardType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reporterType => $state.composableBuilder(
      column: $state.table.reporterType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get locationSource => $state.composableBuilder(
      column: $state.table.locationSource,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get placesApiName => $state.composableBuilder(
      column: $state.table.placesApiName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SymptomReportsTableTableTableManager get symptomReportsTable =>
      $$SymptomReportsTableTableTableManager(_db, _db.symptomReportsTable);
  $$CivicHazardsTableTableTableManager get civicHazardsTable =>
      $$CivicHazardsTableTableTableManager(_db, _db.civicHazardsTable);
}
