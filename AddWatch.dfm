object AddWatchForm: TAddWatchForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add watch'
  ClientHeight = 69
  ClientWidth = 323
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
  object CancelBtn: TSpeedButton
    Left = 121
    Top = 39
    Width = 89
    Height = 22
    Caption = 'Cancel'
    OnClick = CancelBtnClick
  end
  object OkBtn: TSpeedButton
    Left = 216
    Top = 39
    Width = 94
    Height = 22
    Caption = 'Ok'
    OnClick = OkBtnClick
  end
  object WatchEdit: TEdit
    Left = 8
    Top = 8
    Width = 302
    Height = 21
    TabOrder = 0
  end
end
