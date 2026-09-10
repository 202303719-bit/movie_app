import 'package:flutter/material.dart';
import 'package:m/core/constants/app_constants.dart';
import 'package:m/screens/movie_details/view/movie_details_screen.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_data_model.dart';

class BuildSimilarMovies extends StatelessWidget {
  final MovieDetailsModel movie;
  final List<Movie> suggestions;
  const BuildSimilarMovies({super.key, required this.movie, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Similar",
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
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 16,
            mainAxisExtent: 200,
          ),
          //itemCount: suggestions.length,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return buildSimilarMovieItem(suggestions[index],context);
          },
        )



      ],
    );
  }

  Widget buildSimilarMovieItem(Movie movie,BuildContext context){
    return GestureDetector(
      onTap: (){

        // Navigate to movie details screen with the selected movie
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: movie.id),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: NetworkImage(
                  movie.largeCoverImage
                ),
                fit: BoxFit.fill
            )
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 30,
            width: 60,
            decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.star,color: AppColors.primary,size: 20,),
                  Text(
                    "${movie.rating}",
                    style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
