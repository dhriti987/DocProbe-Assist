import 'package:doc_probe_assist/models/feedback_model.dart';
import 'package:flutter/material.dart';

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<FeedBackModel> feedbacks = [];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 10,
        child: ListView.builder(
          itemBuilder: (context, index) =>
              ExpansionTile(title: Text(feedbacks[index].username)),
          itemCount: feedbacks.length,
        ),
      ),
    );
  }
}
