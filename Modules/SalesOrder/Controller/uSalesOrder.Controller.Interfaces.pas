unit uSalesOrder.Controller.Interfaces;

interface

uses
  uSalesOrder.Entity.Interfaces,
  uEither,
  System.Generics.Collections,
  uPageFilter,
  uIndexResult;

type
  ISalesOrderController = interface
    ['{44325605-F86C-4868-8D35-4C276E638E6F}']

    /// <summary> Apagar registro por ID </summary>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [Boolean] Se apagou </returns>
    function Delete(AId: Int64): Boolean;

    /// <summary> Retorna Lista de pesquisa </summary>
    /// <returns> [TList<ISalesOrderEntity] Lista </returns>
    function Index: TList<ISalesOrderEntity>; overload;

    /// <summary> Retorna Lista de pesquisa </summary>
    /// <param name="APageFilter"> [IPageFilter] Filtro de dados </param>
    /// <returns> [IIndexResult] Resultado com metadados </returns>
    function Index(APageFilter: IPageFilter): IIndexResult; overload;

    /// <summary> Localizar registro por ID </summary>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [TSalesOrderEntity/Nil] Registro encontrado/não encontrado </returns>
    function Show(AId: Int64): ISalesOrderEntity;

    /// <summary> Incluir um novo registro </summary>
    /// <param name="AEntity"> [TSalesOrderEntity] Dados para incluir </param>
    /// <returns> [Either<string, Int64>] String com erros/ID de registro salvo </returns>
    function Store(AEntity: ISalesOrderEntity): Either<string, Int64>;

    /// <summary> Atualizar registro por ID </summary>
    /// <param name="AEntity"> [TSalesOrderEntity] Dados para atualizar </param>
    /// <param name="AId"> [Int64] ID </param>
    /// <returns> [Either<string, Boolean>] String com erros/status de registro atualizado </returns>
    function Update(AEntity: ISalesOrderEntity; AId: Int64): Either<string,Boolean>;
  end;

implementation

end.
