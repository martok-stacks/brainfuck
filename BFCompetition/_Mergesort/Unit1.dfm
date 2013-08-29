object Form1: TForm1
  Left = 227
  Top = 103
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    862
    613)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 20
    Top = 45
    Width = 356
    Height = 561
    Anchors = [akLeft, akTop, akBottom]
  end
  object Image2: TImage
    Left = 380
    Top = 45
    Width = 356
    Height = 561
    Anchors = [akLeft, akTop, akBottom]
  end
  object Label1: TLabel
    Left = 740
    Top = 45
    Width = 105
    Height = 52
    Caption = 'Zuf'#228'llig entdeckt:'#13#10#13#10'Gr'#252'ne Linie = perfekte'#13#10'Zufallsdaten'
  end
  object Button1: TButton
    Left = 20
    Top = 15
    Width = 75
    Height = 25
    Caption = 'Randomfill'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 380
    Top = 10
    Width = 75
    Height = 25
    Caption = 'MS'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 660
    Top = 15
    Width = 75
    Height = 25
    Caption = 'Try'
    TabOrder = 2
    OnClick = Button3Click
  end
end
