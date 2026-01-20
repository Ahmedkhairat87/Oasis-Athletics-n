import 'package:flutter/material.dart';

/// =======================
/// PHOTO ITEM MODEL
/// =======================
class PhotoItem {
  final String id; // photo serNo
  final String album; // eventSer
  final double price;

  PhotoItem({required this.id, required this.album, required this.price});
}

/// =======================
/// CART PROVIDER
/// =======================
class CartProvider extends ChangeNotifier {
  /// Local cart (for checkout screen only)
  final List<PhotoItem> _cart = [];

  /// Checkout history (optional, local)
  final List<PhotoItem> _history = [];

  /// 🔥 Requested count from backend (SOURCE OF TRUTH)
  int _requestedCount = 0;

  /// =======================
  /// GETTERS
  /// =======================
  List<PhotoItem> get cart => List.unmodifiable(_cart);
  List<PhotoItem> get history => List.unmodifiable(_history);

  int get requestedCount => _requestedCount;

  double get total => _cart.fold(0.0, (sum, item) => sum + item.price);

  /// =======================
  /// BACKEND SYNC
  /// =======================

  /// Call this AFTER:
  /// - request photo
  /// - cancel photo
  /// - loading gallery albums
  void setRequestedCount(int count) {
    _requestedCount = count;
    notifyListeners();
  }

  /// =======================
  /// CART ACTIONS (LOCAL)
  /// =======================

  void addToCart(PhotoItem item) {
    if (_cart.any((e) => e.id == item.id)) return;
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void checkout() {
    _history.addAll(_cart);
    _cart.clear();
    notifyListeners();
  }

  /// =======================
  /// UTILITIES
  /// =======================

  bool isInCart(String photoId) {
    return _cart.any((e) => e.id == photoId);
  }

  void reset() {
    _cart.clear();
    _history.clear();
    _requestedCount = 0;
    notifyListeners();
  }
}
