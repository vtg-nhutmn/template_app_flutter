import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/core/utils/validators.dart';
import 'package:demo/core/widgets/app_text_field.dart';
import 'package:demo/features/profile/domain/entities/profile_entity.dart';
import 'package:demo/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:demo/features/profile/presentation/bloc/edit_profile_event.dart';
import 'package:demo/features/profile/presentation/bloc/edit_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatelessWidget {
  final ProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<EditProfileBloc>(),
      child: _EditProfileView(profile: profile),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  final ProfileEntity profile;

  const _EditProfileView({required this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
          );
          context.pop(true);
        } else if (state is EditProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Chỉnh sửa thông tin')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _ProfileInfoSection(profile: profile),
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoSection extends StatefulWidget {
  final ProfileEntity profile;

  const _ProfileInfoSection({required this.profile});

  @override
  State<_ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<_ProfileInfoSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.profile.displayName,
    );
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final displayName = _displayNameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();

      final unchanged =
          displayName == widget.profile.displayName &&
          phone == (widget.profile.phone ?? '') &&
          email == widget.profile.email;

      if (unchanged) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không có thông tin nào thay đổi')),
        );
        return;
      }

      context.read<EditProfileBloc>().add(
        EditProfileSubmitted(
          displayName: displayName,
          phone: phone,
          email: email,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        final isLoading = state is EditProfileLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin cá nhân',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _displayNameController,
                    labelText: 'Họ và tên',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                    validator: Validators.validateFullName,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _phoneController,
                    labelText: 'Số điện thoại',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    enabled: !isLoading,
                    validator: Validators.validateEmail,
                    helperText:
                        'Đổi email sẽ gửi link xác nhận đến địa chỉ mới',
                    helperMaxLines: 2,
                    onFieldSubmitted: (_) => _onSubmit(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onSubmit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Lưu thông tin'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
