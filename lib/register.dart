import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Register Page',
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _passwordError = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordError);
  }

  void _updatePasswordError() {
    String newError = '';
    if (_passwordController.text.isEmpty) {
      newError = 'Please enter your password.';
    } else {
      if (_passwordController.text.length < 8) {
        newError += 'Password needs at least 8 characters.\n';
      }
      if (!RegExp(r'[A-Z]').hasMatch(_passwordController.text)) {
        newError += 'Password needs a capital letter.\n';
      }
      if (!RegExp(r'[0-9]').hasMatch(_passwordController.text)) {
        newError += 'Password needs 1 number.\n';
      }
    }

    if (newError != _passwordError) {
      setState(() {
        _passwordError = newError.trim();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get isFormFilled =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  bool get isPasswordValid => _passwordError.isEmpty;

  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase Authentication instance

  Future<void> _register() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user!
          .updateProfile(displayName: _nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Registration successful! Welcome, ${userCredential.user!.displayName}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to register: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) =>
                              WelcomePage()), // Navigate back to WelcomePage
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Name and last name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name and last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your email';
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Mobile'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your phone number';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _passwordError.isEmpty ? null : _passwordError,
                  errorMaxLines: 3,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (!isFormFilled || !isPasswordValid) {
                        return Colors.grey;
                      }
                      return Colors.blue;
                    },
                  ),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: (isFormFilled && isPasswordValid)
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _register();
                        }
                      }
                    : null,
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
