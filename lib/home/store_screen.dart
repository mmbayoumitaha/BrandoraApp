import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsData>(context);
    final materialsData = Provider.of<MaterialsData>(context, listen: false);
    final products = productsData.products;
    const Color primaryColor = Color(0xFF3F51B5);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: const Text("Brandora Store", 
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: products.isEmpty
            ? const Center(child: Text("No products in store yet!"))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Center(
                    child: Container(
                      // صغرنا العرض لـ 75% عشان الكارت يلم نفسه ويبان أصغر
                      width: MediaQuery.of(context).size.width * 0.75, 
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04), 
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. الصورة بمساحة أصغر (1.2 تقريباً) عشان تاخد مساحة أقل بالطول
                          AspectRatio(
                            aspectRatio: 1.2, 
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FF),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                image: product.imagePath != null
                                    ? DecorationImage(
                                        image: FileImage(File(product.imagePath!)),
                                        fit: BoxFit.cover)
                                    : null,
                              ),
                              child: product.imagePath == null
                                  ? const Icon(Icons.shopping_bag_outlined, 
                                      color: primaryColor, size: 40)
                                  : null,
                            ),
                          ),
                          
                          // 2. البيانات مضغوطة (Padding أقل)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${product.price}",
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text("Qty: ${product.quantity}",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    // زر حذف صغير وغير مأخد مساحة
                                    GestureDetector(
                                      onTap: () => _showDeleteDialog(
                                          context, product, productsData, materialsData),
                                      child: const Icon(Icons.delete_outline, 
                                          color: Colors.redAccent, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductModel product,
      ProductsData productsData, MaterialsData materialsData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Product?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              double prodQty = double.tryParse(product.quantity) ?? 0.0;
              for (var item in product.usedMaterials) {
                List<String> parts = item.split(" - ");
                if (parts.length >= 2) {
                  materialsData.returnMaterial(parts[0], prodQty * (double.tryParse(parts[1]) ?? 0.0));
                }
              }
              productsData.removeProduct(product);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}