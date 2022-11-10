inherited SalesOrderCreateUpdateView: TSalesOrderCreateUpdateView
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBackground: TPanel
    inherited pnlBackground2: TPanel
      inherited pnlBottomButtons: TPanel
        inherited pnlSave: TPanel
          inherited pnlSave2: TPanel
            inherited btnSave: TSpeedButton
              Caption = 'Gravar Pedido (F6)'
              OnClick = btnSaveClick
              ExplicitLeft = 62
            end
            inherited pnlSave3: TPanel
              inherited imgSave: TImage
                OnClick = btnSaveClick
                ExplicitLeft = -7
                ExplicitTop = 4
              end
              inherited IndicatorLoadButtonSave: TActivityIndicator
                ExplicitWidth = 24
                ExplicitHeight = 24
              end
            end
          end
        end
        inherited pnlCancel: TPanel
          inherited pnlCancel2: TPanel
            inherited btnCancel: TSpeedButton
              OnClick = btnCancelClick
              ExplicitLeft = 38
            end
            inherited pnlCancel3: TPanel
              inherited imgCancel4: TImage
                OnClick = btnCancelClick
              end
            end
          end
        end
      end
      inherited pgc: TPageControl
        inherited tabMain: TTabSheet
          ExplicitLeft = 4
          ExplicitTop = 25
          ExplicitWidth = 994
          ExplicitHeight = 574
          inherited pnlMain: TPanel
            object Label22: TLabel
              Left = 10
              Top = 10
              Width = 53
              Height = 18
              Caption = 'Cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label35: TLabel
              Left = 10
              Top = 34
              Width = 12
              Height = 14
              Caption = 'ID'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 11
              Top = 80
              Width = 8
              Height = 14
              Caption = '*'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label1: TLabel
              Left = 765
              Top = 540
              Width = 53
              Height = 24
              Caption = 'Total:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -20
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label23: TLabel
              Left = 21
              Top = 80
              Width = 62
              Height = 14
              Caption = 'F1 - Cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 10
              Top = 141
              Width = 67
              Height = 18
              Caption = 'Produtos'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label3: TLabel
              Left = 10
              Top = 165
              Width = 69
              Height = 14
              Caption = 'F2 - Produto'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 435
              Top = 165
              Width = 63
              Height = 14
              Caption = 'Quantidade'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 566
              Top = 165
              Width = 48
              Height = 14
              Caption = 'Vlr. Unit.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 697
              Top = 165
              Width = 28
              Height = 14
              Caption = 'Total'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 435
              Top = 80
              Width = 36
              Height = 14
              Caption = 'Cidade'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label9: TLabel
              Left = 828
              Top = 80
              Width = 14
              Height = 14
              Caption = 'UF'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Panel5: TPanel
              Left = 10
              Top = 28
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 9
            end
            object edtId: TDBEdit
              Left = 10
              Top = 49
              Width = 50
              Height = 26
              TabStop = False
              Color = 16053492
              DataField = 'id'
              DataSource = dtsSalesOrder
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Calibri'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              OnClick = EdtFieldClick
              OnKeyDown = EdtFieldKeyDown
            end
            object DBEdit1: TDBEdit
              Left = 828
              Top = 541
              Width = 157
              Height = 26
              TabStop = False
              BorderStyle = bsNone
              Color = 16579576
              DataField = 'sum_sales_order_product_amount'
              DataSource = dtsSalesOrder
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -20
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtcustomer_id: TDBEdit
              Left = 37
              Top = 95
              Width = 50
              Height = 26
              DataField = 'customer_id'
              DataSource = dtsSalesOrder
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel123: TPanel
              Left = 10
              Top = 95
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 10
              object Panel12: TPanel
                Left = 1
                Top = 1
                Width = 24
                Height = 24
                Cursor = crHandPoint
                Align = alClient
                BevelOuter = bvNone
                Color = 8747344
                ParentBackground = False
                TabOrder = 0
                object imgLocaCustomer: TImage
                  Left = 0
                  Top = 0
                  Width = 24
                  Height = 24
                  Align = alClient
                  AutoSize = True
                  Center = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000120000
                    0012080600000056CE8E57000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    414944415478DAA5938171C2300C45ADCB00850DC2040D1B94094A2600262899
                    80D205B84E001B1426209DA0D9A0E904658284FF13B9C7E56C27477DF7CFC696
                    9E14498809ACBAAE47D85EA0391443FC5D4247E85D444A6B2B014882ED431D73
                    E8A44F043E434BE815B0AD1704088DCF1A790BE38BDE199B85063A5755F51645
                    D1CE07DAABD34A1D3650017DE22EEF64FD054DC401B18F53E802119A32AB6050
                    C7038BBB84E314676672C2B908D4928DD8BB40744EE09CE2BCC39EF574B6F982
                    20C80C5821509BAAC87820688D6DE1028DB4D86CFBA10742DB664CC4138105A7
                    D1ACA7D0EC58D2D87920ACCFC2B4D39B7533C310C6B8DBC09E81E60C260EC88A
                    436727D7B4B3C4EC72358D5585DA96BC946E26A4DFFCCF9A3A69031E15F84368
                    F793C593C91F6448E72CE8FBBF100BFA65D5A107E8700FC4829E6E8A9ADD03E1
                    BA02035FC005512468860000000049454E44AE426082}
                  OnClick = imgLocaCustomerClick
                  ExplicitTop = 14
                  ExplicitWidth = 18
                  ExplicitHeight = 18
                end
              end
            end
            object edtcustomer_name: TDBEdit
              Left = 88
              Top = 95
              Width = 337
              Height = 26
              Color = 16053492
              DataField = 'customer_name'
              DataSource = dtsSalesOrder
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel1: TPanel
              Left = 10
              Top = 159
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 11
            end
            object edtSelectedProductId: TEdit
              Left = 37
              Top = 180
              Width = 50
              Height = 26
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtSelectedProductQuantity: TEdit
              Left = 435
              Top = 180
              Width = 121
              Height = 26
              Color = clWhite
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 6
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtSelectedProductUnitPrice: TEdit
              Left = 566
              Top = 180
              Width = 121
              Height = 26
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtSelectedProductAmount: TEdit
              Left = 697
              Top = 180
              Width = 121
              Height = 26
              Color = 16053492
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 8
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
              OnKeyPress = edtSelectedProductAmountKeyPress
            end
            object Panel2: TPanel
              Left = 828
              Top = 166
              Width = 156
              Height = 40
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5919286
              ParentBackground = False
              TabOrder = 12
              object pnlSelectedProductSubmit: TPanel
                Left = 1
                Top = 1
                Width = 154
                Height = 38
                Cursor = crHandPoint
                Align = alClient
                BevelOuter = bvNone
                Color = 8747344
                ParentBackground = False
                TabOrder = 0
                object btnSelectedProductSubmit: TSpeedButton
                  Left = 0
                  Top = 0
                  Width = 154
                  Height = 38
                  Cursor = crHandPoint
                  Align = alClient
                  Caption = 'Incluir Produto'
                  Flat = True
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWhite
                  Font.Height = -13
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                  OnClick = btnSelectedProductSubmitClick
                  ExplicitLeft = 62
                  ExplicitTop = 2
                  ExplicitWidth = 130
                end
              end
            end
            object pnlLocaCodProd: TPanel
              Left = 10
              Top = 180
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 13
              object Panel6: TPanel
                Left = 1
                Top = 1
                Width = 24
                Height = 24
                Cursor = crHandPoint
                Align = alClient
                BevelOuter = bvNone
                Color = 8747344
                ParentBackground = False
                TabOrder = 0
                object imgLocaProduct: TImage
                  Left = 0
                  Top = 0
                  Width = 24
                  Height = 24
                  Align = alClient
                  AutoSize = True
                  Center = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000120000
                    0012080600000056CE8E57000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    414944415478DAA5938171C2300C45ADCB00850DC2040D1B94094A2600262899
                    80D205B84E001B1426209DA0D9A0E904658284FF13B9C7E56C27477DF7CFC696
                    9E14498809ACBAAE47D85EA0391443FC5D4247E85D444A6B2B014882ED431D73
                    E8A44F043E434BE815B0AD1704088DCF1A790BE38BDE199B85063A5755F51645
                    D1CE07DAABD34A1D3650017DE22EEF64FD054DC401B18F53E802119A32AB6050
                    C7038BBB84E314676672C2B908D4928DD8BB40744EE09CE2BCC39EF574B6F982
                    20C80C5821509BAAC87820688D6DE1028DB4D86CFBA10742DB664CC4138105A7
                    D1ACA7D0EC58D2D87920ACCFC2B4D39B7533C310C6B8DBC09E81E60C260EC88A
                    436727D7B4B3C4EC72358D5585DA96BC946E26A4DFFCCF9A3A69031E15F84368
                    F793C593C91F6448E72CE8FBBF100BFA65D5A107E8700FC4829E6E8A9ADD03E1
                    BA02035FC005512468860000000049454E44AE426082}
                  OnClick = imgLocaProductClick
                  ExplicitTop = 14
                  ExplicitWidth = 18
                  ExplicitHeight = 18
                end
              end
            end
            object edtSelectedProductName: TEdit
              Left = 88
              Top = 180
              Width = 337
              Height = 26
              Color = 16053492
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
              OnKeyDown = EdtFieldKeyDown
            end
            object dbgSalesOrderProduct: TDBGrid
              Left = 11
              Top = 211
              Width = 974
              Height = 317
              Color = clWhite
              DrawingStyle = gdsGradient
              FixedColor = 8747344
              GradientEndColor = 10786408
              GradientStartColor = 8747344
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
              ParentFont = False
              ReadOnly = True
              TabOrder = 14
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWhite
              TitleFont.Height = -12
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = [fsBold]
              OnCellClick = dbgSalesOrderProductCellClick
              OnDrawColumnCell = dbgSalesOrderProductDrawColumnCell
              OnDblClick = btnSelectedProductSetModifyClick
              OnKeyDown = dbgSalesOrderProductKeyDown
              Columns = <
                item
                  Alignment = taRightJustify
                  Expanded = False
                  FieldName = 'editar'
                  Title.Caption = ' '
                  Width = 25
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'deletar'
                  Title.Caption = ' '
                  Width = 25
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'product_id'
                  Title.Caption = 'C'#243'd. Prod.'
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'product_name'
                  Title.Caption = 'Produto'
                  Width = 392
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'quantity'
                  Title.Caption = 'Qde'
                  Width = 71
                  Visible = True
                end
                item
                  Alignment = taRightJustify
                  Expanded = False
                  FieldName = 'unit_price'
                  Title.Alignment = taRightJustify
                  Title.Caption = 'Pre'#231'o Unit.'
                  Width = 150
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'amount'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = 7300674
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  Title.Caption = 'Total'
                  Width = 150
                  Visible = True
                end>
            end
            object DBEdit2: TDBEdit
              Left = 435
              Top = 95
              Width = 383
              Height = 26
              Color = 16053492
              DataField = 'customer_city'
              DataSource = dtsSalesOrder
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 15
              OnKeyDown = EdtFieldKeyDown
            end
            object DBEdit3: TDBEdit
              Left = 828
              Top = 95
              Width = 40
              Height = 26
              Color = 16053492
              DataField = 'customer_state'
              DataSource = dtsSalesOrder
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 16
              OnKeyDown = EdtFieldKeyDown
            end
          end
        end
      end
    end
    inherited pnlTitle: TPanel
      inherited imgTitle: TImage
        Width = 25
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
          00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
          6E4944415478DAB5968D51C3300C85EDCB008409081B9409683768364827A04C
          4098806C4037A04CD032016C403B011E2097A0D79339135CFF1EBAF3B9499EFC
          45B2A5548EE3580A21EE686076D99B94723BBDC9FE331E17348EA4DB981A49A2
          35CD4F22CCAE69818301C0C2CF0C985AAD5F0A1000D681901B72FC604045D3BB
          270327500E0411341EBD22FD651284F7E153F8F711B64A85CC385521D6E644F2
          15E8D3E5EC09D25505F8D4399007A4C2A3DF937E910C61D08EA6F919ADA2B180
          1E90255DBC0400E0846254E64D4B31E3395E64A50B57B2B00CC8EF610A98C0E0
          5FDA7432304D59F6076244A5CC3EE5D079A3FF81F47D5F1545816EDC88DF95FC
          48C2D60208ADF85AEF092A78E7703A1D45031253F19D86B88EA2B67B02754990
          98238C8E9A0A89FE68A540FEBB0BC7A58B23512990D0B6BD25408D1FA9A7CB19
          0D3DC73F90B92ECE24086C1886252D6203ED85D1EC1812F3D16A6D6DA5A1E98A
          2F5FC599C6C82F75EB011C696CBE016BDCF402CC34BF930000000049454E44AE
          426082}
        ExplicitLeft = 10
        ExplicitTop = 10
        ExplicitWidth = 25
        ExplicitHeight = 25
      end
      inherited lblTitle: TLabel
        Left = 45
        Width = 184
        Height = 40
        Caption = 'Pedido de Venda'
        ExplicitLeft = 45
        ExplicitWidth = 184
      end
      inherited imgCloseTitle: TImage
        OnClick = btnCancelClick
        ExplicitLeft = 563
      end
      inherited imgMinimizeTitle: TImage
        ExplicitLeft = 528
      end
    end
  end
  inherited IndicatorLoadForm: TActivityIndicator
    ExplicitWidth = 64
    ExplicitHeight = 64
  end
  object dtsSalesOrder: TDataSource
    Left = 887
    Top = 11
  end
  object dtsSalesOrderProduct: TDataSource
    Left = 916
    Top = 11
  end
end
