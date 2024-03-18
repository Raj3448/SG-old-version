// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _Env {
  static const List<int> _enviedkeyserverUrl = <int>[
    1423901082,
    2188854511,
  ];

  static const List<int> _envieddataserverUrl = <int>[
    1423901112,
    2188854477,
  ];

  static final String serverUrl = String.fromCharCodes(List<int>.generate(
    _envieddataserverUrl.length,
    (int i) => i,
    growable: false,
  ).map((int i) => _envieddataserverUrl[i] ^ _enviedkeyserverUrl[i]));
}
