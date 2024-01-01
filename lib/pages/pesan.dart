// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  List<OrderItem> foodOrders = [];
  List<OrderItem> drinkOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Baru'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Pemesan'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Tanggal Pesanan'),
              ),
              SizedBox(height: 16),
              _buildMenuList('Makanan', foodMenu, foodOrders),
              SizedBox(height: 16),
              _buildMenuList('Minuman', drinkMenu, drinkOrders),
              SizedBox(height: 16),
              Text('Makanan yang telah ditambahkan:'),
              _buildOrderList(foodOrders),
              SizedBox(height: 16),
              Text('Minuman yang telah ditambahkan:'),
              _buildOrderList(drinkOrders),
              SizedBox(height: 16),
              _buildTotalPrice(),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 3.3,
                        vertical: 20)
                    // padding: EdgeInsets.only(
                    //     left: 120, right: 120, top: 20, bottom: 20),
                    ),
                onPressed: () {
                  // Handle the "Lanjutkan" button click
                  _navigateToDetailPage();
                },
                child: Text(
                  'Lanjutkan',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderItem> orders) {
    return Column(
      children: orders.map((order) {
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${order.name}'),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _decreaseOrder(order);
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('${order.quantity} x ${order.price}'),
                  IconButton(
                    onPressed: () {
                      _increaseOrder(order);
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: ${order.quantity * order.price}'),
              IconButton(
                onPressed: () {
                  _removeOrder(order);
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _decreaseOrder(OrderItem order) {
    if (order.quantity > 1) {
      order.quantity--;
      setState(() {});
    }
  }

  void _increaseOrder(OrderItem order) {
    order.quantity++;
    setState(() {});
  }

  void _removeOrder(OrderItem order) {
    foodOrders.remove(
        order); // Assuming foodOrders contains both food and drink orders
    drinkOrders.remove(order);
    setState(() {});
  }

  Widget _buildMenuList(
      String title, List<String> menu, List<OrderItem> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title:'),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _addOrder(orders, menu[index]);
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(menu[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPrice() {
    int totalPrice = 0;
    for (OrderItem order in [...foodOrders, ...drinkOrders]) {
      totalPrice += (order.quantity * order.price);
    }

    return Text('Total Harga: $totalPrice');
  }

  void _addOrder(List<OrderItem> orders, String itemName) {
    bool existingOrder = false;

    for (OrderItem order in orders) {
      if (order.name == itemName) {
        order.quantity++;
        existingOrder = true;
        break;
      }
    }

    if (!existingOrder) {
      // Assign a price based pricing logic
      int price = calculatePrice(itemName);
      orders.add(OrderItem(name: itemName, quantity: 1, price: price));
    }

    setState(() {});
  }

  int calculatePrice(String itemName) {
    switch (itemName) {
      case 'Nasi Goreng':
        return 15000;
      case 'Mie Goreng':
        return 12000;
      case 'Ayam Goreng':
        return 18000;
      case 'Es Teh':
        return 5000;
      case 'Es Jeruk':
        return 6000;
      case 'Air Mineral':
        return 3000;
      default:
        return 0;
    }
  }

  void _navigateToDetailPage() {
    // Implement navigation to the detail page here
  }

  final List<String> foodMenu = ['Nasi Goreng', 'Mie Goreng', 'Ayam Goreng'];
  final List<String> drinkMenu = ['Es Teh', 'Es Jeruk', 'Air Mineral'];
}

class OrderItem {
  final String name;
  int quantity;
  int price;

  OrderItem({required this.name, this.quantity = 1, this.price = 0});
}
