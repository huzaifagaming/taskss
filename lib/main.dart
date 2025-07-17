import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:tasks/admin/verified_screen.dart';
import 'package:tasks/home_page.dart';
import 'admin/auth_controller.dart';
 import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController()); // Inject controller
    return GetMaterialApp(
      home: HomePage(),
    );
  }
}


//import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:tasks/admin/Admin_SignUp_Pages.dart';
//import 'package:tasks/admin_sign_up_page.dart';
// import 'package:tasks/screens/user_login_page.dart';
// import 'home_page.dart'; // Your homepage
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   static int loginCount = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Admin Auth',
//       debugShowCheckedModeBanner: false,
//       home: AdminSignupPage(),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'home_page.dart';
// import 'login_page.dart';
// import 'class_detail_page.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   static int loginCount = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Class App',
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => HomePage(),
//         '/login': (context) => LoginPage(),
//         '/classDetail': (context) => ClassDetailPage(className: '',),
//       },
//     );
//   }
// }


// // ignore_for_file: use_build_context_synchronously
//
// import 'package:flutter/material.dart';
// import 'package:paymob_pakistan/paymob_payment.dart';
//
// void main() {
//   // Testing info do not use in your app
//   PaymobPakistan.instance.initialize(
//     apiKey: "{YOUR API KEY HERE}",
//     integrationID: 123456,
//     iFrameID: 123456,
//     jazzcashIntegrationId: 123456,
//     easypaisaIntegrationID: 123456,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         appBarTheme: const AppBarTheme(
//           color: Color(0xFF007aec),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(const Color(0xFF007aec)),
//             )),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const PaymentView(),
//     );
//   }
// }
//
// class PaymentView extends StatefulWidget {
//   const PaymentView({super.key});
//
//   @override
//   State<PaymentView> createState() => _PaymentViewState();
// }
//
// class _PaymentViewState extends State<PaymentView> {
//   PaymobResponse? response;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Paymob'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Image.network('https://paymob.pk/images/paymobLogo.png'),
//             const SizedBox(height: 24),
//             if (response != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text("Success ==> ${response?.success}"),
//                   const SizedBox(height: 8),
//                   Text("Transaction ID ==> ${response?.transactionID}"),
//                   const SizedBox(height: 8),
//                   Text("Message ==> ${response?.message}"),
//                   const SizedBox(height: 8),
//                   Text("Response Code ==> ${response?.responseCode}"),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             Column(
//               children: [
//                 // ElevatedButton(
//                 //   child: const Text('Pay with Jazzcash'),
//                 //   onPressed: () => PaymobPakistan.instance.pay(
//                 //     context: context,
//                 //     currency: "PKR",
//                 //     amountInCents: "100",
//                 //     paymentType: PaymentType.jazzcash,
//                 //     onPayment: (response) => setState(() => this.response = response),
//                 //   ),
//                 // ),
//                 ElevatedButton(
//                     child: const Text('Pay with Jazzcash'),
//                     onPressed: () async {
//                       try {
//                         PaymentInitializationResult response = await PaymobPakistan.instance.initializePayment(
//                           currency: "PKR",
//                           amountInCents: "100",
//                         );
//
//                         String authToken = response.authToken;
//                         int orderID = response.orderID;
//
//                         PaymobPakistan.instance.makePayment(context,
//                             currency: "PKR",
//                             amountInCents: "100",
//                             paymentType: PaymentType.jazzcash,
//                             authToken: authToken,
//                             orderID: orderID,
//                             onPayment: (response) => setState(() => this.response = response));
//                       } catch (err) {
//                         rethrow;
//                       }
//                     }),
//                 // ElevatedButton(
//                 //   child: const Text('Pay with Easypaisa'),
//                 //   onPressed: () => PaymobPakistan.instance.pay(
//                 //     context: context,
//                 //     currency: "PKR",
//                 //     amountInCents: "100",
//                 //     billingData: PaymobBillingData(
//                 //         email: "test@test.com",
//                 //         firstName: "Arshman",
//                 //         lastName: "Afzal",
//                 //         phoneNumber: "+921234567890",
//                 //         apartment: "NA",
//                 //         building: "NA",
//                 //         city: "NA",
//                 //         country: "Pakistan",
//                 //         floor: "NA",
//                 //         postalCode: "NA",
//                 //         shippingMethod: "Online",
//                 //         state: "NA",
//                 //         street: "NA"),
//                 //     paymentType: PaymentType.easypaisa,
//                 //     onPayment: (response) =>
//                 //         setState(() => this.response = response),
//                 //   ),
//                 // ),
//                 // ElevatedButton(
//                 //   child: const Text('Pay with Card'),
//                 //   onPressed: () => PaymobPakistan.instance.pay(
//                 //     context: context,
//                 //     currency: "PKR",
//                 //     amountInCents: "100",
//                 //     paymentType: PaymentType.card,
//                 //     onPayment: (response) =>
//                 //         setState(() => this.response = response),
//                 //   ),
//                 // ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//


// import 'package:flutter/material.dart';
// import 'package:tasks/screens/teacher/teacher_dashboard.dart';
// import 'package:tasks/student/mark_present_screen.dart';
// import 'admin/attendence_sheet_screen.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // Change this to "admin", "teacher", or "student"
//   final String userRole = 'teacher'; // TEMPORARY for testing
//
//   @override
//   Widget build(BuildContext context) {
//     Widget homeScreen;
//
//     if (userRole == 'admin') {
//       homeScreen = AttendanceSheetScreen();
//     } else if (userRole == 'teacher') {
//       homeScreen = TeacherDashboard();
//     } else if (userRole == 'student') {
//       homeScreen = MarkPresentScreen(
//         studentId: '123',
//         studentName: 'John Doe',
//       );
//     } else {
//       homeScreen = Scaffold(body: Center(child: Text("Invalid role")));
//     }
//
//     return MaterialApp(
//       title: 'LMS System',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: homeScreen,
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:tasks/youtube_channel_video.dart';
//
// import 'group_calling_screen.dart';
//
// void main() async {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Zego Video Calling',
//       home:  YouTubeChannelVideos(),
//     );
//   }
// }
//
//
//
