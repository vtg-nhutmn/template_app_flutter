import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/features/home/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    File? imageFile,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Không thể tải danh sách sản phẩm: $e');
    }
  }

  @override
  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    File? imageFile,
  }) async {
    try {
      String? imageData;
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        imageData = base64Encode(bytes);
      }

      final data = <String, dynamic>{
        'name': name,
        'description': description,
        'price': price,
        'imageData': imageData,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('products').add(data);
    } catch (e) {
      throw ServerException(message: 'Không thể thêm sản phẩm: $e');
    }
  }
}
