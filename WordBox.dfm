object WordBoxForm: TWordBoxForm
  Left = 488
  Top = 141
  BiDiMode = bdLeftToRight
  BorderStyle = bsNone
  Caption = 'WordBoxForm'
  ClientHeight = 147
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  ParentBiDiMode = False
  Position = poDefault
  PrintScale = poNone
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 243
    Height = 147
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clOlive
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnMouseDown = PanelMouseDown
    OnMouseMove = PanelMouseMove
    OnMouseUp = PanelMouseUp
    OnResize = PanelResize
  end
end
