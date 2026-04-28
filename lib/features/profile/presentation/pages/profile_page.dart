import 'package:demo/app/router/app_routes.dart';
import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/features/profile/domain/entities/profile_entity.dart';
import 'package:demo/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:demo/features/profile/presentation/bloc/profile_event.dart';
import 'package:demo/features/profile/presentation/bloc/profile_state.dart';
import 'package:demo/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:demo/features/profile/presentation/widgets/profile_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return _ProfileView(onLogout: onLogout);
  }
}

class _ProfileView extends StatelessWidget {
  final VoidCallback onLogout;

  const _ProfileView({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Chỉnh sửa',
                  onPressed: () async {
                    final result = await context.push<bool>(
                      AppRoutes.editProfile,
                      extra: state.profile,
                    );
                    if (result == true && context.mounted) {
                      context.read<ProfileBloc>().add(ProfileLoadRequested());
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: onLogout,
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
          ProfileAvatarWidget(name: profile.displayName),
          const SizedBox(height: 16),
          Text(
            profile.displayName,
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
              profile.isActive ? 'Đang hoạt động' : 'Ngừng hoạt động',
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
                    value: profile.displayName,
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
                    label: 'Ngày tạo',
                    value: profile.createdAt.isNotEmpty
                        ? profile.createdAt.substring(0, 10)
                        : 'Không rõ',
                    icon: Icons.calendar_today_outlined,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline, color: AppColors.primary),
              title: const Text('Đổi mật khẩu'),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
              onTap: () => context.push(AppRoutes.changePassword),
            ),
          ),
          // if (profile.role) ...[
          //   const SizedBox(height: 12),
          //   Card(
          //     child: ListTile(
          //       leading: const Icon(
          //         Icons.campaign_outlined,
          //         color: AppColors.primary,
          //       ),
          //       title: const Text('Gửi thông báo'),
          //       subtitle: const Text('Gửi broadcast đến tất cả người dùng'),
          //       trailing: const Icon(
          //         Icons.chevron_right,
          //         color: AppColors.textSecondary,
          //       ),
          //       onTap: () => context.push(AppRoutes.broadcastNotification),
          //     ),
          //   ),
          // ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
