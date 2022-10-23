import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final testLogin = "admin";
  final testPassword = "123456";
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isRemember = false;

  @override
  void initState() {
    super.initState();
    // For use Future function in initState and wait it run once and complete before build
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _loadPreferences();
      if (_isRemember) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    });
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRemember = prefs.getBool('remember') ?? false;
    });
  }

  void _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('remember', _isRemember);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              key: const Key('login'),
              controller: _loginController,
              decoration: const InputDecoration(labelText: 'Login'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              key: const Key('password'),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Checkbox(
                    value: _isRemember,
                    activeColor: Colors.blue,
                    onChanged: (newValue) {
                      setState(() {
                        _isRemember = newValue!;
                      });
                    }),
              ),
              const Expanded(child: Text("Запам'ятати")),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_loginController.text == testLogin &&
                          _passwordController.text == testPassword) {
                        if (_isRemember) {
                          _savePreferences();
                        }
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()));
                      } else {
                        setState(() {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Помилка'),
                              content: const Text(
                                  'Логін або пароль є невірними. Спробуйте ще раз.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        });
                      }
                    },
                    child: const Text('Далі')),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
