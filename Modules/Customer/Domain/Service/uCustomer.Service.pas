unit uCustomer.Service;

interface

uses
  uCustomer.Service.Interfaces,
  uCustomer.Entity.Interfaces,
  uCustomer.Repository.Interfaces,
  System.Generics.Collections,
  uIndexResult,
  uPageFilter;

type
  TCustomerService = class(TInterfacedObject, ICustomerService)
  private
    FRepository: ICustomerRepository;
    constructor Create(ARepository: ICustomerRepository);
  public
    class function Make(ARepository: ICustomerRepository): ICustomerService;
    function Delete(AId: Int64): Boolean;
    function Index: TList<ICustomerEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ICustomerEntity;
    function Store(AEntity: ICustomerEntity): Int64;
    function Update(AEntity: ICustomerEntity; AId: Int64): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TCustomerService }

constructor TCustomerService.Create(ARepository: ICustomerRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TCustomerService.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TCustomerService.Index(APageFilter: IPageFilter): IIndexResult;
begin
  Result := FRepository.Index(APageFilter);
end;

function TCustomerService.Index: TList<ICustomerEntity>;
begin
  Result := FRepository.Index;
end;

class function TCustomerService.Make(ARepository: ICustomerRepository): ICustomerService;
begin
  Result := Self.Create(ARepository);
end;

function TCustomerService.Show(AId: Int64): ICustomerEntity;
begin
  Result := FRepository.Show(AId);
end;

function TCustomerService.Store(AEntity: ICustomerEntity): Int64;
begin
  AEntity.created_at := now;
  Result := FRepository.Store(AEntity);
end;

function TCustomerService.Update(AEntity: ICustomerEntity; AId: Int64): Boolean;
begin
  AEntity.updated_at := now;
  Result := FRepository.Update(AEntity, AId);
end;

end.
