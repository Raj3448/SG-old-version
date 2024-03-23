import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/elder_care_sub.dart';
import 'package:silver_genie/core/widgets/relationship.dart';
import 'package:silver_genie/feature/main/store/main_store.dart';
import 'package:silver_genie/feature/profile/screens/add_family_member_screen.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final store = GetIt.I<MainStore>();
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 6), store.disableFetching);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: Observer(
        builder: (context) {
          if (store.isFetching) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else {
            return store.dataAvailable
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            'Your Family Members',
                            style: AppTextStyle.bodyLargeBold.copyWith(
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _MemberCard(
                            name: 'Varun nair',
                            relation: 'Father',
                            hasCareSub: true,
                          ),
                          const SizedBox(height: 12),
                          const _MemberCard(
                            name: 'Shalini Kaphoor',
                            relation: 'Mother',
                            hasCareSub: true,
                          ),
                          const SizedBox(height: 12),
                          const _MemberCard(
                            name: 'Sameera',
                            relation: 'Wife',
                            hasCareSub: false,
                          ),
                          const SizedBox(height: 12),
                          const _MemberCard(
                            name: 'Arun',
                            relation: 'Self',
                            hasCareSub: false,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddFamilyMemberScreen(),
                                ),
                              );
                            },
                            title: 'Add new member',
                            showIcon: false,
                            iconPath: AppIcons.add,
                            size: ButtonSize.normal,
                            type: ButtonType.primary,
                            expanded: true,
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Data not available'),
                        const SizedBox(height: 10),
                        CustomButton(
                          ontap: () {
                            store.dataAvailable = true;
                          },
                          title: 'Retry',
                          showIcon: false,
                          iconPath: AppIcons.warning,
                          size: ButtonSize.normal,
                          type: ButtonType.state,
                          expanded: false,
                        ),
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.name,
    required this.relation,
    required this.hasCareSub,
  });

  final String name;
  final String relation;
  final bool hasCareSub;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar.fromSize(imgPath: '', size: AvatarSize.size32),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.bodyLargeBold,
                  ),
                  const SizedBox(height: 5),
                  Relationship(relation: relation),
                ],
              ),
              const Spacer(),
              const Icon(
                AppIcons.arrow_forward_ios,
                color: AppColors.grayscale900,
                size: 17,
              ),
            ],
          ),
          if (hasCareSub)
            const Column(
              children: [
                SizedBox(height: 8),
                ElderCareSubscription(color: ElderCareColor.blue),
              ],
            ),
        ],
      ),
    );
  }
}
