import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Screens/rekap_barang.dart';
import '../constant/color.dart';
import '../main.dart';

class FirebaseDataTable extends StatefulWidget {
  const FirebaseDataTable({super.key});

  @override
  State<FirebaseDataTable> createState() => _FirebaseDataTableState();
}

class _FirebaseDataTableState extends State<FirebaseDataTable> {
  // variable number start 1
  int counter = 1;

// mengambil data dari cloud firestore menggunakan fungsi snapshot
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('data-barang').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Stack(
            children: [
              CircularProgressIndicator(),
            ],
          );
        }

        return Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 50),
            child: DataTable(
              columnSpacing: 15,
              headingRowHeight: 45,
              // ignore: deprecated_member_use
              dataRowHeight: 35,
              border: TableBorder.all(
                color: Colors.orange,
                style: BorderStyle.solid,
                width: 1,
              ),
              dataRowColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.orange;
                }
                return null;
              }),
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'No',
                    style: TextStyle(
                      color: getRandomColor(),
                    ),
                  ),
                ),
                DataColumn(
                    label: Text('Nama Barang',
                        style: TextStyle(color: getRandomColor()))),
                DataColumn(
                    label: Text('Jenis barang',
                        style: TextStyle(color: getRandomColor()))),
                DataColumn(
                    label: Text('kondisi Barang',
                        style: TextStyle(color: getRandomColor()))),
                DataColumn(
                    label: Text('Tanggal Masuk Barang',
                        style: TextStyle(color: getRandomColor()))),
                DataColumn(
                    label: Text('Nama Distributor',
                        style: TextStyle(color: getRandomColor()))),
                DataColumn(
                    label: Text('Alamat',
                        style: TextStyle(color: getRandomColor()))),
                DataColumn(
                    label: Text('Aksi',
                        style: TextStyle(color: getRandomColor()))),
                // Tambahkan kolom tambahan sesuai kebutuhan
              ],
              rows: _buildRows(
                snapshot.data!,
              ),
            ),
          ),
        );
      },
    );
  }

  // membaca data yang dimabil dari cloud firebase ke client sesuai field yang di butuhkan pada document collection
  List<DataRow> _buildRows(QuerySnapshot snapshot) {
    counter = 1;
    return snapshot.docs.map((DocumentSnapshot document) {
      final int index = counter++;
      return DataRow(
        cells: <DataCell>[
          DataCell(
            Text(
              '$index',
            ),
          ),
          DataCell(
            Text(
              document['nama-barang'],
            ),
          ),
          DataCell(Text(
            document['jenis-barang'],
          )),
          DataCell(Text(
            document['kondisi-barang'],
          )),
          DataCell(Text(
            document['tanggalmasuk-barang'],
          )),
          DataCell(Text(
            document['nama-distributor'],
          )),
          DataCell(Text(
            document['alamat'],
          )),
          DataCell(
            Row(
              children: [
                IconButton(
                  tooltip: 'edit',
                  onPressed: () {
                    // update atau edit data secara realtime ke firebase
                    _editData(document);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: iconUpdate,
                  ),
                ),
                IconButton(
                  tooltip: 'delete',
                  onPressed: () {
                    // hapus data secara realtime ke firebase
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Yakin ingin menghapus?"),
                          content:  Text("tekan ya jika ingin melanjutkan"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Tidak'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: iconDelete),
                              onPressed: () {
                                Navigator.pop(context);
                                document.reference.delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Barang berhasil di Hapus!'),
                                    duration: Duration(
                                      seconds: 2,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Ya'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: iconDelete,
                  ),
                ),
              ],
            ),
          ),
          // Tambahkan sel tambahan sesuai kebutuhan
        ],
      );
    }).toList();
  }
}

// form updatete data
Future<void> _editData(DocumentSnapshot document) async {
  String nama_barang = document['nama-barang'];
  String jenis_barang = document['jenis-barang'];
  String kondisi_barang = document['kondisi-barang'];
  String tanggalmasuk_barang = document['tanggalmasuk-barang'];
  String nama_distributor = document['nama-distributor'];
  String alamat = document['alamat'];

  Navigator.push(
    GlobalContextService.navigatorKey.currentContext!,
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: blueColor,
            title: Text('Edit Data Barang'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        initialValue: nama_barang,
                        onChanged: (value) {
                          nama_barang = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'nama-barang',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        initialValue: jenis_barang,
                        onChanged: (value) {
                          jenis_barang = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'jenis-barang',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        initialValue: kondisi_barang,
                        onChanged: (value) {
                          kondisi_barang = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'kondisi',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        initialValue: tanggalmasuk_barang,
                        onChanged: (value) {
                          tanggalmasuk_barang = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'tanggal masuk barang',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        initialValue: nama_distributor,
                        onChanged: (value) {
                          nama_distributor = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'nama distributor',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        initialValue: alamat,
                        onChanged: (value) {
                          alamat = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'alamat',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Kembali'),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: iconUpdate),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Barang berhasil di Perbaharui!'),
                                duration: Duration(
                                  seconds: 2,
                                ),
                              ),
                            );
                            document.reference.update(
                              {
                                'nama-barang': nama_barang,
                                'jenis-barang': jenis_barang,
                                'kondisi-barang': kondisi_barang,
                                'tanggalmasuk-barang': tanggalmasuk_barang,
                                'nama-distributor': nama_distributor,
                                'alamat': alamat,
                              },
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text('Update Data'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
