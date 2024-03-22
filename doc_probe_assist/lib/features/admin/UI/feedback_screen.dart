import 'package:doc_probe_assist/models/feedback_model.dart';
import 'package:flutter/material.dart';

class FeedBackScreen extends StatelessWidget {
  const FeedBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<FeedBackModel> feedbacks = [
      FeedBackModel(
          question:
              "What is the maximum number of tags that Historian can collect and store?",
          answer:
              "The maximum number of tags that Historian can collect and store is 2 million.",
          username: 'Dhruv',
          isGood: true,
          feedback: "Quick responses and accurate information.",
          date: "01-01-2024"),
      FeedBackModel(
          question:
              "What warrant does the Contractor provide for all spares supplied?",
          answer:
              "Structures and hangers shall be designed considering loads due to these additional surfaces also. (Page 135, Section 2.2.3.4)",
          username: 'Dhritiman',
          isGood: true,
          feedback: "Easy to navigate and understand.",
          date: "01-01-2024"),
      FeedBackModel(
          question:
              "What are some of the reporting options available in AVEVA Historian Client?",
          answer:
              "AVEVA Historian Client offers several reporting options, including:\n\n 1. Production events and formula reporting (usage and set points)\n2. Material consumption including comparisons of â€œplan vs. actualâ€\n3. Consumption and genealogy of materials, equipment, personnel, and production events related to a lot, batch, or serial number\n4. Complete traceability and genealogy reporting to help comply with government regulations.",
          username: 'Muskaan',
          isGood: true,
          feedback: "Helpful in finding specific information quickly.",
          date: "02-01-2024"),
      FeedBackModel(
          question:
              "What is the targeted voltage class for efficiency in Cabo Verde's operation?",
          answer:
              "The targeted voltage class for efficiency in Cabo Verde's operation is 20kV.",
          username: 'Dhruv',
          isGood: false,
          feedback: "Limited range of topics covered.",
          date: "03-01-2024"),
      FeedBackModel(
          question:
              "What project connected New Porto Novo PS to Riberia Grande PS?",
          answer:
              "The project that connected New Porto Novo PS to Riberia Grande PS is the ORET Project.",
          username: 'Dhritiman',
          isGood: true,
          feedback: "Consistently reliable in delivering accurate information.",
          date: "03-01-2024"),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 10,
        child: ListView.builder(
          itemBuilder: (context, index) => ExpansionTile(
            leading: Icon(
              Icons.square,
              color: feedbacks[index].isGood ? Colors.green : Colors.red,
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
  }
}
