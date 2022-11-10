unit uSalesOrder.CreateUpdate.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, uSalesOrder.ViewModel.Interfaces, uBase.CreateUpdate.View, Data.DB,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids,

  uConnection.Types;

type
  TSalesOrderCreateUpdateView = class(TBaseCreateUpdateView)
    dtsSalesOrder: TDataSource;
    Label22: TLabel;
    Panel5: TPanel;
    Label35: TLabel;
    edtId: TDBEdit;
    Label5: TLabel;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label23: TLabel;
    edtcustomer_id: TDBEdit;
    Panel123: TPanel;
    Panel12: TPanel;
    imgLocaCustomer: TImage;
    edtcustomer_name: TDBEdit;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    edtSelectedProductId: TEdit;
    Label4: TLabel;
    edtSelectedProductQuantity: TEdit;
    Label6: TLabel;
    edtSelectedProductUnitPrice: TEdit;
    Label7: TLabel;
    edtSelectedProductAmount: TEdit;
    Panel2: TPanel;
    pnlSelectedProductSubmit: TPanel;
    btnSelectedProductSubmit: TSpeedButton;
    pnlLocaCodProd: TPanel;
    Panel6: TPanel;
    imgLocaProduct: TImage;
    edtSelectedProductName: TEdit;
    dbgSalesOrderProduct: TDBGrid;
    dtsSalesOrderProduct: TDataSource;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgLocaCustomerClick(Sender: TObject);
    procedure imgLocaProductClick(Sender: TObject);
    procedure edtFieldExit(Sender: TObject); override;
    procedure edtSelectedProductAmountKeyPress(Sender: TObject; var Key: Char);
    procedure btnSelectedProductSubmitClick(Sender: TObject);
    procedure btnSelectedProductSetModifyClick(Sender: TObject);
    procedure btnSelectedProductApplyModifyClick(Sender: TObject);
    procedure btnSelectedProductCancelModifyClick(Sender: TObject);
    procedure btnSelectedProductDeleteClick(Sender: TObject);
    procedure dbgSalesOrderProductKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgSalesOrderProductDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgSalesOrderProductCellClick(Column: TColumn);
  private
    FCurrentPk: Int64;
    FStateFormEnum: TEntityState;
    FViewModel: ISalesOrderViewModel;
    FFormReadOnly: Boolean;
    FIsChangingProductData: Boolean;
    FLoadingSumSalesOrderProduct: Boolean;
    procedure SetIsChangingProductData(const Value: Boolean);
    property IsChangingProductData: Boolean read FIsChangingProductData write SetIsChangingProductData;
    procedure ClearProductSelectedFields;
    function BeforeShow: TSalesOrderCreateUpdateView;
    procedure SumSalesOrderProduct;
    function KeepGoingToHandleSalesOrderProduct: Boolean;
  public
    class function HandleEditRecord(AEditPk: Int64; AStateFormEnum: TEntityState = esUpdate): Boolean;
    class function HandleNewRecord: Int64;
  end;

const
  TITLE_NAME = 'Pedido de Venda';

implementation

{$R *.dfm}

uses
  uSalesOrder.Entity,
  uNotificationView,
  uSalesOrder.Controller,
  uSalesOrder.Mapper,
  uHlp,
  uSalesOrder.Controller.Interfaces,
  uEither,
  uAlert.View,
  uSalesOrder.ViewModel,
  uSalesOrder.Entity.Interfaces,
  uCustomer.Index.View,
  uProduct.Controller,
  uProduct.Entity.Interfaces,
  uProduct.Index.View,
  uYesOrNo.View,
  uSession.DTM,
  uMemTable.Factory,
  uMemTable.Interfaces,
  Vcl.Dialogs,
  uThreadCustom,
  Vcl.Forms;

{ TSalesOrderCreateUpdateView }

function TSalesOrderCreateUpdateView.BeforeShow: TSalesOrderCreateUpdateView;
var
  lEntity: ISalesOrderEntity;
begin
  Result := Self;
  pgc.ActivePageIndex := 0;

  // Iniciar Loading
  LoadingForm           := True;
  pnlBackground.Enabled := False;
  pgc.Visible           := False;

  TThreadCustom.Start(
    // OnShow
    procedure
    begin
      // Alterar layout dependendo da operação
      case FStateFormEnum of
        // Inserir
        esStore: Begin
          lblTitle.Caption := TITLE_NAME + ' (Incluindo...)';
          dtsSalesOrder.DataSet.Append;
        End;
        // Editar
        esUpdate: Begin
          lblTitle.Caption := TITLE_NAME + ' (Editando...)';
        End;
        // Visualizar
        esNone: Begin
          lblTitle.Caption := TITLE_NAME + ' (Visualizando...)';
          pnlSave.Visible  := False;
        End;
      end;
    end,

    // OnProcess
    procedure
    begin
      if (FStateFormEnum in [esUpdate, esNone]) then
        lEntity := TSalesOrderController.Make(True).Show(FCurrentPk);
    end,

    // OnComplete
    procedure
    begin
      // Encerrar Loading
      LoadingForm           := false;
      pnlBackground.Enabled := True;
      pgc.Visible           := True;

      if (FStateFormEnum in [esUpdate, esNone]) then
      begin
        TSalesOrderMapper.EntityToDataSet(lEntity, dtsSalesOrder.DataSet, dtsSalesOrderProduct.DataSet);
        dtsSalesOrder.DataSet.Edit;
      end;
      if edtcustomer_id.CanFocus then
        edtcustomer_id.SetFocus;
    end,

    // OnError
    procedure(const AValue: string)
    begin
      pnlSave.Visible := False;
      MessageDlg('Oops... Ocorreu um erro!' + #13 + AValue, mtWarning, [mbOK], 0);
    end,

    // CompleteWithError?
    true
  );
end;

procedure TSalesOrderCreateUpdateView.btnCancelClick(Sender: TObject);
begin
  if not (TYesOrNoView.AShowModal('Deseja cancelar operação') = mrOk) then
    Abort;

  FCurrentPk  := -1;
  ModalResult := MrCancel;
end;

procedure TSalesOrderCreateUpdateView.btnSaveClick(Sender: TObject);
var
  lEntityToSave: ISalesOrderEntity;
  lMsgNotification: String;
  lTypeNotification: TTypeNotificationEnum;
  lError: String;
begin
  // Não prosseguir se estiver carregando
  if LoadingSave or LoadingForm then
    Exit;

  // Iniciar Loading
  LoadingSave := True;
  LoadingForm := True;
  pnlBackground.Enabled := False;

  TThreadCustom.Start(
    // OnShow
    procedure
    begin
      if (dtsSalesOrder.DataSet.State in [dsInsert, dsEdit]) then
        dtsSalesOrder.DataSet.Post;

      lEntityToSave := TSalesOrderEntity.Create;
      TSalesOrderMapper.DataSetToEntity(dtsSalesOrder.DataSet, dtsSalesOrderProduct.DataSet, lEntityToSave);
    end,

    // OnProcess
    procedure
    var
      lCtrl: ISalesOrderController;
      lStoreResult: Either<string, Int64>;
      lUpdateResult: Either<string, Boolean>;
    begin
      lCtrl := TSalesOrderController.Make(True);

      // Incluir
      if (FStateFormEnum = esStore) then
      begin
        lStoreResult := lCtrl.Store(lEntityToSave);
        if lStoreResult.Match then
        begin
          FCurrentPk        := lStoreResult.Right;
          lMsgNotification  := 'Registro salvo com sucesso.';
          lTypeNotification := tneSuccess;
        end else
          lError := lStoreResult.Left;
      end;

      // Alterar
      if (FStateFormEnum = esUpdate) then
      begin
        lUpdateResult := lCtrl.Update(lEntityToSave, FCurrentPk);
        if lUpdateResult.Match then
        begin
          lMsgNotification  := 'Registro alterado com sucesso.';
          lTypeNotification := tneWarning;
        end else
          lError := lUpdateResult.Left;
      end;
    end,

    // OnComplete
    procedure
    begin
      // Encerrar Loading
      LoadingSave := False;
      LoadingForm := False;
      pnlBackground.Enabled := True;

      // Verificar se ocorreu algum erro
      if not lError.Trim.IsEmpty then
      Begin
        TAlertView.AShowModal(lError);
        dtsSalesOrder.DataSet.Edit;
        Abort;
      End;
      NotificationView.Execute(lMsgNotification, lTypeNotification);
      ModalResult := mrOk;
    end,

    // OnError
    procedure(const AValue: string)
    begin
      MessageDlg('Oops... Ocorreu um erro!' + #13 + AValue, mtWarning, [mbOK], 0);
    end,

    // CompleteWithError?
    true
  );
end;

procedure TSalesOrderCreateUpdateView.btnSelectedProductCancelModifyClick(Sender: TObject);
begin
  ClearProductSelectedFields;
  IsChangingProductData := False;
  NotificationView.Execute('Alteração do Produto abortada.', tneInfo);
  if edtSelectedProductId.CanFocus then
    edtSelectedProductId.SetFocus;
end;

procedure TSalesOrderCreateUpdateView.btnSelectedProductDeleteClick(Sender: TObject);
begin
  if not KeepGoingToHandleSalesOrderProduct then
    Exit;

  // Mensagem de Sim/Não
  if not (TYesOrNoView.AShowModal('Deseja apagar item selecionado?', 'Exclusão') = mrOK) then
    Exit;

  dtsSalesOrderProduct.DataSet.Delete;
  NotificationView.Execute('Registro apagado!', tneWarning);
  if dbgSalesOrderProduct.CanFocus then
    dbgSalesOrderProduct.SetFocus;
end;

procedure TSalesOrderCreateUpdateView.btnSelectedProductApplyModifyClick(Sender: TObject);
var
  lError: String;
begin
  Try
    pnlBackground.Enabled := False;

    // Validar Campos antes de lançar
    lError := EmptyStr;
    if (THlp.StrFloat(edtSelectedProductQuantity.Text) <= 0)  then lError := lError + '  Quantidade para produto não informado!' + #13;
    if (THlp.StrFloat(edtSelectedProductUnitPrice.Text) <= 0) then lError := lError + '  Valor unitário para produto não informado!' + #13;
    if not lError.Trim.IsEmpty then
    begin
      TAlertView.AShowModal('No lançamento do produto' + #13 + lError);
      Abort;
    end;

    With dtsSalesOrderProduct.DataSet do
    begin
      Edit;
      FieldByName('quantity').AsFloat   := THlp.StrFloat(edtSelectedProductQuantity.Text);
      FieldByName('unit_price').AsFloat := THlp.StrFloat(edtSelectedProductUnitPrice.Text);
      Post;
      SumSalesOrderProduct;
    end;
    IsChangingProductData := False;
    ClearProductSelectedFields;
    NotificationView.Execute('Produto alterado com sucesso', tneWarning);
  finally
    pnlBackground.Enabled := True;
    if edtSelectedProductId.CanFocus then
      edtSelectedProductId.SetFocus;
  end;
end;

procedure TSalesOrderCreateUpdateView.btnSelectedProductSetModifyClick(Sender: TObject);
begin
  if not KeepGoingToHandleSalesOrderProduct then
    Exit;

  edtSelectedProductId.Text        := dtsSalesOrderProduct.DataSet.FieldByName('product_id').AsString;
  edtSelectedProductName.Text      := dtsSalesOrderProduct.DataSet.FieldByName('product_name').AsString;
  edtSelectedProductQuantity.Text  := FormatFloat('#,####,##0.00', dtsSalesOrderProduct.DataSet.FieldByName('quantity').AsFloat);
  edtSelectedProductUnitPrice.Text := FormatFloat('#,####,##0.00', dtsSalesOrderProduct.DataSet.FieldByName('unit_price').AsFloat);
  edtSelectedProductAmount.Text    := FormatFloat('#,####,##0.00', dtsSalesOrderProduct.DataSet.FieldByName('amount').AsFloat);
  if edtSelectedProductQuantity.CanFocus then
    edtSelectedProductQuantity.SetFocus;
  IsChangingProductData := true;
end;

procedure TSalesOrderCreateUpdateView.btnSelectedProductSubmitClick(Sender: TObject);
var
  lPk: Int64;
  lProductEntity: IProductEntity;
  lError: String;
begin
  inherited;

  // Validar Campos antes de lançar
  lPk := THlp.StrInt(edtSelectedProductId.Text);
  lError := EmptyStr;
  if (lPk <= 0)                                             then lError := lError + '  Cód. do Produto não informado!' + #13;
  if (THlp.StrFloat(edtSelectedProductQuantity.Text) <= 0)  then lError := lError + '  Quantidade para produto não informado!' + #13;
  if (THlp.StrFloat(edtSelectedProductUnitPrice.Text) <= 0) then lError := lError + '  Valor unitário para produto não informado!' + #13;
  if not lError.Trim.IsEmpty then
  begin
    TAlertView.AShowModal('No lançamento do produto' + #13 + lError);
    Abort;
  end;

  try
    pnlBackground.Enabled := False;

    // Localizar produto novamente antes de lançar (Evita erro por parte do usuário)
    lProductEntity := TProductController.Make.Show(lPk);
    if not Assigned(lProductEntity) then
    begin
      NotificationView.Execute('Produto não encontrado. Cód: "' + lPk.ToString+'"', tneError);
      Exit;
    end;

    // Lançar produto
    With dtsSalesOrderProduct.DataSet do
    begin
      Append;
      FieldByName('product_id').AsLargeInt := lProductEntity.id;
      FieldByName('product_name').AsString := lProductEntity.name;
      FieldByName('quantity').AsFloat      := THlp.StrFloat(edtSelectedProductQuantity.Text);
      FieldByName('unit_price').AsFloat    := THlp.StrFloat(edtSelectedProductUnitPrice.Text);
      Post;
      SumSalesOrderProduct;
    end;
  finally
    pnlBackground.Enabled := True;
    ClearProductSelectedFields;
    if edtSelectedProductId.CanFocus then
    begin
      edtSelectedProductId.SetFocus;
      edtSelectedProductId.SelectAll;
    end;
  end;
end;

procedure TSalesOrderCreateUpdateView.ClearProductSelectedFields;
begin
  edtSelectedProductId.Clear;
  edtSelectedProductQuantity.Text  := '0,00';
  edtSelectedProductUnitPrice.Text := '0,00';
  edtSelectedProductAmount.Text    := '0,00';
  edtSelectedProductName.Clear;
end;

procedure TSalesOrderCreateUpdateView.dbgSalesOrderProductCellClick(Column: TColumn);
begin
  inherited;
  if not KeepGoingToHandleSalesOrderProduct then
    Exit;

  // Editar
  if (AnsiLowerCase(Column.FieldName) = 'editar') then
    btnSelectedProductSetModifyClick(dbgSalesOrderProduct);

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'deletar') then
    btnSelectedProductDeleteClick(dbgSalesOrderProduct);
end;

procedure TSalesOrderCreateUpdateView.dbgSalesOrderProductDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  if not KeepGoingToHandleSalesOrderProduct then
    Exit;

  // Exibir imagem de Editar
  if (AnsiLowerCase(Column.FieldName) = 'editar') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    SessionDTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 0);
  end;

  // Exibir imagem de Deletar
  if (AnsiLowerCase(Column.FieldName) = 'deletar') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    SessionDTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 1);
  end;
end;

procedure TSalesOrderCreateUpdateView.dbgSalesOrderProductKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Bloquear Ctrl+Delete
  if (ssCtrl in Shift) and (Key = VK_DELETE) then
    Key := 0;

  // Permitir apenas Delete
  if (Key = VK_DELETE) and (dbgSalesOrderProduct.Focused) then
  begin
    btnSelectedProductDeleteClick(dbgSalesOrderProduct);
    key := 0;
  end;

  // Quando Enter Pressionado Editar
  if (Key = VK_RETURN) Then
  Begin
    btnSelectedProductSetModifyClick(Sender);
    Key := 0;
  End;
end;

procedure TSalesOrderCreateUpdateView.edtFieldExit(Sender: TObject);
var
  lPk: Int64;
  lProductEntity: IProductEntity;
begin
  inherited;

  // Localizar Produto
  if (Sender = edtSelectedProductId) then
  begin
    lPk := THlp.StrInt(edtSelectedProductId.Text);
    if (lPk <= 0) then
    begin
      ClearProductSelectedFields;
      Exit;
    end;
    lProductEntity := TProductController.Make.Show(lPk);
    if not Assigned(lProductEntity) then
    begin
      ClearProductSelectedFields;
      NotificationView.Execute('Produto não encontrado. Cód: "' + lPk.ToString+'"', tneError);
      Exit;
    end;

    // Preenche campos se encontrar registro
    edtSelectedProductId.Text        := lProductEntity.id.ToString;
    edtSelectedProductName.Text      := lProductEntity.name;
    edtSelectedProductQuantity.Text  := '1,00';
    edtSelectedProductUnitPrice.Text := FormatFloat('#,###,##0.00', lProductEntity.price);
    edtSelectedProductAmount.Text    := FormatFloat('#,###,##0.00', lProductEntity.price);
    if edtSelectedProductName.CanFocus then
      edtSelectedProductName.SetFocus;
  end;

  // Calcular Total do Produto
  if ((Sender = edtSelectedProductQuantity) or (Sender = edtSelectedProductUnitPrice)) then
  begin
    edtSelectedProductQuantity.Text  := FormatFloat('#,###,##0.00', THlp.StrFloat(edtSelectedProductQuantity.Text));
    edtSelectedProductUnitPrice.Text := FormatFloat('#,###,##0.00', THlp.StrFloat(edtSelectedProductUnitPrice.Text));

    edtSelectedProductAmount.Text := FormatFloat(
      '#,###,##0.00',
      THlp.StrFloat(edtSelectedProductQuantity.Text) * THlp.StrFloat(edtSelectedProductUnitPrice.Text)
    );
  end;
end;

procedure TSalesOrderCreateUpdateView.edtSelectedProductAmountKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) then
  begin
    case FIsChangingProductData of
      True:  btnSelectedProductApplyModifyClick(Sender);
      False: btnSelectedProductSubmitClick(Sender);
    end;
  end;
end;

procedure TSalesOrderCreateUpdateView.FormCreate(Sender: TObject);
begin
  inherited;

  FViewModel                      := TSalesOrderViewModel.Make;
  dtsSalesOrder.DataSet           := FViewModel.SalesOrder.DataSet;
  dtsSalesOrderProduct.DataSet    := FViewModel.SalesOrderProduct.DataSet;
  dbgSalesOrderProduct.DataSource := dtsSalesOrderProduct;
end;

procedure TSalesOrderCreateUpdateView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Esc - Cancelar alteração do produto
  if (Key = VK_ESCAPE) and (FIsChangingProductData) then
  begin
    btnSelectedProductCancelModifyClick(Sender);
    Exit;
  end;

  // Esc - Sair
  if (Key = VK_ESCAPE) and (FIsChangingProductData = False) then
  begin
    btnCancelClick(btnCancel);
    Exit;
  end;

  // F1 - Localizar Cliente
  if (Key = VK_F1) and pnlBackground.Enabled then
  begin
    imgLocaCustomerClick(imgLocaCustomer);
    Exit;
  end;

  // F2 - Localizar produto
  if (Key = VK_F2) and pnlBackground.Enabled then
  begin
    imgLocaProductClick(imgLocaProduct);
    Exit;
  end;

  // F6 - Salvar
  if (Key = VK_F6) and pnlBackground.Enabled and pnlSave.Visible then
  begin
    btnSaveClick(btnSave);
    Exit;
  end;
end;

procedure TSalesOrderCreateUpdateView.FormShow(Sender: TObject);
begin
  inherited;

  BeforeShow;
end;

class function TSalesOrderCreateUpdateView.HandleEditRecord(AEditPk: Int64; AStateFormEnum: TEntityState): Boolean;
var
  lView: TSalesOrderCreateUpdateView;
begin
  lView := TSalesOrderCreateUpdateView.Create(nil);
  lView.FCurrentPk     := AEditPk;
  lView.FStateFormEnum := AStateFormEnum;
  Try
    Result := lView.ShowModal = mrOK;
  Finally
    if Assigned(lView) then
      FreeAndNil(lView);
  End;
end;

class function TSalesOrderCreateUpdateView.HandleNewRecord: Int64;
var
  lView: TSalesOrderCreateUpdateView;
begin
  Result := -1;
  lView := TSalesOrderCreateUpdateView.Create(nil);
  lView.FStateFormEnum := esStore;
  Try
    if (lView.ShowModal = mrOK) then
      Result := lView.FCurrentPk;
  Finally
    if Assigned(lView) then
      FreeAndNil(lView);
  End;
end;

procedure TSalesOrderCreateUpdateView.imgLocaCustomerClick(Sender: TObject);
var
  lPk: Int64;
begin
  lPk := TCustomerIndexView.ShowModalLocate;
  if (lPk > 0) then
    dtsSalesOrder.DataSet.FieldByName('customer_id').Text := lPk.ToString;
end;

procedure TSalesOrderCreateUpdateView.imgLocaProductClick(Sender: TObject);
var
  lPk: Int64;
begin
  if FIsChangingProductData then
    Exit;

  lPk := TProductIndexView.ShowModalLocate;
  if (lPk > 0) then
  begin
    edtSelectedProductId.Text       := lPk.ToString;
    EdtFieldExit(edtSelectedProductId);
  end;
end;

function TSalesOrderCreateUpdateView.KeepGoingToHandleSalesOrderProduct: Boolean;
begin
  Result := Assigned(dtsSalesOrderProduct.DataSet) and dtsSalesOrderProduct.DataSet.Active and (dtsSalesOrderProduct.DataSet.RecordCount > 0);
end;

procedure TSalesOrderCreateUpdateView.SetIsChangingProductData(const Value: Boolean);
begin
  FIsChangingProductData := Value;

  case FIsChangingProductData of
    // Alterando Produto
    True: Begin
      edtSelectedProductId.Enabled      := False;
      edtSelectedProductQuantity.Color  := $004F8A26;
      edtSelectedProductUnitPrice.Color := $004F8A26;
      pnlLocaCodProd.Enabled            := False;
      btnSelectedProductSubmit.Caption  := '> Alterar Produto';
      pnlSelectedProductSubmit.color    := $004F8A26;
      btnSelectedProductSubmit.OnClick  := btnSelectedProductApplyModifyClick;
      dbgSalesOrderProduct.Enabled      := False;
      dbgSalesOrderProduct.Color        := $00F4F4F4;
      pnlSave.Visible                   := False;
      pnlCancel.Visible                 := False;
      pnlCancel.Visible                 := False;
      imgCloseTitle.OnClick             := nil;
    end;
    False: Begin
      // Incluindo Produto
      edtSelectedProductId.Enabled      := True;
      edtSelectedProductQuantity.Color  := clWhite;
      edtSelectedProductUnitPrice.Color := clWhite;
      pnlLocaCodProd.Enabled            := True;
      btnSelectedProductSubmit.Caption  := 'Incluir Produto';
      pnlSelectedProductSubmit.color    := $00857950;
      btnSelectedProductSubmit.OnClick  := btnSelectedProductSubmitClick;
      dbgSalesOrderProduct.Enabled      := true;
      dbgSalesOrderProduct.Color        := clWhite;
      pnlSave.Visible                   := True;
      pnlCancel.Visible                 := True;
      pnlCancel.Visible                 := True;
      imgCloseTitle.OnClick             := btnCancelClick;
    end;
  end;
end;

procedure TSalesOrderCreateUpdateView.SumSalesOrderProduct;
var
  lMtb: IMemTable;
  lTotal: Double;
begin
  while FLoadingSumSalesOrderProduct do
    Application.ProcessMessages;

  FLoadingSumSalesOrderProduct := True;
  TThreadCustom.Start(
    // OnShow
    procedure
    begin
      lMtb   := TMemTableFactory.Make.FromDataSet(dtsSalesOrderProduct.DataSet);
      lTotal := 0;
    end,

    // OnProcess
    procedure
    begin
      lMtb.DataSet.First;
      while not lMtb.DataSet.Eof do
      begin
        lTotal := lTotal + lMtb.DataSet.FieldByName('amount').AsCurrency;
        lMtb.DataSet.Next;
      end;
    end,

    // OnComplete
    procedure
    var
      lKeepGoing: Boolean;
    begin
      lKeepGoing := Assigned(dtsSalesOrder.DataSet) and dtsSalesOrder.DataSet.Active and (dtsSalesOrder.State in [dsInsert, dsEdit]);
      if not lKeepGoing then Exit;
      dtsSalesOrder.DataSet.FieldByName('sum_sales_order_product_amount').AsCurrency := lTotal;
      FLoadingSumSalesOrderProduct := False;
    end,

    // OnError
    procedure(const AValue: string)
    begin
      MessageDlg('Oops... Ocorreu um erro!' + #13 + AValue, mtWarning, [mbOK], 0);
      FLoadingSumSalesOrderProduct := False;
    end,

    // CompleteWithError?
    false
  );
end;

end.
