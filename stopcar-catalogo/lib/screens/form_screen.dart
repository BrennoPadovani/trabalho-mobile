import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/atendimento.dart';
import '../state/atendimento_repository.dart';

class FormScreen extends StatefulWidget {
  final Atendimento? existente;

  const FormScreen({super.key, this.existente});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clienteController;
  late TextEditingController _veiculoController;
  late TextEditingController _placaController;
  late TextEditingController _valorController;
  late TextEditingController _observacoesController;
  late TipoServico _tipoServico;
  late StatusAtendimento _status;
  late DateTime _data;

  static final RegExp _placaRegex = RegExp(r'^[A-Za-z]{3}-?\d[A-Za-z0-9]\d{2}$');

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    _clienteController = TextEditingController(text: existente?.cliente ?? '');
    _veiculoController = TextEditingController(text: existente?.veiculo ?? '');
    _placaController = TextEditingController(text: existente?.placa ?? '');
    _valorController = TextEditingController(
      text: existente != null ? existente.valor.toStringAsFixed(2) : '',
    );
    _observacoesController = TextEditingController(text: existente?.observacoes ?? '');
    _tipoServico = existente?.tipoServico ?? TipoServico.lavagemSimples;
    _status = existente?.status ?? StatusAtendimento.pendente;
    _data = existente?.data ?? DateTime.now();
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _veiculoController.dispose();
    _placaController.dispose();
    _valorController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.existente != null;
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar atendimento' : 'Novo atendimento')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                TextFormField(
                  controller: _clienteController,
                  decoration: const InputDecoration(labelText: 'Cliente *'),
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Informe o nome do cliente.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _veiculoController,
                  decoration: const InputDecoration(labelText: 'Veículo (modelo) *'),
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Informe o modelo do veículo.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _placaController,
                  decoration: const InputDecoration(labelText: 'Placa *', hintText: 'ABC1D23'),
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Informe a placa.';
                    if (!_placaRegex.hasMatch(value.trim())) {
                      return 'Use o formato ABC1D23 ou ABC-1D23.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TipoServico>(
                  initialValue: _tipoServico,
                  decoration: const InputDecoration(labelText: 'Tipo de serviço *'),
                  items: TipoServico.values
                      .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo.label)))
                      .toList(),
                  onChanged: (value) => setState(() => _tipoServico = value ?? _tipoServico),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorController,
                  decoration: const InputDecoration(labelText: 'Valor (R\$) *'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Informe o valor.';
                    final normalizado = value.trim().replaceAll(',', '.');
                    final numero = double.tryParse(normalizado);
                    if (numero == null || numero <= 0) {
                      return 'Informe um valor numérico maior que zero.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<StatusAtendimento>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status *'),
                  items: StatusAtendimento.values
                      .map((status) => DropdownMenuItem(value: status, child: Text(status.label)))
                      .toList(),
                  onChanged: (value) => setState(() => _status = value ?? _status),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observacoesController,
                  decoration: const InputDecoration(labelText: 'Observações'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _salvar,
                  child: Text(editando ? 'Salvar alterações' : 'Cadastrar atendimento'),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    final repo = context.read<AtendimentoRepository>();
    final valor = double.parse(_valorController.text.trim().replaceAll(',', '.'));
    final observacoes =
        _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim();

    if (widget.existente == null) {
      repo.adicionar(
        cliente: _clienteController.text.trim(),
        veiculo: _veiculoController.text.trim(),
        placa: _placaController.text.trim().toUpperCase(),
        tipoServico: _tipoServico,
        valor: valor,
        data: _data,
        status: _status,
        observacoes: observacoes,
      );
    } else {
      repo.atualizar(
        widget.existente!.copyWith(
          cliente: _clienteController.text.trim(),
          veiculo: _veiculoController.text.trim(),
          placa: _placaController.text.trim().toUpperCase(),
          tipoServico: _tipoServico,
          valor: valor,
          status: _status,
          observacoes: observacoes,
        ),
      );
    }
    Navigator.of(context).pop();
  }
}
