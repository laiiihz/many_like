import 'package:flutter/material.dart';
import 'package:many_like/many_like.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 100,
          alignment: Alignment.topCenter,
          child: ManyLikeButton(
            onLongPress: (count) {
              print(count);
            },
            child: Icon(
              Icons.linked_camera,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
