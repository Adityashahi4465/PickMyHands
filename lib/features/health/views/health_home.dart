import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/snackbar.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/font_provider.dart';
import '../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../auth/controller/auth_controller.dart';
import '../../dashboard/widgets/shimmer.dart';
import '../../user/controller/user_controller.dart';

final List tabs = [
  "Documents",
  "Prescription",
  "Appointment",
];

class HealthHomeView extends ConsumerWidget {
  HealthHomeView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final fontSize = ref.watch(fontSizesProvider);
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user_loading = ref.watch(userControllerProvider);
    final user = ref.watch(userProvider)!;
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Theme.of(context).primaryColor,
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(),
                width: width,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 45.0, left: 10, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigation.navigateToBack(context);
                            },
                          ),
                          Switch(
                              activeColor: Dcream,
                              value: notifier.isDark,
                              onChanged: (value) => notifier.changeTheme()),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (1.12 / 0.9),
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 1,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  // Navigate to Report and Recommendation Page
                                  Navigation.navigateMyDocument(context);
                                  break;
                                case 1:
                                  // Navigate to Community Page
                                  Navigation.navigateToPrescriptionCalender(
                                      context);
                                  break;
                                case 2:
                                  // Navigate to Medicare Page
                                  Navigation.navigateToAppointmentCalender(
                                      context);
                                  break;

                                default:
                                  // Handle any undefined index
                                  Fluttertoast.showToast(
                                    msg: "This page is under construction",
                                  );
                                  break;
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isDarkTheme ? Dcream : Lpurple1,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.3,
                                    blurRadius: 1,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Image.asset(imgData[index]),
                                  Text(
                                    tabs[index],
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          fontSize: fontSize.fontSize,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.red.shade400,
          shape: const CircleBorder(),
          onPressed: () {
            // Get.to(() => AddContactsPage());
            successSnackBar(
                context: context,
                message:
                    'Your Community "Jffffffffffffffffffffff" Created Successfully!',
                title: 'Success');
          },
          child: const Icon(
            Icons.sos_rounded,
            size: 48,
            color: Dbrown1,
          ),
          elevation: 2.0,
        ),
      );
    });
  }
}
