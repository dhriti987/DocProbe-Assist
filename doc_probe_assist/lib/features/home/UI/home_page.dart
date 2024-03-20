import 'package:doc_probe_assist/features/home/bloc/home_bloc.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:text_3d/text_3d.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeBloc homeBloc = sl.get<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B74B0),
              Color(0xFF75479C),
              Color(0xFFBD3861),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/bot_chatting.png',
                      fit: BoxFit.contain,
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ThreeDText(
                                text: "Doc Probe\nAssist",
                                textStyle: const TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                    color: Color.fromARGB(231, 255, 255, 255)),
                                style: ThreeDStyle.inset,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Simplifing Documents, Amplifying Answers",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  homeBloc
                                      .add(LoginToContinueButtonClickedEvent());
                                  context.push('/login');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Login to Continue",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
