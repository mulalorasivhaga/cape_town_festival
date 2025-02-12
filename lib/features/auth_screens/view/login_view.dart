import 'package:ct_festival/features/auth_screens/controller/auth_provider.dart';
import 'package:ct_festival/features/auth_screens/model/admin_model.dart' as admin_auth;
import 'package:ct_festival/features/auth_screens/model/user_model.dart' as user_auth;
import 'package:ct_festival/shared/navigation/view/back_button.dart';
import 'package:flutter/material.dart';
import 'package:ct_festival/utils/logger.dart';
import 'package:ct_festival/features/auth_screens/controller/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard_screen/view/admin_dashboard_view.dart';
import '../../dashboard_screen/view/user_dashboard_view.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthService _authService;
  final AppLogger logger = AppLogger();


  /// This method initializes the AuthService
  @override
  void initState() {
    super.initState();
    // Initialize AuthService using the provider
    _authService = ref.read(authServiceProvider);
  }

  @override
  void dispose() {
    logger.logInfo('Disposing LoginScreen');
    super.dispose();
  }

// variables
  bool _passwordVisible = false;
  bool _isLoading = false;
  String appUserEmail = '';
  String appUserPassword = '';

  /// This method validates the email address
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      logger.logWarning('Email validation failed: Empty email');
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      logger.logWarning('Email validation failed: Invalid format - $value');
      return 'Please enter a valid email address';
    }
    logger.logDebug('Email validation passed: $value');
    return null;
  }

  /// This method validates the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      logger.logWarning('Password validation failed: Empty password');
      return 'Please enter your password';
    }
    if (value.length < 6) {
      logger.logWarning('Password validation failed: Too short');
      return 'Password must be at least 6 characters';
    }
    logger.logWarning('Password validation passed');
    return null;
  }


  /// This method handles the login process
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      logger.logWarning('Form validation failed');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final (appUser, message) = await _authService.loginUser(
        email: appUserEmail,
        password: appUserPassword,
      );

      if (mounted) {
        if (appUser != null) {
          if (appUser is admin_auth.Admin) {
            logger.logInfo('Login successful for admin: ${appUser.email}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboardView()),
            );
          } else if (appUser is user_auth.User) {
            logger.logInfo('Login successful for user: ${appUser.email}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserDashboard()),
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          logger.logWarning('Login failed: $message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.black,
            ),
          );
        }
      }
    } catch (e) {
      logger.logError('Login error', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.black,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// This method builds the LoginScreen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(25),
        child: BackToHomeNav(),
      ),
      backgroundColor:Color(0xFFAD343E),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 48.0 : 16.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(constraints),
                      SizedBox(height: constraints.maxWidth > 600 ? 50 : 30),
                      _buildLoginContainer(constraints),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// This method builds the header section of the LoginScreen widget
  Widget _buildHeader(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    /// Return the header section
    return Column(
      children: [
        Text(
          'Login',
          style: TextStyle(
            color: const Color(0xFFF2AF29),
            fontSize: isMobile ? 36 : 72,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.9 : 800,
          ),
          child: Text(
            "Welcome back! Please enter your email and password to login.",
            style: TextStyle(
              color: const Color(0xFFE0E0CE),
              fontSize: isMobile ? 16 : 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// This method builds the login container section of the LoginScreen widget
  Widget _buildLoginContainer(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;
    final double containerWidth = isMobile ? constraints.maxWidth * 0.95 : 800;

    /// Return the login container section
    return Container(
      width: containerWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInputField(
            title: 'Email address:',
            hintText: 'Please enter your Email Address',
            icon: Icons.email,
            onChanged: (value) => setState(() => appUserEmail = value),
            validator: _validateEmail,  // Add the validator here
            constraints: constraints,
          ),
          SizedBox(height: isMobile ? 24 : 40),
          _buildPasswordField(constraints),
          SizedBox(height: isMobile ? 24 : 40),
          _buildSubmitButton(constraints),
          SizedBox(height: isMobile ? 30 : 50),
          //_buildLogo(constraints),
          //const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// This method builds the input field section of the LoginScreen widget
  Widget _buildInputField({
    required String title,
    required String hintText,
    required IconData icon,
    required Function(String) onChanged,
    required BoxConstraints constraints,
    String? Function(String?)? validator,
  }) {
    final bool isMobile = constraints.maxWidth <= 600;
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF000000),
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.85 : 600,
          ),
          child: TextFormField(
            onChanged: onChanged,
            validator: validator,
            style: const TextStyle(color: Color(0xFF363636)),
            decoration: InputDecoration(
              hintText: hintText,
              icon: Icon(icon, color: const Color(0xFF363636)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF363636), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// This method builds the password field section of the LoginScreen widget
  Widget _buildPasswordField(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return Column(
      children: [
        Text(
          'Password:',
          style: TextStyle(
            color: const Color(0xFF242F40),
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.85 : 600,
          ),
          child: TextFormField(
            onChanged: (value) => setState(() => appUserPassword = value),
            validator: _validatePassword,
            obscureText: !_passwordVisible,
            style: const TextStyle(color: Color(0xFF363636)),
            decoration: InputDecoration(
              hintText: 'Please enter your Password',
              icon: const Icon(Icons.lock, color: Color(0xFF363636)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF363636), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCA43B), width: 2),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF363636),
                ),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// This method builds the submit button section of the LoginScreen widget
  Widget _buildSubmitButton(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF2AF29),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 32 : 50,
          vertical: isMobile ? 8 : 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : Text(
        'Login',
        style: TextStyle(fontSize: isMobile ? 20 : 24),
      ),
    );
  }
}

/// This method builds the logo section of the LoginScreen widget
// Widget _buildLogo(BoxConstraints constraints) {
//   final bool isMobile = constraints.maxWidth <= 600;
//   final double size = isMobile ? 150 : 200;

  /// Return the logo section
  // return Image.asset(
  //   'assets/logo/ct_logo.png',
  //   width: size,
  //   height: size,
  // );
