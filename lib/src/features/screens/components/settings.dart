import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
                onPressed: (BuildContext context) {
                  // Navigate to language settings
                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: const Icon(Icons.format_paint),
                title: const Text('Enable custom theme'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Edit Profile'),
                onPressed: (BuildContext context) {
                  // Navigate to profile edit screen
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.security),
                title: const Text('Change Password'),
                onPressed: (BuildContext context) {
                  // Navigate to password change screen
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Notifications'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Push Notifications'),
                onToggle: (value) {
                  // Handle push notification toggle
                },
                initialValue: true, // Replace with actual value
              ),
              SettingsTile.switchTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Notifications'),
                onToggle: (value) {
                  // Handle email notification toggle
                },
                initialValue: null, // Replace with actual value
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Privacy'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                leading: const Icon(Icons.lock),
                title: const Text('Private Account'),
                onToggle: (value) {
                  // Handle private account toggle
                },
                initialValue: null, // Replace with actual value
              ),
              SettingsTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Location Privacy'),
                onPressed: (BuildContext context) {
                  // Navigate to location privacy settings
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Data Management'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text('Backup Data'),
                onPressed: (BuildContext context) {
                  // Initiate data backup process
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.cloud_download),
                title: const Text('Restore Data'),
                onPressed: (BuildContext context) {
                  // Initiate data restore process
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('About'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.info),
                title: const Text('App Info'),
                onPressed: (BuildContext context) {
                  // Navigate to app info screen
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                onPressed: (BuildContext context) {
                  // Navigate to help & support screen
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Appearance'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Theme'),
                onPressed: (BuildContext context) {
                  // Navigate to theme selection screen
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Font Size'),
                onPressed: (BuildContext context) {
                  // Navigate to font size settings
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Security'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Biometric Login'),
                onToggle: (value) {
                  // Handle biometric login toggle
                },
                initialValue: null, // Replace with actual value
              ),
              SettingsTile(
                leading: const Icon(Icons.lock),
                title: const Text('Two-Factor Authentication'),
                onPressed: (BuildContext context) {
                  // Navigate to two-factor authentication settings
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Feedback'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.comment),
                title: const Text('Send Feedback'),
                onPressed: (BuildContext context) {
                  // Navigate to feedback submission screen
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.star),
                title: const Text('Rate Us'),
                onPressed: (BuildContext context) {
                  // Navigate to app rating screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
