import 'package:flutter/material.dart';

class UpDownAnimation extends StatefulWidget {
  final Widget child;
  final double? y;
  final bool? reverse;
  final double delay;

  const UpDownAnimation({
    super.key,
    required this.child,
    this.reverse,
    this.delay = 0.0,
    this.y,
  });

  @override
  UpDownAnimationState createState() => UpDownAnimationState();
}

class UpDownAnimationState extends State<UpDownAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> translateAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    translateAnimation = Tween<Offset>(
      begin: widget.reverse ?? false
          ? Offset(0, widget.y ?? 1)
          : Offset(0, widget.y ?? -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ),
    );
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()))
        .then((value) {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: translateAnimation,
        child: widget.child,
      ),
    );
  }
}
