import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/font_provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../../user/controller/user_controller.dart';
import 'shimmer.dart';
// import 'package:screen_brightness/screen_brightness.dart';

class MenuDrawer extends ConsumerStatefulWidget {
  const MenuDrawer({super.key});

  @override
  ConsumerState<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends ConsumerState<MenuDrawer> {
  // double _brightnessValue = 1.0; //maximum brightness

  // void _setBrightness(double brightness) async {
  //   if (brightness >= 0.0 && brightness <= 1.0) {
  //     await ScreenBrightness().setScreenBrightness(brightness);
  //     setState(() {
  //       _brightnessValue = brightness;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final fontsize = ref.watch(fontSizesProvider);
    final width = MediaQuery.of(context).size.width;
    final user_loading = ref.watch(userControllerProvider);
    final user = ref.watch(userProvider)!;

    return Drawer(
      width: width * 0.93,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Material(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(
                    top: 24 + MediaQuery.of(context).padding.top,
                    bottom: 24,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundImage: user.profilePicture == ""
                            ? const AssetImage(
                                "assets/images/onboardin1.png",
                              )
                            : Image.network(
                                user.profilePicture,
                              ).image,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      user_loading
                          ? const TshimerEffect(width: 80, height: 15)
                          : Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(),
                            ),
                      user_loading
                          ? const TshimerEffect(width: 80, height: 15)
                          : Text(
                              user.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const MenuItems(),
          ],
        ),
      ),
    );
  }
}

class MenuItems extends ConsumerWidget {
  const MenuItems({super.key});

  void logOutPopup(FontSizes fontsize, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog(fontsize: fontsize);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontsize = ref.watch(fontSizesProvider);

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      )),
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle_rounded),
            title: const Text('My Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.mode_edit_sharp),
            title: const Text('Edit Profile'),
            onTap: () => Navigation.navigateToEditProfile(context),
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('About App'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('Information for People with Disability'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Logout'),
            onTap: () {
              logOutPopup(fontsize, context);
            },
          ),
        ],
      ),
    );
  }
}

class LogoutDialog extends ConsumerWidget {
  final FontSizes fontsize;

  const LogoutDialog({required this.fontsize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(18),
      title: Text(
        'Logout',
        style: TextStyle(
          fontSize: fontsize.subheadingSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        width: 200, // Set your desired width here
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to logout from your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontsize.fontSize,
              ),
            ),
            const SizedBox(
              height: 20,
            ), // Spacing between text and buttons
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).logOut();
                    Navigation.navigateToBack(context);
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    minimumSize: const Size(100, 40),
                    backgroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
