import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './custom_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final widgetList =
      List<Widget>.generate(60, (i) => Text((i).toString().padLeft(2, '0')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: 500.0,
            color: Theme.of(context).primaryColor,
            child: CustomPicker(
                useMagnifier: true,
                backgroundColor: null,
                // offAxisFraction: -1.0,
                magnification: 1.125,
                looping: true,
                itemExtent: 50.0,
                onSelectedItemChanged: (int state) {
                  print(state);
                },
                children: widgetList)));
  }

// CustomMultiChildLayout(
//               delegate: FollowTheLeader(),
//               children: widgetList,
//             )

// CustomScrollView(
//           anchor: 0.5,
//           scrollDirection: Axis.vertical,
//           slivers: <Widget>[
//             SliverToBoxAdapter(
//               child: Container(
//                 child: Text('apple'),
//               ),
//             ),
//             SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                     (context, index) => _buildTile(context, index),
//                     childCount: widgetList.length))
//           ],
//         ),
//   Widget _buildTile(BuildContext context, int index) {
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 40.0,
//         ),
//         Container(
//           color: Colors.amber,
//           padding: const EdgeInsets.all(10.0),
//           child: Text(
//             widgetList[index],
//             textScaleFactor: 2.0,
//           ),
//         ),
//       ],
//     );
//   }
}

// enum _Slot {
//   leader,
//   follower,
// }

// class FollowTheLeader extends MultiChildLayoutDelegate {
//   @override
//   void performLayout(Size size) {
//     Size leaderSize = Size.zero;

//     if (hasChild(_Slot.leader)) {
//       leaderSize = layoutChild(_Slot.leader, BoxConstraints.loose(size));
//       positionChild(_Slot.leader, Offset.zero);
//     }

//     if (hasChild(_Slot.follower)) {
//       layoutChild(_Slot.follower, BoxConstraints.tight(leaderSize));
//       positionChild(
//           _Slot.follower,
//           Offset(
//               size.width - leaderSize.width, size.height - leaderSize.height));
//     }
//   }

//   @override
//   bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
// }
