// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class ErrorStateComponent extends StatelessWidget {
  const ErrorStateComponent(
      {required this.errorType, this.errorMessage, super.key});
  final ErrorType errorType;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    String errorMessage2;
    String subcontent;
    String imagePath;

    switch (errorType) {
      case ErrorType.unknown:
        errorMessage2 = 'Unknown Error';
        subcontent =
            'We apologise but the page you are trying to access cannot be found';
        imagePath = 'assets/icon/unknown error.svg';
      case ErrorType.pageNotFound:
        errorMessage2 = 'Page Not Found';
        subcontent =
            'We apologise but the page you are trying to access cannot be found';
        imagePath = 'assets/icon/page not found.svg';
      case ErrorType.noInternetConnection:
        errorMessage2 = 'No Internet Connection';
        subcontent =
            'Please ensure you are connected to stable Wi-fi network or cellular data to continue';
        imagePath = 'assets/icon/no internet connection.svg';
      case ErrorType.somethinWentWrong:
        errorMessage2 = 'Something Went Wrong';
        subcontent =
            'We apologise but the page you are trying to access cannot be found';
        imagePath = 'assets/icon/unknown error.svg';
    }
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      errorMessage2 = errorMessage!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimension.d1),
      child: Column(
        children: [
          SvgPicture.asset(imagePath),
          const SizedBox(height: 16),
          Text(
            errorMessage2,
            style: AppTextStyle.bodyXLSemiBold.copyWith(
              height: 2.8,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subcontent,
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyLargeMedium
                .copyWith(height: 1.5, color: AppColors.grayscale800),
          ),
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
