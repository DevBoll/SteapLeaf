import 'package:flutter/material.dart';
import 'package:steapleaf/features/collection/collection_screen.dart';
import 'package:steapleaf/features/home/home_screen.dart';
import 'package:steapleaf/features/journal/journal_screen.dart';
import 'package:steapleaf/shared/widgets/floating_session_bar.dart';
import 'package:steapleaf/theme/steapleaf_theme.dart';

/// Die drei Haupt-Tabs der App.
enum _Tab { home, collection, journal }

/// Haupt-Shell der App mit Tab-Navigation und optionaler Session-Leiste.
///
/// Hält die drei Haupt-Screens in einem [IndexedStack], damit kein Rebuild
/// beim Tab-Wechsel stattfindet. Die [FloatingSessionBar] liegt im Body-Stack
/// direkt oberhalb der [NavigationBar].
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  _Tab _activeTab = _Tab.home;

  // TODO: Platzhalter – wird später durch den Session-Provider ersetzt.
  bool _sessionActive = false;


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _activeTab.index,
            children: const [
              HomeScreen(),
              CollectionScreen(),
              JournalScreen(),
            ],
          ),
          if (_sessionActive)
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingSessionBar(
                teaName: 'Gyokuro',
                remainingTime: '2:30',
                onTap: () {
                  // TODO: Session-Detail-Screen öffnen
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _activeTab.index,
        onDestinationSelected: (i) =>
            setState(() => _activeTab = _Tab.values[i]),
        destinations: [
          NavigationDestination(
            icon: Text(SteapLeafKanji.home.character,
                style: textTheme.titleLarge),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Text(SteapLeafKanji.collection.character,
                style: textTheme.titleLarge),
            label: 'Sammlung',
          ),
          NavigationDestination(
            icon: Text(SteapLeafKanji.journal.character,
                style: textTheme.titleLarge),
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}
