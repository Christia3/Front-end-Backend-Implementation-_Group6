import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'English';
  String selectedCurrency = 'USD (\$)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1E6F3D),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Preferences
          _buildSectionHeader('Preferences'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive order updates and offers'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
            activeColor: const Color(0xFF1E6F3D),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch to dark theme'),
            value: darkModeEnabled,
            onChanged: (value) {
              setState(() {
                darkModeEnabled = value;
              });
            },
            activeColor: const Color(0xFF1E6F3D),
          ),

          // Language Selection
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(selectedLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLanguageSelector();
            },
          ),

          // Currency Selection
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency'),
            subtitle: Text(selectedCurrency),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showCurrencySelector();
            },
          ),

          // Support
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_outlined),
            title: const Text('Contact Us'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showContactUs();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showAboutDialog();
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...['English', 'Spanish', 'French', 'German', 'Chinese'].map((
                lang,
              ) {
                return ListTile(
                  title: Text(lang),
                  trailing: selectedLanguage == lang
                      ? const Icon(Icons.check, color: Color(0xFF1E6F3D))
                      : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = lang;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Currency',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...['USD (\$)', 'EUR (€)', 'GBP (£)', 'JPY (¥)', 'CAD (\$)'].map((
                currency,
              ) {
                return ListTile(
                  title: Text(currency),
                  trailing: selectedCurrency == currency
                      ? const Icon(Icons.check, color: Color(0xFF1E6F3D))
                      : null,
                  onTap: () {
                    setState(() {
                      selectedCurrency = currency;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showContactUs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Us'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@mobileger.com'),
            SizedBox(height: 8),
            Text('Phone: +1 (555) 123-4567'),
            SizedBox(height: 8),
            Text('Hours: Mon-Fri, 9AM-6PM EST'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'MobiLedger',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.agriculture, size: 48),
      applicationLegalese: '© 2024 MobiLedger. All rights reserved.',
      children: const [
        Text(
          'A comprehensive farming marketplace app connecting farmers with buyers.',
        ),
        SizedBox(height: 8),
        Text('Features:'),
        Text('• Buy and sell agricultural products'),
        Text('• Credit tracking system'),
        Text('• Educational resources'),
        Text('• Order management'),
      ],
    );
  }
}
