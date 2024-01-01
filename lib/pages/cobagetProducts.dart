import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String name;
  final double price;
  final String image;
  final String statusStock;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.statusStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      statusStock: json['status_stock'] ?? '',
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body ?? '');
        List<Product> products =
            data.map((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load products. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Laravel API Demo'),
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No products available');
            } else {
              return ProductList(products: snapshot.data!);
            }
          },
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;

  ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: \$${products[index].price.toStringAsFixed(2)}'),
              Text('Status Stock: ${products[index].statusStock}'),
            ],
          ),
          trailing: Image.network(
            products[index].image,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/placeholder.png', // Ganti dengan path placeholder yang sesuai
                width: 50,
                height: 50,
              );
            },
          ),
          onTap: () {
            // Do something when the item is tapped
          },
        );
      },
    );
  }
}
