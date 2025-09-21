class PaymentRequest {
  final String provider;
  final int amount;
  final String orderId;

  PaymentRequest({
    required this.provider,
    required this.amount,
    required this.orderId,
  });
}