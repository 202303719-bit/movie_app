// import 'package:flutter/material.dart';
// import 'package:m/screens/movie_details/data/models/movie_data_model.dart';
//
// class MovieInfoRow extends StatelessWidget {
//   final MovieDetailsModel movie;
//
//   const MovieInfoRow({super.key, required this.movie});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.star, color: Colors.amber, size: 20),
//               const SizedBox(width: 4),
//               Text(
//                 movie.movie.rating.toStringAsFixed(1),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(width: 16),
//               const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//               const SizedBox(width: 4),
//               Text(
//                   movie.movie.dateUploaded, style: const TextStyle(color: Colors.grey)),
//               ...[
//               const SizedBox(width: 16),
//               const Icon(Icons.schedule, size: 16, color: Colors.grey),
//               const SizedBox(width: 4),
//               Text('${movie.movie.runtime} min', style: const TextStyle(color: Colors.grey)),
//             ],
//             ],
//           ),
//           if (movie.movie.genres.isNotEmpty) ...[
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: movie.movie.genres
//                   .map((g) => Chip(
//                         label: Text(g , style: const TextStyle(fontSize: 12)),
//                         padding: EdgeInsets.zero,
//                         visualDensity: VisualDensity.compact,
//                       ))
//                   .toList(),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
