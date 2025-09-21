import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/payment_request.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../../domain/entities/payment_provider.dart';

class PaymentHomePage extends StatelessWidget {
  const PaymentHomePage({super.key});

  final List<PaymentProvider> providers = const [
    PaymentProvider('토스', 'toss', Icons.account_balance_wallet, Colors.blue),
    PaymentProvider('페이코', 'payco', Icons.payment, Colors.red),
    PaymentProvider('카카오페이', 'kakaopay', Icons.monetization_on, Colors.yellow),
    PaymentProvider('기타', 'etc', Icons.credit_card, Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('외부 결제앱 연동 데모')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(24),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1,
              children: providers.map((provider) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('결제 처리중...', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      );
                      await context.read<PaymentCubit>().pay(
                        PaymentRequest(
                          provider: provider.key,
                          amount: 10000,
                          orderId: 'ORDER123',
                        ),
                      );
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(provider.icon, color: provider.color, size: 48),
                          const SizedBox(height: 12),
                          Text(provider.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              return _buildStatusCard(state.status, state.message);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatusCard(PaymentStatus status, String message) {
    IconData icon;
    Color color;

    switch (status) {
      case PaymentStatus.success:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case PaymentStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.orange;
        break;
      case PaymentStatus.notInstalled:
        icon = Icons.error;
        color = Colors.red;
        break;
      case PaymentStatus.failed:
      case PaymentStatus.error:
        icon = Icons.warning;
        color = Colors.redAccent;
        break;
      case PaymentStatus.processing:
        icon = Icons.hourglass_top;
        color = Colors.blueGrey;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 36),
        title: Text('상태: ${status.label}\n메시지: $message', style: TextStyle(fontSize: 16, color: color)),
      ),
    );
  }
}
