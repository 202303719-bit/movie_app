import 'package:flutter/material.dart';
import '../services/movie_api_service.dart';

class AppColors {
  static const Color background = Color(0xFF121312);
  static const Color primary = Color(0xFFF6BD00);
  static const Color fieldFill = Color(0xFF282A28);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9E9E9E);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    _HomeTab(),
    _SearchTab(),
    _BrowseTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.local_activity_outlined,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.fieldFill,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          _icons.length,
              (index) {
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _icons[index],
                  color: isSelected
                      ? Colors.black
                      : AppColors.textGrey,
                  size: 24,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final MovieApiService _apiService = MovieApiService();

  late Future<List<dynamic>> _popularMoviesFuture;

  @override
  void initState() {
    super.initState();
    _popularMoviesFuture = _apiService.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _popularMoviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _popularMoviesFuture =
                          _apiService.getPopularMovies();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final movies = snapshot.data ?? [];

        if (movies.isEmpty) {
          return const Center(
            child: Text(
              'No movies found',
              style: TextStyle(
                color: AppColors.textWhite,
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 24,
          ),
          children: [
            Center(
              child: Image.asset(
                'assets/images/available_now.png',
                width: 267,
                height: 93,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            _FeaturedCarousel(
              movies: movies,
            ),
            const SizedBox(height: 24),
            Center(
              child: Image.asset(
                'assets/images/watch_now.png',
                width: 180,
                height: 64,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 28),
            _CategorySection(
              title: 'Action',
              category: 'action',
            ),
            _CategorySection(
              title: 'Adventure',
              category: 'adventure',
            ),
            _CategorySection(
              title: 'Animation',
              category: 'animation',
            ),
            _CategorySection(
              title: 'Comedy',
              category: 'comedy',
            ),
            _CategorySection(
              title: 'Drama',
              category: 'drama',
            ),
            _CategorySection(
              title: 'Horror',
              category: 'horror',
            ),
          ],
        );
      },
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  final List<dynamic> movies;

  const _FeaturedCarousel({
    required this.movies,
  });

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  late final PageController _pageController;
  double _page = 0;

  static const double _viewportFraction = 0.6;
  static const double _gap = 12;
  static const double _cardHeight = 351;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: _viewportFraction,
    );

    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _page = _pageController.page ?? 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pageWidth =
              constraints.maxWidth * _viewportFraction;

          final cardWidth = pageWidth - _gap;

          return PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final distance =
              (index - _page).abs().clamp(0.0, 1.0);

              final opacity = 1 - (distance * 0.5);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _gap / 2,
                ),
                child: Opacity(
                  opacity: opacity,
                  child: _FeaturedCard(
                    movie: widget.movies[index],
                    width: cardWidth,
                    height: _cardHeight,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final dynamic movie;
  final double width;
  final double height;

  const _FeaturedCard({
    required this.movie,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final String posterPath =
        movie['poster_path'] ?? '';

    final String title =
        movie['title'] ?? 'Movie';

    final double rating =
    (movie['vote_average'] ?? 0).toDouble();

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          posterPath.isNotEmpty
              ? Image.network(
            _apiImageUrl(posterPath),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const Center(
                child: Icon(
                  Icons.movie_creation_outlined,
                  color: AppColors.textGrey,
                  size: 56,
                ),
              );
            },
          )
              : const Center(
            child: Icon(
              Icons.movie_creation_outlined,
              color: AppColors.textGrey,
              size: 56,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: _RatingBadge(
              rating: rating,
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatefulWidget {
  final String title;
  final String category;

  const _CategorySection({
    required this.title,
    required this.category,
  });

  @override
  State<_CategorySection> createState() =>
      _CategorySectionState();
}

class _CategorySectionState
    extends State<_CategorySection> {
  late Future<List<dynamic>> _moviesFuture;

  final MovieApiService _apiService =
  MovieApiService();

  @override
  void initState() {
    super.initState();

    _moviesFuture =
        _apiService.getMoviesByCategory(
          widget.category,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  'See More →',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<dynamic>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const SizedBox(
                  height: 190,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const SizedBox(
                  height: 190,
                  child: Center(
                    child: Text(
                      'Unable to load movies',
                      style: TextStyle(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                );
              }

              final movies = snapshot.data ?? [];

              return SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  itemCount: movies.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return _MovieCard(
                      movie: movies[index],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final dynamic movie;

  const _MovieCard({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final String posterPath =
        movie['poster_path'] ?? '';

    final String title =
        movie['title'] ?? 'Movie';

    final double rating =
    (movie['vote_average'] ?? 0).toDouble();

    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius:
                BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  posterPath.isNotEmpty
                      ? Image.network(
                    _apiImageUrl(
                      posterPath,
                    ),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) {
                      return const Center(
                        child: Icon(
                          Icons.movie_outlined,
                          color:
                          AppColors.textGrey,
                          size: 32,
                        ),
                      );
                    },
                  )
                      : const Center(
                    child: Icon(
                      Icons.movie_outlined,
                      color:
                      AppColors.textGrey,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _RatingBadge(
                      rating: rating,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

String _apiImageUrl(String posterPath) {
  return 'https://image.tmdb.org/t/p/w500$posterPath';
}

class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() =>
      _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: AppColors.textWhite,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.fieldFill,
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: AppColors.textGrey,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textWhite,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Search movies',
                style: TextStyle(
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseTab extends StatefulWidget {
  const _BrowseTab();

  @override
  State<_BrowseTab> createState() =>
      _BrowseTabState();
}

class _BrowseTabState extends State<_BrowseTab> {
  int _selectedCategory = 0;

  final List<String> _categories = const [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Drama',
    'Horror',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            itemCount: _categories.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isSelected =
                  index == _selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = index;
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.fieldFill,
                    ),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.black
                          : AppColors.textWhite,
                      fontWeight:
                      FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Browse movies',
              style: TextStyle(
                color: AppColors.textGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile',
        style: TextStyle(
          color: AppColors.textWhite,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.star,
            color: AppColors.primary,
            size: 11,
          ),
        ],
      ),
    );
  }
}