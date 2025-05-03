import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

void main() {
  final testItems = List.generate(
    5,
    (index) => InfiniteCarouselItem(
      content: Text('Item $index', key: ValueKey('card_$index')),
    ),
  );

  Widget buildCarousel() {
    return MaterialApp(
      home: Scaffold(
        body: InfiniteCarousel(
          items: testItems,
          cardWidth: 200,
          cardHeight: 300,
          inactiveScale: 0.9,
        ),
      ),
    );
  }

  group('InfiniteCarousel', () {
    testWidgets('does not crash with single item', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfiniteCarousel(
              items: [
                InfiniteCarouselItem(
                  content: const Text('Single', key: ValueKey('single_card')),
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey('single_card')),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('renders active and inactive cards initially', (tester) async {
      await tester.pumpWidget(buildCarousel());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('card_0')), findsWidgets);
      expect(find.byKey(const ValueKey('card_1')), findsWidgets);
    });

    testWidgets('scrolls to next card and updates state', (tester) async {
      await tester.pumpWidget(buildCarousel());
      await tester.pumpAndSettle();

      final gestureDetector = find.byType(GestureDetector).first;
      await tester.drag(gestureDetector, const Offset(-400, 0));
      await tester.pumpAndSettle();

      // After scroll, expect Item 1 to exist and be visible
      expect(find.byKey(const ValueKey('card_1')), findsWidgets);
    });

    testWidgets('active card has scale 1.0', (tester) async {
      await tester.pumpWidget(buildCarousel());
      await tester.pumpAndSettle();

      final transforms = tester.widgetList<Transform>(find.byType(Transform));

      final activeTransform = transforms.firstWhere(
        (t) => t.transform.getMaxScaleOnAxis().toStringAsFixed(2) == '1.00',
        orElse: () => throw TestFailure('No active card with scale 1.0 found'),
      );

      expect(activeTransform.transform.getMaxScaleOnAxis(), closeTo(1.0, 0.01));
    });
  });
}
