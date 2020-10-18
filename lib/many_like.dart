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
  ///子组件 默认为Material红色爱心
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

  ///弹出爱心组件
  ///the pop child
  final Widget popChild;

  ///动效显示时长
  ///
  ///The length of time this animation should last.
  final Duration duration;

  ///长按按钮 每个爱心发射的时间间隔
  ///
  ///The length of time that user on long press at the button,
  ///too small value may cause performance issue,
  ///bese value is more than 300 millsecond
  final Duration longTapDuration;

  ///the Curve use in widget
  final Curve curve;

  ///长按按钮回调
  ///
  /// long press callback
  final PulseCallback onLongPress;

  ///长按时按钮 爱心发射回调次数
  ///
  /// every `tickCount` call the onLongPress
  final int tickCount;

  ///只在第一次响应按钮点击
  ///
  /// tap only work first time
  final bool tapCallbackOnlyOnce;

  ///按钮点击回调
  ///
  /// on tap button
  final PulseCallback onTap;

  ///按钮点击延迟
  ///
  ///tap delay
  final Duration tapDelay;

  ///每次点击额外的爱心
  final int extraLikeCount;

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
    this.tapCallbackOnlyOnce = true,
    this.onTap,
    this.tapDelay = const Duration(milliseconds: 2000),
    this.extraLikeCount = 0,
  }) : super(key: key);

  @override
  _ManyLikeButtonState createState() => _ManyLikeButtonState();
}

class _ManyLikeButtonState extends State<ManyLikeButton> {
  List<int> likeWidgets = [];
  Timer timer;
  bool callbackOnlyOnce = false;
  Timer tapTimer;
  int singleTap = 0;

  @override
  void dispose() {
    timer?.cancel();
    tapTimer?.cancel();
    super.dispose();
  }

  giveAShot(int shot) {
    if (shot > 0)
      Future.delayed(widget.longTapDuration, () {
        if (mounted)
          setState(() {
            likeWidgets.add(DateTime.now().millisecond);
          });
      }).then((_) {
        giveAShot(shot - 1);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            singleTap++;
            if (widget.tapCallbackOnlyOnce) {
              if (!callbackOnlyOnce && widget.onTap != null) widget.onTap(1);
              callbackOnlyOnce = true;
            } else {
              tapTimer?.cancel();
              tapTimer = Timer(widget.tapDelay, () {
               if(widget.onTap != null) widget.onTap(singleTap);
                singleTap = 0;
              });
            }
            giveAShot(widget.extraLikeCount);
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
            timer?.cancel();
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
