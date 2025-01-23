import 'package:flutter/material.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: const Color(0xFF008975),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari bantuan...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Frequently Asked Questions
              const Text(
                'Pertanyaan yang Sering Diajukan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008975),
                ),
              ),
              const SizedBox(height: 16),
              _buildFAQSection(),

              const SizedBox(height: 24),

              // Basic Usage Guide
              const Text(
                'Panduan Penggunaan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008975),
                ),
              ),
              const SizedBox(height: 16),
              _buildUserGuideSection(),

              const SizedBox(height: 24),

              // Contact Support
              const Text(
                'Hubungi Kami',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008975),
                ),
              ),
              const SizedBox(height: 16),
              _buildContactSection(context),

              const SizedBox(height: 24),

              // App Information
              _buildAppInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      children: [
        _buildExpandableCard(
          'Bagaimana cara menambah catatan hutang baru?',
          'Untuk menambah catatan hutang baru:\n\n'
          '1. Tekan tombol + di halaman utama\n'
          '2. Pilih jenis transaksi (Meminjam/Dipinjam)\n'
          '3. Isi detail hutang (nama, jumlah, tanggal, dll)\n'
          '4. Tekan tombol Simpan',
        ),
        const SizedBox(height: 8),
        _buildExpandableCard(
          'Bagaimana cara mengedit atau menghapus catatan?',
          'Untuk mengedit atau menghapus catatan:\n\n'
          '1. Tekan titik tiga (...) pada catatan yang diinginkan\n'
          '2. Pilih "Edit" untuk mengubah atau "Hapus" untuk menghapus\n'
          '3. Konfirmasi tindakan Anda',
        ),
        const SizedBox(height: 8),
        _buildExpandableCard(
          'Apakah data saya aman?',
          'Ya, data Anda disimpan secara lokal di perangkat dan dapat '
          'dibackup ke penyimpanan cloud. Kami tidak mengumpulkan '
          'atau menyimpan data pribadi Anda di server kami.',
        ),
        const SizedBox(height: 8),
        _buildExpandableCard(
          'Bagaimana cara membackup data?',
          '1. Buka menu Pengaturan\n'
          '2. Pilih "Backup Data"\n'
          '3. Pilih lokasi penyimpanan backup\n'
          '4. Tunggu hingga proses backup selesai',
        ),
      ],
    );
  }

  Widget _buildUserGuideSection() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Langkah-langkah Dasar:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('1. Mencatat Hutang Baru'),
            Text('   • Tekan tombol + di halaman utama'),
            Text('   • Isi informasi yang diperlukan'),
            Text('   • Simpan catatan'),
            SizedBox(height: 8),
            Text('2. Melihat Riwayat'),
            Text('   • Buka menu "Riwayat Transaksi"'),
            Text('   • Filter berdasarkan kategori jika diperlukan'),
            SizedBox(height: 8),
            Text('3. Mengelola Data'),
            Text('   • Backup data secara rutin'),
            Text('   • Periksa total hutang di dashboard'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text('support@utangapp.com'),
              onTap: () {
                // Implement email action
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Live Chat'),
              subtitle: const Text('Tersedia 24/7'),
              onTap: () {
                _showLiveChatDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Pusat Bantuan Online'),
              subtitle: const Text('Kunjungi website kami'),
              onTap: () {
                // Implement website navigation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              'Informasi Aplikasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Versi: 1.0.0'),
            Text('Terakhir Diperbarui: 13 Januari 2025'),
            Text('Dibuat oleh: BangJepp56'),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCard(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content),
        ),
      ],
    );
  }

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mulai Live Chat'),
          content: const Text(
            'Anda akan terhubung dengan tim support kami. '
            'Waktu tunggu rata-rata adalah 2 menit.',
          ),
          actions: [
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Mulai Chat',
                style: TextStyle(color: Color(0xFF008975)),
              ),
              onPressed: () {
                // Implement live chat functionality
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}