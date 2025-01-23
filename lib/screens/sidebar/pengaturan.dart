import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  // State variables
  bool _isDarkMode = false;
  String _currentLanguage = 'Bahasa Indonesia';
  String _currency = 'Rp';
  bool _notificationsEnabled = true;
  String _lastSync = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('userName') ?? 'BangJepp56';
      _emailController.text = prefs.getString('userEmail') ?? 'BangJepp56@gmail.com';
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _currentLanguage = prefs.getString('language') ?? 'Bahasa Indonesia';
      _currency = prefs.getString('currency') ?? 'Rp';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _lastSync = prefs.getString('lastSync') ?? 
          DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now());
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    await prefs.setString('userEmail', _emailController.text);
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('language', _currentLanguage);
    await prefs.setString('currency', _currency);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('lastSync', 
        DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF008975),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preferensi Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008975),
                ),
              ),
              const SizedBox(height: 16),
              _buildPreferencesSection(),
              
              const Divider(height: 32),
              
              // Data Management Section
              const Text(
                'Manajemen Data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008975),
                ),
              ),
              const SizedBox(height: 16),
              _buildDataManagementSection(),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008975),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    await _saveSettings();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pengaturan berhasil disimpan'),
                        backgroundColor: Color(0xFF008975),
                      ),
                    );
                  },
                  child: const Text(
                    'Simpan Pengaturan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      children: [
        // Dark Mode Switch
        SwitchListTile(
          title: const Text('Mode Gelap'),
          secondary: const Icon(Icons.dark_mode),
          value: _isDarkMode,
          onChanged: (bool value) {
            setState(() {
              _isDarkMode = value;
            });
          },
        ),
        
        // Language Selection
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Bahasa'),
          subtitle: Text(_currentLanguage),
          onTap: () => _showLanguageDialog(),
        ),
        
        // Currency Selection
        ListTile(
          leading: const Icon(Icons.currency_exchange),
          title: const Text('Mata Uang'),
          subtitle: Text(_currency),
          onTap: () => _showCurrencyDialog(),
        ),
        
        // Notifications Switch
        SwitchListTile(
          title: const Text('Notifikasi'),
          secondary: const Icon(Icons.notifications),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDataManagementSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Sinkronisasi Data'),
          subtitle: Text('Terakhir: $_lastSync'),
          onTap: () async {
            // Implement sync logic here
            setState(() {
              _lastSync = DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now());
            });
            await _saveSettings();
          },
        ),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Backup Data'),
          onTap: () {
            // Implement backup logic
          },
        ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: const Text('Restore Data'),
          onTap: () {
            // Implement restore logic
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text(
            'Hapus Semua Data',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => _showDeleteConfirmation(),
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Bahasa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Bahasa Indonesia'),
                onTap: () {
                  setState(() {
                    _currentLanguage = 'Bahasa Indonesia';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    _currentLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Mata Uang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Rp (Rupiah)'),
                onTap: () {
                  setState(() {
                    _currency = 'Rp';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('\$ (Dollar)'),
                onTap: () {
                  setState(() {
                    _currency = '\$';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Semua Data'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus semua data? '
            'Tindakan ini tidak dapat dibatalkan.',
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
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua data telah dihapus'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}