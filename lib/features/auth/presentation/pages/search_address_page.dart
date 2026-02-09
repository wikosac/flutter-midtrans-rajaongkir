import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_midtrans/features/shipping/data/datasources/rajaongkir_remote_data_source.dart';
import 'package:flutter_midtrans/features/shipping/data/repositories/shipping_repository_impl.dart';
import 'package:flutter_midtrans/features/shipping/domain/entities/destination.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class SearchAddressPage extends StatefulWidget {
  const SearchAddressPage({super.key});

  @override
  State<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  final _searchController = TextEditingController();
  List<Destination> _destinations = [];
  bool _isLoading = false;
  late final ShippingRepositoryImpl _repository;

  @override
  void initState() {
    super.initState();
    final dataSource = RajaOngkirRemoteDataSourceImpl(client: http.Client());
    _repository = ShippingRepositoryImpl(remoteDataSource: dataSource);
  }

  void _searchDestinations(String query) async {
    if (query.isEmpty || query.length < 3) {
      setState(() {
        _destinations = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _repository.searchDestinations(query.trim());

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        }
      },
      (destinations) {
        log('destinations: ${destinations[0]}');
        setState(() {
          _destinations = destinations;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Address')),
      body: Column(
        children: [
          Padding(
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
              onSubmitted: _searchDestinations,
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _destinations.isEmpty
                ? const Center(child: Text('Search for a destination'))
                : ListView.builder(
                    itemCount: _destinations.length,
                    itemBuilder: (context, index) {
                      final destination = _destinations[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(destination.label ?? ''),
                        onTap: () => context.pop(destination),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
