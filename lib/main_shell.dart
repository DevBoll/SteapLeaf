import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/session_provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/tag_provider.dart';
import 'core/providers/tea_provider.dart';
import 'screens/collection/collection_screen.dart';
import 'screens/collection/tea_edit_screen.dart';
import 'theme/steapleaf_theme.dart';


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final ValueNotifier<int> _tabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context;
      ctx.read<TeaProvider>().loadAll();
      ctx.read<SessionProvider>().loadAll();
      ctx.read<SessionProvider>().loadActive();
      ctx.read<TagProvider>().loadAll();
      ctx.read<SettingsProvider>().load();
    });
  }

  // Einmalig erstellt, dauerhaft im Baum gehalten (IndexedStack)
  static final List<Widget> _pages = [
    const _HomeTab(),
    const _CollectionTab(),
    const _JournalTab(),
  ];

  @override
  void dispose() {
    _tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack hält alle Tabs im Widget-Baum – kein Rebuild beim Wechsel
      body: ValueListenableBuilder<int>(
        valueListenable: _tabIndex,
        builder: (_, index, _) => IndexedStack(
          index: index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _tabIndex,
        builder: (_, index, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _FloatingStatusBar(),
            _NavBar(
              selectedIndex: index,
              onDestinationSelected: (i) => _tabIndex.value = i,
            ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder<int>(
        valueListenable: _tabIndex,
        builder: (_, index, _) => _ShellFab(tabIndex: index),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Bottom Navigation Bar

typedef _TabDef = ({KanjiDefinition kanji, String label});

const List<_TabDef> _tabDefs = [
  (kanji: SteapLeafKanji.home, label: 'Heim'),
  (kanji: SteapLeafKanji.collection, label: 'Sammlung'),
  (kanji: SteapLeafKanji.journal, label: 'Journal'),
];

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: _tabDefs
          .map((t) => NavigationDestination(
                icon: KanjiIcon(t.kanji, size: KanjiSize.icon),
                selectedIcon: KanjiIcon(
                  t.kanji,
                  size: KanjiSize.icon,
                  color: colorScheme.primary,
                ),
                label: t.label,
              ))
          .toList(),
    );
  }
}

// Floating Status Bar
//
// Zeigt aktive Sessions oder laufende Cold-Brew-Ansätze an.
// Bleibt unsichtbar (SizedBox.shrink), wenn nichts aktiv ist.

class _FloatingStatusBar extends StatelessWidget {
  const _FloatingStatusBar();

  @override
  Widget build(BuildContext context) {
    // TODO: SessionStatusBanner anzeigen wenn activeSession != null
    context.watch<SessionProvider>();
    // TODO: ColdBrewStatusBanner anzeigen wenn aktiver Cold-Brew vorhanden
    return const SizedBox.shrink();
  }
}

// Kontextsensitiver FAB

typedef _FabDef = ({KanjiDefinition kanji, String tooltip});

class _ShellFab extends StatelessWidget {
  const _ShellFab({required this.tabIndex});

  final int tabIndex;

  _FabDef get _config => switch (tabIndex) {
        0 => (kanji: SteapLeafKanji.sessionStart, tooltip: 'Session starten'),
        1 => (kanji: SteapLeafKanji.newItem, tooltip: 'Tee hinzufügen'),
        2 => (kanji: SteapLeafKanji.record, tooltip: 'Manuell erfassen'),
    // TODO: Handle this case.
    int() => throw UnimplementedError(),
      };

  @override
  Widget build(BuildContext context) {
    final config = _config;
    return FloatingActionButton(
      tooltip: config.tooltip,
      onPressed: () {
   if (tabIndex == 1) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const TeaEditScreen(),
          ));
        }
      },
      child: KanjiIcon(
        config.kanji,
        size: KanjiSize.fab,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

// Placeholder-Tabs
//
// Werden durch die echten Feature-Screens ersetzt, sobald diese gebaut sind.

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) =>
      const _TabPlaceholder(SteapLeafKanji.home);
}

class _CollectionTab extends StatelessWidget {
  const _CollectionTab();
  @override
  Widget build(BuildContext context) => const CollectionScreen();
}


class _JournalTab extends StatelessWidget {
  const _JournalTab();
  @override
  Widget build(BuildContext context) =>
      const _TabPlaceholder(SteapLeafKanji.journal);
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder(this.kanji);

  final KanjiDefinition kanji;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KanjiIcon(
        kanji,
        size: KanjiSize.decorative,
        opacity: 0.08,
      ),
    );
  }
}
