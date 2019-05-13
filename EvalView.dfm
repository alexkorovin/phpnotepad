object EvalViewForm: TEvalViewForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Eval'
  ClientHeight = 253
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object EvalListView: TListView
    Left = 0
    Top = 0
    Width = 537
    Height = 253
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Value'
        Width = 150
      end
      item
        Caption = 'Type'
        Width = 150
      end>
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
end
