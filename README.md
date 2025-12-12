# Günlük Notlar & Görevler 📝

Spatial glass efektleri ve modern UI/UX tasarımına sahip, günlük notlar ve görevleri yönetmek için Flutter uygulaması.

## 📱 Ekran Görüntüleri

<table>
  <tr>
    <td align="center">
      <img src="screenshots/3.png" width="200" alt="Ekran Görüntüsü 3" />
    </td>
    <td align="center">
      <img src="screenshots/4.png" width="200" alt="Ekran Görüntüsü 4" />
    </td>
  </tr>
  <tr>
    <td align="center" colspan="2">
      <img src="screenshots/7.png" width="450" alt="Yatay Ekran Görüntüsü 1" />
    </td>
  </tr>
  <tr>
    <td align="center" colspan="2">
      <img src="screenshots/8.png" width="450" alt="Yatay Ekran Görüntüsü 2" />
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/1.png" width="200" alt="Ekran Görüntüsü 1" />
    </td>
    <td align="center">
      <img src="screenshots/2.png" width="200" alt="Ekran Görüntüsü 2" />
    </td>
  </tr>
</table>

## ✨ Özellikler

### Fonksiyonel Özellikler
- **Not Yönetimi**: Başlık, içerik ve tarih ile notlar oluşturma, görüntüleme ve silme
- **Görev Yönetimi**: Görev ekleme, tamamlanma durumunu işaretleme ve kategorilere göre organize etme
- **Kategoriler**: Görevleri Kişisel, İş, Okul veya Diğer kategorilerine göre organize etme
- **Arama & Filtreleme**: Notlar ve görevlerde arama yapma, görevleri kategoriye göre filtreleme
- **Koyu/Açık Tema**: Spatial glass efektleri ile modern temalar
- **Yerelleştirme**: İngilizce ve Türkçe dil desteği

### Tasarım Özellikleri
- **Spatial Glass Efektleri**: Bulanık efektlerle donuk cam kartlar
- **Animasyonlu Arka Planlar**: 
  - Açık tema: Animasyonlu güneş (hareket eden) (`spatial_background.dart`)
  - Koyu tema: Neon parçacıklar ve parlayan efektler
- **Yumuşak Animasyonlar**: Sayfa geçişleri, Hero animasyonları ve kart animasyonları
- **Modern UI/UX**: Temiz, sezgisel arayüz

## 🏗️ Mimari

Proje **Clean Architecture** prensiplerini takip eder:

```
lib/
├── core/              # Core utilities, constants, themes
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── domain/            # Business logic layer
│   ├── entities/
│   └── repositories/
├── data/              # Data layer
│   ├── database/
│   └── repositories/
└── presentation/      # UI layer (MVVM)
    ├── screens/
    ├── viewmodels/
    ├── widgets/
    └── providers/
```

### Mimari Prensipleri
- **Clean Architecture**: Domain, Data ve Presentation katmanları ile ayrım
- **MVVM Pattern**: State management için ViewModels
- **SOLID Prensipleri**: İyi yapılandırılmış, bakımı kolay kod tabanı
- **Provider**: Provider pattern ile state management
- **Modüler Yapı**: Her özellik ayrı dosyalarda

## 🚀 Kurulum & Çalıştırma

### Gereksinimler
- **Flutter SDK**: >=3.0.0 <4.0.0
- **Dart SDK**: >=3.0.0

### Adımlar

1. **Projeyi Klonlayın**
   ```bash
   git clone <repository-url>
   cd todo_note
   ```

2. **Bağımlılıkları Yükleyin**
   ```bash
   flutter pub get
   ```
   > **Not**: Yerelleştirme dosyaları (`pubspec.yaml`'daki `generate: true` ayarı sayesinde) otomatik olarak oluşturulur.

3. **Uygulamayı Çalıştırın**
   ```bash
   flutter run
   ```

### Platforma Özel Çalıştırma
- **iOS**: `flutter run -d ios`
- **Android**: `flutter run -d android`
- **Web**: `flutter run -d chrome`
- **macOS**: `flutter run -d macos`

## 🛠️ Kullanılan Teknolojiler

- **Flutter**: UI framework
- **Provider**: State management
- **SQLite (sqflite)**: Yerel veritabanı
- **Shared Preferences**: Tema kalıcılığı
- **Google Fonts**: Tipografi
- **Flutter Localizations**: Yerelleştirme

### Bağımlılıklar

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  provider: ^6.1.1
  sqflite: ^2.3.0
  path: ^1.8.3
  shared_preferences: ^2.2.2
  google_fonts: ^6.1.0
```

## 🎬 Animasyonlar

Uygulama, kullanıcı deneyimini geliştirmek için çeşitli animasyonlar içerir:

- **Page Transition Animasyonları**: Fade, Slide ve Scale geçiş efektleri (`page_transitions.dart`)
- **AnimatedCard**: Kartların fade (opacity) ve slide (transform) animasyonları ile görünmesi (`animated_card.dart`)
- **Tab Transitions**: Tab değişimlerinde `AnimatedBuilder` ve `TabController.animateTo()` ile yumuşak geçişler (`home_screen.dart`)
- **Dialog Animasyonları**: Dialog açılış/kapanışlarında scale ve fade kombinasyonu (`CustomDialogRoute`)
- **Glowing Button Effects**: Add butonlarında glassmorphism ve glow efektleri (`glowing_add_button.dart`)

## 🔄 State Management

Uygulama **Provider** kullanarak state management yapar:
- `ThemeProvider`: Tema durumunu yönetir
- `NoteViewModel`: Not durumunu ve işlemlerini yönetir
- `TaskViewModel`: Görev durumunu ve işlemlerini yönetir

## 🌍 Yerelleştirme

Desteklenen diller:
- İngilizce (en)
- Türkçe (tr)

Yerelleştirme dosyaları `lib/l10n/` dizininde ARB formatında bulunur.

## 📝 Kod Yapısı

### Domain Layer
- **Entities**: `Note`, `Task` - Saf iş nesneleri
- **Repositories**: Veri işlemlerini tanımlayan arayüzler

### Data Layer
- **Database Helper**: SQLite kurulumu ve yönetimi
- **Repository Implementations**: Domain repository'lerinin somut implementasyonları

### Presentation Layer
- **ViewModels**: İş mantığı ve state management
- **Screens**: Özelliklere göre organize edilmiş UI ekranları
- **Widgets**: Yeniden kullanılabilir UI bileşenleri
- **Providers**: Dependency injection kurulumu

## 🎨 Tasarım Felsefesi

Uygulama, modern ve kullanıcı dostu bir deneyim sunmak için aşağıdaki tasarım prensiplerini takip eder:

- **Spatial Design (Mekansal Tasarım)**: Arka planlar derinlik hissi veren dinamik tuval görevi görür. Açık temada animasyonlu güneş koyu temada neon parçacıklar ve parlayan efektler ile kullanıcıya üç boyutlu bir deneyim sunar.

- **Glass Morphism (Cam Morfolojisi)**: Modern donuk cam efektleri (`BackdropFilter` ve blur kullanarak) ile kartlar ve container'lar şeffaf bir görünüm kazanır. Bu efekt, içeriğin arka planla uyumlu bir şekilde görünmesini sağlar.

- **Smooth Animations (Yumuşak Animasyonlar)**: Tüm geçişler ve etkileşimler `Curves.easeOutCubic` gibi yumuşak eğrilerle animasyonlanır. Kartlar fade-in ve slide-up ile görünür, sayfa geçişleri akıcıdır ve kullanıcı etkileşimleri anında geri bildirim verir.

- **Gradient & Glow Effects**: Primary renklerde gradient geçişler ve glow efektleri ile önemli butonlar ve seçili öğeler vurgulanır. Bu, kullanıcının dikkatini önemli aksiyonlara yönlendirir.

- **Responsive Layout**: Hem portrait hem landscape modlarda optimize edilmiş düzenler.

