import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mytask/constant/api_links.dart';
import '../model/food_model.dart';
import '../services/network.dart';

class HomeController extends GetxController {
  final NetworkManager networkManager = NetworkManager(Dio());
  List<Product> cartProducts = [];
  late Future<FoodModel> foodModelFuture;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    foodModelFuture = fetchData();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Fluttertoast.showToast(msg: 'No internet connection');
      }
    });
  }
  Future<FoodModel> fetchData() async {
    try {
      var response = await networkManager.request<dynamic>(
        RequestMethod.get,
        ApiLinks.productUrl,
      );
      if (response.statusCode == 200 && response.statusCode! < 300) {
        var data = response.data;
        print(data);
        var json = jsonEncode(data);
        FoodModel foodModel = foodModelFromJson(json);
        return foodModel;
      } else {
        throw Exception('API error occurred');
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.unknown) {

        Fluttertoast.showToast(msg: 'No internet connection');
        throw SocketException('No internet connection');
      } else if (error.response != null) {
        int? statusCode = error.response!.statusCode;
        String errorMessage = error.response!.statusMessage ?? 'Unknown error';
        throw Exception('API error occurred: $statusCode ($errorMessage)');
      } else {
        throw Exception('Unknown error occurred');
      }
    } catch (error) {
      throw Exception('Unknown error occurred: $error');
    }
  }

  void addItemToCart(Product product) {
    bool found = false;
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts[i].id == product.id) {
        cartProducts[i].quantity = (cartProducts[i].quantity ?? 0) + 1;
        found = true;
        break;
      }
    }
    if (!found) {
      product.quantity = 1;
      cartProducts.add(product);
    }
    update();
  }

  void removeItemFromCart(Product product) {
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts[i].id == product.id) {
        cartProducts[i].quantity = (cartProducts[i].quantity ?? 0) - 1;
        if (cartProducts[i].quantity == 0) {
          cartProducts.removeAt(i);
        }
        break;
      }
    }
    update();
  }

  int getQuantity(Product product) {
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts[i].id == product.id) {
        return cartProducts[i].quantity ?? 0;
      }
    }
    return 0;
  }

  double get totalPrice {
    double totalPrice = 0;
    for (var product in cartProducts) {
      totalPrice += (product.price ?? 0) * (product.quantity ?? 0);
    }
    return totalPrice;
  }
}

