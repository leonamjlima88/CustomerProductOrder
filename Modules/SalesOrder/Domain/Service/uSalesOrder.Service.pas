unit uSalesOrder.Service;

interface

uses
  uSalesOrder.Service.Interfaces,
  uSalesOrder.Entity.Interfaces,
  uSalesOrder.Repository.Interfaces,
  System.Generics.Collections,
  uIndexResult,
  uPageFilter;

type
  TSalesOrderService = class(TInterfacedObject, ISalesOrderService)
  private
    FRepository: ISalesOrderRepository;
    constructor Create(ARepository: ISalesOrderRepository);
  public
    class function Make(ARepository: ISalesOrderRepository): ISalesOrderService;
    function Delete(AId: Int64): Boolean;
    function Index: TList<ISalesOrderEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ISalesOrderEntity;
    function Store(AEntity: ISalesOrderEntity): Int64;
    function Update(AEntity: ISalesOrderEntity; AId: Int64): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TSalesOrderService }

constructor TSalesOrderService.Create(ARepository: ISalesOrderRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TSalesOrderService.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TSalesOrderService.Index(APageFilter: IPageFilter): IIndexResult;
begin
  Result := FRepository.Index(APageFilter);
end;

function TSalesOrderService.Index: TList<ISalesOrderEntity>;
begin
  Result := FRepository.Index;
end;

class function TSalesOrderService.Make(ARepository: ISalesOrderRepository): ISalesOrderService;
begin
  Result := Self.Create(ARepository);
end;

function TSalesOrderService.Show(AId: Int64): ISalesOrderEntity;
begin
  Result := FRepository.Show(AId);
end;

function TSalesOrderService.Store(AEntity: ISalesOrderEntity): Int64;
begin
  AEntity.created_at := now;
  Result := FRepository.Store(AEntity);
end;

function TSalesOrderService.Update(AEntity: ISalesOrderEntity; AId: Int64): Boolean;
begin
  AEntity.updated_at := now;
  Result := FRepository.Update(AEntity, AId);
end;

end.
