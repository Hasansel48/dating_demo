import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // Örnek kullanıcı listesi
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Ahmet Yılmaz',
      'lastMessage': 'Merhaba, nasılsın?',
      'time': '10:30',
      'unread': 2,
      'avatar': Icons.person,
    },
    {
      'name': 'Ayşe Demir',
      'lastMessage': 'Yarın görüşürüz',
      'time': 'Dün',
      'unread': 0,
      'avatar': Icons.person,
    },
    {
      'name': 'Mehmet Kaya',
      'lastMessage': 'Teşekkürler!',
      'time': '2 gün önce',
      'unread': 1,
      'avatar': Icons.person,
    },
    {
      'name': 'Fatma Şahin',
      'lastMessage': 'İyi günler',
      'time': '3 gün önce',
      'unread': 0,
      'avatar': Icons.person,
    },
  ];

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sohbetler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Arama özelliği
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profil')),
              const PopupMenuItem(value: 'settings', child: Text('Ayarlar')),
              const PopupMenuItem(value: 'logout', child: Text('Çıkış Yap')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              child: Icon(user['avatar'], color: Colors.white),
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
                      style: TextStyle(
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
                    initialMessages: [],
                    onMessagesSaved: (_) {},
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni sohbet başlat
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
