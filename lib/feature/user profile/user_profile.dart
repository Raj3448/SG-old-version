import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/profile_component.dart';
import 'package:silver_genie/core/widgets/profile_nav.dart';
import 'package:silver_genie/feature/user%20profile/cubit/user_details_cubit.dart';
import 'package:silver_genie/feature/user%20profile/model/user_details.dart';
import 'package:silver_genie/feature/user%20profile/profile_details.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserDetails? userDetails;
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    userDetails = context.read<UserDetailsCubit>().getCurrentUserDetails;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'User Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.d4),
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
                          userDetails!.fullname,
                          style: AppTextStyle.bodyXLSemiBold,
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dimension.d4,
                    ),
                    CustomTextIcon(
                        iconpath: AppIcons.phone, title: userDetails!.mobileNum),
                    SizedBox(
                      height: Dimension.d2,
                    ),
                    CustomTextIcon(
                      iconpath: AppIcons.home,
                      title: userDetails!.emailId,
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
                          ).then((value) {
                            setState(() {});
                          });
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
              ProfileNav(
                title: 'SG+ subscription',
              ),
              ProfileNav(
                title: 'Emergency subscription',
              ),
              ProfileNav(title: 'About'),
              ProfileNav(title: 'Logout'),
            ],
          ),
        ),
      ),
    );
  }
}
