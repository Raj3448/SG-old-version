import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TestmonialsComponent extends StatelessWidget {
  TestmonialsComponent({
    required this.testimonialsModel,
    super.key,
  });

  final PageController _testimonialsCardController =
      PageController(viewportFraction: 0.60);
  final TestimonialsModel testimonialsModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.secondary),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.d4,
        vertical: Dimension.d2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimension.d2),
          Text(
            testimonialsModel.title,
            style: AppTextStyle.bodyXLSemiBold.copyWith(
              color: AppColors.grayscale900,
            ),
          ),
          const SizedBox(height: Dimension.d4),
          Column(
            children: [
              SizedBox(
                height: 132,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  controller: _testimonialsCardController,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    testimonialsModel.testimonials.data.length,
                    (index) => _TestmonialsCard(
                      testifierName: testimonialsModel
                          .testimonials.data[index].attributes.testifierName,
                      content: testimonialsModel
                          .testimonials.data[index].attributes.content,
                      imgUrl: testimonialsModel.testimonials.data[index]
                          .attributes.testifierImage?.data!.attributes.url,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimension.d4),
              Center(
                child: SmoothPageIndicator(
                  controller: _testimonialsCardController,
                  count: testimonialsModel.testimonials.data.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.grayscale300,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
              const SizedBox(height: Dimension.d2),
            ],
          ),
        ],
      ),
    );
  }
}

class _TestmonialsCard extends StatelessWidget {
  const _TestmonialsCard({
    required this.testifierName,
    required this.content,
    this.imgUrl,
    Key? key,
  }) : super(key: key);

  final String testifierName;
  final String content;
  final String? imgUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      width: MediaQuery.sizeOf(context).width * 0.60,
      margin: const EdgeInsets.only(left: Dimension.d2),
      padding: const EdgeInsets.all(Dimension.d2),
      decoration: BoxDecoration(
        color: AppColors.grayscale100,
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              Avatar.fromSize(
                imgPath: imgUrl == null ? '' : '${Env.serverUrl}${imgUrl!}',
                size: AvatarSize.size12,
              ),
              const SizedBox(
                width: Dimension.d2,
              ),
              Flexible(
                child: Text(
                  testifierName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: AppColors.grayscale800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
