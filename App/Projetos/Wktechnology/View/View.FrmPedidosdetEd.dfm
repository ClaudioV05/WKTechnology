object FrmPedidosdetEd: TFrmPedidosdetEd
  Left = 695
  Top = 237
  BorderIcons = [biSystemMenu]
  ClientHeight = 288
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanSalvar: TPanel
    Left = 0
    Top = 251
    Width = 423
    Height = 37
    Align = alBottom
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object BtnSalvar: TBitBtn
      Left = 26
      Top = 5
      Width = 100
      Height = 27
      Caption = 'Salvar  F12'
      Enabled = False
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnSalvarClick
    end
    object BtnCancelar: TBitBtn
      Left = 132
      Top = 5
      Width = 100
      Height = 27
      Caption = 'Cancelar  Esc'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 423
    Height = 251
    Align = alClient
    BorderStyle = bsNone
    Color = clWhite
    ParentColor = False
    TabOrder = 0
    object LblCodigo: TLabel
      Left = 3
      Top = 61
      Width = 123
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Descri'#231#227'o do produto (*)'
      FocusControl = EdtDescProduto
    end
    object LblPrecounitario: TLabel
      Left = 48
      Top = 115
      Width = 78
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pre'#231'o unit'#225'rio'
    end
    object Label1: TLabel
      Left = 48
      Top = 89
      Width = 78
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Quantidade'
    end
    object EdtDescProduto: TEdit
      Left = 132
      Top = 58
      Width = 286
      Height = 21
      TabStop = False
      CharCase = ecUpperCase
      Color = clBtnFace
      MaxLength = 100
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 0
      OnChange = EditsChange
    end
    object EdtPrecounitario: TEdit
      Left = 132
      Top = 112
      Width = 93
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 2
      Text = '0,00'
      OnChange = EditsChange
    end
    object EdtQuantidade: TEdit
      Left = 132
      Top = 85
      Width = 93
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 1
      Text = '0,00'
      OnChange = EditsChange
    end
  end
end
