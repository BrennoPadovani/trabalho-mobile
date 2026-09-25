import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/atendimento.dart';
import '../state/atendimento_repository.dart';
import '../widgets/status_chip.dart';
import 'form_screen.dart';

class DetalheScreen extends StatelessWidget {
  final String atendimentoId;

  const DetalheScreen({super.key, required this.atendimentoId});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<AtendimentoRepository>();
    final atendimento = repo.porId(atendimentoId);

    if (atendimento == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Atendimento')),
        body: const Center(child: Text('Atendimento não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(atendimento.cliente),
        actions: [
          IconButton(
            tooltip: 'Editar atendimento',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => FormScreen(existente: atendimento)),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        atendimento.veiculo,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    StatusChip(status: atendimento.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Placa: ${atendimento.placa}'),
                const SizedBox(height: 16),
                _linha(context, 'Serviço', atendimento.tipoServico.label),
                _linha(context, 'Valor', 'R\$ ${atendimento.valor.toStringAsFixed(2)}'),
                _linha(
                  context,
                  'Data',
                  '${atendimento.data.day.toString().padLeft(2, '0')}/'
                      '${atendimento.data.month.toString().padLeft(2, '0')}/'
                      '${atendimento.data.year}',
                ),
                if (atendimento.observacoes != null && atendimento.observacoes!.isNotEmpty)
                  _linha(context, 'Observações', atendimento.observacoes!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _linha(BuildContext context, String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rotulo, style: Theme.of(context).textTheme.labelLarge),
          Text(valor, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
