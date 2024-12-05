import 'package:paloma365/generated/assets.dart';
import 'package:paloma365/model/product_model.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class ProductRepository {

  //singleton
  static final ProductRepository instance = ProductRepository._internal();

  factory ProductRepository() {
    return instance;
  }

  ProductRepository._internal();


  Future<List<ProductModel>> fetchProducts() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 100));
    return [
      ProductModel(
        id: 1,
        name: "Big Cake",
        shortDescription: "A large, delicious cake for all occasions.",
        image: Assets.imagesCake,
        type: ProductType.DESSERT,
        price: 12,
      ),
      ProductModel(
        id: 2,
        name: "Cake",
        shortDescription: "A small piece of delightful cake.",
        image: Assets.imagesCakePiece,
        type: ProductType.DESSERT,
        price: 6,
      ),
      ProductModel(
        id: 3,
        name: "Coke",
        shortDescription: "Classic refreshing cola drink.",
        image: Assets.imagesCoke,
        type: ProductType.DRINK,
        price: 3,
      ),
      ProductModel(
        id: 4,
        name: "Cocktail",
        shortDescription: "A fruity and refreshing mixed drink.",
        image: Assets.imagesCokteyl,
        type: ProductType.DRINK,
        price: 8,
      ),
      ProductModel(
        id: 5,
        name: "Donut",
        shortDescription: "A sweet and fluffy fried dough treat.",
        image: Assets.imagesDonut,
        type: ProductType.DESSERT,
        price: 4,
      ),
      ProductModel(
        id: 6,
        name: "Fanta",
        shortDescription: "A fizzy orange-flavored soda.",
        image: Assets.imagesFanta,
        type: ProductType.DRINK,
        price: 3,
      ),
      ProductModel(
        id: 7,
        name: "Fish",
        shortDescription: "Freshly cooked fish for a hearty meal.",
        image: Assets.imagesFish,
        type: ProductType.FOOD,
        price: 15,
      ),
      ProductModel(
        id: 8,
        name: "Fish salad",
        shortDescription: "A light and healthy fish salad.",
        image: Assets.imagesFishSalad,
        type: ProductType.FOOD,
        price: 10,
      ),
      ProductModel(
        id: 9,
        name: "Free",
        shortDescription: "A complimentary dish for special guests.",
        image: Assets.imagesFree,
        type: ProductType.FOOD,
        price: 2,
      ),
      ProductModel(
        id: 10,
        name: "Ice cream",
        shortDescription: "Creamy and cold dessert for hot days.",
        image: Assets.imagesIcecream,
        type: ProductType.DESSERT,
        price: 5,
      ),
      ProductModel(
        id: 11,
        name: "Meat",
        shortDescription: "Juicy and tender cooked meat.",
        image: Assets.imagesMeat,
        type: ProductType.FOOD,
        price: 18,
      ),
      ProductModel(
        id: 12,
        name: "Moxito",
        shortDescription: "A minty and refreshing drink.",
        image: Assets.imagesMoxito,
        type: ProductType.DRINK,
        price: 7,
      ),
      ProductModel(
        id: 13,
        name: "Pepsi",
        shortDescription: "A popular cola drink for any occasion.",
        image: Assets.imagesPepsi,
        type: ProductType.DRINK,
        price: 3,
      ),
      ProductModel(
        id: 14,
        name: "Pizza",
        shortDescription: "Delicious pizza with a crispy crust.",
        image: Assets.imagesPizza,
        type: ProductType.FOOD,
        price: 20,
      ),
      ProductModel(
        id: 15,
        name: "Plov",
        shortDescription: "A traditional rice dish with spices and meat.",
        image: Assets.imagesPlov,
        type: ProductType.FOOD,
        price: 12,
      ),
      ProductModel(
        id: 16,
        name: "Salad",
        shortDescription: "Fresh and healthy mixed vegetables.",
        image: Assets.imagesSalad,
        type: ProductType.FOOD,
        price: 8,
      ),
      ProductModel(
        id: 17,
        name: "Samosa",
        shortDescription: "A crispy pastry filled with spiced meat or veggies.",
        image: Assets.imagesSomosa,
        type: ProductType.FOOD,
        price: 5,
      ),
      ProductModel(
        id: 18,
        name: "Sprite",
        shortDescription: "A clear, lemon-lime soda.",
        image: Assets.imagesSprite,
        type: ProductType.DRINK,
        price: 3,
      ),
      ProductModel(
        id: 19,
        name: "Steak",
        shortDescription: "Perfectly cooked and seasoned steak.",
        image: Assets.imagesSteak,
        type: ProductType.FOOD,
        price: 25,
      ),
    ];

  }
}
