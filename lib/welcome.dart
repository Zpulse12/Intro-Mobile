import 'package:flutter/material.dart';
import 'login.screen.dart'; 
import 'register.dart'; 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/welcome-background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset(
                'assets/logo_transparent_text.jpg',
                width: 350.0,
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  'Join the biggest racket sports players community',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'And find your perfect match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Register'),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Log in'),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'By registering you are accepting our ',
                  style: TextStyle(color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'terms of use',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 2.0,
                        decorationColor: Colors.white,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'privacy policy',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 2.0,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
