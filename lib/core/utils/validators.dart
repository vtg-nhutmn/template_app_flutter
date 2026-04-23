class Validators {
  Validators._();

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên đăng nhập không được để trống';
    }
    if (value.trim().length < 3) {
      return 'Tên đăng nhập ít nhất 3 ký tự';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu ít nhất 6 ký tự';
    }
    return null;
  }
}
