unit uCustomer.Controller.Interfaces;

interface

uses
  uCustomer.Entity.Interfaces,
  uEither,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  ICustomerController = interface
    ['{D5B31915-D0CB-48FB-8131-A82277C6C9E7}']

    /// <summary> Apagar registro por ID </summary>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [Boolean] Se apagou </returns>
    function Delete(AId: Int64): Boolean;

    /// <summary> Retorna Lista de pesquisa </summary>
    /// <returns> [TList<ICustomerEntity] Lista </returns>
    function Index: TList<ICustomerEntity>; overload;

    /// <summary> Retorna Lista de pesquisa </summary>
    /// <param name="APageFilter"> [IPageFilter] Filtro de dados </param>
    /// <returns> [IIndexResult] Resultado com metadados </returns>
    function Index(APageFilter: IPageFilter): IIndexResult; overload;

    /// <summary> Localizar registro por ID </summary>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [TCustomerEntity/Nil] Registro encontrado/não encontrado </returns>
    function Show(AId: Int64): ICustomerEntity;

    /// <summary> Incluir um novo registro </summary>
    /// <param name="AEntity"> [TCustomerEntity] Dados para incluir </param>
    /// <returns> [Either<string, Int64>] String com erros/ID de registro salvo </returns>
    function Store(AEntity: ICustomerEntity): Either<string, Int64>;

    /// <summary> Atualizar registro por ID </summary>
    /// <param name="AEntity"> [TCustomerEntity] Dados para atualizar </param>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [Either<string, Boolean>] String com erros/status de registro atualizado </returns>
    function Update(AEntity: ICustomerEntity; AId: Int64): Either<string,Boolean>;
  end;

implementation

end.
