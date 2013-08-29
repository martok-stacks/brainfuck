object fmBF: TfmBF
  Left = 192
  Top = 107
  Width = 870
  Height = 640
  Caption = 'BF'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 580
    Top = 0
    Width = 282
    Height = 613
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 237
      Width = 282
      Height = 19
      Align = alTop
      AutoSize = False
      Caption = 'Datenfelder:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 0
      Top = 117
      Width = 282
      Height = 19
      Align = alTop
      AutoSize = False
      Caption = 'Sprungstack:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 0
      Top = 58
      Width = 282
      Height = 19
      Align = alTop
      AutoSize = False
      Caption = 'Statistik:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object sgTape: TStringGrid
      Left = 0
      Top = 256
      Width = 282
      Height = 357
      Align = alClient
      ColCount = 2
      FixedRows = 0
      TabOrder = 0
    end
    object lbStack: TListBox
      Left = 0
      Top = 136
      Width = 282
      Height = 101
      Align = alTop
      ItemHeight = 13
      TabOrder = 1
    end
    object Panel3: TPanel
      Left = 0
      Top = 77
      Width = 282
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object Label6: TLabel
        Left = 5
        Top = 0
        Width = 54
        Height = 13
        Caption = 'Codel'#228'nge:'
      end
      object Label7: TLabel
        Left = 5
        Top = 15
        Width = 25
        Height = 13
        Caption = 'Takt:'
      end
      object lbCodeLength: TLabel
        Left = 65
        Top = 0
        Width = 60
        Height = 13
      end
      object lbCycle: TLabel
        Left = 65
        Top = 15
        Width = 60
        Height = 13
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 282
      Height = 58
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object btnStart: TButton
        Left = 5
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Start [F9]'
        TabOrder = 0
        OnClick = btnStartClick
      end
      object btnLoad: TButton
        Left = 220
        Top = 5
        Width = 56
        Height = 25
        Caption = 'Laden'
        TabOrder = 1
        OnClick = btnLoadClick
      end
      object cbSteps: TCheckBox
        Left = 90
        Top = 35
        Width = 86
        Height = 17
        Caption = 'Schrittweise'
        TabOrder = 2
      end
      object btnNext: TButton
        Left = 90
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Weiter [F7]'
        TabOrder = 3
        OnClick = btnNextClick
      end
      object cbSlow: TCheckBox
        Left = 5
        Top = 35
        Width = 71
        Height = 17
        Caption = 'Bremsen'
        TabOrder = 4
      end
      object btnSave: TButton
        Left = 220
        Top = 30
        Width = 56
        Height = 25
        Caption = 'Speichern'
        TabOrder = 5
        OnClick = btnSaveClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 580
    Height = 613
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 0
      Top = 415
      Width = 580
      Height = 19
      Align = alBottom
      AutoSize = False
      Caption = 'Ausgabe:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object seInput: TSynEdit
      Left = 0
      Top = 0
      Width = 580
      Height = 415
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 0
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.ShowLineNumbers = True
      Lines.Strings = (
        
          '++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>+' +
          '+.<<'
        '+++++++++++++++.>.+++.------.--------.>+.>. ')
      OnChange = seInputChange
    end
    object pnEnter: TPanel
      Left = 0
      Top = 584
      Width = 580
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object Label3: TLabel
        Left = 0
        Top = 10
        Width = 51
        Height = 13
        Caption = 'Eingabe:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbEnterType: TLabel
        Left = 55
        Top = 10
        Width = 57
        Height = 13
        Caption = 'lbEnterType'
      end
      object edEnter: TEdit
        Left = 125
        Top = 5
        Width = 451
        Height = 21
        TabOrder = 0
        OnKeyDown = edEnterKeyDown
      end
    end
    object seOutput: TSynEdit
      Left = 0
      Top = 434
      Width = 580
      Height = 150
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 2
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Options = [eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoShowSpecialChars, eoSmartTabDelete, eoTabsToSpaces]
      ReadOnly = True
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Brainfuck(*.bf)|*.bf|Alle Dateien|*.*'
    Left = 700
    Top = 100
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Brainfuck(*.bf)|*.bf|Alle Dateien|*.*'
    Left = 730
    Top = 100
  end
end
