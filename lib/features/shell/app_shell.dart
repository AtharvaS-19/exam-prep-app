import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/constants/app_colors.dart';

/// The persistent application shell.
///
/// Rendered once for the lifetime of the app session. GoRouter's [ShellRoute]
/// swaps the [child] (the active tab's screen) while this scaffold and its
/// [NavigationBar] remain mounted and never rebuild on tab switch.
///
/// State preservation: each tab's subtree stays alive via [IndexedStack],
/// so scroll positions, form input, and local state survive tab switches.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  /// The currently active tab's screen, injected by GoRouter's ShellRoute.
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Maps a tab index to its root route path.
  static const List<_TabDestination> _destinations = [
    _TabDestination(
      path: '/home',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _TabDestination(
      path: '/subjects',
      label: 'Subjects',
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
    ),
    _TabDestination(
      path: '/bookmarks',
      label: 'Bookmarks',
      icon: Icons.bookmark_outline_rounded,
      selectedIcon: Icons.bookmark_rounded,
    ),
    _TabDestination(
      path: '/mistakes',
      label: 'Mistakes',
      icon: Icons.highlight_off_outlined,
      selectedIcon: Icons.highlight_off_rounded,
    ),
    _TabDestination(
      path: '/progress',
      label: 'Progress',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
    ),
  ];

  int _activeIndex = 0;

  /// Derives the selected index from the current router location so that
  /// deep-links and programmatic navigation keep the bar in sync.
  int _locationToIndex(String location) {
    for (int i = 0; i < _destinations.length; i++) {
      if (location.startsWith(_destinations[i].path)) return i;
    }
    return 0;
  }

  void _onTabTapped(int index) {
    if (index == _activeIndex) return; // already active — no-op
    setState(() => _activeIndex = index);
    context.go(_destinations[index].path);
  }

  @override
  Widget build(BuildContext context) {
    // Keep the bar in sync when navigating programmatically.
    final String location = GoRouterState.of(context).uri.toString();
    _activeIndex = _locationToIndex(location);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: _AppNavigationBar(
        selectedIndex: _activeIndex,
        destinations: _destinations,
        onDestinationSelected: _onTabTapped,
      ),
    );
  }
}

// ── Navigation bar ─────────────────────────────────────────────────────────────

class _AppNavigationBar extends StatelessWidget {
  const _AppNavigationBar({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final List<_TabDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: AppColors.primaryLight,
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      destinations: destinations.map((dest) {
        return NavigationDestination(
          icon: Icon(
            dest.icon,
            size: 22,
            color: AppColors.textSecondary,
          ),
          selectedIcon: Icon(
            dest.selectedIcon,
            size: 22,
            color: AppColors.primary,
          ),
          label: dest.label,
          tooltip: dest.label,
        );
      }).toList(),
    );
  }
}

// ── Data model ─────────────────────────────────────────────────────────────────

/// Immutable descriptor for a single bottom-navigation destination.
class _TabDestination {
  const _TabDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}