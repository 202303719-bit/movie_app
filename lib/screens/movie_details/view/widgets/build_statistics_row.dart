import 'package:flutter/material.dart';
import 'package:m/core/theme/app_colors.dart';

import '../../data/models/movie_data_model.dart';

class BuildStatisticsRow extends StatelessWidget {
  final MovieDetailsModel movie;
  const BuildStatisticsRow({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          buildSharedContainer(
            Icons.favorite,
            "${movie.movie.likeCount}"
          ),
          SizedBox(width: 10,),
          buildSharedContainer(
              Icons.watch_later,
              "${movie.movie.runtime} min"
          ),
          SizedBox(width: 10,),
          buildSharedContainer(
              Icons.star,
              "${movie.movie.rating}"
          ),
        ],
      ),
    );
  }

  Widget buildSharedContainer(IconData icon,String text){
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon,color: AppColors.primary,size: 30,),
            Text(
              text,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            )

          ],
        ),
      ),
    );
  }

}

