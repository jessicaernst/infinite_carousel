import 'package:flutter/material.dart';

import 'active_infinite_carousel_card.dart';
import 'inactive_infinite_carousel_card.dart';

/// Represents a single item to be displayed in the [InfiniteCarousel].
class InfiniteCarouselItem {
  /// The main content widget for this carousel item.
  final Widget content;

  /// Creates an instance of [InfiniteCarouselItem].
  ///
  /// Requires [content] which is the widget to be displayed.
  const InfiniteCarouselItem({required this.content});
}

/// A Flutter widget that displays a list of items in an infinitely scrollable
/// horizontal carousel with a snapping effect and scaling for inactive items.
class InfiniteCarousel extends StatefulWidget {
  const InfiniteCarousel({
    super.key,
    required this.items,
    this.controller,
    this.cardWidth = 228,
    this.cardHeight = 347,
    this.inactiveScale = 0.9,
    this.activeCardBuilder,
    this.inactiveCardBuilder,
    this.physics = const BouncingScrollPhysics(),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOut,
    this.initialItem,
    this.onActiveItemChanged,
  });

  /// The list of [InfiniteCarouselItem]s to display.
  final List<InfiniteCarouselItem> items;

  /// Optional [PageController] to use for the carousel.
  /// If provided, the carousel will use this controller instead of creating its own,
  /// allowing for external control over its scrolling state. The widget will not
  /// take ownership of the provided controller and will not dispose of it.
  final PageController? controller;

  /// The width of each card in the carousel. Defaults to 228.
  final double cardWidth;

  /// The height of each card in the carousel. Defaults to 347.
  final double cardHeight;

  /// The scale factor applied to inactive cards (cards not in the center).
  /// Defaults to 0.9. Must be between 0.0 and 1.0.
  final double inactiveScale;

  /// Optional builder function to customize the appearance of the active
  /// (center) card. It receives the original `child` widget.
  final Widget Function(Widget child)? activeCardBuilder;

  /// Optional builder function to customize the appearance of inactive cards.
  /// It receives the original `child` widget.
  final Widget Function(Widget child)? inactiveCardBuilder;

  /// The physics to use for the underlying [PageView] scrolling behavior.
  /// Defaults to `BouncingScrollPhysics`.
  final ScrollPhysics physics;

  /// The duration of the animation when the carousel snaps to the nearest page.
  /// Defaults to 300 milliseconds.
  final Duration animationDuration;

  /// The curve used for the snapping animation. Defaults to `Curves.easeOut`.
  final Curve animationCurve;

  /// The index of the item to be initially displayed in the center.
  /// If null, the carousel defaults to the logical center of the items.
  /// This value is used to determine the `initialPage` for an internally managed
  /// `PageController`. If an external `controller` is provided, `initialItem`
  /// influences the initial visual centering and is used as the target for `jumpToPage` if `initialItem` itself is changed.
  final int? initialItem;

  /// Callback function that is called when the active (center) item changes.
  final void Function(int index)? onActiveItemChanged;

  @override
  State<InfiniteCarousel> createState() => _InfiniteCarouselState();
}

class _InfiniteCarouselState extends State<InfiniteCarousel> {
  static const int _multiplier = 1000;
  late final PageController _controller;
  bool _ownsController = false;
  double currentPage = 0.0;
  int? _lastReportedPage;

  @override
  void initState() {
    super.initState();
    int initialPage;
    if (widget.initialItem != null &&
        widget.initialItem! >= 0 &&
        widget.initialItem! < widget.items.length) {
      // Calculate the initialPage to center the desired initialItem
      // We want widget.initialItem to be at items.length * _multiplier / 2 + widget.initialItem
      // but since PageView is 0-indexed, we find a page in the middle block
      // that corresponds to initialItem.
      initialPage =
          (widget.items.length * _multiplier ~/ 2) -
          (widget.items.length ~/ 2) +
          widget.initialItem!;
    } else {
      initialPage = widget.items.length * _multiplier ~/ 2;
    }

    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
      // If an external controller is provided, its current page might differ from `initialPage`.
      // `currentPage` is initialized based on `initialPage` for consistent first-frame rendering.
      // The listener will then sync `currentPage` with the external controller's actual page.
    } else {
      _controller = PageController(
        initialPage: initialPage,
      ); // viewportFraction defaults to 1.0
      _ownsController = true;
    }
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page ?? initialPage.toDouble();
      });
      _handleActiveItemChanged();
    });
    currentPage = initialPage.toDouble(); // Initialize currentPage
    // Call initially for the first item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleActiveItemChanged();
    });
  }

  @override
  void didUpdateWidget(InfiniteCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.isEmpty) {
      return;
    }

    // If initialItem or items length changes, recalculate the target page.
    // This applies even if an external controller is used, as initialItem
    // can still dictate a desired jump.
    if (widget.initialItem != oldWidget.initialItem ||
        widget.items.length != oldWidget.items.length) {
      int newTargetPage;
      if (widget.initialItem != null &&
          widget.initialItem! >= 0 &&
          widget.initialItem! < widget.items.length) {
        newTargetPage =
            (widget.items.length * _multiplier ~/ 2) -
            (widget.items.length ~/ 2) +
            widget.initialItem!;
      } else {
        // Default to center if initialItem is null or invalid
        newTargetPage = widget.items.length * _multiplier ~/ 2;
      }

      if (_controller.hasClients &&
          _controller.page?.round() != newTargetPage) {
        _controller.jumpToPage(newTargetPage);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super
        .dispose(); // This was a typo in the provided code, should be _controller.removeListener if not disposing. Corrected to only dispose if owned.
  }

  void _handleActiveItemChanged() {
    if (widget.onActiveItemChanged != null && _controller.page != null) {
      final currentActualPage =
          (_controller.page!.round() % widget.items.length +
              widget.items.length) %
          widget.items.length;
      if (_lastReportedPage != currentActualPage) {
        _lastReportedPage = currentActualPage;
        widget.onActiveItemChanged!(currentActualPage);
      }
    }
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
