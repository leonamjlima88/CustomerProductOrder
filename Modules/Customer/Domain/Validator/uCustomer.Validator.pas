unit uCustomer.Validator;

interface

uses
  uCustomer.Validator.Interfaces,
  uCustomer.Entity.Interfaces,
  uConnection.Types;

type
  TCustomerValidator = class(TInterfacedObject, ICustomerValidator)
  private
    FEntity: ICustomerEntity;
    FEntityState: TEntityState;
    FErrors: String;
    constructor Create(AEntity: ICustomerEntity; AStateEntityEnum: TEntityState);
    function HandleAttributes: ICustomerValidator;
    function HandleCustomer: ICustomerValidator;
  public
    class function Make(AEntity: ICustomerEntity; AStateEntityEnum: TEntityState): ICustomerValidator;
    function Execute: String;
  end;

implementation

uses
  System.SysUtils;

{ TCustomerValidator }

constructor TCustomerValidator.Create(AEntity: ICustomerEntity; AStateEntityEnum: TEntityState);
begin
  inherited Create;
  FEntity      := AEntity;
  FEntityState := AStateEntityEnum;
  FErrors      := EmptyStr;
end;

function TCustomerValidator.Execute: String;
begin
  HandleAttributes;
  Result := FErrors;
end;

function TCustomerValidator.HandleAttributes: ICustomerValidator;
begin
  Result := Self;
  HandleCustomer;
end;

function TCustomerValidator.HandleCustomer: ICustomerValidator;
begin
  if FEntity.name.Trim.IsEmpty then
    FErrors := FErrors + 'O Campo [Nome] é obrigatório. ' + #13;
end;

class function TCustomerValidator.Make(AEntity: ICustomerEntity; AStateEntityEnum: TEntityState): ICustomerValidator;
begin
  Result := Self.Create(AEntity, AStateEntityEnum);
end;

end.
