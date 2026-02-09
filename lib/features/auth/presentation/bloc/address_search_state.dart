part of 'address_search_bloc.dart';

abstract class AddressSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddressSearchInitial extends AddressSearchState {}

class AddressSearchLoading extends AddressSearchState {}

class AddressSearchLoaded extends AddressSearchState {
  final List<Destination> destinations;

  AddressSearchLoaded(this.destinations);

  @override
  List<Object> get props => [destinations];
}

class AddressSearchError extends AddressSearchState {
  final String message;

  AddressSearchError(this.message);

  @override
  List<Object> get props => [message];
}
