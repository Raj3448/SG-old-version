import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class ErrorStateComponent extends StatelessWidget {
  final ErrorType errorType;

  const ErrorStateComponent({Key? key, required this.errorType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String errorMessage;
    String subcontent;
    String imagePath;

    switch (errorType) {
      case ErrorType.unknown:
        errorMessage = 'Unknown Error';
        subcontent =
            'We apologise but the page you are trying to access cannot be found';
        imagePath = 'assets/icon/unknown error.svg';
        break;
      case ErrorType.pageNotFound:
        errorMessage = 'Page Not Found';
        subcontent =
            'We apologise but the page you are trying to access cannot be found';
        imagePath = 'assets/icon/page not found.svg';
        break;
      case ErrorType.noInternetConnection:
        errorMessage = 'No Internet Connection';
        subcontent =
            'Please ensure you are connected to stable Wi-fi network or cellular data to continue';
        imagePath = 'assets/icon/no internet connection.svg';
        break;
      case ErrorType.somethinWentWrong:
        errorMessage = 'Something Went Wrong';
        subcontent =
            'We apologise but the page you are trying to access cannot be found';
        imagePath = 'assets/icon/unknown error.svg';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimension.d1),
      child: Column(
        children: [
          SvgPicture.asset(imagePath),
          const SizedBox(height: 16),
          Text(errorMessage,
              style: AppTextStyle.bodyXLSemiBold.copyWith(
                  height: 2.8, fontSize: 20, fontWeight: FontWeight.w600)),
          Text(subcontent,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyLargeMedium
                  .copyWith(height: 1.5, color: AppColors.grayscale800))
        ],
      ),
    );
  }
}

enum ErrorType {
  unknown,
  pageNotFound,
  noInternetConnection,
  somethinWentWrong
}
