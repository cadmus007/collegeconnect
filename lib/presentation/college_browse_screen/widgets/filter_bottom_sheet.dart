import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> activeFilters;
  final Function(List<String>) onFiltersChanged;

  const FilterBottomSheet({
    super.key,
    required this.activeFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedFilters;

  final Map<String, List<String>> _filterCategories = {
    'Location': [
      'California',
      'Massachusetts',
      'New York',
      'Texas',
      'Pennsylvania'
    ],
    'Tuition': ['Under \$30k', 'Under \$50k', 'Under \$70k', 'Above \$70k'],
    'Type': ['Public', 'Private', 'Community College'],
    'Courses': [
      'Engineering',
      'Computer Science',
      'Business',
      'Liberal Arts',
      'Medicine'
    ],
    'Size': ['Small (< 5k)', 'Medium (5k-15k)', 'Large (> 15k)'],
  };

  @override
  void initState() {
    super.initState();
    _selectedFilters = List.from(widget.activeFilters);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Text(
                      'Filters',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilters.clear();
                        });
                      },
                      child: Text(
                        'Clear All',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter content
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _filterCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filterCategories.keys.elementAt(index);
                    final options = _filterCategories[category]!;

                    return _buildFilterSection(category, options);
                  },
                ),
              ),

              // Apply button
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onFiltersChanged(_selectedFilters);
                          Navigator.pop(context);
                        },
                        child: Text('Apply (${_selectedFilters.length})'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String category, List<String> options) {
    return ExpansionTile(
      title: Text(
        category,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: options.map((option) {
        final isSelected = _selectedFilters.contains(option);

        return CheckboxListTile(
          title: Text(
            option,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _selectedFilters.add(option);
              } else {
                _selectedFilters.remove(option);
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
        );
      }).toList(),
    );
  }
}
