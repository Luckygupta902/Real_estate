import 'package:flutter/material.dart';

import '../models/property.dart';
import '../services/property_service.dart';
import '../services/social_service.dart';
import '../services/auth_service.dart';

import 'add_property_screen.dart';
import 'leads_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'property_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final PropertyService _properties = PropertyService();
  final SocialService _social = SocialService();

  bool _loggedIn = false;

  late Future<List<Property>> _future;

  @override
  void initState() {
    super.initState();

    _future = _properties.getAllProperties();

    // Check whether the user is already logged in.
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      final loggedIn = await _auth.isLoggedIn();

      if (!mounted) return;

      setState(() {
        _loggedIn = loggedIn;
      });
    } catch (e) {
      debugPrint('Login status check failed: $e');
    }
  }

  Future<void> _refresh() async {
    final next = _properties.getAllProperties();

    if (!mounted) return;

    setState(() {
      _future = next;
    });

    try {
      await next;
    } catch (e) {
      debugPrint('Property refresh failed: $e');
    }
  }

  String money(double? price) {
    if (price == null) {
      return 'Price not available';
    }

    return '₹${price.toStringAsFixed(0)}';
  }

  Future<void> _openLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );

    if (!mounted) return;

    await _checkLogin();

    if (result == true) {
      await _refresh();
    }
  }

  Future<void> _openRegister() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );

    if (!mounted) return;

    await _checkLogin();
  }

  Future<void> _openAddProperty() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPropertyScreen(),
      ),
    );

    if (!mounted) return;

    if (created == true) {
      await _refresh();
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.logout();

      if (!mounted) return;

      setState(() {
        _loggedIn = false;
      });

      await _refresh();
    } catch (e) {
      debugPrint('Logout failed: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not log out. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Properties'),
        actions: [
          if (!_loggedIn) ...[
            TextButton(
              onPressed: _openLogin,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: _openRegister,
              child: const Text('Register'),
            ),
          ] else ...[
            IconButton(
              tooltip: 'Add property',
              icon: const Icon(Icons.add_home_work),
              onPressed: _openAddProperty,
            ),
            IconButton(
              tooltip: 'Leads',
              icon: const Icon(Icons.assignment),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LeadsScreen(),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ],
      ),

      body: FutureBuilder<List<Property>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text('Could not load properties'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<Property> properties = snapshot.data ?? [];

          if (properties.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text('No properties available yet'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final p = properties[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 18),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PropertyDetailScreen(
                            property: p,
                          ),
                        ),
                      );

                      if (mounted) {
                        await _refresh();
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.teal.shade50,
                          child: const Icon(
                            Icons.home_work_outlined,
                            size: 65,
                            color: Colors.teal,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                money(p.price),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                '${p.city ?? ''}, ${p.state ?? ''}',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children: [
                                  if (p.bedrooms != null)
                                    Text('🛏 ${p.bedrooms} beds'),
                                  if (p.bathrooms != null)
                                    Text('🛁 ${p.bathrooms} baths'),
                                  if (p.area != null)
                                    Text('${p.area} area'),
                                ],
                              ),

                              const SizedBox(height: 8),

                              if (p.id != null)
                                FutureBuilder<int>(
                                  future: _social.getLikeCount(p.id!),
                                  builder: (context, count) {
                                    return Row(
                                      children: [
                                        const Icon(
                                          Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          count.hasError
                                              ? 'Likes unavailable'
                                              : count.hasData
                                                  ? '${count.data} likes'
                                                  : 'Loading likes...',
                                        ),
                                      ],
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}