import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytask/controller/home_controller.dart';
import 'package:mytask/view/widgets/body_widget.dart';
import '../../model/food_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () async {
                 Get.toNamed('/cart');
              },
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder<FoodModel>(
            future: controller.foodModelFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                List<Product>? products = snapshot.data?.products;
                if (products != null) {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Product product = products[index];
                      int quantity = 0;
                      for (var cartProduct in controller.cartProducts) {
                        if (cartProduct.id == product.id) {
                          quantity = cartProduct.quantity ?? 0;
                          break;
                        }
                      }
                  return BodyWidget(image: product.images![0],
                      title: product.title,
                      description: product.description,
                      quantity: quantity,
                      addIcon:IconButton(
                              onPressed: () {
                                controller.addItemToCart(product);
                              },
                              icon: Icon(Icons.add),
                            ),
                      removeIcon: IconButton(
                              onPressed: () {
                                if (quantity > 0) {
                                  controller.removeItemFromCart(product);
                                }
                              },
                              icon: Icon(Icons.remove),
                      ));
                    },
                  );
                } else {
                  return Text('No products available');
                }
              } else if (snapshot.hasError) {
                return Text('Failed to fetch data: ${snapshot.error}');
              } else {
                return Text('Failed to fetch data');
              }
            },
          ),
        ),
      ),
    );
  }
}
