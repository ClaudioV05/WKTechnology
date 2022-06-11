object FrmClientes: TFrmClientes
  Left = 0
  Top = 0
  Caption = 'Pesquisa de Clientes'
  ClientHeight = 513
  ClientWidth = 759
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PanFiltro: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 753
    Height = 89
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblCampoPesquisa: TLabel
      Left = 4
      Top = 3
      Width = 78
      Height = 13
      Caption = '&Campo Pesquisa'
      FocusControl = CboCampoPesquisa
    end
    object LblOrdem: TLabel
      Left = 4
      Top = 43
      Width = 59
      Height = 13
      Caption = '&Ordenar por'
      FocusControl = CboOrdem
    end
    object Label1: TLabel
      Left = 202
      Top = 45
      Width = 49
      Height = 13
      Caption = 'Pagina'#231#227'o'
      FocusControl = CboOrdem
    end
    object Bevel1: TBevel
      Left = 365
      Top = 5
      Width = 9
      Height = 77
      Shape = bsLeftLine
    end
    object Label2: TLabel
      Left = 376
      Top = 3
      Width = 83
      Height = 13
      Caption = 'Confirmar Cliente'
      FocusControl = CboOrdem
    end
    object EdtPesquisa: TEdit
      Left = 202
      Top = 20
      Width = 153
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 2
      OnChange = EdtPesquisaChange
    end
    object CboModoPesquisa: TComboBox
      Left = 110
      Top = 20
      Width = 83
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 1
      Text = 'contem'
      Items.Strings = (
        'come'#231'a com'
        'contem'
        #233' igual a')
    end
    object ChkDescendente: TCheckBox
      Left = 113
      Top = 62
      Width = 81
      Height = 17
      Caption = 'Descendente'
      TabOrder = 4
      OnClick = ChkDescendenteClick
    end
    object CboOrdem: TComboBox
      Left = 4
      Top = 60
      Width = 100
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'CODIGO'
      OnChange = CboOrdemChange
      Items.Strings = (
        'CODIGO'
        'NOME')
    end
    object CboCampoPesquisa: TComboBox
      Left = 4
      Top = 20
      Width = 100
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'CODIGO'
      OnChange = CboCampoPesquisaChange
      Items.Strings = (
        'CODIGO'
        'NOME')
    end
    object BtnRetornar: TBitBtn
      Left = 202
      Top = 58
      Width = 75
      Height = 25
      Hint = 'Retornar'
      Caption = '&Retornar'
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        1800000000000006000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FF331400451B00572200572200471C00361600FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7474747A7A7A7F
        7F7F7F7F7F7A7A7A757575FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF491C00491C00803200A54100AA4200AA4200A74100843400511F00511F
        00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7B7B7B7B7B7B8A8A8A94949495
        95959595959595958C8C8C7D7D7D7D7D7DFF00FFFF00FFFF00FFFF00FFFF00FF
        5923006E2B00AF4400B14500AA4200A54100AA4200AA4200AF4400B14500702C
        00361600FF00FFFF00FFFF00FFFF00FF80808086868696969697979795959594
        9494959595959595969696979797868686757575FF00FFFF00FFFF00FF592300
        7B3000C54D00B84800AA4200A54100A54100A74100A74100A74100AA4200B145
        00702C00511F00FF00FFFF00FF8080808989899C9C9C99999995959594949494
        94949595959595959595959595959797978686867D7D7DFF00FFFF00FF592300
        D45300CC5000BB4900AA4200C67F42F8EFE7F3E3D4B25510A74100A74100AA42
        00B14500511F00FF00FFFF00FF8080809F9F9F9E9E9E999999959595B8B8B8EF
        EFEFE9E9E9A1A1A19595959595959595959797977D7D7DFF00FF5F2500A03F00
        EB5C00CC5000B14500C67A3AFCF8F4FFFFFFDAAA7EAA4603A74100A74100A741
        00AF4400843400451B00818181939393A5A5A59E9E9E979797B5B5B5F3F3F3F6
        F6F6CECECE9898989595959595959595959696968C8C8C7A7A7A5F2500D75400
        EB5C00D45300CA7A38FCF7F3FEFEFCD7A06FA74100A74100A74100A74100A741
        00AC43009E3E00451B00818181A0A0A0A5A5A59F9F9FB6B6B6F2F2F2F5F5F5C9
        C9C99595959595959595959595959595959696969292927A7A7A772E00F66000
        F86200FB9E4FFEF6EEFFFFFFFEFAF6F7CFAAF6CCA6E7C9ABE7C9ABE7C9ACE9CB
        AFAA4200AA42004F1F00888888A7A7A7A8A8A8C8C8C8F2F2F2F6F6F6F3F3F3E0
        E0E0DEDEDEDDDDDDDDDDDDDDDDDDDEDEDE9595959595957D7D7D893500FF7813
        FF6A04FED1A7FFFFFFFFFFFFFFFEFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFAC4300AA42005722008D8D8DB4B4B4ADADADE1E1E1F6F6F6F6F6F6F5F5F5F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F69696969595957F7F7F893500FF8829
        FF801EF26C0BFEC28CFFFFFFFFFBF8FBAB66E27925D77D31D57B31D47B32D47A
        31B84800A541004B1D008D8D8DBDBDBDB9B9B9ADADADDADADAF6F6F6F4F4F4CF
        CFCFB4B4B4B6B6B6B6B6B6B6B6B6B6B6B69999999494947B7B7B893500FF801E
        FFAD67FF6400EE5E00FEB779FFFFFFFFEDDAEF8630D45300CF5100CF5100C54D
        00BB4900953A004B1D008D8D8DB9B9B9D0D0D0A9A9A9A6A6A6D5D5D5F6F6F6ED
        EDEDBCBCBC9F9F9F9E9E9E9E9E9E9C9C9C9999999090907B7B7BFF00FFE65A00
        FFC693FF9842E15800EB5D00FEB270FFFFFFFFF8F2E26B11CF5100CA4F00C04B
        00C74E00752D00FF00FFFF00FFA4A4A4DCDCDCC5C5C5A2A2A2A5A5A5D2D2D2F6
        F6F6F3F3F3ADADAD9E9E9E9D9D9D9B9B9B9C9C9C878787FF00FFFF00FFE65A00
        FF892BFFDAB7FF9741F86200E95E01FCB87AFEC795E56205D95500D45300D754
        00B44600752D00FF00FFFF00FFA4A4A4BDBDBDE5E5E5C5C5C5A8A8A8A5A5A5D5
        D5D5DCDCDCA7A7A7A1A1A19F9F9FA0A0A0989898878787FF00FFFF00FFFF00FF
        C54D00FF9842FFE2C6FFBB7FFF8728FF750FFF6B05FF6E08FF6E08FF6701CA4F
        00702C00FF00FFFF00FFFF00FFFF00FF9C9C9CC5C5C5E9E9E9D7D7D7BCBCBCB3
        B3B3ADADADAFAFAFAFAFAFABABAB9D9D9D868686FF00FFFF00FFFF00FFFF00FF
        FF00FFFF801EFF801EFFBA7DFFD5ADFFC591FFB574FFA558FF8323D75400D754
        00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB9B9B9B9B9B9D6D6D6E3E3E3DB
        DBDBD4D4D4CCCCCCBABABAA0A0A0A0A0A0FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFE15800FF700AFF7D19FF7813FB6300B64700FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA2A2A2B0B0B0B7
        B7B7B4B4B4A8A8A8989898FF00FFFF00FFFF00FFFF00FFFF00FF}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
      OnClick = BtnRetornarClick
    end
    object BtnAvancar: TBitBtn
      Left = 280
      Top = 58
      Width = 75
      Height = 25
      Hint = 'Avan'#231'ar'
      Caption = '&Avan'#231'ar'
      Enabled = False
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        1800000000000006000000000000000000000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FF331400451B00572200572200471C00361600FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7474747A7A7A7F
        7F7F7F7F7F7A7A7A757575FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF491C00491C00803200A54100AA4200AA4200A74100843400511F00511F
        00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7B7B7B7B7B7B8A8A8A94949495
        95959595959595958C8C8C7D7D7D7D7D7DFF00FFFF00FFFF00FFFF00FFFF00FF
        5923006E2B00AF4400B14500AA4200A54100AA4200AA4200AF4400B14500702C
        00361600FF00FFFF00FFFF00FFFF00FF80808086868696969697979795959594
        9494959595959595969696979797868686757575FF00FFFF00FFFF00FF592300
        7B3000C54D00B84800AA4200A54100A54100A74100A74100A74100AA4200B145
        00702C00511F00FF00FFFF00FF8080808989899C9C9C99999995959594949494
        94949595959595959595959595959797978686867D7D7DFF00FFFF00FF592300
        D45300CC5000BB4900AA4200B25510F3E3D4F8EFE7C67F42A74100A74100AA42
        00B14500511F00FF00FFFF00FF8080809F9F9F9E9E9E999999959595A1A1A1E9
        E9E9EFEFEFB8B8B89595959595959595959797977D7D7DFF00FF5F2500A03F00
        EB5C00CC5000B14500AC4300AA4603DAAA7EFFFFFFFCF8F4C4793AA74100A741
        00AF4400843400451B00818181939393A5A5A59E9E9E979797969696989898CE
        CECEF6F6F6F3F3F3B4B4B49595959595959696968C8C8C7A7A7A5F2500D75400
        EB5C00D45300B14500AA4200AC4300AA4200D5A06FFEFEFCFCF7F3C27738A741
        00AC43009E3E00451B00818181A0A0A0A5A5A59F9F9F97979795959596969695
        9595C9C9C9F5F5F5F2F2F2B4B4B49595959696969292927A7A7A772E00F66000
        F86200FED5AFF8D1ACF4CFABF8D0ABF7CEA6F6CFAAFCF8F6FFFFFFFAF4EECB89
        4FAA4200AA42004F1F00888888A7A7A7A8A8A8E3E3E3E1E1E1E0E0E0E0E0E0DF
        DFDFE0E0E0F3F3F3F6F6F6F0F0F0BDBDBD9595959595957D7D7D893500FF7813
        FF6A04FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFCFFFFFFFFFFFFE6C6
        A7AC4300AA42005722008D8D8DB4B4B4ADADADF6F6F6F6F6F6F6F6F6F6F6F6F6
        F6F6F6F6F6F5F5F5F6F6F6F6F6F6DBDBDB9696969595957F7F7F893500FF8829
        FF801EF48931FC8C32FC8C31FC8C31F88225EDA566FEFBF8FFFFFFE9B88CC75A
        0BB84800A541004B1D008D8D8DBDBDBDB9B9B9BDBDBDBFBFBFBFBFBFBFBFBFBA
        BABACBCBCBF4F4F4F6F6F6D5D5D5A4A4A49999999494947B7B7B893500FF801E
        FFAD67FF6400EE5D00FB6300FB6300FC8B30FCEBDAFFFFFFEAAF79CF5200C54D
        00BB4900953A004B1D008D8D8DB9B9B9D0D0D0A9A9A9A5A5A5A8A8A8A8A8A8BF
        BFBFEDEDEDF6F6F6D0D0D09F9F9F9C9C9C9999999090907B7B7BFF00FFE65A00
        FFC693FF9842E15800EB5C00FB7511FFF8F2FFFFFFF0AC70CF5200CA4F00C04B
        00C74E00752D00FF00FFFF00FFA4A4A4DCDCDCC5C5C5A2A2A2A5A5A5B3B3B3F3
        F3F3F6F6F6CFCFCF9F9F9F9D9D9D9B9B9B9C9C9C878787FF00FFFF00FFE65A00
        FF892BFFDAB7FF9741F86200EA6405FCC695FEB87AE35C01D95500D45300D754
        00B44600752D00FF00FFFF00FFA4A4A4BDBDBDE5E5E5C5C5C5A8A8A8A8A8A8DB
        DBDBD5D5D5A4A4A4A1A1A19F9F9FA0A0A0989898878787FF00FFFF00FFFF00FF
        C54D00FF9842FFE2C6FFBB7FFF8728FF750FFF6B05FF6E08FF6E08FF6701CA4F
        00702C00FF00FFFF00FFFF00FFFF00FF9C9C9CC5C5C5E9E9E9D7D7D7BCBCBCB3
        B3B3ADADADAFAFAFAFAFAFABABAB9D9D9D868686FF00FFFF00FFFF00FFFF00FF
        FF00FFFF801EFF801EFFBA7DFFD5ADFFC591FFB574FFA558FF8323D75400D754
        00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB9B9B9B9B9B9D6D6D6E3E3E3DB
        DBDBD4D4D4CCCCCCBABABAA0A0A0A0A0A0FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFE15800FF700AFF7D19FF7813FB6300B64700FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA2A2A2B0B0B0B7
        B7B7B4B4B4A8A8A8989898FF00FFFF00FFFF00FFFF00FFFF00FF}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = False
      TabOrder = 6
      OnClick = BtnAvancarClick
    end
    object BtnConfirmaCliente: TBitBtn
      Left = 375
      Top = 18
      Width = 88
      Height = 25
      Caption = '  F5'
      Default = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 7
      OnClick = BtnConfirmaClienteClick
    end
  end
  object StgLista: TStringGrid
    AlignWithMargins = True
    Left = 3
    Top = 98
    Width = 753
    Height = 412
    Align = alClient
    ColCount = 1
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColMoving, goRowSelect]
    TabOrder = 1
    OnSelectCell = StgListaSelectCell
  end
end
