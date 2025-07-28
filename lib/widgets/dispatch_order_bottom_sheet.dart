import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/dispatch_order.dart';
import '../services/dispatch_order_service.dart';

class DispatchOrderBottomSheet extends StatefulWidget {
  const DispatchOrderBottomSheet({Key? key}) : super(key: key);

  @override
  State<DispatchOrderBottomSheet> createState() => _DispatchOrderBottomSheetState();
}

class _DispatchOrderBottomSheetState extends State<DispatchOrderBottomSheet> {
  bool _isLoading = true;
  String? _errorMessage;
  List<DispatchOrder> _dispatchOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchDispatchOrders();
  }

  Future<void> _fetchDispatchOrders() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final orders = await DispatchOrderService.getDispatchOrders();
      
      if (mounted) {
        setState(() {
          _dispatchOrders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل أوامر التوصيل: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildHeader(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.delivery_dining, size: 24, color: Color(0xFF0C5AA6)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'أوامر التوصيل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0C5AA6)),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF0C5AA6)),
              onPressed: _fetchDispatchOrders,
              tooltip: 'تحديث',
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _dispatchOrders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchDispatchOrders,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_dispatchOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.inbox,
              color: Colors.grey,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد أوامر توصيل حالياً',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _dispatchOrders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final order = _dispatchOrders[index];
        final formattedDate = DateFormat('yyyy/MM/dd - HH:mm').format(order.dateTime);
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'أمر توصيل #${order.id}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(formattedDate),
                    const SizedBox(width: 4),
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  ],
                ),
                if (order.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          order.notes,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.note, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
                if (order.relatedEmployeeNames.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          order.relatedEmployeeNames,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ],
            ),
            trailing: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: order.notified ? Colors.green : Colors.orange,
              ),
            ),
          ),
        );
      },
    );
  }
}
