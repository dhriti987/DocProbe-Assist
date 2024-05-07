import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff0b74b0),
                        Color(0xff75479c),
                        Color(0xffbd3861),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: -10.0),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(
                      text: 'About Us',
                    ),
                    Tab(
                      text: 'Features & Limitations',
                    ),
                    Tab(
                      text: 'FAQs',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              AboutUsSection(),
              SingleChildScrollView(child: FeaturesAndLimitationsSection()),
              SingleChildScrollView(child: HowItWorksSection()),
            ],
          ),
          bottomNavigationBar: const BottomAppBar(
            child: SizedBox(
              height: 50.0,
              child: Center(
                child: Text(
                  'Version 1.1',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AboutUsSection extends StatefulWidget {
  const AboutUsSection({super.key});

  @override
  State<AboutUsSection> createState() => _AboutUsSectionState();
}

class _AboutUsSectionState extends State<AboutUsSection> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/ad.mp4')
      ..initialize().then((value) {
        _controller.play();

        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double imageWidth = constraints.maxWidth * 0.4;
            double imageHeight = imageWidth;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Doc Probe Assist is your trusted partner in simplifying the way you interact with documents. Our platform is designed to empower individuals and businesses alike by providing an intuitive and efficient solution for accessing and utilizing information from documents.\n\nWe understand the challenges of dealing with complex documents, which is why we\'ve developed innovative approaches to document exploration. Our focus on user-friendly interfaces ensures that navigating through documents is both seamless and rewarding.\n\nAt Doc Probe Assist, we prioritize the security and confidentiality of your information. Our platform is built with robust security measures to ensure that your data is protected at all times.\n\nJoin us as we revolutionize document exploration, making it easier and more efficient than ever before. Experience the future of document interaction with Doc Probe Assist!',
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20.0),

                Container(
                    color: Colors.black,
                    height: 340,
                    width: 700,
                    child: VideoPlayer(_controller)),

                // SizedBox(
                //   width: imageWidth,
                //   height: imageHeight,
                //   child: Image.network(
                //     'https://www.shutterstock.com/image-vector/3d-artificial-intelligence-digital-brain-600nw-2288372371.jpg',
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FeaturesAndLimitationsSection extends StatelessWidget {
  const FeaturesAndLimitationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Features',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                ..._buildFeatureItems(),
              ],
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Limitations',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                ..._buildLimitationItems(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureItems() {
    return [
      const FeatureItem(
        icon: Icons.explore,
        title: 'Efficient Document Exploration',
        description:
            'Doc Probe Assist offers a user-friendly interface for navigating through documents, making it easy to access and utilize information.',
      ),
      const FeatureItem(
        icon: Icons.check_circle,
        title: 'Accurate Answer Retrieval',
        description:
            'Our platform uses advanced text generation and embedding models to provide precise answers from multiple documents.',
      ),
      const FeatureItem(
        icon: Icons.storage,
        title: 'Document Storage',
        description:
            'Store and access your documents securely on our platform for easy retrieval and management.',
      ),
      const FeatureItem(
        icon: Icons.help,
        title: 'User Support',
        description:
            'Our dedicated support team is available to assist you with any questions or issues you may encounter.',
      ),
      const FeatureItem(
        icon: Icons.security,
        title: 'Enhanced Security Measures',
        description:
            'Our platform employs state-of-the-art security measures to protect your documents and data from unauthorized access.',
      ),
    ];
  }

  List<Widget> _buildLimitationItems() {
    return [
      const FeatureItem(
        icon: Icons.folder_open,
        title: 'Document Compatibility',
        description:
            'Doc Probe Assist may have limitations in accessing and processing certain document formats.',
      ),
      const FeatureItem(
        icon: Icons.query_builder,
        title: 'Complex Queries',
        description:
            'While our platform strives to provide accurate answers, complex queries may not always yield the desired results.',
      ),
      const FeatureItem(
        icon: Icons.language,
        title: 'Language Restriction',
        description:
            'The platform\'s model only understands English and provides English input and output.',
      ),
      const FeatureItem(
        icon: Icons.error,
        title: 'Occasional Errors',
        description:
            'Due to the complexity of document analysis, there may be instances where the platform provides incorrect or incomplete information.',
      ),
      const FeatureItem(
        icon: Icons.table_chart,
        title: 'Table Data Extraction',
        description:
            'Doc Probe Assist can only extract data from tables if they are in the proper format.',
      ),
    ];
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 32.0, color: Colors.blue),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'FAQs',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 400.0,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                List<Map<String, String>> contents = [
                  {
                    'title':
                        'Within the capabilities of DocProbe Assist, what types of questions are most likely to yield accurate and insightful responses?',
                    'content': """

# Identifying Optimal Prompt Styles for DocProbe Assist

Query: Within the capabilities of DocProbe Assist, what types of questions are most likely to yield accurate and insightful responses?

DocProbe Assist Capabilities:

DocProbe Assist can effectively handle a variety of question formats, but certain styles tend to optimize its ability to deliver accurate and insightful responses. Here's a breakdown of these preferred structures:

* Factual Inquiries: Focus on seeking objective, verifiable information. Utilize keywords like what is, define, when was, or who discovered. For instance, what is the capital of France?

* List Generation: Aim to acquire an ordered list of items. Employ keywords like list, enumerate, name some, or give me a few. An example: enumerate the phases of the water cycle.

* Instructional Prompts: Target obtaining clear steps to complete a task. Leverage keywords like how to, steps for, or instructions on. For instance, how to change a tire?

* Summarization Requests: Strive for a concise overview of a particular topic. Include keywords like summarize, in short, or the main points of. An example: summarize the life of Albert Einstein.

* Comparison Prompts: Focus on highlighting similarities and differences between things. Utilize keywords like compare, contrast, differences between, or similarities of. For instance, compare and contrast DNA and RNA.

* Creative Text Generation: Target generation of imaginative text formats like poems, scripts, or code. Employ keywords like write a poem about, generate a story with the prompt, or create a Python script for. An example: write a limerick about a grumpy cat.

* Context-Specific Question Answering: Provide surrounding text alongside your question. Include keywords like based on the passage, according to the text, in this article, or can you answer a question about. For instance, based on the passage, what are the causes of the French Revolution? (Provide the passage beforehand).

* Translation Prompts: Target conversion of text from one language to another. Utilize keywords like translate, convert to, or in French. An example: translate this sentence to Spanish: Hello, how are you?

* Code Completion Prompts: Target acquiring assistance in finishing or suggesting code snippets. Include keywords like complete the code, what comes next, or function for. For instance, complete the code to find the factorial of a number in Python: def factorial(n): ...

* Open-Ended Inquiries: Encourage discussion and exploration of ideas. Utilize keywords like what do you think about, why is it important, or discuss the implications of. An example: what do you think the future of artificial intelligence holds?

Remember:

* The more specific your question, the better the answer will be.
* Strategic use of keywords guides DocProbe Assist towards the type of response you desire.
* Be mindful that DocProbe Assist might not have built-in safety features for factual or sensitive topics, so double-check the information it provides.

"""
                  },
                  {
                    'title': 'How do I use DocProbe Assist?',
                    'content': """1. Upload your document or provide a link.
2. Ask your question in a clear and concise manner.
3. DocProbe Assist will analyze the document and provide you with an answer.
"""
                  },
                  {
                    'title': 'Is DocProbe Assist secure?',
                    'content':
                        """Data security is a top priority for DocProbe Assist. We employ secure protocols to protect your documents and information."""
                  },
                  {
                    'title':
                        'What if DocProbe Assist can not answer my question?',
                    'content':
                        'Add the feedback to the query. We will look into it.'
                  },
                ];
                return ExpansionTile(
                  leading: Icon(
                    Icons.square,
                  ),
                  title: Text('${contents[index]['title']}'),
                  expandedAlignment: Alignment.topLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('${contents[index]['content']}'),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
