import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';

class dividerGradient extends StatelessWidget {
  const dividerGradient({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
                height: 8, decoration: const BoxDecoration(gradient: gradient)))
      ],
    );
  }
}
