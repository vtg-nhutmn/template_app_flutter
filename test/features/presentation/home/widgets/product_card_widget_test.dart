import 'package:demo/features/domain/home/entities/product_entity.dart';
import 'package:demo/features/presentation/home/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tProduct = ProductEntity(
    id: 'p1',
    name: 'Widget A',
    description: 'A great widget for testing',
    price: 99.99,
    createdAt: '2026-01-01',
  );

  Widget buildSubject(ProductEntity product) {
    return MaterialApp(
      home: Scaffold(body: ProductCardWidget(product: product)),
    );
  }

  group('ProductCardWidget', () {
    testWidgets('displays product name', (tester) async {
      await tester.pumpWidget(buildSubject(tProduct));
      expect(find.text('Widget A'), findsOneWidget);
    });

    testWidgets('displays product description', (tester) async {
      await tester.pumpWidget(buildSubject(tProduct));
      expect(find.text('A great widget for testing'), findsOneWidget);
    });

    testWidgets('displays formatted price with đ suffix', (tester) async {
      await tester.pumpWidget(buildSubject(tProduct));
      expect(find.textContaining('đ'), findsOneWidget);
    });

    testWidgets('shows placeholder when product has no image', (tester) async {
      await tester.pumpWidget(buildSubject(tProduct));
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    });

    testWidgets('renders as a Card widget', (tester) async {
      await tester.pumpWidget(buildSubject(tProduct));
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
