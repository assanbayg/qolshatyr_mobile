// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/data/faq_data.dart';

class FAQScreen extends StatelessWidget {
  static const routeName = '/faq';

  const FAQScreen({super.key});

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
