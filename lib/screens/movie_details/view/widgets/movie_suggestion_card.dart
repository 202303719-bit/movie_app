// import 'package:flutter/material.dart';
// import 'package:m/screens/movie_details/data/models/movie_data_model.dart';
//
// class MovieSuggestionCard extends StatelessWidget {
//   final Movie movie;
//   final VoidCallback? onTap;
//
//   const MovieSuggestionCard({super.key, required this.movie, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: SizedBox(
//         width: 110,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: AspectRatio(
//                 aspectRatio: 2 / 3,
//                 child: (movie.posterPath ?? "").isNotEmpty
//                     ? Image.network(movie.posterPath!, fit: BoxFit.cover)
//                     : Container(color: Colors.grey[800]),
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               movie.title ?? "",
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
