import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/models/feedback_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<FeedBackModel> feedbacks = [];

    final adminBloc = sl.get<AdminBloc>();
    return BlocConsumer<AdminBloc, AdminState>(
      bloc: adminBloc,
      listener: (context, state) {
        if (state is FeedbackLoadingFailedState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                      'Unable to fetch feedbacks. Please try again later.'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Ok',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 10),
                        ))
                  ],
                );
              });
        }
      },
      builder: (context, state) {
        if (state is AdminInitial) {
          adminBloc.add(AllFeedbackFetchEvent());
        } else if (state is FeedbackLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FeedbackLoadingSuccessState) {
          feedbacks = state.feedbacks;
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 10,
            child: ListView.builder(
              itemBuilder: (context, index) => ExpansionTile(
                leading: Icon(
                  Icons.square,
                  color:
                      feedbacks[index].rating > 3 ? Colors.green : Colors.red,
                ),
                title: Text(
                    '${feedbacks[index].username} (${feedbacks[index].feedback})'),
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Question : ${feedbacks[index].question}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Answer : ${feedbacks[index].answer}'),
                  )
                ],
              ),
              itemCount: feedbacks.length,
            ),
          ),
        );
      },
    );
  }
}
