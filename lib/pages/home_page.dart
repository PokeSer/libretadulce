import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'calculator_page.dart';
import 'foods_page.dart';
import 'global_foods_page.dart';
import 'profile_page.dart';
import 'admin_page.dart';
import 'history_page.dart';
import '../l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      
      // Si el usuario no tiene documento aún, se lo creamos por defecto como "user" (no admin)
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'email': user!.email,
          'role': 'user', // user o admin
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Leemos su rol de Firestore
        if (userDoc.data()?['role'] == 'admin') {
          if (mounted) setState(() => _isAdmin = true);
        }
      }
    }
  }

  List<Widget> get _pages => const [
    CalculatorPage(),
    FoodsPage(),
    GlobalFoodsPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Por si al cambiar de modo el índice se queda fuera de rango
    final int safeIndex = _currentIndex >= _pages.length ? 0 : _currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Icono en el header
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/icon.png',
                  height: 36,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.favorite, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Botón de Admin en la barra superior (solo si el rol en BD es admin)
          if (_isAdmin)
            IconButton(
              icon: const Icon(
                Icons.admin_panel_settings,
                color: Colors.amberAccent,
              ),
              tooltip: l10n.navAdminTooltip,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                );
              },
            ),
        ],
      ),
      body: _pages[safeIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: l10n.navCalculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fastfood_outlined),
            selectedIcon: const Icon(Icons.fastfood),
            label: l10n.navFoods,
          ),
          NavigationDestination(
            icon: const Icon(Icons.public_outlined),
            selectedIcon: const Icon(Icons.public),
            label: l10n.navGlobal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.navHistory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
