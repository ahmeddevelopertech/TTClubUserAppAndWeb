/// Helper class to handle user type display and conversion
class UserTypeHelper {
  /// Get readable name for user type
  static String getReadableUserType(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'lawyers':
        return '(محامي)';
      case 'companies':
        return '(شركة)';
      case 'individuals_membership':
        return '(عضو)';
      case 'club_delegate':
        return '(منتدب نادي)';
      case 'legal_sponsorship':
        return '(رعاية قانونية)';
      default:
        return '';
    }
  }

  /// Get user type with name format: "Name (Type)"
  static String getUserDisplayName({
    required String? firstName,
    required String? lastName,
    required String? userType,
  }) {
    final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    final typeDisplay = getReadableUserType(userType);
    return typeDisplay.isEmpty ? name : '$name $typeDisplay';
  }
}

