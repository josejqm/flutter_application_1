import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/error/failures.dart';
import 'package:flutter_application_1/src/dependencies_injector.dart';
import 'package:flutter_application_1/src/domain/entities/entities.dart';
import 'package:flutter_application_1/src/presentation/blocs/notario_info_cubit/notario_info_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotarioInfoCubit(injector()..getNotariosInfo()),
      child: const _HomePageVIew(),
    );
  }
}

class _HomePageVIew extends StatelessWidget {
  const _HomePageVIew({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notario'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<NotarioInfoCubit, NotarioInfoCubitState>(
            builder: (context, state) {
              return state.when(
                loading: () => const _LoadingIndicator(),
                data: (notariosInfo) =>
                    _NotariosDataView(notariosInfo: notariosInfo),
                noData: () => const _NoDataVIew(),
                error: (failure) => _ErrorView(
                  failure: failure,
                ),
              );
            },
          ),
        ));
  }
}

class _NotariosDataView extends StatelessWidget {
  const _NotariosDataView({
    Key? key,
    required this.notariosInfo,
  }) : super(key: key);

  final List<NotarioInfoEntity> notariosInfo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: notariosInfo
          .map((info) => Card(
                child: ListView(
                    children: info.notariosList
                        .map(
                          (notario) => Column(
                            children: [
                              Text(notario.id),
                              Expanded(
                                child: ListView(
                                    children: notario.texts
                                        .map(
                                          (e) => ListTile(
                                            title: Text(e.text),
                                          ),
                                        )
                                        .toList()),
                              ),
                            ],
                          ),
                        )
                        .toList()),
              ))
          .toList(),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    Key? key,
    required this.failure,
  }) : super(key: key);

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(failure.toString()),
    );
  }
}

class _NoDataVIew extends StatelessWidget {
  const _NoDataVIew({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No data'),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}