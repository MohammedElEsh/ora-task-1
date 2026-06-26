# 📱 Ticket Scanner — نظام مسح التذاكر

تطبيق Flutter لمسح الباركود والتحقق من صحة التذاكر الإلكترونية للفعاليات.

---

## 🏗️ بنية المشروع (Scanner Feature فقط)

```
lib/features/scanner/
├── data/
│   ├── datasources/
│   │   └── barcode_database.dart      # قاعدة بيانات SQLite محلية
│   ├── models/
│   │   └── barcode_model.dart         # موديل الباركود (Equatable)
│   └── repositories/
│       ├── barcode_repository.dart     # واجهة المستودع (Abstract)
│       └── barcode_repository_impl.dart # تنفيذ المستودع
└── presentation/
    ├── manager/
    │   ├── scanner_cubit.dart         # منطق الأعمال (Cubit)
    │   └── scanner_state.dart         # حالات المسح (Sealed States)
    ├── views/
    │   ├── scanner_view.dart          # شاشة المسح الرئيسية
    │   └── test_qr_view.dart          # شاشة عرض QR للاختبار
    └── widgets/
        └── scan_result_overlay.dart   # طبقة النتيجة المتحركة
```

---

## ⚙️ التقنيات المستخدمة

| المكتبة | الاستخدام |
|---------|-----------|
| `mobile_scanner: ^7.2.0` | مسح الباركود والـ QR عبر الكاميرا |
| `sqflite: 2.4.3` | قاعدة بيانات محلية (SQLite) |
| `path: 1.9.1` | تحديد مسار قاعدة البيانات |
| `qr_flutter: ^4.1.0` | عرض أكواد QR للاختبار |
| `flutter_bloc` | إدارة الحالة (Cubit) |
| `get_it` | حقن التبعيات (DI) |
| `equatable` | مقارنة الكائنات |
| `flutter_screenutil` | التصميم المتجاوب |

---

## 🗄️ قاعدة البيانات (SQLite)

**اسم الملف:** `barcodes.db`

**جدول `barcodes`:**
| العمود | النوع | الشرح |
|--------|------|-------|
| `id` | INTEGER (PK, AUTOINCREMENT) | المعرف الفريد |
| `code` | TEXT (UNIQUE, NOT NULL) | كود التذكرة |
| `event_name` | TEXT (NOT NULL) | اسم الفعالية |
| `is_used` | INTEGER (DEFAULT 0) | هل تم الاستخدام؟ |
| `used_at` | INTEGER ( nullable) | وقت الاستخدام (milliseconds) |
| `created_at` | INTEGER (NOT NULL) | وقت الإنشاء (milliseconds) |

---

## 🧠 حالات المسح (Scanner States)

| الحالة | الشرح |
|--------|-------|
| `ScannerInitial` | وضع الانتظار، لا يوجد مسح نشط |
| `ScannerLoading` | جارٍ التحقق من التذكرة |
| `ScanAccepted` | ✅ تذكرة صالحة — تم قبولها |
| `ScanAlreadyUsed` | ❌ تذكرة مستخدمة مسبقاً |
| `ScanNotFound` | ❌ التذكرة غير موجودة في قاعدة البيانات |
| `ScanError` | ⚠️ حدث خطأ أثناء المعالجة |

---

## 🔄 تدفق المسح (Scan Flow)

1. المستخدم يضغط **"Start Scanner"** → تفعيل الكاميرا
2. الكاميرا تكتشف باركود → `HapticFeedback` + إرسال الكود إلى `ScannerCubit`
3. `ScannerCubit`:
   - إرسال `ScannerLoading`
   - البحث في قاعدة البيانات عبر `BarcodeRepository`
   - إذا غير موجود ← `ScanNotFound`
   - إذا موجود ومستخدم مسبقاً ← `ScanAlreadyUsed`
   - إذا موجود وغير مستخدم ← تحديث الحالة إلى `isUsed = true` وإرسال `ScanAccepted`
4. النتيجة تظهر عبر `ScanResultOverlay` (مدة 3 ثوانٍ ثم تختفي تلقائياً)
5. **Debounce:** لا يمكن مسح تذكرة أخرى إلا بعد 2 ثانية

---

## 📦 واجهة المستودع (Repository Contract)

```dart
abstract class BarcodeRepository {
  Future<BarcodeModel?> findByCode(String code);
  Future<void> markAsUsed(int id);
  Future<void> insertBarcode(BarcodeModel barcode);
  Future<List<BarcodeModel>> getAllBarcodes();
  Future<void> seedDemoData();
}
```

---

## 🧪 بيانات الاختبار (Demo Data)

### الـ 8 تذاكر المبدئية (تُزرع تلقائياً عند أول تشغيل):

| الكود | الفعالية | الحالة |
|-------|----------|--------|
| TKT-001 | Music Festival 2025 | ✅ متاح |
| TKT-002 | Music Festival 2025 | ✅ متاح |
| TKT-003 | Music Festival 2025 | ❌ مستخدم |
| TKT-004 | Music Festival 2025 | ✅ متاح |
| TKT-005 | Tech Conference | ✅ متاح |
| TKT-006 | Tech Conference | ❌ مستخدم |
| TKT-007 | Tech Conference | ✅ متاح |
| TKT-008 | Art Exhibition | ✅ متاح |

### شاشة Test QR Codes:

عبر النقر على أيقونة QR في شريط الأدوات → تظهر قائمة بجميع الباركودات مع QR code وstatus badge:
- 🟢 **Available** — أخضر
- 🟡 **Used** — برتقالي/أصفر
- 🔴 **Not Found** — أحمر (TKT-999)

---

## 🎨 المظهر (Theme)

يستخدم النظام الأساسي للألوان والخطوط:
- **`AppColors`**: `primary`, `success`, `error`, `warning`, `background`, `surface`, `textPrimary`, `textSecondary`...
- **`AppTypography`**: `bold28`, `semiBold18`, `semiBold14`, `semiBold12`, `regular14`, `regular12`
- **`ScreenUtil`**: `.r`, `.w`, `.h` للتصميم المتجاوب

---

## 🧩 حقن التبعيات (Dependency Injection)

```dart
sl.registerSingleton<BarcodeDatabase>(BarcodeDatabase());
sl.registerSingleton<BarcodeRepository>(BarcodeRepositoryImpl(sl<BarcodeDatabase>()));
sl.registerFactory<ScannerCubit>(() => ScannerCubit(sl<BarcodeRepository>()));
```

- `BarcodeDatabase` ← Singleton
- `BarcodeRepository` ← Singleton (Impl)
- `ScannerCubit` ← Factory

---

## 🧭 التنقل (Navigation)

- لا يوجد GoRouter/SessionManager
- `ScannerView` هي الشاشة الرئيسية (`home`) في `MaterialApp`
- الانتقال إلى `TestQrView` عبر `Navigator.push`
- العودة عبر `Navigator.pop`

---

## 📍 ملاحظات مهمة

- جميع النصوص مكتوبة باللغة الإنجليزية (لا يوجد localization)
- جميع الأيقونات من Material Design (لا يوجد assets مخصصة)
- لا يستخدم `Either<Failure, T>` pattern — يستخدم try/catch مباشر
- لا يستخدم `safeCall` أو `FeedbackHandler`
- ميزة Scanner معزولة تماماً عن أي ميزة أخرى (todo, إلخ)
