unit uCustomer.ViewModel;

interface

uses
  uCustomer.ViewModel.Interfaces,
  Data.DB,
  uMemTable.Interfaces;

type
  TCustomerViewModel = class(TInterfacedObject, ICustomerViewModel)
  private
    FCustomer: IMemTable;
    function SetUp: ICustomerViewModel;
    constructor Create;
    // Customer
    procedure CustomerAfterInsert(DataSet: TDataSet);
  public
    class function Make: ICustomerViewModel;
    destructor Destroy; override;

    function Customer: IMemTable;
    function CustomerClear: ICustomerViewModel;
  end;

implementation

uses
  uHlp,
  uMemTable.Factory;

{ TCustomerViewModel }

function TCustomerViewModel.Customer: IMemTable;
begin
  Result := FCustomer;
end;

procedure TCustomerViewModel.CustomerAfterInsert(DataSet: TDataSet);
begin
  THlp.fillDataSetWithZero(DataSet);
end;

function TCustomerViewModel.CustomerClear: ICustomerViewModel;
begin
  Result := Self;
  FCustomer.DataSet.First;
  while not FCustomer.DataSet.Eof do
    FCustomer.DataSet.Delete;
end;

constructor TCustomerViewModel.Create;
begin
  inherited Create;
  FCustomer := TMemTableFactory.Make();
  SetUp;
end;

destructor TCustomerViewModel.Destroy;
begin
  inherited;
end;

class function TCustomerViewModel.Make: ICustomerViewModel;
begin
  Result := Self.Create;
end;

function TCustomerViewModel.SetUp: ICustomerViewModel;
begin
  Result := Self;

  // Customer
  With FCustomer.FieldDefs do
  begin
    Add('id', ftLargeint);
    Add('name', ftString, 100);
    Add('city', ftString, 80);
    Add('state', ftString, 2);
    Add('created_at', ftDateTime);
    Add('updated_at', ftDateTime);
  end;
  FCustomer.CreateDataSet.Active(True);

  // Formatar Dataset
  THlp.formatDataSet(FCustomer.DataSet);

  // Eventos
  FCustomer.DataSet.AfterInsert := CustomerAfterInsert;
end;

end.
