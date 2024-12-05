import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */

enum ProductType {
  FOOD(label: "Food", icon: Icons.soup_kitchen),
  DRINK(label: "Drinks", icon: Icons.local_drink),
  DESSERT(label: "Desserts", icon: Icons.cake);

  final String label;
  final IconData icon;

  const ProductType({required this.label, required this.icon});
}

class ProductModel {
  final int id;
  final String name;
  final String shortDescription;
  final String image;
  final ProductType type;
  final int price;

  ProductModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.image,
    required this.type,
    required this.price,
  });
}
