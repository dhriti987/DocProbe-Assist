import 'package:flutter/material.dart';

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
                      text: 'How It Works',
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

class AboutUsSection extends StatelessWidget {
  const AboutUsSection({super.key});

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
                SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: Image.network(
                    'https://www.shutterstock.com/image-vector/3d-artificial-intelligence-digital-brain-600nw-2288372371.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
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
            'How It Works',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 400.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                List<Map<String, String>> contents = [
                  {
                    'title': 'User Interaction',
                    'content':
                        'Doc Probe Assist provides a seamless interface for users to submit their documents and ask questions, enhancing the overall user experience.'
                  },
                  {
                    'title': 'Advanced Text Processing',
                    'content':
                        'Our platform utilizes advanced text processing techniques to analyze and extract information from documents with high accuracy.'
                  },
                  {
                    'title': 'Intelligent Answer Generation',
                    'content':
                        'Using advanced machine learning algorithms, Doc Probe Assist generates intelligent answers to user queries based on document content.'
                  },
                  {
                    'title': 'Document Security',
                    'content':
                        'We prioritize the security and confidentiality of your documents, ensuring that your data is protected at all times.'
                  },
                ];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff0b74b0),
                          Color(0xff75479c),
                          Color(0xffbd3861),
                        ],
                      ),
                      shape: BoxShape.rectangle,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            contents[index]['title']!,
                            style: const TextStyle(
                                fontSize: 24.0, color: Colors.white),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              contents[index]['content']!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
