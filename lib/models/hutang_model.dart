class HutangModel {
  final String id;
  final String nama;
  final double jumlah;
  final String tanggal;
  final String keterangan;
  final bool isMeminjam;

  HutangModel({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
    required this.isMeminjam,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'isMeminjam': isMeminjam,
    };
  }

  factory HutangModel.fromJson(Map<String, dynamic> json) {
    return HutangModel(
      id: json['id'],
      nama: json['nama'],
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      isMeminjam: json['isMeminjam'],
    );
  }
}