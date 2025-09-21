import 'package:task03/domain/entities/payment_result.dart';
import 'package:task03/domain/entities/payment_request.dart';

import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_platform_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentPlatformDatasource datasource;

  PaymentRepositoryImpl(this.datasource);

  @override
  Future<PaymentResult> requestPayment(PaymentRequest request) {
    return datasource.requestPayment(request);
  }
}