import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_data_model.dart';

class BuildMovieGenres extends StatelessWidget {
  final MovieDetailsModel movie;
  const BuildMovieGenres({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    if(movie.movie.genres.isEmpty){
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Genres",
          style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10,),
        /// Grid View to show similar movies
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 16,
            mainAxisExtent: 40
          ),
          //itemCount: suggestions.length,
          itemCount: movie.movie.genres.length,
          itemBuilder: (context, index) {
            final genreName = movie.movie.genres[index];
            return buildGenreItem(genreName);
          },
        )



      ],
    );
  }


  Widget buildGenreItem(String genreName) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          genreName,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w400
          ),
        ),
      ),
    );
  }
}
