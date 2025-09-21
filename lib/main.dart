import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/payment_platform_datasource.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'domain/usecases/request_payment.dart';
import 'presentation/cubit/payment_cubit.dart';
import 'presentation/pages/payment_home_page.dart';

void main() {
  final datasource = PaymentPlatformDatasource();
  final repository = PaymentRepositoryImpl(datasource);
  final requestPayment = RequestPayment(repository);

  runApp(
    BlocProvider(
      create: (_) => PaymentCubit(requestPayment),
      child: MaterialApp(
        title: 'Intent Payment Demo',
        home: PaymentHomePage(),
      ),
    ),
  );
}