unit uSalesOrder.ViewModel;

interface

uses
  uSalesOrder.ViewModel.Interfaces,
  Data.DB,
  uMemTable.Interfaces;

type
  TSalesOrderViewModel = class(TInterfacedObject, ISalesOrderViewModel)
  private
    FSalesOrder: IMemTable;
    FSalesOrderProduct: IMemTable;
    function SetUp: ISalesOrderViewModel;
    constructor Create;
    // SalesOrder
    procedure SalesOrderAfterInsert(DataSet: TDataSet);
    procedure SalesOrderCustomerIdSetText(Sender: TField; const Text: string);
    // SalesOrderProduct
    procedure SalesOrderProductAfterInsert(DataSet: TDataSet);
    procedure SalesOrderProductBeforePost(DataSet: TDataSet);
    procedure SalesOrderProductProductIdSetText(Sender: TField; const Text: string);
  public
    class function Make: ISalesOrderViewModel;
    destructor Destroy; override;

    function SalesOrder: IMemTable;
    function SalesOrderClear: ISalesOrderViewModel;

    function SalesOrderProduct: IMemTable;
    function SalesOrderProductClear: ISalesOrderViewModel;
  end;

implementation

uses
  uHlp,
  uMemTable.Factory,
  uCustomer.Entity.Interfaces,
  uCustomer.Controller,
  uProduct.Entity.Interfaces,
  uProduct.Controller;

{ TSalesOrderViewModel }

function TSalesOrderViewModel.SalesOrder: IMemTable;
begin
  Result := FSalesOrder;
end;

procedure TSalesOrderViewModel.SalesOrderAfterInsert(DataSet: TDataSet);
begin
  THlp.fillDataSetWithZero(DataSet);
end;

function TSalesOrderViewModel.SalesOrderClear: ISalesOrderViewModel;
begin
  Result := Self;
  FSalesOrder.DataSet.First;
  while not FSalesOrder.DataSet.Eof do
    FSalesOrder.DataSet.Delete;
end;

procedure TSalesOrderViewModel.SalesOrderCustomerIdSetText(Sender: TField; const Text: string);
var
  lDataSet: TDataSet;
  lCustomerEntity: ICustomerEntity;
begin
  Sender.AsInteger := THlp.StrInt(Text);
  lDataSet         := Sender.DataSet;

  If not (lDataSet.State in [dsInsert, dsEdit]) Then
    Exit;

  // Localizar Cliente
  lCustomerEntity := TCustomerController.Make.Show(Sender.AsInteger);
  case Assigned(lCustomerEntity) of
    True: Begin
      lDataSet.FieldByName('customer_name').AsString  := lCustomerEntity.name;
      lDataSet.FieldByName('customer_city').AsString  := lCustomerEntity.city;
      lDataSet.FieldByName('customer_state').AsString := lCustomerEntity.state;
    end;
    False: Begin
      Sender.Clear;
      lDataSet.FieldByName('customer_name').Clear;
      lDataSet.FieldByName('customer_city').Clear;
      lDataSet.FieldByName('customer_state').Clear;
    End;
  end;
end;

function TSalesOrderViewModel.SalesOrderProduct: IMemTable;
begin
  Result := FSalesOrderProduct;
end;

procedure TSalesOrderViewModel.SalesOrderProductAfterInsert(DataSet: TDataSet);
begin
  THlp.fillDataSetWithZero(DataSet);
end;

procedure TSalesOrderViewModel.SalesOrderProductBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('amount').AsFloat := DataSet.FieldByName('quantity').AsFloat *  DataSet.FieldByName('unit_price').AsFloat;
end;

function TSalesOrderViewModel.SalesOrderProductClear: ISalesOrderViewModel;
begin
  Result := Self;
  FSalesOrderProduct.DataSet.First;
  while not FSalesOrderProduct.DataSet.Eof do
    FSalesOrderProduct.DataSet.Delete;
end;

procedure TSalesOrderViewModel.SalesOrderProductProductIdSetText(Sender: TField; const Text: string);
var
  lDataSet: TDataSet;
  lProductEntity: IProductEntity;
begin
  Sender.AsInteger := THlp.StrInt(Text);
  lDataSet         := Sender.DataSet;

  If not (lDataSet.State in [dsInsert, dsEdit]) Then
    Exit;

  // Localizar Producto
  lProductEntity := TProductController.Make.Show(Sender.AsInteger);
  case Assigned(lProductEntity) of
    True:  lDataSet.FieldByName('product_name').AsString := lProductEntity.name;
    False: Begin
      Sender.Clear;
      lDataSet.FieldByName('product_name').Clear;
    End;
  end;
end;

constructor TSalesOrderViewModel.Create;
begin
  inherited Create;
  FSalesOrder        := TMemTableFactory.Make();
  FSalesOrderProduct := TMemTableFactory.Make();
  SetUp;
end;

destructor TSalesOrderViewModel.Destroy;
begin
  inherited;
end;

class function TSalesOrderViewModel.Make: ISalesOrderViewModel;
begin
  Result := Self.Create;
end;

function TSalesOrderViewModel.SetUp: ISalesOrderViewModel;
begin
  Result := Self;

  // SalesOrder
  With FSalesOrder.FieldDefs do
  begin
    Add('id', ftLargeint);
    Add('customer_id', ftLargeint);
    Add('sum_sales_order_product_amount', ftFloat);
    Add('created_at', ftDateTime);
    Add('updated_at', ftDateTime);

    // Virtuais
    Add('customer_name', ftString, 100);
    Add('customer_city', ftString, 100);
    Add('customer_state', ftString, 2);
  end;
  FSalesOrder.CreateDataSet.Active(True);

  // Formatar Dataset
  THlp.formatDataSet(FSalesOrder.DataSet);

  // Eventos
  FSalesOrder.DataSet.AfterInsert := SalesOrderAfterInsert;
  FSalesOrder.DataSet.FieldByName('customer_id').OnSetText := SalesOrderCustomerIdSetText;



  // SalesOrderProduct
  With FSalesOrderProduct.FieldDefs do
  begin
    Add('id', ftLargeint);
    Add('sales_order_id', ftLargeint);
    Add('product_id', ftLargeint);
    Add('quantity', ftFloat);
    Add('unit_price', ftFloat);
    Add('amount', ftFloat);

    // Virtuais
    Add('product_name',  ftString, 100);
    Add('product_price', ftFloat);
  end;
  FSalesOrderProduct.CreateDataSet.Active(True);

  // Formatar Dataset
  THlp.formatDataSet(FSalesOrderProduct.DataSet);

  // Eventos
  FSalesOrderProduct.DataSet.AfterInsert := SalesOrderProductAfterInsert;
  FSalesOrderProduct.DataSet.BeforePost  := SalesOrderProductBeforePost;
  FSalesOrderProduct.DataSet.FieldByName('product_id').OnSetText := SalesOrderProductProductIdSetText;
end;

end.
