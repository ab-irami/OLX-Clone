import 'package:ecom_app/forms/seller_car_form.dart';
import 'package:ecom_app/forms/user_review_screen.dart';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/screens/account_screen.dart';
import 'package:ecom_app/screens/authentication/email_auth_screen.dart';
import 'package:ecom_app/screens/authentication/email_verification_screen.dart';
import 'package:ecom_app/screens/authentication/password_reset_screen.dart';
import 'package:ecom_app/screens/authentication/phoneauth_screen.dart';
import 'package:ecom_app/screens/categories/category_list_screen.dart';
import 'package:ecom_app/screens/categories/sub_cat_list_screen.dart';
import 'package:ecom_app/screens/chat_screen.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/location_screen.dart';
import 'package:ecom_app/screens/login_screen.dart';
import 'package:ecom_app/screens/main_screen.dart';
import 'package:ecom_app/screens/my_ad_screen.dart';
import 'package:ecom_app/screens/sell_items/seller_category_list_screen.dart';
import 'package:ecom_app/screens/sell_items/seller_sub_cat_list_screen.dart';
import 'package:ecom_app/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.id,
      theme: ThemeData(
        primaryColor: Colors.cyan.shade900,
        fontFamily: 'Lato',
      ),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        PhoneAuthScreen.id: (context) => const PhoneAuthScreen(),
        LocationScreen.id: (context) => const LocationScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        EmailAuthScreen.id: (context) => const EmailAuthScreen(),
        EmailVerificationScreen.id: (context) => const EmailVerificationScreen(),
        PasswordResetScreen.id: (context) => const PasswordResetScreen(),
        CategoryListScreen.id: (context) => const CategoryListScreen(),
        SubCatListScreen.id: (context) => const SubCatListScreen(),
        MainScreen.id: (context) => const MainScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
        MyAdScreen.id: (context) => const MyAdScreen(),
        AccountScreen.id: (context) => const AccountScreen(),
        SellerCategoryListScreen.id: (context) => const SellerCategoryListScreen(),
        SellerSubCatListScreen.id: (context) => const SellerSubCatListScreen(),
        SellerCarForm.id: (context) => const SellerCarForm(),
        ImagePickerWidget.id :(context) => const ImagePickerWidget(),
        UserReviewScreen.id :(context) => const UserReviewScreen(),
      },
    );
  }
}
