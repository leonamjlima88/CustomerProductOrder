unit uSalesOrder.Validator;

interface

uses
  uSalesOrder.Validator.Interfaces,
  uSalesOrder.Entity.Interfaces,
  uConnection.Types,
  uSalesOrderProduct.Entity.Interfaces;

type
  TSalesOrderValidator = class(TInterfacedObject, ISalesOrderValidator)
  private
    FEntity: ISalesOrderEntity;
    FEntityState: TEntityState;
    FErrors: String;
    constructor Create(AEntity: ISalesOrderEntity; AStateEntityEnum: TEntityState);
    function HandleAttributes: ISalesOrderValidator;
    function HandleSalesOrder: ISalesOrderValidator;
    function HandleSalesOrderProductList: TSalesOrderValidator;
  public
    class function Make(AEntity: ISalesOrderEntity; AStateEntityEnum: TEntityState): ISalesOrderValidator;
    function Execute: String;

    function HandleSalesOrderProduct(ASalesOrderProductEntity: ISalesOrderProductEntity): String;
  end;

implementation

uses
  System.SysUtils, uHlp;

{ TSalesOrderValidator }

constructor TSalesOrderValidator.Create(AEntity: ISalesOrderEntity; AStateEntityEnum: TEntityState);
begin
  inherited Create;
  FEntity      := AEntity;
  FEntityState := AStateEntityEnum;
  FErrors      := EmptyStr;
end;

function TSalesOrderValidator.Execute: String;
begin
  HandleAttributes;
  Result := FErrors;
end;

function TSalesOrderValidator.HandleAttributes: ISalesOrderValidator;
begin
  Result := Self;
  HandleSalesOrder;
  HandleSalesOrderProductList;
end;

function TSalesOrderValidator.HandleSalesOrder: ISalesOrderValidator;
begin
  if (FEntity.customer_id <= 0) then
    FErrors := FErrors + 'O Campo [Cliente] é obrigatório. ' + #13;
end;

function TSalesOrderValidator.HandleSalesOrderProduct(ASalesOrderProductEntity: ISalesOrderProductEntity): String;
begin
  Result := EmptyStr;
  if (ASalesOrderProductEntity.product_id <= 0) then
    Result := Result + 'O Campo [Produto] é obrigatório. ' + #13;

  if (ASalesOrderProductEntity.quantity <= 0) then
    Result := Result + 'O Campo [Quantidade] deve ser maaior que "0". ' + #13;

  if (ASalesOrderProductEntity.unit_price <= 0) then
    Result := Result + 'O Campo [Preço Unitário] deve ser maaior que "0". ' + #13;

  if (ASalesOrderProductEntity.amount <= 0) then
    Result := Result + 'O Campo [Total] deve ser maior que "0". ' + #13;
end;

function TSalesOrderValidator.HandleSalesOrderProductList: TSalesOrderValidator;
var
  lI: Integer;
  lCurrentError: String;
begin
  if (FEntity.sales_order_product_list.Count <= 0) then
    FErrors := FErrors + 'Em Produtos > Nenhum item lançado.' + #13;

  for lI := 0 to Pred(FEntity.sales_order_product_list.Count) do
  begin
    lCurrentError := HandleSalesOrderProduct(FEntity.sales_order_product_list.Items[lI]);
    if not lCurrentError.Trim.IsEmpty then
      FErrors := FErrors + 'Em Produtos > Produto: ' + THlp.strZero(lI.ToString,2) + ' > ' + #13 + lCurrentError + #13;
  end;
end;

class function TSalesOrderValidator.Make(AEntity: ISalesOrderEntity; AStateEntityEnum: TEntityState): ISalesOrderValidator;
begin
  Result := Self.Create(AEntity, AStateEntityEnum);
end;

end.
