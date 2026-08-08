import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../utils/app_colors.dart';

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

    return SizedBox(

      height: 150,

      child: ListView.separated(

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        scrollDirection: Axis.horizontal,

separatorBuilder: (_, _) =>
            const SizedBox(width: 16),

        itemCount: categories.length,

        itemBuilder: (context, index) {

          final category = categories[index];

          return InkWell(

            borderRadius:
                BorderRadius.circular(22),

            onTap: () {

              onCategoryTap?.call(category);

            },

            child: AnimatedContainer(

              duration: const Duration(
                milliseconds: 250,
              ),

              width: 115,

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(22),

boxShadow: [

                  BoxShadow(

                    color: Colors.black.withValues(alpha: .05),

                    blurRadius: 14,

                    offset: const Offset(0, 6),

                  ),

                ],

              ),

              child: Padding(

                padding: const EdgeInsets.all(14),

                child: Column(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Container(

                      width: 64,
                      height: 64,

                      decoration: BoxDecoration(

                        color: AppColors.surfaceTint,

                        borderRadius:
                            BorderRadius.circular(18),

                      ),

child: (category.icon.isNotEmpty)

                          ? Padding(

                              padding:
                                  const EdgeInsets.all(10),

                              child: Image.network(
                                category.icon,
                                fit: BoxFit.contain,

errorBuilder:
                                    (_, _, _) {

                                  return Icon(

                                    _getCategoryIcon(
                                      category.name,
                                    ),

                                    color: AppColors.primary,

                                    size: 34,

                                  );

                                },

                              ),

                            )

                          : Icon(

                              _getCategoryIcon(
                                category.name,
                              ),

                              color: AppColors.primary,

                              size: 34,

                            ),

                    ),

                    const SizedBox(height: 14),

                    Text(

                      category.name,

                      maxLines: 2,

                      textAlign: TextAlign.center,

                      overflow:
                          TextOverflow.ellipsis,

                      style: const TextStyle(

                        fontWeight:
                            FontWeight.w700,

                        fontSize: 14,

                      ),

                    ),

                  ],

                ),

              ),

            ),

          );

        },

      ),

    );

  }

  IconData _getCategoryIcon(String name) {

    switch (name.toLowerCase()) {

      case "plumber":
      case "plumbing":
        return Icons.plumbing;

      case "electrician":
        return Icons.electrical_services;

      case "carpenter":
        return Icons.handyman;

      case "cleaner":
      case "cleaning":
        return Icons.cleaning_services;

      case "painter":
        return Icons.format_paint;

      case "mechanic":
        return Icons.car_repair;

      default:
        return Icons.home_repair_service;

    }

  }

}