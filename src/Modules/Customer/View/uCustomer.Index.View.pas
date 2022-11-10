unit uCustomer.Index.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase.Index.View, Data.DB,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uMemTable.Interfaces;

type
  TCustomerIndexView = class(TBaseIndexView)
    tmrDoSearch: TTimer;
    pnlLocate: TPanel;
    imgLocateAppend: TImage;
    imgLocateEdit: TImage;
    lblLocateAppend: TLabel;
    lblLocateEdit: TLabel;
    pnlSave: TPanel;
    pnlSave2: TPanel;
    btnLocateConfirm: TSpeedButton;
    pnlSave3: TPanel;
    imgSave: TImage;
    pnlCancel: TPanel;
    pnlCancel2: TPanel;
    btnLocateClose: TSpeedButton;
    pnlCancel3: TPanel;
    imgCancel4: TImage;
    procedure FormCreate(Sender: TObject); override;
    procedure edtSearchValueChange(Sender: TObject);
    procedure edtSearchValueDblClick(Sender: TObject);
    procedure edtSearchValueKeyPress(Sender: TObject; var Key: Char);
    procedure tmrDoSearchTimer(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mtbIndexAfterOpen(DataSet: TDataSet);
    procedure imgDoSearchClick(Sender: TObject);
    procedure imgSearchClearClick(Sender: TObject);
    procedure btnNavIndexClick(Sender: TObject);
    procedure edtNavLimitPerPageExit(Sender: TObject);
    procedure btnLocateCloseClick(Sender: TObject);
    procedure btnLocateConfirmClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnAppendClick(Sender: TObject);
  private
    FMtbIndex: IMemTable;
    FLayoutLocate: Boolean;
    FLocateResult: Integer;
    FLoadingDoSearch: Boolean;
    procedure SetLocateResult(const Value: Integer);
    procedure CleanFilter;
    procedure DoSearch(ACurrentPage: Integer = 1);
    procedure SetLayoutLocate;
    property LocateResult: Integer read FLocateResult write SetLocateResult;
  public
    class function ShowModalLocate: integer;
  end;

var
  CustomerIndexView: TCustomerIndexView;

implementation

uses
  uPageFilter,
  uIndexResult,
  uHlp,
  uMemTable.Factory,
  uCustomer.Controller,
  uSession.DTM,
  uCustomer.CreateUpdate.View,
  uNotificationView,
  uYesOrNo.View,
  uAlert.View,
  uConnection.Types,
  uThreadCustom;

{$R *.dfm}

procedure TCustomerIndexView.btnAppendClick(Sender: TObject);
var
  lStoredId: Integer;
begin
  inherited;

  if not pnlAppend.Enabled then Exit;
  Try
    pnlAppend.Enabled := False;
    DBGrid1.Enabled   := False;

    // Incluir Novo Registro
    lStoredId := TCustomerCreateUpdateView.HandleNewRecord;
    if (lStoredId <= 0) then Exit;

    // Atualizar Listagem
    DoSearch;
  Finally
    pnlAppend.Enabled := true;
    DBGrid1.Enabled := True;
    if edtSearchValue.CanFocus then edtSearchValue.SetFocus;
  End;
end;

procedure TCustomerIndexView.btnDeleteClick(Sender: TObject);
begin
  if not Assigned(dtsIndex.DataSet) then Exit;
  if not dtsIndex.DataSet.Active then Exit;
  if not (dtsIndex.DataSet.RecordCount > 0) then Exit;

  // Mensagem de Sim/Não
  if not (TYesOrNoView.AShowModal('Deseja apagar item selecionado?', 'Exclusão') = mrOK) then
    Exit;

  Try
    pnlBackground.Enabled := False;
    if not TCustomerController.Make.Delete(dtsIndex.DataSet.FieldByName('id').AsInteger) then
    begin
      TAlertView.AShowModal('Erro ao tentar apagar registro: ' + dtsIndex.DataSet.FieldByName('id').AsString);
      Exit;
    end;

    dtsIndex.DataSet.Delete;
    NotificationView.Execute('Registro deletado com sucesso.', tneError);
  Finally
    pnlBackground.Enabled := True;
    if edtSearchValue.CanFocus then edtSearchValue.SetFocus;
  End;
end;

procedure TCustomerIndexView.btnEditClick(Sender: TObject);
begin
  // Evitar erros
  if not Assigned(dtsIndex.DataSet) then Exit;
  if not dtsIndex.DataSet.Active then Exit;
  if not (dtsIndex.DataSet.RecordCount > 0) then Exit;
  if (dtsIndex.DataSet.FieldByName('id').AsInteger <= 0) then Exit;

  Try
    pnlBackground.Enabled := False;

    // Editar Registro
    if not TCustomerCreateUpdateView.HandleEditRecord(dtsIndex.DataSet.FieldByName('id').AsInteger) then
      Exit;

    // Atualizar Listagem
    DoSearch;
  Finally
    pnlBackground.Enabled := True;
    if edtSearchValue.CanFocus then
      edtSearchValue.SetFocus;
  End;
end;

procedure TCustomerIndexView.btnLocateCloseClick(Sender: TObject);
begin
  inherited;
  FLocateResult := -1;
  ModalResult   := MrCancel;
end;

procedure TCustomerIndexView.btnLocateConfirmClick(Sender: TObject);
begin
  inherited;

  if ((FLayoutLocate) and
  Assigned(dtsIndex.DataSet) and
  dtsIndex.DataSet.Active and
  (dtsIndex.DataSet.RecordCount > 0)) Then
  begin
    FLocateResult := dtsIndex.DataSet.Fields[0].AsInteger;
    ModalResult   := mrOK;
  end;
end;

procedure TCustomerIndexView.btnNavIndexClick(Sender: TObject);
begin
  inherited;

  // Primeira página
  if (Sender = btnNavFirst) then
  begin
    DoSearch;
    Exit;
  end;

  // Voltar página
  if (Sender = btnNavPrior) then
  begin
    DoSearch(THlp.StrInt(edtNavCurrentPage.Text)-1);
    Exit;
  end;

  // Próxima Página
  if (Sender = btnNavNext) then
  begin
    DoSearch(THlp.StrInt(edtNavCurrentPage.Text)+1);
    Exit;
  end;

  // Última página
  if (Sender = btnNavLast) then
  begin
    DoSearch(THlp.StrInt(edtNavLastPageNumber.Text));
    Exit;
  end;
end;

procedure TCustomerIndexView.btnViewClick(Sender: TObject);
begin
  // Evitar erros
  if not Assigned(dtsIndex.DataSet) then Exit;
  if not dtsIndex.DataSet.Active then Exit;
  if not (dtsIndex.DataSet.RecordCount > 0) then Exit;
  if (dtsIndex.DataSet.FieldByName('id').AsInteger <= 0) then Exit;

  // Visualizar Registro
  TCustomerCreateUpdateView.HandleEditRecord(dtsIndex.DataSet.FieldByName('id').AsInteger, esNone);
end;

procedure TCustomerIndexView.CleanFilter;
begin
  // Limite de Registros p/ Página
  edtNavLimitPerPage.Text := '50';

  // Limpar Input de Pesquisa sem Fazer Refresh
  edtSearchValue.OnChange := nil;
  edtSearchValue.Clear;
  edtSearchValue.OnChange := edtSearchValueChange;
end;

procedure TCustomerIndexView.DBGrid1CellClick(Column: TColumn);
begin
  inherited;

  // Evitar erros
  if not Assigned(dtsIndex.DataSet) then Exit;
  if not dtsIndex.DataSet.Active then Exit;
  if (dtsIndex.DataSet.RecordCount = 0) then Exit;
  if (dgRowSelect in DBGrid1.Options) then Abort;

  // Editar
  if (AnsiLowerCase(Column.FieldName) = 'editar') then
    btnEditClick(DBGrid1);

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'deletar') then
    btnDeleteClick(DBGrid1);

  // Visualizar
  if (AnsiLowerCase(Column.FieldName) = 'visualizar') then
    btnViewClick(DBGrid1);
end;

procedure TCustomerIndexView.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  case FLayoutLocate of
    False: btnEditClick(DBGrid1);
    True:  btnLocateConfirmClick(Sender);
  end;
end;

procedure TCustomerIndexView.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
Var
  lI: Integer;
begin
  inherited;
  if not Assigned(dtsIndex.DataSet)         then Exit;
  if not (dtsIndex.DataSet.Active)          then Exit;
  if not (dtsIndex.DataSet.RecordCount > 0) then Exit;

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

  // Exibir imagem de Visualizar
  if (AnsiLowerCase(Column.FieldName) = 'visualizar') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    SessionDTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 2);
  end;
end;

procedure TCustomerIndexView.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Bloquear Ctrl + Del
  if (ssCtrl in Shift) and (Key = VK_DELETE) then
    Key := 0;

  // Focus em pesquisa
  If (Shift = [ssShift]) and (key = VK_TAB) then
  Begin
    if edtSearchValue.CanFocus then
      edtSearchValue.SetFocus;
    Key := 0;
  End;

  // Quando Enter Pressionado Editar
  if (Key = VK_RETURN) Then
  Begin
    case FLayoutLocate of
      False: btnEditClick(Sender);
      True:  btnLocateConfirmClick(Sender);
    end;
    Key := 0;
  End;
end;

procedure TCustomerIndexView.DoSearch(ACurrentPage: Integer);
var
  lIndexResult: IIndexResult;
  lPageFilter: IPageFilter;
begin
  // Filtragem dos dados
  Try
    dtsIndex.DataSet        := nil;
    DBGrid1.Enabled         := False;
    pnlNavigator.Enabled    := False;
    edtSearchValue.OnChange := nil;

    // Filtro de Pesquisa
    lPageFilter := TPageFilter.Make
      .CurrentPage  (ACurrentPage)
      .LimitPerPage (THlp.StrInt(edtNavLimitPerPage.Text))
      .OrderBy      ('customer.name')
      .AddOrWhere   ('customer.id',    coEqual,        String(edtSearchValue.Text).trim)
      .AddOrWhere   ('customer.name',  coLikeAnywhere, String(edtSearchValue.Text).trim)
      .AddOrWhere   ('customer.city',  coLikeAnywhere, String(edtSearchValue.Text).trim)
      .AddOrWhere   ('customer.state', coEqual,        String(edtSearchValue.Text).trim);

    // Efetuar Pesquisa
    lIndexResult := TCustomerController.Make.Index(lPageFilter);
    FMtbIndex.FromDataSet(lIndexResult.Data.DataSet);

    // Resultado
    dtsIndex.DataSet          := FMtbIndex.DataSet;
    DBGrid1.DataSource        := dtsIndex;
    edtNavCurrentPage.Text    := lIndexResult.CurrentPage.ToString;
    edtNavLimitPerPage.Text   := lIndexResult.LimitPerPage.ToString;
    btnNavPrior.Enabled       := lIndexResult.NavPrior;
    btnNavNext.Enabled        := lIndexResult.NavNext;
    btnNavFirst.Enabled       := lIndexResult.NavFirst;
    btnNavLast.Enabled        := lIndexResult.NavLast;
    edtNavLastPageNumber.Text := lIndexResult.LastPageNumber.ToString;
    lblNavShowingRecords.Caption :=
      'Exibindo '     + lIndexResult.CurrentPageRecordCount.ToString +
      ' registro de ' + lIndexResult.AllPagesRecordCount.ToString + '.';

  Finally
    DBGrid1.Enabled         := True;
    pnlNavigator.Enabled    := True;
    edtSearchValue.OnChange := edtSearchValueChange;
    if not DBGrid1.Visible then
      DBGrid1.Visible := True
  End;
end;

procedure TCustomerIndexView.edtNavLimitPerPageExit(Sender: TObject);
begin
  inherited;
  DoSearch;
end;

procedure TCustomerIndexView.edtSearchValueChange(Sender: TObject);
begin
  inherited;
  if tmrDoSearch.Enabled then
    tmrDoSearch.Enabled := False;

  tmrDoSearch.Enabled := True;
end;

procedure TCustomerIndexView.edtSearchValueDblClick(Sender: TObject);
begin
  inherited;
  edtSearchValue.Clear;
end;

procedure TCustomerIndexView.edtSearchValueKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  If (Key = #13) Then
  Begin
    tmrDoSearch.Enabled := False;
    DoSearch;
    if DBGrid1.CanFocus then DBGrid1.SetFocus;
    DBGrid1.SelectedIndex := 3;
    Exit;
  End;
end;

procedure TCustomerIndexView.mtbIndexAfterOpen(DataSet: TDataSet);
begin
  THlp.FormatDataSet(DataSet);
end;

procedure TCustomerIndexView.SetLayoutLocate;
var
  lI: Integer;
begin
  FLayoutLocate      := true;
  pnlNavigator.Align := alNone;
  pnlLocate.Visible  := true;
  pnlLocate.Align    := alNone;
  pnlLocate.Align    := alBottom;
  pnlNavigator.Align := alBottom;

  lblTitle.Caption           := 'Pesquisando... Clientes';
  pnlAppend.Width            := 0;
  Self.BorderStyle           := bsNone;
  pnlBackground.BorderWidth  := 1;
  pnlBackground.Color        := $00857950;
  Thlp.createTransparentBackground(Self);

  // Varrer dbgrid e esconder botoes
  for lI := 0 to DBGrid1.Columns.Count-1 do
    if (AnsiLowerCase(DBGrid1.Columns[lI].FieldName) = 'editar') or
    (AnsiLowerCase(DBGrid1.Columns[lI].FieldName) = 'deletar') or
    (AnsiLowerCase(DBGrid1.Columns[lI].FieldName) = 'visualizar') Then
      DBGrid1.Columns[lI].Visible := False;
end;

procedure TCustomerIndexView.SetLocateResult(const Value: Integer);
begin
  FLocateResult := Value;
end;

class function TCustomerIndexView.ShowModalLocate: integer;
var
  lView: TCustomerIndexView;
begin
  Try
    lView := TCustomerIndexView.Create(nil);
    lView.SetLayoutLocate;
    case (lView.ShowModal = mrOK) of
      True:  Result := lView.LocateResult;
      False: Result := -1;
    end;
  Finally
    if Assigned(lView) then
      FreeAndNil(lView);
  End;
end;

procedure TCustomerIndexView.FormCreate(Sender: TObject);
begin
  inherited;

  FMtbIndex                   := TMemTableFactory.Make;
  FMtbIndex.DataSet.AfterOpen := mtbIndexAfterOpen;
  CleanFilter;
end;

procedure TCustomerIndexView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // INS - Novo Registro
  if (Key = VK_INSERT) then
  begin
    btnAppendClick(btnAppend);
    Exit;
  end;

  // F5 - Atualizar e setar focus em pesquisa
  if (Key = VK_F5) then
  begin
    DoSearch;
    if edtSearchValue.CanFocus then edtSearchValue.SelectAll;
    Exit;
  end;

  // Esc - Fechar Modal quando estiver pesquisando
  if (Key = VK_ESCAPE) and FLayoutLocate then
  begin
    btnLocateCloseClick(btnLocateClose);
    Exit;
  end;
end;

procedure TCustomerIndexView.imgDoSearchClick(Sender: TObject);
begin
  inherited;
  DoSearch;
end;

procedure TCustomerIndexView.imgSearchClearClick(Sender: TObject);
begin
  inherited;
  CleanFilter;
  DoSearch;
end;

procedure TCustomerIndexView.tmrDoSearchTimer(Sender: TObject);
begin
  inherited;
  tmrDoSearch.Enabled := False;
  DoSearch;
end;

end.
