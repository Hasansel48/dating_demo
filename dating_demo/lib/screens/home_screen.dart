import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';
import 'search_user_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final int userAge;
  final String userCity;
  final String userBio;
  final String userId;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userAge,
    required this.userCity,
    required this.userBio,
    required this.userId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late int _userAge;
  late String _userCity;
  late String _userBio;

  // Her kullanıcının mesaj geçmişi
  Map<String, List<Map<String, dynamic>>> _chatHistory = {};

  // Hiç mesajlaşmadığımız kullanıcılar (ID ekledim)
  final List<Map<String, dynamic>> _exploreUsers = [
    {
      'id': '000002',
      'name': 'Zeynep Kız',
      'age': 24,
      'city': 'İstanbul',
      'bio': 'Seyahat etmeyi seviyorum. Yeni insanlarla tanışmayı seviyorum.',
      'hasMessaged': false,
    },
    {
      'id': '000003',
      'name': 'Elif Şahin',
      'age': 22,
      'city': 'Ankara',
      'bio': 'Okuma ve yazma severim. Kahve sahibi.',
      'hasMessaged': false,
    },
    {
      'id': '000004',
      'name': 'Merve Yıldız',
      'age': 25,
      'city': 'Izmir',
      'bio': 'Spor yapmayı ve doğa yürüyüşünü seviyorum.',
      'hasMessaged': false,
    },
    {
      'id': '000005',
      'name': 'Selin Aydın',
      'age': 23,
      'city': 'Bursa',
      'bio': 'Müzik öğretmeni. Her zaman yeni şeyler öğrenmeyi seviyorum.',
      'hasMessaged': false,
    },
    {
      'id': '000006',
      'name': 'Deniz Çelik',
      'age': 26,
      'city': 'Antalya',
      'bio': 'Deniz ve sahili seviyorum. Fotoğraf çekmek hobi.',
      'hasMessaged': false,
    },
  ];

  // Mesajlaştığımız kullanıcılar (ID ekledim)
  List<Map<String, dynamic>> _messageUsers = [
    {
      'id': '000002',
      'name': 'Ahmet Yılmaz',
      'age': 27,
      'city': 'İstanbul',
      'bio': 'Yazılımcı, müzik severim',
      'lastMessage': 'Merhaba, nasılsın?',
      'time': '10:30',
      'unread': 2,
      'hasMessaged': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _userAge = widget.userAge;
    _userCity = widget.userCity;
    _userBio = widget.userBio;
  }

  void _onProfileUpdated(int age, String city, String bio) {
    setState(() {
      _userAge = age;
      _userCity = city;
      _userBio = bio;
    });
  }

  void _startChat(
    String userName,
    int userAge,
    String userCity,
    String userBio,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userName: userName,
          userAge: userAge,
          userCity: userCity,
          initialMessages: _chatHistory[userName] ?? [],
          onMessagesSaved: (messages) {
            setState(() {
              _chatHistory[userName] = messages;
            });
          },
        ),
      ),
    ).then((value) {
      // Sohbet sonlandığında, kullanıcıyı message listesine ekle
      setState(() {
        final messageUser = {
          'name': userName,
          'age': userAge,
          'city': userCity,
          'bio': userBio,
          'lastMessage': 'Sohbet başlandı',
          'time': 'Şimdi',
          'unread': 0,
          'hasMessaged': true,
        };

        // Zaten mesajlaştığımız kişi mi kontrol et
        bool alreadyExists = _messageUsers.any((u) => u['name'] == userName);
        if (!alreadyExists) {
          _messageUsers.insert(0, messageUser);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Uygulaması'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchUserScreen(
                    allUsers: _exploreUsers,
                    currentUserId: widget.userId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Explore Sekmesi
          _buildExploreTab(),

          // Messages Sekmesi
          _buildMessagesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Keşfet'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mesajlar'),
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildExploreTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _exploreUsers.length,
      itemBuilder: (context, index) {
        final user = _exploreUsers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue.shade300,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            title: Text(
              user['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.cake, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${user['age']} yaş'),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(user['city']),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    name: user['name'],
                    age: user['age'],
                    city: user['city'],
                    bio: user['bio'],
                    email: '${user['name'].replaceAll(' ', '')}@chat.com',
                    onChatPressed: () {
                      Navigator.pop(context);
                      _startChat(
                        user['name'],
                        user['age'],
                        user['city'],
                        user['bio'],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMessagesTab() {
    if (_messageUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Henüz sohbetiniz yok',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Keşfet sekmesinde kişiler bulun',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _messageUsers.length,
      itemBuilder: (context, index) {
        final user = _messageUsers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              user['name'],
              style: TextStyle(
                fontWeight: user['unread'] > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              user['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: user['unread'] > 0
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: user['unread'] > 0 ? Colors.black87 : Colors.grey,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: user['unread'] > 0 ? Colors.blue : Colors.grey,
                  ),
                ),
                if (user['unread'] > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${user['unread']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    userName: user['name'],
                    userAge: user['age'],
                    userCity: user['city'],
                    initialMessages: _chatHistory[user['name']] ?? [],
                    onMessagesSaved: (messages) {
                      setState(() {
                        _chatHistory[user['name']] = messages;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade800],
              ),
            ),
            accountName: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName),
                Text(
                  'ID: ${widget.userId}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            accountEmail: Text(widget.userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue.shade800),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    userName: widget.userName,
                    userEmail: widget.userEmail,
                    userAge: _userAge,
                    userCity: _userCity,
                    userBio: _userBio,
                    onProfileUpdated: _onProfileUpdated,
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Hakkında'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
