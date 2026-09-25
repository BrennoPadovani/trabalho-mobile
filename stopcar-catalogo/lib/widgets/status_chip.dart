import 'package:flutter/material.dart';
import '../models/atendimento.dart';

class StatusChip extends StatelessWidget {
  final StatusAtendimento status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isConcluido = status == StatusAtendimento.concluido;
    final scheme = Theme.of(context).colorScheme;
    final background = isConcluido ? scheme.tertiaryContainer : scheme.errorContainer;
    final foreground = isConcluido ? scheme.onTertiaryContainer : scheme.onErrorContainer;
    return Semantics(
      label: 'Status: ${status.label}',
      child: Chip(
        label: Text(status.label),
        backgroundColor: background,
        labelStyle: TextStyle(color: foreground, fontWeight: FontWeight.w600),
      ),
    );
  }
}
