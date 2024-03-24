import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/members/repo/member_repo.dart';
import 'package:silver_genie/feature/members/screens/add_family_member_screen.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/member_card.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final store = GetIt.I<MembersStore>();
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 6), store.disableFetching);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder(
                future: fetchMembers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // TODO(Amanjot): update this with the new error screens.
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final members = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            'Your Family Members'.tr(),
                            style: AppTextStyle.bodyLargeBold.copyWith(
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return MemberCard(
                                name: member.name,
                                relation: member.relation,
                                hasCareSub: member.hasCareSub,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 12);
                            },
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
                            title: 'Add new member'.tr(),
                            showIcon: false,
                            iconPath: AppIcons.add,
                            size: ButtonSize.normal,
                            type: ButtonType.primary,
                            expanded: true,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
