import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:doc_probe_assist/features/login/bloc/login_bloc.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController empIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bloc = sl.get<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/doc_probe_logo.png',
              fit: BoxFit.contain,
              height: 56,
            ),
          ],
        ),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is LoginSuccessfull) {
            context.go('/chat');
          } else if (state is LoginFailed) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(state.title),
                content: Text(state.message),
              ),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff0b74b0),
                Color(0xff75479c),
                Color(0xffbd3861),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TyperAnimatedText(
                                  'Simplifying Docs, Amplifying Answers ',
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TyperAnimatedText(
                                  'Whizzing through documents for you.',
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                              isRepeatingAnimation: true,
                              totalRepeatCount: 10,
                              pause: const Duration(milliseconds: 1000),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login Form',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextField(
                          controller: empIdController,
                          decoration: const InputDecoration(
                            labelText: 'Employee ID',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // context.push("/chat");
                                bloc.add(LoginButtonClickedEvent(
                                    empId: empIdController.text,
                                    password: passwordController.text));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 30.0,
                                ),
                              ),
                              child: const Text('Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Adani')),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.purple, // Change to purple
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                alignment: Alignment.bottomCenter,
                                child: TextButton(
                                  onPressed: () {
                                    context.go('/register');
                                  },
                                  child: const Text(
                                    "Don't have an account? Register",
                                    style: TextStyle(
                                      color: Colors.purple, // Change to purple
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
