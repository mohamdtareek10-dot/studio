# 🐺 IRON WOLF - Martial Arts Mastery

تطبيق ذكاء اصطناعي متطور لتوليد تمارين الفنون القتالية ومتابعة الأهداف.

## 🚀 كيف تبدأ؟

هذا المشروع مبني باستخدام **Next.js 15** و **Genkit**.

### 1. التشغيل في بيئة التطوير (Development)
لمشاهدة التغييرات مباشرة أثناء العمل:
```bash
npm run dev
```
سيفتح التطبيق على الرابط: `http://localhost:9002`

### 2. تشغيل واجهة Genkit (للذكاء الاصطناعي)
لتجربة وتطوير تدفقات الذكاء الاصطناعي (Flows) بشكل منفصل:
```bash
npm run genkit:dev
```

### 3. بناء نسخة الإنتاج (Production Build)
عندما يكون التطبيق جاهزاً للنشر، يجب تحويل الكود إلى نسخة محسنة وسريعة:
```bash
npm run build
```

## 🌐 النشر على الإنترنت (Deployment)

بما أن المشروع يحتوي على ملف `apphosting.yaml` ومرتبط بـ Firebase، يمكنك نشره ليراه الجميع:

1. **ارفع الكود إلى GitHub:** تأكد من رفع جميع الملفات إلى مستودع (Repository) خاص بك.
2. **اربطه بـ Firebase App Hosting:** من خلال لوحة تحكم Firebase Console، قم بإنشاء "App Hosting Backend" واربطه بمستودع GitHub الخاص بك.
3. **الإعدادات التلقائية:** بمجرد الربط، سيقوم Firebase ببناء التطبيق ونشره تلقائياً عند كل "Push" تقوم به.

## 🛠 التقنيات المستخدمة
- **Next.js 15** (App Router)
- **Firebase** (App Hosting / Firestore)
- **Genkit** (Google Gemini AI)
- **Tailwind CSS** & **ShadCN UI**
- **Lucide Icons**
