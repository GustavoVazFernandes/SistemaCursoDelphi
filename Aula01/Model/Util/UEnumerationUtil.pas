unit UEnumerationUtil;

interface

type
   TEstadoTela =
      (etPadrao, etIncluir, etAlterar, etExcluir, etConsultar, etListar,
       etPesquisarCliente,etPesquisarProduto,etConsultarCliente,
       etConsultarProduto,etPesquisar,etIncluirDados, etConsultarVenda);

   TPessoa = (peFisica, peJuridica);

   TTipoPessoa = (tpCliente, tpFornecedor, tpVendedor);

   TTipoEndereco = (tePrincipal, teEntrega, teCobranca);

implementation

end.
 