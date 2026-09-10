// import 'package:flutter/material.dart';
// import 'package:m/screens/movie_details/data/models/movie_data_model.dart';
//
// /// Backdrop image with a gradient + the poster/title overlaid at the bottom.
// /// Meant to be used as the `flexibleSpace` of a SliverAppBar.
// class MovieBackdropHeader extends StatelessWidget {
//   final MovieDetailsModel movie;
//
//   const MovieBackdropHeader({super.key, required this.movie});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         if ((movie.backdropPath ?? "").isNotEmpty)
//           Image.network(
//             movie.backdropPath!,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
//           )
//         else
//           Container(color: Colors.grey[900]),
//         DecoratedBox(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.black.withOpacity(0.1),
//                 Colors.black.withOpacity(0.85),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           left: 16,
//           right: 16,
//           bottom: 16,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: SizedBox(
//                   width: 80,
//                   height: 120,
//                   child: (movie.posterPath ?? "").isNotEmpty
//                       ? Image.network(movie.posterPath!, fit: BoxFit.cover)
//                       : Container(color: Colors.grey[800]),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   movie.title ?? "",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
