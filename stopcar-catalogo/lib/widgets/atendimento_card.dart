import 'package:flutter/material.dart';
import '../models/atendimento.dart';
import 'status_chip.dart';

class AtendimentoCard extends StatelessWidget {
  final Atendimento atendimento;
  final VoidCallback onTap;

  const AtendimentoCard({super.key, required this.atendimento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      atendimento.cliente,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${atendimento.veiculo} · ${atendimento.placa}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      atendimento.tipoServico.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusChip(status: atendimento.status),
            ],
          ),
        ),
      ),
    );
  }
}
