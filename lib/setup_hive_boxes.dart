import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:silver_genie/feature/home/model/master_data_model.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

const TOKEN_BOX_NAME = 'jwt_token_box';
const JWT_TOKEN_KEY = 'JWT_token';

const USER_DETAILS_BOX_NAME = 'user_details_box';
const USER_DETAILS_BOX_KEY = 'userDetails_box_key';

const HOMEPAGE_DETAILS_BOX_NAME = 'homePageDetails';
const HOMEPAGE_DETAILS_BOX_Key = 'homePageBoxKey';

const MASTER_DATA_BOX_NAME = 'masterdata-box';
const MASTER_DATA_BOX_KEY = 'masterdata-box-KEY';

const storage = FlutterSecureStorage();

Future<void> setupHiveBox() async {
  await initializeBoxForToken();
  await initializeBoxForUserDetails();
  await initializeBoxForHomePageDetails();
  await initializeBoxForMasterData();
}

Future<void> initializeBoxForMasterData() async {
  Hive
    ..registerAdapter(MasterDataModelAdapter())
    ..registerAdapter(MasterDataAdapter())
    ..registerAdapter(ContactUsAdapter())
    ..registerAdapter(EmergencyHelplineAdapter());
  await Hive.openBox<MasterDataModel>(
    MASTER_DATA_BOX_NAME,
    compactionStrategy: (int total, int deleted) => deleted > 2,
  );
}

Future<void> initializeBoxForHomePageDetails() async {
  Hive
    ..registerAdapter(AboutUsOfferModelAdapter())
    ..registerAdapter(BannerImageModelAdapter())
    ..registerAdapter(TestimonialsModelAdapter())
    ..registerAdapter(TestimonialsAdapter())
    ..registerAdapter(DatumAdapter())
    ..registerAdapter(AttributesAdapter())
    ..registerAdapter(BannerImageAdapter())
    ..registerAdapter(DataAdapter())
    ..registerAdapter(ImageDataModelAdapter())
    ..registerAdapter(CtaAdapter())
    ..registerAdapter(LinkAdapter())
    ..registerAdapter(OfferingAdapter())
    ..registerAdapter(OfferAdapter())
    ..registerAdapter(ValueAdapter())
    ..registerAdapter(NewsletterAdapter())
    ..registerAdapter(NewsletterModelAdapter());
  await Hive.openBox<List<dynamic>>(
    HOMEPAGE_DETAILS_BOX_NAME,
    compactionStrategy: (int total, int deleted) => deleted > 2,
  );
}

Future<void> initializeBoxForUserDetails() async {
  Hive
    ..registerAdapter(UserAdapter())
    ..registerAdapter(AddressAdapter())
    ..registerAdapter(ProfileImgAdapter())
    ..registerAdapter(FormatsAdapter())
    ..registerAdapter(ThumbnailAdapter());

  await Hive.openBox<User>(
    USER_DETAILS_BOX_NAME,
    compactionStrategy: (int total, int deleted) => deleted > 2,
  );
}

Future<void> initializeBoxForToken() async {
  String? existingKey = await storage.read(key: 'hive_key');
  if (existingKey == null) {
    var newKey = Hive.generateSecureKey();
    await storage.write(key: 'hive_key', value: base64UrlEncode(newKey));
    existingKey = base64UrlEncode(newKey);
  }
  var key = base64Url.decode(existingKey);
  // ignore: inference_failure_on_function_invocation
  await Hive.openBox(TOKEN_BOX_NAME, encryptionCipher: HiveAesCipher(key));
}
