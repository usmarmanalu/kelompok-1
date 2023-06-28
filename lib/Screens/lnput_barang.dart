import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_1/Screens/dasboard.dart';
import 'package:kelompok_1/Screens/rekap_barang.dart';
import '../constant/color.dart';
import '../main.dart';

class InputBarang extends StatefulWidget {
  const InputBarang({super.key});

  @override
  State<InputBarang> createState() => _InputBarangState();
}

class _InputBarangState extends State<InputBarang> {
  TextEditingController _namaBarang = TextEditingController();
  TextEditingController _jenisBarang = TextEditingController();
  TextEditingController _kondisiBarang = TextEditingController();
  TextEditingController _tanggalMasukBarang = TextEditingController();
  TextEditingController _namaDistrubutor = TextEditingController();
  TextEditingController _alamat = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // index dropdown button
  List<String> jenisbrg = ["Box", "Pack", ""];
  // fungsi menampilkan kalender
  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 0),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );

    if (picked != null) {
      setState(
        () {
          _tanggalMasukBarang.text =
              "${picked.day}/ ${picked.month}/ ${picked.year}";
        },
      );
    }
  }

// fungsi mengirim data reference pada collection cloud firestore
  sendUserDataToDB() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("data-barang");

    return _collectionRef
        .doc()
        .set({
          "nama-barang": _namaBarang.text,
          "jenis-barang": _jenisBarang.text,
          "kondisi-barang": _kondisiBarang.text,
          "tanggalmasuk-barang": _tanggalMasukBarang.text,
          "nama-distributor": _namaDistrubutor.text,
          "alamat": _alamat.text,
        })
        .then(
          (value) => Navigator.push(
            GlobalContextService.navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => DetailBarang(),
            ),
          ),
        )
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: blueColor,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Manajemen Data Barang",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: Center(
                      child: Text(
                        'Form Tambah Data',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            // validator form
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'data barang harus di isi';
                              }
                              return null;
                            },
                            controller: _namaBarang,
                            decoration: InputDecoration(
                              label: Text("nama barang"),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      controller: _jenisBarang,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: DropdownButton<String>(
                          iconDisabledColor: Colors.black,
                          iconEnabledColor: Colors.teal,
                          hint: Text('jenis barang'),
                          items: jenisbrg.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                              onTap: () {
                                setState(() {
                                  _jenisBarang.text = value;
                                });
                              },
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _kondisiBarang,
                          decoration: InputDecoration(
                            label: Text("Kondisi"),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _tanggalMasukBarang,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text('tanggal/bulan/tahun - masuk barang'),
                        border: InputBorder.none,
                        hintText: "dd/mm/ttdy",
                        suffixIcon: IconButton(
                          onPressed: () => _selectDateFromPicker(context),
                          icon: Icon(
                            Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _namaDistrubutor,
                          decoration: InputDecoration(
                            label: Text("nama distributor"),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _alamat,
                          decoration: InputDecoration(
                            label: Text("alamat"),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: iconCreate),
                          onPressed: () {
                            // aksi jka validasi valid dan memanggil fungsi untuk mengirim data ke cloud firestore
                            if (_formKey.currentState!.validate()) {
                              sendUserDataToDB();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Barang berhasil di Buat!'),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text("Simpan Barang"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: iconRead),
                              onPressed: () {
                                Navigator.push(
                                  GlobalContextService
                                      .navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                    builder: (context) => DetailBarang(),
                                  ),
                                );
                              },
                              child: Text("Lihat Rekap"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange),
                              onPressed: () {
                                // mereset semual value form
                                _namaBarang.clear();
                                _jenisBarang.clear();
                                _kondisiBarang.clear();
                                _tanggalMasukBarang.clear();
                                _namaDistrubutor.clear();
                                _alamat.clear();
                              },
                              child: Text("Reset"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                // batal dan kembali ke dasboard
                                Navigator.push(
                                  GlobalContextService
                                      .navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                    builder: (context) => const Dasboard(),
                                  ),
                                );
                              },
                              child: Text("Batal"),
                            ),
                          ],
                        ),
                      ],
                    ),
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
