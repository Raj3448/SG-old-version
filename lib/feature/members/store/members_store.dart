// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'members_store.g.dart';

class MembersStore = _MembersStoreBase with _$MembersStore;

abstract class _MembersStoreBase with Store {}
