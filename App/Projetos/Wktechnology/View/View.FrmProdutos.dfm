object FrmProdutos: TFrmProdutos
  Left = 0
  Top = 0
  ClientHeight = 513
  ClientWidth = 759
  Color = clWindow
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
    Left = 0
    Top = 0
    Width = 150
    Height = 513
    Align = alLeft
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 304
    object BtnConfirmar: TBitBtn
      Left = 10
      Top = 16
      Width = 130
      Height = 33
      Caption = 'Confirmar'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnConfirmarClick
    end
  end
  object StgLista: TStringGrid
    Left = 150
    Top = 0
    Width = 609
    Height = 513
    Align = alClient
    ColCount = 1
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColMoving, goRowSelect]
    PopupMenu = mnuGrid
    TabOrder = 1
    OnSelectCell = StgListaSelectCell
  end
  object mnuGrid: TPopupMenu
    Left = 304
    Top = 184
    object mniCopiar: TMenuItem
      Caption = '&Copiar'
      OnClick = mniCopiarClick
    end
    object mniOrdenar: TMenuItem
      Caption = '&Ordenar pela coluna selecionada'
      OnClick = mniOrdenarClick
    end
  end
end
