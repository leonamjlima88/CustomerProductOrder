unit uProduct.Validator;

interface

uses
  uProduct.Validator.Interfaces,
  uProduct.Entity.Interfaces,
  uConnection.Types;

type
  TProductValidator = class(TInterfacedObject, IProductValidator)
  private
    FEntity: IProductEntity;
    FEntityState: TEntityState;
    FErrors: String;
    constructor Create(AEntity: IProductEntity; AStateEntityEnum: TEntityState);
    function HandleAttributes: IProductValidator;
    function HandleProduct: IProductValidator;
  public
    class function Make(AEntity: IProductEntity; AStateEntityEnum: TEntityState): IProductValidator;
    function Execute: String;
  end;

implementation

uses
  System.SysUtils;

{ TProductValidator }

constructor TProductValidator.Create(AEntity: IProductEntity; AStateEntityEnum: TEntityState);
begin
  inherited Create;
  FEntity      := AEntity;
  FEntityState := AStateEntityEnum;
  FErrors      := EmptyStr;
end;

function TProductValidator.Execute: String;
begin
  HandleAttributes;
  Result := FErrors;
end;

function TProductValidator.HandleAttributes: IProductValidator;
begin
  Result := Self;
  HandleProduct;
end;

function TProductValidator.HandleProduct: IProductValidator;
begin
  if FEntity.name.Trim.IsEmpty then
    FErrors := FErrors + 'O Campo [Nome] é obrigatório. ' + #13;
end;

class function TProductValidator.Make(AEntity: IProductEntity; AStateEntityEnum: TEntityState): IProductValidator;
begin
  Result := Self.Create(AEntity, AStateEntityEnum);
end;

end.
