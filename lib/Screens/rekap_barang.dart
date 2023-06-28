import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kelompok_1/Screens/dasboard.dart';
import 'package:kelompok_1/constant/color.dart';
import '../data/firebase_data_table.dart';
import '../main.dart';
import 'lnput_barang.dart';

// List random color pada header table cell row
List<Color> _randomColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.teal,
  Colors.orange,
  Colors.purple,
  Colors.black,
  Colors.brown,
];

// Fungsi untuk menghasilkan warna acak
Color getRandomColor() {
  Random random = Random();
  return _randomColors[random.nextInt(_randomColors.length)];
}

class DetailBarang extends StatelessWidget {
  DetailBarang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: blueColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text("Rekap Data Barang"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  GlobalContextService.navigatorKey.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => const InputBarang(),
                  ),
                );
              },
              child: ClipRect(
                child: CircleAvatar(
                  radius: 23,
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              FirebaseDataTable(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Dasboard',
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          Navigator.push(
            GlobalContextService.navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const Dasboard(),
            ),
          );
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
