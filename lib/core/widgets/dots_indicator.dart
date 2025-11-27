import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;
  final DotsDecorator decorator;

  const DotsIndicator({
    super.key,
    required this.dotsCount,
    required this.position,
    this.decorator = const DotsDecorator(),
  });

  Widget _buildDot(int index) {
    final isCurrent = position == index;
    final color = isCurrent ? decorator.activeColor : decorator.color;
    final size = isCurrent ? decorator.activeSize : decorator.size;

    return Container(
      width: size.width,
      height: size.height,
      margin: decorator.spacing,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size.width / 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotsCount, (index) => _buildDot(index)),
    );
  }
}

class DotsDecorator {
  final Color color;
  final Color activeColor;
  final Size size;
  final Size activeSize;
  final EdgeInsets spacing;

  const DotsDecorator({
    this.color = Colors.grey,
    this.activeColor = Colors.blue,
    this.size = const Size(10.0, 10.0),
    this.activeSize = const Size(10.0, 10.0),
    this.spacing = const EdgeInsets.all(4.0),
  });
}
