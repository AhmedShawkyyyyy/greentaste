import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = SharedPrefsHelper.isDarkMode();
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    SharedPrefsHelper.setDarkMode(value);
  }

  void _logout() {
    SharedPrefsHelper.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(AppStrings.account),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildFavorites(),
            const SizedBox(height: 20),
            _buildSettings(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final userName = SharedPrefsHelper.getUserName() ?? 'Ahmed Shawky';
    final userEmail = SharedPrefsHelper.getUserEmail() ?? 'User';

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            userEmail,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites() {
    final favorites = SharedPrefsHelper.getFavorites();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.myFavorites,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(AppStrings.seeAll),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: favorites.isEmpty
              ? Center(
            child: Text(
              'No favorites yet',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.fastfood, size: 40),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
              activeColor: AppColors.primary,
            ),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            titleColor: Colors.red,
            iconColor: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}