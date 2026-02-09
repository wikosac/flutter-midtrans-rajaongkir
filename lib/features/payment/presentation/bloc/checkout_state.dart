part of 'checkout_bloc.dart';

class CheckoutState extends Equatable {
  final String shippingName;
  final String shippingPhone;
  final Destination? shippingAddress;
  final List<ShippingService> shippingServices;
  final ShippingService? selectedService;
  final bool isLoadingServices;
  final bool isProcessingPayment;
  final String? orderId;
  final String? snapToken;
  final String? errorMessage;

  const CheckoutState({
    this.shippingName = '',
    this.shippingPhone = '',
    this.shippingAddress,
    this.shippingServices = const [],
    this.selectedService,
    this.isLoadingServices = false,
    this.isProcessingPayment = false,
    this.orderId,
    this.snapToken,
    this.errorMessage,
  });

  CheckoutState copyWith({
    String? shippingName,
    String? shippingPhone,
    Destination? shippingAddress,
    List<ShippingService>? shippingServices,
    ShippingService? selectedService,
    bool? isLoadingServices,
    bool? isProcessingPayment,
    String? orderId,
    String? snapToken,
    String? errorMessage,
  }) {
    return CheckoutState(
      shippingName: shippingName ?? this.shippingName,
      shippingPhone: shippingPhone ?? this.shippingPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingServices: shippingServices ?? this.shippingServices,
      selectedService: selectedService ?? this.selectedService,
      isLoadingServices: isLoadingServices ?? this.isLoadingServices,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      orderId: orderId,
      snapToken: snapToken,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        shippingName,
        shippingPhone,
        shippingAddress,
        shippingServices,
        selectedService,
        isLoadingServices,
        isProcessingPayment,
        orderId,
        snapToken,
        errorMessage,
      ];
}
