import 'package:flutter/material.dart';
import '../../core/services/ad_service.dart';

class AdDebugWidget extends StatelessWidget {
  const AdDebugWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔍 Ad Debug Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'App ID: ${AdService.isInitialized ? "✅ Initialized" : "❌ Not Initialized"}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Banner ID: ${AdService.bannerAdUnitId}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          Text(
            'Status: ${AdService.isInitialized ? "Ready" : "Loading..."}',
            style: TextStyle(
              fontSize: 12,
              color: AdService.isInitialized ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
