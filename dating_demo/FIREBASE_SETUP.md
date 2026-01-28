# Firebase Kurulum Rehberi

Bu uygulama Firebase Authentication ve Cloud Firestore kullanmaktadır. Uygulamayı çalıştırmadan önce Firebase'i yapılandırmanız gerekmektedir.

## Adım 1: Firebase Projesi Oluşturma

1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. "Add project" butonuna tıklayın
3. Proje adı girin (örn: "dating-demo")
4. Google Analytics'i isteğe bağlı olarak etkinleştirin
5. "Create project" butonuna tıklayın

## Adım 2: Firebase CLI ve FlutterFire Kurulumu

Terminal'de şu komutları çalıştırın:

```bash
# Firebase CLI'yi yükleyin (henüz yüklemediyseniz)
npm install -g firebase-tools

# Firebase'e giriş yapın
firebase login

# FlutterFire CLI'yi yükleyin
dart pub global activate flutterfire_cli
```

## Adım 3: Firebase Yapılandırması

Proje klasöründe şu komutu çalıştırın:

```bash
flutterfire configure
```

Bu komut:
- Firebase projenizi seçmenizi isteyecek
- Android, iOS, Web ve diğer platformlar için gerekli yapılandırma dosyalarını otomatik oluşturacak
- `firebase_options.dart` dosyasını güncelleyecek

## Adım 4: Firebase Authentication'ı Etkinleştirme

1. Firebase Console'da projenizi açın
2. Sol menüden **Build** > **Authentication** seçin
3. **Get Started** butonuna tıklayın
4. **Sign-in method** sekmesinde **Email/Password** seçeneğini etkinleştirin
5. **Save** butonuna tıklayın

## Adım 5: Cloud Firestore'u Etkinleştirme

1. Firebase Console'da projenizi açın
2. Sol menüden **Build** > **Firestore Database** seçin
3. **Create database** butonuna tıklayın
4. **Start in test mode** seçeneğini seçin (geliştirme için)
   - Üretim için güvenlik kurallarını düzenlemeyi unutmayın!
5. Lokasyon seçin (örn: europe-west1)
6. **Enable** butonuna tıklayın

## Adım 6: Firestore Güvenlik Kuralları (Opsiyonel)

Firestore'da **Rules** sekmesine giderek şu kuralları ekleyebilirsiniz:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Kullanıcılar sadece kendi profillerini okuyabilir ve düzenleyebilir
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Mesajlar (chat özelliği için)
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Adım 7: Android için Ek Yapılandırma

`android/app/build.gradle.kts` dosyasında minimum SDK versiyonunun en az 21 olduğundan emin olun:

```kotlin
minSdk = 21
```

## Adım 8: Uygulamayı Çalıştırma

Tüm adımları tamamladıktan sonra uygulamayı çalıştırabilirsiniz:

```bash
flutter run
```

## Özellikler

✅ **Firebase Authentication**
- Email/şifre ile kayıt olma
- Email/şifre ile giriş yapma
- Otomatik kullanıcı oturumu yönetimi

✅ **Cloud Firestore**
- Kullanıcı profil bilgilerini kaydetme
- Kullanıcı bilgilerini okuma
- Gerçek zamanlı veri senkronizasyonu (gelecekte eklenecek)

## Sorun Giderme

### "Firebase not initialized" hatası
- `flutterfire configure` komutunu tekrar çalıştırın
- `firebase_options.dart` dosyasının mevcut olduğundan emin olun

### "Null check operator used on a null value"
- Firebase servislerinin Firebase Console'da etkinleştirildiğinden emin olun
- `main.dart` dosyasında `Firebase.initializeApp()` çağrısının yapıldığından emin olun

### Android'de "Multidex" hatası
- `android/app/build.gradle.kts` dosyasına multidex desteği ekleyin

## Gelecek Geliştirmeler

- 🔄 Gerçek zamanlı mesajlaşma (Firestore Streams)
- 📷 Profil fotoğrafı yükleme (Firebase Storage)
- 🔔 Bildirimler (Firebase Cloud Messaging)
- 👥 Arkadaş ekleme ve eşleşme sistemi
- 💬 Grup sohbetleri

## Destek

Sorun yaşıyorsanız:
1. `flutter clean` ve `flutter pub get` komutlarını çalıştırın
2. Uygulamayı yeniden başlatın
3. Firebase Console'da servis durumlarını kontrol edin
