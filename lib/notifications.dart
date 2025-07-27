import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'services/secure_storage_service.dart';

class NotificationModel {
  final int id;
  final int user;
  final String text;
  final int order;
  final DateTime datetime;

  NotificationModel({
    required this.id,
    required this.user,
    required this.text,
    required this.order,
    required this.datetime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['Id'] as int,
      user: json['user'] as int,
      text: json['text'] as String,
      order: json['order'] as int,
      datetime: DateTime.parse(json['datetime'] as String),
    );
  }

  // Helper method to format the date nicely
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(datetime);

    if (difference.inDays == 0) {
      // Today - show time only
      return 'اليوم ${DateFormat.jm().format(datetime)}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'أمس ${DateFormat.jm().format(datetime)}';
    } else if (difference.inDays < 7) {
      // Within the last week
      return '${_getDayName(datetime)} ${DateFormat.jm().format(datetime)}';
    } else {
      // More than a week ago
      return DateFormat('yyyy/MM/dd - hh:mm a').format(datetime);
    }
  }

  // Helper method to get the Arabic day name
  String _getDayName(DateTime date) {
    final days = [
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت'
    ];
    return days[date.weekday % 7];
  }
}


class NotificationService {
  static const String _notificationsEndpoint = 
    'https://personal-d9p61k4i.outsystemscloud.com/production/rest/v1/notifications';
  
  static const Duration _timeout = Duration(seconds: 30);

  /// Fetches notifications from the API
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      // Get the JWT token from secure storage
      final token = await SecureStorageService.getToken();
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Make the API request
      final response = await http.get(
        Uri.parse(_notificationsEndpoint),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      ).timeout(_timeout);

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> jsonData = json.decode(response.body);
        
        // Convert to a list of Notification objects
        return jsonData
            .map((data) => NotificationModel.fromJson(data))
            .toList()
            // Sort by datetime (newest first)
            ..sort((a, b) => b.datetime.compareTo(a.datetime));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors and rethrow for the UI to display
      throw Exception('Failed to load notifications: $e');
    }
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;
  final Color _primaryColor = const Color(0xFF287EE8);
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notificationsFuture = NotificationService.getNotifications();
    });
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _loadNotifications();
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        backgroundColor: _primaryColor,
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        color: _primaryColor,
        child: FutureBuilder<List<NotificationModel>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !_isRefreshing) {
              return Center(
                child: CircularProgressIndicator(
                  color: _primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyWidget();
            } else {
              return _buildNotificationsList(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: notifications.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, index);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                // Could implement notification detail view if needed
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications,
                              color: _primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'إشعار',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          notification.formattedDate,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notification.text.isEmpty ? 'لا يوجد محتوى للإشعار' : notification.text,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ أثناء تحميل الإشعارات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.contains('Unauthorized') 
                  ? 'يرجى تسجيل الدخول مجدداً للوصول إلى هذه الميزة'
                  : 'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshNotifications,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: Colors.grey[400],
            size: 70,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم عرض الإشعارات الجديدة هنا',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}