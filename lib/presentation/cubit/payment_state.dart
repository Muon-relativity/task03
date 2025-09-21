enum PaymentStatus {
  initial,
  processing,
  success,
  cancelled,
  notInstalled,
  failed,
  error,
}

extension PaymentStatusExtension on PaymentStatus {
  int get code => index;
  String get label {
    switch (this) {
      case PaymentStatus.success: return '성공';
      case PaymentStatus.cancelled: return '취소됨';
      case PaymentStatus.notInstalled: return '미설치';
      case PaymentStatus.failed: return '실패';
      case PaymentStatus.error: return '오류';
      case PaymentStatus.processing: return '처리중';
      case PaymentStatus.initial: // 명확하게 지정
      default: return '초기';
    }
  }
}

PaymentStatus paymentStatusFromString(String status) {
  switch (status) {
    case 'success':
      return PaymentStatus.success;
    case 'cancelled':
      return PaymentStatus.cancelled;
    case 'not_installed':
      return PaymentStatus.notInstalled;
    case 'failed':
      return PaymentStatus.failed;
    case 'error':
      return PaymentStatus.error;
    case 'processing':
      return PaymentStatus.processing;
    default:
      return PaymentStatus.initial; // 일관성 있게 변경
  }
}

class PaymentState {
  final PaymentStatus status;
  final String message;

  const PaymentState({required this.status, required this.message});

  factory PaymentState.initial() =>
      const PaymentState(status: PaymentStatus.initial, message: '');
}