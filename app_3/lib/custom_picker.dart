import 'dart:math' show sqrt1_2;

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter/rendering.dart'
    show RenderProxyBox, SemanticsConfiguration, SemanticsNode;
import 'package:flutter/widgets.dart'
    hide
        FixedExtentScrollController,
        FixedExtentMetrics,
        FixedExtentScrollPhysics;
import 'package:flutter/material.dart' show Colors;

import './list_circle_scroll_view.dart';
import './list_circle_viewport.dart' show MyRenderListCircleViewport;

const Color _kDefaultBackground = Color(0xFFD2D4DB);

const double _kSqueeze = 1.0;

class CustomPicker extends StatefulWidget {
  CustomPicker({
    Key key,
    @required this.radius,
    this.backgroundColor = _kDefaultBackground,
    this.scrollController,
    this.squeeze = _kSqueeze,
    @required this.markerRadius,
    @required this.itemExtent,
    @required this.onSelectedItemChanged,
    @required List<Widget> children,
    bool looping = false,
  })  : assert(children != null),
        assert(radius != null),
        assert(radius > 0.0, MyRenderListCircleViewport.radiusZeroMessage),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        assert(markerRadius != null),
        assert(markerRadius > 0),
        childDelegate = looping
            ? MyListCircleChildLoopingListDelegate(children: children)
            : MyListCircleChildListDelegate(children: children),
        super(key: key);

  CustomPicker.builder({
    Key key,
    @required this.radius,
    this.backgroundColor = _kDefaultBackground,
    this.scrollController,
    this.squeeze = _kSqueeze,
    @required this.markerRadius,
    @required this.itemExtent,
    @required this.onSelectedItemChanged,
    @required IndexedWidgetBuilder itemBuilder,
    int childCount,
  })  : assert(itemBuilder != null),
        assert(radius != null),
        assert(radius > 0.0, MyRenderListCircleViewport.radiusZeroMessage),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        assert(markerRadius != null),
        assert(markerRadius > 0),
        childDelegate = MyListCircleChildBuilderDelegate(
            builder: itemBuilder, childCount: childCount),
        super(key: key);

  final double radius;

  final Color backgroundColor;

  final FixedExtentScrollController scrollController;

  final double itemExtent;

  final double squeeze;

  final double markerRadius;

  final ValueChanged<int> onSelectedItemChanged;

  final MyListCircleChildDelegate childDelegate;

  @override
  State<StatefulWidget> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int _lastHapticIndex;
  FixedExtentScrollController _controller;
  double _markerPosition;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _controller = FixedExtentScrollController();
    }
  }

  @override
  void didUpdateWidget(CustomPicker oldWidget) {
    if (widget.scrollController != null && oldWidget.scrollController == null) {
      _controller = null;
    } else if (widget.scrollController == null &&
        oldWidget.scrollController != null) {
      assert(_controller == null);
      _controller = FixedExtentScrollController();
    }
    _markerPosition =
        _calculateMarkerPosition(widget.radius, widget.markerRadius);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleSelectedItemChanged(int index) {
    bool hasSuitableHapticHardware;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        hasSuitableHapticHardware = true;
        break;
      case TargetPlatform.windows:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        hasSuitableHapticHardware = false;
        break;
    }
    assert(hasSuitableHapticHardware != null);
    if (hasSuitableHapticHardware && index != _lastHapticIndex) {
      _lastHapticIndex = index;
      HapticFeedback.selectionClick();
    }

    if (widget.onSelectedItemChanged != null) {
      widget.onSelectedItemChanged(index);
    }
  }

  double _calculateMarkerPosition(double bigRadius, double smallRadius) {
    /// 9 is in the formula because of the font size of the number. 1.25 is factor.
    double position =
        (bigRadius - widget.itemExtent + 9 * 1.25) * sqrt1_2 - smallRadius;
    return position;
  }

  Widget _addBackgroundToChild(Widget child) {
    return Stack(
      children: <Widget>[
        Container(
          child: Placeholder(),
          width: widget.radius,
          height: widget.radius,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(widget.radius)),
          ),
        ),
        Positioned(
          bottom: _markerPosition,
          right: _markerPosition,
          child: Container(
            child: Placeholder(),
            width: widget.markerRadius * 2,
            height: widget.markerRadius * 2,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(widget.itemExtent)),
          ),
        ),
        Container(
          width: widget.radius,
          height: widget.radius,
          child: child,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = DefaultTextStyle(
      style: TextStyle(color: Colors.black, fontSize: 18.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: _CustomPickerSemantics(
              scrollController: widget.scrollController ?? _controller,
              child: MyListCircleScrollView.useDelegate(
                controller: widget.scrollController ?? _controller,
                physics: const FixedExtentScrollPhysics(),
                radius: widget.radius,
                itemExtent: widget.itemExtent,
                squeeze: widget.squeeze,
                onSelectedItemChanged: _handleSelectedItemChanged,
                childDelegate: widget.childDelegate,
              ),
            ),
          ),
        ],
      ),
    );

    result = _addBackgroundToChild(result);
    return result;
  }
}

class _CustomPickerSemantics extends SingleChildRenderObjectWidget {
  const _CustomPickerSemantics({
    Key key,
    Widget child,
    @required this.scrollController,
  }) : super(key: key, child: child);

  final FixedExtentScrollController scrollController;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderCustomPickerSemantics(
          scrollController, Directionality.of(context));

  @override
  void updateRenderObject(BuildContext context,
      covariant _RenderCustomPickerSemantics renderObject) {
    renderObject
      ..textDirection = Directionality.of(context)
      ..controller = scrollController;
  }
}

class _RenderCustomPickerSemantics extends RenderProxyBox {
  _RenderCustomPickerSemantics(
      FixedExtentScrollController controller, this._textDirection) {
    this.controller = controller;
  }

  FixedExtentScrollController get controller => _controller;
  FixedExtentScrollController _controller;
  set controller(FixedExtentScrollController value) {
    if (value == _controller) return;
    if (_controller != null)
      _controller.removeListener(_handleScrollUpdate);
    else
      _currentIndex = value.initialItem ?? 0;
    value.addListener(_handleScrollUpdate);
    _controller = value;
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (textDirection == value) return;
    _textDirection = value;
    markNeedsSemanticsUpdate();
  }

  int _currentIndex = 0;

  void _handleIncrease() {
    controller.jumpToItem(_currentIndex + 1);
  }

  void _handleDecrease() {
    if (_currentIndex == 0) return;
    controller.jumpToItem(_currentIndex - 1);
  }

  void _handleScrollUpdate() {
    if (controller.selectedItem == _currentIndex) return;
    _currentIndex = controller.selectedItem;
    markNeedsSemanticsUpdate();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    config.textDirection = textDirection;
  }

  @override
  void assembleSemanticsNode(SemanticsNode node, SemanticsConfiguration config,
      Iterable<SemanticsNode> children) {
    if (children.isEmpty)
      return super.assembleSemanticsNode(node, config, children);
    final SemanticsNode scrollable = children.first;
    final Map<int, SemanticsNode> indexedChildren = <int, SemanticsNode>{};
    scrollable.visitChildren((SemanticsNode child) {
      assert(child.indexInParent != null);
      indexedChildren[child.indexInParent] = child;
      return true;
    });
    if (indexedChildren[_currentIndex] == null) {
      return node.updateWith(config: config);
    }
    config.value = indexedChildren[_currentIndex].label;
    final SemanticsNode previousChild = indexedChildren[_currentIndex - 1];
    final SemanticsNode nextChild = indexedChildren[_currentIndex + 1];
    if (nextChild != null) {
      config.increasedValue = nextChild.label;
      config.onIncrease = _handleIncrease;
    }
    if (previousChild != null) {
      config.decreasedValue = previousChild.label;
      config.onDecrease = _handleDecrease;
    }
    node.updateWith(config: config);
  }
}
