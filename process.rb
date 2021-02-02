require './movimentacao_de_contas'

movimentacao = MovimentacaoDeContas.new(ARGV[0], ARGV[1])
movimentacao.processar_transacoes
movimentacao.mostrar