import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'db/database.dart';
import 'providers.dart';
import 'session.dart';

import 'screens/building_screen.dart';
import 'screens/entrance_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/map_screen.dart';
import 'screens/route_screen.dart';
import 'screens/survey_screen.dart';
import 'store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fixtures = await Fixtures.load();
  // The app's truth from now on: SQLite, seeded from the fixtures once.
  final db = AppDatabase();
  await db.seedIfEmpty(fixtures.buildings, fixtures.entrances);
  _startAt = await lastTab(); // reopen on the tab the app was closed on
  runApp(
    ProviderScope(
      // Hand the two things main() opened to every provider that asks for them.
      overrides: [
        fixturesProvider.overrideWithValue(fixtures),
        databaseProvider.overrideWithValue(db),
      ],
      child: const FieldApp(),
    ),
  );
}

const _tabs = ['/map', '/route', '/inbox'];
var _startAt = _tabs.first;

// A top-level final is created on first use (in FieldApp), after main() has
// read _startAt.
final _router = GoRouter(
  initialLocation: _startAt,
  routes: [
    // The three tabs: each branch keeps its own navigation stack.
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => TabsShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/map',
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/route',
              builder: (context, state) => const RouteScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const InboxScreen(),
              routes: [
                GoRoute(
                  path: 'conversations/:id',
                  builder: (context, state) =>
                      ConversationScreen(id: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Outside the shell: these cover the tab bar, like a stack screen.
    GoRoute(
      path: '/buildings/:id',
      builder: (context, state) =>
          BuildingScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/entrances/:id',
      builder: (context, state) =>
          EntranceScreen(id: state.pathParameters['id']!),
      routes: [
        GoRoute(
          path: 'survey',
          builder: (context, state) =>
              SurveyScreen(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

class FieldApp extends StatelessWidget {
  const FieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Field app',
      routerConfig: _router,
      theme: _buildTheme(_lightColors),
      darkTheme: _buildTheme(_darkColors),
      themeMode: ThemeMode.system, // follow the phone's setting
    );
  }
}

const _lightColors = _AppColors(
  background: Color(0xFFFFFFFF),
  card: Color(0xFFF3F4F6),
  text: Color(0xFF111827),
  muted: Color(0xFF4B5563),
  border: Color(0xFFD1D5DB),
  primary: Color(0xFFC2410C),
  onPrimary: Color(0xFFFFFFFF),
  error: Color(0xFFB91C1C),
);

const _darkColors = _AppColors(
  background: Color(0xFF0B0F17),
  card: Color(0xFF1F2937),
  text: Color(0xFFF9FAFB),
  muted: Color(0xFF9CA3AF),
  border: Color(0xFF374151),
  primary: Color(0xFFFB923C),
  onPrimary: Color(0xFF111827),
  error: Color(0xFFF87171),
);

ThemeData _buildTheme(_AppColors colors) {
  final scheme = ColorScheme(
    brightness: colors == _lightColors ? Brightness.light : Brightness.dark,
    primary: colors.primary,
    onPrimary: colors.onPrimary,
    secondary: colors.primary,
    onSecondary: colors.onPrimary,
    error: colors.error,
    onError: colors.onPrimary,
    surface: colors.background,
    onSurface: colors.text,
    outline: colors.border,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.background,
    cardColor: colors.card,
    cardTheme: CardThemeData(color: colors.card),
    dividerTheme: DividerThemeData(color: colors.border),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.card,
      foregroundColor: colors.text,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.card,
      indicatorColor: colors.primary.withValues(alpha: 0.18),
      labelTextStyle: WidgetStatePropertyAll(TextStyle(color: colors.text)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.card,
      labelStyle: TextStyle(color: colors.muted),
      hintStyle: TextStyle(color: colors.muted),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    ),
  );
}

class _AppColors {
  const _AppColors({
    required this.background,
    required this.card,
    required this.text,
    required this.muted,
    required this.border,
    required this.primary,
    required this.onPrimary,
    required this.error,
  });

  final Color background;
  final Color card;
  final Color text;
  final Color muted;
  final Color border;
  final Color primary;
  final Color onPrimary;
  final Color error;
}

class TabsShell extends ConsumerWidget {
  const TabsShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(fixturesProvider);
    final unread = f.messages
        .where((m) => m.authorId != f.me && !m.readAt.containsKey(f.me))
        .where(
          (m) => f.conversations.any(
            (c) => c.id == m.conversationId && c.participantIds.contains(f.me),
          ),
        )
        .length;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        // Tapping the current tab again goes back to its first screen.
        onDestinationSelected: (i) {
          shell.goBranch(i, initialLocation: i == shell.currentIndex);
          saveLastTab(_tabs[i]);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          const NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'My route',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.mail_outline),
            ),
            label: 'Inbox',
          ),
        ],
      ),
    );
  }
}
