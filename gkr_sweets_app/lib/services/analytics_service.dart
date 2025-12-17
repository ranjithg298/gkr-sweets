import 'package:flutter/material.dart';

class AnalyticsService {
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    // TODO: integrate with Supabase analytics or Firebase Analytics later
    debugPrint('Analytics event: $name, params: $parameters');
  }
}
