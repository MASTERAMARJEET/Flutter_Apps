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

const Color _kWheelBackground = Colors.blue,
    _kMarkerBackground = Colors.greenAccent;

const double _kSqueeze = 1.0, _kFontSize = 18.0;

class CustomPicker extends StatefulWidget {
  CustomPicker({
    Key key,
    this.backgroundColor = _kWheelBackground,
    this.markerColor = _kMarkerBackground,
    this.scrollController,
    this.squeeze = _kSqueeze,
    this.fontSize = _kFontSize,
    @required this.radius,
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
    this.backgroundColor = _kWheelBackground,
    this.markerColor = _kMarkerBackground,
    this.scrollController,
    this.squeeze = _kSqueeze,
    this.fontSize = _kFontSize,
    @required this.radius,
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

  final Color backgroundColor, markerColor;

  final FixedExtentScrollController scrollController;

  final double radius, itemExtent, squeeze, markerRadius, fontSize;

  final ValueChanged<int> onSelectedItemChanged;

  final MyListCircleChildDelegate childDelegate;

  @override
  State<StatefulWidget> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int _lastHapticIndex;
  FixedExtentScrollController _controller;
  double _markerPosition, _radius, _markerRadius;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _controller = FixedExtentScrollController();
    }
    _radius = widget.radius;
    _markerRadius = widget.markerRadius;
    _markerPosition = _calculateMarkerPosition(_radius, _markerRadius);
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
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleSelectedItemChanged(int index) {
    bool hasSuitableHapticHardware;
    hasSuitableHapticHardware =
        defaultTargetPlatform == TargetPlatform.iOS ? true : false;

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
    double position =
        (bigRadius - widget.itemExtent + widget.fontSize * 0.6) * sqrt1_2 -
            smallRadius;
    return position;
  }

  Widget _addBackgroundToChild(Widget child) {
    return Stack(
      children: <Widget>[
        Container(
          width: _radius,
          height: _radius,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(_radius)),
          ),
        ),
        Positioned(
          bottom: _markerPosition,
          right: _markerPosition,
          child: Container(
            width: _markerRadius * 2,
            height: _markerRadius * 2,
            decoration: BoxDecoration(
                color: widget.markerColor,
                borderRadius: BorderRadius.circular(widget.itemExtent)),
          ),
        ),
        Container(
          width: _radius,
          height: _radius,
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
                radius: _radius,
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
