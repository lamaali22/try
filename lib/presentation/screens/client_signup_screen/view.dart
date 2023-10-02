import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/models/clientModel.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/screens/landing_screen/view.dart';

import '../../../data/models/clientModel.dart';

class ClientSignUpScreen extends StatefulWidget {
  const ClientSignUpScreen({Key? key}) : super(key: key);

  @override
  _ClientSignUpScreenState createState() => _ClientSignUpScreenState();
}

class _ClientSignUpScreenState extends State<ClientSignUpScreen> {
  //controllers
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final dOBController = TextEditingController();
  final phoneNumController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final genderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  //gender
  List<String> itemsList = ['الجنس', 'أنثى', 'ذكر'];
  String selectedItem = 'الجنس';

  //DOB
  @override
  void initState() {
    dOBController.text = ""; //set the initial value of text field
    super.initState();
  }

//Email validation
  bool validateEmail(String email) {
    bool isvalid = EmailValidator.validate(email);
    return isvalid;
  }

//password visibile or not
  bool passwordVisible = false;

//password validation
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;
    });
  }

//is a number validation
  bool isNumericUsingRegularExpression(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  //Authentication
  final _auth = FirebaseAuth.instance;

  Future<void> createUserWithEmailAndPassword(String email, password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      e.code;
    } catch (_) {}
  }

  //Storing data in Firebase
  final _db = FirebaseFirestore.instance;
  createUser(clientModel client) async {
    await _db.collection("Clients").add(client.toJson());
  }

  //signinUser
  Future<void> signInWithEmailAndPassword(String email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      e.code;
    } catch (_) {}
  }

  //check if email is used
  List<String> emails = [];
  Future<void> fetchEmailsAsync() async {
    final QuerySnapshot querySnapshot = await _db.collection('Clients').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final email = data['email'] as String;
        emails.add(email);
      }
    }

    final QuerySnapshot querySnapshot2 = await _db.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents2 = querySnapshot2.docs;

    for (QueryDocumentSnapshot doc in documents2) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('email')) {
        final email = data['email'] as String;
        emails.add(email);
      }
    }
  }

//check if phone is used
  List<String> phones = [];
  Future<void> fetchPhonesAsync() async {
    final QuerySnapshot querySnapshot = await _db.collection('Clients').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot doc in documents) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('phoneNumber')) {
        final phone = data['phoneNumber'] as String;
        phones.add(phone);
      }
    }

    final QuerySnapshot querySnapshot2 = await _db.collection('lawyers').get();
    final List<QueryDocumentSnapshot> documents2 = querySnapshot2.docs;

    for (QueryDocumentSnapshot doc in documents2) {
      final data = doc.data() as Map<String, dynamic>; // Access data as a Map
      if (data.containsKey('phoneNumber')) {
        final phone = data['phoneNumber'] as String;
        phones.add(phone);
      }
    }
  }

  ////////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 128, 128),
              elevation: 0,
              title: const Text("انشاء حساب جديد",
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              centerTitle: true,
              actions: [
                IconButton(
                  padding: EdgeInsets.only(right: 30),
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous page
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                ' * الأسم الاول',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                    255,
                                    78,
                                    76,
                                    76,
                                  ), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: fNameController,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 0.9,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      fNameController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبأة الخانة بشكل صحيح';
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* الأسم الأخير',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: lNameController,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 0.9,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      lNameController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبأة الخانة بشكل صحيح';
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                            child: Column(children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              '* تاريخ الميلاد',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(
                                    255, 78, 76, 76), // Customize label color
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: dOBController,
                            style: TextStyle(
                                fontSize: 13, height: 1.1, color: Colors.black),
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                suffixIcon: Icon(Icons.calendar_month_rounded)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء تعبأة الخانة';
                              } else if (value.length > 50)
                                return ' الرجاء تعبأة الخانة بشكل صحيح';

                              return null;
                            },
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1930),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Colors
                                            .teal, // Change the primary color to teal
                                      ),
                                      textTheme: TextTheme(
                                        headline1: TextStyle(
                                          color: Colors
                                              .teal, // Change the year text color to teal
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  dOBController.text = formattedDate;
                                });
                              }
                            },
                          ),
                        ])),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* رقم الهاتف',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              onTap: () async {
                                print("ontap");
                                await fetchPhonesAsync();
                              },
                              controller: phoneNumController,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.black),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                prefixText: "05",
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      phoneNumController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length != 8)
                                  return '(05x-xxxx-xxx) الرجاء ادخال رقم هاتف صحيح';
                                else if (!isNumericUsingRegularExpression(
                                    value))
                                  return '(الرجاء تعبأة الخانة بأعداد فقط (من 0-9';
                                else {
                                  if (phones.contains(value))
                                    return 'هذا الرقم مستخدم';
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* البريد الإلكتروني',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            TextFormField(
                              onTap: () async {
                                print("ontap");
                                await fetchEmailsAsync();
                              },
                              controller: emailController,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.1,
                                  color: Colors.black),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: "Example@gmail.com",
                                border: OutlineInputBorder(),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                                suffixIcon: Icon(Icons.email),
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.clear), // Clear button icon
                                  onPressed: () {
                                    setState(() {
                                      emailController.clear();
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء تعبأة الخانة';
                                } else if (value.length > 50)
                                  return ' الرجاء تعبأة الخانة بشكل صحيح';
                                else if (!validateEmail(value))
                                  return '( Example@gmail.com )  الرجاء ادخال بريد الكتروني صحيح';
                                else {
                                  if (emails.contains(value))
                                    return 'هذا البريد الإلكتروني مستخدم';
                                }

                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* كلمة المرور',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                  controller: passwordController,
                                  onChanged: (password) =>
                                      onPasswordChanged(password),
                                  obscureText: !passwordVisible,
                                  style: TextStyle(
                                      fontSize: 13,
                                      height: 1.1,
                                      color: Colors.black,
                                      backgroundColor: null),
                                  textAlign: TextAlign.right,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.teal),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                          Icons.clear), // Clear button icon
                                      onPressed: () {
                                        setState(() {
                                          passwordController.clear();
                                        });
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                      icon: passwordVisible
                                          ? Icon(
                                              Icons.visibility,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                            ),
                                    ),
                                    alignLabelWithHint: false,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'الرجاء تعبأة الخانة';
                                    else if (value.length < 8)
                                      return '  الرجاء ادخال 8 خانات و رقم واحد على الأقل';
                                    else if (passwordController.text !=
                                        passwordConfirmController.text)
                                      return "لا يوجد تطابق";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '* تأكيد كلمة المرور',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(
                                      255, 78, 76, 76), // Customize label color
                                ),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                  controller: passwordConfirmController,
                                  obscureText: !passwordVisible,
                                  style: TextStyle(
                                      fontSize: 13,
                                      height: 1.1,
                                      color: Colors.black,
                                      backgroundColor: null),
                                  textAlign: TextAlign.right,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.teal),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                          Icons.clear), // Clear button icon
                                      onPressed: () {
                                        setState(() {
                                          passwordConfirmController.clear();
                                        });
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                      icon: passwordVisible
                                          ? Icon(
                                              Icons.visibility,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                            ),
                                    ),
                                    alignLabelWithHint: false,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'الرجاء تعبأة الخانة';
                                    else if (value.length < 8)
                                      return '  الرجاء ادخال 8 خانات و رقم واحد على الأقل';
                                    else if (passwordController.text !=
                                        passwordConfirmController.text)
                                      return "لا يوجد تطابق";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: _isPasswordEightCharacters
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: _isPasswordEightCharacters
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("تتكون من 8 خانات على الأقل",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromRGBO(
                                              104, 102, 102, 1))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: _hasPasswordOneNumber
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: _hasPasswordOneNumber
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("تحتوي على رقم واحد على الأقل",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromRGBO(
                                              104, 102, 102, 1))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ])),
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            '* الجنس ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(
                                  255, 78, 76, 76), // Customize label color
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment
                              .centerRight, // Align the FractionallySizedBox to the right
                          child: FractionallySizedBox(
                            widthFactor: 1, // Set to 50% of the screen width
                            child: Container(
                              height: 95,
                              padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
                              margin: EdgeInsets.all(2),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                                value: selectedItem,
                                items: itemsList
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Align(
                                          alignment: Alignment
                                              .centerRight, // Right-align the text
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromRGBO(
                                                  123, 121, 121, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (item) => setState(
                                    () => selectedItem = item.toString()),
                                validator: (value) {
                                  if (value == "الجنس")
                                    return 'الرجاء تحديد الجنس';
                                  else
                                    return null;
                                },
                                // Set the maximum dropdown menu height
                                isExpanded:
                                    true, // Expand the dropdown to the maximum width
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF008080),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //authentication
                                createUserWithEmailAndPassword(
                                    emailController.text.trim(),
                                    passwordController.text.trim());

                                //storing in DB
                                final client = clientModel(
                                    firstName: fNameController.text.trim(),
                                    lastName: lNameController.text.trim(),
                                    dateOfBirth: dOBController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    phone: phoneNumController.text.trim(),
                                    gender: selectedItem);

                                await createUser(client);

                                await signInWithEmailAndPassword(
                                    emailController.text.trim(),
                                    passwordController.text.trim());

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ));
                              }
                              //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')),);
                            },
                            child: Text('تسجيل'),
                          ),
                        ),
                      ] //children
                      ) //column
                  ), //form
            ) //container
            ));
  }
}
