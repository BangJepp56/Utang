import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/hutang_model.dart';
import '../../services/hutang_service.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final HutangService _hutangService = HutangService();
  List<HutangModel> _allHutang = [];
  List<HutangModel> _filteredHutang = [];
  bool _isLoading = true;
  String _filterValue = 'Semua';
  String _searchQuery = '';

  final currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadHutangData();
  }

  Future<void> _loadHutangData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final hutangList = await _hutangService.getSemuaHutang();
      setState(() {
        _allHutang = hutangList;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memuat data riwayat'),
          backgroundColor: Color(0xFF008975),
        ),
      );
    }
  }

  void _applyFilters() {
    List<HutangModel> filtered = List.from(_allHutang);

    // Apply category filter
    if (_filterValue != 'Semua') {
      bool isMeminjam = _filterValue == 'Meminjam';
      filtered = filtered.where((hutang) => hutang.isMeminjam == isMeminjam).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((hutang) {
        return hutang.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            hutang.keterangan.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => DateTime.parse(b.tanggal).compareTo(DateTime.parse(a.tanggal)));

    setState(() {
      _filteredHutang = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008975),
        elevation: 0,
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5), // Light grey background
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari transaksi...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF008975)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF008975)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _applyFilters();
                  });
                },
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Meminjam'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Dipinjam'),
                  ],
                ),
              ),
            ),

            // Transaction List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF008975),
                      ),
                    )
                  : _filteredHutang.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada riwayat transaksi',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _filteredHutang.length,
                          itemBuilder: (context, index) {
                            final hutang = _filteredHutang[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: hutang.isMeminjam
                                        ? const Color(0xFFFFEBEE)
                                        : const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    hutang.isMeminjam
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: hutang.isMeminjam
                                        ? Colors.red[700]
                                        : Colors.green[700],
                                    size: 28,
                                  ),
                                ),
                                title: Text(
                                  hutang.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      currencyFormatter.format(hutang.jumlah),
                                      style: TextStyle(
                                        color: hutang.isMeminjam
                                            ? Colors.red[700]
                                            : Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('dd MMMM yyyy').format(
                                        DateTime.parse(hutang.tanggal),
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _showTransactionDetails(hutang),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: _filterValue == label ? Colors.white : Colors.grey[800],
          fontWeight: _filterValue == label ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _filterValue == label,
      selectedColor: const Color(0xFF008975),
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _filterValue == label
              ? const Color(0xFF008975)
              : Colors.grey[300]!,
        ),
      ),
      onSelected: (bool selected) {
        setState(() {
          _filterValue = label;
          _applyFilters();
        });
      },
    );
  }

  void _showTransactionDetails(HutangModel hutang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                hutang.isMeminjam ? Icons.arrow_upward : Icons.arrow_downward,
                color: hutang.isMeminjam ? Colors.red[700] : Colors.green[700],
              ),
              const SizedBox(width: 8),
              const Text('Detail Transaksi'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Nama', hutang.nama),
              _buildDetailRow('Jumlah', currencyFormatter.format(hutang.jumlah)),
              _buildDetailRow(
                'Tanggal',
                DateFormat('dd MMMM yyyy').format(
                  DateTime.parse(hutang.tanggal),
                ),
              ),
              _buildDetailRow(
                'Jenis',
                hutang.isMeminjam ? 'Meminjam' : 'Dipinjam',
              ),
              _buildDetailRow('Keterangan', hutang.keterangan),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF008975),
              ),
              child: const Text('Tutup'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}