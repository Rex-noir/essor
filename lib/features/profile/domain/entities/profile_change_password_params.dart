class ProfileChangePasswordParams {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ProfileChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}
