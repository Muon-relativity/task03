import 'package:flutter/services.dart';
import '../../domain/entities/payment_result.dart';
import '../../presentation/cubit/payment_state.dart';
import '../../domain/entities/payment_request.dart';

class PaymentPlatformDatasource {
  static const platform = MethodChannel('com.example.payment/bridge');

  Future<PaymentResult> requestPayment(PaymentRequest request) async {
    try {
      final result = await platform.invokeMethod('openPaymentApp', {
        'provider': request.provider,
        'amount': request.amount,
        'orderId': request.orderId,
      });
      return PaymentResult(
        status: paymentStatusFromString(result['status']),
        message: result['message'],
      );
    } on PlatformException catch (e) {
      return PaymentResult(
        status: PaymentStatus.error,
        message: e.message ?? 'Unknown error',
      );
    }
  }
}
