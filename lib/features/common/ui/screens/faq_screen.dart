import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  static const routeName = '/faq';

  FAQScreen({super.key});

  final List<Map<String, String>> faqData = [
    {
      "question": "Question 1",
      "answer": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "question": "Question 2",
      "answer":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "question": "Question 3",
      "answer":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    },
    {
      "question": "Question 4",
      "answer":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: ListView.builder(
        itemCount: faqData.length,
        itemBuilder: (context, index) {
          final faq = faqData[index];
          return ExpansionTile(
            title: Text(faq['question']!),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faq['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}