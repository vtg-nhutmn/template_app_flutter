import 'package:demo/app/router/app_routes.dart';
import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/core/di/injection_container.dart';
import 'package:demo/core/session/user_session_cubit.dart';
import 'package:demo/features/home/presentation/bloc/product_bloc.dart';
import 'package:demo/features/home/presentation/bloc/product_event.dart';
import 'package:demo/features/home/presentation/bloc/product_state.dart';
import 'package:demo/features/home/presentation/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductBloc>()..add(const ProductsLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: () =>
                context.read<ProductBloc>().add(const ProductsLoadRequested()),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<UserSessionCubit, UserSessionState>(
        builder: (context, sessionState) {
          if (sessionState.isAdmin) {
            return FloatingActionButton(
              tooltip: 'Thêm sản phẩm',
              onPressed: () async {
                final added = await context.push<bool>(AppRoutes.addProduct);
                if (added == true && context.mounted) {
                  context.read<ProductBloc>().add(
                    const ProductsLoadRequested(),
                  );
                }
              },
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ProductBloc>().add(
                        const ProductsLoadRequested(),
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text(
                  'Chưa có sản phẩm nào',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  ProductCardWidget(product: state.products[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
