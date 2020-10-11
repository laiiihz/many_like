import 'dart:math';

import 'package:flutter/material.dart';

typedef BuildAnimation = Function(
  BuildContext context,
  Widget child,
  AnimationController controller,
);

class AnimateLikeWidget extends StatefulWidget {
  ///The length of time this animation should last.
  final Duration duration;

  ///the Curve use in widget
  final Curve curve;

  ///the child widget
  final Widget child;

  ///call onDestory when animation done
  final VoidCallback onDestory;
  AnimateLikeWidget({
    Key key,
    this.duration = const Duration(milliseconds: 2000),
    this.child = const Icon(Icons.favorite, color: Colors.red),
    this.onDestory,
    this.curve = Curves.easeInOutCubic,
  }) : super(key: key);

  @override
  _AnimateLikeWidgetState createState() => _AnimateLikeWidgetState();
}

class _AnimateLikeWidgetState extends State<AnimateLikeWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Tween<Offset> _offsetTween;
  Animation<Offset> _offsetAnimation;
  double _randomSize = 0;

  @override
  void initState() {
    super.initState();
    _randomSize = Random().nextDouble();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _offsetTween = Tween<Offset>(
      begin: Offset.zero,
      end: offset,
    );
    _offsetAnimation = _offsetTween.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
    _animationController.forward().then((_) {
      widget.onDestory();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: _offsetAnimation.value,
            child: Transform.scale(
              scale: size,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }

  double get opacity {
    if (_animationController.value < 0.2) {
      return _animationController.value / 0.2;
    }
    if (_animationController.value > 0.8) {
      return (1 - _animationController.value) / 0.2;
    } else
      return 1;
  }

  Offset get offset {
    final direction = Random().nextBool() ? -1 : 1;
    double x = direction * Random().nextDouble() * 100;
    double y = -Random().nextDouble() * 500 - 100;
    return Offset(x, y);
  }

  double get size {
    return 1 + _animationController.value * _randomSize;
  }
}
