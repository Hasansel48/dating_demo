import 'package:flutter/material.dart';

class SearchUserScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allUsers;
  final String currentUserId;

  const SearchUserScreen({
    super.key,
    required this.allUsers,
    required this.currentUserId,
  });

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      // ID veya isim ile ara
      _searchResults = widget.allUsers.where((user) {
        final id = user['id'].toString().toLowerCase();
        final name = user['name'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();

        return id.contains(searchQuery) || name.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arkadaş Ara'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Arama barı
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'ID veya isim ile ara...',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Arama sonuçları
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'ID veya isim yazarak ara',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Sonuç bulunamadı',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade300,
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                const SizedBox(width: 12),

                // Bilgiler
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ID: ${user['id']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${user['age']} yaş',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['city'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Mesaj butonu
                Icon(Icons.arrow_forward, color: Colors.blue),
              ],
            ),
          ),
        );
      },
    );
  }
}
