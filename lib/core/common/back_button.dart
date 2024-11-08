import 'package:flutter/material.dart';

import '../../routes/route_utils.dart';

class BackPageButton extends StatelessWidget {
  const BackPageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        size: 40,
      ),
      onPressed: () {
        Navigation.navigateToBack(context);
      },
    );
  }
}
