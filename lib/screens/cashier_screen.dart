import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import '../core/models/product_model.dart';
import '../core/database/database_helper.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الاستماع للتغييرات في سلة المبيعات لتحديث الشاشة تلقائياً
    final cartController = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة الكاشير الذكية', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // زر تفريغ السلة بالكامل
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: cartController.cartItems.isEmpty 
                ? null 
                : () => cartController.clearCart(),
            tooltip: 'تفريغ السلة',
          )
        ],
      ),
      body: Column(
        children: [
          // 🚀 قسم المنتجات التجريبية (لمحاكاة قراءة الباركود بالكاميرا)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'اضغط على المنتج لمحاكاة قراءة الباركود عبر الكاميرا:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100, foregroundColor: Colors.orange.shade900),
                        icon: const Icon(Icons.local_drink),
                        label: const Text('بيبسي (3 ريال)'),
                        onPressed: () => _simulateBarcodeScan(context, '1', 'بيبسي بارد', '62810001', 3.0, 1.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100, foregroundColor: Colors.green.shade900),
                        icon: const Icon(Icons.bakery_dining),
                        label: const Text('خبز بر (1 ريال)'),
                        onPressed: () => _simulateBarcodeScan(context, '2', 'كيس خبز بر', '62810002', 1.0, 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🛒 قائمة السلة الحالية
          Expanded(
            child: cartController.cartItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'سلة المبيعات فارغة حالياً.\nاضغط على المنتجات بالأعلى لإضافتها!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('سعر القطعة: ${item.product.price} ريال | الإجمالي: ${item.totalPrice} ريال'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // زر إنقاص الكمية
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                                onPressed: () => cartController.removeOrDecreaseProduct(item.product),
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              // زر زيادة الكمية
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () => cartController.addProductToCart(item.product),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 💳 قسم إجمالي الحساب وإتمام البيع
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: const Offset(0, -3))],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('إجمالي المبيعات:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${cartController.totalAmount} ريال', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                      ),
                      onPressed: cartController.cartItems.isEmpty
                          ? null
                          : () async {
                              // إتمام البيع كاش وحفظ الفاتورة في قاعدة البيانات وخصم الكمية
                              final success = await cartController.checkout('كاش');
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🎉 تم حفظ الفاتورة بنجاح وخصم الكمية من المخزن!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                      child: const Text('إتمام البيع وحفظ الفاتورة (أوفلاين)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🪄 دالة محاكاة قراءة الباركود: تحفظ المنتج في قاعدة البيانات المحلية أولاً (إذا لم يكن موجوداً) ثم تضيفه للسلة
  Future<void> _simulateBarcodeScan(BuildContext context, String id, String name, String barcode, double price, double cost) async {
    final product = Product(
      id: id,
      name: name,
      barcode: barcode,
      price: price,
      cost: cost,
      stockQuantity: 100, // كمية ابتدائية في المخزن
      minStockLimit: 5,
    );

    // 1. حفظ المنتج في قاعدة البيانات المحلية
    await DatabaseHelper.instance.insertProduct(product);

    // 2. إضافته فوراً للسلة
    if (context.mounted) {
      Provider.of<CartController>(context, listen: false).addProductToCart(product);
    }
  }
}