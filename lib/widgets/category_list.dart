import 'package:flutter/material.dart';

import '../models/category_model.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final void Function(CategoryModel category)? onCategoryTap;

  const CategoryList({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final category = categories[index];

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onCategoryTap?.call(category);
            },
            child: Container(
              width: 95,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(.12),
                    child: Icon(
                      _getCategoryIcon(category.name),
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    category.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'plumbing':
      case 'plumber':
        return Icons.plumbing;

      case 'electrician':
      case 'electrical':
        return Icons.electrical_services;

      case 'carpenter':
        return Icons.handyman;

      case 'painting':
      case 'painter':
        return Icons.format_paint;

      case 'cleaning':
        return Icons.cleaning_services;

      case 'ac repair':
      case 'ac':
        return Icons.ac_unit;

      case 'beauty':
      case 'salon':
        return Icons.face_retouching_natural;

      case 'appliance':
        return Icons.kitchen;

      default:
        return Icons.home_repair_service;
    }
  }
}