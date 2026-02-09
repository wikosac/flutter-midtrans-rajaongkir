import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shipping/domain/entities/destination.dart';
import '../../../shipping/domain/repositories/shipping_repository.dart';

part 'address_search_event.dart';
part 'address_search_state.dart';

class AddressSearchBloc extends Bloc<AddressSearchEvent, AddressSearchState> {
  final ShippingRepository repository;

  AddressSearchBloc({required this.repository}) : super(AddressSearchInitial()) {
    on<SearchAddressRequested>(_onSearchAddressRequested);
  }

  Future<void> _onSearchAddressRequested(
    SearchAddressRequested event,
    Emitter<AddressSearchState> emit,
  ) async {
    if (event.query.isEmpty || event.query.length < 3) {
      emit(AddressSearchInitial());
      return;
    }

    emit(AddressSearchLoading());
    final result = await repository.searchDestinations(event.query.trim());
    result.fold(
      (failure) => emit(AddressSearchError(failure.message)),
      (destinations) => emit(AddressSearchLoaded(destinations)),
    );
  }
}
