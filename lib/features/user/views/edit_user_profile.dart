import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/utils/image_picker.dart';
import '../../../core/utils/validators.dart';
import '../../../theme/font_provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/user_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profileFile;

  late TextEditingController nameController;
  late TextEditingController disabilityController;
  late TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    disabilityController =
        TextEditingController(text: ref.read(userProvider)!.disability);
    phoneController =
        TextEditingController(text: ref.read(userProvider)!.phoneNumber);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    final user = ref.read(userProvider)!;
    ref.read(userControllerProvider.notifier).updateUser(
        context: context,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        disability: disabilityController.text.trim(),
        profileFile: profileFile);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userControllerProvider);
    final fontSize = ref.watch(fontSizesProvider);
    final user = ref.watch(userProvider)!;
    return ref.watch(getUserDataByIdProvider(user.id)).when(
        data: (user) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: fontSize.fontSize,
                      ),
                ),
                centerTitle: true,
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 200, // To fix the position of avatar
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.profilePicture),
                                      radius: 60,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: nameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'enter valid name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Name',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(18)),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                TextFormField(
                                  controller: phoneController,
                                  validator: (value) =>
                                      TValidator.validatePhoneNumber(value),
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Phone',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(18)),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                TextField(
                                  controller: disabilityController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Disability',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(18)),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                isLoading
                                    ? Loader()
                                    : Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              save();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            'Update Profile',
                                            style: TextStyle(
                                              fontSize: fontSize.bodyLarge,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
        loading: () => const Loader(),
        error: (error, stackTrace) => ErrorText(error: error.toString()));
  }
}
