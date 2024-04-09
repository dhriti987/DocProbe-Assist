import 'package:doc_probe_assist/features/register/bloc/register_bloc.dart';
import 'package:doc_probe_assist/features/register/repository/register_repository.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameTextEditingController = TextEditingController();
    TextEditingController empIdTextEditingController = TextEditingController();
    TextEditingController emailTextEditingController = TextEditingController();
    TextEditingController passwordTextEditingController =
        TextEditingController();
    TextEditingController confirmPasswordTextEditingController =
        TextEditingController();

    final registerBloc = sl.get<RegisterBloc>();

    return BlocConsumer<RegisterBloc, RegisterState>(
      bloc: registerBloc,
      buildWhen: (previous, current) => current is! RegisterState,
      listenWhen: (previous, current) => current is RegisterActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is RegisterLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RegisterLoadingSuccessState) {
          context.go('/login');
        } else if (state is RegisterLoadingFailedState) {
          return AlertDialog(
            content: Text('Something went wrong. Please Try again later.'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text('Ok'))
            ],
          );
        }
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
          body: Container(
            decoration: BoxDecoration(
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
                    padding: EdgeInsets.all(20.0),
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
                                    'Simplifying Docs, Amplifying Answers! ',
                                    textStyle: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TyperAnimatedText(
                                    'Whizzing through documents for you...',
                                    textStyle: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                                isRepeatingAnimation: true,
                                totalRepeatCount: 10,
                                pause: Duration(milliseconds: 1000),
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
                      padding: EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register Form',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: nameTextEditingController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: empIdTextEditingController,
                              decoration: InputDecoration(
                                labelText: 'Employee ID',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: emailTextEditingController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: passwordTextEditingController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: confirmPasswordTextEditingController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (passwordTextEditingController.text ==
                                        confirmPasswordTextEditingController
                                            .text) {
                                      registerBloc.add(
                                          RegisterButtonClickedEvent(
                                              name: nameTextEditingController
                                                  .text,
                                              empID: empIdTextEditingController
                                                  .text,
                                              email: emailTextEditingController
                                                  .text,
                                              password:
                                                  passwordTextEditingController
                                                      .text));
                                    } else {
                                      print('pass and confirm not same.');
                                    }
                                    // sl.get<RegisterRepository>().register(
                                    //     "abd", "cdd", "ab@mail.com", "mnbv9876");
                                  },
                                  child: Text('Register Request'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 30.0,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.go('/login');
                                  },
                                  child: Text(
                                    "Already have an account? Sign in",
                                    style: TextStyle(
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}