import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';
import '../../../core/utils/image_picker.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/font_provider.dart';
import '../../../theme/theme_provider.dart';
import '../controller/community_controller.dart';
import 'package:provider/provider.dart' as provider;

// We are using statefulWidget bcz we have to dispose textfield
class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  File? bannerFile;
  Uint8List? bannerWebFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
          bannerFile,
          bannerWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final isDarkTheme = provider.Provider.of<ThemeProvider>(context).isDark;
    final fontSize = ref.watch(fontSizesProvider);
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create a Community'),
        ),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: isDarkTheme ? Dcream : Lpurple1,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerWebFile != null
                              ? Image.memory(bannerWebFile!)
                              : bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Community Name',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: fontSize.fontSize,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: communityNameController,
                      decoration: const InputDecoration(
                        hintText: 'Community_name',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 22,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: createCommunity,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Create Community',
                        style: TextStyle(fontSize: fontSize.bodyLarge),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
