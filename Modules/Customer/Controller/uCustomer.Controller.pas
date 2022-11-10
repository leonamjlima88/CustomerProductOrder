unit uCustomer.Controller;

interface

uses
  uCustomer.Controller.Interfaces,
  uCustomer.Entity.Interfaces,
  uCustomer.Service.Interfaces,
  uEither,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  TCustomerController = class(TInterfacedObject, ICustomerController)
  private
    FService: ICustomerService;
    constructor Create(APoolConn: Boolean);
  public
    class function Make(APoolConn: Boolean = False): ICustomerController;

    function Delete(AId: Int64): Boolean;
    function Index: TList<ICustomerEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ICustomerEntity;
    function Store(AEntity: ICustomerEntity): Either<string, Int64>;
    function Update(AEntity: ICustomerEntity; AId: Int64): Either<string,Boolean>;
  end;

implementation

uses
  uCustomer.Service,
  uCustomer.Repository.Factory,
  uCustomer.Validator,
  uConnection.Types,
  System.SysUtils;

{ TCustomerController }

constructor TCustomerController.Create(APoolConn: Boolean);
begin
  inherited Create;
  FService := TCustomerService.Make(TCustomerRepositoryFactory.Make(APoolConn));
end;

function TCustomerController.Delete(AId: Int64): Boolean;
begin
  Result := FService.Delete(AId);
end;

function TCustomerController.Index(APageFilter: IPageFilter): IIndexResult;
begin
  Result := FService.Index(APageFilter);
end;

function TCustomerController.Index: TList<ICustomerEntity>;
begin
  Result := FService.Index;
end;

class function TCustomerController.Make(APoolConn: Boolean): ICustomerController;
begin
  Result := Self.Create(APoolConn);
end;

function TCustomerController.Show(AId: Int64): ICustomerEntity;
begin
  Result := FService.Show(AId);
end;

function TCustomerController.Store(AEntity: ICustomerEntity): Either<string, Int64>;
var
  lErrors: String;
begin
  // Validar e Inserir
  lErrors := TCustomerValidator.Make(AEntity, TEntityState.esStore).Execute;
  case lErrors.Trim.IsEmpty of
    True:  Result := FService.Store(AEntity);
    False: Result := lErrors;
  end;
end;

function TCustomerController.Update(AEntity: ICustomerEntity; AId: Int64): Either<string,Boolean>;
var
  lErrors: String;
begin
  // Validar e Atualizar
  lErrors := TCustomerValidator.Make(AEntity, TEntityState.esUpdate).Execute;
  case lErrors.Trim.IsEmpty of
    True:  Result := FService.Update(AEntity, AId);
    False: Result := lErrors;
  end;
end;

end.
