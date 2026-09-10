import 'package:flutter/material.dart';
import 'package:m/core/constants/app_constants.dart';
import 'package:m/core/theme/app_colors.dart';
import 'package:m/screens/movie_details/data/models/movie_data_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildMovieHeader extends StatelessWidget {
  final MovieDetailsModel movie;
  const BuildMovieHeader({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * .6,
      width: width,
      child: Stack(
        children: [
          /// background image
          Image.network(
            (movie.movie.largeCoverImage),
            height: height * .6,
            width: width,
              fit: BoxFit.fill
          ),
          /// build play button
          buildPlayButton(context),
          /// title and date
          buildTitleAndDateRow(context),

          /// arrow back and save buttons
          buildTopBar(context),
        ],
      ),
    );
  }

  Widget buildPlayButton(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: height * .2,
      left: width / 2.5,
      child: GestureDetector(
          onTap: (){
            _launchUrl(movie.movie.url, context);
          },
          child: Image.asset(
            "assets/images/play_icon.png",
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          )
      ),
    );
  }

  Widget buildTitleAndDateRow(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            movie.movie.title,
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10,),
          Text(
            "${movie.movie.year}",
            style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10,),

        ],
      ),
    );
  }

  Widget buildTopBar(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    return Positioned(
      top: height * .05,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// back
            GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "assets/images/back_icon.png",
                  height: 20,
                  width: 30,
                )
            ),
            GestureDetector(
                onTap: (){

                },
                child: Image.asset(
                  "assets/images/save_icon.png",
                  height: 20,
                  width: 30,
                )
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }



}
