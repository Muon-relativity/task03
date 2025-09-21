import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/payment_request.dart';
import 'payment_state.dart';
import '../../domain/usecases/request_payment.dart';
import '../../domain/entities/payment_result.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final RequestPayment requestPayment;

  PaymentCubit(this.requestPayment) : super(PaymentState.initial());

  Future<void> pay(PaymentRequest request) async {
    emit(const PaymentState(status: PaymentStatus.processing, message: ''));
    final PaymentResult result = await requestPayment.call(request);
    emit(PaymentState(status: result.status, message: result.message));
  }
}