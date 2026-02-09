import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midtrans/features/shipping/domain/entities/destination.dart';
import 'package:go_router/go_router.dart';
import '../bloc/address_search_bloc.dart';

class SearchAddressPage extends StatefulWidget {
  const SearchAddressPage({super.key});

  @override
  State<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Address')),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search address...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onSubmitted: (query) => context.read<AddressSearchBloc>().add(SearchAddressRequested(query)),
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildResultsList() {
    return BlocConsumer<AddressSearchBloc, AddressSearchState>(
      listener: (context, state) {
        if (state is AddressSearchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AddressSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AddressSearchLoaded) {
          return ListView.builder(
            itemCount: state.destinations.length,
            itemBuilder: (context, index) => _buildDestinationItem(state.destinations[index]),
          );
        }
        return const Center(child: Text('Search for a destination'));
      },
    );
  }

  Widget _buildDestinationItem(Destination destination) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: Text(destination.label ?? ''),
      onTap: () => context.pop(destination),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
