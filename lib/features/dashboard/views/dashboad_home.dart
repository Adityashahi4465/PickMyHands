import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/notification_service.dart';
import '../../../core/utils/snackbar.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/font_provider.dart';
import '../../../theme/theme_provider.dart';
import 'package:provider/provider.dart' as provider;

import '../../auth/controller/auth_controller.dart';
import '../../user/controller/user_controller.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/menu.dart';
import '../widgets/shimmer.dart';

final List tabs = [
  "Report & Recommendation",
  "Community",
  "Medicare",
  "Connect Me",
  "Services",
  "Feed"
];

class DashboardHomeView extends ConsumerStatefulWidget {
  const DashboardHomeView({super.key});

  @override
  ConsumerState<DashboardHomeView> createState() => _DashboardHomeViewState();
}

class _DashboardHomeViewState extends ConsumerState<DashboardHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int clickCount = 0;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _incrementClickCount();
  }

  Future<void> _incrementClickCount() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCount = _prefs.getInt('video_click_count') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          drawer: const MenuDrawer(),
          body: Stack(
            children: [
              Container(
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
                            padding: const EdgeInsets.only(
                                top: 45.0, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.menu,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    _scaffoldKey.currentState
                                        ?.openDrawer(); // This line opens the drawer.
                                  },
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(clickCount.toString())
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Switch(
                                      activeColor: Dcream,
                                      value: notifier.isDark,
                                      onChanged: (value) =>
                                          notifier.changeTheme(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              left: 30,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                user_loading
                                    ? const TshimerEffect(width: 80, height: 15)
                                    : Text(
                                        "Hello, ${user.name}!",
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              color:
                                                  isDarkTheme ? Dcream : Lcream,
                                              fontSize: fontSize.headingSize,
                                            ),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Welcome to SAMPOORNA – Redefining Accessibility, Limitlessly!",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: isDarkTheme ? Dcream : Lcream,
                                        fontSize: fontSize.subheadingSize,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? dashboard
                              : Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 0),
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
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      // Navigate to Report and Recommendation Page
                                      Navigation
                                          .navigateToReportandRecommendation(
                                              context);
                                      break;
                                    case 1:
                                      // Navigate to Community Page
                                      Navigation.navigateCommunityHome(context);
                                      break;
                                    case 2:
                                      // Navigate to Medicare Page
                                      Navigation.navigateHealthHome(context);
                                      break;
                                    case 3:
                                      // Navigate to Connect Me Page
                                      Navigation.navigateToCounsellorHome(
                                        context,
                                      );
                                      break;
                                    case 4:
                                      // Navigate to Services Page
                                      Navigation.navigateToServices(context);
                                      break;
                                    case 5:
                                      Navigation.navigateToFeed(context);
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
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 350,
                child: Container(
                  color: isDarkTheme ? Dbrown3 : Lpurple3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          ref.read(fontSizeManager).increaseAllFontSizes(ref);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          ref.read(fontSizeManager).decreaseAllFontSizes(ref);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.large(
            backgroundColor: Colors.red.shade400,
            shape: const CircleBorder(),
            onPressed: () {
              // // Get.to(() => AddContactsPage());
              // NotificationService().showNotification(
              //     id: 0, title: 'New Notification', body: 'nothing');
              print('Scheduling notification...');

              NotificationService().scheduleNotification(
                  scheduledNotificationDateTime:
                      DateTime.now().add(const Duration(seconds: 10)),
                  title: 'Scheduled Notification');
              successSnackBar(
                  context: context,
                  message:
                      'Your Notification Scheduled Successfully At  ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(const Duration(seconds: 10)))}!',
                  title: 'Success');
            },
            child: const Icon(
              Icons.sos_rounded,
              size: 48,
              color: Dbrown1,
            ),
            elevation: 2.0,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const BottomBar());
    });
  }
}
