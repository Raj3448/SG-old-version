// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _Env {
  static const List<int> _enviedkeyserverUrl = <int>[
    1073414930,
    2556958791,
    3858472332,
    3324076874,
    2938887137,
    511841557,
    39521484,
    1765589114,
    2315053986,
  ];

  static const List<int> _envieddataserverUrl = <int>[
    1073415009,
    2556958754,
    3858472446,
    3324076860,
    2938887044,
    511841639,
    39521433,
    1765589000,
    2315054030,
  ];

  static final String serverUrl = String.fromCharCodes(List<int>.generate(
    _envieddataserverUrl.length,
    (int i) => i,
    growable: false,
  ).map((int i) => _envieddataserverUrl[i] ^ _enviedkeyserverUrl[i]));
}
