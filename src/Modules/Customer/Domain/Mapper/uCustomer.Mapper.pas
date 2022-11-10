unit uCustomer.Mapper;

interface

uses
  uCustomer.Entity.Interfaces,
  Data.DB;

type
  TCustomerMapper = class
  private
  public
    class procedure EntityToDataSet(const AEntity: ICustomerEntity; const ADataSet: TDataSet);
    class procedure DataSetToEntity(const ADataSet: TDataSet; const AEntity: ICustomerEntity);
  end;

implementation

{ TCustomerMapper }

class procedure TCustomerMapper.DataSetToEntity(const ADataSet: TDataSet; const AEntity: ICustomerEntity);
begin
  // Customer
  if Assigned(ADataSet) then
  Begin
    AEntity.id         := ADataSet.FieldByName('id').AsLargeInt;
    AEntity.name       := ADataSet.FieldByName('name').AsString;
    AEntity.city       := ADataSet.FieldByName('city').AsString;
    AEntity.state      := ADataSet.FieldByName('state').AsString;
    AEntity.created_at := ADataSet.FieldByName('created_at').AsDateTime;
    AEntity.updated_at := ADataSet.FieldByName('updated_at').AsDateTime;
  end;
end;

class procedure TCustomerMapper.EntityToDataSet(const AEntity: ICustomerEntity; const ADataSet: TDataSet);
begin
  // Customer
  if Assigned(ADataSet) then
  Begin
    if not (ADataSet.State in [dsEdit]) then
      ADataSet.Edit;

    ADataSet.FieldByName('id').AsLargeInt         := AEntity.id;
    ADataSet.FieldByName('name').AsString         := AEntity.name;
    ADataSet.FieldByName('city').AsString         := AEntity.city;
    ADataSet.FieldByName('state').AsString        := AEntity.state;
    ADataSet.FieldByName('created_at').AsDateTime := AEntity.created_at;
    ADataSet.FieldByName('updated_at').AsDateTime := AEntity.updated_at;

    if (ADataSet.State in [dsEdit, dsInsert]) then
      ADataSet.Post;
  end;
end;

end.
