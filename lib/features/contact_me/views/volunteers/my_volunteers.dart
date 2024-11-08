import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/error_text.dart';
import '../../../../core/common/loader.dart';
import '../../../../theme/font_provider.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/contect_me_controller.dart';

class MyVolunteersView extends ConsumerStatefulWidget {
  const MyVolunteersView({super.key});

  @override
  ConsumerState<MyVolunteersView> createState() => _MyVolunteersViewState();
}

class _MyVolunteersViewState extends ConsumerState<MyVolunteersView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final fontsize = ref.watch(fontSizesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Volunteers',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: fontsize.headingSize,
              ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ref.watch(userVolunteersProvider).when(
                data: (appointment) => Expanded(
                    child: ListView.builder(
                      itemCount: appointment.length,
                      itemBuilder: (BuildContext context, int index) {
                        final document = appointment[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/onboardin1.png'),
                            radius: 24,
                          ),
                          title: Text(
                            document.reason,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  fontSize: fontsize.subheadingSize + 2,
                                ),
                          ),
                          trailing: Text(
                            document.isAccepted ? "Accepted" : "Padding",
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: fontsize.fontSize,
                                    ),
                          ),
                          subtitle: Text(
                            DateFormat('yyyy-MM-dd').format(
                              document.appointmentTime.toDate(),
                            ),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: fontsize.fontSize - 4),
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                  error: (error, stackTrace) {
                    print(error);
                    return ErrorText(
                      error: error.toString(),
                    );
                  },
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
    );
  }
}
