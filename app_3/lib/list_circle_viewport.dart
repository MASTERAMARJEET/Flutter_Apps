import 'dart:math' as math;
import 'dart:ui' show Offset, Rect;

import 'package:vector_math/vector_math_64.dart' show Matrix4;
import 'package:flutter/painting.dart' show MatrixUtils, Alignment;
import 'package:flutter/material.dart' show required;
import 'package:flutter/animation.dart' show Curve, Curves;
import 'package:flutter/rendering.dart'
    show
        RenderBox,
        RenderObject,
        RenderAbstractViewport,
        ContainerBoxParentData,
        ContainerRenderObjectMixin,
        ViewportOffset,
        BoxConstraints,
        PaintingContext,
        BoxHitTestResult,
        RevealedOffset,
        PipelineOwner;

typedef _MyChildSizingFunction = double Function(RenderBox child);

abstract class MyListCircleChildManager {
  int get childCount;
  bool childExistsAt(int index);
  void createChild(int index, {@required RenderBox after});
  void removeChild(RenderBox child);
}

class MyListCircleParentData extends ContainerBoxParentData<RenderBox> {
  int index;
}

class MyRenderListCircleViewport extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, MyListCircleParentData>
    implements RenderAbstractViewport {
  MyRenderListCircleViewport({
    @required this.childManager,
    @required ViewportOffset offset,
    @required double radius,
    @required double itemExtent,
    double squeeze = 1,
    List<RenderBox> children,
  })  : assert(childManager != null),
        assert(offset != null),
        assert(radius != null),
        assert(radius > 0, radiusZeroMessage),
        assert(itemExtent != null),
        assert(squeeze != null),
        assert(squeeze > 0),
        assert(itemExtent > 0),
        _offset = offset,
        _radius = radius,
        _itemExtent = itemExtent,
        _squeeze = squeeze;

  static const String radiusZeroMessage = "You can't set a radius "
      'of 0 or of a negative number. It would imply a circle of 0 in radius '
      'in which case nothing will be drawn.';

  final MyListCircleChildManager childManager;

  ViewportOffset get offset => _offset;
  ViewportOffset _offset;
  set offset(ViewportOffset value) {
    assert(value != null);
    if (value == _offset) return;
    if (attached) _offset.removeListener(_hasScrolled);
    _offset = value;
    if (attached) _offset.addListener(_hasScrolled);
    markNeedsLayout();
  }

  double get radius => _radius;
  double _radius;
  set radius(double value) {
    assert(value != null);
    assert(
      value > 0,
      radiusZeroMessage,
    );
    if (value == _radius) return;
    _radius = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  double get itemExtent => _itemExtent;
  double _itemExtent;
  set itemExtent(double value) {
    assert(value != null);
    assert(value > 0);
    if (value == _itemExtent) return;
    _itemExtent = value;
    markNeedsLayout();
  }

  double get squeeze => _squeeze;
  double _squeeze;
  set squeeze(double value) {
    assert(value != null);
    assert(value > 0);
    if (value == _squeeze) return;
    _squeeze = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  void _hasScrolled() {
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MyListCircleParentData)
      child.parentData = MyListCircleParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _offset.addListener(_hasScrolled);
  }

  @override
  void detach() {
    _offset.removeListener(_hasScrolled);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  double get _viewportExtent {
    assert(hasSize);
    return size.height;
  }

  double get _minEstimatedScrollExtent {
    assert(hasSize);
    if (childManager.childCount == null) return double.negativeInfinity;
    return 0.0;
  }

  double get _maxEstimatedScrollExtent {
    assert(hasSize);
    if (childManager.childCount == null) return double.infinity;

    return math.max(0.0, (childManager.childCount - 1) * _itemExtent);
  }

  double get _topScrollMarginExtent {
    assert(hasSize);
    return -size.height / 2.0 + _itemExtent / 2.0;
  }

  double _getUntransformedPaintingCoordinateY(double layoutCoordinateY) {
    return layoutCoordinateY - _topScrollMarginExtent - offset.pixels;
  }

  double get _maxVisibleRadian {
    return math.pi / 4.0;
  }

  double _getIntrinsicCrossAxis(_MyChildSizingFunction childSize) {
    double extent = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      extent = math.max(extent, childSize(child));
      child = childAfter(child);
    }
    return extent;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _getIntrinsicCrossAxis(
        (RenderBox child) => child.getMinIntrinsicWidth(height));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _getIntrinsicCrossAxis(
        (RenderBox child) => child.getMaxIntrinsicWidth(height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (childManager.childCount == null) return 0.0;
    return childManager.childCount * _itemExtent;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (childManager.childCount == null) return 0.0;
    return childManager.childCount * _itemExtent;
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  int indexOf(RenderBox child) {
    assert(child != null);
    final MyListCircleParentData childParentData = child.parentData;
    assert(childParentData.index != null);
    return childParentData.index;
  }

  int scrollOffsetToIndex(double scrollOffset) =>
      (scrollOffset / itemExtent).floor();

  double indexToScrollOffset(int index) => index * itemExtent;

  void _createChild(int index, {RenderBox after}) {
    invokeLayoutCallback<BoxConstraints>((BoxConstraints constraints) {
      assert(constraints == this.constraints);
      childManager.createChild(index, after: after);
    });
  }

  void _destroyChild(RenderBox child) {
    invokeLayoutCallback<BoxConstraints>((BoxConstraints constraints) {
      assert(constraints == this.constraints);
      childManager.removeChild(child);
    });
  }

  void _layoutChild(RenderBox child, BoxConstraints constraints, int index) {
    child.layout(constraints, parentUsesSize: true);
    final MyListCircleParentData childParentData = child.parentData;
    final double crossPosition = size.width / 2.0 - child.size.width / 2.0;
    childParentData.offset = Offset(crossPosition, indexToScrollOffset(index));
  }

  @override
  void performLayout() {
    final BoxConstraints childConstraints = constraints.copyWith(
      minHeight: _itemExtent,
      maxHeight: _itemExtent,
      minWidth: 0.0,
    );

    double visibleHeight = size.height * _squeeze;

    final double firstVisibleOffset =
        offset.pixels + _itemExtent / 2 - visibleHeight / 2;
    final double lastVisibleOffset = firstVisibleOffset + visibleHeight;

    int targetFirstIndex = scrollOffsetToIndex(firstVisibleOffset);
    int targetLastIndex = scrollOffsetToIndex(lastVisibleOffset);

    if (targetLastIndex * _itemExtent == lastVisibleOffset) targetLastIndex--;

    while (!childManager.childExistsAt(targetFirstIndex) &&
        targetFirstIndex <= targetLastIndex) targetFirstIndex++;
    while (!childManager.childExistsAt(targetLastIndex) &&
        targetFirstIndex <= targetLastIndex) targetLastIndex--;

    if (targetFirstIndex > targetLastIndex) {
      while (firstChild != null) _destroyChild(firstChild);
      return;
    }

    if (childCount > 0 &&
        (indexOf(firstChild) > targetLastIndex ||
            indexOf(lastChild) < targetFirstIndex)) {
      while (firstChild != null) _destroyChild(firstChild);
    }

    if (childCount == 0) {
      _createChild(targetFirstIndex);
      _layoutChild(firstChild, childConstraints, targetFirstIndex);
    }

    int currentFirstIndex = indexOf(firstChild);
    int currentLastIndex = indexOf(lastChild);

    while (currentFirstIndex < targetFirstIndex) {
      _destroyChild(firstChild);
      currentFirstIndex++;
    }
    while (currentLastIndex > targetLastIndex) {
      _destroyChild(lastChild);
      currentLastIndex--;
    }

    RenderBox child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      child = childAfter(child);
    }

    while (currentFirstIndex > targetFirstIndex) {
      _createChild(currentFirstIndex - 1);
      _layoutChild(firstChild, childConstraints, --currentFirstIndex);
    }
    while (currentLastIndex < targetLastIndex) {
      _createChild(currentLastIndex + 1, after: lastChild);
      _layoutChild(lastChild, childConstraints, ++currentLastIndex);
    }

    offset.applyViewportDimension(_viewportExtent);

    final double minScrollExtent =
        childManager.childExistsAt(targetFirstIndex - 1)
            ? _minEstimatedScrollExtent
            : indexToScrollOffset(targetFirstIndex);
    final double maxScrollExtent =
        childManager.childExistsAt(targetLastIndex + 1)
            ? _maxEstimatedScrollExtent
            : indexToScrollOffset(targetLastIndex);
    offset.applyContentDimensions(minScrollExtent, maxScrollExtent);
  }

  bool _shouldClipAtCurrentOffset() {
    final double highestUntransformedPaintY =
        _getUntransformedPaintingCoordinateY(0.0);
    return highestUntransformedPaintY < 0.0 ||
        size.height <
            highestUntransformedPaintY +
                _maxEstimatedScrollExtent +
                _itemExtent;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (childCount > 0) {
      if (_shouldClipAtCurrentOffset()) {
        context.pushClipRect(
          needsCompositing,
          offset,
          Offset.zero & size,
          _paintVisibleChildren,
        );
      } else {
        _paintVisibleChildren(context, offset);
      }
    }
  }

  void _paintVisibleChildren(PaintingContext context, Offset offset) {
    RenderBox childToPaint = firstChild;
    MyListCircleParentData childParentData = childToPaint?.parentData;

    while (childParentData != null) {
      _paintTransformedChild(
          childToPaint, context, offset, childParentData.offset);
      childToPaint = childAfter(childToPaint);
      childParentData = childToPaint?.parentData;
    }
  }

  void _paintTransformedChild(
    RenderBox child,
    PaintingContext context,
    Offset offset,
    Offset layoutOffset,
  ) {
    final Offset untransformedPaintingCoordinates = offset +
        Offset(
          layoutOffset.dx,
          _getUntransformedPaintingCoordinateY(layoutOffset.dy),
        );

    final double fractionalY =
        (untransformedPaintingCoordinates.dy + _itemExtent / 2.0) / size.height;
    final double angle =
        -(fractionalY - 0.5) * 2.0 * _maxVisibleRadian / squeeze;

    if (angle > math.pi / 2.0 || angle < -math.pi / 2.0) return;

    Matrix4 transform = Matrix4.identity()
      ..rotateZ(math.pi * 0.75)
      ..setTranslationRaw((_radius + _itemExtent * 0.675) * (0.5),
          (_radius + _itemExtent * 0.675) * (0.5), 0.0);

    transform *= (Matrix4.rotationZ(angle)) *
        Matrix4.translationValues(0.0, _radius, 0.0);

    final Offset offsetToCenter =
        Offset(untransformedPaintingCoordinates.dx, -_topScrollMarginExtent);

    final Matrix4 result = Matrix4.identity();
    final Offset centerOriginTranslation = Alignment.center.alongSize(size);
    result.translate(centerOriginTranslation.dx, centerOriginTranslation.dy);
    result.multiply(transform);
    result.translate(-centerOriginTranslation.dx, -centerOriginTranslation.dy);

    context.pushTransform(false, offset, result,
        (PaintingContext context, Offset offset) {
      context.paintChild(
        child,
        offset + offsetToCenter,
      );
    });
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final MyListCircleParentData parentData = child?.parentData;
    transform.translate(
        0.0, _getUntransformedPaintingCoordinateY(parentData.offset.dy));
  }

  @override
  Rect describeApproximatePaintClip(RenderObject child) {
    if (child != null && _shouldClipAtCurrentOffset()) {
      return Offset.zero & size;
    }
    return null;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) => false;

  @override
  RevealedOffset getOffsetToReveal(RenderObject target, double alignment,
      {Rect rect}) {
    rect ??= target.paintBounds;

    RenderObject child = target;
    while (child.parent != this) child = child.parent;

    final MyListCircleParentData parentData = child.parentData;
    final double targetOffset =
        parentData.offset.dy; // the so-called "centerPosition"

    final Matrix4 transform = target.getTransformTo(child);
    final Rect bounds = MatrixUtils.transformRect(transform, rect);
    final Rect targetRect =
        bounds.translate(0.0, (size.height - itemExtent) / 2);

    return RevealedOffset(offset: targetOffset, rect: targetRect);
  }

  @override
  void showOnScreen({
    RenderObject descendant,
    Rect rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    if (descendant != null) {
      final RevealedOffset revealedOffset =
          getOffsetToReveal(descendant, 0.5, rect: rect);
      if (duration == Duration.zero) {
        offset.jumpTo(revealedOffset.offset);
      } else {
        offset.animateTo(revealedOffset.offset,
            duration: duration, curve: curve);
      }
      rect = revealedOffset.rect;
    }

    super.showOnScreen(
      rect: rect,
      duration: duration,
      curve: curve,
    );
  }
}
