import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytask/controller/home_controller.dart';
import '../../model/food_model.dart';
import '../widgets/body_widget.dart';
class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return GetBuilder(
      init: HomeController(),
        builder: (controller) => Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              controller.cartProducts.clear();
              controller.update();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount:controller.cartProducts.length,
        itemBuilder: (context, index) {
          Product product = controller.cartProducts[index];
          bool isLastItem = product.quantity == 1;
          return  BodyWidget(
              image: product.images![0],
              title: product.title,
              description: product.description,
              quantity: product.quantity,
              addIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  controller.addItemToCart(product);
                  controller.update();
                },
              ),
              removeIcon: IconButton(
                icon: isLastItem ? const Icon(Icons.delete) : const Icon(Icons.remove),
                onPressed: () {
                  controller.removeItemFromCart(product);
                  controller.update();

                },
              ));

        },
      ),
        bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Price: ${controller.totalPrice}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.cartProducts.clear();
                controller.update();
                Get.back();
              },
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    ));
  }
}






