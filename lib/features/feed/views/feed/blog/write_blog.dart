import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/common/loader.dart';
import '../../../../../core/utils/image_picker.dart';
import '../../../../../core/utils/snackbar.dart';
import '../../../controller/feed_controller.dart';
import 'home_screen_blogs.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List categories = [
  "Tech",
  "Data Science",
  "Web Development",
  "Machine Learning",
  "Science",
  "Math",
  "Arts",
  "Productivity",
  "Carrier",
  "Food",
  "Travel",
  "Health" "Movie",
  "Political",
  "Business",
  "Sports",
  "News",
  "Personal",
];

class WriteBlog extends ConsumerStatefulWidget {
  const WriteBlog({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => WriteBlogState();
}

class WriteBlogState extends ConsumerState<WriteBlog> {
  final titleController = TextEditingController();
  final articleController = TextEditingController();
  final linkController = TextEditingController();
  final briefController = TextEditingController();
  final readingTimeController = TextEditingController();
  File? bannerFile;
  String selectedCategory = "";
  late List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  Uint8List? bannerWebFile;
  final formKey1 = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = [];
    for (var listItem in listItems) {
      items.add(
        DropdownMenuItem(
          value: listItem,
          child: Text(listItem),
        ),
      );
    }
    return items;
  }

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

  void sharePost() {
    if (bannerFile != null || bannerWebFile != null) {
      ref.read(articleControllerProvider.notifier).shareArticle(
            context: context,
            title: titleController.text.trim(),
            category: selectedCategory,
            brief: briefController.text.trim(),
            description: articleController.text,
            link: linkController.text.trim(),
            file: bannerFile,
            bannerWebFile: bannerWebFile,
            readingTime: readingTimeController.text.trim(),
          );
    } else {
      warningSnackBar(
        context: context,
        message: 'Please pick and image',
        title: 'Warning!',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(categories);
    //selectedItem = _dropdownMenuItems[0].value;
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    articleController.dispose();
    linkController.dispose();
    briefController.dispose();
    readingTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(articleControllerProvider);
    return Form(
      key: formKey1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Let\'s Write'),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  if (formKey1.currentState!.validate()) {
                    sharePost();
                  }
                },
                child: const Text('Share'))
          ],
        ),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Title can't be left empty.";
                          }
                          return null;
                        },
                        controller: titleController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Title Here',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLength: 40,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "brief can't be left empty.";
                          }
                          return null;
                        },
                        controller: briefController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter brief here',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLength: 100,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: articleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Article can't be left empty.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Write the Article',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: readingTimeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Description can't be left empty.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Reading Time(in minutes) here .',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: linkController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter External Links here ',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
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
                                          child: Icon(Icons.camera_alt_outlined,
                                              size: 40),
                                        )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Select Category'),
                      ),
                      DropdownButtonFormField<String>(
                          validator: (value) =>
                              value == null ? "Please select a category" : null,
                          hint: const Text('Select a category'),
                          value:
                              selectedCategory == "" ? null : selectedCategory,
                          items: _dropdownMenuItems,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          }),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
