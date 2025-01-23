// Import package dan dependencies yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Package untuk format tanggal dan mata uang
import 'package:utang/auth/loginpage.dart';
import 'package:utang/models/hutang_model.dart';
import 'package:utang/screens/edit_hutang.dart';
import 'package:utang/screens/sidebar/bantuan.dart';
import 'package:utang/screens/sidebar/pengaturan.dart';
import 'package:utang/screens/sidebar/riwayat.dart';
import 'package:utang/screens/tambah_hutang.dart';
import 'package:utang/screens/sidebar/tentang.dart';
import 'package:utang/services/hutang_service.dart';

// Widget utama untuk halaman beranda aplikasi
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BukuHutangHomeState createState() => _BukuHutangHomeState();
}

// State untuk mengatur logika dan tampilan halaman beranda
class _BukuHutangHomeState extends State<Homescreen> {
  // Inisialisasi service dan variabel yang dibutuhkan
  final HutangService _hutangService = HutangService();
  bool isMeminjam = true;// Status tab yang aktif (Meminjam/Dipinjam)
  double totalMeminjam = 0.0;// Total hutang yang dipinjam
  double totalDipinjam = 0.0;// Total hutang yang dipinjamkan
  String userName = 'JS';
  String userEmail = 'JS@gmail.com';
  List<HutangModel> _hutangList = [];// Daftar semua hutang

   // Konfigurasi format mata uang Rupiah
  final currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();// Memuat data pengguna
    _loadHutangData();// Memuat data hutang

  }

// Fungsi untuk memuat data pengguna dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Nama Pengguna';
      userEmail = prefs.getString('userEmail') ?? 'user@example.com';
    });
  }

 // Fungsi untuk memuat daftar hutang dan total hutang
  Future<void> _loadHutangData() async {
    final hutangList = await _hutangService.getSemuaHutang();
    final totals = await _hutangService.getTotals();
    setState(() {
      _hutangList = hutangList;
      totalMeminjam = totals['totalMeminjam'] ?? 0;
      totalDipinjam = totals['totalDipinjam'] ?? 0;
    });
  }

// Widget untuk menampilkan daftar hutang
  Widget _buildHutangList() {
    // Filter hutang berdasarkan tab yang aktif
    final filteredList = _hutangList
        .where((hutang) => hutang.isMeminjam == isMeminjam)
        .toList();

// Tampilan ketika tidak ada hutang
    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF7FFFD4).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.attach_money,
                size: 40,
                color: Color(0xFF008975),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isMeminjam ? 'Belum ada hutang' : 'Belum ada yang meminjam',
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF008975),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                isMeminjam
                    ? 'Tuliskan uang yang Anda pinjam dari orang lain'
                    : 'Tuliskan uang yang Anda pinjamkan ke orang lain',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

// Tampilan daftar hutang dalam bentuk ListView
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final hutang = filteredList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              hutang.nama,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currencyFormatter.format(hutang.jumlah)),
                Text(
                  DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(hutang.tanggal),
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Color(0xFF008975)),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) async {
                if (value == 'edit') {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => EditHutangPage(
                   hutang: hutang,
                    onDebtEdited: (HutangModel updatedHutang) {
                     _loadHutangData(); // Reload data after editing
                    },
                  ),
                  ),
                  );
                } else if (value == 'delete') {
                  _showDeleteConfirmationDialog(hutang);
                }
              },
            ),
            onTap: () {
              _showHutangDetails(hutang);
            },
          ),
        );
      },
    );
  }

 // Dialog konfirmasi penghapusan hutang
  void _showDeleteConfirmationDialog(HutangModel hutang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Hutang'),
          content: const Text('Apakah Anda yakin ingin menghapus hutang ini?'),
          actions: [
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await _hutangService.hapusHutang(hutang.id);
                if (success) {
                  _loadHutangData();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hutang berhasil dihapus')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

// Dialog untuk menampilkan detail hutang
  void _showHutangDetails(HutangModel hutang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detail Hutang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${hutang.nama}'),
              const SizedBox(height: 8),
              Text('Jumlah: ${currencyFormatter.format(hutang.jumlah)}'),
              const SizedBox(height: 8),
              Text('Tanggal: ${DateFormat('dd MMMM yyyy').format(
                DateTime.parse(hutang.tanggal),
              )}'),
              const SizedBox(height: 8),
              Text('Keterangan: ${hutang.keterangan}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008975),
        title: const Text('Utang'),
       
      ),

      //menu sidebar
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF008975),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF008975),
                  size: 40,
                ),
              ),
              accountName: Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(userEmail),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Color(0xFF008975),
                    ),
                    title: const Text('Beranda'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: Color(0xFF008975),
                    ),
                    title: const Text('Riwayat Transaksi'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RiwayatScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Color(0xFF008975),
                    ),
                    title: const Text('Pengaturan'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PengaturanScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.help_outline,
                      color: Color(0xFF008975),
                    ),
                    title: const Text('Bantuan'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BantuanScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF008975),
                    ),
                    title: const Text('Tentang Aplikasi'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TentangScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                title: const Text('Keluar'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Keluar'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Ya',
                              style: TextStyle(color: Color(0xFF008975)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      //body utama aplikasi
      body: Column(
        children: [
          // Tab untuk memilih antara Meminjam dan Dipinjam
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isMeminjam ? const Color(0xFF008975) : Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isMeminjam = true;
                      });
                    },
                    child: Text(
                      'MEMINJAM',
                      style: TextStyle(
                        color: isMeminjam ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isMeminjam ? const Color(0xFF008975) : Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isMeminjam = false;
                      });
                    },
                    child: Text(
                      'DIPINJAM',
                      style: TextStyle(
                        color: !isMeminjam ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Daftar hutang
          Expanded(
            child: _buildHutangList(),
          ),

           // Total hutang di bagian bawah
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF008975),
            width: double.infinity,
            child: Text(
              'Total: ${currencyFormatter.format(isMeminjam ? totalMeminjam : totalDipinjam)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),

      //tombol tambah hutang
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF008975),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahHutangPage(
                isMeminjam: isMeminjam,
                onDebtAdded: (HutangModel hutang) {
                  _loadHutangData(); // Reload data after adding new debt
                },
              ),
            ),
          );
        },
      ),
    );
  }
}