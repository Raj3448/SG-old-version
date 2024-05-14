import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class LoadingWidget extends StatefulWidget {
  final VoidCallback? onAppeared;
  final bool showShadow;
  const LoadingWidget({Key? key, this.onAppeared, this.showShadow = true}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  void initState() {
    super.initState();

    if (widget.onAppeared != null) {
      widget.onAppeared!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 200,
          height: 142,
          padding: const EdgeInsets.symmetric(vertical: Dimension.d2),
          decoration: BoxDecoration(
              color: AppColors.grayscale100,
              borderRadius: BorderRadius.circular(Dimension.d3),
              boxShadow: widget.showShadow? [
                BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 2000,
                    color: AppColors.black.withOpacity(0.5))
              ]:null),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ).createShader(bounds);
                },
                child: Padding(
                  padding: const EdgeInsets.all(Dimension.d3),
                  child: Transform.scale(
                    scale: 1.5,
                    child: const CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.secondary),
                    ),
                  ),
                ),
              ),
              Text(
                'Please Wait',
                style: AppTextStyle.bodyLargeSemiBold
                    .copyWith(color: AppColors.grayscale700),
              )
            ],
          )),
    );
  }
}
