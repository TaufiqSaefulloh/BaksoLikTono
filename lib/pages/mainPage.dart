// ignore_for_file: prefer_const_constructors, deprecated_member_use, camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posbakso/pages/pesan.dart';
import 'package:posbakso/pages/welcomeScreen.dart';

class mainPage extends StatelessWidget {
  const mainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Stack(
          children: [
            ClipPath(
              clipper: HeadClipper(),
              child: Container(
                color: Colors.blueAccent,
                width: double.infinity,
                height: 150,
                child: Center(
                  child: Text(
                    'Bakso LikTono',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TransactionPage()),
                      );
                      print('Button Pemesanan pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Warna biru
                      fixedSize: Size(400, 60), // Set the size here
                    ),
                    child: Text('Pemesanan'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika untuk pembayaran
                      print('Button Pembayaran pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // Warna oranye
                      fixedSize: Size(400, 60), // Set the size here
                    ),
                    child: Text('Pembayaran'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

