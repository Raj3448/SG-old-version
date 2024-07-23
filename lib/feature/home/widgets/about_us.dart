import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsOfferComponent extends StatelessWidget {
  AboutUsOfferComponent({
    required this.aboutUsOfferModel,
  });

  final AboutUsOfferModel aboutUsOfferModel;
  final PageController _offerPageController =
      PageController(viewportFraction: 0.58);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          aboutUsOfferModel.header,
          style: AppTextStyle.bodyXLSemiBold
              .copyWith(color: AppColors.grayscale900, height: 2.6),
        ),
        Text(
          aboutUsOfferModel.description,
          style: AppTextStyle.bodyLargeMedium.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: AppColors.grayscale700,
          ),
        ),
        Text(
          aboutUsOfferModel.offering.header,
          style: AppTextStyle.bodyXLSemiBold.copyWith(
            color: AppColors.grayscale900,
            height: 2.4,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: Dimension.d1),
        SizedBox(
          height: 240,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            controller: _offerPageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              aboutUsOfferModel.offering.offers.length,
              (index) => _HomeScreenOfferCard(
                offerTitle: aboutUsOfferModel.offering.offers[index].title,
                content: List.generate(
                  aboutUsOfferModel.offering.offers[index].values.length,
                  (i) =>
                      aboutUsOfferModel.offering.offers[index].values[i].value,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: Dimension.d4,
        ),
        Center(
          child: SmoothPageIndicator(
            controller: _offerPageController,
            count: aboutUsOfferModel.offering.offers.length,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotColor: AppColors.grayscale300,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimension.d3),
          child: CustomButton(
            ontap: () async {
              String url;
              url = aboutUsOfferModel.cta.href ??
                  aboutUsOfferModel.cta.link!.href;
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
            title: aboutUsOfferModel.cta.label ?? '',
            showIcon: false,
            iconColor: AppColors.error,
            iconPath: Icons.not_interested,
            size: ButtonSize.normal,
            type: ButtonType.secondary,
            expanded: true,
          ),
        ),
      ],
    );
  }
}

class _HomeScreenOfferCard extends StatelessWidget {
  const _HomeScreenOfferCard({
    required this.offerTitle,
    required this.content,
  });

  final String offerTitle;
  final List<String> content;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 236,
      width: MediaQuery.sizeOf(context).width * 0.60,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border.all(width: 2, color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offerTitle,
              style: AppTextStyle.bodyXLSemiBold.copyWith(
                color: AppColors.grayscale900,
                height: 2.4,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            Column(
              children: List.generate(
                content.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: Dimension.d2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Icon(
                          AppIcons.check,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(
                        width: Dimension.d3,
                      ),
                      Expanded(
                        child: Text(
                          content[index],
                          style: AppTextStyle.bodyMediumMedium.copyWith(
                            color: AppColors.grayscale700,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
