// ignore_for_file: inference_failure_on_function_invocation, one_member_abstracts

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/onboarding/models/master_data_model.dart';

abstract class IMasterService {
  Future<Either<Failure, MasterDataModel>> getAllMasterData();
}

class MasterDataService implements IMasterService {
  MasterDataService({required this.httpClient});

  final HttpClient httpClient;

  @override
  Future<Either<Failure, MasterDataModel>> getAllMasterData() async {
    try {
      final response =
          await httpClient.get('https://silvergenie.com/api/v1/masterData');

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final masterData = MasterDataModel.fromJson(jsonData);
        return Right(masterData);
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
