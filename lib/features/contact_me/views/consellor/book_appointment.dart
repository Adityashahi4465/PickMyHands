import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/loader.dart';
import '../../../../core/utils/image_picker.dart';
import '../../../../core/utils/validators.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/font_provider.dart';
import '../../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../controller/contect_me_controller.dart';


// We are using statefulWidget bcz we have to dispose textfield
class BookAppointmentScreen extends ConsumerStatefulWidget {
  final String id;
  const BookAppointmentScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  final reasonController = TextEditingController();
  final date = TextEditingController();
  DateTime time = DateTime.now();
  @override
  void dispose() {
    super.dispose();
    reasonController.dispose();
    date.dispose();
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

  void bookAppointment() {
    ref.read(contactMeControllerProvider.notifier).bookAppointment(
          reasonController.text.trim(),
          time,
          widget.id,
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(contactMeControllerProvider);
    final isDarkTheme = provider.Provider.of<ThemeProvider>(context).isDark;
    final fontSize = ref.watch(fontSizesProvider);
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Book Appointment'),
        ),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Appointment Reason',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: fontSize.fontSize,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        hintText: 'Appointment Reason',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Enter Appointment Date',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontSize: fontSize.fontSize,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: date,
                                validator: (value) =>
                                    TValidator.validateEmptyText('Date', value),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.none,
                                // onChanged: (value) {
                                //   //Do something with the user input.
                                //   // password = value;
                                // },
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.calendar_month_rounded,
                                    color: isDarkTheme ? Dcream : Lpurple1,
                                  ),
                                  hintText: 'Select date',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                ),
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickeddate != null) {
                                    setState(() {
                                      date.text = DateFormat('dd-MM-yyyy')
                                          .format(pickeddate);
                                      time = pickeddate;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: bookAppointment,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Book Appointment',
                        style: TextStyle(
                          fontSize: fontSize.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
