object WithoutViewModelView: TWithoutViewModelView
  Left = 0
  Top = 0
  Caption = 'WithoutViewModelView'
  ClientHeight = 643
  ClientWidth = 889
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 290
    Height = 13
    Caption = 'Tela para compreender melhor o funcionamento das classes.'
  end
  object Button1: TButton
    Left = 24
    Top = 27
    Width = 113
    Height = 49
    Caption = 'Incluir Registro'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 82
    Width = 569
    Height = 223
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Button2: TButton
    Left = 248
    Top = 27
    Width = 153
    Height = 49
    Caption = 'Incluir Cliente com Tasks'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ActivityIndicator1: TActivityIndicator
    Left = 561
    Top = 44
  end
end
