import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hutang_model.dart';
import '../utils/shared_preferences_keys.dart';

class HutangService {
  // Singleton pattern
  static final HutangService _instance = HutangService._internal();
  factory HutangService() => _instance;
  HutangService._internal();

  // Create
  Future<bool> tambahHutang(HutangModel hutang) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<HutangModel> hutangList = await getSemuaHutang();
      
      // Add new hutang
      hutangList.add(hutang);
      
      // Update totals
      double totalMeminjam = prefs.getDouble(SharedPreferencesKeys.totalMeminjamKey) ?? 0;
      double totalDipinjam = prefs.getDouble(SharedPreferencesKeys.totalDipinjamKey) ?? 0;

      if (hutang.isMeminjam) {
        totalMeminjam += hutang.jumlah;
      } else {
        totalDipinjam += hutang.jumlah;
      }

      // Save updated data
      await prefs.setString(
        SharedPreferencesKeys.hutangListKey,
        json.encode(hutangList.map((h) => h.toJson()).toList()),
      );
      await prefs.setDouble(SharedPreferencesKeys.totalMeminjamKey, totalMeminjam);
      await prefs.setDouble(SharedPreferencesKeys.totalDipinjamKey, totalDipinjam);
      await prefs.setString(SharedPreferencesKeys.lastUpdatedKey, DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      print('Error menambah hutang: $e');
      return false;
    }
  }

  // Read
  Future<List<HutangModel>> getSemuaHutang() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? hutangString = prefs.getString(SharedPreferencesKeys.hutangListKey);
      
      if (hutangString == null || hutangString.isEmpty) {
        return [];
      }

      List<dynamic> hutangJson = json.decode(hutangString);
      return hutangJson.map((json) => HutangModel.fromJson(json)).toList();
    } catch (e) {
      print('Error mengambil data hutang: $e');
      return [];
    }
  }

  // Update
  Future<bool> updateHutang(HutangModel updatedHutang) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<HutangModel> hutangList = await getSemuaHutang();
      
      int index = hutangList.indexWhere((h) => h.id == updatedHutang.id);
      if (index != -1) {
        // Update totals
        double totalMeminjam = prefs.getDouble(SharedPreferencesKeys.totalMeminjamKey) ?? 0;
        double totalDipinjam = prefs.getDouble(SharedPreferencesKeys.totalDipinjamKey) ?? 0;

        if (hutangList[index].isMeminjam) {
          totalMeminjam -= hutangList[index].jumlah;
        } else {
          totalDipinjam -= hutangList[index].jumlah;
        }

        if (updatedHutang.isMeminjam) {
          totalMeminjam += updatedHutang.jumlah;
        } else {
          totalDipinjam += updatedHutang.jumlah;
        }

        hutangList[index] = updatedHutang;

        // Save updated data
        await prefs.setString(
          SharedPreferencesKeys.hutangListKey,
          json.encode(hutangList.map((h) => h.toJson()).toList()),
        );
        await prefs.setDouble(SharedPreferencesKeys.totalMeminjamKey, totalMeminjam);
        await prefs.setDouble(SharedPreferencesKeys.totalDipinjamKey, totalDipinjam);
        await prefs.setString(SharedPreferencesKeys.lastUpdatedKey, DateTime.now().toIso8601String());

        return true;
      }
      return false;
    } catch (e) {
      print('Error mengupdate hutang: $e');
      return false;
    }
  }

  // Delete
  Future<bool> hapusHutang(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<HutangModel> hutangList = await getSemuaHutang();
      
      // Find hutang to delete
      int index = hutangList.indexWhere((h) => h.id == id);
      if (index != -1) {
        // Update totals
        double totalMeminjam = prefs.getDouble(SharedPreferencesKeys.totalMeminjamKey) ?? 0;
        double totalDipinjam = prefs.getDouble(SharedPreferencesKeys.totalDipinjamKey) ?? 0;

        if (hutangList[index].isMeminjam) {
          totalMeminjam -= hutangList[index].jumlah;
        } else {
          totalDipinjam -= hutangList[index].jumlah;
        }

        hutangList.removeAt(index);

        // Save updated data
        await prefs.setString(
          SharedPreferencesKeys.hutangListKey,
          json.encode(hutangList.map((h) => h.toJson()).toList()),
        );
        await prefs.setDouble(SharedPreferencesKeys.totalMeminjamKey, totalMeminjam);
        await prefs.setDouble(SharedPreferencesKeys.totalDipinjamKey, totalDipinjam);
        await prefs.setString(SharedPreferencesKeys.lastUpdatedKey, DateTime.now().toIso8601String());

        return true;
      }
      return false;
    } catch (e) {
      print('Error menghapus hutang: $e');
      return false;
    }
  }

  // Get Totals
  Future<Map<String, double>> getTotals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'totalMeminjam': prefs.getDouble(SharedPreferencesKeys.totalMeminjamKey) ?? 0,
        'totalDipinjam': prefs.getDouble(SharedPreferencesKeys.totalDipinjamKey) ?? 0,
      };
    } catch (e) {
      print('Error mengambil total: $e');
      return {
        'totalMeminjam': 0,
        'totalDipinjam': 0,
      };
    }
  }

  // Clear All Data
  Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferencesKeys.hutangListKey);
      await prefs.remove(SharedPreferencesKeys.totalMeminjamKey);
      await prefs.remove(SharedPreferencesKeys.totalDipinjamKey);
      await prefs.setString(SharedPreferencesKeys.lastUpdatedKey, DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      print('Error menghapus semua data: $e');
      return false;
    }
  }
}