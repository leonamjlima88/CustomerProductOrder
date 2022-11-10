inherited SalesOrderIndexView: TSalesOrderIndexView
  Caption = 'SalesOrderIndexView'
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlBackground: TPanel
    inherited pnlContent: TPanel
      ExplicitLeft = 320
      ExplicitWidth = 688
      inherited pnlTitle: TPanel
        ExplicitWidth = 648
        inherited lblTitle: TLabel
          Width = 84
          Caption = 'Pedidos'
          ExplicitWidth = 84
        end
        inherited pnlTitleBottomBar: TPanel
          ExplicitWidth = 648
        end
      end
      inherited scbContent: TScrollBox
        ExplicitWidth = 648
        inherited pnlGrid: TPanel
          Height = 447
          ExplicitWidth = 648
          ExplicitHeight = 447
          inherited pnlGrid2: TPanel
            Height = 447
            ExplicitWidth = 648
            ExplicitHeight = 447
            inherited pnlSearch: TPanel
              ExplicitWidth = 648
              inherited pnlSearch4: TPanel
                ExplicitWidth = 648
              end
              inherited pnlSearch2: TPanel
                ExplicitWidth = 648
              end
            end
            inherited pnlDbgrid: TPanel
              Height = 447
              ExplicitWidth = 648
              ExplicitHeight = 447
              inherited DBGrid1: TDBGrid
                Height = 447
                OnCellClick = DBGrid1CellClick
                OnDrawColumnCell = DBGrid1DrawColumnCell
                OnDblClick = DBGrid1DblClick
                OnKeyDown = DBGrid1KeyDown
                Columns = <
                  item
                    Alignment = taCenter
                    Expanded = False
                    FieldName = 'editar'
                    Title.Alignment = taCenter
                    Title.Caption = ' '
                    Width = 25
                    Visible = True
                  end
                  item
                    Alignment = taCenter
                    Expanded = False
                    FieldName = 'deletar'
                    Title.Alignment = taCenter
                    Title.Caption = ' '
                    Width = 25
                    Visible = True
                  end
                  item
                    Alignment = taCenter
                    Expanded = False
                    FieldName = 'visualizar'
                    Title.Alignment = taCenter
                    Title.Caption = ' '
                    Width = 25
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'id'
                    Title.Caption = 'N'#186' do Pedido'
                    Width = 107
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'customer_name'
                    Title.Caption = 'Nome do Cliente'
                    Width = 450
                    Visible = True
                  end
                  item
                    Alignment = taRightJustify
                    Expanded = False
                    FieldName = 'sum_sales_order_product_amount'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = 7300674
                    Font.Height = -16
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    Title.Alignment = taRightJustify
                    Title.Caption = 'Total'
                    Width = 300
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'created_at'
                    Title.Caption = 'Emiss'#227'o'
                    Width = 200
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'updated_at'
                    Title.Caption = 'Atualizado em'
                    Width = 200
                    Visible = True
                  end>
              end
            end
          end
        end
        inherited pnlNavigator: TPanel
          Top = 507
          ExplicitTop = 507
          ExplicitWidth = 648
          inherited pnlNavFirst3: TPanel
            inherited pnlNavFirst2: TPanel
              inherited btnNavFirst: TSpeedButton
                OnClick = btnNavIndexClick
              end
            end
          end
          inherited pnlNavLast3: TPanel
            inherited pnlNavLast2: TPanel
              inherited btnNavLast: TSpeedButton
                OnClick = btnNavIndexClick
              end
            end
          end
          inherited pnlNavPrior4: TPanel
            inherited pnlNavPrior2: TPanel
              inherited pnlNavPrior: TPanel
                inherited btnNavPrior: TSpeedButton
                  OnClick = btnNavIndexClick
                end
              end
            end
          end
          inherited pnlNavNext4: TPanel
            inherited pnlNavNext2: TPanel
              inherited pnlNavNext: TPanel
                inherited btnNavNext: TSpeedButton
                  OnClick = btnNavIndexClick
                end
              end
            end
          end
          inherited pnlNavLimitPerPage: TPanel
            inherited pnlNavLimitPerPage2: TPanel
              inherited edtNavLimitPerPage: TEdit
                OnExit = edtNavLimitPerPageExit
              end
            end
          end
        end
        inherited pnlButtonsTop: TPanel
          ExplicitWidth = 648
          inherited pnlOptions: TPanel
            inherited pnlOptions2: TPanel
              inherited pnlOptions3: TPanel
                inherited imgOptions: TImage
                  OnClick = imgOptionsClick
                end
              end
            end
          end
          inherited pnlAppend: TPanel
            inherited pnlAppend2: TPanel
              inherited btnAppend: TSpeedButton
                OnClick = btnAppendClick
              end
              inherited pnlAppend3: TPanel
                inherited imgAppend: TImage
                  OnClick = btnAppendClick
                end
              end
            end
          end
          inherited pnlSearch3: TPanel
            ExplicitLeft = 232
            ExplicitWidth = 416
            inherited Panel4: TPanel
              ExplicitWidth = 414
              inherited imgDoSearch: TImage
                OnClick = imgDoSearchClick
                ExplicitLeft = 5
                ExplicitTop = 13
                ExplicitHeight = 28
              end
              inherited imgSearchClear: TImage
                OnClick = imgSearchClearClick
              end
              inherited pnlSearch5: TPanel
                ExplicitWidth = 341
                inherited lblSearchTitle: TLabel
                  Width = 260
                  Caption = 'Pesquise por N'#186' do Pedido ou Nome do Cliente.'
                  ExplicitWidth = 260
                end
                inherited edtSearchValue: TEdit
                  OnChange = edtSearchValueChange
                  OnDblClick = edtSearchValueDblClick
                  OnKeyPress = edtSearchValueKeyPress
                  ExplicitWidth = 331
                end
              end
            end
          end
          inherited pnlFilter: TPanel
            inherited pnlFilter2: TPanel
              inherited btnFilter: TSpeedButton
                ExplicitLeft = 0
                ExplicitTop = 2
                ExplicitWidth = 38
                ExplicitHeight = 38
              end
            end
          end
        end
        object pnlLocate: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 552
          Width = 648
          Height = 46
          Margins.Left = 0
          Margins.Top = 20
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alBottom
          BevelOuter = bvNone
          Color = 16381936
          ParentBackground = False
          TabOrder = 3
          Visible = False
          object imgLocateAppend: TImage
            Left = 0
            Top = 0
            Width = 20
            Height = 20
            Cursor = crHandPoint
            Picture.Data = {
              0954506E67496D61676589504E470D0A1A0A0000000D49484452000000140000
              001408060000008D891D0D000000017352474200AECE1CE90000000467414D41
              0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
              7E4944415478DAAD94CD2E035114C7EF157BF5B125158285883E80D848EC8CBE
              804C638DD6A25BE9B612CA0354DFA01D2C6C2CC45E6A49246A2DA2892DC6EFEA
              8CDCF96A67AA27F9E79CB973EEEF7E1F29426CAE6CA4700632D12252DFC3E80D
              DD22EBB168D5C2FA4A7FC37CD9D8B28538221C17DDAD8D0A7EB0D4402940C7CE
              AC925815E87600C832ABB85C42980BA93D14ADDC1F10D80EEE34225FEDDB9A13
              5FA3B188BC2C336D48E7009EBAEC5983C4AC33701DB719B5A7E48DCA1EB34B02
              549693319292007F97FC4C90D61ADFD18DF6DD0458728079DCAAF6CF0F6F2BA0
              ED6BCC00688A18C6559BA2F38BD66407801CFB3457A01513B844E77B4F7F80AF
              F809ADED0B5D442CF900B7ACFD5B11DEDBD152C02B82F5411E8A49703620A029
              170E8D916F5BA84348FF13A85ED4ACFBF454523D225155950C9A44E7A253CAC2
              2CCFC0277A7150CB36457F5601565081A71EF659712AA804B01D003AD03DD129
              B0433D40EA45ED4716D810F02E6E03CD88CE817DA20F74872E51CD9D956E3F9A
              9B9804204234240000000049454E44AE426082}
            OnClick = btnAppendClick
          end
          object imgLocateEdit: TImage
            Left = 0
            Top = 25
            Width = 20
            Height = 20
            Cursor = crHandPoint
            Picture.Data = {
              0954506E67496D61676589504E470D0A1A0A0000000D49484452000000140000
              001408060000008D891D0D000000017352474200AECE1CE90000000467414D41
              0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
              CA4944415478DA9D953F2C435114C6BFDB1222420949633248176611535B9381
              F81726D2329834BA4A9ABC328B926090A093C15016912EADC16668AC066CD20E
              1A6944D0F77CB7D5E6F5FF7B3DC9CD3DEFE4DE5FBE73EEBDE70954314D71DA54
              88690B34AF060C0BC0C6702B478AE39EE35A28F1F36A7B4579E05771AD58A1ED
              D2ED437D4B73F8CBC145E077D06D6BD1D43D063C3061CCE4D4AAC4D62A80AAE2
              3CE587D70CAC5822E0D2A2C4178B40A6B9C1340F0C133ABA80CF8FF2E82CD3BF
              12F200F8F164A06679EB1D009659E2C728103B2BA929813D82A96E50A63175ED
              9D808B55199D83967A85385E65BEAA7E85572A8CD09931AC2C7A0438C681BB30
              35BD95AFCAA5FC4C67B02ECC3E042CEDF036DA8124974B65D52D2D819A216512
              261585FDD594E58C20AD3ED004AC601298E4DCDF30CD8BAD8630DA8B04DED099
              2C09CBD35C3F31A54C7F281E3A25170A236E603E604659A1861EF1B53DD1DDA6
              6613D09FF4D8427E4EDC025F194330E43B9123F7F4A852DEC388D19D35D46DF2
              3DEF179B03A1326D4F93BC109F9D5F3A25FDB0C98E13E2081298AE00FE437D9C
              645FB43448F19D6B02041DEAE3A2D686ACE2F2F117304597173277603F8464B8
              E181BEBC6AE705557AFB03C8D0A8C23CF54E3C0000000049454E44AE426082}
            OnClick = btnEditClick
          end
          object lblLocateAppend: TLabel
            Left = 26
            Top = 2
            Width = 171
            Height = 16
            Cursor = crHandPoint
            Caption = 'Incluir um novo registro. (Ins)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8747344
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            OnClick = btnAppendClick
          end
          object lblLocateEdit: TLabel
            Left = 26
            Top = 27
            Width = 156
            Height = 16
            Cursor = crHandPoint
            Caption = 'Editar registro posicionado.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8747344
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            OnClick = btnEditClick
          end
          object pnlSave: TPanel
            AlignWithMargins = True
            Left = 478
            Top = 4
            Width = 170
            Height = 42
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 4
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            BevelOuter = bvNone
            Color = 3299352
            ParentBackground = False
            TabOrder = 0
            object pnlSave2: TPanel
              Left = 0
              Top = 0
              Width = 170
              Height = 42
              Cursor = crHandPoint
              Align = alClient
              BevelOuter = bvNone
              Color = 5212710
              ParentBackground = False
              TabOrder = 0
              object btnLocateConfirm: TSpeedButton
                Left = 38
                Top = 0
                Width = 132
                Height = 42
                Cursor = crHandPoint
                Align = alClient
                Caption = 'Confirmar (Enter)'
                Flat = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWhite
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                OnClick = btnLocateConfirmClick
                ExplicitTop = 2
                ExplicitWidth = 130
                ExplicitHeight = 38
              end
              object pnlSave3: TPanel
                Left = 0
                Top = 0
                Width = 38
                Height = 42
                Align = alLeft
                BevelOuter = bvNone
                Color = 4552994
                ParentBackground = False
                TabOrder = 0
                object imgSave: TImage
                  AlignWithMargins = True
                  Left = 5
                  Top = 5
                  Width = 25
                  Height = 32
                  Cursor = crHandPoint
                  Margins.Left = 5
                  Margins.Top = 5
                  Margins.Right = 5
                  Margins.Bottom = 5
                  Align = alLeft
                  Center = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
                    00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000002
                    BD4944415478DAB5967B684E611CC7CFC91F729D154D2B8B2251B4B01452CB1A
                    9B3F988D90CBFCA7FC333299CB721D35B592C83FAE21B74CAE19EFE4AF955B22
                    4D5A2B458A78436BE5F2FA7CBDBFF3F6F47ACF7B899DFAF43BE739BFE7F779CE
                    739EF739AFEF653862B1587F42091443010C87287C8536DFF71F66AAE1A729AE
                    625BA01A8AACB9077EC1602755D707A119E1BBAC24141F40A8834D30141EC035
                    B809EFE19BF51B0BB36021545AF77A4407D24A10E4118EC032E880F574EAC862
                    4A3595876026DCA74F694A0989FD08E76D7A5A601BC93D990449B29D84C66491
                    2B692034811E772FD4425E2E128E3DB0430384DD881A1312047ACC5B10819530
                    1DDAACE345E84A53781A94D97905856F534FEFAF022673FD3C909CB397574C63
                    37D7658EA48AB6D6345354630371255A995A2411AECB7D1A0AB9780B2769A8B5
                    8EFF24B1F66384355024499DBDE8392444FEA3640AE1B1A7156AC6155040C2E7
                    14924E23EC180553534806D994B54A72D55ED0186774AE24972321B13A6F3440
                    49DA3919C9CD097D20794AE895E4062733B899DF07926E4297247AE96BED9D7C
                    099168FF6A4F51749E17FF4DFD25A18606AD557B4692E53A81D5249C0A91ECE7
                    5E43B281BC7D84CD21126D9C57A0DAB74DF1135C27614198C418011FC98B6621
                    394D580C85C12FFEB817DFAB4A487A1422D1323E012FC899944E42FB78CE5FFE
                    992ADF5F1548F2ED693AB5CAB81EE6C537B96083BC6792751025A7DEFAE98738
                    D79148F813B49826C2ECC4DE651DB4C55F823BDC703B667D50632041B3B24403
                    A2CE61B5277FB49A091BE12E5492F43D07819E5EBB4715B4D07743702FD5E777
                    17613B7C5024F96816A3AFB1E91D075BE9D3E4E6F8211D4B6D54A3A1D7A640DF
                    79ED45DADF8678F16FBCBE438B405BD22B135C4EAE17FA6FC5644BBDF8765D1E
                    92A2BF454FE0029C0D96764E1247A6EFFF7C7B02F1035EC3B3B0C2EEF11BEE87
                    567A9D684E950000000049454E44AE426082}
                  OnClick = btnLocateConfirmClick
                  ExplicitLeft = 13
                  ExplicitTop = 10
                  ExplicitHeight = 28
                end
              end
            end
          end
          object pnlCancel: TPanel
            AlignWithMargins = True
            Left = 298
            Top = 4
            Width = 170
            Height = 42
            Cursor = crHandPoint
            Margins.Left = 0
            Margins.Top = 4
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alRight
            BevelOuter = bvNone
            Color = 6708286
            ParentBackground = False
            TabOrder = 1
            object pnlCancel2: TPanel
              Left = 0
              Top = 0
              Width = 170
              Height = 42
              Cursor = crHandPoint
              Align = alClient
              BevelOuter = bvNone
              Color = 15658211
              ParentBackground = False
              TabOrder = 0
              object btnLocateClose: TSpeedButton
                Left = 38
                Top = 0
                Width = 132
                Height = 42
                Cursor = crHandPoint
                Align = alClient
                Caption = 'Cancelar (Esc)'
                Flat = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 8747344
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                OnClick = btnLocateCloseClick
                ExplicitLeft = 54
                ExplicitTop = 2
                ExplicitWidth = 130
                ExplicitHeight = 38
              end
              object pnlCancel3: TPanel
                Left = 0
                Top = 0
                Width = 38
                Height = 42
                Align = alLeft
                BevelOuter = bvNone
                Color = 12893085
                ParentBackground = False
                TabOrder = 0
                object imgCancel4: TImage
                  AlignWithMargins = True
                  Left = 5
                  Top = 5
                  Width = 25
                  Height = 32
                  Cursor = crHandPoint
                  Margins.Left = 5
                  Margins.Top = 5
                  Margins.Right = 5
                  Margins.Bottom = 5
                  Align = alLeft
                  Center = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
                    00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    DA4944415478DABD56D171C2300CB5F9E083AF74033241610398A06182C20485
                    091A26A01B1026289D0036804E001BE03F3E38A04FA0E45463A781E4AA3B5D63
                    4BD6B3A42753ADFE417451C7F3F91CE04F07DA846EB5D6F34A410040C13FA181
                    D836D01EC096A5414EA7530B811616809436ECEB5220C862C165A29B8FA109B4
                    0F9DB00B952E7C18040043116C8C60B1B04D198C64005B723708377AC365DA72
                    598C655FA92B11CCE17008EBF5BAB917E4E6A61CB895361BEB485D0941DFB35A
                    ADD62F0CC26C5AF0728EA0BDE3F11820489A99D9EFF761A3D130A2674A7948A0
                    1D0001DF8E0E52FA5D3A68F54766D7E4B292ACB1D72E0222837DE0D088F76530
                    C5E069D9C87F28C1BD201C6895D3EC0D377A89FDAE957D46023EB7758260F0E8
                    E66FBE1B21183576EAB1652448FB7803E26AB6A75F2B3B43617792403B1C72DF
                    24F8B57CCF88D5B7EC25D08E66C7308E3D41E8122FD0AF9C4B64F385EF01689F
                    E8BF26DB2A553627D030C7EF3709AC2CBC6F101FDEF1F2864196AF24C1884068
                    11A902AF29D817C1E795CB95E4F922EE8EB39E4B1083834FAA02B14A76E9C93B
                    3E62B6D34FEA8CCBF1A8100091A3CFEBF8D278284DF073155958197D236E27A5
                    30A14F047A59A14AD02CD1BC19D70319550120E95DF85FA232F20397BB1C8499
                    AADF3F0000000049454E44AE426082}
                  OnClick = btnLocateCloseClick
                  ExplicitTop = 4
                  ExplicitHeight = 28
                end
              end
            end
          end
        end
      end
    end
    inherited SplitView1: TSplitView
      ExplicitLeft = 0
      inherited pnlSplitView: TPanel
        inherited pnlSplitView3: TPanel
          inherited pnlSplitViewApply: TPanel
            inherited pnlSplitViewApply2: TPanel
              OnClick = imgSplitViewApplyClick
              inherited pnlSplitViewApply3: TPanel
                inherited btnSplitViewApply: TSpeedButton
                  OnClick = imgSplitViewApplyClick
                end
              end
            end
          end
          inherited pnlSplitViewHide: TPanel
            inherited pnlSplitViewHide2: TPanel
              OnClick = imgSplitViewHideClick
            end
          end
          inherited pnlFilterClean2: TPanel
            inherited pnlFilterClean: TPanel
              OnClick = imgSearchClearClick
              inherited imgFilterClean: TImage
                OnClick = imgSearchClearClick
              end
            end
          end
        end
        inherited scbSplitView: TScrollBox
          object lblFilterSearchType2: TLabel
            Left = 10
            Top = 9
            Width = 80
            Height = 14
            Caption = 'N'#186' do Pedido'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8747344
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label2: TLabel
            Left = 10
            Top = 60
            Width = 42
            Height = 14
            Caption = 'Cliente'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8747344
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label3: TLabel
            Left = 10
            Top = 111
            Width = 70
            Height = 14
            Caption = 'Emiss'#227'o em'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8747344
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label4: TLabel
            Left = 168
            Top = 111
            Width = 22
            Height = 14
            Caption = 'At'#233
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8747344
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object SpeedButton1: TSpeedButton
            Left = 137
            Top = 111
            Width = 14
            Height = 14
            Cursor = crHandPoint
            Hint = 'Preencha Data Inicial e Final para filtragem dos dados.'
            Caption = '?'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object SpeedButton2: TSpeedButton
            Left = 295
            Top = 111
            Width = 14
            Height = 14
            Cursor = crHandPoint
            Hint = 'Preencha Data Inicial e Final para filtragem dos dados.'
            Caption = '?'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
          end
          object edtFilterId: TEdit
            Left = 10
            Top = 24
            Width = 299
            Height = 26
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object edtFilterCustomerId: TEdit
            Left = 37
            Top = 75
            Width = 50
            Height = 26
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnExit = edtFilterCustomerIdExit
          end
          object Panel123: TPanel
            Left = 10
            Top = 75
            Width = 26
            Height = 26
            Cursor = crHandPoint
            BevelOuter = bvNone
            BorderWidth = 1
            Color = 5327153
            ParentBackground = False
            TabOrder = 2
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
              object imgFilterLocaCustomer: TImage
                Left = 0
                Top = 0
                Width = 18
                Height = 18
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
                OnClick = imgFilterLocaCustomerClick
                ExplicitTop = 14
              end
            end
          end
          object edtFilterCustomerName: TEdit
            Left = 88
            Top = 75
            Width = 221
            Height = 26
            Color = 16053492
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 3
          end
          object edtFilterCreatedAtStart: TDateTimePicker
            Left = 10
            Top = 126
            Width = 141
            Height = 26
            Date = 44874.000000000000000000
            Time = 44874.000000000000000000
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
          end
          object edtFilterCreatedAtEnd: TDateTimePicker
            Left = 168
            Top = 126
            Width = 141
            Height = 26
            Date = 44874.752840740740000000
            Time = 44874.752840740740000000
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
        end
      end
    end
  end
  inherited IndicatorLoadDoSearch: TActivityIndicator
    ExplicitWidth = 64
    ExplicitHeight = 64
  end
  inherited dtsIndex: TDataSource
    Top = 176
  end
  object tmrDoSearch: TTimer
    Enabled = False
    Interval = 600
    OnTimer = tmrDoSearchTimer
    Left = 942
    Top = 232
  end
  object PopupMenu1: TPopupMenu
    Left = 948
    Top = 289
    object Registros1: TMenuItem
      Caption = '** Op'#231#245'es **'
      Enabled = False
    end
    object mniLocaSaleOrderToEdit: TMenuItem
      Caption = '        Localizar Pedido p/ N'#250'mero'
      OnClick = mniLocaSaleOrderToEditClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniLocaSaleOrderToDelete: TMenuItem
      Caption = '        Cancelar/Deletar Pedido p/ N'#250'mero'
      OnClick = mniLocaSaleOrderToDeleteClick
    end
  end
end
