import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/font_provider.dart';

class ErrorText extends ConsumerWidget {
  final String error;
  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontsize = ref.watch(fontSizesProvider);
    return Text(
      error,
      style: TextStyle(
          color: Colors.red,
          fontSize: fontsize.headingSize,
          fontWeight: FontWeight.bold),
    );
  }
}
