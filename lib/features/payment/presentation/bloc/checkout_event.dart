part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeCheckout extends CheckoutEvent {
  final String name;
  final String phone;
  final Destination? address;

  InitializeCheckout({required this.name, required this.phone, this.address});

  @override
  List<Object?> get props => [name, phone, address];
}

class LoadShippingServices extends CheckoutEvent {
  final int receiverDestinationId;
  final double itemValue;

  LoadShippingServices({
    required this.receiverDestinationId,
    required this.itemValue,
  });

  @override
  List<Object> get props => [receiverDestinationId, itemValue];
}

class SelectShippingService extends CheckoutEvent {
  final ShippingService service;

  SelectShippingService(this.service);

  @override
  List<Object> get props => [service];
}

class ProcessPayment extends CheckoutEvent {
  final PaymentRequest request;

  ProcessPayment(this.request);

  @override
  List<Object> get props => [request];
}
