import 'package:flutter/material.dart';
import 'home_screen.dart';

class ProfileCompletionScreen extends StatefulWidget {
  final String name;
  final String email;
  final String userId;

  const ProfileCompletionScreen({
    super.key,
    required this.name,
    required this.email,
    required this.userId,
  });

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _completeProfile() {
    if (_ageController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    // Profil bilgilerini kaydet ve ana sayfaya git
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userName: widget.name,
          userEmail: widget.email,
          userAge: int.parse(_ageController.text),
          userCity: _cityController.text,
          userBio: _bioController.text,
          userId: widget.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'Profilini Tamamla',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hoşgeldin ${widget.name}!',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 32),

                  // Yaş field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Yaşın',
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Şehir field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Şehra',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bio field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Kendinden Bahset',
                        hintText: 'Hobilerin, ilgi alanlarını yaz...',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.edit),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Kaydette butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _completeProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kaydette',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
