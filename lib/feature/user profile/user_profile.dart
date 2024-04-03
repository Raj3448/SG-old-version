import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/profile_component.dart';
import 'package:silver_genie/core/widgets/profile_nav.dart';
import 'package:silver_genie/feature/user%20profile/profile_details.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppbar(title: 'User Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimension.d4),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimension.d1),
                    border: Border.all(
                      color: AppColors.secondary,
                      width: 2,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(Dimension.d3),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Avatar(imgPath: '', maxRadius: 44),
                        SizedBox(
                          width: Dimension.d2,
                        ),
                        Text(
                          'Varun Nair',
                          style: AppTextStyle.bodyXLSemiBold,
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dimension.d4,
                    ),
                    CustomTextIcon(
                        iconpath: AppIcons.phone, title: '1234567890'),
                    SizedBox(
                      height: Dimension.d2,
                    ),
                    CustomTextIcon(
                      iconpath: AppIcons.home,
                      title: 'dfhgjhkl@gmail.com',
                    ),
                    SizedBox(
                      height: Dimension.d4,
                    ),
                    CustomButton(
                        ontap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileDetails(),
                            ),
                          );
                        },
                        title: 'Edit',
                        showIcon: false,
                        iconPath: Icons.not_interested,
                        size: ButtonSize.small,
                        type: ButtonType.secondary,
                        expanded: true)
                  ]),
                ),
              ),
              SizedBox(
                height: Dimension.d6,
              ),
              ProfileNav(
                title: 'Wallet',
              ),
              ProfileNav(title: 'SG+ subscription',),
              ProfileNav(title: 'Emergency subscription',),
              ProfileNav(title: 'About'),
              ProfileNav(title: 'Logout'),
            ],
          ),
        ),
      ),
    );
  }
}
