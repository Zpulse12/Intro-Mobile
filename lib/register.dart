import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Page',
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name and last name'),
                validator: (value) {
                  if (value!.isEmpty)
                    return 'Please enter your name and last name';
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your email';
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Mobile'),
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
              SizedBox(height: 20),
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
                          // Registration moet nog worden geïmplementeerd
                        }
                      }
                    : null,
                child: Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
