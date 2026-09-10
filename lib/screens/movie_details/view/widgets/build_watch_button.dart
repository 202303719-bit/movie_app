import 'package:flutter/material.dart';
import 'package:m/core/theme/app_colors.dart';

import '../../data/models/movie_data_model.dart';

class BuildWatchButton extends StatelessWidget {
  final MovieDetailsModel movie;
  const BuildWatchButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){},
      child: Container(
        height: height * .08,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.redColor
        ),
        child: Center(
          child: Text(
            "Watch",
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
