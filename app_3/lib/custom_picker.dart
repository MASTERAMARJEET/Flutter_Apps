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

const Color _kHighlighterBorder = Color(0xFF5F5F5F);
const Color _kDefaultBackground = Color(0xFFD2D4DB);

const double _kDefaultPerspective = 0.003;
const double _kSqueeze = 1.45;

const double _kForegroundScreenOpacityFraction = 0.7;

class CustomPicker extends StatefulWidget {
  CustomPicker({
    Key key,
    @required this.radius,
    this.backgroundColor = _kDefaultBackground,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = _kSqueeze,
    @required this.itemExtent,
    @required this.onSelectedItemChanged,
    @required List<Widget> children,
    bool looping = false,
  })  : assert(children != null),
        assert(radius != null),
        assert(radius > 0.0, MyRenderListCircleViewport.radiusZeroMessage),
        assert(magnification > 0),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        childDelegate = looping
            ? MyListCircleChildLoopingListDelegate(children: children)
            : MyListCircleChildListDelegate(children: children),
        super(key: key);

  CustomPicker.builder({
    Key key,
    @required this.radius,
    this.backgroundColor = _kDefaultBackground,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = _kSqueeze,
    @required this.itemExtent,
    @required this.onSelectedItemChanged,
    @required IndexedWidgetBuilder itemBuilder,
    int childCount,
  })  : assert(itemBuilder != null),
        assert(radius != null),
        assert(radius > 0.0, MyRenderListCircleViewport.radiusZeroMessage),
        assert(magnification > 0),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(squeeze != null),
        assert(squeeze > 0),
        childDelegate = MyListCircleChildBuilderDelegate(
            builder: itemBuilder, childCount: childCount),
        super(key: key);

  final double radius;

  final Color backgroundColor;

  final double offAxisFraction;

  final bool useMagnifier;

  final double magnification;

  final FixedExtentScrollController scrollController;

  final double itemExtent;

  final double squeeze;

  final ValueChanged<int> onSelectedItemChanged;

  final MyListCircleChildDelegate childDelegate;

  @override
  State<StatefulWidget> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int _lastHapticIndex;
  FixedExtentScrollController _controller;

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
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
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

  Widget _buildMagnifierScreen() {
    final Color foreground = widget.backgroundColor?.withAlpha(
        (widget.backgroundColor.alpha * _kForegroundScreenOpacityFraction)
            .toInt());

    return IgnorePointer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: foreground,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.0, color: _kHighlighterBorder),
                bottom: BorderSide(width: 0.0, color: _kHighlighterBorder),
              ),
            ),
            constraints: BoxConstraints.expand(
              height: widget.itemExtent * widget.magnification,
            ),
          ),
          Expanded(
            child: Container(
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderMagnifierScreen() {
    final Color foreground = widget.backgroundColor?.withAlpha(
        (widget.backgroundColor.alpha * _kForegroundScreenOpacityFraction)
            .toInt());

    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        Container(
          color: foreground,
          constraints: BoxConstraints.expand(
            height: widget.itemExtent * widget.magnification,
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  Widget _addBackgroundToChild(Widget child) {
    return Container(
      width: widget.radius,
      height: widget.radius * 2.0,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius:
            BorderRadius.horizontal(left: Radius.circular(widget.radius * 2)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = DefaultTextStyle(
      style: TextStyle(color: Colors.black),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: _CustomPickerSemantics(
              scrollController: widget.scrollController ?? _controller,
              child: MyListCircleScrollView.useDelegate(
                controller: widget.scrollController ?? _controller,
                physics: const FixedExtentScrollPhysics(),
                radius: widget.radius,
                perspective: _kDefaultPerspective,
                offAxisFraction: widget.offAxisFraction,
                useMagnifier: widget.useMagnifier,
                magnification: widget.magnification,
                itemExtent: widget.itemExtent,
                squeeze: widget.squeeze,
                onSelectedItemChanged: _handleSelectedItemChanged,
                childDelegate: widget.childDelegate,
              ),
            ),
          ),
          _buildMagnifierScreen(),
        ],
      ),
    );

    if (widget.backgroundColor != null && widget.backgroundColor.alpha < 255) {
      result = Stack(
        children: <Widget>[
          _buildUnderMagnifierScreen(),
          _addBackgroundToChild(result),
        ],
      );
    } else {
      result = _addBackgroundToChild(result);
    }
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
