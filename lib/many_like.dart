library many_like;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:many_like/animate_like_widget.dart';
export 'animate_like_widget.dart';

///long press callback Function
typedef PulseCallback = Function(int count);

///Many Like Button
class ManyLikeButton extends StatefulWidget {
  ///child
  ///
  ///default like button child is a material favorite icon with red color
  ///
  ///```
  ///const Icon(
  ///  Icons.favorite,
  ///  color: Colors.red,
  ///)
  ///```
  final Widget child;

  ///the pop child
  final Widget popChild;

  ///The length of time this animation should last.
  final Duration duration;

  ///The length of time that user on long press at the button,
  ///too small value may cause performance issue,
  ///bese value is more than 300 millsecond
  final Duration longTapDuration;

  ///the Curve use in widget
  final Curve curve;

  /// long press callback
  final PulseCallback onLongPress;

  /// every `tickCount` call the onLongPress
  final int tickCount;

  ManyLikeButton({
    Key key,
    this.child = const Icon(
      Icons.favorite,
      color: Colors.red,
    ),
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeInOutCubic,
    this.longTapDuration = const Duration(milliseconds: 250),
    this.onLongPress,
    this.tickCount = 20,
    this.popChild = const Icon(
      Icons.favorite,
      color: Colors.red,
    ),
  }) : super(key: key);

  @override
  _ManyLikeButtonState createState() => _ManyLikeButtonState();
}

class _ManyLikeButtonState extends State<ManyLikeButton> {
  List<int> likeWidgets = [];
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              likeWidgets.add(DateTime.now().millisecond);
            });
          },
          child: widget.child,
          onLongPressStart: (detail) {
            timer = Timer.periodic(widget.longTapDuration, (timer) {
              setState(() {
                likeWidgets.add(DateTime.now().millisecond);
              });
              if (timer.tick % widget.tickCount == 0 &&
                  widget.onLongPress != null)
                widget.onLongPress(widget.tickCount);
            });
          },
          onLongPressEnd: (detail) {
            timer.cancel();
          },
        )
      ]..addAll(likeWidgets.map((e) {
          return AnimateLikeWidget(
            duration: widget.duration,
            curve: widget.curve,
            key: ValueKey(e),
            child: widget.popChild,
            onDestory: () {
              setState(() {
                likeWidgets.remove(e);
              });
            },
          );
        })),
    );
  }
}
