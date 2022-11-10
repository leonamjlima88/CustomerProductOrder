{
Exemplo de uso

  TThreadCustom.Start(
    // OnShow
    procedure
    begin
    end,

    // OnProcess
    procedure
    begin
    end,

    // OnComplete
    procedure
    begin
    end,

    // OnError
    procedure(const AValue: string)
    begin
      MessageDlg('Oops... Ocorreu um erro!' + #13 + AValue, mtWarning, [mbOK], 0);
    end,

    // CompleteWithError?
    true
  );
}
unit uThreadCustom;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TThreadCustomException = reference to procedure(const AValue: string);

  TThreadCustom = Class
  public
    class function Start(const AOnShow, AOnProcess, AOnComplete: TProc; const AOnError: TThreadCustomException; const ADoCompleteWithError: Boolean = False): TThread;
  End;

implementation

{ TThreadCustom }

class function TThreadCustom.Start(const AOnShow, AOnProcess, AOnComplete: TProc; const AOnError: TThreadCustomException; const ADoCompleteWithError: Boolean): TThread;
var
  LDoComplete: Boolean;
begin
  LDoComplete := True;
  Result := nil;
  Result := TThread.CreateAnonymousThread( //
    procedure
    begin
      try
        try
          TThread.Synchronize( //
            TThread.CurrentThread, //
            procedure
            begin
              if (Assigned(AOnShow)) then
                AOnShow;
            end //
            );

          if (Assigned(AOnProcess)) then
            AOnProcess;
        except
          on E: Exception do
          begin
            LDoComplete := ADoCompleteWithError;
            TThread.Synchronize( //
              TThread.CurrentThread, //
              procedure
              begin
                if (Assigned(AOnError)) then
                  AOnError(E.Message);
              end //
              );
          end;
        end;
      finally
        if LDoComplete then
        begin
          TThread.Synchronize( //
            TThread.CurrentThread, //
            procedure
            begin
              if (Assigned(AOnComplete)) then
                AOnComplete;
            end //
            );
        end;
      end;
    end //
    );
  Result.FreeOnTerminate := True;
  Result.Start;
end;
end.

