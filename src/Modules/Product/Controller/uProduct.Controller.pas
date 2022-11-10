unit uProduct.Controller;

interface

uses
  uProduct.Controller.Interfaces,
  uProduct.Entity.Interfaces,
  uProduct.Service.Interfaces,
  uEither,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  TProductController = class(TInterfacedObject, IProductController)
  private
    FService: IProductService;
    constructor Create(APoolConn: Boolean);
  public
    class function Make(APoolConn: Boolean = False): IProductController;

    function Delete(AId: Int64): Boolean;
    function Index: TList<IProductEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): IProductEntity;
    function Store(AEntity: IProductEntity): Either<string, Int64>;
    function Update(AEntity: IProductEntity; AId: Int64): Either<string,Boolean>;
  end;

implementation

uses
  uProduct.Service,
  uProduct.Repository.Factory,
  uProduct.Validator,
  uConnection.Types,
  System.SysUtils;

{ TProductController }

constructor TProductController.Create(APoolConn: Boolean);
begin
  inherited Create;
  FService := TProductService.Make(TProductRepositoryFactory.Make(APoolConn));
end;

function TProductController.Delete(AId: Int64): Boolean;
begin
  Result := FService.Delete(AId);
end;

function TProductController.Index(APageFilter: IPageFilter): IIndexResult;
begin
  Result := FService.Index(APageFilter);
end;

function TProductController.Index: TList<IProductEntity>;
begin
  Result := FService.Index;
end;

class function TProductController.Make(APoolConn: Boolean): IProductController;
begin
  Result := Self.Create(APoolConn);
end;

function TProductController.Show(AId: Int64): IProductEntity;
begin
  Result := FService.Show(AId);
end;

function TProductController.Store(AEntity: IProductEntity): Either<string, Int64>;
var
  lErrors: String;
begin
  // Validar e Inserir
  lErrors := TProductValidator.Make(AEntity, TEntityState.esStore).Execute;
  case lErrors.Trim.IsEmpty of
    True:  Result := FService.Store(AEntity);
    False: Result := lErrors;
  end;
end;

function TProductController.Update(AEntity: IProductEntity; AId: Int64): Either<string,Boolean>;
var
  lErrors: String;
begin
  // Validar e Atualizar
  lErrors := TProductValidator.Make(AEntity, TEntityState.esUpdate).Execute;
  case lErrors.Trim.IsEmpty of
    True:  Result := FService.Update(AEntity, AId);
    False: Result := lErrors;
  end;
end;
end.
