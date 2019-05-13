object ShortHelpForm: TShortHelpForm
  Left = 473
  Top = 268
  BorderStyle = bsDialog
  Caption = 'Short Help'
  ClientHeight = 399
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 472
    Height = 399
    Align = alClient
    Color = clWhite
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'F1 - PHP function help'
      'Ctrl+Left Mouse - Follow a link (php classes and '
      'functions)'
      '______________________________________________________'
      'Ctrl+Space - Show Function Box'
      'Shift+Ctrl+U - Block Left'
      'Shift+Ctrl+I - Block Right'
      'Ctrl+Up Arrow - Line Up Scroll'
      'Ctrl+Down Arrow - Line Down Scroll '
      '______________________________________________________'
      'Ctrl+N - New Document'
      'Ctrl+O - Open Document'
      'Ctrl+S - Save Document'
      'Ctrl+Alt+S - Save As Document'
      'Shift+Ctrl+S - Save All Documents'
      'Ctrl+W - Close Document'
      'Shift+Ctrl+W - Close All Documents'
      'Ctrl+P - Print Document'
      'Alt+F4 - Exit'
      '______________________________________________________'
      'Ctrl+Z - Undo'
      'Shift+Ctrl+Z - Redo'
      'Ctrl+X - Cut'
      'Ctrl+C - Copy'
      'Ctrl+V - Paste'
      'Del - Delete'
      'Ctrl+A - Undo'
      '______________________________________________________'
      'Ctrl+F - Find'
      'Ctrl+R - Replace'
      '______________________________________________________')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
