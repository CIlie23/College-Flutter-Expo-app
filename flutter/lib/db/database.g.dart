// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BuildingsTable extends Buildings
    with TableInfo<$BuildingsTable, BuildingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuildingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncState>($BuildingsTable.$convertersyncState);
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    syncState,
    lastError,
    label,
    comment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buildings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BuildingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BuildingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuildingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncState: $BuildingsTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
    );
  }

  @override
  $BuildingsTable createAlias(String alias) {
    return $BuildingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class BuildingRow extends DataClass implements Insertable<BuildingRow> {
  final String id;
  final String createdAt;
  final String updatedAt;
  final SyncState syncState;
  final String? lastError;
  final String label;
  final String? comment;
  const BuildingRow({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.syncState,
    this.lastError,
    required this.label,
    this.comment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    {
      map['sync_state'] = Variable<String>(
        $BuildingsTable.$convertersyncState.toSql(syncState),
      );
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  BuildingsCompanion toCompanion(bool nullToAbsent) {
    return BuildingsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncState: Value(syncState),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      label: Value(label),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory BuildingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuildingRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncState: $BuildingsTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
      label: serializer.fromJson<String>(json['label']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncState': serializer.toJson<String>(
        $BuildingsTable.$convertersyncState.toJson(syncState),
      ),
      'lastError': serializer.toJson<String?>(lastError),
      'label': serializer.toJson<String>(label),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  BuildingRow copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    SyncState? syncState,
    Value<String?> lastError = const Value.absent(),
    String? label,
    Value<String?> comment = const Value.absent(),
  }) => BuildingRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncState: syncState ?? this.syncState,
    lastError: lastError.present ? lastError.value : this.lastError,
    label: label ?? this.label,
    comment: comment.present ? comment.value : this.comment,
  );
  BuildingRow copyWithCompanion(BuildingsCompanion data) {
    return BuildingRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      label: data.label.present ? data.label.value : this.label,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BuildingRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('label: $label, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    syncState,
    lastError,
    label,
    comment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuildingRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.lastError == this.lastError &&
          other.label == this.label &&
          other.comment == this.comment);
}

class BuildingsCompanion extends UpdateCompanion<BuildingRow> {
  final Value<String> id;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<SyncState> syncState;
  final Value<String?> lastError;
  final Value<String> label;
  final Value<String?> comment;
  final Value<int> rowid;
  const BuildingsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    this.label = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BuildingsCompanion.insert({
    required String id,
    required String createdAt,
    required String updatedAt,
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    required String label,
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       label = Value(label);
  static Insertable<BuildingRow> custom({
    Expression<String>? id,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? syncState,
    Expression<String>? lastError,
    Expression<String>? label,
    Expression<String>? comment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (lastError != null) 'last_error': lastError,
      if (label != null) 'label': label,
      if (comment != null) 'comment': comment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BuildingsCompanion copyWith({
    Value<String>? id,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<SyncState>? syncState,
    Value<String?>? lastError,
    Value<String>? label,
    Value<String?>? comment,
    Value<int>? rowid,
  }) {
    return BuildingsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      lastError: lastError ?? this.lastError,
      label: label ?? this.label,
      comment: comment ?? this.comment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $BuildingsTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuildingsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('label: $label, ')
          ..write('comment: $comment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntrancesTable extends Entrances
    with TableInfo<$EntrancesTable, EntranceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntrancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncState>($EntrancesTable.$convertersyncState);
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _buildingIdMeta = const VerificationMeta(
    'buildingId',
  );
  @override
  late final GeneratedColumn<String> buildingId = GeneratedColumn<String>(
    'building_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES buildings (id)',
    ),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
    'street',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entranceNameMeta = const VerificationMeta(
    'entranceName',
  );
  @override
  late final GeneratedColumn<String> entranceName = GeneratedColumn<String>(
    'entrance_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coordsConfirmedMeta = const VerificationMeta(
    'coordsConfirmed',
  );
  @override
  late final GeneratedColumn<bool> coordsConfirmed = GeneratedColumn<bool>(
    'coords_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("coords_confirmed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _correctedLatMeta = const VerificationMeta(
    'correctedLat',
  );
  @override
  late final GeneratedColumn<double> correctedLat = GeneratedColumn<double>(
    'corrected_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctedLngMeta = const VerificationMeta(
    'correctedLng',
  );
  @override
  late final GeneratedColumn<double> correctedLng = GeneratedColumn<double>(
    'corrected_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressConfirmedMeta = const VerificationMeta(
    'addressConfirmed',
  );
  @override
  late final GeneratedColumn<bool> addressConfirmed = GeneratedColumn<bool>(
    'address_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("address_confirmed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _storiesMeta = const VerificationMeta(
    'stories',
  );
  @override
  late final GeneratedColumn<int> stories = GeneratedColumn<int>(
    'stories',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flatsMeta = const VerificationMeta('flats');
  @override
  late final GeneratedColumn<int> flats = GeneratedColumn<int>(
    'flats',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _elevatorsMeta = const VerificationMeta(
    'elevators',
  );
  @override
  late final GeneratedColumn<int> elevators = GeneratedColumn<int>(
    'elevators',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearBuiltMeta = const VerificationMeta(
    'yearBuilt',
  );
  @override
  late final GeneratedColumn<int> yearBuilt = GeneratedColumn<int>(
    'year_built',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groundFloorCommercialMeta =
      const VerificationMeta('groundFloorCommercial');
  @override
  late final GeneratedColumn<bool> groundFloorCommercial =
      GeneratedColumn<bool>(
        'ground_floor_commercial',
        aliasedName,
        true,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ground_floor_commercial" IN (0, 1))',
        ),
      );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SurveyStatus, String>
  surveyStatus = GeneratedColumn<String>(
    'survey_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SurveyStatus>($EntrancesTable.$convertersurveyStatus);
  static const VerificationMeta _surveyedByMeta = const VerificationMeta(
    'surveyedBy',
  );
  @override
  late final GeneratedColumn<String> surveyedBy = GeneratedColumn<String>(
    'surveyed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surveyedAtMeta = const VerificationMeta(
    'surveyedAt',
  );
  @override
  late final GeneratedColumn<String> surveyedAt = GeneratedColumn<String>(
    'surveyed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    syncState,
    lastError,
    buildingId,
    lat,
    lng,
    street,
    number,
    entranceName,
    coordsConfirmed,
    correctedLat,
    correctedLng,
    addressConfirmed,
    stories,
    flats,
    elevators,
    yearBuilt,
    groundFloorCommercial,
    comment,
    surveyStatus,
    surveyedBy,
    surveyedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entrances';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntranceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('building_id')) {
      context.handle(
        _buildingIdMeta,
        buildingId.isAcceptableOrUnknown(data['building_id']!, _buildingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_buildingIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('street')) {
      context.handle(
        _streetMeta,
        street.isAcceptableOrUnknown(data['street']!, _streetMeta),
      );
    } else if (isInserting) {
      context.missing(_streetMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('entrance_name')) {
      context.handle(
        _entranceNameMeta,
        entranceName.isAcceptableOrUnknown(
          data['entrance_name']!,
          _entranceNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entranceNameMeta);
    }
    if (data.containsKey('coords_confirmed')) {
      context.handle(
        _coordsConfirmedMeta,
        coordsConfirmed.isAcceptableOrUnknown(
          data['coords_confirmed']!,
          _coordsConfirmedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coordsConfirmedMeta);
    }
    if (data.containsKey('corrected_lat')) {
      context.handle(
        _correctedLatMeta,
        correctedLat.isAcceptableOrUnknown(
          data['corrected_lat']!,
          _correctedLatMeta,
        ),
      );
    }
    if (data.containsKey('corrected_lng')) {
      context.handle(
        _correctedLngMeta,
        correctedLng.isAcceptableOrUnknown(
          data['corrected_lng']!,
          _correctedLngMeta,
        ),
      );
    }
    if (data.containsKey('address_confirmed')) {
      context.handle(
        _addressConfirmedMeta,
        addressConfirmed.isAcceptableOrUnknown(
          data['address_confirmed']!,
          _addressConfirmedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_addressConfirmedMeta);
    }
    if (data.containsKey('stories')) {
      context.handle(
        _storiesMeta,
        stories.isAcceptableOrUnknown(data['stories']!, _storiesMeta),
      );
    }
    if (data.containsKey('flats')) {
      context.handle(
        _flatsMeta,
        flats.isAcceptableOrUnknown(data['flats']!, _flatsMeta),
      );
    }
    if (data.containsKey('elevators')) {
      context.handle(
        _elevatorsMeta,
        elevators.isAcceptableOrUnknown(data['elevators']!, _elevatorsMeta),
      );
    }
    if (data.containsKey('year_built')) {
      context.handle(
        _yearBuiltMeta,
        yearBuilt.isAcceptableOrUnknown(data['year_built']!, _yearBuiltMeta),
      );
    }
    if (data.containsKey('ground_floor_commercial')) {
      context.handle(
        _groundFloorCommercialMeta,
        groundFloorCommercial.isAcceptableOrUnknown(
          data['ground_floor_commercial']!,
          _groundFloorCommercialMeta,
        ),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('surveyed_by')) {
      context.handle(
        _surveyedByMeta,
        surveyedBy.isAcceptableOrUnknown(data['surveyed_by']!, _surveyedByMeta),
      );
    }
    if (data.containsKey('surveyed_at')) {
      context.handle(
        _surveyedAtMeta,
        surveyedAt.isAcceptableOrUnknown(data['surveyed_at']!, _surveyedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntranceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntranceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncState: $EntrancesTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      buildingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}building_id'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      street: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      entranceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entrance_name'],
      )!,
      coordsConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}coords_confirmed'],
      )!,
      correctedLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}corrected_lat'],
      ),
      correctedLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}corrected_lng'],
      ),
      addressConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}address_confirmed'],
      )!,
      stories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stories'],
      ),
      flats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flats'],
      ),
      elevators: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elevators'],
      ),
      yearBuilt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_built'],
      ),
      groundFloorCommercial: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ground_floor_commercial'],
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      surveyStatus: $EntrancesTable.$convertersurveyStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}survey_status'],
        )!,
      ),
      surveyedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surveyed_by'],
      ),
      surveyedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surveyed_at'],
      ),
    );
  }

  @override
  $EntrancesTable createAlias(String alias) {
    return $EntrancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
  static JsonTypeConverter2<SurveyStatus, String, String>
  $convertersurveyStatus = const EnumNameConverter<SurveyStatus>(
    SurveyStatus.values,
  );
}

class EntranceRow extends DataClass implements Insertable<EntranceRow> {
  final String id;
  final String createdAt;
  final String updatedAt;
  final SyncState syncState;
  final String? lastError;
  final String buildingId;
  final double lat;
  final double lng;
  final String street;
  final String number;
  final String entranceName;
  final bool coordsConfirmed;
  final double? correctedLat;
  final double? correctedLng;
  final bool addressConfirmed;
  final int? stories;
  final int? flats;
  final int? elevators;
  final int? yearBuilt;
  final bool? groundFloorCommercial;
  final String? comment;
  final SurveyStatus surveyStatus;
  final String? surveyedBy;
  final String? surveyedAt;
  const EntranceRow({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.syncState,
    this.lastError,
    required this.buildingId,
    required this.lat,
    required this.lng,
    required this.street,
    required this.number,
    required this.entranceName,
    required this.coordsConfirmed,
    this.correctedLat,
    this.correctedLng,
    required this.addressConfirmed,
    this.stories,
    this.flats,
    this.elevators,
    this.yearBuilt,
    this.groundFloorCommercial,
    this.comment,
    required this.surveyStatus,
    this.surveyedBy,
    this.surveyedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    {
      map['sync_state'] = Variable<String>(
        $EntrancesTable.$convertersyncState.toSql(syncState),
      );
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['building_id'] = Variable<String>(buildingId);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    map['street'] = Variable<String>(street);
    map['number'] = Variable<String>(number);
    map['entrance_name'] = Variable<String>(entranceName);
    map['coords_confirmed'] = Variable<bool>(coordsConfirmed);
    if (!nullToAbsent || correctedLat != null) {
      map['corrected_lat'] = Variable<double>(correctedLat);
    }
    if (!nullToAbsent || correctedLng != null) {
      map['corrected_lng'] = Variable<double>(correctedLng);
    }
    map['address_confirmed'] = Variable<bool>(addressConfirmed);
    if (!nullToAbsent || stories != null) {
      map['stories'] = Variable<int>(stories);
    }
    if (!nullToAbsent || flats != null) {
      map['flats'] = Variable<int>(flats);
    }
    if (!nullToAbsent || elevators != null) {
      map['elevators'] = Variable<int>(elevators);
    }
    if (!nullToAbsent || yearBuilt != null) {
      map['year_built'] = Variable<int>(yearBuilt);
    }
    if (!nullToAbsent || groundFloorCommercial != null) {
      map['ground_floor_commercial'] = Variable<bool>(groundFloorCommercial);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    {
      map['survey_status'] = Variable<String>(
        $EntrancesTable.$convertersurveyStatus.toSql(surveyStatus),
      );
    }
    if (!nullToAbsent || surveyedBy != null) {
      map['surveyed_by'] = Variable<String>(surveyedBy);
    }
    if (!nullToAbsent || surveyedAt != null) {
      map['surveyed_at'] = Variable<String>(surveyedAt);
    }
    return map;
  }

  EntrancesCompanion toCompanion(bool nullToAbsent) {
    return EntrancesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncState: Value(syncState),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      buildingId: Value(buildingId),
      lat: Value(lat),
      lng: Value(lng),
      street: Value(street),
      number: Value(number),
      entranceName: Value(entranceName),
      coordsConfirmed: Value(coordsConfirmed),
      correctedLat: correctedLat == null && nullToAbsent
          ? const Value.absent()
          : Value(correctedLat),
      correctedLng: correctedLng == null && nullToAbsent
          ? const Value.absent()
          : Value(correctedLng),
      addressConfirmed: Value(addressConfirmed),
      stories: stories == null && nullToAbsent
          ? const Value.absent()
          : Value(stories),
      flats: flats == null && nullToAbsent
          ? const Value.absent()
          : Value(flats),
      elevators: elevators == null && nullToAbsent
          ? const Value.absent()
          : Value(elevators),
      yearBuilt: yearBuilt == null && nullToAbsent
          ? const Value.absent()
          : Value(yearBuilt),
      groundFloorCommercial: groundFloorCommercial == null && nullToAbsent
          ? const Value.absent()
          : Value(groundFloorCommercial),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      surveyStatus: Value(surveyStatus),
      surveyedBy: surveyedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(surveyedBy),
      surveyedAt: surveyedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(surveyedAt),
    );
  }

  factory EntranceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntranceRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncState: $EntrancesTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
      buildingId: serializer.fromJson<String>(json['buildingId']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      street: serializer.fromJson<String>(json['street']),
      number: serializer.fromJson<String>(json['number']),
      entranceName: serializer.fromJson<String>(json['entranceName']),
      coordsConfirmed: serializer.fromJson<bool>(json['coordsConfirmed']),
      correctedLat: serializer.fromJson<double?>(json['correctedLat']),
      correctedLng: serializer.fromJson<double?>(json['correctedLng']),
      addressConfirmed: serializer.fromJson<bool>(json['addressConfirmed']),
      stories: serializer.fromJson<int?>(json['stories']),
      flats: serializer.fromJson<int?>(json['flats']),
      elevators: serializer.fromJson<int?>(json['elevators']),
      yearBuilt: serializer.fromJson<int?>(json['yearBuilt']),
      groundFloorCommercial: serializer.fromJson<bool?>(
        json['groundFloorCommercial'],
      ),
      comment: serializer.fromJson<String?>(json['comment']),
      surveyStatus: $EntrancesTable.$convertersurveyStatus.fromJson(
        serializer.fromJson<String>(json['surveyStatus']),
      ),
      surveyedBy: serializer.fromJson<String?>(json['surveyedBy']),
      surveyedAt: serializer.fromJson<String?>(json['surveyedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncState': serializer.toJson<String>(
        $EntrancesTable.$convertersyncState.toJson(syncState),
      ),
      'lastError': serializer.toJson<String?>(lastError),
      'buildingId': serializer.toJson<String>(buildingId),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'street': serializer.toJson<String>(street),
      'number': serializer.toJson<String>(number),
      'entranceName': serializer.toJson<String>(entranceName),
      'coordsConfirmed': serializer.toJson<bool>(coordsConfirmed),
      'correctedLat': serializer.toJson<double?>(correctedLat),
      'correctedLng': serializer.toJson<double?>(correctedLng),
      'addressConfirmed': serializer.toJson<bool>(addressConfirmed),
      'stories': serializer.toJson<int?>(stories),
      'flats': serializer.toJson<int?>(flats),
      'elevators': serializer.toJson<int?>(elevators),
      'yearBuilt': serializer.toJson<int?>(yearBuilt),
      'groundFloorCommercial': serializer.toJson<bool?>(groundFloorCommercial),
      'comment': serializer.toJson<String?>(comment),
      'surveyStatus': serializer.toJson<String>(
        $EntrancesTable.$convertersurveyStatus.toJson(surveyStatus),
      ),
      'surveyedBy': serializer.toJson<String?>(surveyedBy),
      'surveyedAt': serializer.toJson<String?>(surveyedAt),
    };
  }

  EntranceRow copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    SyncState? syncState,
    Value<String?> lastError = const Value.absent(),
    String? buildingId,
    double? lat,
    double? lng,
    String? street,
    String? number,
    String? entranceName,
    bool? coordsConfirmed,
    Value<double?> correctedLat = const Value.absent(),
    Value<double?> correctedLng = const Value.absent(),
    bool? addressConfirmed,
    Value<int?> stories = const Value.absent(),
    Value<int?> flats = const Value.absent(),
    Value<int?> elevators = const Value.absent(),
    Value<int?> yearBuilt = const Value.absent(),
    Value<bool?> groundFloorCommercial = const Value.absent(),
    Value<String?> comment = const Value.absent(),
    SurveyStatus? surveyStatus,
    Value<String?> surveyedBy = const Value.absent(),
    Value<String?> surveyedAt = const Value.absent(),
  }) => EntranceRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncState: syncState ?? this.syncState,
    lastError: lastError.present ? lastError.value : this.lastError,
    buildingId: buildingId ?? this.buildingId,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    street: street ?? this.street,
    number: number ?? this.number,
    entranceName: entranceName ?? this.entranceName,
    coordsConfirmed: coordsConfirmed ?? this.coordsConfirmed,
    correctedLat: correctedLat.present ? correctedLat.value : this.correctedLat,
    correctedLng: correctedLng.present ? correctedLng.value : this.correctedLng,
    addressConfirmed: addressConfirmed ?? this.addressConfirmed,
    stories: stories.present ? stories.value : this.stories,
    flats: flats.present ? flats.value : this.flats,
    elevators: elevators.present ? elevators.value : this.elevators,
    yearBuilt: yearBuilt.present ? yearBuilt.value : this.yearBuilt,
    groundFloorCommercial: groundFloorCommercial.present
        ? groundFloorCommercial.value
        : this.groundFloorCommercial,
    comment: comment.present ? comment.value : this.comment,
    surveyStatus: surveyStatus ?? this.surveyStatus,
    surveyedBy: surveyedBy.present ? surveyedBy.value : this.surveyedBy,
    surveyedAt: surveyedAt.present ? surveyedAt.value : this.surveyedAt,
  );
  EntranceRow copyWithCompanion(EntrancesCompanion data) {
    return EntranceRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      buildingId: data.buildingId.present
          ? data.buildingId.value
          : this.buildingId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      street: data.street.present ? data.street.value : this.street,
      number: data.number.present ? data.number.value : this.number,
      entranceName: data.entranceName.present
          ? data.entranceName.value
          : this.entranceName,
      coordsConfirmed: data.coordsConfirmed.present
          ? data.coordsConfirmed.value
          : this.coordsConfirmed,
      correctedLat: data.correctedLat.present
          ? data.correctedLat.value
          : this.correctedLat,
      correctedLng: data.correctedLng.present
          ? data.correctedLng.value
          : this.correctedLng,
      addressConfirmed: data.addressConfirmed.present
          ? data.addressConfirmed.value
          : this.addressConfirmed,
      stories: data.stories.present ? data.stories.value : this.stories,
      flats: data.flats.present ? data.flats.value : this.flats,
      elevators: data.elevators.present ? data.elevators.value : this.elevators,
      yearBuilt: data.yearBuilt.present ? data.yearBuilt.value : this.yearBuilt,
      groundFloorCommercial: data.groundFloorCommercial.present
          ? data.groundFloorCommercial.value
          : this.groundFloorCommercial,
      comment: data.comment.present ? data.comment.value : this.comment,
      surveyStatus: data.surveyStatus.present
          ? data.surveyStatus.value
          : this.surveyStatus,
      surveyedBy: data.surveyedBy.present
          ? data.surveyedBy.value
          : this.surveyedBy,
      surveyedAt: data.surveyedAt.present
          ? data.surveyedAt.value
          : this.surveyedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntranceRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('buildingId: $buildingId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('street: $street, ')
          ..write('number: $number, ')
          ..write('entranceName: $entranceName, ')
          ..write('coordsConfirmed: $coordsConfirmed, ')
          ..write('correctedLat: $correctedLat, ')
          ..write('correctedLng: $correctedLng, ')
          ..write('addressConfirmed: $addressConfirmed, ')
          ..write('stories: $stories, ')
          ..write('flats: $flats, ')
          ..write('elevators: $elevators, ')
          ..write('yearBuilt: $yearBuilt, ')
          ..write('groundFloorCommercial: $groundFloorCommercial, ')
          ..write('comment: $comment, ')
          ..write('surveyStatus: $surveyStatus, ')
          ..write('surveyedBy: $surveyedBy, ')
          ..write('surveyedAt: $surveyedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    syncState,
    lastError,
    buildingId,
    lat,
    lng,
    street,
    number,
    entranceName,
    coordsConfirmed,
    correctedLat,
    correctedLng,
    addressConfirmed,
    stories,
    flats,
    elevators,
    yearBuilt,
    groundFloorCommercial,
    comment,
    surveyStatus,
    surveyedBy,
    surveyedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntranceRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.lastError == this.lastError &&
          other.buildingId == this.buildingId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.street == this.street &&
          other.number == this.number &&
          other.entranceName == this.entranceName &&
          other.coordsConfirmed == this.coordsConfirmed &&
          other.correctedLat == this.correctedLat &&
          other.correctedLng == this.correctedLng &&
          other.addressConfirmed == this.addressConfirmed &&
          other.stories == this.stories &&
          other.flats == this.flats &&
          other.elevators == this.elevators &&
          other.yearBuilt == this.yearBuilt &&
          other.groundFloorCommercial == this.groundFloorCommercial &&
          other.comment == this.comment &&
          other.surveyStatus == this.surveyStatus &&
          other.surveyedBy == this.surveyedBy &&
          other.surveyedAt == this.surveyedAt);
}

class EntrancesCompanion extends UpdateCompanion<EntranceRow> {
  final Value<String> id;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<SyncState> syncState;
  final Value<String?> lastError;
  final Value<String> buildingId;
  final Value<double> lat;
  final Value<double> lng;
  final Value<String> street;
  final Value<String> number;
  final Value<String> entranceName;
  final Value<bool> coordsConfirmed;
  final Value<double?> correctedLat;
  final Value<double?> correctedLng;
  final Value<bool> addressConfirmed;
  final Value<int?> stories;
  final Value<int?> flats;
  final Value<int?> elevators;
  final Value<int?> yearBuilt;
  final Value<bool?> groundFloorCommercial;
  final Value<String?> comment;
  final Value<SurveyStatus> surveyStatus;
  final Value<String?> surveyedBy;
  final Value<String?> surveyedAt;
  final Value<int> rowid;
  const EntrancesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    this.buildingId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.street = const Value.absent(),
    this.number = const Value.absent(),
    this.entranceName = const Value.absent(),
    this.coordsConfirmed = const Value.absent(),
    this.correctedLat = const Value.absent(),
    this.correctedLng = const Value.absent(),
    this.addressConfirmed = const Value.absent(),
    this.stories = const Value.absent(),
    this.flats = const Value.absent(),
    this.elevators = const Value.absent(),
    this.yearBuilt = const Value.absent(),
    this.groundFloorCommercial = const Value.absent(),
    this.comment = const Value.absent(),
    this.surveyStatus = const Value.absent(),
    this.surveyedBy = const Value.absent(),
    this.surveyedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntrancesCompanion.insert({
    required String id,
    required String createdAt,
    required String updatedAt,
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    required String buildingId,
    required double lat,
    required double lng,
    required String street,
    required String number,
    required String entranceName,
    required bool coordsConfirmed,
    this.correctedLat = const Value.absent(),
    this.correctedLng = const Value.absent(),
    required bool addressConfirmed,
    this.stories = const Value.absent(),
    this.flats = const Value.absent(),
    this.elevators = const Value.absent(),
    this.yearBuilt = const Value.absent(),
    this.groundFloorCommercial = const Value.absent(),
    this.comment = const Value.absent(),
    required SurveyStatus surveyStatus,
    this.surveyedBy = const Value.absent(),
    this.surveyedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       buildingId = Value(buildingId),
       lat = Value(lat),
       lng = Value(lng),
       street = Value(street),
       number = Value(number),
       entranceName = Value(entranceName),
       coordsConfirmed = Value(coordsConfirmed),
       addressConfirmed = Value(addressConfirmed),
       surveyStatus = Value(surveyStatus);
  static Insertable<EntranceRow> custom({
    Expression<String>? id,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? syncState,
    Expression<String>? lastError,
    Expression<String>? buildingId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? street,
    Expression<String>? number,
    Expression<String>? entranceName,
    Expression<bool>? coordsConfirmed,
    Expression<double>? correctedLat,
    Expression<double>? correctedLng,
    Expression<bool>? addressConfirmed,
    Expression<int>? stories,
    Expression<int>? flats,
    Expression<int>? elevators,
    Expression<int>? yearBuilt,
    Expression<bool>? groundFloorCommercial,
    Expression<String>? comment,
    Expression<String>? surveyStatus,
    Expression<String>? surveyedBy,
    Expression<String>? surveyedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (lastError != null) 'last_error': lastError,
      if (buildingId != null) 'building_id': buildingId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (street != null) 'street': street,
      if (number != null) 'number': number,
      if (entranceName != null) 'entrance_name': entranceName,
      if (coordsConfirmed != null) 'coords_confirmed': coordsConfirmed,
      if (correctedLat != null) 'corrected_lat': correctedLat,
      if (correctedLng != null) 'corrected_lng': correctedLng,
      if (addressConfirmed != null) 'address_confirmed': addressConfirmed,
      if (stories != null) 'stories': stories,
      if (flats != null) 'flats': flats,
      if (elevators != null) 'elevators': elevators,
      if (yearBuilt != null) 'year_built': yearBuilt,
      if (groundFloorCommercial != null)
        'ground_floor_commercial': groundFloorCommercial,
      if (comment != null) 'comment': comment,
      if (surveyStatus != null) 'survey_status': surveyStatus,
      if (surveyedBy != null) 'surveyed_by': surveyedBy,
      if (surveyedAt != null) 'surveyed_at': surveyedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntrancesCompanion copyWith({
    Value<String>? id,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<SyncState>? syncState,
    Value<String?>? lastError,
    Value<String>? buildingId,
    Value<double>? lat,
    Value<double>? lng,
    Value<String>? street,
    Value<String>? number,
    Value<String>? entranceName,
    Value<bool>? coordsConfirmed,
    Value<double?>? correctedLat,
    Value<double?>? correctedLng,
    Value<bool>? addressConfirmed,
    Value<int?>? stories,
    Value<int?>? flats,
    Value<int?>? elevators,
    Value<int?>? yearBuilt,
    Value<bool?>? groundFloorCommercial,
    Value<String?>? comment,
    Value<SurveyStatus>? surveyStatus,
    Value<String?>? surveyedBy,
    Value<String?>? surveyedAt,
    Value<int>? rowid,
  }) {
    return EntrancesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      lastError: lastError ?? this.lastError,
      buildingId: buildingId ?? this.buildingId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      street: street ?? this.street,
      number: number ?? this.number,
      entranceName: entranceName ?? this.entranceName,
      coordsConfirmed: coordsConfirmed ?? this.coordsConfirmed,
      correctedLat: correctedLat ?? this.correctedLat,
      correctedLng: correctedLng ?? this.correctedLng,
      addressConfirmed: addressConfirmed ?? this.addressConfirmed,
      stories: stories ?? this.stories,
      flats: flats ?? this.flats,
      elevators: elevators ?? this.elevators,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      groundFloorCommercial:
          groundFloorCommercial ?? this.groundFloorCommercial,
      comment: comment ?? this.comment,
      surveyStatus: surveyStatus ?? this.surveyStatus,
      surveyedBy: surveyedBy ?? this.surveyedBy,
      surveyedAt: surveyedAt ?? this.surveyedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $EntrancesTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (buildingId.present) {
      map['building_id'] = Variable<String>(buildingId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (entranceName.present) {
      map['entrance_name'] = Variable<String>(entranceName.value);
    }
    if (coordsConfirmed.present) {
      map['coords_confirmed'] = Variable<bool>(coordsConfirmed.value);
    }
    if (correctedLat.present) {
      map['corrected_lat'] = Variable<double>(correctedLat.value);
    }
    if (correctedLng.present) {
      map['corrected_lng'] = Variable<double>(correctedLng.value);
    }
    if (addressConfirmed.present) {
      map['address_confirmed'] = Variable<bool>(addressConfirmed.value);
    }
    if (stories.present) {
      map['stories'] = Variable<int>(stories.value);
    }
    if (flats.present) {
      map['flats'] = Variable<int>(flats.value);
    }
    if (elevators.present) {
      map['elevators'] = Variable<int>(elevators.value);
    }
    if (yearBuilt.present) {
      map['year_built'] = Variable<int>(yearBuilt.value);
    }
    if (groundFloorCommercial.present) {
      map['ground_floor_commercial'] = Variable<bool>(
        groundFloorCommercial.value,
      );
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (surveyStatus.present) {
      map['survey_status'] = Variable<String>(
        $EntrancesTable.$convertersurveyStatus.toSql(surveyStatus.value),
      );
    }
    if (surveyedBy.present) {
      map['surveyed_by'] = Variable<String>(surveyedBy.value);
    }
    if (surveyedAt.present) {
      map['surveyed_at'] = Variable<String>(surveyedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntrancesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('buildingId: $buildingId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('street: $street, ')
          ..write('number: $number, ')
          ..write('entranceName: $entranceName, ')
          ..write('coordsConfirmed: $coordsConfirmed, ')
          ..write('correctedLat: $correctedLat, ')
          ..write('correctedLng: $correctedLng, ')
          ..write('addressConfirmed: $addressConfirmed, ')
          ..write('stories: $stories, ')
          ..write('flats: $flats, ')
          ..write('elevators: $elevators, ')
          ..write('yearBuilt: $yearBuilt, ')
          ..write('groundFloorCommercial: $groundFloorCommercial, ')
          ..write('comment: $comment, ')
          ..write('surveyStatus: $surveyStatus, ')
          ..write('surveyedBy: $surveyedBy, ')
          ..write('surveyedAt: $surveyedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, PhotoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncState>($PhotosTable.$convertersyncState);
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entranceIdMeta = const VerificationMeta(
    'entranceId',
  );
  @override
  late final GeneratedColumn<String> entranceId = GeneratedColumn<String>(
    'entrance_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entrances (id)',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteUrlMeta = const VerificationMeta(
    'remoteUrl',
  );
  @override
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
    'remote_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<String> takenAt = GeneratedColumn<String>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headingMeta = const VerificationMeta(
    'heading',
  );
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
    'heading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UploadState, String> uploadState =
      GeneratedColumn<String>(
        'upload_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<UploadState>($PhotosTable.$converteruploadState);
  @override
  late final GeneratedColumnWithTypeConverter<ReviewStatus, String>
  reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  ).withConverter<ReviewStatus>($PhotosTable.$converterreviewStatus);
  static const VerificationMeta _reviewNoteMeta = const VerificationMeta(
    'reviewNote',
  );
  @override
  late final GeneratedColumn<String> reviewNote = GeneratedColumn<String>(
    'review_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewedByMeta = const VerificationMeta(
    'reviewedBy',
  );
  @override
  late final GeneratedColumn<String> reviewedBy = GeneratedColumn<String>(
    'reviewed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replacesPhotoIdMeta = const VerificationMeta(
    'replacesPhotoId',
  );
  @override
  late final GeneratedColumn<String> replacesPhotoId = GeneratedColumn<String>(
    'replaces_photo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localUriMeta = const VerificationMeta(
    'localUri',
  );
  @override
  late final GeneratedColumn<String> localUri = GeneratedColumn<String>(
    'local_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    syncState,
    lastError,
    entranceId,
    fileName,
    remoteUrl,
    takenAt,
    lat,
    lng,
    heading,
    uploadState,
    reviewStatus,
    reviewNote,
    reviewedBy,
    replacesPhotoId,
    localUri,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhotoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('entrance_id')) {
      context.handle(
        _entranceIdMeta,
        entranceId.isAcceptableOrUnknown(data['entrance_id']!, _entranceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entranceIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('remote_url')) {
      context.handle(
        _remoteUrlMeta,
        remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta),
      );
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('heading')) {
      context.handle(
        _headingMeta,
        heading.isAcceptableOrUnknown(data['heading']!, _headingMeta),
      );
    }
    if (data.containsKey('review_note')) {
      context.handle(
        _reviewNoteMeta,
        reviewNote.isAcceptableOrUnknown(data['review_note']!, _reviewNoteMeta),
      );
    }
    if (data.containsKey('reviewed_by')) {
      context.handle(
        _reviewedByMeta,
        reviewedBy.isAcceptableOrUnknown(data['reviewed_by']!, _reviewedByMeta),
      );
    }
    if (data.containsKey('replaces_photo_id')) {
      context.handle(
        _replacesPhotoIdMeta,
        replacesPhotoId.isAcceptableOrUnknown(
          data['replaces_photo_id']!,
          _replacesPhotoIdMeta,
        ),
      );
    }
    if (data.containsKey('local_uri')) {
      context.handle(
        _localUriMeta,
        localUri.isAcceptableOrUnknown(data['local_uri']!, _localUriMeta),
      );
    } else if (isInserting) {
      context.missing(_localUriMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      syncState: $PhotosTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      entranceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entrance_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      remoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_url'],
      ),
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}taken_at'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      heading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading'],
      ),
      uploadState: $PhotosTable.$converteruploadState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}upload_state'],
        )!,
      ),
      reviewStatus: $PhotosTable.$converterreviewStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}review_status'],
        )!,
      ),
      reviewNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_note'],
      ),
      reviewedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewed_by'],
      ),
      replacesPhotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}replaces_photo_id'],
      ),
      localUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_uri'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
  static JsonTypeConverter2<UploadState, String, String> $converteruploadState =
      const EnumNameConverter<UploadState>(UploadState.values);
  static JsonTypeConverter2<ReviewStatus, String, String>
  $converterreviewStatus = const EnumNameConverter<ReviewStatus>(
    ReviewStatus.values,
  );
}

class PhotoRow extends DataClass implements Insertable<PhotoRow> {
  final String id;
  final String createdAt;
  final String updatedAt;
  final SyncState syncState;
  final String? lastError;
  final String entranceId;
  final String fileName;
  final String? remoteUrl;
  final String takenAt;
  final double? lat;
  final double? lng;
  final double? heading;
  final UploadState uploadState;
  final ReviewStatus reviewStatus;
  final String? reviewNote;
  final String? reviewedBy;
  final String? replacesPhotoId;

  /// Where the file is on this phone (local-only, like syncState).
  final String localUri;
  const PhotoRow({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.syncState,
    this.lastError,
    required this.entranceId,
    required this.fileName,
    this.remoteUrl,
    required this.takenAt,
    this.lat,
    this.lng,
    this.heading,
    required this.uploadState,
    required this.reviewStatus,
    this.reviewNote,
    this.reviewedBy,
    this.replacesPhotoId,
    required this.localUri,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    {
      map['sync_state'] = Variable<String>(
        $PhotosTable.$convertersyncState.toSql(syncState),
      );
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['entrance_id'] = Variable<String>(entranceId);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    map['taken_at'] = Variable<String>(takenAt);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<double>(heading);
    }
    {
      map['upload_state'] = Variable<String>(
        $PhotosTable.$converteruploadState.toSql(uploadState),
      );
    }
    {
      map['review_status'] = Variable<String>(
        $PhotosTable.$converterreviewStatus.toSql(reviewStatus),
      );
    }
    if (!nullToAbsent || reviewNote != null) {
      map['review_note'] = Variable<String>(reviewNote);
    }
    if (!nullToAbsent || reviewedBy != null) {
      map['reviewed_by'] = Variable<String>(reviewedBy);
    }
    if (!nullToAbsent || replacesPhotoId != null) {
      map['replaces_photo_id'] = Variable<String>(replacesPhotoId);
    }
    map['local_uri'] = Variable<String>(localUri);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncState: Value(syncState),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      entranceId: Value(entranceId),
      fileName: Value(fileName),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      takenAt: Value(takenAt),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
      uploadState: Value(uploadState),
      reviewStatus: Value(reviewStatus),
      reviewNote: reviewNote == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewNote),
      reviewedBy: reviewedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedBy),
      replacesPhotoId: replacesPhotoId == null && nullToAbsent
          ? const Value.absent()
          : Value(replacesPhotoId),
      localUri: Value(localUri),
    );
  }

  factory PhotoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoRow(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      syncState: $PhotosTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
      entranceId: serializer.fromJson<String>(json['entranceId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      takenAt: serializer.fromJson<String>(json['takenAt']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      heading: serializer.fromJson<double?>(json['heading']),
      uploadState: $PhotosTable.$converteruploadState.fromJson(
        serializer.fromJson<String>(json['uploadState']),
      ),
      reviewStatus: $PhotosTable.$converterreviewStatus.fromJson(
        serializer.fromJson<String>(json['reviewStatus']),
      ),
      reviewNote: serializer.fromJson<String?>(json['reviewNote']),
      reviewedBy: serializer.fromJson<String?>(json['reviewedBy']),
      replacesPhotoId: serializer.fromJson<String?>(json['replacesPhotoId']),
      localUri: serializer.fromJson<String>(json['localUri']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'syncState': serializer.toJson<String>(
        $PhotosTable.$convertersyncState.toJson(syncState),
      ),
      'lastError': serializer.toJson<String?>(lastError),
      'entranceId': serializer.toJson<String>(entranceId),
      'fileName': serializer.toJson<String>(fileName),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'takenAt': serializer.toJson<String>(takenAt),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'heading': serializer.toJson<double?>(heading),
      'uploadState': serializer.toJson<String>(
        $PhotosTable.$converteruploadState.toJson(uploadState),
      ),
      'reviewStatus': serializer.toJson<String>(
        $PhotosTable.$converterreviewStatus.toJson(reviewStatus),
      ),
      'reviewNote': serializer.toJson<String?>(reviewNote),
      'reviewedBy': serializer.toJson<String?>(reviewedBy),
      'replacesPhotoId': serializer.toJson<String?>(replacesPhotoId),
      'localUri': serializer.toJson<String>(localUri),
    };
  }

  PhotoRow copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    SyncState? syncState,
    Value<String?> lastError = const Value.absent(),
    String? entranceId,
    String? fileName,
    Value<String?> remoteUrl = const Value.absent(),
    String? takenAt,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<double?> heading = const Value.absent(),
    UploadState? uploadState,
    ReviewStatus? reviewStatus,
    Value<String?> reviewNote = const Value.absent(),
    Value<String?> reviewedBy = const Value.absent(),
    Value<String?> replacesPhotoId = const Value.absent(),
    String? localUri,
  }) => PhotoRow(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncState: syncState ?? this.syncState,
    lastError: lastError.present ? lastError.value : this.lastError,
    entranceId: entranceId ?? this.entranceId,
    fileName: fileName ?? this.fileName,
    remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
    takenAt: takenAt ?? this.takenAt,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    heading: heading.present ? heading.value : this.heading,
    uploadState: uploadState ?? this.uploadState,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    reviewNote: reviewNote.present ? reviewNote.value : this.reviewNote,
    reviewedBy: reviewedBy.present ? reviewedBy.value : this.reviewedBy,
    replacesPhotoId: replacesPhotoId.present
        ? replacesPhotoId.value
        : this.replacesPhotoId,
    localUri: localUri ?? this.localUri,
  );
  PhotoRow copyWithCompanion(PhotosCompanion data) {
    return PhotoRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      entranceId: data.entranceId.present
          ? data.entranceId.value
          : this.entranceId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      heading: data.heading.present ? data.heading.value : this.heading,
      uploadState: data.uploadState.present
          ? data.uploadState.value
          : this.uploadState,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      reviewNote: data.reviewNote.present
          ? data.reviewNote.value
          : this.reviewNote,
      reviewedBy: data.reviewedBy.present
          ? data.reviewedBy.value
          : this.reviewedBy,
      replacesPhotoId: data.replacesPhotoId.present
          ? data.replacesPhotoId.value
          : this.replacesPhotoId,
      localUri: data.localUri.present ? data.localUri.value : this.localUri,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('entranceId: $entranceId, ')
          ..write('fileName: $fileName, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('takenAt: $takenAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('heading: $heading, ')
          ..write('uploadState: $uploadState, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('reviewedBy: $reviewedBy, ')
          ..write('replacesPhotoId: $replacesPhotoId, ')
          ..write('localUri: $localUri')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    syncState,
    lastError,
    entranceId,
    fileName,
    remoteUrl,
    takenAt,
    lat,
    lng,
    heading,
    uploadState,
    reviewStatus,
    reviewNote,
    reviewedBy,
    replacesPhotoId,
    localUri,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.lastError == this.lastError &&
          other.entranceId == this.entranceId &&
          other.fileName == this.fileName &&
          other.remoteUrl == this.remoteUrl &&
          other.takenAt == this.takenAt &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.heading == this.heading &&
          other.uploadState == this.uploadState &&
          other.reviewStatus == this.reviewStatus &&
          other.reviewNote == this.reviewNote &&
          other.reviewedBy == this.reviewedBy &&
          other.replacesPhotoId == this.replacesPhotoId &&
          other.localUri == this.localUri);
}

class PhotosCompanion extends UpdateCompanion<PhotoRow> {
  final Value<String> id;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<SyncState> syncState;
  final Value<String?> lastError;
  final Value<String> entranceId;
  final Value<String> fileName;
  final Value<String?> remoteUrl;
  final Value<String> takenAt;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<double?> heading;
  final Value<UploadState> uploadState;
  final Value<ReviewStatus> reviewStatus;
  final Value<String?> reviewNote;
  final Value<String?> reviewedBy;
  final Value<String?> replacesPhotoId;
  final Value<String> localUri;
  final Value<int> rowid;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    this.entranceId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.heading = const Value.absent(),
    this.uploadState = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.reviewedBy = const Value.absent(),
    this.replacesPhotoId = const Value.absent(),
    this.localUri = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosCompanion.insert({
    required String id,
    required String createdAt,
    required String updatedAt,
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    required String entranceId,
    required String fileName,
    this.remoteUrl = const Value.absent(),
    required String takenAt,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.heading = const Value.absent(),
    this.uploadState = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.reviewedBy = const Value.absent(),
    this.replacesPhotoId = const Value.absent(),
    required String localUri,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       entranceId = Value(entranceId),
       fileName = Value(fileName),
       takenAt = Value(takenAt),
       localUri = Value(localUri);
  static Insertable<PhotoRow> custom({
    Expression<String>? id,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? syncState,
    Expression<String>? lastError,
    Expression<String>? entranceId,
    Expression<String>? fileName,
    Expression<String>? remoteUrl,
    Expression<String>? takenAt,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<double>? heading,
    Expression<String>? uploadState,
    Expression<String>? reviewStatus,
    Expression<String>? reviewNote,
    Expression<String>? reviewedBy,
    Expression<String>? replacesPhotoId,
    Expression<String>? localUri,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (lastError != null) 'last_error': lastError,
      if (entranceId != null) 'entrance_id': entranceId,
      if (fileName != null) 'file_name': fileName,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (takenAt != null) 'taken_at': takenAt,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (heading != null) 'heading': heading,
      if (uploadState != null) 'upload_state': uploadState,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (reviewNote != null) 'review_note': reviewNote,
      if (reviewedBy != null) 'reviewed_by': reviewedBy,
      if (replacesPhotoId != null) 'replaces_photo_id': replacesPhotoId,
      if (localUri != null) 'local_uri': localUri,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<SyncState>? syncState,
    Value<String?>? lastError,
    Value<String>? entranceId,
    Value<String>? fileName,
    Value<String?>? remoteUrl,
    Value<String>? takenAt,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<double?>? heading,
    Value<UploadState>? uploadState,
    Value<ReviewStatus>? reviewStatus,
    Value<String?>? reviewNote,
    Value<String?>? reviewedBy,
    Value<String?>? replacesPhotoId,
    Value<String>? localUri,
    Value<int>? rowid,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      lastError: lastError ?? this.lastError,
      entranceId: entranceId ?? this.entranceId,
      fileName: fileName ?? this.fileName,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      takenAt: takenAt ?? this.takenAt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      heading: heading ?? this.heading,
      uploadState: uploadState ?? this.uploadState,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewNote: reviewNote ?? this.reviewNote,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      replacesPhotoId: replacesPhotoId ?? this.replacesPhotoId,
      localUri: localUri ?? this.localUri,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $PhotosTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (entranceId.present) {
      map['entrance_id'] = Variable<String>(entranceId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<String>(takenAt.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    if (uploadState.present) {
      map['upload_state'] = Variable<String>(
        $PhotosTable.$converteruploadState.toSql(uploadState.value),
      );
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(
        $PhotosTable.$converterreviewStatus.toSql(reviewStatus.value),
      );
    }
    if (reviewNote.present) {
      map['review_note'] = Variable<String>(reviewNote.value);
    }
    if (reviewedBy.present) {
      map['reviewed_by'] = Variable<String>(reviewedBy.value);
    }
    if (replacesPhotoId.present) {
      map['replaces_photo_id'] = Variable<String>(replacesPhotoId.value);
    }
    if (localUri.present) {
      map['local_uri'] = Variable<String>(localUri.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('entranceId: $entranceId, ')
          ..write('fileName: $fileName, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('takenAt: $takenAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('heading: $heading, ')
          ..write('uploadState: $uploadState, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('reviewedBy: $reviewedBy, ')
          ..write('replacesPhotoId: $replacesPhotoId, ')
          ..write('localUri: $localUri, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BuildingsTable buildings = $BuildingsTable(this);
  late final $EntrancesTable entrances = $EntrancesTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    buildings,
    entrances,
    photos,
  ];
}

typedef $$BuildingsTableCreateCompanionBuilder = BuildingsCompanion Function({
  required String id,
  required String createdAt,
  required String updatedAt,
  Value<SyncState> syncState,
  Value<String?> lastError,
  required String label,
  Value<String?> comment,
  Value<int> rowid,
});
typedef $$BuildingsTableUpdateCompanionBuilder = BuildingsCompanion Function({
  Value<String> id,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<SyncState> syncState,
  Value<String?> lastError,
  Value<String> label,
  Value<String?> comment,
  Value<int> rowid,
});

final class $$BuildingsTableReferences
    extends BaseReferences<_$AppDatabase, $BuildingsTable, BuildingRow> {
  $$BuildingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntrancesTable, List<EntranceRow>>
  _entrancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.entrances,
    aliasName: 'buildings__id__entrances__building_id',
  );

  $$EntrancesTableProcessedTableManager get entrancesRefs {
    final manager = $$EntrancesTableTableManager(
      $_db,
      $_db.entrances,
    ).filter((f) => f.buildingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entrancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BuildingsTableFilterComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> entrancesRefs(
    Expression<bool> Function($$EntrancesTableFilterComposer f) f,
  ) {
    final $$EntrancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entrances,
      getReferencedColumn: (t) => t.buildingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntrancesTableFilterComposer(
            $db: $db,
            $table: $db.entrances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuildingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BuildingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BuildingsTable> {
  $$BuildingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  Expression<T> entrancesRefs<T extends Object>(
    Expression<T> Function($$EntrancesTableAnnotationComposer a) f,
  ) {
    final $$EntrancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entrances,
      getReferencedColumn: (t) => t.buildingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntrancesTableAnnotationComposer(
            $db: $db,
            $table: $db.entrances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuildingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BuildingsTable,
          BuildingRow,
          $$BuildingsTableFilterComposer,
          $$BuildingsTableOrderingComposer,
          $$BuildingsTableAnnotationComposer,
          $$BuildingsTableCreateCompanionBuilder,
          $$BuildingsTableUpdateCompanionBuilder,
          (BuildingRow, $$BuildingsTableReferences),
          BuildingRow,
          PrefetchHooks Function({bool entrancesRefs})
        > {
  $$BuildingsTableTableManager(_$AppDatabase db, $BuildingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BuildingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BuildingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BuildingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BuildingsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncState: syncState,
                lastError: lastError,
                label: label,
                comment: comment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String createdAt,
                required String updatedAt,
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String label,
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BuildingsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncState: syncState,
                lastError: lastError,
                label: label,
                comment: comment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BuildingsTable, BuildingRow>(table),
                  $$BuildingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entrancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entrancesRefs) db.entrances],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entrancesRefs)
                    await $_getPrefetchedDataByColumns<
                      BuildingRow,
                      $BuildingsTable,
                      EntranceRow,
                      $EntrancesTable
                    >(
                      currentTable: table,
                      referencedTable: $$BuildingsTableReferences
                          ._entrancesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BuildingsTableReferences(
                            db,
                            table,
                            p0,
                          ).entrancesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'building_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BuildingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BuildingsTable,
      BuildingRow,
      $$BuildingsTableFilterComposer,
      $$BuildingsTableOrderingComposer,
      $$BuildingsTableAnnotationComposer,
      $$BuildingsTableCreateCompanionBuilder,
      $$BuildingsTableUpdateCompanionBuilder,
      (BuildingRow, $$BuildingsTableReferences),
      BuildingRow,
      PrefetchHooks Function({bool entrancesRefs})
    >;
typedef $$EntrancesTableCreateCompanionBuilder = EntrancesCompanion Function({
  required String id,
  required String createdAt,
  required String updatedAt,
  Value<SyncState> syncState,
  Value<String?> lastError,
  required String buildingId,
  required double lat,
  required double lng,
  required String street,
  required String number,
  required String entranceName,
  required bool coordsConfirmed,
  Value<double?> correctedLat,
  Value<double?> correctedLng,
  required bool addressConfirmed,
  Value<int?> stories,
  Value<int?> flats,
  Value<int?> elevators,
  Value<int?> yearBuilt,
  Value<bool?> groundFloorCommercial,
  Value<String?> comment,
  required SurveyStatus surveyStatus,
  Value<String?> surveyedBy,
  Value<String?> surveyedAt,
  Value<int> rowid,
});
typedef $$EntrancesTableUpdateCompanionBuilder = EntrancesCompanion Function({
  Value<String> id,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<SyncState> syncState,
  Value<String?> lastError,
  Value<String> buildingId,
  Value<double> lat,
  Value<double> lng,
  Value<String> street,
  Value<String> number,
  Value<String> entranceName,
  Value<bool> coordsConfirmed,
  Value<double?> correctedLat,
  Value<double?> correctedLng,
  Value<bool> addressConfirmed,
  Value<int?> stories,
  Value<int?> flats,
  Value<int?> elevators,
  Value<int?> yearBuilt,
  Value<bool?> groundFloorCommercial,
  Value<String?> comment,
  Value<SurveyStatus> surveyStatus,
  Value<String?> surveyedBy,
  Value<String?> surveyedAt,
  Value<int> rowid,
});

final class $$EntrancesTableReferences
    extends BaseReferences<_$AppDatabase, $EntrancesTable, EntranceRow> {
  $$EntrancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BuildingsTable _buildingIdTable(_$AppDatabase db) =>
      db.buildings.createAlias('entrances__building_id__buildings__id');

  $$BuildingsTableProcessedTableManager get buildingId {
    final $_column = $_itemColumn<String>('building_id')!;

    final manager = $$BuildingsTableTableManager(
      $_db,
      $_db.buildings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_buildingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<PhotoRow>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: 'entrances__id__photos__entrance_id',
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.entranceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EntrancesTableFilterComposer
    extends Composer<_$AppDatabase, $EntrancesTable> {
  $$EntrancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entranceName => $composableBuilder(
    column: $table.entranceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get coordsConfirmed => $composableBuilder(
    column: $table.coordsConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get correctedLat => $composableBuilder(
    column: $table.correctedLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get correctedLng => $composableBuilder(
    column: $table.correctedLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get addressConfirmed => $composableBuilder(
    column: $table.addressConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stories => $composableBuilder(
    column: $table.stories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flats => $composableBuilder(
    column: $table.flats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elevators => $composableBuilder(
    column: $table.elevators,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearBuilt => $composableBuilder(
    column: $table.yearBuilt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get groundFloorCommercial => $composableBuilder(
    column: $table.groundFloorCommercial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SurveyStatus, SurveyStatus, String>
  get surveyStatus => $composableBuilder(
    column: $table.surveyStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get surveyedBy => $composableBuilder(
    column: $table.surveyedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surveyedAt => $composableBuilder(
    column: $table.surveyedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BuildingsTableFilterComposer get buildingId {
    final $$BuildingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buildingId,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableFilterComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.entranceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntrancesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntrancesTable> {
  $$EntrancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entranceName => $composableBuilder(
    column: $table.entranceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get coordsConfirmed => $composableBuilder(
    column: $table.coordsConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get correctedLat => $composableBuilder(
    column: $table.correctedLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get correctedLng => $composableBuilder(
    column: $table.correctedLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get addressConfirmed => $composableBuilder(
    column: $table.addressConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stories => $composableBuilder(
    column: $table.stories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flats => $composableBuilder(
    column: $table.flats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elevators => $composableBuilder(
    column: $table.elevators,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearBuilt => $composableBuilder(
    column: $table.yearBuilt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get groundFloorCommercial => $composableBuilder(
    column: $table.groundFloorCommercial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surveyStatus => $composableBuilder(
    column: $table.surveyStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surveyedBy => $composableBuilder(
    column: $table.surveyedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surveyedAt => $composableBuilder(
    column: $table.surveyedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BuildingsTableOrderingComposer get buildingId {
    final $$BuildingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buildingId,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableOrderingComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntrancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntrancesTable> {
  $$EntrancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get entranceName => $composableBuilder(
    column: $table.entranceName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get coordsConfirmed => $composableBuilder(
    column: $table.coordsConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get correctedLat => $composableBuilder(
    column: $table.correctedLat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get correctedLng => $composableBuilder(
    column: $table.correctedLng,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get addressConfirmed => $composableBuilder(
    column: $table.addressConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stories =>
      $composableBuilder(column: $table.stories, builder: (column) => column);

  GeneratedColumn<int> get flats =>
      $composableBuilder(column: $table.flats, builder: (column) => column);

  GeneratedColumn<int> get elevators =>
      $composableBuilder(column: $table.elevators, builder: (column) => column);

  GeneratedColumn<int> get yearBuilt =>
      $composableBuilder(column: $table.yearBuilt, builder: (column) => column);

  GeneratedColumn<bool> get groundFloorCommercial => $composableBuilder(
    column: $table.groundFloorCommercial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SurveyStatus, String> get surveyStatus =>
      $composableBuilder(
        column: $table.surveyStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get surveyedBy => $composableBuilder(
    column: $table.surveyedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get surveyedAt => $composableBuilder(
    column: $table.surveyedAt,
    builder: (column) => column,
  );

  $$BuildingsTableAnnotationComposer get buildingId {
    final $$BuildingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buildingId,
      referencedTable: $db.buildings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingsTableAnnotationComposer(
            $db: $db,
            $table: $db.buildings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.entranceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntrancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntrancesTable,
          EntranceRow,
          $$EntrancesTableFilterComposer,
          $$EntrancesTableOrderingComposer,
          $$EntrancesTableAnnotationComposer,
          $$EntrancesTableCreateCompanionBuilder,
          $$EntrancesTableUpdateCompanionBuilder,
          (EntranceRow, $$EntrancesTableReferences),
          EntranceRow,
          PrefetchHooks Function({bool buildingId, bool photosRefs})
        > {
  $$EntrancesTableTableManager(_$AppDatabase db, $EntrancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntrancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntrancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntrancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> buildingId = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<String> street = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<String> entranceName = const Value.absent(),
                Value<bool> coordsConfirmed = const Value.absent(),
                Value<double?> correctedLat = const Value.absent(),
                Value<double?> correctedLng = const Value.absent(),
                Value<bool> addressConfirmed = const Value.absent(),
                Value<int?> stories = const Value.absent(),
                Value<int?> flats = const Value.absent(),
                Value<int?> elevators = const Value.absent(),
                Value<int?> yearBuilt = const Value.absent(),
                Value<bool?> groundFloorCommercial = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<SurveyStatus> surveyStatus = const Value.absent(),
                Value<String?> surveyedBy = const Value.absent(),
                Value<String?> surveyedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntrancesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncState: syncState,
                lastError: lastError,
                buildingId: buildingId,
                lat: lat,
                lng: lng,
                street: street,
                number: number,
                entranceName: entranceName,
                coordsConfirmed: coordsConfirmed,
                correctedLat: correctedLat,
                correctedLng: correctedLng,
                addressConfirmed: addressConfirmed,
                stories: stories,
                flats: flats,
                elevators: elevators,
                yearBuilt: yearBuilt,
                groundFloorCommercial: groundFloorCommercial,
                comment: comment,
                surveyStatus: surveyStatus,
                surveyedBy: surveyedBy,
                surveyedAt: surveyedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String createdAt,
                required String updatedAt,
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String buildingId,
                required double lat,
                required double lng,
                required String street,
                required String number,
                required String entranceName,
                required bool coordsConfirmed,
                Value<double?> correctedLat = const Value.absent(),
                Value<double?> correctedLng = const Value.absent(),
                required bool addressConfirmed,
                Value<int?> stories = const Value.absent(),
                Value<int?> flats = const Value.absent(),
                Value<int?> elevators = const Value.absent(),
                Value<int?> yearBuilt = const Value.absent(),
                Value<bool?> groundFloorCommercial = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                required SurveyStatus surveyStatus,
                Value<String?> surveyedBy = const Value.absent(),
                Value<String?> surveyedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntrancesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncState: syncState,
                lastError: lastError,
                buildingId: buildingId,
                lat: lat,
                lng: lng,
                street: street,
                number: number,
                entranceName: entranceName,
                coordsConfirmed: coordsConfirmed,
                correctedLat: correctedLat,
                correctedLng: correctedLng,
                addressConfirmed: addressConfirmed,
                stories: stories,
                flats: flats,
                elevators: elevators,
                yearBuilt: yearBuilt,
                groundFloorCommercial: groundFloorCommercial,
                comment: comment,
                surveyStatus: surveyStatus,
                surveyedBy: surveyedBy,
                surveyedAt: surveyedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EntrancesTable, EntranceRow>(table),
                  $$EntrancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({buildingId = false, photosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (photosRefs) db.photos],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (buildingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.buildingId,
                        referencedTable: $$EntrancesTableReferences
                            ._buildingIdTable(db),
                        referencedColumn: $$EntrancesTableReferences
                            ._buildingIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (photosRefs)
                    await $_getPrefetchedDataByColumns<
                      EntranceRow,
                      $EntrancesTable,
                      PhotoRow,
                      $PhotosTable
                    >(
                      currentTable: table,
                      referencedTable: $$EntrancesTableReferences
                          ._photosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EntrancesTableReferences(db, table, p0).photosRefs,
                      currentColumn: 'id',
                      referencedColumn: 'entrance_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EntrancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntrancesTable,
      EntranceRow,
      $$EntrancesTableFilterComposer,
      $$EntrancesTableOrderingComposer,
      $$EntrancesTableAnnotationComposer,
      $$EntrancesTableCreateCompanionBuilder,
      $$EntrancesTableUpdateCompanionBuilder,
      (EntranceRow, $$EntrancesTableReferences),
      EntranceRow,
      PrefetchHooks Function({bool buildingId, bool photosRefs})
    >;
typedef $$PhotosTableCreateCompanionBuilder = PhotosCompanion Function({
  required String id,
  required String createdAt,
  required String updatedAt,
  Value<SyncState> syncState,
  Value<String?> lastError,
  required String entranceId,
  required String fileName,
  Value<String?> remoteUrl,
  required String takenAt,
  Value<double?> lat,
  Value<double?> lng,
  Value<double?> heading,
  Value<UploadState> uploadState,
  Value<ReviewStatus> reviewStatus,
  Value<String?> reviewNote,
  Value<String?> reviewedBy,
  Value<String?> replacesPhotoId,
  required String localUri,
  Value<int> rowid,
});
typedef $$PhotosTableUpdateCompanionBuilder = PhotosCompanion Function({
  Value<String> id,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<SyncState> syncState,
  Value<String?> lastError,
  Value<String> entranceId,
  Value<String> fileName,
  Value<String?> remoteUrl,
  Value<String> takenAt,
  Value<double?> lat,
  Value<double?> lng,
  Value<double?> heading,
  Value<UploadState> uploadState,
  Value<ReviewStatus> reviewStatus,
  Value<String?> reviewNote,
  Value<String?> reviewedBy,
  Value<String?> replacesPhotoId,
  Value<String> localUri,
  Value<int> rowid,
});

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, PhotoRow> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntrancesTable _entranceIdTable(_$AppDatabase db) =>
      db.entrances.createAlias('photos__entrance_id__entrances__id');

  $$EntrancesTableProcessedTableManager get entranceId {
    final $_column = $_itemColumn<String>('entrance_id')!;

    final manager = $$EntrancesTableTableManager(
      $_db,
      $_db.entrances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entranceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UploadState, UploadState, String>
  get uploadState => $composableBuilder(
    column: $table.uploadState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewStatus, ReviewStatus, String>
  get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewedBy => $composableBuilder(
    column: $table.reviewedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replacesPhotoId => $composableBuilder(
    column: $table.replacesPhotoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localUri => $composableBuilder(
    column: $table.localUri,
    builder: (column) => ColumnFilters(column),
  );

  $$EntrancesTableFilterComposer get entranceId {
    final $$EntrancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entranceId,
      referencedTable: $db.entrances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntrancesTableFilterComposer(
            $db: $db,
            $table: $db.entrances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadState => $composableBuilder(
    column: $table.uploadState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewedBy => $composableBuilder(
    column: $table.reviewedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replacesPhotoId => $composableBuilder(
    column: $table.replacesPhotoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localUri => $composableBuilder(
    column: $table.localUri,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntrancesTableOrderingComposer get entranceId {
    final $$EntrancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entranceId,
      referencedTable: $db.entrances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntrancesTableOrderingComposer(
            $db: $db,
            $table: $db.entrances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get remoteUrl =>
      $composableBuilder(column: $table.remoteUrl, builder: (column) => column);

  GeneratedColumn<String> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<double> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UploadState, String> get uploadState =>
      $composableBuilder(
        column: $table.uploadState,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ReviewStatus, String> get reviewStatus =>
      $composableBuilder(
        column: $table.reviewStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewedBy => $composableBuilder(
    column: $table.reviewedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replacesPhotoId => $composableBuilder(
    column: $table.replacesPhotoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localUri =>
      $composableBuilder(column: $table.localUri, builder: (column) => column);

  $$EntrancesTableAnnotationComposer get entranceId {
    final $$EntrancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entranceId,
      referencedTable: $db.entrances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntrancesTableAnnotationComposer(
            $db: $db,
            $table: $db.entrances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          PhotoRow,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (PhotoRow, $$PhotosTableReferences),
          PhotoRow,
          PrefetchHooks Function({bool entranceId})
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> entranceId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<String> takenAt = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> heading = const Value.absent(),
                Value<UploadState> uploadState = const Value.absent(),
                Value<ReviewStatus> reviewStatus = const Value.absent(),
                Value<String?> reviewNote = const Value.absent(),
                Value<String?> reviewedBy = const Value.absent(),
                Value<String?> replacesPhotoId = const Value.absent(),
                Value<String> localUri = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncState: syncState,
                lastError: lastError,
                entranceId: entranceId,
                fileName: fileName,
                remoteUrl: remoteUrl,
                takenAt: takenAt,
                lat: lat,
                lng: lng,
                heading: heading,
                uploadState: uploadState,
                reviewStatus: reviewStatus,
                reviewNote: reviewNote,
                reviewedBy: reviewedBy,
                replacesPhotoId: replacesPhotoId,
                localUri: localUri,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String createdAt,
                required String updatedAt,
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String entranceId,
                required String fileName,
                Value<String?> remoteUrl = const Value.absent(),
                required String takenAt,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> heading = const Value.absent(),
                Value<UploadState> uploadState = const Value.absent(),
                Value<ReviewStatus> reviewStatus = const Value.absent(),
                Value<String?> reviewNote = const Value.absent(),
                Value<String?> reviewedBy = const Value.absent(),
                Value<String?> replacesPhotoId = const Value.absent(),
                required String localUri,
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncState: syncState,
                lastError: lastError,
                entranceId: entranceId,
                fileName: fileName,
                remoteUrl: remoteUrl,
                takenAt: takenAt,
                lat: lat,
                lng: lng,
                heading: heading,
                uploadState: uploadState,
                reviewStatus: reviewStatus,
                reviewNote: reviewNote,
                reviewedBy: reviewedBy,
                replacesPhotoId: replacesPhotoId,
                localUri: localUri,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PhotosTable, PhotoRow>(table),
                  $$PhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entranceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entranceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entranceId,
                        referencedTable: $$PhotosTableReferences
                            ._entranceIdTable(db),
                        referencedColumn: $$PhotosTableReferences
                            ._entranceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      PhotoRow,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (PhotoRow, $$PhotosTableReferences),
      PhotoRow,
      PrefetchHooks Function({bool entranceId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BuildingsTableTableManager get buildings =>
      $$BuildingsTableTableManager(_db, _db.buildings);
  $$EntrancesTableTableManager get entrances =>
      $$EntrancesTableTableManager(_db, _db.entrances);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
}
