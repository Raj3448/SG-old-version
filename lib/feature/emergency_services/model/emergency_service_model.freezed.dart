// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmergencyServiceModel _$EmergencyServiceModelFromJson(
    Map<String, dynamic> json) {
  return _EmergencyServiceModel.fromJson(json);
}

/// @nodoc
mixin _$EmergencyServiceModel {
  @JsonKey(name: 'defination')
  String get defination => throw _privateConstructorUsedError;
  @JsonKey(name: 'support')
  Support get support => throw _privateConstructorUsedError;
  @JsonKey(name: 'plansDescription')
  String get plansDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'plans')
  List<Plan> get plans => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmergencyServiceModelCopyWith<EmergencyServiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyServiceModelCopyWith<$Res> {
  factory $EmergencyServiceModelCopyWith(EmergencyServiceModel value,
          $Res Function(EmergencyServiceModel) then) =
      _$EmergencyServiceModelCopyWithImpl<$Res, EmergencyServiceModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'defination') String defination,
      @JsonKey(name: 'support') Support support,
      @JsonKey(name: 'plansDescription') String plansDescription,
      @JsonKey(name: 'plans') List<Plan> plans});

  $SupportCopyWith<$Res> get support;
}

/// @nodoc
class _$EmergencyServiceModelCopyWithImpl<$Res,
        $Val extends EmergencyServiceModel>
    implements $EmergencyServiceModelCopyWith<$Res> {
  _$EmergencyServiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defination = null,
    Object? support = null,
    Object? plansDescription = null,
    Object? plans = null,
  }) {
    return _then(_value.copyWith(
      defination: null == defination
          ? _value.defination
          : defination // ignore: cast_nullable_to_non_nullable
              as String,
      support: null == support
          ? _value.support
          : support // ignore: cast_nullable_to_non_nullable
              as Support,
      plansDescription: null == plansDescription
          ? _value.plansDescription
          : plansDescription // ignore: cast_nullable_to_non_nullable
              as String,
      plans: null == plans
          ? _value.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<Plan>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SupportCopyWith<$Res> get support {
    return $SupportCopyWith<$Res>(_value.support, (value) {
      return _then(_value.copyWith(support: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EmergencyServiceModelImplCopyWith<$Res>
    implements $EmergencyServiceModelCopyWith<$Res> {
  factory _$$EmergencyServiceModelImplCopyWith(
          _$EmergencyServiceModelImpl value,
          $Res Function(_$EmergencyServiceModelImpl) then) =
      __$$EmergencyServiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'defination') String defination,
      @JsonKey(name: 'support') Support support,
      @JsonKey(name: 'plansDescription') String plansDescription,
      @JsonKey(name: 'plans') List<Plan> plans});

  @override
  $SupportCopyWith<$Res> get support;
}

/// @nodoc
class __$$EmergencyServiceModelImplCopyWithImpl<$Res>
    extends _$EmergencyServiceModelCopyWithImpl<$Res,
        _$EmergencyServiceModelImpl>
    implements _$$EmergencyServiceModelImplCopyWith<$Res> {
  __$$EmergencyServiceModelImplCopyWithImpl(_$EmergencyServiceModelImpl _value,
      $Res Function(_$EmergencyServiceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defination = null,
    Object? support = null,
    Object? plansDescription = null,
    Object? plans = null,
  }) {
    return _then(_$EmergencyServiceModelImpl(
      defination: null == defination
          ? _value.defination
          : defination // ignore: cast_nullable_to_non_nullable
              as String,
      support: null == support
          ? _value.support
          : support // ignore: cast_nullable_to_non_nullable
              as Support,
      plansDescription: null == plansDescription
          ? _value.plansDescription
          : plansDescription // ignore: cast_nullable_to_non_nullable
              as String,
      plans: null == plans
          ? _value._plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<Plan>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergencyServiceModelImpl implements _EmergencyServiceModel {
  const _$EmergencyServiceModelImpl(
      {@JsonKey(name: 'defination') required this.defination,
      @JsonKey(name: 'support') required this.support,
      @JsonKey(name: 'plansDescription') required this.plansDescription,
      @JsonKey(name: 'plans') required final List<Plan> plans})
      : _plans = plans;

  factory _$EmergencyServiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergencyServiceModelImplFromJson(json);

  @override
  @JsonKey(name: 'defination')
  final String defination;
  @override
  @JsonKey(name: 'support')
  final Support support;
  @override
  @JsonKey(name: 'plansDescription')
  final String plansDescription;
  final List<Plan> _plans;
  @override
  @JsonKey(name: 'plans')
  List<Plan> get plans {
    if (_plans is EqualUnmodifiableListView) return _plans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plans);
  }

  @override
  String toString() {
    return 'EmergencyServiceModel(defination: $defination, support: $support, plansDescription: $plansDescription, plans: $plans)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyServiceModelImpl &&
            (identical(other.defination, defination) ||
                other.defination == defination) &&
            (identical(other.support, support) || other.support == support) &&
            (identical(other.plansDescription, plansDescription) ||
                other.plansDescription == plansDescription) &&
            const DeepCollectionEquality().equals(other._plans, _plans));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, defination, support,
      plansDescription, const DeepCollectionEquality().hash(_plans));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyServiceModelImplCopyWith<_$EmergencyServiceModelImpl>
      get copyWith => __$$EmergencyServiceModelImplCopyWithImpl<
          _$EmergencyServiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergencyServiceModelImplToJson(
      this,
    );
  }
}

abstract class _EmergencyServiceModel implements EmergencyServiceModel {
  const factory _EmergencyServiceModel(
      {@JsonKey(name: 'defination') required final String defination,
      @JsonKey(name: 'support') required final Support support,
      @JsonKey(name: 'plansDescription') required final String plansDescription,
      @JsonKey(name: 'plans')
      required final List<Plan> plans}) = _$EmergencyServiceModelImpl;

  factory _EmergencyServiceModel.fromJson(Map<String, dynamic> json) =
      _$EmergencyServiceModelImpl.fromJson;

  @override
  @JsonKey(name: 'defination')
  String get defination;
  @override
  @JsonKey(name: 'support')
  Support get support;
  @override
  @JsonKey(name: 'plansDescription')
  String get plansDescription;
  @override
  @JsonKey(name: 'plans')
  List<Plan> get plans;
  @override
  @JsonKey(ignore: true)
  _$$EmergencyServiceModelImplCopyWith<_$EmergencyServiceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return _Plan.fromJson(json);
}

/// @nodoc
mixin _$Plan {
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration')
  String get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'descrip')
  String get descrip => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount')
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'discountamount')
  double get discountamount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlanCopyWith<Plan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanCopyWith<$Res> {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) then) =
      _$PlanCopyWithImpl<$Res, Plan>;
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'duration') String duration,
      @JsonKey(name: 'descrip') String descrip,
      @JsonKey(name: 'amount') double amount,
      @JsonKey(name: 'discountamount') double discountamount});
}

/// @nodoc
class _$PlanCopyWithImpl<$Res, $Val extends Plan>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? duration = null,
    Object? descrip = null,
    Object? amount = null,
    Object? discountamount = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      descrip: null == descrip
          ? _value.descrip
          : descrip // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      discountamount: null == discountamount
          ? _value.discountamount
          : discountamount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanImplCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$$PlanImplCopyWith(
          _$PlanImpl value, $Res Function(_$PlanImpl) then) =
      __$$PlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'duration') String duration,
      @JsonKey(name: 'descrip') String descrip,
      @JsonKey(name: 'amount') double amount,
      @JsonKey(name: 'discountamount') double discountamount});
}

/// @nodoc
class __$$PlanImplCopyWithImpl<$Res>
    extends _$PlanCopyWithImpl<$Res, _$PlanImpl>
    implements _$$PlanImplCopyWith<$Res> {
  __$$PlanImplCopyWithImpl(_$PlanImpl _value, $Res Function(_$PlanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? duration = null,
    Object? descrip = null,
    Object? amount = null,
    Object? discountamount = null,
  }) {
    return _then(_$PlanImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      descrip: null == descrip
          ? _value.descrip
          : descrip // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      discountamount: null == discountamount
          ? _value.discountamount
          : discountamount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanImpl implements _Plan {
  const _$PlanImpl(
      {@JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'duration') required this.duration,
      @JsonKey(name: 'descrip') required this.descrip,
      @JsonKey(name: 'amount') required this.amount,
      @JsonKey(name: 'discountamount') required this.discountamount});

  factory _$PlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanImplFromJson(json);

  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'duration')
  final String duration;
  @override
  @JsonKey(name: 'descrip')
  final String descrip;
  @override
  @JsonKey(name: 'amount')
  final double amount;
  @override
  @JsonKey(name: 'discountamount')
  final double discountamount;

  @override
  String toString() {
    return 'Plan(title: $title, duration: $duration, descrip: $descrip, amount: $amount, discountamount: $discountamount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.descrip, descrip) || other.descrip == descrip) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.discountamount, discountamount) ||
                other.discountamount == discountamount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, duration, descrip, amount, discountamount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      __$$PlanImplCopyWithImpl<_$PlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanImplToJson(
      this,
    );
  }
}

abstract class _Plan implements Plan {
  const factory _Plan(
      {@JsonKey(name: 'title') required final String title,
      @JsonKey(name: 'duration') required final String duration,
      @JsonKey(name: 'descrip') required final String descrip,
      @JsonKey(name: 'amount') required final double amount,
      @JsonKey(name: 'discountamount')
      required final double discountamount}) = _$PlanImpl;

  factory _Plan.fromJson(Map<String, dynamic> json) = _$PlanImpl.fromJson;

  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'duration')
  String get duration;
  @override
  @JsonKey(name: 'descrip')
  String get descrip;
  @override
  @JsonKey(name: 'amount')
  double get amount;
  @override
  @JsonKey(name: 'discountamount')
  double get discountamount;
  @override
  @JsonKey(ignore: true)
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Support _$SupportFromJson(Map<String, dynamic> json) {
  return _Support.fromJson(json);
}

/// @nodoc
mixin _$Support {
  @JsonKey(name: 'preparedness')
  String get preparedness => throw _privateConstructorUsedError;
  @JsonKey(name: 'Hospital')
  String get hospital => throw _privateConstructorUsedError;
  @JsonKey(name: 'postDischarge')
  String get postDischarge => throw _privateConstructorUsedError;
  @JsonKey(name: 'healthMonitor')
  String get healthMonitor => throw _privateConstructorUsedError;
  @JsonKey(name: 'genieCare')
  String get genieCare => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupportCopyWith<Support> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportCopyWith<$Res> {
  factory $SupportCopyWith(Support value, $Res Function(Support) then) =
      _$SupportCopyWithImpl<$Res, Support>;
  @useResult
  $Res call(
      {@JsonKey(name: 'preparedness') String preparedness,
      @JsonKey(name: 'Hospital') String hospital,
      @JsonKey(name: 'postDischarge') String postDischarge,
      @JsonKey(name: 'healthMonitor') String healthMonitor,
      @JsonKey(name: 'genieCare') String genieCare});
}

/// @nodoc
class _$SupportCopyWithImpl<$Res, $Val extends Support>
    implements $SupportCopyWith<$Res> {
  _$SupportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preparedness = null,
    Object? hospital = null,
    Object? postDischarge = null,
    Object? healthMonitor = null,
    Object? genieCare = null,
  }) {
    return _then(_value.copyWith(
      preparedness: null == preparedness
          ? _value.preparedness
          : preparedness // ignore: cast_nullable_to_non_nullable
              as String,
      hospital: null == hospital
          ? _value.hospital
          : hospital // ignore: cast_nullable_to_non_nullable
              as String,
      postDischarge: null == postDischarge
          ? _value.postDischarge
          : postDischarge // ignore: cast_nullable_to_non_nullable
              as String,
      healthMonitor: null == healthMonitor
          ? _value.healthMonitor
          : healthMonitor // ignore: cast_nullable_to_non_nullable
              as String,
      genieCare: null == genieCare
          ? _value.genieCare
          : genieCare // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupportImplCopyWith<$Res> implements $SupportCopyWith<$Res> {
  factory _$$SupportImplCopyWith(
          _$SupportImpl value, $Res Function(_$SupportImpl) then) =
      __$$SupportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'preparedness') String preparedness,
      @JsonKey(name: 'Hospital') String hospital,
      @JsonKey(name: 'postDischarge') String postDischarge,
      @JsonKey(name: 'healthMonitor') String healthMonitor,
      @JsonKey(name: 'genieCare') String genieCare});
}

/// @nodoc
class __$$SupportImplCopyWithImpl<$Res>
    extends _$SupportCopyWithImpl<$Res, _$SupportImpl>
    implements _$$SupportImplCopyWith<$Res> {
  __$$SupportImplCopyWithImpl(
      _$SupportImpl _value, $Res Function(_$SupportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preparedness = null,
    Object? hospital = null,
    Object? postDischarge = null,
    Object? healthMonitor = null,
    Object? genieCare = null,
  }) {
    return _then(_$SupportImpl(
      preparedness: null == preparedness
          ? _value.preparedness
          : preparedness // ignore: cast_nullable_to_non_nullable
              as String,
      hospital: null == hospital
          ? _value.hospital
          : hospital // ignore: cast_nullable_to_non_nullable
              as String,
      postDischarge: null == postDischarge
          ? _value.postDischarge
          : postDischarge // ignore: cast_nullable_to_non_nullable
              as String,
      healthMonitor: null == healthMonitor
          ? _value.healthMonitor
          : healthMonitor // ignore: cast_nullable_to_non_nullable
              as String,
      genieCare: null == genieCare
          ? _value.genieCare
          : genieCare // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportImpl implements _Support {
  const _$SupportImpl(
      {@JsonKey(name: 'preparedness') required this.preparedness,
      @JsonKey(name: 'Hospital') required this.hospital,
      @JsonKey(name: 'postDischarge') required this.postDischarge,
      @JsonKey(name: 'healthMonitor') required this.healthMonitor,
      @JsonKey(name: 'genieCare') required this.genieCare});

  factory _$SupportImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupportImplFromJson(json);

  @override
  @JsonKey(name: 'preparedness')
  final String preparedness;
  @override
  @JsonKey(name: 'Hospital')
  final String hospital;
  @override
  @JsonKey(name: 'postDischarge')
  final String postDischarge;
  @override
  @JsonKey(name: 'healthMonitor')
  final String healthMonitor;
  @override
  @JsonKey(name: 'genieCare')
  final String genieCare;

  @override
  String toString() {
    return 'Support(preparedness: $preparedness, hospital: $hospital, postDischarge: $postDischarge, healthMonitor: $healthMonitor, genieCare: $genieCare)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportImpl &&
            (identical(other.preparedness, preparedness) ||
                other.preparedness == preparedness) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital) &&
            (identical(other.postDischarge, postDischarge) ||
                other.postDischarge == postDischarge) &&
            (identical(other.healthMonitor, healthMonitor) ||
                other.healthMonitor == healthMonitor) &&
            (identical(other.genieCare, genieCare) ||
                other.genieCare == genieCare));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, preparedness, hospital,
      postDischarge, healthMonitor, genieCare);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportImplCopyWith<_$SupportImpl> get copyWith =>
      __$$SupportImplCopyWithImpl<_$SupportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportImplToJson(
      this,
    );
  }
}

abstract class _Support implements Support {
  const factory _Support(
          {@JsonKey(name: 'preparedness') required final String preparedness,
          @JsonKey(name: 'Hospital') required final String hospital,
          @JsonKey(name: 'postDischarge') required final String postDischarge,
          @JsonKey(name: 'healthMonitor') required final String healthMonitor,
          @JsonKey(name: 'genieCare') required final String genieCare}) =
      _$SupportImpl;

  factory _Support.fromJson(Map<String, dynamic> json) = _$SupportImpl.fromJson;

  @override
  @JsonKey(name: 'preparedness')
  String get preparedness;
  @override
  @JsonKey(name: 'Hospital')
  String get hospital;
  @override
  @JsonKey(name: 'postDischarge')
  String get postDischarge;
  @override
  @JsonKey(name: 'healthMonitor')
  String get healthMonitor;
  @override
  @JsonKey(name: 'genieCare')
  String get genieCare;
  @override
  @JsonKey(ignore: true)
  _$$SupportImplCopyWith<_$SupportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
