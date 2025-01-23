import 'package:flutter/material.dart';

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: const Color(0xFF008975),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Logo and Version
            Container(
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              color: const Color(0xFF008975),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      size: 60,
                      color: Color(0xFF008975),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Utang App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versi 1.0.0',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Information List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    'Deskripsi',
                    'Aplikasi pengelola hutang piutang untuk membantu mencatat '
                    'dan mengatur keuangan dengan lebih baik.',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Pengembang',
                    'BangJepp56\n'
                    'MbakSelvi\n'
                    'Terakhir diperbarui: 13 Januari 2025',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Kontak',
                    'Email: BangJepp56@gmail.com\n'
                    'GitHub: github.com/BangJepp56',
                  ),

                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Kontak',
                    'Email: shelviabae@gmail.com\n'
                    'GitHub: github.com/mbakselvi06',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Fitur Utama',
                    '• Pencatatan hutang dan piutang\n'
                    '• Pengingat jatuh tempo\n'
                    '• Laporan keuangan\n'
                    '• Backup data',
                  ),
                ],
              ),
            ),

            // Copyright
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '© 2025 BangJepp56. All rights reserved.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008975),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}