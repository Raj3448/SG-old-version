// ignore_for_file: inference_failure_on_function_invocation, one_member_abstracts

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/onboarding/models/master_data_model.dart';

abstract class IMasterService {
  Future<Either<Error, MasterDataModel>> getAllMasterData();
}

class MasterDataService implements IMasterService {
  final dio = GetIt.I<HttpClient>();

  @override
  Future<Either<Error, MasterDataModel>> getAllMasterData() async {
    try {
      final response =
          await dio.get('https://silvergenie.com/api/v1/masterData');

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final masterData = MasterDataModel.fromJson(jsonData);
        return Right(masterData);
      } else {
        return Left(
          Error(
            'Failed to load master data',
          ),
        );
      }
    } catch (e) {
      return Left(
        Error('An error occurred: $e'),
      );
    }
  }
}

class Error {
  Error(this.message);
  final String message;
}
