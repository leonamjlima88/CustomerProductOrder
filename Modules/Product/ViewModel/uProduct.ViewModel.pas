unit uProduct.ViewModel;

interface

uses
  uProduct.ViewModel.Interfaces,
  Data.DB,
  uMemTable.Interfaces;

type
  TProductViewModel = class(TInterfacedObject, IProductViewModel)
  private
    FProduct: IMemTable;
    function SetUp: IProductViewModel;
    constructor Create;
    // Product
    procedure ProductAfterInsert(DataSet: TDataSet);
  public
    class function Make: IProductViewModel;
    destructor Destroy; override;

    function Product: IMemTable;
    function ProductClear: IProductViewModel;
  end;

implementation

uses
  uHlp,
  uMemTable.Factory;

{ TProductViewModel }

function TProductViewModel.Product: IMemTable;
begin
  Result := FProduct;
end;

procedure TProductViewModel.ProductAfterInsert(DataSet: TDataSet);
begin
  THlp.fillDataSetWithZero(DataSet);
end;

function TProductViewModel.ProductClear: IProductViewModel;
begin
  Result := Self;
  FProduct.DataSet.First;
  while not FProduct.DataSet.Eof do
    FProduct.DataSet.Delete;
end;

constructor TProductViewModel.Create;
begin
  inherited Create;
  FProduct := TMemTableFactory.Make();
  SetUp;
end;

destructor TProductViewModel.Destroy;
begin
  inherited;
end;

class function TProductViewModel.Make: IProductViewModel;
begin
  Result := Self.Create;
end;

function TProductViewModel.SetUp: IProductViewModel;
begin
  Result := Self;

  // Product
  With FProduct.FieldDefs do
  begin
    Add('id', ftLargeint);
    Add('name', ftString, 100);
    Add('price', ftFloat);
    Add('created_at', ftDateTime);
    Add('updated_at', ftDateTime);
  end;
  FProduct.CreateDataSet.Active(True);

  // Formatar Dataset
  THlp.formatDataSet(FProduct.DataSet);

  // Eventos
  FProduct.DataSet.AfterInsert := ProductAfterInsert;
end;

end.
