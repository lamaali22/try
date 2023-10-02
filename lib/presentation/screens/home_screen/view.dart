import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/main.dart';
import 'package:qanuni/presentation/screens/reset_password_screen/view.dart';
import 'package:qanuni/utils/colors.dart';
import 'package:qanuni/viewListOfLawyers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
//navigation bar method
void _navigateToScreen(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogoutPage()),
        (route) => false,
      );
      break;
    case 1:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogoutPage()),
        (route) => false,
      );
      break;
    case 2:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogoutPage()),
        (route) => false,
      );
      break;
    case 3:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
      break;
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0x7F008080),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (index) => _navigateToScreen(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'الصفحةالرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'الرسائل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'استشاراتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'حسابي',
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'الصفحة الرئيسية',
            //   style: TextStyle(color: Colors.black, fontSize: 20),
            // ),
            10.verticalSpace,
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList(),
                      ));
                  ;
                },
                child: const Text(
                  'جميع المحامين >',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.primaryColor),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogoutPage(),
                      ));
                },
                child: Text('تسجيل الخروج'))
          ],
        ),
      ),
    );
  }
}
