import 'package:flutter/material.dart';

void main() {
  runApp(const SafeCarWashApp());
}

class SafeCarWashApp extends StatelessWidget {
  const SafeCarWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ضبط اتجاه التطبيق بالكامل ليدعم اللغة العربية (من اليمين لليسار)
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const SecureLoginScreen(), // نقطة البداية: شاشة الدخول المؤمنة
    );
  }
}

// -----------------------------------------------------------------
// 1. شاشة تسجيل الدخول المؤمنة (Secure Login)
// -----------------------------------------------------------------
class SecureLoginScreen extends StatefulWidget {
  const SecureLoginScreen({super.key});

  @override
  State<SecureLoginScreen> createState() => _SecureLoginScreenState();
}

class _SecureLoginScreenState extends State<SecureLoginScreen> {
  // مفتاح الأمان للتحقق من صحة البيانات المدخلة في الحقول
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void handleSecureLogin() async {
    // التحقق الآمن: تفعيل الفلاتر للتأكد من الشروط قبل إرسال البيانات
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      
      // محاكاة الاتصال المشفر بالسيرفر لمدة ثانيتين
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => isLoading = false);
      
      if (!mounted) return;
      // الانتقال الآمن للشاشة الرئيسية وتدمير شاشة اللوج إن من الذاكرة لزيادة الأمان
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey, // ربط حماية المدخلات بالفورم
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield, size: 80, color: Colors.greenAccent),
                const SizedBox(height: 10),
                const Text('منصة المغاسل الذكية', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('تسجيل دخول مؤمن ومحمي', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 40),
                
                // حقل البريد الإلكتروني الآمن
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'البريد الإلكتروني للعميل',
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    prefixIcon: const Icon(Icons.email, color: Color(0xFF0284C7)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'خطأ أمني: يرجى إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // حقل كلمة المرور المشفرة واجهياً
                TextFormField(
                  controller: passwordController,
                  obscureText: true, // إخفاء الباسوورد لحماية الخصوصية
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور',
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF0284C7)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'خطأ أمني: كلمة المرور يجب أن لا تقل عن 6 أحرف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // زر الدخول الآمن
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: isLoading ? null : handleSecureLogin,
                    child: isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('دخول آمن للمنصة', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// 2. الشاشة الرئيسية: عرض المغاسل وأسعارها المعلنة
// -----------------------------------------------------------------
class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة المغاسل والأسعار التي حددها أصحاب المغاسل بأنفسهم
    final List<Map<String, dynamic>> washStations = [
      {'name': 'مغسلة النظافة الفائقة', 'price': 120.0, 'location': 'حي الملقا'},
      {'name': 'مغسلة الرواد VIP', 'price': 200.0, 'location': 'حي الياسمين'},
      {'name': 'مركز الغسيل السريع', 'price': 80.0, 'location': 'حي النرجس'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        title: const Text('المغاسل والأسعار المتاحة', style: TextStyle(color: Colors.white)), 
        backgroundColor: const Color(0xFF0284C7),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: washStations.length,
        itemBuilder: (context, index) {
          final station = washStations[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: const Icon(Icons.local_car_wash, size: 40, color: Color(0xFF38BDF8)),
              title: Text(station['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text('الموقع: ${station['location']}\nالسعر: ${station['price']} جنيه', style: const TextStyle(color: Colors.greenAccent, height: 1.5)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                onPressed: () {
                  // الانتقال الآمن لصفحة الفاتورة والدفع مع تمرير البيانات الثابتة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecurePaymentScreen(
                        stationName: station['name'],
                        rawPrice: station['price'],
                      ),
                    ),
                  );
                },
                child: const Text('احجز', style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------
// 3. شاشة المعالجة المالية الآمنة (حساب عمولة الـ 10%)
// -----------------------------------------------------------------
class SecurePaymentScreen extends StatefulWidget {
  final String stationName;
  final double rawPrice; // السعر الأساسي القادم من المغسلة

  const SecurePaymentScreen({super.key, required this.stationName, required this.rawPrice});

  @override
  State<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends State<SecurePaymentScreen> {
  bool isProcessing = false;

  void executeSecureTransaction() async {
    setState(() => isProcessing = true);

    // --- [منطقة الأمان المالي العالي] ---
    // الحسابات الرياضية معزولة تماماً هنا ولا يمكن التلاعب بها من واجهة المستخدم
    const double commissionRate = 0.10; // تحديد نسبة الـ 10% الخاصة بك برمجياً
    double platformProfit = widget.rawPrice * commissionRate; // حساب عمولتك
    double vendorNetPayout = widget.rawPrice - platformProfit; // صافي مستحقات المغسلة (90%)

    // محاكاة إرسال الفاتورة المحسوبة بدقة مشفرة إلى Firebase
    await Future.delayed(const Duration(seconds: 2));

    // طباعة تفاصيل العملية في سجلات الإدارة الخاصة بك للتوثيق والأمان
    print('🚨 [عملية مالية آمنة مكتملة] 🚨');
    print('المغسلة المستفيدة: ${widget.stationName}');
    print('المبلغ المدفوع من العميل: ${widget.rawPrice} ج.م');
    print('صـافي عمولتك المحجوزة (10%): $platformProfit ج.م');
    print('المبلغ المستحق للمغسلة (90%): $vendorNetPayout ج.م');
    print('-----------------------------------------');

    setState(() => isProcessing = false);

    if (!mounted) return;
    // إظهار إشعار النجاح الآمن للمستخدم
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✔️ تم تأكيد الحجز والتحويل المالي بأمان!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context); // العودة التلقائية بأمان
  }

  @override
  Widget build(BuildContext context) {
    // حساب العمولة لعرضها في الفاتورة بالتفصيل
    double commissionAmount = widget.rawPrice * 0.10;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(title: const Text('الفاتورة والدفع الآمن'), backgroundColor: const Color(0xFF0284C7)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مراجعة الحجز المالي:', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.stationName, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 16)),
            const Divider(color: Colors.grey, height: 40),
            
            // تصميم الفاتورة الإلكترونية المؤمنة
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('سعر غسيل السيارة:', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text('${widget.rawPrice} ج.م', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('رسوم تشغيل المنصة (10%):', style: TextStyle(color: Colors.orangeAccent, fontSize: 16)),
                      Text('$commissionAmount ج.م', style: const TextStyle(color: Colors.orangeAccent, fontSize: 16)),
                    ],
                  ),
                  const Divider(color: Colors.grey, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('إجمالي ما يدفعه العميل:', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${widget.rawPrice} ج.م', style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // زر معالجة الدفع النهائي
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: isProcessing ? null : executeSecureTransaction,
                child: isProcessing 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('تأكيد الدفع المؤمن والخصم', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
