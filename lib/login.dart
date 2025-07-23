import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:io';
import 'dart:async';

// API endpoints and constants
class AppConfig {
  static const apiBaseUrl = 'https://personal-d9p61k4i.outsystemscloud.com/production/rest/v1';
  static const loginEndpoint = '$apiBaseUrl/login';
  static const notificationEndpoint = '$apiBaseUrl/n';
  static const requestTimeout = Duration(seconds: 15);
  static const secureStorageKey = 'jwt_token';
  static const retryDelay = Duration(seconds: 2);
  static const maxRetries = 3;
}

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  
  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF287EE8);
  final Color secondaryColor = const Color(0xFF34A853);
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String _versionInfo = '';
  late TabController _tabController;
  final double _elevation = 4.0;
  final double _borderRadius = 16.0;
  String? _oneSignalPlayerId;
  final _storage = const FlutterSecureStorage();
  int _loginAttempts = 0;
  final _maxLoginAttempts = 5;
  DateTime? _lastFailedAttempt;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppVersion();
    _initializeOneSignal();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final year = DateTime.now().year;
      if (mounted) {
        setState(() {
          _versionInfo = 'v${info.version}.${info.buildNumber} © $year';
        });
      }
    } catch (e) {
      debugPrint('Error loading app version: $e');
    }
  }

  Future<void> _initializeOneSignal() async {
    try {
      // iOS requires more careful handling of permissions
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // For iOS, we should request permission explicitly before opt-in
        // Check if permission was already granted
        final permission = await OneSignal.Notifications.permission;
        
        if (permission == false) {
          // Request permission if not already granted
          final hasPrompted = await OneSignal.Notifications.requestPermission(true);
          if (!hasPrompted) {
            debugPrint('User declined or notification permission is unavailable on the device');
            return;
          }
        }
      }
      
      // Now opt-in for push subscriptions
      await OneSignal.User.pushSubscription.optIn();
      
      // Get the player ID if available (may take a moment on first launch)
      final deviceState = await OneSignal.User.pushSubscription.id;
      if (deviceState != null && deviceState.isNotEmpty) {
        setState(() {
          _oneSignalPlayerId = deviceState;
        });
        debugPrint('OneSignal Player ID: $_oneSignalPlayerId');
      } else {
        // On iOS, the ID might not be immediately available, try again after a delay
        await Future.delayed(const Duration(seconds: 2));
        final retryDeviceState = await OneSignal.User.pushSubscription.id;
        if (retryDeviceState != null && retryDeviceState.isNotEmpty && mounted) {
          setState(() {
            _oneSignalPlayerId = retryDeviceState;
          });
          debugPrint('OneSignal Player ID (retry): $_oneSignalPlayerId');
        }
      }
    } catch (e) {
      debugPrint('Error initializing OneSignal: $e');
    }
  }

  String? getOneSignalPlayerId() {
    return _oneSignalPlayerId;
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool _shouldThrottleLogin() {
    if (_loginAttempts >= _maxLoginAttempts) {
      final now = DateTime.now();
      if (_lastFailedAttempt != null) {
        final difference = now.difference(_lastFailedAttempt!);
        if (difference < const Duration(minutes: 2)) {
          setState(() {
            _errorMessage = 'الكثير من محاولات تسجيل الدخول. يرجى المحاولة مرة أخرى بعد دقيقتين.';
          });
          return true;
        } else {
          // Reset counter after cooldown
          _loginAttempts = 0;
        }
      }
    }
    return false;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Apply rate limiting for login attempts
    if (_shouldThrottleLogin()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": _idController.text.trim(),
          "password": _passwordController.text,
          "code": int.tryParse(_codeController.text) ?? 0,
        }),
      ).timeout(AppConfig.requestTimeout);

      // Log response for debugging
      debugPrint('Login response status: ${response.statusCode}');
      
      // Handle HTTP errors (non-200 responses)
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final token = data['accesstoken'];
      final error = data['error'];
      final userid = data['userid'];
      
      // Direct error handling from the working version
      if (error != null && error.isNotEmpty) {
        _loginAttempts++;
        _lastFailedAttempt = DateTime.now();
        _handleLoginError(error);
        return;
      }

      // Reset login attempts on success
      _loginAttempts = 0;
      
      // Store token securely using flutter_secure_storage
      await _storage.write(key: AppConfig.secureStorageKey, value: token);
      
      // For backward compatibility, maintain the shared preferences entry
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      // Register OneSignal ID with the server - simplified approach from working version
      try {
        final playerId = getOneSignalPlayerId();
        if (playerId != null && userid != null) {
          final response = await http.post(
            Uri.parse(AppConfig.notificationEndpoint + '?userid=$userid'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "onesignalid": playerId,
              "deviceOS": Theme.of(context).platform == TargetPlatform.android ? 'Android' : 'iOS',
            })
          );
          
          if (response.statusCode != 200) {
            debugPrint('Failed to register OneSignal ID with server: ${response.statusCode}');
          }
        }
      } catch (e) {
        debugPrint('Error registering OneSignal ID with server: $e');
      }

      // Navigate ONLY if the widget is still mounted
      if (mounted) {
        widget.onLoginSuccess();
      }
    } on TimeoutException catch (_) {
      setState(() {
        _errorMessage = 'انتهت مهلة طلب تسجيل الدخول. يرجى المحاولة مرة أخرى.';
      });
    } on http.ClientException catch (e) {
      // Handle network/DNS errors
      setState(() {
        _errorMessage = 'فشل الاتصال بالخادم. تأكد من وجود اتصال بالإنترنت.';
      });
      debugPrint('Network error: $e');
    } catch (e) {
      // Simplified error handling as in the working version
      setState(() {
        _errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
      });
      debugPrint('Login error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLoginError(String error) {
    setState(() {
      if (error == 'User Not Found') {
        _errorMessage = 'المستخدم غير موجود';
      } else if (error == 'Incorrect Password') {
        _errorMessage = 'كلمة المرور غير صحيحة';
      } else if (error == 'Invalid Login Code') {
        _errorMessage = 'رمز الدخول غير صالح';
      } else {
        _errorMessage = 'حدث خطأ, يرجى المحاولة مرة أخرى';
      }
    });
  }

  // Language-aware text style helper: Arabic → Tajawal, English → Urbanist (wght 500/600)
  TextStyle appTextStyle({
    required String text,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    if (isArabic) {
      return GoogleFonts.tajawal(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    } else {
      // For Urbanist, limit weights to 500 or 600; fallback if not provided
      final urbanistWeight = (fontWeight == FontWeight.w600 || fontWeight == FontWeight.w500)
          ? fontWeight
          : FontWeight.w500;

      return GoogleFonts.urbanist(
        fontSize: fontSize,
        fontWeight: urbanistWeight,
        color: color,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // App Title
                      Text(
                        "Routico",
                        style: appTextStyle(
                          text: "Routico",
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Navigation & Guidance",
                        style: appTextStyle(
                          text: "Navigation & Guidance",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Tab Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle: appTextStyle(
                            text: 'تسجيل الدخول',
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelStyle: appTextStyle(
                            text: 'رمز الدخول',
                            fontWeight: FontWeight.w500,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: primaryColor,
                            ),
                          tabs: [
                            Tab(child: Text('تسجيل الدخول', style: appTextStyle(text: 'تسجيل الدخول', fontWeight: FontWeight.w600))),
                            Tab(child: Text('رمز الدخول', style: appTextStyle(text: 'رمز الدخول', fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tab Views
                      SizedBox(
                        height: 220,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Username & Password Tab
                            Column(
                              children: [
                                _buildInputField(
                                  controller: _idController,
                                  label: 'اسم المستخدم',
                                  icon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال اسم المستخدم';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildInputField(
                                  controller: _passwordController,
                                  label: 'كلمة المرور',
                                  icon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _login(),
                                ),
                              ],
                            ),

                            // Code Tab
                            Column(
                              children: [
                                _buildInputField(
                                  controller: _codeController,
                                  label: 'رمز الدخول',
                                  icon: Icons.vpn_key_outlined,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال رمز الدخول';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'يجب أن يكون الرمز رقمًا';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _login(),
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'احصل على رمز الدخول من مدير النظام',
                                    style: appTextStyle(
                                      text: 'احصل على رمز الدخول من مدير النظام',
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            _errorMessage!,
                            style: appTextStyle(
                              text: _errorMessage!,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Login Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: _elevation,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_borderRadius),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "تسجيل الدخول",
                                style: appTextStyle(
                                  text: "تسجيل الدخول",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Version Text
            if (_versionInfo.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    _versionInfo,
                    style: appTextStyle(
                      text: _versionInfo,
                      color: const Color(0xFF555555),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      style: appTextStyle(text: label),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: appTextStyle(text: label, color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      validator: validator,
    );
  }
}