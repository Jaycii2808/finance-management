import 'package:finance_management/data/model/user_model.dart';
import 'package:finance_management/presentation/screens/login/login_screen.dart';
import 'package:finance_management/presentation/widgets/widget/app_colors.dart';
import 'package:finance_management/presentation/widgets/widget/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signUp-screen";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late Box<UserModel> _userBox;

  @override
  void initState() {
    super.initState();
    _openBoxAndTest();
  }

  //just test and OK, 2005 will build again
  Future<void> _openBoxAndTest() async {
    _userBox = await Hive.openBox<UserModel>('users');

    _fullNameController.text = 'Test User';
    _emailController.text = 'test@example.com';
    _mobileController.text = '1234567890';
    _dobController.text = '01/01/2000';
    _passwordController.text = 'password';
    _confirmPasswordController.text = 'password';

    final user = UserModel(
      id: 12345678,
      fullName: _fullNameController.text,
      email: _emailController.text,
      mobile: _mobileController.text,
      dob: _dobController.text,
      password: _passwordController.text,
    );

    await _userBox.put(user.id, user);
    //show dialog ok  with infomation
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.caribbeanGreen,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Test Data, Ok rồi đó',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.caribbeanGreen,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Full Name: ${user.fullName}\nEmail: ${user.email}\nMobile: ${user.mobile}\nDoB: ${user.dob}\nPassword: ${user.password}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.blackHeader,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.caribbeanGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    final retrievedUser = _userBox.get(user.id);
    if (retrievedUser != null) {
      debugPrint('--- Test Data ---');
      debugPrint('Full Name: ${retrievedUser.fullName}');
      debugPrint('Email: ${retrievedUser.email}');
      debugPrint('Mobile: ${retrievedUser.mobile}');
      debugPrint('DoB: ${retrievedUser.dob}');
      debugPrint('Password: ${retrievedUser.password}');
    } else {
      debugPrint('User not found in Hive');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }

      // final userId = DateTime.now().millisecondsSinceEpoch;
      final userId = _userBox.length + 1;
      final user = UserModel(
        id: userId,
        fullName: _fullNameController.text,
        email: _emailController.text,
        mobile: _mobileController.text,
        dob: _dobController.text,
        password: _passwordController.text,
      );

      await _userBox.put(userId, user);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.caribbeanGreen,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sign Up Successful!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.caribbeanGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your account has been created. You can now log in and start using the app!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.blackHeader,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.caribbeanGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.go(LoginScreen.routeName);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.caribbeanGreen,
      body: SingleChildScrollView(
        child: Column(children: [buildHeader(), buildBody()]),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.honeydew,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),

      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 27, left: 55),
              child: const Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.titleHeaderRegister,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 37,
                right: 36,
                top: 9,
                bottom: 16,
              ),
              child: TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'example@example.com',
                  filled: true,
                  hintStyle: TextStyle(
                    color: AppColors.cyprus.withValues(
                      alpha: (0.45 * 255).round().toDouble(),
                    ),
                  ),
                  fillColor: AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(35, 8, 29, 9),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 55),
              child: const Text(
                'Email',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.titleHeaderRegister,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 37,
                right: 36,
                top: 9,
                bottom: 16,
              ),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null; // No error
                },

                decoration: InputDecoration(
                  hintText: 'example@example.com',
                  filled: true,
                  hintStyle: TextStyle(
                    color: AppColors.cyprus.withValues(
                      alpha: (0.45 * 255).round().toDouble(),
                    ),
                  ),
                  fillColor: AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(35, 8, 29, 9),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 55),
              child: const Text(
                'Mobile Number',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.titleHeaderRegister,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 37,
                right: 36,
                top: 9,
                bottom: 16,
              ),
              child: TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                  hintText: '+ 123 456 789',
                  filled: true,
                  hintStyle: TextStyle(
                    color: AppColors.cyprus.withValues(
                      alpha: (0.45 * 255).round().toDouble(),
                    ),
                  ),
                  fillColor: AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(35, 8, 29, 9),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 55),
              child: const Text(
                'Date Of Birth',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.titleHeaderRegister,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 37,
                right: 36,
                top: 9,
                bottom: 16,
              ),
              child: TextFormField(
                controller: _dobController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'DD / MM / YYY',
                  filled: true,
                  hintStyle: TextStyle(
                    color: AppColors.cyprus.withValues(
                      alpha: (0.45 * 255).round().toDouble(),
                    ),
                  ),
                  fillColor: AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(35, 8, 29, 9),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 55),
              child: const Text(
                'Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.titleHeaderRegister,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 37,
                right: 36,
                top: 9,
                bottom: 16,
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: '• • • • • • • •',
                  filled: true,
                  hintStyle: TextStyle(
                    color: AppColors.cyprus.withValues(
                      alpha: (0.45 * 255).round().toDouble(),
                    ),
                  ),
                  fillColor: AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(35, 8, 29, 9),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white.withValues(
                        alpha: (0.08 * 255).round().toDouble(),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 55),
              child: const Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.titleHeaderRegister,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 37,
                right: 36,
                top: 9,
                bottom: 16,
              ),
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: '• • • • • • • •',
                  filled: true,
                  hintStyle: TextStyle(
                    color: AppColors.cyprus.withValues(
                      alpha: (0.45 * 255).round().toDouble(),
                    ),
                  ),
                  fillColor: AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(35, 8, 29, 9),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white.withValues(
                        alpha: (0.08 * 255).round().toDouble(),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 19, bottom: 13),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14, color: AppColors.termColor),
                    children: [
                      TextSpan(
                        text: 'By continuing, you agree to\n',
                        style: TextStyle(fontWeight: AppFontWeight.regular),
                      ),
                      TextSpan(
                        text: 'Terms of Use',
                        style: TextStyle(fontWeight: AppFontWeight.semiBold),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(fontWeight: AppFontWeight.regular),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(fontWeight: AppFontWeight.semiBold),
                      ),
                      TextSpan(
                        text: '.',
                        style: TextStyle(fontWeight: AppFontWeight.regular),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: _submitForm,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.caribbeanGreen,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 66,
                          right: 66,
                          top: 11,
                          bottom: 12,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackHeader,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              alignment: Alignment.center,

              padding: const EdgeInsets.only(top: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.cyprus),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(LoginScreen.routeName);
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: AppColors.vividBlue,
                        fontWeight: AppFontWeight.light,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 68, 0, 65),
      decoration: const BoxDecoration(color: AppColors.caribbeanGreen),
      child: const Center(
        child: Text(
          'Create Account',
          style: TextStyle(
            fontSize: 30,
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.blackHeader,
          ),
        ),
      ),
    );
  }
}
