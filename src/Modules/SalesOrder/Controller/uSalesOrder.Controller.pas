unit uSalesOrder.Controller;

interface

uses
  uSalesOrder.Controller.Interfaces,
  uSalesOrder.Entity.Interfaces,
  uSalesOrder.Service.Interfaces,
  uEither,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  TSalesOrderController = class(TInterfacedObject, ISalesOrderController)
  private
    FService: ISalesOrderService;
    constructor Create(APoolConn: Boolean);
  public
    class function Make(APoolConn: Boolean = False): ISalesOrderController;

    function Delete(AId: Int64): Boolean;
    function Index: TList<ISalesOrderEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ISalesOrderEntity;
    function Store(AEntity: ISalesOrderEntity): Either<string, Int64>;
    function Update(AEntity: ISalesOrderEntity; AId: Int64): Either<string,Boolean>;
  end;

implementation

uses
  uSalesOrder.Service,
  uSalesOrder.Repository.Factory,
  uSalesOrder.Validator,
  uConnection.Types,
  System.SysUtils;

{ TSalesOrderController }

constructor TSalesOrderController.Create(APoolConn: Boolean);
begin
  inherited Create;
  FService := TSalesOrderService.Make(TSalesOrderRepositoryFactory.Make(APoolConn));
end;

function TSalesOrderController.Delete(AId: Int64): Boolean;
begin
  Result := FService.Delete(AId);
end;

function TSalesOrderController.Index(APageFilter: IPageFilter): IIndexResult;
begin
  Result := FService.Index(APageFilter);
end;

function TSalesOrderController.Index: TList<ISalesOrderEntity>;
begin
  Result := FService.Index;
end;

class function TSalesOrderController.Make(APoolConn: Boolean): ISalesOrderController;
begin
  Result := Self.Create(APoolConn);
end;

function TSalesOrderController.Show(AId: Int64): ISalesOrderEntity;
begin
  Result := FService.Show(AId);
end;

function TSalesOrderController.Store(AEntity: ISalesOrderEntity): Either<string, Int64>;
var
  lErrors: String;
begin
  // Validar e Inserir
  lErrors := TSalesOrderValidator.Make(AEntity, TEntityState.esStore).Execute;
  case lErrors.Trim.IsEmpty of
    True:  Result := FService.Store(AEntity);
    False: Result := lErrors;
  end;
end;

function TSalesOrderController.Update(AEntity: ISalesOrderEntity; AId: Int64): Either<string,Boolean>;
var
  lErrors: String;
begin
  // Validar e Atualizar
  lErrors := TSalesOrderValidator.Make(AEntity, TEntityState.esUpdate).Execute;
  case lErrors.Trim.IsEmpty of
    True:  Result := FService.Update(AEntity, AId);
    False: Result := lErrors;
  end;
end;
end.
