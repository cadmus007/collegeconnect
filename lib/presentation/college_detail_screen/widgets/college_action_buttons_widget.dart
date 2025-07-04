import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CollegeActionButtonsWidget extends StatelessWidget {
  final bool isFavorite;
  final bool isInCompareList;
  final VoidCallback onApplyPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onComparePressed;

  const CollegeActionButtonsWidget({
    super.key,
    required this.isFavorite,
    required this.isInCompareList,
    required this.onApplyPressed,
    required this.onFavoritePressed,
    required this.onComparePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onApplyPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'send',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Apply Now',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: OutlinedButton(
              onPressed: onFavoritePressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: isFavorite
                    ? Colors.red
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                side: BorderSide(
                  color: isFavorite
                      ? Colors.red
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 1.5,
                ),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: isFavorite ? 'favorite' : 'favorite_border',
                    color: isFavorite
                        ? Colors.red
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Favorite',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isFavorite
                          ? Colors.red
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: OutlinedButton(
              onPressed: onComparePressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: isInCompareList
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                side: BorderSide(
                  color: isInCompareList
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 1.5,
                ),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: isInCompareList ? 'compare_arrows' : 'compare',
                    color: isInCompareList
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Compare',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isInCompareList
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
