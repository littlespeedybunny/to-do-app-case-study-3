import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../core/widgets/spatial_background.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../viewmodels/note_viewmodel.dart';
import '../viewmodels/task_viewmodel.dart';
import 'notes/notes_tab.dart';
import 'tasks/tasks_tab.dart';

/// Home screen with tab navigation
/// Main entry point for Notes and Tasks
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Tab değiştiğinde rebuild için listener
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteViewModel>().loadNotes();
      context.read<TaskViewModel>().loadTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: SpatialBackground(
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              // Yatay mod için farklı layout
              if (orientation == Orientation.landscape) {
                return _buildLandscapeLayout(context, themeProvider);
              }
              // Dikey mod için normal layout
              return _buildPortraitLayout(context, themeProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
      BuildContext context, ThemeProvider themeProvider) {
    return Column(
      children: [
        // App bar with theme toggle
        _buildAppBar(context, themeProvider),

        // Tab bar
        _buildTabBar(),

        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              NotesTab(),
              TasksTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
      BuildContext context, ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        // Sol tarafta dikey tab bar
        Container(
          width: 90,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          ),
          child: Column(
            children: [
              _buildAppBar(context, themeProvider),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildVerticalTab(
                      context,
                      index: 0,
                      icon: Icons.note_outlined,
                      label: l10n.notes,
                    ),
                    const SizedBox(height: 12),
                    _buildVerticalTab(
                      context,
                      index: 1,
                      icon: Icons.task_alt_outlined,
                      label: l10n.tasks,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Sağ tarafta content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              NotesTab(),
              TasksTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalTab(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        final isSelected = _tabController.index == index;
        final colorScheme = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () {
            _tabController.animateTo(index);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.2)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize =
        isLandscape ? 14.0 : AppConstants.getTitleFontSize(context);
    final padding = isLandscape ? 8.0 : AppConstants.getPadding(context);
    // Yatay modda kısa başlık, dikey modda tam başlık
    final title = isLandscape ? l10n.appTitleShort : l10n.appTitle;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: isLandscape
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                  tooltip:
                      themeProvider.isDarkMode ? l10n.lightMode : l10n.darkMode,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                  tooltip:
                      themeProvider.isDarkMode ? l10n.lightMode : l10n.darkMode,
                ),
              ],
            ),
    );
  }

  Widget _buildTabBar() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.15),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    isDark
                        ? colorScheme.secondary
                        : colorScheme.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.6),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark
                  ? Colors.white.withOpacity(0.6)
                  : colorScheme.onSurface.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.note_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(l10n.notes),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.task_alt_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(l10n.tasks),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
