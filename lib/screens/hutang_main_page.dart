import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utang/models/hutang_model.dart';

class HutangMainPage extends StatefulWidget {
  final bool isMeminjam;
  final List<HutangModel> hutangList;
  final Function(HutangModel) onEdit;
  final Function(HutangModel) onDelete;

  const HutangMainPage({
    super.key,
    required this.isMeminjam,
    required this.hutangList,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<HutangMainPage> createState() => _HutangMainPageState();
}

class _HutangMainPageState extends State<HutangMainPage> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.hutangList
        .where((hutang) => hutang.isMeminjam == widget.isMeminjam)
        .toList();

    if (filteredList.isEmpty) {
      return _buildEmptyState();
    }
    return _buildHutangList(filteredList);
  }

  Widget _buildEmptyState() {
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
            widget.isMeminjam ? 'Belum ada hutang' : 'Belum ada piutang',
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF008975),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              widget.isMeminjam
                  ? 'Tekan tombol + untuk menambahkan hutang baru'
                  : 'Tekan tombol + untuk menambahkan piutang baru',
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

  Widget _buildHutangList(List<HutangModel> filteredList) {
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final hutang = filteredList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF008975),
              child: Text(
                hutang.nama[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              hutang.nama,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currencyFormatter.format(hutang.jumlah),
                  style: const TextStyle(
                    color: Color(0xFF008975),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd MMMM yyyy', 'id').format(
                    DateTime.parse(hutang.tanggal),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showOptions(context, hutang),
            ),
            onTap: () => _showDetailDialog(context, hutang),
          ),
        );
      },
    );
  }

  void _showOptions(BuildContext context, HutangModel hutang) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit,
                  color: Color(0xFF008975),
                ),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onEdit(hutang);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, hutang);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, HutangModel hutang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${widget.isMeminjam ? "hutang" : "piutang"} dari ${hutang.nama}?',
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
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete(hutang);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.isMeminjam ? "Hutang" : "Piutang"} ${hutang.nama} telah dihapus',
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context, HutangModel hutang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.isMeminjam ? 'Detail Hutang' : 'Detail Piutang',
            style: const TextStyle(color: Color(0xFF008975)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Nama', hutang.nama),
              const SizedBox(height: 8),
              _buildDetailRow('Jumlah', currencyFormatter.format(hutang.jumlah)),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Tanggal',
                DateFormat('dd MMMM yyyy', 'id').format(
                  DateTime.parse(hutang.tanggal),
                ),
              ),
              if (hutang.keterangan.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Keterangan', hutang.keterangan),
              ],
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Tutup',
                style: TextStyle(color: Color(0xFF008975)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}