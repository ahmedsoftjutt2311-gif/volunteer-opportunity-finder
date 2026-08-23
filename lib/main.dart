import 'package:flutter/material.dart';
import 'shared.dart';

void main() {
  runApp(const VolunteerFinderApp());
}

class VolunteerFinderApp extends StatelessWidget {
  const VolunteerFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volunteer Finder',
      theme: appTheme(),
      home: const VolunteerHomePage(),
    );
  }
}

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  final List<Map<String, dynamic>> opportunities = [
    {
      'title': 'Community Clean-up',
      'category': 'Environment',
      'location': 'City Park',
      'icon': Icons.eco,
    },
    {
      'title': 'Food Distribution',
      'category': 'Community',
      'location': 'Community Center',
      'icon': Icons.volunteer_activism,
    },
    {
      'title': 'Teaching Support',
      'category': 'Education',
      'location': 'Learning Hub',
      'icon': Icons.school,
    },
    {
      'title': 'Tree Plantation',
      'category': 'Environment',
      'location': 'Green Zone',
      'icon': Icons.forest,
    },
  ];

  String searchText = '';
  String selectedCategory = 'All';
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Finder'),
        actions: [
          IconButton(
            tooltip: 'About',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Volunteer Finder',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Flutter Lab Project',
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedTab,
        children: [
          _buildExplorePage(),
          _buildSavedPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (int value) {
          setState(() {
            selectedTab = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }

  Widget _buildExplorePage() {
    final filteredOpportunities = opportunities.where((item) {
      final title = item['title'].toString().toLowerCase();
      final category = item['category'].toString();

      final matchesSearch = title.contains(searchText.toLowerCase());
      final matchesCategory =
          selectedCategory == 'All' || category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return FadeIn(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle(
            title: 'Find an opportunity',
            subtitle: 'Choose a cause and make an impact.',
          ),

          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search opportunities',
            ),
          ),

          const SizedBox(height: 16),

          _buildCategorySelector(),

          const SizedBox(height: 16),

          if (filteredOpportunities.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No opportunities found.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Try another search or category.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...filteredOpportunities.map(
              (opportunity) => _buildOpportunityCard(opportunity),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    const categories = [
      'All',
      'Environment',
      'Community',
      'Education',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (_) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOpportunityCard(Map<String, dynamic> opportunity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          child: Icon(opportunity['icon'] as IconData),
        ),
        title: Text(
          opportunity['title'].toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${opportunity['category']} • ${opportunity['location']}',
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          _showOpportunityDetails(opportunity);
        },
      ),
    );
  }

  void _showOpportunityDetails(Map<String, dynamic> opportunity) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            opportunity['title'].toString(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.category_outlined),
                title: const Text('Category'),
                subtitle: Text(
                  opportunity['category'].toString(),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Location'),
                subtitle: Text(
                  opportunity['location'].toString(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This volunteer opportunity is ready for participants.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'You selected ${opportunity['title']}',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Volunteer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSavedPage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Saved Opportunities',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your saved volunteer opportunities will appear here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}