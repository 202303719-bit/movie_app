import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/firestore_service.dart';
import '../services/movie_api_service.dart';
import 'login_screen.dart';
import 'update_profile_screen.dart';

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
            errorBuilder: (_, _, _) {
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
                  separatorBuilder: (_, _) =>
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
                        (_, _, _) {
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
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final MovieApiService _apiService = MovieApiService();
  final TextEditingController _searchController =
  TextEditingController(text: '');

  List<dynamic> _movies = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _movies = [];
        _hasSearched = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final movies = await _apiService.searchMovies(query);

      if (!mounted) return;

      setState(() {
        _movies = movies;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _movies = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchMovies(),
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 14,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: AppColors.textGrey,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textWhite,
                  size: 21,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: _searchMovies,
                  icon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 21,
                  ),
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (!_hasSearched) {
      return const Center(
        child: Image(
          image: AssetImage('assets/images/popcorn.png'),
          width: 124,
          height: 124,
          fit: BoxFit.contain,
        ),
      );
    }

    if (_movies.isEmpty) {
      return const Center(
        child: Text(
          'No movies found',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.63,
      ),
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        return _FigmaMovieGridCard(movie: _movies[index]);
      },
    );
  }
}

class _BrowseTab extends StatefulWidget {
  const _BrowseTab();

  @override
  State<_BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<_BrowseTab> {
  final MovieApiService _apiService = MovieApiService();

  final List<String> _categories = const [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Drama',
    'Horror',
  ];

  int _selectedCategory = 0;
  late Future<List<dynamic>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _apiService.getMoviesByCategory('Action');
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategory = index;
      _moviesFuture =
          _apiService.getMoviesByCategory(_categories[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        SizedBox(
          height: 39,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedCategory;

              return GestureDetector(
                onTap: () => _selectCategory(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.black
                          : AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Unable to load movies',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                );
              }

              final movies = snapshot.data ?? [];

              if (movies.isEmpty) {
                return const Center(
                  child: Text(
                    'No movies found',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.63,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return _FigmaMovieGridCard(movie: movies[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  final FirestoreService _firestoreService = FirestoreService();
  final MovieApiService _apiService = MovieApiService();

  bool _watchListSelected = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          'Please login first',
          style: TextStyle(color: AppColors.textWhite),
        ),
      );
    }

    return StreamBuilder<AppUser?>(
      stream: _firestoreService.watchUserProfile(user.uid),
      builder: (context, profileSnapshot) {
        final profile = profileSnapshot.data;

        // RegisterScreen already saves the real user's name and avatar
        // in Firestore, so nothing is hard-coded here.
        final userName = profile?.name.trim().isNotEmpty == true
            ? profile!.name
            : user.displayName?.trim().isNotEmpty == true
            ? user.displayName!
            : 'User';

        final avatarPath = profile?.avatar.trim().isNotEmpty == true
            ? profile!.avatar
            : 'assets/images/avatar_1.png';

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      avatarPath,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 72,
                          height: 72,
                          color: AppColors.primary,
                          child: const Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 38,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  StreamBuilder<List<int>>(
                    stream: _firestoreService.watchFavoriteIds(user.uid),
                    builder: (context, favoriteSnapshot) {
                      final favoriteCount =
                          favoriteSnapshot.data?.length ?? 0;

                      return _ProfileStat(
                        number: '$favoriteCount',
                        title: 'Wish List',
                      );
                    },
                  ),
                  const SizedBox(width: 28),
                  const _ProfileStat(
                    number: '0',
                    title: 'History',
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                userName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 39,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const UpdateProfileScreen(),
                              ),
                            );
                            if (mounted) setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 86,
                      height: 39,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE93B35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.logout, size: 15),
                        label: const Text(
                          'Exit',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  Expanded(
                    child: _ProfileSectionTab(
                      title: 'Watch List',
                      icon: Icons.list_alt_rounded,
                      selected: _watchListSelected,
                      onTap: () {
                        setState(() => _watchListSelected = true);
                      },
                    ),
                  ),
                  Expanded(
                    child: _ProfileSectionTab(
                      title: 'History',
                      icon: Icons.folder_rounded,
                      selected: !_watchListSelected,
                      onTap: () {
                        setState(() => _watchListSelected = false);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_watchListSelected)
                _WatchListContent(
                  uid: user.uid,
                  apiService: _apiService,
                  firestoreService: _firestoreService,
                )
              else
                const _HistoryContent(),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String number;
  final String title;

  const _ProfileStat({
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileSectionTab({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: selected ? AppColors.primary : AppColors.textWhite,
            size: 23,
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            height: 2,
            width: double.infinity,
            color: selected
                ? AppColors.primary
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _WatchListContent extends StatelessWidget {
  final String uid;
  final MovieApiService apiService;
  final FirestoreService firestoreService;

  const _WatchListContent({
    required this.uid,
    required this.apiService,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: firestoreService.watchFavoriteIds(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        final ids = snapshot.data ?? [];

        if (ids.isEmpty) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: Image(
                image: AssetImage('assets/images/popcorn.png'),
                width: 124,
                height: 124,
                fit: BoxFit.contain,
              ),
            ),
          );
        }

        return FutureBuilder<List<dynamic>>(
          future: Future.wait(
            ids.map((id) => apiService.getMovieById(id)),
          ),
          builder: (context, movieSnapshot) {
            if (movieSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            if (movieSnapshot.hasError) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: Text(
                    'Unable to load watch list',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                ),
              );
            }

            final movies = movieSnapshot.data ?? [];

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 9,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _FigmaMovieGridCard(movie: movies[index]);
              },
            );
          },
        );
      },
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent();

  @override
  Widget build(BuildContext context) {
    // The current shared FirestoreService does not expose a history
    // collection yet. Keep the Figma state/UI without changing teammates'
    // Firestore code or inventing history data.
    return SizedBox(
      height: 300,
      child: Center(
        child: Image.asset(
          'assets/images/popcorn.png',
          width: 124,
          height: 124,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _FigmaMovieGridCard extends StatelessWidget {
  final dynamic movie;

  const _FigmaMovieGridCard({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final posterPath = movie['poster_path'] as String? ?? '';
    final rating = (movie['vote_average'] ?? 0).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (posterPath.isNotEmpty)
            Image.network(
              _apiImageUrl(posterPath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.movie_outlined,
                    color: AppColors.textGrey,
                    size: 32,
                  ),
                );
              },
            )
          else
            const Center(
              child: Icon(
                Icons.movie_outlined,
                color: AppColors.textGrey,
                size: 32,
              ),
            ),
          Positioned(
            top: 6,
            left: 6,
            child: _RatingBadge(rating: rating),
          ),
        ],
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
        color: Colors.black.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.star,
            color: AppColors.primary,
            size: 10,
          ),
        ],
      ),
    );
  }
}