unit uProduct.CreateUpdate.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, uProduct.ViewModel.Interfaces, uBase.CreateUpdate.View, Data.DB,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons,

  uConnection.Types;

type
  TProductCreateUpdateView = class(TBaseCreateUpdateView)
    dtsProduct: TDataSource;
    Label22: TLabel;
    Panel5: TPanel;
    Label35: TLabel;
    edtId: TDBEdit;
    Label3: TLabel;
    Label5: TLabel;
    edtname: TDBEdit;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FCurrentPk: Int64;
    FStateFormEnum: TEntityState;
    FViewModel: IProductViewModel;
    FFormReadOnly: Boolean;
  public
    class function HandleEditRecord(AEditPk: Int64; AStateFormEnum: TEntityState = esUpdate): Boolean;
    class function HandleNewRecord: Int64;
    function BeforeShow: TProductCreateUpdateView;
  end;

const
  TITLE_NAME = 'Produto';

implementation

{$R *.dfm}

uses
  uProduct.Entity,
  uNotificationView,
  uProduct.Controller,
  uProduct.Mapper,
  uHlp,
  uProduct.Controller.Interfaces,
  uEither,
  uAlert.View,
  uProduct.ViewModel,
  uProduct.Entity.Interfaces,
  Vcl.Dialogs,
  uThreadCustom;

{ TProductCreateUpdateView }

function TProductCreateUpdateView.BeforeShow: TProductCreateUpdateView;
var
  lEntity: IProductEntity;
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
          dtsProduct.DataSet.Append;
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
        lEntity := TProductController.Make(True).Show(FCurrentPk);
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
        TProductMapper.EntityToDataSet(lEntity, dtsProduct.DataSet);
        dtsProduct.DataSet.Edit;
      end;
      if edtname.CanFocus then
        edtname.SetFocus;
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

procedure TProductCreateUpdateView.btnCancelClick(Sender: TObject);
begin
  // Não prosseguir se estiver carregando
  if LoadingSave or LoadingForm then
    Exit;

  FCurrentPk  := -1;
  ModalResult := MrCancel;
end;

procedure TProductCreateUpdateView.btnSaveClick(Sender: TObject);
var
  lEntityToSave: IProductEntity;
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
      if (dtsProduct.DataSet.State in [dsInsert, dsEdit]) then
        dtsProduct.DataSet.Post;

      lEntityToSave := TProductEntity.Create;
      TProductMapper.DataSetToEntity(dtsProduct.DataSet, lEntityToSave);
    end,

    // OnProcess
    procedure
    var
      lCtrl: IProductController;
      lStoreResult: Either<string, Int64>;
      lUpdateResult: Either<string, Boolean>;
    begin
      lCtrl := TProductController.Make(True);

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
        dtsProduct.DataSet.Edit;
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

procedure TProductCreateUpdateView.FormCreate(Sender: TObject);
begin
  inherited;

  FViewModel          := TProductViewModel.Make;
  dtsProduct.DataSet := FViewModel.Product.DataSet;
end;

procedure TProductCreateUpdateView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Esc - Sair
  if (Key = VK_ESCAPE) then
  begin
    btnCancelClick(btnCancel);
    Exit;
  end;

  // F6 - Salvar
  if (Key = VK_F6) then
  begin
    btnSaveClick(btnSave);
    Exit;
  end;
end;

procedure TProductCreateUpdateView.FormShow(Sender: TObject);
begin
  inherited;

  BeforeShow;
end;

class function TProductCreateUpdateView.HandleEditRecord(AEditPk: Int64; AStateFormEnum: TEntityState): Boolean;
var
  lView: TProductCreateUpdateView;
begin
  lView := TProductCreateUpdateView.Create(nil);
  lView.FCurrentPk     := AEditPk;
  lView.FStateFormEnum := AStateFormEnum;
  Try
    Result := lView.ShowModal = mrOK;
  Finally
    if Assigned(lView) then
      FreeAndNil(lView);
  End;
end;

class function TProductCreateUpdateView.HandleNewRecord: Int64;
var
  lView: TProductCreateUpdateView;
begin
  Result := -1;
  lView := TProductCreateUpdateView.Create(nil);
  lView.FStateFormEnum := esStore;
  Try
    if (lView.ShowModal = mrOK) then
      Result := lView.FCurrentPk;
  Finally
    if Assigned(lView) then
      FreeAndNil(lView);
  End;
end;

end.
