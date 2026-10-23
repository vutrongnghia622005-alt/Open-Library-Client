import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import 'about_page.dart';
import 'avatar_image.dart';
import 'change_password_page.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import 'settings_service.dart';

/// Account landing page: identity, shelf shortcut, account and app settings.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.authService,
    required this.settings,
    required this.onShelfTap,
  });
  final AuthService authService;
  final SettingsService settings;
  final VoidCallback onShelfTap;

  void _open(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  void _editProfile(BuildContext context) => _open(
    context,
    EditProfilePage(authService: authService, settings: settings),
  );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([authService, settings]),
    builder: (context, _) {
      final user = authService.currentUser;
      if (user == null) return const SizedBox.shrink();
      final english = settings.language == 'en';
      final scheme = Theme.of(context).colorScheme;
      final border = BorderSide(
        color: scheme.outlineVariant.withValues(alpha: .8),
      );
      return Scaffold(
        backgroundColor: scheme.surface,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          english ? 'Profile' : 'Cá nhân',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: english ? 'Settings' : 'Cài đặt',
                        icon: const Icon(Icons.settings_outlined, size: 27),
                        onPressed: () =>
                            _open(context, SettingsPage(settings: settings)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _identity(context, user.displayName, user.email, english),
                  const SizedBox(height: 20),
                  _shelfCard(context, english),
                  const SizedBox(height: 26),
                  _heading(english ? 'Account' : 'Tài khoản'),
                  const SizedBox(height: 10),
                  _group(context, border, [
                    _tile(
                      Icons.person_outline,
                      english ? 'Personal information' : 'Thông tin cá nhân',
                      () => _editProfile(context),
                    ),
                    _tile(
                      Icons.lock_outline,
                      english ? 'Change password' : 'Đổi mật khẩu',
                      () => _open(
                        context,
                        ChangePasswordPage(authService: authService),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _heading(english ? 'Settings' : 'Cài đặt'),
                  const SizedBox(height: 10),
                  _group(context, border, [
                    ListTile(
                      leading: const Icon(Icons.notifications_none, size: 24),
                      minLeadingWidth: 28,
                      title: Text(
                        english ? 'Notifications' : 'Thông báo',
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: Switch(
                        value: settings.notifications,
                        onChanged: (value) async {
                          try {
                            await settings.update(notifications: value);
                          } catch (_) {
                            if (context.mounted) _error(context);
                          }
                        },
                      ),
                    ),
                    _tile(
                      Icons.language,
                      english ? 'Language' : 'Ngôn ngữ',
                      () => _open(context, SettingsPage(settings: settings)),
                      trailing: english ? 'English' : 'Tiếng Việt',
                    ),
                    _tile(
                      settings.darkMode
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      english ? 'Appearance' : 'Giao diện',
                      () => _open(context, SettingsPage(settings: settings)),
                      trailing: settings.darkMode
                          ? (english ? 'Dark' : 'Tối')
                          : (english ? 'Light' : 'Sáng'),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  _group(context, border, [
                    _tile(
                      Icons.help_outline,
                      english ? 'Help' : 'Trợ giúp',
                      () => _open(
                        context,
                        AboutPage(help: true, english: english),
                      ),
                    ),
                    _tile(
                      Icons.info_outline,
                      english ? 'About the app' : 'Giới thiệu ứng dụng',
                      () => _open(context, AboutPage(english: english)),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: authService.signOut,
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(english ? 'Sign out' : 'Đăng xuất'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accent,
                      side: const BorderSide(
                        color: AppTheme.accent,
                        width: 1.3,
                      ),
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  static Color _tint(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF4B2B35)
      : const Color(0xFFFFEEE9);

  Widget _identity(
    BuildContext context,
    String name,
    String email,
    bool english,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final tint = _tint(context);
    return Row(
      children: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _editProfile(context),
          child: SizedBox.square(
            dimension: 76,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AvatarImage(radius: 38, bytes: settings.avatarBytes),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 15,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 96),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: tint,
              foregroundColor: AppTheme.accent,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 34),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _editProfile(context),
            child: Text(
              english ? 'Edit' : 'Sửa hồ sơ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _shelfCard(BuildContext context, bool english) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? const Color(0xFF3A2630) : const Color(0xFFFFF3EE),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onShelfTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: AppTheme.accent,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      english ? 'My bookshelf' : 'Tủ sách của tôi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      english
                          ? 'Saved books and reading progress'
                          : 'Sách đã lưu và tiến độ đọc',
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurface),
            ],
          ),
        ),
      ),
    );
  }

  static void _error(BuildContext context) => ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(content: Text('Không lưu được cài đặt. Hãy thử lại.')),
      );

  Widget _heading(String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
    ),
  );

  Widget _group(
    BuildContext context,
    BorderSide border,
    List<Widget> children,
  ) => Material(
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      side: border,
      borderRadius: BorderRadius.circular(16),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(height: 1, indent: 56),
          children[i],
        ],
      ],
    ),
  );

  Widget _tile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? trailing,
  }) => ListTile(
    leading: Icon(icon, size: 24),
    minLeadingWidth: 28,
    title: Text(title, style: const TextStyle(fontSize: 15)),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(fontSize: 14, color: AppTheme.muted),
          ),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, color: AppTheme.muted),
      ],
    ),
    onTap: onTap,
  );
}
