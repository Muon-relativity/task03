
import '../entities/payment_request.dart';
import '../entities/payment_result.dart';
import '../repositories/payment_repository.dart';

class RequestPayment {
  final PaymentRepository repository;

  RequestPayment(this.repository);

  Future<PaymentResult> call(PaymentRequest request) {
    return repository.requestPayment(request);
  }
}