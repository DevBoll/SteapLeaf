import 'package:flutter/material.dart';

import '../../core/models/tea.dart';

class TeaEditScreen extends StatelessWidget {
  const TeaEditScreen({super.key, this.tea});

  /// Null = neuer Tee, non-null = bestehender Tee bearbeiten.
  final Tea? tea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tea == null ? 'Neuer Tee' : tea!.name)),
    );
  }
}
