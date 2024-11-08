import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.1,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomAppBar(
              clipBehavior: Clip.none,
              color: isDarkTheme ? Dcream : Lpurple1,
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard_rounded,
                              color: isDarkTheme ? Dbrown1 : Lcream,
                              size: 24,
                            ),
                            Text(
                              'DASHBOARD',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDarkTheme ? Dbrown1 : Lcream,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          //   currentScreen = HomeScreen();
                          //   currentTab = 0;
                          // });
                          // Navigator.pushNamed(context, TrackerPage.id);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble,
                              color: isDarkTheme ? Dbrown1 : Lcream,
                              size: 24,
                            ),
                            Text(
                              'CHATBOT HELP',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDarkTheme ? Dbrown1 : Lcream,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
