// ignore_for_file: use_build_context_synchronously, use_if_null_to_convert_nulls_to_bools, lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsletterComponent extends StatefulWidget {
  const NewsletterComponent({required this.newsletterModel, super.key});

  final NewsletterModel newsletterModel;

  @override
  State<NewsletterComponent> createState() => NewsletterComponentState();
}

class NewsletterComponentState extends State<NewsletterComponent> {
  late Timer _timer;
  String? _taskId;
  bool isTimerTrigger = false;

  Future<void> startDownload(int index) async {
    final iOSDirPath = await getApplicationDocumentsDirectory();
    _taskId = await FlutterDownloader.enqueue(
      url: widget.newsletterModel.newsletters[index].link.href,
      savedDir: iOSDirPath.path,
      fileName: '${widget.newsletterModel.newsletters[index].link.label}',
      saveInPublicStorage: true,
    );

    isTimerTrigger = true;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download started!'),
      ),
    );

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id='$_taskId'",
      );

      if (tasks!.isNotEmpty) {
        final status = tasks.first.status;
        if (status == DownloadTaskStatus.complete) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download completed!')),
          );
          timer.cancel();
        } else if (status == DownloadTaskStatus.failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download failed!')),
          );
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    if (isTimerTrigger) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimension.d6),
        Text(
          widget.newsletterModel.title,
          style:
              AppTextStyle.bodyXLMedium.copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d3),
        Text(
          widget.newsletterModel.description,
          style: AppTextStyle.bodyLargeMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(height: Dimension.d3),
        if (widget.newsletterModel.newsletters.isNotEmpty)
          Row(
            mainAxisAlignment: widget.newsletterModel.newsletters.length > 1
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: List.generate(
              widget.newsletterModel.newsletters.length > 1 ? 2 : 1,
              (index) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
                  child: CustomButton(
                    ontap: () {
                      if (widget.newsletterModel.newsletters[index].link
                              .downloadLink ??
                          false) {
                        startDownload(index);
                      }
                      if (widget.newsletterModel.newsletters[index].link
                              .isExternal ??
                          false) {
                        launchUrl(
                          Uri.parse(
                            widget.newsletterModel.newsletters[index].link.href,
                          ),
                        );
                      }
                    },
                    title: widget.newsletterModel.newsletters[index].label,
                    showIcon: false,
                    iconPath: AppIcons.add,
                    size: ButtonSize.normal,
                    type: widget.newsletterModel.newsletters[index].theme ==
                            'secondary'
                        ? ButtonType.secondary
                        : widget.newsletterModel.newsletters[index].theme ==
                                'primary'
                            ? ButtonType.primary
                            : ButtonType.tertiary,
                    expanded: true,
                    iconColor: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: Dimension.d6),
      ],
    );
  }
}
