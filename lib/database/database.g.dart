// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppUsersTable extends AppUsers with TableInfo<$AppUsersTable, AppUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    password,
    role,
    address,
    phone,
    latitude,
    longitude,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppUsersTable createAlias(String alias) {
    return $AppUsersTable(attachedDatabase, alias);
  }
}

class AppUser extends DataClass implements Insertable<AppUser> {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    map['address'] = Variable<String>(address);
    map['phone'] = Variable<String>(phone);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppUsersCompanion toCompanion(bool nullToAbsent) {
    return AppUsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      password: Value(password),
      role: Value(role),
      address: Value(address),
      phone: Value(phone),
      latitude: Value(latitude),
      longitude: Value(longitude),
      createdAt: Value(createdAt),
    );
  }

  factory AppUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppUser(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String>(json['phone']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String>(phone),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) => AppUser(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    role: role ?? this.role,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    createdAt: createdAt ?? this.createdAt,
  );
  AppUser copyWithCompanion(AppUsersCompanion data) {
    return AppUser(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    password,
    role,
    address,
    phone,
    latitude,
    longitude,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.password == this.password &&
          other.role == this.role &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.createdAt == this.createdAt);
}

class AppUsersCompanion extends UpdateCompanion<AppUser> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> password;
  final Value<String> role;
  final Value<String> address;
  final Value<String> phone;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AppUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppUsersCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String password,
    required String role,
    required String address,
    required String phone,
    required double latitude,
    required double longitude,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       password = Value(password),
       role = Value(role),
       address = Value(address),
       phone = Value(phone),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<AppUser> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? password,
    Value<String>? role,
    Value<String>? address,
    Value<String>? phone,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AppUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppUsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceOrdersTable extends ServiceOrders
    with TableInfo<$ServiceOrdersTable, ServiceOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopperIdMeta = const VerificationMeta(
    'shopperId',
  );
  @override
  late final GeneratedColumn<String> shopperId = GeneratedColumn<String>(
    'shopper_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pickupAddressMeta = const VerificationMeta(
    'pickupAddress',
  );
  @override
  late final GeneratedColumn<String> pickupAddress = GeneratedColumn<String>(
    'pickup_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryAddressMeta = const VerificationMeta(
    'deliveryAddress',
  );
  @override
  late final GeneratedColumn<String> deliveryAddress = GeneratedColumn<String>(
    'delivery_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pickupLatMeta = const VerificationMeta(
    'pickupLat',
  );
  @override
  late final GeneratedColumn<double> pickupLat = GeneratedColumn<double>(
    'pickup_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pickupLngMeta = const VerificationMeta(
    'pickupLng',
  );
  @override
  late final GeneratedColumn<double> pickupLng = GeneratedColumn<double>(
    'pickup_lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryLatMeta = const VerificationMeta(
    'deliveryLat',
  );
  @override
  late final GeneratedColumn<double> deliveryLat = GeneratedColumn<double>(
    'delivery_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryLngMeta = const VerificationMeta(
    'deliveryLng',
  );
  @override
  late final GeneratedColumn<double> deliveryLng = GeneratedColumn<double>(
    'delivery_lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopperLatMeta = const VerificationMeta(
    'shopperLat',
  );
  @override
  late final GeneratedColumn<double> shopperLat = GeneratedColumn<double>(
    'shopper_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopperLngMeta = const VerificationMeta(
    'shopperLng',
  );
  @override
  late final GeneratedColumn<double> shopperLng = GeneratedColumn<double>(
    'shopper_lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsListMeta = const VerificationMeta(
    'itemsList',
  );
  @override
  late final GeneratedColumn<String> itemsList = GeneratedColumn<String>(
    'items_list',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopperRatingMeta = const VerificationMeta(
    'shopperRating',
  );
  @override
  late final GeneratedColumn<double> shopperRating = GeneratedColumn<double>(
    'shopper_rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _disputeReasonMeta = const VerificationMeta(
    'disputeReason',
  );
  @override
  late final GeneratedColumn<String> disputeReason = GeneratedColumn<String>(
    'dispute_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    shopperId,
    title,
    pickupAddress,
    deliveryAddress,
    pickupLat,
    pickupLng,
    deliveryLat,
    deliveryLng,
    shopperLat,
    shopperLng,
    status,
    itemsList,
    shopperRating,
    disputeReason,
    isSynced,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('shopper_id')) {
      context.handle(
        _shopperIdMeta,
        shopperId.isAcceptableOrUnknown(data['shopper_id']!, _shopperIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shopperIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('pickup_address')) {
      context.handle(
        _pickupAddressMeta,
        pickupAddress.isAcceptableOrUnknown(
          data['pickup_address']!,
          _pickupAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pickupAddressMeta);
    }
    if (data.containsKey('delivery_address')) {
      context.handle(
        _deliveryAddressMeta,
        deliveryAddress.isAcceptableOrUnknown(
          data['delivery_address']!,
          _deliveryAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deliveryAddressMeta);
    }
    if (data.containsKey('pickup_lat')) {
      context.handle(
        _pickupLatMeta,
        pickupLat.isAcceptableOrUnknown(data['pickup_lat']!, _pickupLatMeta),
      );
    } else if (isInserting) {
      context.missing(_pickupLatMeta);
    }
    if (data.containsKey('pickup_lng')) {
      context.handle(
        _pickupLngMeta,
        pickupLng.isAcceptableOrUnknown(data['pickup_lng']!, _pickupLngMeta),
      );
    } else if (isInserting) {
      context.missing(_pickupLngMeta);
    }
    if (data.containsKey('delivery_lat')) {
      context.handle(
        _deliveryLatMeta,
        deliveryLat.isAcceptableOrUnknown(
          data['delivery_lat']!,
          _deliveryLatMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deliveryLatMeta);
    }
    if (data.containsKey('delivery_lng')) {
      context.handle(
        _deliveryLngMeta,
        deliveryLng.isAcceptableOrUnknown(
          data['delivery_lng']!,
          _deliveryLngMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deliveryLngMeta);
    }
    if (data.containsKey('shopper_lat')) {
      context.handle(
        _shopperLatMeta,
        shopperLat.isAcceptableOrUnknown(data['shopper_lat']!, _shopperLatMeta),
      );
    } else if (isInserting) {
      context.missing(_shopperLatMeta);
    }
    if (data.containsKey('shopper_lng')) {
      context.handle(
        _shopperLngMeta,
        shopperLng.isAcceptableOrUnknown(data['shopper_lng']!, _shopperLngMeta),
      );
    } else if (isInserting) {
      context.missing(_shopperLngMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('items_list')) {
      context.handle(
        _itemsListMeta,
        itemsList.isAcceptableOrUnknown(data['items_list']!, _itemsListMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsListMeta);
    }
    if (data.containsKey('shopper_rating')) {
      context.handle(
        _shopperRatingMeta,
        shopperRating.isAcceptableOrUnknown(
          data['shopper_rating']!,
          _shopperRatingMeta,
        ),
      );
    }
    if (data.containsKey('dispute_reason')) {
      context.handle(
        _disputeReasonMeta,
        disputeReason.isAcceptableOrUnknown(
          data['dispute_reason']!,
          _disputeReasonMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      shopperId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shopper_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      pickupAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pickup_address'],
      )!,
      deliveryAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_address'],
      )!,
      pickupLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pickup_lat'],
      )!,
      pickupLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pickup_lng'],
      )!,
      deliveryLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delivery_lat'],
      )!,
      deliveryLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delivery_lng'],
      )!,
      shopperLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}shopper_lat'],
      )!,
      shopperLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}shopper_lng'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      itemsList: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_list'],
      )!,
      shopperRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}shopper_rating'],
      ),
      disputeReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dispute_reason'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ServiceOrdersTable createAlias(String alias) {
    return $ServiceOrdersTable(attachedDatabase, alias);
  }
}

class ServiceOrder extends DataClass implements Insertable<ServiceOrder> {
  final String id;
  final String customerId;
  final String shopperId;
  final String title;
  final String pickupAddress;
  final String deliveryAddress;
  final double pickupLat;
  final double pickupLng;
  final double deliveryLat;
  final double deliveryLng;
  final double shopperLat;
  final double shopperLng;
  final String status;
  final String itemsList;
  final double? shopperRating;
  final String? disputeReason;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ServiceOrder({
    required this.id,
    required this.customerId,
    required this.shopperId,
    required this.title,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.shopperLat,
    required this.shopperLng,
    required this.status,
    required this.itemsList,
    this.shopperRating,
    this.disputeReason,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['shopper_id'] = Variable<String>(shopperId);
    map['title'] = Variable<String>(title);
    map['pickup_address'] = Variable<String>(pickupAddress);
    map['delivery_address'] = Variable<String>(deliveryAddress);
    map['pickup_lat'] = Variable<double>(pickupLat);
    map['pickup_lng'] = Variable<double>(pickupLng);
    map['delivery_lat'] = Variable<double>(deliveryLat);
    map['delivery_lng'] = Variable<double>(deliveryLng);
    map['shopper_lat'] = Variable<double>(shopperLat);
    map['shopper_lng'] = Variable<double>(shopperLng);
    map['status'] = Variable<String>(status);
    map['items_list'] = Variable<String>(itemsList);
    if (!nullToAbsent || shopperRating != null) {
      map['shopper_rating'] = Variable<double>(shopperRating);
    }
    if (!nullToAbsent || disputeReason != null) {
      map['dispute_reason'] = Variable<String>(disputeReason);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServiceOrdersCompanion toCompanion(bool nullToAbsent) {
    return ServiceOrdersCompanion(
      id: Value(id),
      customerId: Value(customerId),
      shopperId: Value(shopperId),
      title: Value(title),
      pickupAddress: Value(pickupAddress),
      deliveryAddress: Value(deliveryAddress),
      pickupLat: Value(pickupLat),
      pickupLng: Value(pickupLng),
      deliveryLat: Value(deliveryLat),
      deliveryLng: Value(deliveryLng),
      shopperLat: Value(shopperLat),
      shopperLng: Value(shopperLng),
      status: Value(status),
      itemsList: Value(itemsList),
      shopperRating: shopperRating == null && nullToAbsent
          ? const Value.absent()
          : Value(shopperRating),
      disputeReason: disputeReason == null && nullToAbsent
          ? const Value.absent()
          : Value(disputeReason),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ServiceOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceOrder(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      shopperId: serializer.fromJson<String>(json['shopperId']),
      title: serializer.fromJson<String>(json['title']),
      pickupAddress: serializer.fromJson<String>(json['pickupAddress']),
      deliveryAddress: serializer.fromJson<String>(json['deliveryAddress']),
      pickupLat: serializer.fromJson<double>(json['pickupLat']),
      pickupLng: serializer.fromJson<double>(json['pickupLng']),
      deliveryLat: serializer.fromJson<double>(json['deliveryLat']),
      deliveryLng: serializer.fromJson<double>(json['deliveryLng']),
      shopperLat: serializer.fromJson<double>(json['shopperLat']),
      shopperLng: serializer.fromJson<double>(json['shopperLng']),
      status: serializer.fromJson<String>(json['status']),
      itemsList: serializer.fromJson<String>(json['itemsList']),
      shopperRating: serializer.fromJson<double?>(json['shopperRating']),
      disputeReason: serializer.fromJson<String?>(json['disputeReason']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'shopperId': serializer.toJson<String>(shopperId),
      'title': serializer.toJson<String>(title),
      'pickupAddress': serializer.toJson<String>(pickupAddress),
      'deliveryAddress': serializer.toJson<String>(deliveryAddress),
      'pickupLat': serializer.toJson<double>(pickupLat),
      'pickupLng': serializer.toJson<double>(pickupLng),
      'deliveryLat': serializer.toJson<double>(deliveryLat),
      'deliveryLng': serializer.toJson<double>(deliveryLng),
      'shopperLat': serializer.toJson<double>(shopperLat),
      'shopperLng': serializer.toJson<double>(shopperLng),
      'status': serializer.toJson<String>(status),
      'itemsList': serializer.toJson<String>(itemsList),
      'shopperRating': serializer.toJson<double?>(shopperRating),
      'disputeReason': serializer.toJson<String?>(disputeReason),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ServiceOrder copyWith({
    String? id,
    String? customerId,
    String? shopperId,
    String? title,
    String? pickupAddress,
    String? deliveryAddress,
    double? pickupLat,
    double? pickupLng,
    double? deliveryLat,
    double? deliveryLng,
    double? shopperLat,
    double? shopperLng,
    String? status,
    String? itemsList,
    Value<double?> shopperRating = const Value.absent(),
    Value<String?> disputeReason = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ServiceOrder(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    shopperId: shopperId ?? this.shopperId,
    title: title ?? this.title,
    pickupAddress: pickupAddress ?? this.pickupAddress,
    deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    pickupLat: pickupLat ?? this.pickupLat,
    pickupLng: pickupLng ?? this.pickupLng,
    deliveryLat: deliveryLat ?? this.deliveryLat,
    deliveryLng: deliveryLng ?? this.deliveryLng,
    shopperLat: shopperLat ?? this.shopperLat,
    shopperLng: shopperLng ?? this.shopperLng,
    status: status ?? this.status,
    itemsList: itemsList ?? this.itemsList,
    shopperRating: shopperRating.present
        ? shopperRating.value
        : this.shopperRating,
    disputeReason: disputeReason.present
        ? disputeReason.value
        : this.disputeReason,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ServiceOrder copyWithCompanion(ServiceOrdersCompanion data) {
    return ServiceOrder(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      shopperId: data.shopperId.present ? data.shopperId.value : this.shopperId,
      title: data.title.present ? data.title.value : this.title,
      pickupAddress: data.pickupAddress.present
          ? data.pickupAddress.value
          : this.pickupAddress,
      deliveryAddress: data.deliveryAddress.present
          ? data.deliveryAddress.value
          : this.deliveryAddress,
      pickupLat: data.pickupLat.present ? data.pickupLat.value : this.pickupLat,
      pickupLng: data.pickupLng.present ? data.pickupLng.value : this.pickupLng,
      deliveryLat: data.deliveryLat.present
          ? data.deliveryLat.value
          : this.deliveryLat,
      deliveryLng: data.deliveryLng.present
          ? data.deliveryLng.value
          : this.deliveryLng,
      shopperLat: data.shopperLat.present
          ? data.shopperLat.value
          : this.shopperLat,
      shopperLng: data.shopperLng.present
          ? data.shopperLng.value
          : this.shopperLng,
      status: data.status.present ? data.status.value : this.status,
      itemsList: data.itemsList.present ? data.itemsList.value : this.itemsList,
      shopperRating: data.shopperRating.present
          ? data.shopperRating.value
          : this.shopperRating,
      disputeReason: data.disputeReason.present
          ? data.disputeReason.value
          : this.disputeReason,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceOrder(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('shopperId: $shopperId, ')
          ..write('title: $title, ')
          ..write('pickupAddress: $pickupAddress, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('pickupLat: $pickupLat, ')
          ..write('pickupLng: $pickupLng, ')
          ..write('deliveryLat: $deliveryLat, ')
          ..write('deliveryLng: $deliveryLng, ')
          ..write('shopperLat: $shopperLat, ')
          ..write('shopperLng: $shopperLng, ')
          ..write('status: $status, ')
          ..write('itemsList: $itemsList, ')
          ..write('shopperRating: $shopperRating, ')
          ..write('disputeReason: $disputeReason, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    shopperId,
    title,
    pickupAddress,
    deliveryAddress,
    pickupLat,
    pickupLng,
    deliveryLat,
    deliveryLng,
    shopperLat,
    shopperLng,
    status,
    itemsList,
    shopperRating,
    disputeReason,
    isSynced,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceOrder &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.shopperId == this.shopperId &&
          other.title == this.title &&
          other.pickupAddress == this.pickupAddress &&
          other.deliveryAddress == this.deliveryAddress &&
          other.pickupLat == this.pickupLat &&
          other.pickupLng == this.pickupLng &&
          other.deliveryLat == this.deliveryLat &&
          other.deliveryLng == this.deliveryLng &&
          other.shopperLat == this.shopperLat &&
          other.shopperLng == this.shopperLng &&
          other.status == this.status &&
          other.itemsList == this.itemsList &&
          other.shopperRating == this.shopperRating &&
          other.disputeReason == this.disputeReason &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServiceOrdersCompanion extends UpdateCompanion<ServiceOrder> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> shopperId;
  final Value<String> title;
  final Value<String> pickupAddress;
  final Value<String> deliveryAddress;
  final Value<double> pickupLat;
  final Value<double> pickupLng;
  final Value<double> deliveryLat;
  final Value<double> deliveryLng;
  final Value<double> shopperLat;
  final Value<double> shopperLng;
  final Value<String> status;
  final Value<String> itemsList;
  final Value<double?> shopperRating;
  final Value<String?> disputeReason;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ServiceOrdersCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.shopperId = const Value.absent(),
    this.title = const Value.absent(),
    this.pickupAddress = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.pickupLat = const Value.absent(),
    this.pickupLng = const Value.absent(),
    this.deliveryLat = const Value.absent(),
    this.deliveryLng = const Value.absent(),
    this.shopperLat = const Value.absent(),
    this.shopperLng = const Value.absent(),
    this.status = const Value.absent(),
    this.itemsList = const Value.absent(),
    this.shopperRating = const Value.absent(),
    this.disputeReason = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceOrdersCompanion.insert({
    required String id,
    required String customerId,
    required String shopperId,
    required String title,
    required String pickupAddress,
    required String deliveryAddress,
    required double pickupLat,
    required double pickupLng,
    required double deliveryLat,
    required double deliveryLng,
    required double shopperLat,
    required double shopperLng,
    required String status,
    required String itemsList,
    this.shopperRating = const Value.absent(),
    this.disputeReason = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       shopperId = Value(shopperId),
       title = Value(title),
       pickupAddress = Value(pickupAddress),
       deliveryAddress = Value(deliveryAddress),
       pickupLat = Value(pickupLat),
       pickupLng = Value(pickupLng),
       deliveryLat = Value(deliveryLat),
       deliveryLng = Value(deliveryLng),
       shopperLat = Value(shopperLat),
       shopperLng = Value(shopperLng),
       status = Value(status),
       itemsList = Value(itemsList);
  static Insertable<ServiceOrder> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? shopperId,
    Expression<String>? title,
    Expression<String>? pickupAddress,
    Expression<String>? deliveryAddress,
    Expression<double>? pickupLat,
    Expression<double>? pickupLng,
    Expression<double>? deliveryLat,
    Expression<double>? deliveryLng,
    Expression<double>? shopperLat,
    Expression<double>? shopperLng,
    Expression<String>? status,
    Expression<String>? itemsList,
    Expression<double>? shopperRating,
    Expression<String>? disputeReason,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (shopperId != null) 'shopper_id': shopperId,
      if (title != null) 'title': title,
      if (pickupAddress != null) 'pickup_address': pickupAddress,
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (pickupLat != null) 'pickup_lat': pickupLat,
      if (pickupLng != null) 'pickup_lng': pickupLng,
      if (deliveryLat != null) 'delivery_lat': deliveryLat,
      if (deliveryLng != null) 'delivery_lng': deliveryLng,
      if (shopperLat != null) 'shopper_lat': shopperLat,
      if (shopperLng != null) 'shopper_lng': shopperLng,
      if (status != null) 'status': status,
      if (itemsList != null) 'items_list': itemsList,
      if (shopperRating != null) 'shopper_rating': shopperRating,
      if (disputeReason != null) 'dispute_reason': disputeReason,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? shopperId,
    Value<String>? title,
    Value<String>? pickupAddress,
    Value<String>? deliveryAddress,
    Value<double>? pickupLat,
    Value<double>? pickupLng,
    Value<double>? deliveryLat,
    Value<double>? deliveryLng,
    Value<double>? shopperLat,
    Value<double>? shopperLng,
    Value<String>? status,
    Value<String>? itemsList,
    Value<double?>? shopperRating,
    Value<String?>? disputeReason,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ServiceOrdersCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      shopperId: shopperId ?? this.shopperId,
      title: title ?? this.title,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      deliveryLat: deliveryLat ?? this.deliveryLat,
      deliveryLng: deliveryLng ?? this.deliveryLng,
      shopperLat: shopperLat ?? this.shopperLat,
      shopperLng: shopperLng ?? this.shopperLng,
      status: status ?? this.status,
      itemsList: itemsList ?? this.itemsList,
      shopperRating: shopperRating ?? this.shopperRating,
      disputeReason: disputeReason ?? this.disputeReason,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (shopperId.present) {
      map['shopper_id'] = Variable<String>(shopperId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pickupAddress.present) {
      map['pickup_address'] = Variable<String>(pickupAddress.value);
    }
    if (deliveryAddress.present) {
      map['delivery_address'] = Variable<String>(deliveryAddress.value);
    }
    if (pickupLat.present) {
      map['pickup_lat'] = Variable<double>(pickupLat.value);
    }
    if (pickupLng.present) {
      map['pickup_lng'] = Variable<double>(pickupLng.value);
    }
    if (deliveryLat.present) {
      map['delivery_lat'] = Variable<double>(deliveryLat.value);
    }
    if (deliveryLng.present) {
      map['delivery_lng'] = Variable<double>(deliveryLng.value);
    }
    if (shopperLat.present) {
      map['shopper_lat'] = Variable<double>(shopperLat.value);
    }
    if (shopperLng.present) {
      map['shopper_lng'] = Variable<double>(shopperLng.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (itemsList.present) {
      map['items_list'] = Variable<String>(itemsList.value);
    }
    if (shopperRating.present) {
      map['shopper_rating'] = Variable<double>(shopperRating.value);
    }
    if (disputeReason.present) {
      map['dispute_reason'] = Variable<String>(disputeReason.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceOrdersCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('shopperId: $shopperId, ')
          ..write('title: $title, ')
          ..write('pickupAddress: $pickupAddress, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('pickupLat: $pickupLat, ')
          ..write('pickupLng: $pickupLng, ')
          ..write('deliveryLat: $deliveryLat, ')
          ..write('deliveryLng: $deliveryLng, ')
          ..write('shopperLat: $shopperLat, ')
          ..write('shopperLng: $shopperLng, ')
          ..write('status: $status, ')
          ..write('itemsList: $itemsList, ')
          ..write('shopperRating: $shopperRating, ')
          ..write('disputeReason: $disputeReason, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderMessagesTable extends OrderMessages
    with TableInfo<$OrderMessagesTable, OrderMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL REFERENCES service_orders(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    senderId,
    message,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OrderMessagesTable createAlias(String alias) {
    return $OrderMessagesTable(attachedDatabase, alias);
  }
}

class OrderMessage extends DataClass implements Insertable<OrderMessage> {
  final int id;
  final String orderId;
  final String senderId;
  final String message;
  final bool isSynced;
  final DateTime createdAt;
  const OrderMessage({
    required this.id,
    required this.orderId,
    required this.senderId,
    required this.message,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<String>(orderId);
    map['sender_id'] = Variable<String>(senderId);
    map['message'] = Variable<String>(message);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrderMessagesCompanion toCompanion(bool nullToAbsent) {
    return OrderMessagesCompanion(
      id: Value(id),
      orderId: Value(orderId),
      senderId: Value(senderId),
      message: Value(message),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory OrderMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderMessage(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      message: serializer.fromJson<String>(json['message']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<String>(orderId),
      'senderId': serializer.toJson<String>(senderId),
      'message': serializer.toJson<String>(message),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OrderMessage copyWith({
    int? id,
    String? orderId,
    String? senderId,
    String? message,
    bool? isSynced,
    DateTime? createdAt,
  }) => OrderMessage(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    senderId: senderId ?? this.senderId,
    message: message ?? this.message,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  OrderMessage copyWithCompanion(OrderMessagesCompanion data) {
    return OrderMessage(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      message: data.message.present ? data.message.value : this.message,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderMessage(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('senderId: $senderId, ')
          ..write('message: $message, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, senderId, message, isSynced, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderMessage &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.senderId == this.senderId &&
          other.message == this.message &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class OrderMessagesCompanion extends UpdateCompanion<OrderMessage> {
  final Value<int> id;
  final Value<String> orderId;
  final Value<String> senderId;
  final Value<String> message;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  const OrderMessagesCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.message = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OrderMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String senderId,
    required String message,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : orderId = Value(orderId),
       senderId = Value(senderId),
       message = Value(message);
  static Insertable<OrderMessage> custom({
    Expression<int>? id,
    Expression<String>? orderId,
    Expression<String>? senderId,
    Expression<String>? message,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (senderId != null) 'sender_id': senderId,
      if (message != null) 'message': message,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OrderMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? orderId,
    Value<String>? senderId,
    Value<String>? message,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
  }) {
    return OrderMessagesCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderMessagesCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('senderId: $senderId, ')
          ..write('message: $message, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProofFilesTable extends ProofFiles
    with TableInfo<$ProofFilesTable, ProofFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProofFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL REFERENCES service_orders(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    filePath,
    fileName,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proof_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProofFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProofFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProofFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProofFilesTable createAlias(String alias) {
    return $ProofFilesTable(attachedDatabase, alias);
  }
}

class ProofFile extends DataClass implements Insertable<ProofFile> {
  final int id;
  final String orderId;
  final String filePath;
  final String fileName;
  final bool isSynced;
  final DateTime createdAt;
  const ProofFile({
    required this.id,
    required this.orderId,
    required this.filePath,
    required this.fileName,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<String>(orderId);
    map['file_path'] = Variable<String>(filePath);
    map['file_name'] = Variable<String>(fileName);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProofFilesCompanion toCompanion(bool nullToAbsent) {
    return ProofFilesCompanion(
      id: Value(id),
      orderId: Value(orderId),
      filePath: Value(filePath),
      fileName: Value(fileName),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory ProofFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProofFile(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileName: serializer.fromJson<String>(json['fileName']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<String>(orderId),
      'filePath': serializer.toJson<String>(filePath),
      'fileName': serializer.toJson<String>(fileName),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProofFile copyWith({
    int? id,
    String? orderId,
    String? filePath,
    String? fileName,
    bool? isSynced,
    DateTime? createdAt,
  }) => ProofFile(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    filePath: filePath ?? this.filePath,
    fileName: fileName ?? this.fileName,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  ProofFile copyWithCompanion(ProofFilesCompanion data) {
    return ProofFile(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProofFile(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, filePath, fileName, isSynced, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProofFile &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.filePath == this.filePath &&
          other.fileName == this.fileName &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class ProofFilesCompanion extends UpdateCompanion<ProofFile> {
  final Value<int> id;
  final Value<String> orderId;
  final Value<String> filePath;
  final Value<String> fileName;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  const ProofFilesCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProofFilesCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String filePath,
    required String fileName,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : orderId = Value(orderId),
       filePath = Value(filePath),
       fileName = Value(fileName);
  static Insertable<ProofFile> custom({
    Expression<int>? id,
    Expression<String>? orderId,
    Expression<String>? filePath,
    Expression<String>? fileName,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (filePath != null) 'file_path': filePath,
      if (fileName != null) 'file_name': fileName,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProofFilesCompanion copyWith({
    Value<int>? id,
    Value<String>? orderId,
    Value<String>? filePath,
    Value<String>? fileName,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
  }) {
    return ProofFilesCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProofFilesCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$ServiceDeliveryDatabase extends GeneratedDatabase {
  _$ServiceDeliveryDatabase(QueryExecutor e) : super(e);
  $ServiceDeliveryDatabaseManager get managers =>
      $ServiceDeliveryDatabaseManager(this);
  late final $AppUsersTable appUsers = $AppUsersTable(this);
  late final $ServiceOrdersTable serviceOrders = $ServiceOrdersTable(this);
  late final $OrderMessagesTable orderMessages = $OrderMessagesTable(this);
  late final $ProofFilesTable proofFiles = $ProofFilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appUsers,
    serviceOrders,
    orderMessages,
    proofFiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_orders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_orders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('proof_files', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AppUsersTableCreateCompanionBuilder =
    AppUsersCompanion Function({
      required String id,
      required String name,
      required String email,
      required String password,
      required String role,
      required String address,
      required String phone,
      required double latitude,
      required double longitude,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AppUsersTableUpdateCompanionBuilder =
    AppUsersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String> password,
      Value<String> role,
      Value<String> address,
      Value<String> phone,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AppUsersTableFilterComposer
    extends Composer<_$ServiceDeliveryDatabase, $AppUsersTable> {
  $$AppUsersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppUsersTableOrderingComposer
    extends Composer<_$ServiceDeliveryDatabase, $AppUsersTable> {
  $$AppUsersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppUsersTableAnnotationComposer
    extends Composer<_$ServiceDeliveryDatabase, $AppUsersTable> {
  $$AppUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppUsersTableTableManager
    extends
        RootTableManager<
          _$ServiceDeliveryDatabase,
          $AppUsersTable,
          AppUser,
          $$AppUsersTableFilterComposer,
          $$AppUsersTableOrderingComposer,
          $$AppUsersTableAnnotationComposer,
          $$AppUsersTableCreateCompanionBuilder,
          $$AppUsersTableUpdateCompanionBuilder,
          (
            AppUser,
            BaseReferences<_$ServiceDeliveryDatabase, $AppUsersTable, AppUser>,
          ),
          AppUser,
          PrefetchHooks Function()
        > {
  $$AppUsersTableTableManager(
    _$ServiceDeliveryDatabase db,
    $AppUsersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppUsersCompanion(
                id: id,
                name: name,
                email: email,
                password: password,
                role: role,
                address: address,
                phone: phone,
                latitude: latitude,
                longitude: longitude,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                required String password,
                required String role,
                required String address,
                required String phone,
                required double latitude,
                required double longitude,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppUsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                password: password,
                role: role,
                address: address,
                phone: phone,
                latitude: latitude,
                longitude: longitude,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$ServiceDeliveryDatabase,
      $AppUsersTable,
      AppUser,
      $$AppUsersTableFilterComposer,
      $$AppUsersTableOrderingComposer,
      $$AppUsersTableAnnotationComposer,
      $$AppUsersTableCreateCompanionBuilder,
      $$AppUsersTableUpdateCompanionBuilder,
      (
        AppUser,
        BaseReferences<_$ServiceDeliveryDatabase, $AppUsersTable, AppUser>,
      ),
      AppUser,
      PrefetchHooks Function()
    >;
typedef $$ServiceOrdersTableCreateCompanionBuilder =
    ServiceOrdersCompanion Function({
      required String id,
      required String customerId,
      required String shopperId,
      required String title,
      required String pickupAddress,
      required String deliveryAddress,
      required double pickupLat,
      required double pickupLng,
      required double deliveryLat,
      required double deliveryLng,
      required double shopperLat,
      required double shopperLng,
      required String status,
      required String itemsList,
      Value<double?> shopperRating,
      Value<String?> disputeReason,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ServiceOrdersTableUpdateCompanionBuilder =
    ServiceOrdersCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> shopperId,
      Value<String> title,
      Value<String> pickupAddress,
      Value<String> deliveryAddress,
      Value<double> pickupLat,
      Value<double> pickupLng,
      Value<double> deliveryLat,
      Value<double> deliveryLng,
      Value<double> shopperLat,
      Value<double> shopperLng,
      Value<String> status,
      Value<String> itemsList,
      Value<double?> shopperRating,
      Value<String?> disputeReason,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ServiceOrdersTableReferences
    extends
        BaseReferences<
          _$ServiceDeliveryDatabase,
          $ServiceOrdersTable,
          ServiceOrder
        > {
  $$ServiceOrdersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$OrderMessagesTable, List<OrderMessage>>
  _orderMessagesRefsTable(_$ServiceDeliveryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderMessages,
        aliasName: $_aliasNameGenerator(
          db.serviceOrders.id,
          db.orderMessages.orderId,
        ),
      );

  $$OrderMessagesTableProcessedTableManager get orderMessagesRefs {
    final manager = $$OrderMessagesTableTableManager(
      $_db,
      $_db.orderMessages,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProofFilesTable, List<ProofFile>>
  _proofFilesRefsTable(_$ServiceDeliveryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.proofFiles,
        aliasName: $_aliasNameGenerator(
          db.serviceOrders.id,
          db.proofFiles.orderId,
        ),
      );

  $$ProofFilesTableProcessedTableManager get proofFilesRefs {
    final manager = $$ProofFilesTableTableManager(
      $_db,
      $_db.proofFiles,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_proofFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceOrdersTableFilterComposer
    extends Composer<_$ServiceDeliveryDatabase, $ServiceOrdersTable> {
  $$ServiceOrdersTableFilterComposer({
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

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopperId => $composableBuilder(
    column: $table.shopperId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pickupAddress => $composableBuilder(
    column: $table.pickupAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pickupLat => $composableBuilder(
    column: $table.pickupLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pickupLng => $composableBuilder(
    column: $table.pickupLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deliveryLat => $composableBuilder(
    column: $table.deliveryLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deliveryLng => $composableBuilder(
    column: $table.deliveryLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get shopperLat => $composableBuilder(
    column: $table.shopperLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get shopperLng => $composableBuilder(
    column: $table.shopperLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsList => $composableBuilder(
    column: $table.itemsList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get shopperRating => $composableBuilder(
    column: $table.shopperRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get disputeReason => $composableBuilder(
    column: $table.disputeReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderMessagesRefs(
    Expression<bool> Function($$OrderMessagesTableFilterComposer f) f,
  ) {
    final $$OrderMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderMessages,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderMessagesTableFilterComposer(
            $db: $db,
            $table: $db.orderMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> proofFilesRefs(
    Expression<bool> Function($$ProofFilesTableFilterComposer f) f,
  ) {
    final $$ProofFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proofFiles,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProofFilesTableFilterComposer(
            $db: $db,
            $table: $db.proofFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceOrdersTableOrderingComposer
    extends Composer<_$ServiceDeliveryDatabase, $ServiceOrdersTable> {
  $$ServiceOrdersTableOrderingComposer({
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

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopperId => $composableBuilder(
    column: $table.shopperId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pickupAddress => $composableBuilder(
    column: $table.pickupAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pickupLat => $composableBuilder(
    column: $table.pickupLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pickupLng => $composableBuilder(
    column: $table.pickupLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deliveryLat => $composableBuilder(
    column: $table.deliveryLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deliveryLng => $composableBuilder(
    column: $table.deliveryLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get shopperLat => $composableBuilder(
    column: $table.shopperLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get shopperLng => $composableBuilder(
    column: $table.shopperLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsList => $composableBuilder(
    column: $table.itemsList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get shopperRating => $composableBuilder(
    column: $table.shopperRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get disputeReason => $composableBuilder(
    column: $table.disputeReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceOrdersTableAnnotationComposer
    extends Composer<_$ServiceDeliveryDatabase, $ServiceOrdersTable> {
  $$ServiceOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shopperId =>
      $composableBuilder(column: $table.shopperId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get pickupAddress => $composableBuilder(
    column: $table.pickupAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pickupLat =>
      $composableBuilder(column: $table.pickupLat, builder: (column) => column);

  GeneratedColumn<double> get pickupLng =>
      $composableBuilder(column: $table.pickupLng, builder: (column) => column);

  GeneratedColumn<double> get deliveryLat => $composableBuilder(
    column: $table.deliveryLat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get deliveryLng => $composableBuilder(
    column: $table.deliveryLng,
    builder: (column) => column,
  );

  GeneratedColumn<double> get shopperLat => $composableBuilder(
    column: $table.shopperLat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get shopperLng => $composableBuilder(
    column: $table.shopperLng,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get itemsList =>
      $composableBuilder(column: $table.itemsList, builder: (column) => column);

  GeneratedColumn<double> get shopperRating => $composableBuilder(
    column: $table.shopperRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get disputeReason => $composableBuilder(
    column: $table.disputeReason,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> orderMessagesRefs<T extends Object>(
    Expression<T> Function($$OrderMessagesTableAnnotationComposer a) f,
  ) {
    final $$OrderMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderMessages,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> proofFilesRefs<T extends Object>(
    Expression<T> Function($$ProofFilesTableAnnotationComposer a) f,
  ) {
    final $$ProofFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.proofFiles,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProofFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.proofFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceOrdersTableTableManager
    extends
        RootTableManager<
          _$ServiceDeliveryDatabase,
          $ServiceOrdersTable,
          ServiceOrder,
          $$ServiceOrdersTableFilterComposer,
          $$ServiceOrdersTableOrderingComposer,
          $$ServiceOrdersTableAnnotationComposer,
          $$ServiceOrdersTableCreateCompanionBuilder,
          $$ServiceOrdersTableUpdateCompanionBuilder,
          (ServiceOrder, $$ServiceOrdersTableReferences),
          ServiceOrder,
          PrefetchHooks Function({bool orderMessagesRefs, bool proofFilesRefs})
        > {
  $$ServiceOrdersTableTableManager(
    _$ServiceDeliveryDatabase db,
    $ServiceOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> shopperId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> pickupAddress = const Value.absent(),
                Value<String> deliveryAddress = const Value.absent(),
                Value<double> pickupLat = const Value.absent(),
                Value<double> pickupLng = const Value.absent(),
                Value<double> deliveryLat = const Value.absent(),
                Value<double> deliveryLng = const Value.absent(),
                Value<double> shopperLat = const Value.absent(),
                Value<double> shopperLng = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> itemsList = const Value.absent(),
                Value<double?> shopperRating = const Value.absent(),
                Value<String?> disputeReason = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceOrdersCompanion(
                id: id,
                customerId: customerId,
                shopperId: shopperId,
                title: title,
                pickupAddress: pickupAddress,
                deliveryAddress: deliveryAddress,
                pickupLat: pickupLat,
                pickupLng: pickupLng,
                deliveryLat: deliveryLat,
                deliveryLng: deliveryLng,
                shopperLat: shopperLat,
                shopperLng: shopperLng,
                status: status,
                itemsList: itemsList,
                shopperRating: shopperRating,
                disputeReason: disputeReason,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required String shopperId,
                required String title,
                required String pickupAddress,
                required String deliveryAddress,
                required double pickupLat,
                required double pickupLng,
                required double deliveryLat,
                required double deliveryLng,
                required double shopperLat,
                required double shopperLng,
                required String status,
                required String itemsList,
                Value<double?> shopperRating = const Value.absent(),
                Value<String?> disputeReason = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceOrdersCompanion.insert(
                id: id,
                customerId: customerId,
                shopperId: shopperId,
                title: title,
                pickupAddress: pickupAddress,
                deliveryAddress: deliveryAddress,
                pickupLat: pickupLat,
                pickupLng: pickupLng,
                deliveryLat: deliveryLat,
                deliveryLng: deliveryLng,
                shopperLat: shopperLat,
                shopperLng: shopperLng,
                status: status,
                itemsList: itemsList,
                shopperRating: shopperRating,
                disputeReason: disputeReason,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceOrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({orderMessagesRefs = false, proofFilesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderMessagesRefs) db.orderMessages,
                    if (proofFilesRefs) db.proofFiles,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderMessagesRefs)
                        await $_getPrefetchedData<
                          ServiceOrder,
                          $ServiceOrdersTable,
                          OrderMessage
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceOrdersTableReferences
                              ._orderMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (proofFilesRefs)
                        await $_getPrefetchedData<
                          ServiceOrder,
                          $ServiceOrdersTable,
                          ProofFile
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceOrdersTableReferences
                              ._proofFilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).proofFilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServiceOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$ServiceDeliveryDatabase,
      $ServiceOrdersTable,
      ServiceOrder,
      $$ServiceOrdersTableFilterComposer,
      $$ServiceOrdersTableOrderingComposer,
      $$ServiceOrdersTableAnnotationComposer,
      $$ServiceOrdersTableCreateCompanionBuilder,
      $$ServiceOrdersTableUpdateCompanionBuilder,
      (ServiceOrder, $$ServiceOrdersTableReferences),
      ServiceOrder,
      PrefetchHooks Function({bool orderMessagesRefs, bool proofFilesRefs})
    >;
typedef $$OrderMessagesTableCreateCompanionBuilder =
    OrderMessagesCompanion Function({
      Value<int> id,
      required String orderId,
      required String senderId,
      required String message,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });
typedef $$OrderMessagesTableUpdateCompanionBuilder =
    OrderMessagesCompanion Function({
      Value<int> id,
      Value<String> orderId,
      Value<String> senderId,
      Value<String> message,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });

final class $$OrderMessagesTableReferences
    extends
        BaseReferences<
          _$ServiceDeliveryDatabase,
          $OrderMessagesTable,
          OrderMessage
        > {
  $$OrderMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ServiceOrdersTable _orderIdTable(_$ServiceDeliveryDatabase db) =>
      db.serviceOrders.createAlias(
        $_aliasNameGenerator(db.orderMessages.orderId, db.serviceOrders.id),
      );

  $$ServiceOrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$ServiceOrdersTableTableManager(
      $_db,
      $_db.serviceOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderMessagesTableFilterComposer
    extends Composer<_$ServiceDeliveryDatabase, $OrderMessagesTable> {
  $$OrderMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceOrdersTableFilterComposer get orderId {
    final $$ServiceOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.serviceOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceOrdersTableFilterComposer(
            $db: $db,
            $table: $db.serviceOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderMessagesTableOrderingComposer
    extends Composer<_$ServiceDeliveryDatabase, $OrderMessagesTable> {
  $$OrderMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceOrdersTableOrderingComposer get orderId {
    final $$ServiceOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.serviceOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.serviceOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderMessagesTableAnnotationComposer
    extends Composer<_$ServiceDeliveryDatabase, $OrderMessagesTable> {
  $$OrderMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ServiceOrdersTableAnnotationComposer get orderId {
    final $$ServiceOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.serviceOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderMessagesTableTableManager
    extends
        RootTableManager<
          _$ServiceDeliveryDatabase,
          $OrderMessagesTable,
          OrderMessage,
          $$OrderMessagesTableFilterComposer,
          $$OrderMessagesTableOrderingComposer,
          $$OrderMessagesTableAnnotationComposer,
          $$OrderMessagesTableCreateCompanionBuilder,
          $$OrderMessagesTableUpdateCompanionBuilder,
          (OrderMessage, $$OrderMessagesTableReferences),
          OrderMessage,
          PrefetchHooks Function({bool orderId})
        > {
  $$OrderMessagesTableTableManager(
    _$ServiceDeliveryDatabase db,
    $OrderMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OrderMessagesCompanion(
                id: id,
                orderId: orderId,
                senderId: senderId,
                message: message,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String orderId,
                required String senderId,
                required String message,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OrderMessagesCompanion.insert(
                id: id,
                orderId: orderId,
                senderId: senderId,
                message: message,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
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
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$OrderMessagesTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$OrderMessagesTableReferences
                                    ._orderIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$OrderMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$ServiceDeliveryDatabase,
      $OrderMessagesTable,
      OrderMessage,
      $$OrderMessagesTableFilterComposer,
      $$OrderMessagesTableOrderingComposer,
      $$OrderMessagesTableAnnotationComposer,
      $$OrderMessagesTableCreateCompanionBuilder,
      $$OrderMessagesTableUpdateCompanionBuilder,
      (OrderMessage, $$OrderMessagesTableReferences),
      OrderMessage,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$ProofFilesTableCreateCompanionBuilder =
    ProofFilesCompanion Function({
      Value<int> id,
      required String orderId,
      required String filePath,
      required String fileName,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });
typedef $$ProofFilesTableUpdateCompanionBuilder =
    ProofFilesCompanion Function({
      Value<int> id,
      Value<String> orderId,
      Value<String> filePath,
      Value<String> fileName,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });

final class $$ProofFilesTableReferences
    extends
        BaseReferences<_$ServiceDeliveryDatabase, $ProofFilesTable, ProofFile> {
  $$ProofFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceOrdersTable _orderIdTable(_$ServiceDeliveryDatabase db) =>
      db.serviceOrders.createAlias(
        $_aliasNameGenerator(db.proofFiles.orderId, db.serviceOrders.id),
      );

  $$ServiceOrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$ServiceOrdersTableTableManager(
      $_db,
      $_db.serviceOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProofFilesTableFilterComposer
    extends Composer<_$ServiceDeliveryDatabase, $ProofFilesTable> {
  $$ProofFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceOrdersTableFilterComposer get orderId {
    final $$ServiceOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.serviceOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceOrdersTableFilterComposer(
            $db: $db,
            $table: $db.serviceOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProofFilesTableOrderingComposer
    extends Composer<_$ServiceDeliveryDatabase, $ProofFilesTable> {
  $$ProofFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceOrdersTableOrderingComposer get orderId {
    final $$ServiceOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.serviceOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.serviceOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProofFilesTableAnnotationComposer
    extends Composer<_$ServiceDeliveryDatabase, $ProofFilesTable> {
  $$ProofFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ServiceOrdersTableAnnotationComposer get orderId {
    final $$ServiceOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.serviceOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProofFilesTableTableManager
    extends
        RootTableManager<
          _$ServiceDeliveryDatabase,
          $ProofFilesTable,
          ProofFile,
          $$ProofFilesTableFilterComposer,
          $$ProofFilesTableOrderingComposer,
          $$ProofFilesTableAnnotationComposer,
          $$ProofFilesTableCreateCompanionBuilder,
          $$ProofFilesTableUpdateCompanionBuilder,
          (ProofFile, $$ProofFilesTableReferences),
          ProofFile,
          PrefetchHooks Function({bool orderId})
        > {
  $$ProofFilesTableTableManager(
    _$ServiceDeliveryDatabase db,
    $ProofFilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProofFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProofFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProofFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProofFilesCompanion(
                id: id,
                orderId: orderId,
                filePath: filePath,
                fileName: fileName,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String orderId,
                required String filePath,
                required String fileName,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProofFilesCompanion.insert(
                id: id,
                orderId: orderId,
                filePath: filePath,
                fileName: fileName,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProofFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
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
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$ProofFilesTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$ProofFilesTableReferences
                                    ._orderIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ProofFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$ServiceDeliveryDatabase,
      $ProofFilesTable,
      ProofFile,
      $$ProofFilesTableFilterComposer,
      $$ProofFilesTableOrderingComposer,
      $$ProofFilesTableAnnotationComposer,
      $$ProofFilesTableCreateCompanionBuilder,
      $$ProofFilesTableUpdateCompanionBuilder,
      (ProofFile, $$ProofFilesTableReferences),
      ProofFile,
      PrefetchHooks Function({bool orderId})
    >;

class $ServiceDeliveryDatabaseManager {
  final _$ServiceDeliveryDatabase _db;
  $ServiceDeliveryDatabaseManager(this._db);
  $$AppUsersTableTableManager get appUsers =>
      $$AppUsersTableTableManager(_db, _db.appUsers);
  $$ServiceOrdersTableTableManager get serviceOrders =>
      $$ServiceOrdersTableTableManager(_db, _db.serviceOrders);
  $$OrderMessagesTableTableManager get orderMessages =>
      $$OrderMessagesTableTableManager(_db, _db.orderMessages);
  $$ProofFilesTableTableManager get proofFiles =>
      $$ProofFilesTableTableManager(_db, _db.proofFiles);
}
