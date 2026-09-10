// import 'package:flutter/material.dart';
//
// class MovieOverviewSection extends StatelessWidget {
//   final String overview;
//
//   const MovieOverviewSection({super.key, required this.overview});
//
//   @override
//   Widget build(BuildContext context) {
//     if (overview.isEmpty) return const SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Overview',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             overview,
//             style: const TextStyle(height: 1.4),
//           ),
//         ],
//       ),
//     );
//   }
// }
