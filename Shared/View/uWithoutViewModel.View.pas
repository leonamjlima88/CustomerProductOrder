unit uWithoutViewModel.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls;

type
  TWithoutViewModelView = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Button2: TButton;
    ActivityIndicator1: TActivityIndicator;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WithoutViewModelView: TWithoutViewModelView;

implementation

{$R *.dfm}

uses
  uCustomer.Controller,
  uCustomer.Entity,
  uCustomer.Entity.Interfaces,
  uEither,
  uProduct.Entity,
  uProduct.Entity.Interfaces,
  uProduct.Controller,
  uSalesOrder.Entity,
  uSalesOrder.Entity.Interfaces,
  uSalesOrderProduct.Entity.Interfaces,
  uSalesOrderProduct.Entity,
  uSalesOrder.Controller,
  System.Threading,
  uCustomer.Controller.Interfaces,
  uPageFilter,
  uIndexResult;

procedure TWithoutViewModelView.Button1Click(Sender: TObject);
var
  lCustomerEntity: ICustomerEntity;
  lStoreResult: Either<string, Int64>;

  lProductEntity: IProductEntity;
  lSalesOrderEntity: ISalesOrderEntity;
  lSalesOrderProductEntity: ISalesOrderProductEntity;
  lAmount: Double;
  lSumSalesOrderProductAmount: Double;
begin
  // ---------------------------------------------------------------------------
  // CADASTRO DO CLIENTE
  // ---------------------------------------------------------------------------
  // Informações do cliente a serem cadastradas
  lCustomerEntity       := TCustomerEntity.Create;
  lCustomerEntity.name  := 'Leonam José de Lima';
  lCustomerEntity.city  := 'Mogi Guaçu';
  lCustomerEntity.state := 'SP';

  // Inserção do Cliente - Retorno do tipo Either
  lStoreResult := TCustomerController.Make.Store(lCustomerEntity);
  if not lStoreResult.Match then
  begin
    ShowMessage('Falha ao inserir cliente. Msg: ' + lStoreResult.Left);
    Abort;
  end;

  // Localizar Cliente
  lCustomerEntity := TCustomerController.Make.Show(lStoreResult.Right);
  // ---------------------------------------------------------------------------





  // ---------------------------------------------------------------------------
  // CADASTRO DO PRODUTO
  // ---------------------------------------------------------------------------
  // Informações do produto a serem cadastradas
  lProductEntity        := TProductEntity.Create;
  lProductEntity.name   := 'RED BULL TE DA ASAS';
  lProductEntity.price  := 14.90;

  // Inserção do Produto - Retorno do tipo Either
  // Repare em... "TProductController.Make(True)" => Make(True) => True
  // Atributo para informar a factory que deseja uma conexão exclusiva.
  // Interessante para utilizar em Threads e Tasks
  lStoreResult := TProductController.Make(True).Store(lProductEntity);
  if not lStoreResult.Match then
  begin
    ShowMessage('Falha ao inserir produto. Msg: ' + lStoreResult.Left);
    Abort;
  end;

  // Localizar Produto
  lProductEntity := TProductController.Make.Show(lStoreResult.Right);
  // ---------------------------------------------------------------------------





  // ---------------------------------------------------------------------------
  // CADASTRO DO PEDIDO DE VENDA
  // ---------------------------------------------------------------------------
  // Informações do pedido de venda a serem cadastradas
  lSalesOrderEntity := TSalesOrderEntity.Create;
  lSalesOrderEntity.customer(lCustomerEntity, True); // Incluir cliente no pedido

  // Adicionar Produto
  lSalesOrderProductEntity := TSalesOrderProductEntity.Create;
  lSalesOrderProductEntity.product(lProductEntity, True); // Inclui produto no pedido
  lSalesOrderEntity.sales_order_product_list.Add(lSalesOrderProductEntity);

  // Método calculados por Classe Entity
  lAmount                     := lSalesOrderProductEntity.amount; // Total do Item
  lSumSalesOrderProductAmount := lSalesOrderEntity.sum_sales_order_product_amount; // Total de todos os itens do pedido de venda

  // Salvar Pedido
  lStoreResult := TSalesOrderController.Make.Store(lSalesOrderEntity);
  if not lStoreResult.Match then
  begin
    ShowMessage('Falha ao inserir Pedido de Venda. Msg: ' + lStoreResult.Left);
    Abort;
  end;

  // Localizar e exibir registros salvos
  lSalesOrderEntity := TSalesOrderController.Make.Show(lStoreResult.Right);
  if not Assigned(lSalesOrderEntity) then
  begin
    raise Exception.Create('Entity not found');
    Abort;
  end;

  Memo1.Clear;
  Memo1.Lines.Add('Número do Pedido.......: ' + lSalesOrderEntity.id.ToString);
  Memo1.Lines.Add('Nome do Cliente........: ' + lSalesOrderEntity.customer.name);
  Memo1.Lines.Add('Cidade do Cliente......: ' + lSalesOrderEntity.customer.city);
  Memo1.Lines.Add('UF do Cliente..........: ' + lSalesOrderEntity.customer.state);
  Memo1.Lines.Add('Total do Pedido........: ' + FormatFloat('#,###,##0.00', lSalesOrderEntity.sum_sales_order_product_amount));
  Memo1.Lines.Add('');
  Memo1.Lines.Add('Produto Lançado');
  Memo1.Lines.Add('Nome do Produto........: ' + lSalesOrderEntity.sales_order_product_list.Items[0].product.name);
  Memo1.Lines.Add('Quantidade do Produto..: ' + lSalesOrderEntity.sales_order_product_list.Items[0].quantity.ToString);
  Memo1.Lines.Add('Preço Unit. do Produto.: ' + FormatFloat('#,###,##0.00', lSalesOrderEntity.sales_order_product_list.Items[0].unit_price));
  Memo1.Lines.Add('Total do do Produto....: ' + FormatFloat('#,###,##0.00', lSalesOrderEntity.sales_order_product_list.Items[0].amount));
end;

procedure TWithoutViewModelView.Button2Click(Sender: TObject);
begin
  ActivityIndicator1.Animate := True;
  Memo1.Visible              := False;

  TTask.Run(procedure
  var
    lCustomerEntity: ICustomerEntity;
    lCtrl: ICustomerController;
    lI: Integer;
    lFirstPk: Int64;
    lStoreResult: Either<string, Int64>;
    lIndexResult: IIndexResult;
  begin
    lCustomerEntity := TCustomerEntity.Create;
    lCtrl           := TCustomerController.Make(True);
    for lI := 0 to 50 do
    begin
      lCustomerEntity.name  := 'Nome '   + (lI+1).ToString;
      lCustomerEntity.city  := 'Cidade ' + (lI+1).ToString;
      lCustomerEntity.state := 'SP'; // Eu poderia ter criado uma validação para o estado, mas não criei.. =\
      lStoreResult := lCtrl.Store(lCustomerEntity);
      if (lI = 0) then
        lFirstPk := lStoreResult.Right;
    end;

    // Pesquisar registro que acabaram de serem lançados
    lIndexResult := lCtrl.Index(
      TPageFilter.Make
        .CurrentPage(1)
        .LimitPerPage(50)
        .Columns('customer.id, customer.name') // Select apenas em duas colunas
        .OrderBy('customer.id') // Ordenar por id
        .AddWhere('customer.id', coGreaterOrEqual, lFirstPk.ToString) // Adicionar condição
    );

    TThread.Synchronize(TThread.CurrentThread, procedure
    begin
      Memo1.Clear;
      With lIndexResult.Data do
      begin
        while not DataSet.Eof do
        begin
          Memo1.Lines.Add( DataSet.FieldByName('name').AsString );

          DataSet.Next;
          Application.ProcessMessages;
        end;
      end;
      Memo1.Visible := True;
      ActivityIndicator1.Animate := False;
    end);
  end).Start;

end;

end.
