import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shipping/domain/entities/destination.dart';
import '../../../shipping/domain/entities/shipping_service.dart';
import '../../../shipping/domain/repositories/shipping_repository.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/entities/payment_request.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ShippingRepository shippingRepository;
  final PaymentRepository paymentRepository;

  CheckoutBloc({
    required this.shippingRepository,
    required this.paymentRepository,
  }) : super(CheckoutState()) {
    on<InitializeCheckout>(_onInitializeCheckout);
    on<LoadShippingServices>(_onLoadShippingServices);
    on<SelectShippingService>(_onSelectShippingService);
    on<ProcessPayment>(_onProcessPayment);
  }

  void _onInitializeCheckout(
    InitializeCheckout event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(
      shippingName: event.name,
      shippingPhone: event.phone,
      shippingAddress: event.address,
    ));
  }

  Future<void> _onLoadShippingServices(
    LoadShippingServices event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isLoadingServices: true));
    final result = await shippingRepository.getShippingServices(
      shipperDestinationId: 17477,
      receiverDestinationId: event.receiverDestinationId,
      weight: 1,
      itemValue: event.itemValue,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingServices: false,
        errorMessage: failure.message,
      )),
      (services) => emit(state.copyWith(
        shippingServices: services,
        isLoadingServices: false,
        errorMessage: null,
      )),
    );
  }

  void _onSelectShippingService(
    SelectShippingService event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(selectedService: event.service));
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isProcessingPayment: true));
    final result = await paymentRepository.getSnapToken(event.request);
    result.fold(
      (failure) => emit(state.copyWith(
        isProcessingPayment: false,
        errorMessage: failure.message,
      )),
      (snapToken) => emit(state.copyWith(
        isProcessingPayment: false,
        orderId: event.request.transactionDetails.orderId,
        snapToken: snapToken,
        errorMessage: null,
      )),
    );
  }
}
