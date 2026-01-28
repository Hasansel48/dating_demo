import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final int userAge;
  final String userCity;
  final String userBio;
  final Function(int, String, String) onProfileUpdated;

  const SettingsScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userAge,
    required this.userCity,
    required this.userBio,
    required this.onProfileUpdated,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _ageController;
  late TextEditingController _cityController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: widget.userAge.toString());
    _cityController = TextEditingController(text: widget.userCity);
    _bioController = TextEditingController(text: widget.userBio);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_ageController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    widget.onProfileUpdated(
      int.parse(_ageController.text),
      _cityController.text,
      _bioController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil başarıyla güncellendi')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Bilgileri Başlığı
            Text(
              'Profil Bilgileri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 16),

            // İsim bilgisi (sadece görüntü)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İsim',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.userName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Email bilgisi (sadece görüntü)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.userEmail,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Yaş (düzenlenebilir)
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Yaşın',
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Şehir (düzenlenebilir)
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Şehir',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bio (düzenlenebilir)
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Kendinden Bahset',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.edit),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Güncelle butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Profili Güncelle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Çıkış Yap butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.red, width: 2),
                ),
                child: const Text(
                  'Çıkış Yap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
