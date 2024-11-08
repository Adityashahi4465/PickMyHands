import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme_provider.dart';

class OnBoardingPage extends StatefulWidget {
  final VoidCallback onComplete;
  const OnBoardingPage({super.key, required this.onComplete});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 50.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.90,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          20.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkTheme ? Ddisable : Lgrey,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/images/onboardin1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Heartfelt Inclusion",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color:
                                      isDarkTheme ? Colors.white : Colors.black,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              20.0,
                            ),
                            child: Text(
                              "Connecting hearts, erasing loneliness; empowering specially-abled with empathy, not pity",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          )
                        ],
                      ),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Theme.of(context).disabledColor,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: Durations.long1,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Align buttons evenly
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: isDarkTheme
                                      ? MaterialStateProperty.all<Color>(
                                          Dbrown3)
                                      : MaterialStateProperty.all<Color>(
                                          Lpurple2),
                                ),
                                onPressed: widget.onComplete,
                                child: const Text(
                                  "Skip",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 20), // Add margin between buttons
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  _pageController.animateToPage(
                                    1,
                                    duration: Durations.long1,
                                    curve: Curves.linear,
                                  );
                                },
                                child: const Text(
                                  "Next",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.80,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          30.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme ? Ddisable : Lgrey,
                              shape: BoxShape.circle),
                          child: Image.asset(
                            "assets/images/onboardin1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Guardian Alert",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color:
                                      isDarkTheme ? Colors.white : Colors.black,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              20.0,
                            ),
                            child: Text(
                              "Shake your phone, notify loved ones with live location, feel safe",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          )
                        ],
                      ),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Theme.of(context).disabledColor,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: Durations.long1,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Align buttons evenly
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: isDarkTheme
                                      ? MaterialStateProperty.all<Color>(
                                          Dbrown3)
                                      : MaterialStateProperty.all<Color>(
                                          Lpurple2),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Skip",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 20), // Add margin between buttons
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  _pageController.animateToPage(
                                    2,
                                    duration: Durations.long1,
                                    curve: Curves.linear,
                                  );
                                },
                                child: const Text(
                                  "Next",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.80,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          30.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme ? Ddisable : Lgrey,
                              shape: BoxShape.circle),
                          child: Image.asset(
                            "assets/images/onboardin1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Health Companion",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color:
                                      isDarkTheme ? Colors.white : Colors.black,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              20.0,
                            ),
                            child: Text(
                              "Save reports, set alarms, we nurture your health journey lovingly",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          )
                        ],
                      ),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Theme.of(context).disabledColor,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: Durations.long1,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Align buttons evenly
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: isDarkTheme
                                      ? MaterialStateProperty.all<Color>(
                                          Dbrown3)
                                      : MaterialStateProperty.all<Color>(
                                          Lpurple2),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Skip",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 20), // Add margin between buttons
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                  3,
                                  duration: Durations.long1,
                                  curve: Curves.linear,
                                );
                              },
                              child: const Text(
                                "Next",
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.80,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          30.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: isDarkTheme ? Ddisable : Lgrey,
                              shape: BoxShape.circle),
                          child: Image.asset(
                            "assets/images/onboardin1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Recommendation and report",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color:
                                      isDarkTheme ? Colors.white : Colors.black,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              20.0,
                            ),
                            child: Text(
                              "Recommend and report your experience for disability-friendly places",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          )
                        ],
                      ),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Theme.of(context).disabledColor,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: Durations.long1,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                        child: ElevatedButton(
                          onPressed: widget.onComplete,
                          child: const Text(
                            "Get Started",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
