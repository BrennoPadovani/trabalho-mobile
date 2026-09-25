import 'package:flutter/foundation.dart';
import '../models/atendimento.dart';

class AtendimentoRepository extends ChangeNotifier {
  final List<Atendimento> _atendimentos = [];
  int _proximoId = 1;

  List<Atendimento> get atendimentos => List.unmodifiable(_atendimentos);

  bool get isEmpty => _atendimentos.isEmpty;

  Atendimento adicionar({
    required String cliente,
    required String veiculo,
    required String placa,
    required TipoServico tipoServico,
    required double valor,
    required DateTime data,
    required StatusAtendimento status,
    String? observacoes,
  }) {
    final atendimento = Atendimento(
      id: 'A${_proximoId++}',
      cliente: cliente,
      veiculo: veiculo,
      placa: placa,
      tipoServico: tipoServico,
      valor: valor,
      data: data,
      status: status,
      observacoes: observacoes,
    );
    _atendimentos.insert(0, atendimento);
    notifyListeners();
    return atendimento;
  }

  void atualizar(Atendimento atualizado) {
    final index = _atendimentos.indexWhere((a) => a.id == atualizado.id);
    if (index == -1) return;
    _atendimentos[index] = atualizado;
    notifyListeners();
  }

  Atendimento? porId(String id) {
    for (final atendimento in _atendimentos) {
      if (atendimento.id == id) return atendimento;
    }
    return null;
  }
}
