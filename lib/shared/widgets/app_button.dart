import 'package:flutter/material.dart';
import 'package:vsa_model/core/spacings/app_spacings.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacings.h56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: AppSpacings.h20,
                width: AppSpacings.h20,
                child: CircularProgressIndicator(
                  strokeWidth: AppSpacings.h4,
                  color: Colors.white,
                ),
              )
            : Center(child: Text(label)),
      ),
    );
  }
}
