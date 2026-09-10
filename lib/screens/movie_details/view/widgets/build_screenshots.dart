import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_data_model.dart';

class BuildScreenshots extends StatelessWidget {
  final MovieDetailsModel movie;
  const BuildScreenshots({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final List<String> screenshots = [
      movie.movie.largeScreenshotImage1,
      movie.movie.largeScreenshotImage2,
      movie.movie.largeScreenshotImage3,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Screen Shots",
          style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10,),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,index){
              return buildImageItem(screenshots[index]);
            },
            separatorBuilder: (context,index){
              return SizedBox(height: 10,);
            },
            itemCount: screenshots.length
        ),
      ],
    );
  }

  Widget buildImageItem(String imageUrl){
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(
              imageUrl
          ),
          fit: BoxFit.cover
        )
      ),
    );
  }

}
