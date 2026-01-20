import 'package:flutter/material.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/Gallery/widget/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class PurchaseHistory extends StatelessWidget {
  const PurchaseHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<CartProvider>().history;

    return Scaffold(
      appBar: AppBar(title: const Text('Purchase History')),
      body:
          history.isEmpty
              ? const Center(child: Text('No purchases yet'))
              : ListView.builder(
                itemCount: history.length,
                itemBuilder:
                    (_, i) => ListTile(
                      leading: const Icon(Icons.image),
                      title: Text(history[i].album),
                      trailing: const Text(
                        'Paid',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
              ),
    );
  }
}
