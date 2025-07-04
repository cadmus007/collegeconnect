import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CollegeReviewsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;
  final int totalReviews;

  const CollegeReviewsWidget({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  State<CollegeReviewsWidget> createState() => _CollegeReviewsWidgetState();
}

class _CollegeReviewsWidgetState extends State<CollegeReviewsWidget> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    final displayedReviews =
        _showAllReviews ? widget.reviews : widget.reviews.take(2).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Reviews',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildRatingOverview(),
              ],
            ),
          ),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          ...displayedReviews.map((review) => _buildReviewItem(review)),
          if (widget.reviews.length > 2)
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllReviews = !_showAllReviews;
                    });
                  },
                  child: Text(
                    _showAllReviews ? 'Show Less' : 'Show All Reviews',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRatingOverview() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.averageRating.toStringAsFixed(1),
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 2.w),
                Row(
                  children: List.generate(5, (index) {
                    return CustomIconWidget(
                      iconName: index < widget.averageRating.floor()
                          ? 'star'
                          : 'star_border',
                      color: index < widget.averageRating.floor()
                          ? Colors.amber
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Based on ${widget.totalReviews} reviews',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildRatingDistribution(),
      ],
    );
  }

  Widget _buildRatingDistribution() {
    // Mock rating distribution data
    final List<Map<String, dynamic>> distribution = [
      {"stars": 5, "percentage": 0.7},
      {"stars": 4, "percentage": 0.2},
      {"stars": 3, "percentage": 0.05},
      {"stars": 2, "percentage": 0.03},
      {"stars": 1, "percentage": 0.02},
    ];

    return Column(
      children: distribution.map((item) {
        return Row(
          children: [
            Text(
              '${item["stars"]}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'star',
              color: Colors.amber,
              size: 12,
            ),
            SizedBox(width: 2.w),
            Container(
              width: 15.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: item["percentage"] as double,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 3.w,
                backgroundImage: NetworkImage(review["avatar"] as String),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["studentName"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${review["program"]} • ${review["year"]}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName: index < (review["rating"] as double).floor()
                            ? 'star'
                            : 'star_border',
                        color: index < (review["rating"] as double).floor()
                            ? Colors.amber
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 14,
                      );
                    }),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    review["date"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            review["review"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
