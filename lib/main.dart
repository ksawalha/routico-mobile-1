import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gem_kit/core.dart' as gem;
import 'package:gem_kit/map.dart' as gem;
import 'package:gem_kit/navigation.dart' as gem;
import 'package:gem_kit/routing.dart' as gem;
import 'package:gem_kit/sense.dart' as gem;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:collection/collection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'login.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:math';

const Color kPrimaryColor = Color(0xFF287EE8);
const Duration kApiTimeout = Duration(seconds: 30);
const Duration kLocationUpdateInterval = Duration(seconds: 1);
const double kArrivalThreshold = 50.0; // meters
const String kApiKeyEndpoint = 
  'https://personal-d9p61k4i.outsystemscloud.com/production/rest/v1/token';
const String kSearchEndpoint = 
  'https://personal-d9p61k4i.outsystemscloud.com/production/rest/v1/search';
const String kOneSignalAppId = "34f8a9aa-4822-485a-bd21-9d3c20692dd9";
const String kMapStyleAsset = "assets/map.style";
const String kLogoAsset = "assets/logo.png";
const String kArabicLanguageCode = "ar-SA";
const int kMaxApiRetries = 5;
const int kRouteCalculationTimeout = 30; // seconds

// API Error Messages
const String kLocationPermissionDenied = 'تم رفض إذن الموقع';
const String kLocationFetchFailed = 'فشل في الحصول على الموقع';
const String kApiKeyFetchFailed = 'فشل في جلب مفتاح API';
const String kRouteCalculationFailed = 'فشل في حساب الطريق';
const String kNoRouteAvailable = 'لا يوجد طريق بين المواقع المختارة';
const String kSearchFailed = 'فشل البحث';
const String kNavigationFailed = 'خطأ في الملاحة';
const String kTtsInitializationFailed = 'فشل تهيئة محول النص إلى كلام';
const String kConnectivityLost = 'الجهاز غير متصل بالإنترنت';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize platform-specific settings
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  
  // Initialize core SDKs first
  await initializeCoreSdks();
  
  runApp(const AppWrapper());
}

Future<void> initializeCoreSdks() async {
  try {
    // Initialize GemKit SDK
    await gem.GemKit.initialize(appAuthorization: "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJlZTkyMWMwYi05ODAyLTRhZWEtODI3OS1hYjJkNzBhY2Q1MzkiLCJleHAiOjE4MDY1MjY4MDAsImlzcyI6Ik1hZ2ljIExhbmUiLCJqdGkiOiJkM2UzNTk5Yy1iNWFjLTRmNWItODM3ZS1jYTIwMDk1NDkzNTMifQ.K1Vv4sxZ30fLxvNaEl6uFB5Q4imU1CdeAuMhEKyE2ThqALUMmqbCqsREgHqSWANPsXOjXPwchwJujXqU90-WZw");
    
    // Properly initialize OneSignal with better error handling
    await _initializeOneSignal();
    
    // Check connectivity status initially
    await Connectivity().checkConnectivity();
    
    // Request permissions with a better approach
    await _requestBasicPermissions();
  } catch (e) {
    debugPrint("Core SDK initialization error: $e");
    // Implement a recovery strategy or show an error dialog
  }
}

Future<void> _initializeOneSignal() async {
  try {
    // Initialize OneSignal with proper configuration
    OneSignal.initialize(kOneSignalAppId);
    
    // Configure based on platform
    if (Platform.isIOS) {
      // For iOS, configure specific settings
      await OneSignal.Notifications.requestPermission(true);
    } else {
      // For Android, automatically opt-in
      await OneSignal.User.pushSubscription.optIn();
    }
    
    // Log success for debugging
    debugPrint("OneSignal successfully initialized");
  } catch (e) {
    debugPrint("OneSignal initialization error: $e");
    // Non-critical error, app can continue without push notifications
  }
}

Future<void> _requestBasicPermissions() async {
  try {
    if (Platform.isIOS) {
      // For iOS, check location services and permission status
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled on iOS");
        return;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint("iOS Location permission requested: $permission");
      }
      
      if (permission == LocationPermission.deniedForever) {
        debugPrint("iOS Location permission permanently denied - user needs to enable in settings");
      } else if (permission == LocationPermission.whileInUse || 
                 permission == LocationPermission.always) {
        debugPrint("iOS Location permission granted: $permission");
      }
    } else {
      // For Android, use permission_handler
      final status = await Permission.locationWhenInUse.request();
      debugPrint("Android Location permission status: $status");
      
      if (status.isDenied) {
        debugPrint("Android Location permission denied - app will request again when needed");
      } else if (status.isPermanentlyDenied) {
        debugPrint("Android Location permission permanently denied - user needs to enable in settings");
      }
    }
  } catch (e) {
    debugPrint("Permission request error: $e");
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        textTheme: _createTextTheme(),
      ),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const LoginStatusChecker(),
      routes: {
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return MyHomePage(apiKey: args['apiKey']);
        },
      },
    );
  }

  TextTheme _createTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.tajawal(),
      displayMedium: GoogleFonts.tajawal(),
      displaySmall: GoogleFonts.tajawal(),
      headlineLarge: GoogleFonts.tajawal(),
      headlineMedium: GoogleFonts.tajawal(),
      headlineSmall: GoogleFonts.tajawal(),
      titleLarge: GoogleFonts.tajawal(),
      titleMedium: GoogleFonts.tajawal(),
      titleSmall: GoogleFonts.tajawal(),
      bodyLarge: GoogleFonts.tajawal(),
      bodyMedium: GoogleFonts.tajawal(),
      bodySmall: GoogleFonts.tajawal(),
      labelLarge: GoogleFonts.tajawal(),
      labelMedium: GoogleFonts.tajawal(),
      labelSmall: GoogleFonts.tajawal(),
    ).apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    );
  }
}

class LoginStatusChecker extends StatefulWidget {
  const LoginStatusChecker({super.key});

  @override
  State<LoginStatusChecker> createState() => _LoginStatusCheckerState();
}

class _LoginStatusCheckerState extends State<LoginStatusChecker> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jwtToken = prefs.getString('jwt_token');
      setState(() {
        _isLoggedIn = jwtToken != null && jwtToken.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Login status check error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : _isLoggedIn
              ? const ApiKeyLoader()
              : LoginPage(onLoginSuccess: _handleLoginSuccess),
    );
  }

  void _handleLoginSuccess() {
    if (mounted) {
      setState(() {
        _isLoggedIn = true;
        _isLoading = false;
      });
    }
  }
}

class ApiKeyLoader extends StatefulWidget {
  const ApiKeyLoader({super.key});

  @override
  State<ApiKeyLoader> createState() => _ApiKeyLoaderState();
}

class _ApiKeyLoaderState extends State<ApiKeyLoader> {
  String? _apiKey;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchApiKey();
  }

  Future<void> _fetchApiKey() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final key = await fetchMagicLaneApiKey();
      if (key != null) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {'apiKey': key},
        );
      } else {
        _setErrorState('تعذر الحصول على مفتاح API: لا يوجد رمز JWT مخزن');
      }
    } catch (e) {
      _setErrorState('$kApiKeyFetchFailed: $e');
    }
  }

  void _setErrorState(String message) {
    if (mounted) {
      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
      );
    }
    
    return Scaffold(
      body: Center(
        child: _errorMessage != null
            ? ErrorRetryWidget(
                message: _errorMessage!,
                onRetry: _fetchApiKey,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('إعادة المحاولة'),
        ),
      ],
    );
  }
}

Future<String?> fetchMagicLaneApiKey() async {
  final prefs = await SharedPreferences.getInstance();
  final jwtToken = prefs.getString('jwt_token');
  if (jwtToken == null || jwtToken.isEmpty) return null;

  for (int attempt = 0; attempt < kMaxApiRetries; attempt++) {
    try {
      final response = await http.get(
        Uri.parse(kApiKeyEndpoint),
        headers: {'Authorization': jwtToken},
      ).timeout(kApiTimeout);

      if (response.statusCode == 200) {
        return response.body.trim();
      }
      debugPrint('API key fetch failed: ${response.statusCode}');
    } catch (e) {
      debugPrint('API key fetch error: $e');
    }
    await Future.delayed(const Duration(seconds: 2));
  }
  return null;
}

class MyHomePage extends StatefulWidget {
  final String apiKey;
  
  const MyHomePage({super.key, required this.apiKey});
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Map & Navigation Controllers
  gem.GemMapController? _mapController;
  gem.TaskHandler? _routingHandler;
  gem.TaskHandler? _navigationHandler;

  // Location & Route State
  Position? _currentPosition;
  gem.Coordinates? _destinationCoords;
  gem.Route? _currentRoute;
  gem.TimeDistance? _currentTimeDistance;
  gem.TimeDistance? _remainingTimeDistance;
  gem.NavigationInstruction? currentInstruction;

  // UI State
  bool _areRoutesBuilt = false;
  bool _hasLiveDataSource = false;
  bool _isSearching = false;
  bool _isLoadingLocation = false;
  bool _showRecenterButton = false;
  bool _isFollowingPosition = false;
  bool _logoLoaded = false;
  bool _showArrivalMessage = false;
  bool _isCalculatingRoute = false;
  bool _isMapMovedByUser = false;
  bool _isVoiceMuted = false;
  bool _isOffline = false;

  // TTS State
  bool _isFirstSpeech = true;
  bool _isTtsInitialized = false;

  // Data
  String? _destinationName;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  
  // Services
  late FlutterTts _flutterTts;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  StreamSubscription<Position>? _positionStream;

  // Navigation Metrics
  double _remainingDistance = 0.0;
  int _remainingDuration = 0;
  double _routeProgress = 0.0;
  double _totalDistance = 0.0;
  DateTime? _expectedArrivalTime;

@override
void initState() {
  super.initState();
  
  // Initialize UI-dependent services only after widget is built
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializePlatformServices();
    _getCurrentLocation();
  });
}

  void _initializePlatformServices() {
    try {
      // Initialize TTS with platform-specific settings
      _initTts();
      
      // Initialize connectivity monitoring
      _initConnectivityListener();
      
      // Precache resources after UI is ready
      _precacheResources();
    } catch (e) {
      debugPrint("Platform services initialization error: $e");
    }
  }

  Future<void> _precacheResources() async {
    try {
      // Load app logo
      await precacheImage(const AssetImage(kLogoAsset), context);
      
      // Update UI only if widget is still mounted
      if (mounted) {
        setState(() => _logoLoaded = true);
      }
      
      // Preload map style if needed
      await precacheImage(const AssetImage(kMapStyleAsset), context);
      
    } catch (e) {
      // Just log the error but don't block the app from continuing
      debugPrint("Resource preloading error: $e");
      
      // Still mark logo as loaded to avoid UI issues
      if (mounted) {
        setState(() => _logoLoaded = true);
      }
    }
  }

  Future<void> _initTts() async {
    _isFirstSpeech = true;
    _flutterTts = FlutterTts();
    try {
      // Platform-specific TTS configurations
      if (Platform.isAndroid) {
        await _flutterTts.setLanguage(kArabicLanguageCode);
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setEngine('com.google.android.tts');
        await _flutterTts.setQueueMode(1); // Add to queue instead of interrupting
      } else if (Platform.isIOS) {
        // Enhanced iOS Arabic TTS setup
        await _setupiOSArabicTts();
      }
      
      // Event handlers with better error recovery
      _flutterTts.setErrorHandler((msg) {
        debugPrint("TTS Error: $msg");
        // Only reinitialize if widget is still mounted and error is recoverable
        if (mounted && !msg.contains("AVAudioSession")) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) _initTts();
          });
        }
      });
      
      _flutterTts.setCompletionHandler(() {
        debugPrint("TTS completed successfully");
      });
      
      _flutterTts.setStartHandler(() {
        debugPrint("TTS started");
      });
      
      setState(() => _isTtsInitialized = true);
    } catch (e) {
      debugPrint("$kTtsInitializationFailed: $e");
      // Try alternative initialization for iOS
      if (Platform.isIOS) {
        await _reinitializeTtsForIOS();
      }
    }
  }
  
  // Enhanced iOS Arabic TTS setup
  Future<void> _setupiOSArabicTts() async {
    try {
      // Set shared instance first
      await _flutterTts.setSharedInstance(true);
      
      // Configure audio session for iOS
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.duckOthers,
        ],
        IosTextToSpeechAudioMode.spokenAudio,
      );
      
      // Get available voices and languages
      var voices = await _flutterTts.getVoices;
      var languages = await _flutterTts.getLanguages;
      
      debugPrint("Available TTS languages: $languages");
      debugPrint("Available TTS voices: ${voices.length} voices found");
      
      // Try to find Arabic voices
      List<String> arabicLanguageCodes = [
        'ar-SA', 'ar', 'ar-AE', 'ar-EG', 'ar-JO', 'ar-KW', 'ar-LB', 'ar-QA'
      ];
      
      String? selectedLanguage;
      Map<String, dynamic>? selectedVoice;
      
      // First try to find Arabic voices
      for (var voice in voices) {
        String? voiceLocale = voice['locale']?.toString().toLowerCase();
        if (voiceLocale != null && voiceLocale.startsWith('ar')) {
          selectedVoice = voice;
          selectedLanguage = voice['locale'];
          debugPrint("Found Arabic voice: ${voice['name']} (${voice['locale']})");
          break;
        }
      }
      
      // If no Arabic voice found, check languages
      if (selectedLanguage == null) {
        for (String langCode in arabicLanguageCodes) {
          var isAvailable = await _flutterTts.isLanguageAvailable(langCode);
          if (isAvailable) {
            selectedLanguage = langCode;
            debugPrint("Found Arabic language support: $langCode");
            break;
          }
        }
      }
      
      if (selectedLanguage != null) {
        // Set the Arabic language
        await _flutterTts.setLanguage(selectedLanguage);
        
        // If we found a specific voice, set it
        if (selectedVoice != null) {
          await _flutterTts.setVoice({
            "name": selectedVoice['name'],
            "locale": selectedVoice['locale']
          });
          debugPrint("Set Arabic voice: ${selectedVoice['name']}");
        }
        
        // Configure speech parameters
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setVolume(1.0);
        
        // Warm up TTS engine
        await _warmupTts();
        
        _showSnackBar("Arabic TTS initialized successfully");
      } else {
        _showSnackBar("Fell Back to default TTS settings for iOS");
        await _reinitializeTtsForIOS();
      }
      
    } catch (e) {
      debugPrint("iOS Arabic TTS setup failed: $e");
      await _reinitializeTtsForIOS();
    }
  }
  
  // Warm up TTS engine for more reliable first speech
  Future<void> _warmupTts() async {
    try {
      if (Platform.isIOS) {
        debugPrint("Warming up TTS engine...");
        await _flutterTts.speak(" ");
        await Future.delayed(const Duration(milliseconds: 100));
        await _flutterTts.stop();
        debugPrint("TTS warmup completed");
      }
    } catch (e) {
      debugPrint("TTS warmup error: $e");
    }
  }
  
  // Enhanced iOS TTS fallback
  Future<void> _reinitializeTtsForIOS() async {
    try {
      debugPrint("Attempting iOS TTS fallback initialization");
      
      // Reset TTS instance
      await _flutterTts.stop();
      _flutterTts = FlutterTts();
      
      // Try with shared instance disabled
      await _flutterTts.setSharedInstance(false);
      
      // Minimal audio category setup
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [],
        IosTextToSpeechAudioMode.defaultMode,
      );
      
      // Try different Arabic language codes
      List<String> fallbackLanguages = ['ar-SA', 'ar', 'en-US'];
      bool languageSet = false;
      
      for (String lang in fallbackLanguages) {
        try {
          var isAvailable = await _flutterTts.isLanguageAvailable(lang);
          if (isAvailable) {
            await _flutterTts.setLanguage(lang);
            await _flutterTts.setSpeechRate(0.5);
            await _flutterTts.setVolume(1.0);
            
            debugPrint("iOS TTS fallback set to: $lang");
            languageSet = true;
            break;
          }
        } catch (e) {
          debugPrint("Failed to set language $lang: $e");
          continue;
        }
      }
      
      if (!languageSet) {
        debugPrint("iOS TTS fallback: No suitable language found");
      }
      
      // Warm up TTS engine
      await _warmupTts();
      
    } catch (e) {
      debugPrint("iOS TTS fallback initialization failed: $e");
    }
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity()
      .onConnectivityChanged
      .listen((List<ConnectivityResult> results) {
        if (!mounted) return;
        setState(() => _isOffline = results.contains(ConnectivityResult.none));
      });
  }

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  void _cleanupResources() {
    try {
      _connectivitySubscription.cancel();
      _positionStream?.cancel();
      gem.RoutingService.cancelRoute(_routingHandler!);
      gem.NavigationService.cancelNavigation(_navigationHandler);
      _flutterTts.stop();
      gem.GemKit.release();
      WakelockPlus.disable();
    } catch (e) {
      debugPrint("Error during resource cleanup: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    
    // Handle iOS and Android location permission differently
    if (Platform.isIOS) {
      await _handleiOSLocationPermission();
    } else {
      await _handleAndroidLocationPermission();
    }
  }

  Future<void> _handleiOSLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setLocationError('خدمات الموقع غير مفعلة. يرجى تفعيلها من الإعدادات');
        _showLocationServiceDialog();
        return;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      // Handle different iOS permission states
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setLocationError('تم رفض إذن الموقع');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _setLocationError('تم رفض إذن الموقع نهائياً. يرجى تفعيله من الإعدادات');
        _showPermissionDialog();
        return;
      }

      // Get location with iOS-optimized settings
      await _getLocationWithSettings();
    } catch (e) {
      _setLocationError('خطأ في الحصول على الموقع: $e');
    }
  }

  Future<void> _handleAndroidLocationPermission() async {
    try {
      // Check current permission status first
      var status = await Permission.locationWhenInUse.status;
      
      // If not granted, request permission
      if (!status.isGranted) {
        status = await Permission.locationWhenInUse.request();
      }
      
      // Handle different permission states
      if (status.isDenied) {
        _setLocationError(kLocationPermissionDenied);
        return;
      } else if (status.isPermanentlyDenied) {
        _setLocationError('تم رفض إذن الموقع نهائياً. يرجى تفعيله من الإعدادات');
        _showPermissionDialog();
        return;
      } else if (status.isRestricted) {
        _setLocationError('إذن الموقع مقيد على هذا الجهاز');
        return;
      }

      await _getLocationWithSettings();
    } catch (e) {
      _setLocationError('خطأ في الحصول على الموقع: $e');
    }
  }

  Future<void> _getLocationWithSettings() async {
    try {
      final LocationSettings locationSettings = Platform.isIOS
          ? AppleSettings(
              accuracy: LocationAccuracy.high,
              activityType: ActivityType.automotiveNavigation,
              distanceFilter: 10,
              pauseLocationUpdatesAutomatically: false,
              showBackgroundLocationIndicator: true,
            )
          : AndroidSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
              forceLocationManager: false,
              intervalDuration: const Duration(seconds: 10),
              foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationText: "تطبيق روتيكو يستخدم موقعك للملاحة",
                notificationTitle: "الملاحة نشطة",
                enableWakeLock: true,
              ),
            );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      
      if (!mounted) return;
      
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
      
      _updateMapCenter(position);
      _buildRouteIfDestinationExists();
    } catch (e) {
      _setLocationError('$kLocationFetchFailed: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('إذن الموقع مطلوب'),
            content: const Text(
              'هذا التطبيق يحتاج إلى إذن الموقع لتوفير خدمات الملاحة. يرجى تفعيل إذن الموقع من الإعدادات.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isIOS) {
                    Geolocator.openAppSettings();
                  } else {
                    openAppSettings();
                  }
                },
                child: const Text('الإعدادات'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('خدمات الموقع غير مفعلة'),
            content: const Text(
              'يرجى تفعيل خدمات الموقع من إعدادات الجهاز لاستخدام الملاحة.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Geolocator.openLocationSettings();
                },
                child: const Text('الإعدادات'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setLocationError(String message) {
    if (!mounted) return;
    setState(() => _isLoadingLocation = false);
    _showSnackBar(message);
  }

  void _updateMapCenter(Position position) {
    _mapController?.centerOnCoordinates(gem.Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    ));
  }

  void _buildRouteIfDestinationExists() {
    if (_destinationCoords != null && !_areRoutesBuilt) {
      _buildRoute(
        gem.Landmark.withLatLng(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        ),
        gem.Landmark.withLatLng(
          latitude: _destinationCoords!.latitude,
          longitude: _destinationCoords!.longitude,
        ),
      );
    }
  }

  Future<void> _startLocationTracking() async {
    // Platform-specific permission handling
    if (Platform.isIOS) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        _setLocationError('إذن الموقع غير مُفعّل للملاحة');
        return;
      }
    } else {
      final status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        _setLocationError('إذن الموقع غير مُفعّل للملاحة');
        return;
      }
    }

    try {
      if (!_hasLiveDataSource) {
        gem.PositionService.instance.setLiveDataSource();
        _hasLiveDataSource = true;
      }

      // Platform-specific location settings for tracking
      final LocationSettings locationSettings = Platform.isIOS
          ? AppleSettings(
              accuracy: LocationAccuracy.bestForNavigation,
              activityType: ActivityType.automotiveNavigation,
              distanceFilter: 3,
              pauseLocationUpdatesAutomatically: false,
              showBackgroundLocationIndicator: true,
            )
          : AndroidSettings(
              accuracy: LocationAccuracy.bestForNavigation,
              distanceFilter: 3,
              forceLocationManager: false,
              intervalDuration: const Duration(seconds: 2),
              foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationText: "تطبيق روتيكو يستخدم موقعك للملاحة",
                notificationTitle: "الملاحة نشطة",
                enableWakeLock: true,
              ),
            );

      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (position) {
          if (!mounted) return;
          setState(() => _currentPosition = position);
          _updateNavigationProgress();
        },
        onError: (error) {
          debugPrint('Location tracking error: $error');
          if (mounted) {
            _showSnackBar('خطأ في تتبع الموقع: $error');
          }
        },
      );
    } catch (e) {
      _showSnackBar('تعذر تتبع الموقع: $e');
    }
  }

  void _updateNavigationProgress() {
    if (_currentRoute == null) return;

    _remainingTimeDistance = _currentRoute!.getTimeDistance(activePart: true);
    
    setState(() {
      _remainingDistance = _remainingTimeDistance!.totalDistanceM.toDouble();
      _remainingDuration = _remainingTimeDistance!.totalTimeS;
      _routeProgress = ((_totalDistance - _remainingDistance) / _totalDistance).clamp(0.0, 1.0);
      _expectedArrivalTime = DateTime.now().add(Duration(seconds: _remainingDuration));
      
      // Check arrival
      if (!_showArrivalMessage && _remainingDistance <= kArrivalThreshold) {
        _handleArrival();
      }
    });
  }

  void _handleArrival() {
    setState(() => _showArrivalMessage = true);
    Future.delayed(const Duration(seconds: 10), _stopNavigation);
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$kSearchEndpoint?q=$query')
      ).timeout(kApiTimeout);
      
      if (response.statusCode == 200) {
        setState(() => _searchResults = json.decode(response.body));
      } else {
        throw Exception('فشل تحميل نتائج البحث');
      }
    } catch (e) {
      _showSnackBar('$kSearchFailed: $e');
    }
  }

  void _selectDestination(dynamic result) {
    FocusScope.of(context).unfocus();
    
    setState(() {
      _destinationName = result['firstname'];
      _isSearching = false;
      _searchController.clear();
      _destinationCoords = gem.Coordinates(
        latitude: result['latitude'],
        longitude: result['longitude'],
      );
    });

    if (_currentPosition != null) {
      _buildRoute(
        gem.Landmark.withLatLng(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        ),
        gem.Landmark.withLatLng(
          latitude: result['latitude'],
          longitude: result['longitude'],
        ),
      );
    } else {
      _showSnackBar('بانتظار الموقع الحالي...');
      _getCurrentLocation();
    }
  }

  void _buildRoute(gem.Landmark departure, gem.Landmark destination) {
    final routePreferences = gem.RoutePreferences()
      ..transportMode = gem.RouteTransportMode.car
      ..routeType = gem.RouteType.fastest;
      
    setState(() => _isCalculatingRoute = true);
    _showSnackBar('جاري حساب الطريق...', duration: const Duration(seconds: 3));

    _mapController?.preferences.routes.clear();

    _routingHandler = gem.RoutingService.calculateRoute(
      [departure, destination],
      routePreferences,
      (err, routes) {
        if (!mounted) return;
        
        setState(() => _isCalculatingRoute = false);
        ScaffoldMessenger.of(context).clearSnackBars();

        if (err == gem.GemError.success && routes != null && routes.isNotEmpty) {
          _handleRouteSuccess(routes.first);
        } else {
          _handleRouteError(err);
        }
      },
    );
  }

  void _handleRouteSuccess(gem.Route route) {
    _currentRoute = route;
    _currentTimeDistance = route.getTimeDistance(activePart: false);
    _remainingTimeDistance = route.getTimeDistance(activePart: true);
    
    setState(() {
      _areRoutesBuilt = true;
      _totalDistance = _currentTimeDistance!.totalDistanceM.toDouble();
      _remainingDistance = _remainingTimeDistance!.totalDistanceM.toDouble();
      _remainingDuration = _remainingTimeDistance!.totalTimeS;
      _expectedArrivalTime = DateTime.now().add(Duration(seconds: _remainingDuration));
    });

    _mapController!.preferences.routes
      ..clear()
      ..add(route, true, label: "طريق إلى $_destinationName");

    _mapController!.centerOnRoutes(routes: [route]);
    _logTrafficEvents(route);
  }

  void _logTrafficEvents(gem.Route route) {
    for (final event in route.trafficEvents) {
      debugPrint('Traffic Event: ${event.description}');
    }
  }

  void _handleRouteError(gem.GemError? err) {
    final errorMsg = err == gem.GemError.noRoute 
        ? kNoRouteAvailable 
        : kRouteCalculationFailed;
        
    _showSnackBar(errorMsg);
    setState(() => _areRoutesBuilt = false);
  }

  void _onMapCreated(gem.GemMapController controller) {
    _mapController = controller;
    _configureSdkLanguage();
    _setupMapCallbacks();
    _centerMapIfPositionExists();
  }

  void _configureSdkLanguage() {
    try {
      final arabicLang = gem.SdkSettings.languageList
          .firstWhere((lang) => lang.languagecode == 'ara');
          
      gem.SdkSettings.language = arabicLang;
      gem.SdkSettings.setTTSLanguage(arabicLang);
      gem.SdkSettings.mapLanguage = gem.MapLanguage.automaticLanguage;
    } catch (e) {
      debugPrint("Language configuration error: $e");
    }
    
    gem.SoundPlayingService.canPlaySounds = !_isVoiceMuted;
  }

  void _setupMapCallbacks() {
    _mapController?.registerMoveCallback((Point<num> from, Point<num> to) {
      if (currentInstruction != null && mounted) {
        setState(() {
          _isMapMovedByUser = true;
          _isFollowingPosition = false;
        });
      }
    });
  }

  void _centerMapIfPositionExists() {
    if (_currentPosition != null) {     
      _mapController?.centerOnCoordinates(gem.Coordinates(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      ));
    }
  }

  void _startNavigation() {
    final mainRoute = _mapController?.preferences.routes.mainRoute;
    if (mainRoute == null) {
      _showSnackBar("لا يوجد طريق متاح");
      return;
    }

    WakelockPlus.enable();
    _startLocationTracking();
    _mapController?.startFollowingPosition();
    
    setState(() {
      _isFollowingPosition = true;
      _showRecenterButton = false;
      _isMapMovedByUser = false;
    });

    _navigationHandler = gem.NavigationService.startNavigation(
      mainRoute,
      null,
      onNavigationInstruction: (instruction, events) {
        if (!mounted) return;
        setState(() => currentInstruction = instruction);
      },
      onTextToSpeechInstruction: (ttsInstruction) {
        if (!_isVoiceMuted) _speak(ttsInstruction);
      },
      onError: (error) {
        if (error != gem.GemError.cancel && mounted) {
          _showSnackBar('$kNavigationFailed: $error');
        }
        _stopNavigation();
      },
    );
    
    _speak("ابدأ الملاحة نحو الوجهة");
  }
  
  Future<bool> _speak(String text) async {
    if (_isVoiceMuted || !_isTtsInitialized) return false;
    
    try {
      // Stop any ongoing speech first
      await _flutterTts.stop();
      
      // For iOS first speech, add a delay to ensure TTS is ready
      if (Platform.isIOS && _isFirstSpeech) {
        debugPrint("Delaying first speech on iOS...");
        await Future.delayed(const Duration(milliseconds: 500));
        _isFirstSpeech = false;
      }

      // Platform-specific volume and speech handling
      if (Platform.isIOS) {
        // For iOS, ensure audio session is active and volume is set
        await _flutterTts.setVolume(1.0);
        
        // Check current language setting
        var currentLanguage = await _flutterTts.getDefaultEngine;
        debugPrint("Current TTS language/engine: $currentLanguage");
        
        // Verify Arabic is still available before speaking
        var isArabicAvailable = await _flutterTts.isLanguageAvailable('ar-SA');
        if (!isArabicAvailable) {
          // Try to re-setup Arabic TTS
          debugPrint("Arabic TTS not available, attempting to re-setup");
          await _setupiOSArabicTts();
          
          // If still not available, check if we can use any Arabic variant
          isArabicAvailable = await _flutterTts.isLanguageAvailable('ar');
          if (!isArabicAvailable) {
            debugPrint("No Arabic TTS available, using fallback message");
            // Use a simple fallback for critical navigation instructions
            if (text.contains('اتجه') || text.contains('انعطف') || text.contains('استمر')) {
              text = "Navigation instruction";
              await _flutterTts.setLanguage("en-US");
            }
          }
        }
        
        // iOS sometimes needs a small delay before speaking
        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        await _flutterTts.setVolume(1.0);
      }
      
      // Attempt to speak
      int result = await _flutterTts.speak(text).timeout(
        const Duration(seconds: 10),
        onTimeout: () => 0,
      );
      bool success = result == 1;
      
      // iOS-specific retry logic
      if (!success && Platform.isIOS) {
        debugPrint("iOS TTS speak failed, attempting recovery");
        await _reinitializeTtsForIOS();
        
        // Retry once with fallback
        await Future.delayed(const Duration(milliseconds: 200));
        result = await _flutterTts.speak(text).timeout(
          const Duration(seconds: 5),
          onTimeout: () => 0,
        );
        success = result == 1;
        
        if (!success) {
          debugPrint("iOS TTS retry also failed");
        }
      }
      
      return success;
    } catch (e) {
      debugPrint("TTS speak error: $e");
      
      // Auto-recovery for iOS
      if (Platform.isIOS && mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _isFirstSpeech = true;
            _setupiOSArabicTts();
          }
        });
      }
      
      return false;
    }
  }

  void _stopNavigation() {
    if (!mounted) return;
    
    WakelockPlus.disable();
    gem.NavigationService.cancelNavigation(_navigationHandler);
    _positionStream?.cancel();
    _flutterTts.stop();
    
    setState(() {
      currentInstruction = null;
      _remainingDistance = 0.0;
      _remainingDuration = 0;
      _routeProgress = 0.0;
      _showRecenterButton = false;
      _showArrivalMessage = false;
      _isMapMovedByUser = false;
      _expectedArrivalTime = null;
    });
    
    _mapController?.stopFollowingPosition();
  }

  void _abandonDirections() {
    _stopNavigation();
    setState(() {
      _areRoutesBuilt = false;
      _destinationName = null;
      _destinationCoords = null;
      _currentRoute = null;
      _currentTimeDistance = null;
      _remainingTimeDistance = null;
      _expectedArrivalTime = null;
    });
    _mapController?.preferences.routes.clear();
  }

  void _toggleVoiceMute() {
    setState(() => _isVoiceMuted = !_isVoiceMuted);
    gem.SoundPlayingService.canPlaySounds = !_isVoiceMuted;
    
    if (_isVoiceMuted) {
      gem.SoundPlayingService.cancelNavigationSoundsPlaying();
      _flutterTts.stop();
    }
  }

  void _showSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: duration)
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} م';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} كم';
    }
  }

  String _formatTime(int seconds) {
    if (seconds < 60) {
      return '$seconds ثانية';
    } else {
      final minutes = seconds ~/ 60;
      if (minutes < 60) {
        return '$minutes دقيقة';
      } else {
        final hours = minutes ~/ 60;
        final remainingMinutes = minutes % 60;
        return '${hours}س ${remainingMinutes}د';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) return const OfflineScreen();
    
    final isNavigating = currentInstruction != null;
    final screenPadding = MediaQuery.of(context).padding;
    final formattedETA = _expectedArrivalTime == null
      ? '--:--'
      : '${_expectedArrivalTime!.hour.toString().padLeft(2, '0')}:${_expectedArrivalTime!.minute.toString().padLeft(2, '0')}';
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          gem.GemMap(
            key: const ValueKey("GemMap"),
            onMapCreated: _onMapCreated,
            appAuthorization: widget.apiKey,
            initialMapStyleAsset: kMapStyleAsset,
          ),
          
          if (!isNavigating)
            Positioned(
              top: screenPadding.top + 10,
              right: 16,
              left: 16,
              child: _buildFloatingSearchBar(),
            ),

          if (isNavigating && currentInstruction != null && !_showArrivalMessage)
            Positioned(
              top: screenPadding.top + 20,
              left: 0,
              right: 0,
              child: Center(
                child: NavigationInstructionPanel(
                  instruction: currentInstruction!,
                  isVoiceMuted: _isVoiceMuted,
                  onToggleVoice: _toggleVoiceMute,
                  expectedArrivalTime: formattedETA,
                ),
              ),
            ),

          if (_showArrivalMessage)
            Positioned(
              top: screenPadding.top + 20,
              right: 0,
              left: 0,
              child: Center(
                child: _buildArrivalMessage(),
              ),
            ),

          if (_destinationName != null && !_isSearching && !isNavigating)
            Positioned(
              top: screenPadding.top + 70,
              right: 16,
              child: _buildDestinationChip(),
            ),

          if (_isSearching)
            Positioned(
              top: screenPadding.top + 70,
              right: 0,
              left: 0,
              child: _buildSearchResults(),
            ),

          // Bottom Navigation Panel
          if (isNavigating)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: NavigationBottomPanel(
                destinationName: "طريق إلى $_destinationName",
                remainingDistance: _formatDistance(_remainingDistance),
                remainingDuration: _formatTime(_remainingDuration),
                progress: _routeProgress,
                isVoiceMuted: _isVoiceMuted,
                onToggleVoice: _toggleVoiceMute,
                onExit: _abandonDirections,
              ),
            ),

          // Recenter Button
          if (isNavigating && _isMapMovedByUser)
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _recenterMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('إعادة تمركز الخريطة'),
                ),
              ),
            ),

          // Start Navigation Button
          if (_areRoutesBuilt && !isNavigating && !_isSearching)
            Positioned(
              bottom: screenPadding.bottom + 100,
              right: 0,
              left: 0,
              child: Center(
                child: FloatingActionButton.extended(
                  backgroundColor: kPrimaryColor,
                  icon: const Icon(Icons.directions, color: Colors.white),
                  label: const Text('ابدأ', style: TextStyle(color: Colors.white)),
                  onPressed: _startNavigation,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      resizeToAvoidBottomInset: false,
    );
  }

  void _recenterMap() {
    _mapController?.startFollowingPosition();
    setState(() {
      _isMapMovedByUser = false;
      _isFollowingPosition = true;
    });
  }

  Widget _buildArrivalMessage() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 30),
            SizedBox(width: 12),
            Text(
              'وصلت الى وجهتك',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingSearchBar() {
    return Hero(
      tag: 'searchbar',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 8),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: _logoLoaded ? Colors.transparent : kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: _logoLoaded
                          ? Image.asset(kLogoAsset, fit: BoxFit.cover)
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: _isSearching,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(CupertinoIcons.search, color: Colors.grey),
                        hintText: 'البحث',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onChanged: _performSearch,
                      onTap: () => setState(() => _isSearching = true),
                    ),
                  ),
                  if (!_isSearching && _areRoutesBuilt)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: _abandonDirections,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationChip() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: _isCalculatingRoute
            ? _buildRouteCalculationIndicator()
            : _areRoutesBuilt
                ? _buildRouteInfo()
                : _buildRouteError(),
      ),
    );
  }

  Widget _buildRouteCalculationIndicator() {
    return Row(
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "جاري حساب الطريق",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteInfo() {
    return Row(
      children: [
        Text(
          "الطريق إلى $_destinationName",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.route, color: Colors.green),
      ],
    );
  }

  Widget _buildRouteError() {
    return Row(
      children: [
        Text(
          "لا يوجد طريق متاح",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.warning, color: Colors.orange),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) return Container();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final result = _searchResults[index];
            return ListTile(
              leading: const Icon(Icons.location_on, color: kPrimaryColor),
              title: Text(result['firstname'] ?? 'Unknown', textDirection: TextDirection.rtl),
              subtitle: Text(
                "${result['street']}, ${result['area']}, ${result['governorate']}",
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
              onTap: () => _selectDestination(result),
            );
          },
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    final shouldHide = currentInstruction != null || 
                      _isSearching || 
                      (_areRoutesBuilt && !_isSearching);
                      
    return shouldHide 
        ? null 
        : FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: _getCurrentLocation,
            child: const Icon(Icons.my_location, color: Colors.white),
          );
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.signal_wifi_off, size: 120, color: Colors.redAccent),
              SizedBox(height: 20),
              Text(
                kConnectivityLost,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationInstructionPanel extends StatefulWidget {
  final gem.NavigationInstruction instruction;
  final bool isVoiceMuted;
  final VoidCallback onToggleVoice;
  final String expectedArrivalTime;

  const NavigationInstructionPanel({
    super.key,
    required this.instruction,
    required this.isVoiceMuted,
    required this.onToggleVoice,
    required this.expectedArrivalTime,
  });

  @override
  State<NavigationInstructionPanel> createState() => _NavigationInstructionPanelState();
}

class _NavigationInstructionPanelState extends State<NavigationInstructionPanel> {
  gem.NavigationInstruction? _previousInstruction;

  @override
  void initState() {
    super.initState();
    _previousInstruction = widget.instruction;
  }

  @override
  void didUpdateWidget(covariant NavigationInstructionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_imagesEqual(widget.instruction, oldWidget.instruction)) {
      setState(() => _previousInstruction = widget.instruction);
    }
  }

  bool _imagesEqual(gem.NavigationInstruction a, gem.NavigationInstruction b) {
    final imgA = a.nextNextTurnImg?.getRenderableImage()?.bytes;
    final imgB = b.nextNextTurnImg?.getRenderableImage()?.bytes;
    return imgA != null && imgB != null && 
        const ListEquality().equals(imgA, imgB);
  }

  @override
  Widget build(BuildContext context) {
    final instructionText = widget.instruction.nextTurnInstruction ?? 'تابع للأمام';
    final imageBytes = widget.instruction.nextNextTurnImg?.getRenderableImage()?.bytes;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    widget.isVoiceMuted ? Icons.volume_off : Icons.volume_up,
                    color: widget.isVoiceMuted ? Colors.grey : kPrimaryColor,
                  ),
                  onPressed: widget.onToggleVoice,
                ),
                Expanded(
                  child: Text(
                    instructionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes,
                          width: 30,
                          height: 30,
                          gaplessPlayback: true,
                        )
                      : const Icon(Icons.navigation, size: 30, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, color: kPrimaryColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'وقت الوصول المتوقع: ${widget.expectedArrivalTime}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBottomPanel extends StatelessWidget {
  final String destinationName;
  final String remainingDistance;
  final String remainingDuration;
  final double progress;
  final bool isVoiceMuted;
  final VoidCallback onToggleVoice;
  final VoidCallback onExit;

  const NavigationBottomPanel({
    super.key,
    required this.destinationName,
    required this.remainingDistance,
    required this.remainingDuration,
    required this.progress,
    required this.isVoiceMuted,
    required this.onToggleVoice,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              destinationName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCompactInfoItem(Icons.alt_route, remainingDistance),
                      _buildCompactInfoItem(Icons.access_time, remainingDuration),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCompactButton(
                        icon: isVoiceMuted ? Icons.volume_off : Icons.volume_up,
                        color: isVoiceMuted ? Colors.grey : kPrimaryColor,
                        onTap: onToggleVoice,
                      ),
                      _buildCompactButton(
                        icon: Icons.close,
                        color: Colors.red,
                        onTap: onExit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoItem(IconData icon, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kPrimaryColor, size: 20),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
  
  Widget _buildCompactButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}