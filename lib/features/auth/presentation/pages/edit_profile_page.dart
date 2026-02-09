import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midtrans/features/shipping/domain/entities/destination.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Destination? _selectedAddress;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _nameController.text = authState.user.name;
      _phoneController.text = authState.user.phone ?? '';
      _selectedAddress = authState.user.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                  const SizedBox(height: 16),
                  _buildAddressField(context),
                  const SizedBox(height: 24),
                  _buildSaveButton(context, state),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await context.push<Destination>('/search-address');
        if (result != null) {
          setState(() {
            _selectedAddress = result;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Address',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
        child: Text(
          _selectedAddress == null ? 'Tap to search address' : _selectedAddress!.label ?? '',
          style: TextStyle(
            color: _selectedAddress == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, Authenticated state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _saveProfile(context, state),
        child: const Text('Save'),
      ),
    );
  }

  void _saveProfile(BuildContext context, Authenticated state) {
    final updatedUser = User(
      id: state.user.id,
      email: state.user.email,
      name: _nameController.text,
      phone: _phoneController.text,
      address: _selectedAddress,
    );
    context.read<AuthBloc>().add(UpdateProfileRequested(updatedUser));
    context.pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
