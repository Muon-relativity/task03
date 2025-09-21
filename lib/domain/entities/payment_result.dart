import '../../presentation/cubit/payment_state.dart';

class PaymentResult {
  final PaymentStatus status;
  final String message;

  PaymentResult({required this.status, required this.message});
}