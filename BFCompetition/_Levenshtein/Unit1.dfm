object Form1: TForm1
  Left = 175
  Top = 88
  Width = 465
  Height = 451
  Caption = 'Damerau Levenshtein Distance'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    457
    417)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 248
    Top = 48
    Width = 76
    Height = 13
    Caption = 'Unterschiede: 0'
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 233
    Height = 21
    MaxLength = 50
    TabOrder = 0
    Text = 'meilenstein'
  end
  object Edit2: TEdit
    Left = 8
    Top = 40
    Width = 233
    Height = 21
    MaxLength = 50
    TabOrder = 1
    Text = 'levenshtein'
  end
  object Button1: TButton
    Left = 248
    Top = 8
    Width = 145
    Height = 25
    Caption = 'Vergleich'
    TabOrder = 2
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 16
    Top = 72
    Width = 433
    Height = 337
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 52
    DefaultColWidth = 32
    DefaultRowHeight = 32
    RowCount = 52
    TabOrder = 3
  end
end
