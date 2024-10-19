// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchCard extends StatelessWidget {
  final Function onSearch;
  final TextEditingController addressController;

  const SearchCard(
      {super.key, required this.onSearch, required this.addressController});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: addressController,
                  // TODO: localize
                  decoration: InputDecoration(
                    hintText: localization.enterAddress,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (addressController.text.isNotEmpty) {
                    onSearch();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
