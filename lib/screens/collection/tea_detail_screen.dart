import 'package:flutter/material.dart';

import '../../core/models/tea.dart';

class TeaDetailScreen extends StatelessWidget {
  const TeaDetailScreen({
    super.key,
    required this.tea,
    required this.teaId,
  });

  final Tea tea;
  final String teaId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tea.name)),
    );
  }
}
