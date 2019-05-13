object DBGpConfigForm: TDBGpConfigForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DBGp Configuration'
  ClientHeight = 206
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 356
    Height = 145
    Align = alTop
    Caption = ' Misc '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 54
      Width = 167
      Height = 16
      Caption = 'Maximum depth of elements:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 79
      Width = 146
      Height = 16
      Caption = 'Maximum child elements:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 104
      Width = 138
      Height = 16
      Caption = 'Maximum variable data:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object SpinDepth: TSpinEdit
      Left = 221
      Top = 48
      Width = 121
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object SpinChild: TSpinEdit
      Left = 221
      Top = 76
      Width = 121
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SpinData: TSpinEdit
      Left = 221
      Top = 106
      Width = 121
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object CheckBoxBreakAtFirst: TCheckBox
      Left = 16
      Top = 25
      Width = 323
      Height = 17
      Caption = 'Break at first line when debugging starts'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object BitBtn1: TBitBtn
    Left = 136
    Top = 169
    Width = 93
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 240
    Top = 169
    Width = 99
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = BitBtn2Click
  end
end
