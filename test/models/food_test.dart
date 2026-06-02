import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/models/food.dart';

void main() {
  group('Food.fromFirestore', () {
    test('should parse basic fields correctly', () {
      final data = {
        'name': 'Arroz',
        'brand': 'Basmati',
        'carbsPer100g': 28.0,
        'isFavorite': true,
      };

      final food = Food.fromFirestore('doc123', data);

      expect(food.id, 'doc123');
      expect(food.name, 'Arroz');
      expect(food.brand, 'Basmati');
      expect(food.carbsPer100g, 28.0);
      expect(food.isFavorite, true);
      expect(food.kcalPer100g, isNull);
    });

    test('should handle missing optional fields', () {
      final data = {
        'name': 'Manzana',
        'carbsPer100g': 14.0,
      };

      final food = Food.fromFirestore('doc456', data);

      expect(food.brand, '');
      expect(food.isFavorite, false);
      expect(food.kcalPer100g, isNull);
      expect(food.proteinsPer100g, isNull);
      expect(food.fatsPer100g, isNull);
      expect(food.productUrl, isNull);
    });

    test('should parse numeric fields as int or double', () {
      final data = {
        'name': 'Test',
        'carbsPer100g': 25, // int
        'kcalPer100g': 100.5, // double
      };

      final food = Food.fromFirestore('id', data);

      expect(food.carbsPer100g, 25.0);
      expect(food.kcalPer100g, 100.5);
    });
  });

  group('Food.toFirestore', () {
    test('should serialize all fields', () {
      const food = Food(
        id: 'id1',
        name: 'Pollo',
        brand: 'Avícola',
        carbsPer100g: 0.0,
        kcalPer100g: 200.0,
        proteinsPer100g: 30.0,
        fatsPer100g: 5.0,
        isFavorite: true,
        productUrl: 'https://example.com',
      );

      final map = food.toFirestore();

      expect(map['name'], 'Pollo');
      expect(map['brand'], 'Avícola');
      expect(map['carbsPer100g'], 0.0);
      expect(map['kcalPer100g'], 200.0);
      expect(map['proteinsPer100g'], 30.0);
      expect(map['fatsPer100g'], 5.0);
      expect(map['isFavorite'], true);
      expect(map['productUrl'], 'https://example.com');
    });

    test('should omit null optional fields', () {
      const food = Food(
        id: 'id2',
        name: 'Agua',
        carbsPer100g: 0.0,
      );

      final map = food.toFirestore();

      expect(map.containsKey('kcalPer100g'), false);
      expect(map.containsKey('proteinsPer100g'), false);
      expect(map.containsKey('fatsPer100g'), false);
      expect(map.containsKey('productUrl'), false);
    });
  });

  group('Food.copyWith', () {
    const food = Food(
      id: 'id1',
      name: 'Original',
      brand: 'Brand',
      carbsPer100g: 10.0,
      kcalPer100g: 50.0,
      proteinsPer100g: 5.0,
      fatsPer100g: 2.0,
      isFavorite: false,
      productUrl: 'https://example.com',
    );

    test('should keep values when no changes', () {
      final copy = food.copyWith();

      expect(copy.id, food.id);
      expect(copy.name, food.name);
      expect(copy.carbsPer100g, food.carbsPer100g);
      expect(copy.kcalPer100g, food.kcalPer100g);
      expect(copy.productUrl, food.productUrl);
    });

    test('should override specified fields', () {
      final copy = food.copyWith(
        name: 'Nuevo',
        carbsPer100g: 20.0,
      );

      expect(copy.name, 'Nuevo');
      expect(copy.carbsPer100g, 20.0);
      expect(copy.brand, food.brand);
    });

    test('should clear kcal when clearKcal is true', () {
      final copy = food.copyWith(clearKcal: true);

      expect(copy.kcalPer100g, isNull);
    });

    test('should clear proteins when clearProteins is true', () {
      final copy = food.copyWith(clearProteins: true);

      expect(copy.proteinsPer100g, isNull);
    });

    test('should clear fats when clearFats is true', () {
      final copy = food.copyWith(clearFats: true);

      expect(copy.fatsPer100g, isNull);
    });

    test('should clear productUrl when clearProductUrl is true', () {
      final copy = food.copyWith(clearProductUrl: true);

      expect(copy.productUrl, isNull);
    });

    test('should keep productUrl when clearProductUrl is false', () {
      final copy = food.copyWith(productUrl: 'https://new.com');

      expect(copy.productUrl, 'https://new.com');
    });
  });

  group('Food.displayName', () {
    test('should return name only when brand is empty', () {
      const food = Food(
        id: 'id',
        name: 'Manzana',
        carbsPer100g: 14.0,
      );

      expect(food.displayName, 'Manzana');
    });

    test('should return name with brand when brand is set', () {
      const food = Food(
        id: 'id',
        name: 'Yogur',
        brand: 'Danone',
        carbsPer100g: 12.0,
      );

      expect(food.displayName, 'Yogur (Danone)');
    });
  });
}
