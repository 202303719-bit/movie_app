// import 'package:flutter/material.dart';
// import 'package:m/screens/movie_details/data/models/movie_data_model.dart';
// import 'movie_suggestion_card.dart';
//
// class MovieSuggestionsSection extends StatelessWidget {
//   final List<Movie> suggestions;
//   final void Function(MovieDetailsModel movie)? onMovieTap;
//
//   const MovieSuggestionsSection({
//     super.key,
//     required this.suggestions,
//     this.onMovieTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (suggestions.isEmpty) return const SizedBox.shrink();
//
//     return Padding(
//       padding: const EdgeInsets.only(top: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               'You might also like',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             height: 190,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: suggestions.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 12),
//               itemBuilder: (context, index) {
//                 final movie = suggestions[index];
//                 return MovieSuggestionCard(
//                   movie: movie,
//                   onTap: onMovieTap == null ? null : () => onMovieTap!(movie),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
