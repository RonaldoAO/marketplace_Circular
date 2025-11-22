import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar Productos',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.mic_none_rounded),
                onPressed: () {},
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6E6E6)),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
          ),
        ),
      ],
    );
  }
}
