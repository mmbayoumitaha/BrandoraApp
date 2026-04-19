// data.dart
import 'package:flutter/material.dart';

// نموذج بيانات المادة
class MaterialModel {
  String name;
  String quantity;
  String unit;
  String price;

  MaterialModel({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.price,
  });
}

// كلاس مركزى لإدارة المواد وإشعار التغييرات
// data.dart

class MaterialsData extends ChangeNotifier {
  final List<MaterialModel> _materials = [];

  List<MaterialModel> get materials => _materials;

  void addMaterial(MaterialModel newMaterial) {
    // البحث عن مادة موجودة بنفس الاسم ونفس الوحدة
    // (استخدمنا lowercase عشان نتفادى مشاكل الحروف الكبيرة والصغيرة)
    int existingIndex = _materials.indexWhere((m) => 
      m.name.trim().toLowerCase() == newMaterial.name.trim().toLowerCase() && 
      m.unit == newMaterial.unit
    );

    if (existingIndex != -1) {
      // 1. لو موجودة: نحدث الكمية والسعر
      // تحويل النصوص لأرقام عشان نجمع الكميات
      //double oldQty = double.tryParse(_materials[existingIndex].quantity) ?? 0;
      double addedQty = double.tryParse(newMaterial.quantity) ?? 0;
      
      _materials[existingIndex].quantity = addedQty.toString();
      _materials[existingIndex].price = newMaterial.price; // تحديث السعر لآخر سعر مضاف
    } else {
      // 2. لو مش موجودة: نضيفها كعنصر جديد
      _materials.add(newMaterial);
    }
    
    notifyListeners(); // تحديث كل الشاشات
  }

  // دالة لتعديل مادة معينة بالكامل (لو حبيتي تعدلي يدوياً من UI)
  void updateMaterial(int index, MaterialModel updatedMaterial) {
    _materials[index] = updatedMaterial;
    notifyListeners();
  }

  void removeMaterial(int index) {
    _materials.removeAt(index);
    notifyListeners();
  }
  void updateExistingMaterial(int index, MaterialModel updatedMaterial) {
  _materials[index] = updatedMaterial;
  notifyListeners();
  }
  void returnMaterial(String name, double amount) {
  int index = _materials.indexWhere((m) => m.name.trim().toLowerCase() == name.trim().toLowerCase());
  if (index != -1) {
    double currentQty = double.tryParse(_materials[index].quantity) ?? 0.0;
    _materials[index].quantity = (currentQty + amount).toString();
    notifyListeners();
  }
}
  // ضيفي الدالة دي جوه كلاس MaterialsData
void deductMaterial(String name, double amount) {
  // بنبحث عن المادة بالاسم
  int index = _materials.indexWhere((m) => m.name.trim().toLowerCase() == name.trim().toLowerCase());
  
  if (index != -1) {
    double currentQty = double.tryParse(_materials[index].quantity) ?? 0.0;
    
    // الخصم: الكمية الجديدة = القديمة - المستخدمة
    double newQty = currentQty - amount;
    
    // لو الكمية بقت أقل من صفر، بنخليها صفر عشان ميبقاش فيه سوالب
    _materials[index].quantity = (newQty < 0 ? 0 : newQty).toString();
    
    notifyListeners(); // مهم جداً عشان يحدث شكل المخزن فوراً
  }
}
  List<String> getMaterialNames() {
    return _materials.map((m) => m.name).toList();
  }
}
class ProductModel {
  String name;
  String quantity;
  String price;
  String? imagePath; // تأكد أن المسار موجود هنا
  List<String> usedMaterials; 
  ProductModel({
    required this.name, 
    required this.quantity, 
    required this.price, 
    this.imagePath,
    this.usedMaterials = const [], // افتراضيًا قائمة فارغة
  });
}

class ProductsData extends ChangeNotifier {
  final List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  void addProduct(ProductModel product) {
    // بنبحث لو المنتج موجود بنفس الاسم
    int index = _products.indexWhere((p) => p.name.trim().toLowerCase() == product.name.trim().toLowerCase());
    
    if (index != -1) {
      // لو موجود: بنحدث الكمية والسعر والصورة (لو فيه صورة جديدة)
      double oldQty = double.tryParse(_products[index].quantity) ?? 0;
      double newQty = double.tryParse(product.quantity) ?? 0;
      
      _products[index].quantity = (oldQty + newQty).toString();
      _products[index].price = product.price;
      if (product.imagePath != null) {
        _products[index].imagePath = product.imagePath;
      }
    } else {
      // لو جديد: بنضيفه بالكامل
      _products.add(product);
    }
    notifyListeners();
  }
  void removeProduct(ProductModel product) {
    // بنستخدم removeWhere عشان نمسح أي منتج له نفس الاسم
    _products.removeWhere((p) => p.name == product.name);
    notifyListeners(); // دي أهم سطر عشان يخلي الشاشة تختفي منها البيانات فوراً
  }

// أضيفي هذه الدالة داخل كلاس MaterialsData في ملف data.dart لإرجاع الكميات

}


// أضيفي هذه الدالة داخل كلاس ProductsData في ملف data.dart
