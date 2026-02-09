import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_form_bloc.dart';
import 'features/auth/presentation/bloc/address_search_bloc.dart';

import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/bloc/product_detail_bloc.dart';

import 'features/cart/data/datasources/cart_remote_data_source.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

import 'features/payment/data/datasources/payment_remote_data_source.dart';
import 'features/payment/data/repositories/payment_repository_impl.dart';
import 'features/payment/domain/repositories/payment_repository.dart';
import 'features/payment/presentation/bloc/checkout_bloc.dart';

import 'features/orders/data/datasources/order_remote_data_source.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';

import 'features/shipping/data/datasources/rajaongkir_remote_data_source.dart';
import 'features/shipping/data/repositories/shipping_repository_impl.dart';
import 'features/shipping/domain/repositories/shipping_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl(), signIn: sl()));
  sl.registerFactory(() => AuthFormBloc());
  sl.registerFactory(() => AddressSearchBloc(repository: sl()));
  sl.registerFactory(() => ProductBloc(repository: sl()));
  sl.registerFactory(() => ProductDetailBloc(repository: sl()));
  sl.registerFactory(() => CartBloc(remoteDataSource: sl()));
  sl.registerFactory(() => OrderBloc(repository: sl()));
  sl.registerFactory(() => CheckoutBloc(
        shippingRepository: sl(),
        paymentRepository: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ShippingRepository>(
    () => ShippingRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<RajaOngkirRemoteDataSource>(
    () => RajaOngkirRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => http.Client());
}
