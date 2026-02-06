import 'package:demandium/utils/core_export.dart';

/// A small, square action tile used in Provider Details (Rate / Chat / Call).
///
/// - Production-ready: supports disabled state and uses theme colors.
/// - Responsive: width is controlled by parent (Wrap/Row).
class SquareActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const SquareActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool enabled = onTap != null;

    final Color iconColor = enabled ? theme.colorScheme.primary : theme.hintColor;
    final TextStyle labelStyle = robotoMedium.copyWith(
      fontSize: Dimensions.fontSizeSmall,
      color: enabled ? theme.textTheme.bodyMedium?.color : theme.hintColor,
    );

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
              color: theme.hintColor.withValues(alpha: 0.15),
            ),
            boxShadow: searchBoxShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
