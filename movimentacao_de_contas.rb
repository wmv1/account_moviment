require 'csv'
require 'bigdecimal'

class MovimentacaoDeContas
  attr_reader :contas, :transacoes

  VALOR_DA_MULTA = 3.0

  def initialize(contas_path, transacoes_path)
    @contas = ler_contas(contas_path)
    @transacoes = ler_transacoes(transacoes_path)
  end

  def processar_transacoes
    @transacoes.each do |t|
      @contas.each do |c|
        next if t[:id] != c[:id]

        deposita_ou_debita(c,  t)
      end
    end
  end

  def mostrar
    @contas.each do |c|
      p ("Saldo final de  R$ %.2f na conta: #{c[:id]}" %  c[:saldo]).to_s.gsub('.',',')
    end
  end

  private

  def deposita_ou_debita(conta, transacao)
    if aplicar_multa?( conta[:saldo], transacao[:operacao])
      conta[:saldo] += transacao[:operacao] - VALOR_DA_MULTA
    else
      conta[:saldo] += transacao[:operacao]
    end
  end

  def aplicar_multa?(saldo, operacao)
    return false if operacao.positive?

    saldo.negative? || conta_sera_negativada?(saldo, operacao)
  end
  def deposito?(valor_operacao)
    valor_operacao.positive?
  end

  def conta_sera_negativada?(saldo, valor)
    (BigDecimal(saldo.to_s, 10).to_f - BigDecimal(valor.to_s,10).to_f).round(2).negative?
  end

  def ler_contas(contas_path)
    CSV.new(File.read(contas_path), col_sep: ',').flat_map do |row|
      { id: row[0], saldo: (BigDecimal(row[1]) / BigDecimal(100)).to_f.round(5) }
    end
  end

  def ler_transacoes(transacoes_path)
    CSV.new(File.read(transacoes_path), col_sep: ',').flat_map do |row|
      { id: row[0], operacao: (BigDecimal(row[1]) / BigDecimal(100)).to_f.round(5) }
    end
  end
end

MovimentacaoDeContas.new('contas.csv', 'transacoes.csv')