import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';


class AppColors {
  static const Color background = Color(0xFF121312);
  static const Color primary = Color(0xFFF6BD00);
  static const Color fieldFill = Color(0xFF282A28);
  static const Color fieldBorder = Color(0xFF282A28);
  static const Color fieldBorderFocused = Color(0xFF2F80ED);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9E9E9E);
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Index of the selected avatar (0, 1, 2 ...)
  int _selectedAvatarIndex = 1;

  final List<String> _avatars = const [
    'assets/images/avatar_1.png',
    'assets/images/avatar_2.png',
    'assets/images/avatar_3.png',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  final AuthService _authService = AuthService();

  // --- Validators ---

  static final RegExp _nameRegex =
  RegExp(r"^[a-zA-Z\u0600-\u06FF]+(?:\s[a-zA-Z\u0600-\u06FF]+)*$");
  static final RegExp _emailRegex =
  RegExp(r"^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$");
  static final RegExp _phoneRegex = RegExp(r"^[0-9+\s-]{8,15}$");

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Please enter your name';
    if (name.length < 2) return 'Name is too short';
    if (!_nameRegex.hasMatch(name)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email';
    if (!_emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Please enter your phone number';
    if (!_phoneRegex.hasMatch(phone)) return 'Enter a valid phone number';
    return null;
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return; // stops here and shows red borders + messages on bad fields
    }

    setState(() => _isLoading = true);
    try {
      await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        avatar: _avatars[_selectedAvatarIndex],
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
            (route) => false,
      );
    } catch (e) {
      _showMessage(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pop();
  }

  void _changeLanguage(bool english) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Header (back arrow + title)
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF6BD00),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // to balance the back button
                  ],
                ),

                const SizedBox(height: 20),

                // Avatars row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(_avatars.length, (index) {
                    final bool isSelected = index == _selectedAvatarIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _AvatarOption(
                        assetPath: _avatars[index],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedAvatarIndex = index;
                          });
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Avatar',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _AuthTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.name,
                  validator: _validateName,
                ),

                const SizedBox(height: 16),

                _AuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 16),

                _AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textWhite,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                _AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  validator: _validateConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textWhite,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                _AuthTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black,
                      ),
                    )
                        : const Text(
                      'Create Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: GestureDetector(
                    onTap: _goToLogin,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.2,
                          color: AppColors.textWhite,
                        ),
                        children: [
                          TextSpan(text: 'Already Have Account ? '),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Center(
                  child: _LanguageSwitch(
                    onChanged: _changeLanguage,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarOption({
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Selected avatar is noticeably bigger than the others (per design),
    // but the difference is smaller than before.
    final double size = isSelected ? 94 : 78;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.fieldBorderFocused.withValues(alpha: 0.25)
              : Colors.transparent,
          border: isSelected
              ? Border.all(
            color: AppColors.fieldBorderFocused,
            width: 2,
          )
              : null,
        ),
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: AppColors.textWhite,
        fontSize: 14,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.fieldFill,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.textWhite,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.textWhite,
          size: 20,
        ),
        suffixIcon: suffixIcon,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        errorStyle: const TextStyle(
          color: Color(0xFFFF6B6B),
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.fieldBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.fieldBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.fieldBorderFocused,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B6B),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B6B),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _LanguageSwitch extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  const _LanguageSwitch({this.onChanged});

  @override
  State<_LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<_LanguageSwitch> {
  bool isEnglishSelected = true;

  void _changeLanguage(bool english) {
    setState(() {
      isEnglishSelected = english;
    });
    widget.onChanged?.call(english);
  }

  @override
  Widget build(BuildContext context) {
    const double switchWidth = 130;
    const double switchHeight = 60;
    const double flagSize = 48;

    const double selectedCircleSize = 70;

    return SizedBox(
      width: switchWidth,
      height: switchHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: isEnglishSelected
                    ? -5
                    : switchWidth - selectedCircleSize + 5,
                top: (switchHeight - selectedCircleSize) / 2,
                child: Container(
                  width: selectedCircleSize,
                  height: selectedCircleSize,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 6,
                child: GestureDetector(
                  onTap: () => _changeLanguage(true),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/usa_flag.png',
                      width: flagSize,
                      height: flagSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 6,
                child: GestureDetector(
                  onTap: () => _changeLanguage(false),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/egypt_flag.png',
                      width: flagSize,
                      height: flagSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}