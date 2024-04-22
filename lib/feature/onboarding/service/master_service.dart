// ignore_for_file: inference_failure_on_function_invocation, one_member_abstracts

import 'package:dio/dio.dart';
import 'package:silver_genie/feature/onboarding/models/master_data_model.dart';

abstract class IMasterService {
  Future<MasterDataModel> getAllMasterData();
}

class FetchMasterData implements IMasterService {
  FetchMasterData(this._dio);
  final Dio _dio;

  @override
  Future<MasterDataModel> getAllMasterData() async {
    final response =
        await _dio.get('https://silvergenie.com/api/v1/masterData');

    if (response.statusCode == 200) {
      final jsonData = response.data as Map<String, dynamic>;
      return MasterDataModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load master data');
    }
  }
}
