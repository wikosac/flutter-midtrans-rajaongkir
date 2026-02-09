part of 'address_search_bloc.dart';

abstract class AddressSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchAddressRequested extends AddressSearchEvent {
  final String query;

  SearchAddressRequested(this.query);

  @override
  List<Object> get props => [query];
}
