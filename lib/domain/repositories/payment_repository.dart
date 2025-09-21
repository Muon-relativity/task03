import 'package:task03/domain/entities/payment_result.dart';
import 'package:task03/domain/entities/payment_request.dart';

abstract class PaymentRepository {
  Future<PaymentResult> requestPayment(PaymentRequest request);
}