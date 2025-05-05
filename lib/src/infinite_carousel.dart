import 'package:flutter/material.dart';

import 'active_infinite_carousel_card.dart';
import 'inactive_infinite_carousel_card.dart';

class InfiniteCarouselItem {
  final Widget content;
  const InfiniteCarouselItem({required this.content});
}

class InfiniteCarousel extends StatefulWidget {
  const InfiniteCarousel({
    super.key,
    required this.items,
    this.cardWidth = 228,
    this.cardHeight = 347,
    this.inactiveScale = 0.9,
    this.activeCardBuilder,
    this.inactiveCardBuilder,
    this.physics = const BouncingScrollPhysics(),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOut,
  });

  final List<InfiniteCarouselItem> items;
  final double cardWidth;
  final double cardHeight;
  final double inactiveScale;

  /// Optional custom active card wrapper
  final Widget Function(Widget child)? activeCardBuilder;

  /// Optional custom inactive card wrapper
  final Widget Function(Widget child)? inactiveCardBuilder;

  /// The physics to use for scrolling. Defaults to `BouncingScrollPhysics`.
  final ScrollPhysics physics;

  /// The duration of the animation when snapping to a page.
  final Duration animationDuration;

  /// The curve of the animation when snapping to a page.
  final Curve animationCurve;

  @override
  State<InfiniteCarousel> createState() => _InfiniteCarouselState();
}

class _InfiniteCarouselState extends State<InfiniteCarousel> {
  static const int _multiplier = 1000;
  late final PageController _controller;
  double currentPage = 0.0;

  @override
  void initState() {
    final initialPage = widget.items.length * _multiplier ~/ 2;
    _controller = PageController(
      initialPage: initialPage,
      viewportFraction: 1.0,
    );
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page ?? currentPage;
      });
    });
    currentPage = initialPage.toDouble();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = widget.cardWidth;
    final cardHeight = widget.cardHeight;
    final inactiveScale = widget.inactiveScale;

    if (widget.items.isEmpty) {
      return SizedBox(height: cardHeight + 40);
    }

    final int currentNearestPage = currentPage.round();
    const int range = 1;
    final List<int> indicesToRender = [];
    for (int i = -range; i <= range; i++) {
      final pageIndex = currentNearestPage + i;
      if (pageIndex >= 0 && pageIndex < widget.items.length * _multiplier) {
        indicesToRender.add(pageIndex);
      }
    }

    indicesToRender.sort((a, b) {
      final aDelta = (a - currentPage).abs();
      final bDelta = (b - currentPage).abs();
      return bDelta.compareTo(aDelta);
    });

    return SizedBox(
      height: cardHeight + 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PageView.builder(
            controller: _controller,
            physics: widget.physics,
            itemCount: widget.items.length * _multiplier,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          ),
          for (final pageIndex in indicesToRender)
            _buildCard(
              pageIndex: pageIndex,
              screenWidth: screenWidth,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              inactiveScale: inactiveScale,
            ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required int pageIndex,
    required double screenWidth,
    required double cardWidth,
    required double cardHeight,
    required double inactiveScale,
  }) {
    final itemIndex =
        (pageIndex % widget.items.length + widget.items.length) %
        widget.items.length;
    final item = widget.items[itemIndex];

    final delta = pageIndex - currentPage;
    final isActive = delta.abs() < 0.5;
    final scale = isActive ? 1.0 : inactiveScale;
    final effectiveCardHeight = cardHeight * scale;
    final verticalOffset = (cardHeight - effectiveCardHeight) / 2;
    final overlapFactor = 60.0;
    final leftOffset =
        screenWidth / 2 -
        (cardWidth * scale) / 2 +
        (delta > 0
            ? delta * (cardWidth - overlapFactor)
            : delta * (cardWidth - overlapFactor * 1.6));

    final child = item.content;

    final cardWrapper =
        isActive
            ? (widget.activeCardBuilder?.call(child) ??
                ActiveInfiniteCarouselCard(child: child))
            : (widget.inactiveCardBuilder?.call(child) ??
                InactiveInfiniteCarouselCard(child: child));

    return Positioned(
      top: verticalOffset,
      left: leftOffset,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.center,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight * scale,
          child:
              isActive
                  ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanUpdate: (details) {
                      if (_controller.hasClients) {
                        _controller.position.moveTo(
                          _controller.position.pixels - details.delta.dx,
                          clamp: false,
                        );
                      }
                    },
                    onPanEnd: (_) {
                      if (_controller.hasClients) {
                        final nearestPage = _controller.page?.round() ?? 0;
                        _controller.animateToPage(
                          nearestPage,
                          duration: widget.animationDuration,
                          curve: widget.animationCurve,
                        );
                      }
                    },
                    child: cardWrapper,
                  )
                  : AbsorbPointer(absorbing: true, child: cardWrapper),
        ),
      ),
    );
  }
}
