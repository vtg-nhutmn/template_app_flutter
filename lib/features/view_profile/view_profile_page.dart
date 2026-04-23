import 'package:flutter/material.dart';
import 'package:vsa_model/core/spacings/app_spacings.dart';
import 'package:vsa_model/shared/widgets/app_button.dart';
import 'view_profile_notifier.dart';
import 'view_profile_state.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final _notifier = ViewProfileNotifier();

  @override
  void initState() {
    super.initState();
    _notifier.loadProfile();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ')),
      body: ListenableBuilder(
        listenable: _notifier,
        builder: (context, _) {
          final state = _notifier.state;

          if (state.status == ViewProfileStatus.loading ||
              state.status == ViewProfileStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ViewProfileStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Không tải được hồ sơ'),
                  const SizedBox(height: AppSpacings.v16),
                  AppButton(label: 'Thử lại', onPressed: _notifier.loadProfile),
                ],
              ),
            );
          }

          final profile = state.profile!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacings.h32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    child: Text(
                      profile.name.isNotEmpty
                          ? profile.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacings.v24),
                _InfoRow(label: 'Họ tên: ', value: profile.name),
                const SizedBox(height: AppSpacings.v12),
                _InfoRow(label: 'Tên đăng nhập: ', value: profile.username),
                const SizedBox(height: AppSpacings.v12),
                _InfoRow(label: 'Mã nhân viên: ', value: profile.code),
                const SizedBox(height: AppSpacings.v12),
                _InfoRow(label: 'Email: ', value: profile.email),
                const SizedBox(height: AppSpacings.v12),
                _InfoRow(label: 'Số điện thoại: ', value: profile.phone ?? '—'),
                const SizedBox(height: AppSpacings.v12),
                _InfoRow(label: 'Vai trò: ', value: profile.role.name),
                const SizedBox(height: AppSpacings.v12),
                _InfoRow(
                  label: 'Trạng thái',
                  value: profile.isActive ? 'Hoạt động' : 'Ngừng hoạt động',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: AppSpacings.h8),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
