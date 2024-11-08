import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/font_provider.dart';
import '../../../theme/theme_provider.dart';
import '../../user/controller/user_controller.dart';

class Bubble extends ConsumerWidget {
  final bool isMe;
  final String message;
  final String sender;

  const Bubble(
      {required this.message, required this.isMe, required this.sender});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = provider.Provider.of<ThemeProvider>(context).isDark;
    final fontsize = ref.watch(fontSizesProvider);

    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return ref.watch(getUserDataByIdProvider(sender)).when(
            data: (user) {
              return ClipPath(
                clipper: isMe
                    ? LowerNipMessageClipper(
                        MessageType.send,
                        sizeOfNip: 4,
                        sizeRatio: 4,
                        bubbleRadius: 0,
                      )
                    : LowerNipMessageClipper(
                        MessageType.receive,
                        sizeOfNip: 4,
                        sizeRatio: 4,
                        bubbleRadius: 0,
                      ),
                child: Container(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  padding: isMe
                      ? const EdgeInsets.only(left: 60)
                      : const EdgeInsets.only(right: 60),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isMe
                          ? isDarkTheme
                              ? Dbrown1
                              : Lpurple3
                          : isDarkTheme
                              ? Dbrown1
                              : Lcream,
                      borderRadius: isMe
                          ? const BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : const BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                    ),
                    child: !isMe
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      user.profilePicture,
                                    ),
                                    radius: 14,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(user.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize:
                                                  fontsize.subheadingSize)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 35,
                                ),
                                child: Text(
                                  message,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: fontsize.fontSize,
                                      ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                              bottom: 2,
                            ),
                            child: Text(
                              message,
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: fontsize.fontSize,
                                  ),
                            ),
                          ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    });
  }
}
