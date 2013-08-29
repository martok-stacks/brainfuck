object fmBFEvo: TfmBFEvo
  Left = 192
  Top = 107
  Width = 563
  Height = 441
  Caption = 'BFevo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbBetValue: TLabel
    Left = 470
    Top = 35
    Width = 51
    Height = 13
    Caption = 'lbBetValue'
  end
  object lbGeneration: TLabel
    Left = 470
    Top = 55
    Width = 60
    Height = 13
    Caption = 'lbGeneration'
  end
  object pbBestValue: TProgressBar
    Left = 5
    Top = 35
    Width = 461
    Height = 16
    Max = 10000
    Smooth = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 5
    Top = 5
    Width = 75
    Height = 25
    Caption = 'Los!'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 110
    Top = 5
    Width = 75
    Height = 25
    Caption = 'Halt!'
    TabOrder = 2
    OnClick = Button2Click
  end
  object meBestCode: TMemo
    Left = 5
    Top = 55
    Width = 461
    Height = 350
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 3
  end
end
