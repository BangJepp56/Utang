import 'package:flutter/material.dart';
import '../models/hutang_model.dart';
import '../services/hutang_service.dart';
import 'package:uuid/uuid.dart';

class TambahHutangPage extends StatefulWidget {
  final bool isMeminjam;
  final Function(HutangModel) onDebtAdded;

  const TambahHutangPage({
    super.key,
    required this.isMeminjam,
    required this.onDebtAdded,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TambahHutangPageState createState() => _TambahHutangPageState();
}

class _TambahHutangPageState extends State<TambahHutangPage> {
  final _formKey = GlobalKey<FormState>();
  final _hutangService = HutangService();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();

  // Define constant colors
  static const primaryColor = Color(0xFF008975);
  static const backgroundColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.isMeminjam ? 'Tambah Meminjam' : 'Tambah Dipinjam',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('Nama'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _namaController,
                        hint: 'Masukkan nama',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInputLabel('Jumlah'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _jumlahController,
                        hint: 'Masukkan jumlah',
                        prefixText: 'Rp ',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jumlah tidak boleh kosong';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Jumlah harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInputLabel('Keterangan'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _keteranganController,
                        hint: 'Masukkan keterangan (opsional)',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D2D2D),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? prefixText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      style: const TextStyle(fontSize: 16),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 2,
      ),
      onPressed: _submitForm,
      child: const Text(
        'Simpan',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final hutang = HutangModel(
        id: const Uuid().v4(),
        nama: _namaController.text,
        jumlah: double.parse(_jumlahController.text),
        tanggal: DateTime.now().toIso8601String(),
        keterangan: _keteranganController.text,
        isMeminjam: widget.isMeminjam,
      );

      bool success = await _hutangService.tambahHutang(hutang);
      if (success) {
        widget.onDebtAdded(hutang);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan data'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }
}