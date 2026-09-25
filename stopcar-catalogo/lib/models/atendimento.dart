enum TipoServico { lavagemSimples, lavagemCompleta, polimento, enceramento }

extension TipoServicoLabel on TipoServico {
  String get label {
    switch (this) {
      case TipoServico.lavagemSimples:
        return 'Lavagem simples';
      case TipoServico.lavagemCompleta:
        return 'Lavagem completa';
      case TipoServico.polimento:
        return 'Polimento';
      case TipoServico.enceramento:
        return 'Enceramento';
    }
  }
}

enum StatusAtendimento { pendente, concluido }

extension StatusAtendimentoLabel on StatusAtendimento {
  String get label =>
      this == StatusAtendimento.pendente ? 'Pendente' : 'Concluído';
}

class Atendimento {
  final String id;
  final String cliente;
  final String veiculo;
  final String placa;
  final TipoServico tipoServico;
  final double valor;
  final DateTime data;
  final StatusAtendimento status;
  final String? observacoes;

  Atendimento({
    required this.id,
    required this.cliente,
    required this.veiculo,
    required this.placa,
    required this.tipoServico,
    required this.valor,
    required this.data,
    required this.status,
    this.observacoes,
  });

  static const Object _unset = Object();

  Atendimento copyWith({
    String? cliente,
    String? veiculo,
    String? placa,
    TipoServico? tipoServico,
    double? valor,
    DateTime? data,
    StatusAtendimento? status,
    Object? observacoes = _unset,
  }) {
    return Atendimento(
      id: id,
      cliente: cliente ?? this.cliente,
      veiculo: veiculo ?? this.veiculo,
      placa: placa ?? this.placa,
      tipoServico: tipoServico ?? this.tipoServico,
      valor: valor ?? this.valor,
      data: data ?? this.data,
      status: status ?? this.status,
      observacoes: identical(observacoes, _unset) ? this.observacoes : observacoes as String?,
    );
  }
}
