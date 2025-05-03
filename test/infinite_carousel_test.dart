import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

void main() {
  final testItems = List.generate(
    5,
    (index) => InfiniteCarouselItem(content: Text('Item $index')),
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
              items: [InfiniteCarouselItem(content: Text('Single'))],
            ),
          ),
        ),
      );

      expect(find.text('Single'), findsOneWidget);
    });

    testWidgets('renders active and inactive cards initially', (tester) async {
      await tester.pumpWidget(buildCarousel());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ActiveInfiniteCarouselCard, 'Item 0'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(InactiveInfiniteCarouselCard, 'Item 1'),
        findsOneWidget,
      );
    });

    testWidgets('scrolls to next card and updates state', (tester) async {
      await tester.pumpWidget(buildCarousel());
      await tester.pumpAndSettle();

      final gestureDetector = find.ancestor(
        of: find.widgetWithText(ActiveInfiniteCarouselCard, 'Item 0'),
        matching: find.byType(GestureDetector),
      );

      expect(gestureDetector, findsOneWidget);

      await tester.drag(gestureDetector, const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ActiveInfiniteCarouselCard, 'Item 1'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(InactiveInfiniteCarouselCard, 'Item 0'),
        findsOneWidget,
      );
    });

    testWidgets('applies correct scale to active and inactive cards', (
      tester,
    ) async {
      await tester.pumpWidget(buildCarousel());
      await tester.pumpAndSettle();

      final activeTransformFinder = find.descendant(
        of: find.widgetWithText(ActiveInfiniteCarouselCard, 'Item 0'),
        matching: find.byType(Transform),
      );

      final activeTransform = tester.widget<Transform>(activeTransformFinder);
      expect(activeTransform.transform.getMaxScaleOnAxis(), equals(1.0));

      final inactiveTransformFinder = find.descendant(
        of: find.widgetWithText(InactiveInfiniteCarouselCard, 'Item 1'),
        matching: find.byType(Transform),
      );

      final inactiveTransform = tester.widget<Transform>(
        inactiveTransformFinder,
      );
      expect(inactiveTransform.transform.getMaxScaleOnAxis(), equals(0.9));
    });
  });
}
