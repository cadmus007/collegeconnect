import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CollegeSectionCardWidget extends StatefulWidget {
  final String title;
  final String content;
  final bool isExpandable;

  const CollegeSectionCardWidget({
    super.key,
    required this.title,
    required this.content,
    this.isExpandable = false,
  });

  @override
  State<CollegeSectionCardWidget> createState() =>
      _CollegeSectionCardWidgetState();
}

class _CollegeSectionCardWidgetState extends State<CollegeSectionCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          InkWell(
            onTap: widget.isExpandable ? _toggleExpansion : null,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                  if (widget.isExpandable)
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!widget.isExpandable || _isExpanded)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                child: widget.isExpandable
                    ? FadeTransition(
                        opacity: _animation,
                        child: _buildContent(),
                      )
                    : _buildContent(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      widget.content.startsWith('•')
          ? widget.content
          : '• ${widget.content.replaceAll('\n', '\n• ')}',
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }
}
