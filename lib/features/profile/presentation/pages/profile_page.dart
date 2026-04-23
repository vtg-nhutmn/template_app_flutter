import 'package:architecture/app/theme/app_colors.dart';
import 'package:architecture/core/di/injection_container.dart';
import 'package:architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:architecture/features/auth/presentation/bloc/auth_event.dart';
import 'package:architecture/features/profile/domain/entities/profile_entity.dart';
import 'package:architecture/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:architecture/features/profile/presentation/bloc/profile_event.dart';
import 'package:architecture/features/profile/presentation/bloc/profile_state.dart';
import 'package:architecture/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:architecture/features/profile/presentation/widgets/profile_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()..add(ProfileLoadRequested()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
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
                      onPressed: () => context.read<ProfileBloc>().add(
                        ProfileLoadRequested(),
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ProfileLoaded) {
            return _ProfileContent(profile: state.profile);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileEntity profile;

  const _ProfileContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ProfileAvatarWidget(name: profile.name),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x1A1E6B3C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              profile.role.name,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin tài khoản',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileInfoCardWidget(
                    label: 'Tên đăng nhập',
                    value: profile.username,
                    icon: Icons.person_outline,
                  ),
                  ProfileInfoCardWidget(
                    label: 'Họ và tên',
                    value: profile.name,
                    icon: Icons.badge_outlined,
                  ),
                  ProfileInfoCardWidget(
                    label: 'Email',
                    value: profile.email,
                    icon: Icons.email_outlined,
                  ),
                  ProfileInfoCardWidget(
                    label: 'Số điện thoại',
                    value: profile.phone ?? 'Chưa cập nhật',
                    icon: Icons.phone_outlined,
                  ),
                  ProfileInfoCardWidget(
                    label: 'Mã nhân viên',
                    value: profile.code,
                    icon: Icons.qr_code_outlined,
                  ),
                  ProfileInfoCardWidget(
                    label: 'Trạng thái',
                    value: profile.isActive
                        ? 'Đang hoạt động'
                        : 'Ngừng hoạt động',
                    icon: Icons.circle_outlined,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quyền hạn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${profile.role.permissions.length} quyền được cấp',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.role.permissions
                        .take(12)
                        .map(
                          (p) => Chip(
                            label: Text(
                              p,
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor: const Color(0x141E6B3C),
                            side: BorderSide.none,
                            padding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
                  ),
                  if (profile.role.permissions.length > 12) ...[
                    const SizedBox(height: 8),
                    Text(
                      '... và ${profile.role.permissions.length - 12} quyền khác',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
