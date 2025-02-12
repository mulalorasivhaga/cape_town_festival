// lib/features/auth/services/email_verification_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailVerificationService {
  static const String _baseUrl = 'https://api.mailcheck.ai';
  static const String _apiKey = 'XMCdlPTFTh6EaGewegZIcp9LfQJrpLC7'; // API key



  // List of explicitly allowed email domains
  final Set<String> _allowedDomains = {
    'gmail.com',
    'icloud.com',
    'hotmail.com',
    'yahoo.com',
    'myuwc.ac.za',    // MyUWC
    'uwc.ac.za',
    'uct.ac.za',      // UCT
  };

  /// Check if the email domain is allowed
  bool _isAllowedDomain(String email) {
    final domain = email.toLowerCase().split('@').last;

    // Check explicit allowed domains
    if (_allowedDomains.contains(domain)) {
      return true;
    }

    // Check for university domains
    if (domain.endsWith('.ac.za') ||
        domain.endsWith('.edu')) {
      return true;
    }

    return false;
  }

  /// Verify the email address
  Future<(bool isValid, String message)> verifyEmail(String email) async {
    try {
      // Basic format validation first
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        return (false, 'Please enter a valid email address format');
      }

      // Check if domain is allowed
      if (!_isAllowedDomain(email)) {
        return (false, 'Please use a valid email address.');
      }

      // For allowed domains, verify with MailCheck.ai to ensure it's not disposable
      final response = await http.get(
        Uri.parse('$_baseUrl/email/$email'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Reject disposable emails
        if (data['disposable'] == true) {
          return (false, 'Please use a non-disposable email address');
        }

        // Accept the email if it's from allowed domain and not disposable
        return (true, 'Email is valid');
      } else {
        // If API call fails, still check domain restrictions
        return (true, 'Email format is valid');
      }
    } catch (e) {
      // In case of API error, still enforce domain restrictions
      return (true, 'Email format is valid');
    }
  }
}