object SearchForm: TSearchForm
  Left = 513
  Top = 196
  BorderStyle = bsDialog
  Caption = 'SearchForm'
  ClientHeight = 236
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 236
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 0
    object PageControl: TPageControl
      Left = 2
      Top = 2
      Width = 356
      Height = 232
      ActivePage = FindSheet
      Align = alClient
      TabOrder = 0
      TabStop = False
      OnChange = PageControlChange
      object FindSheet: TTabSheet
        Caption = 'Find'
        object FindBtn: TSpeedButton
          Left = 248
          Top = 72
          Width = 89
          Height = 22
          Caption = 'Find'
          Layout = blGlyphBottom
          OnClick = FindBtnClick
        end
        object CalcBtn: TSpeedButton
          Left = 248
          Top = 104
          Width = 89
          Height = 22
          Caption = 'Calc'
          Layout = blGlyphBottom
          OnClick = CalcBtnClick
        end
        object CloseFindBtn: TSpeedButton
          Left = 248
          Top = 136
          Width = 89
          Height = 22
          Caption = 'Close'
          Layout = blGlyphBottom
          OnClick = CloseFindBtnClick
        end
        object FindLabel: TLabel
          Left = 5
          Top = 12
          Width = 23
          Height = 13
          Caption = 'Find:'
        end
        object FInsBtn: TSpeedButton
          Left = 315
          Top = 8
          Width = 23
          Height = 22
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00B3B3B300A5A5A500A4A4A400A2A2
            A200A1A1A1009F9F9F009E9E9E009D9D9D009C9C9C00B5B5B500BFD3E2004B81
            AC002164980021649800216498002564950059748800F7F7F700F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F3F3F300A0A0A0005689B10063A5
            D70066A8DA0065A6D90063A4D800639FD100768EA400EFEFEF00E7E7E700E7E7
            E700E7E7E700E7E7E700E6E6E600E6E6E600ECECEC00A2A2A2002164980069AB
            DC00498ECF00478BCE004487CD004584C6006985A100F0F0F000B4B4B400B4B4
            B400B4B4B400B4B4B400B4B4B400B3B3B300EDEDED00A3A3A300216498006AAE
            DC004B93D100498FD000478BCE004888C7006D88A300F0F0F000E8E8E800E8E8
            E800E7E7E700E7E7E700E7E7E700E7E7E700EDEDED00A5A5A500216498006CB1
            DE004E97D3004C93D200498FD0004B8CC900708BA500F1F1F100B6B6B600B5B5
            B500B5B5B500B4B4B400B4B4B400B4B4B400EDEDED00A7A7A700216498006EB3
            DF00519CD5004F98D3004C94D1004D91CB00718EA700F1F1F100E9E9E900E9E9
            E900E8E8E800E8E8E800E8E8E800E7E7E700EDEDED00A8A8A8002164980071B5
            E000539FD700519CD6004F98D4005095CD007491AA00F1F1F100B7B7B700B6B6
            B600B6B6B600B6B6B600B5B5B500B5B5B500EEEEEE00AAAAAA002164980074B7
            E10058A3D70054A0D700519DD5005399CF007694AC00F8F8F800F2F2F200F2F2
            F200F2F2F200F2F2F200F2F2F200F1F1F100F4F4F400ACACAC002164980077B9
            E2005DA7D90059A4D80054A0D700549ED500628BA9006588A1006587A1006486
            A0006A879F004B698100AFAFAF00AEAEAE00ACACAC00C3C3C300216498007BBB
            E30062AADB005BA5D90054A0D700539FD700539FD700539FD700539FD700539F
            D70063A3D80021649800FF00FF00FF00FF00FF00FF00FF00FF00216498007DBD
            E40066AEDD0063ABDC005FA8DA005DA7D9005DA7D9005DA7D9005DA7D900539F
            D70063A3D80021649800FF00FF00FF00FF00FF00FF00FF00FF002164980080BF
            E4006AB2DE004B9BDA004597DC004496DC004396DC004395DC004295DB00529E
            D6006DB2DE0021649800FF00FF00FF00FF00FF00FF00FF00FF003C77A50072B4
            DB007FBFE4004F9DDF00B5EEFD0076D4F00076D4F000B5EEFD004C9BDE006FB4
            E00071B5E0002B6B9D00FF00FF00FF00FF00FF00FF00FF00FF00D4E1EC006493
            B800216498003876A400B6EFFE0081DBF30081DBF300B6EFFE002F6FA1002164
            9800709BBD00B7CDDE00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00DBE6EF0021649800216498002164980021649800216498002E6D9F00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          OnClick = FInsBtnClick
        end
        object FindEdit: TEdit
          Left = 56
          Top = 8
          Width = 257
          Height = 21
          TabOrder = 0
          OnChange = FindEditChange
          OnKeyDown = FindEditKeyDown
        end
        object FindFromCursorBox: TCheckBox
          Left = 8
          Top = 72
          Width = 97
          Height = 17
          Caption = 'From Cursor'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = FindFromCursorBoxClick
        end
        object CaseSensitiveFindBox: TCheckBox
          Left = 8
          Top = 96
          Width = 97
          Height = 17
          Caption = 'Case sensitive'
          TabOrder = 2
          OnClick = CaseSensitiveFindBoxClick
        end
        object FindForwardRadio: TRadioButton
          Left = 8
          Top = 128
          Width = 113
          Height = 17
          Caption = 'Forward'
          Checked = True
          TabOrder = 3
          TabStop = True
          OnClick = FindForwardRadioClick
        end
        object FindBackwardRadio: TRadioButton
          Left = 8
          Top = 152
          Width = 113
          Height = 17
          Caption = 'Backward'
          TabOrder = 4
          OnClick = FindBackwardRadioClick
        end
        object FindStatusBar: TStatusBar
          Left = 0
          Top = 185
          Width = 348
          Height = 19
          Panels = <
            item
              Width = 50
            end>
        end
      end
      object ReplaceSheet: TTabSheet
        Caption = 'Replace'
        ImageIndex = 1
        object FindReplLabel: TLabel
          Left = 5
          Top = 12
          Width = 23
          Height = 13
          Caption = 'Find:'
        end
        object ReplaceLabel: TLabel
          Left = 5
          Top = 43
          Width = 43
          Height = 13
          Caption = 'Replace:'
        end
        object ReplaceBtn: TSpeedButton
          Left = 248
          Top = 72
          Width = 89
          Height = 22
          Caption = 'Replace'
          Layout = blGlyphBottom
          OnClick = ReplaceBtnClick
        end
        object ReplaceAllBtn: TSpeedButton
          Left = 248
          Top = 104
          Width = 89
          Height = 22
          Caption = 'Replace All'
          Layout = blGlyphBottom
          OnClick = ReplaceAllBtnClick
        end
        object CloseReplaceBtn: TSpeedButton
          Left = 248
          Top = 136
          Width = 89
          Height = 22
          Caption = 'Close'
          Layout = blGlyphBottom
          OnClick = CloseReplaceBtnClick
        end
        object FRInsBtn: TSpeedButton
          Left = 315
          Top = 8
          Width = 23
          Height = 22
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00B3B3B300A5A5A500A4A4A400A2A2
            A200A1A1A1009F9F9F009E9E9E009D9D9D009C9C9C00B5B5B500BFD3E2004B81
            AC002164980021649800216498002564950059748800F7F7F700F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F3F3F300A0A0A0005689B10063A5
            D70066A8DA0065A6D90063A4D800639FD100768EA400EFEFEF00E7E7E700E7E7
            E700E7E7E700E7E7E700E6E6E600E6E6E600ECECEC00A2A2A2002164980069AB
            DC00498ECF00478BCE004487CD004584C6006985A100F0F0F000B4B4B400B4B4
            B400B4B4B400B4B4B400B4B4B400B3B3B300EDEDED00A3A3A300216498006AAE
            DC004B93D100498FD000478BCE004888C7006D88A300F0F0F000E8E8E800E8E8
            E800E7E7E700E7E7E700E7E7E700E7E7E700EDEDED00A5A5A500216498006CB1
            DE004E97D3004C93D200498FD0004B8CC900708BA500F1F1F100B6B6B600B5B5
            B500B5B5B500B4B4B400B4B4B400B4B4B400EDEDED00A7A7A700216498006EB3
            DF00519CD5004F98D3004C94D1004D91CB00718EA700F1F1F100E9E9E900E9E9
            E900E8E8E800E8E8E800E8E8E800E7E7E700EDEDED00A8A8A8002164980071B5
            E000539FD700519CD6004F98D4005095CD007491AA00F1F1F100B7B7B700B6B6
            B600B6B6B600B6B6B600B5B5B500B5B5B500EEEEEE00AAAAAA002164980074B7
            E10058A3D70054A0D700519DD5005399CF007694AC00F8F8F800F2F2F200F2F2
            F200F2F2F200F2F2F200F2F2F200F1F1F100F4F4F400ACACAC002164980077B9
            E2005DA7D90059A4D80054A0D700549ED500628BA9006588A1006587A1006486
            A0006A879F004B698100AFAFAF00AEAEAE00ACACAC00C3C3C300216498007BBB
            E30062AADB005BA5D90054A0D700539FD700539FD700539FD700539FD700539F
            D70063A3D80021649800FF00FF00FF00FF00FF00FF00FF00FF00216498007DBD
            E40066AEDD0063ABDC005FA8DA005DA7D9005DA7D9005DA7D9005DA7D900539F
            D70063A3D80021649800FF00FF00FF00FF00FF00FF00FF00FF002164980080BF
            E4006AB2DE004B9BDA004597DC004496DC004396DC004395DC004295DB00529E
            D6006DB2DE0021649800FF00FF00FF00FF00FF00FF00FF00FF003C77A50072B4
            DB007FBFE4004F9DDF00B5EEFD0076D4F00076D4F000B5EEFD004C9BDE006FB4
            E00071B5E0002B6B9D00FF00FF00FF00FF00FF00FF00FF00FF00D4E1EC006493
            B800216498003876A400B6EFFE0081DBF30081DBF300B6EFFE002F6FA1002164
            9800709BBD00B7CDDE00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00DBE6EF0021649800216498002164980021649800216498002E6D9F00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          OnClick = FRInsBtnClick
        end
        object RInsBtn: TSpeedButton
          Left = 315
          Top = 40
          Width = 23
          Height = 22
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00B3B3B300A5A5A500A4A4A400A2A2
            A200A1A1A1009F9F9F009E9E9E009D9D9D009C9C9C00B5B5B500BFD3E2004B81
            AC002164980021649800216498002564950059748800F7F7F700F0F0F000F0F0
            F000F0F0F000F0F0F000F0F0F000F0F0F000F3F3F300A0A0A0005689B10063A5
            D70066A8DA0065A6D90063A4D800639FD100768EA400EFEFEF00E7E7E700E7E7
            E700E7E7E700E7E7E700E6E6E600E6E6E600ECECEC00A2A2A2002164980069AB
            DC00498ECF00478BCE004487CD004584C6006985A100F0F0F000B4B4B400B4B4
            B400B4B4B400B4B4B400B4B4B400B3B3B300EDEDED00A3A3A300216498006AAE
            DC004B93D100498FD000478BCE004888C7006D88A300F0F0F000E8E8E800E8E8
            E800E7E7E700E7E7E700E7E7E700E7E7E700EDEDED00A5A5A500216498006CB1
            DE004E97D3004C93D200498FD0004B8CC900708BA500F1F1F100B6B6B600B5B5
            B500B5B5B500B4B4B400B4B4B400B4B4B400EDEDED00A7A7A700216498006EB3
            DF00519CD5004F98D3004C94D1004D91CB00718EA700F1F1F100E9E9E900E9E9
            E900E8E8E800E8E8E800E8E8E800E7E7E700EDEDED00A8A8A8002164980071B5
            E000539FD700519CD6004F98D4005095CD007491AA00F1F1F100B7B7B700B6B6
            B600B6B6B600B6B6B600B5B5B500B5B5B500EEEEEE00AAAAAA002164980074B7
            E10058A3D70054A0D700519DD5005399CF007694AC00F8F8F800F2F2F200F2F2
            F200F2F2F200F2F2F200F2F2F200F1F1F100F4F4F400ACACAC002164980077B9
            E2005DA7D90059A4D80054A0D700549ED500628BA9006588A1006587A1006486
            A0006A879F004B698100AFAFAF00AEAEAE00ACACAC00C3C3C300216498007BBB
            E30062AADB005BA5D90054A0D700539FD700539FD700539FD700539FD700539F
            D70063A3D80021649800FF00FF00FF00FF00FF00FF00FF00FF00216498007DBD
            E40066AEDD0063ABDC005FA8DA005DA7D9005DA7D9005DA7D9005DA7D900539F
            D70063A3D80021649800FF00FF00FF00FF00FF00FF00FF00FF002164980080BF
            E4006AB2DE004B9BDA004597DC004496DC004396DC004395DC004295DB00529E
            D6006DB2DE0021649800FF00FF00FF00FF00FF00FF00FF00FF003C77A50072B4
            DB007FBFE4004F9DDF00B5EEFD0076D4F00076D4F000B5EEFD004C9BDE006FB4
            E00071B5E0002B6B9D00FF00FF00FF00FF00FF00FF00FF00FF00D4E1EC006493
            B800216498003876A400B6EFFE0081DBF30081DBF300B6EFFE002F6FA1002164
            9800709BBD00B7CDDE00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00DBE6EF0021649800216498002164980021649800216498002E6D9F00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          OnClick = RInsBtnClick
        end
        object FindReplEdit: TEdit
          Left = 56
          Top = 8
          Width = 257
          Height = 21
          TabOrder = 0
          OnChange = FindReplEditChange
        end
        object ReplaceEdit: TEdit
          Left = 56
          Top = 40
          Width = 257
          Height = 21
          TabOrder = 1
        end
        object ReplaceFromCursorBox: TCheckBox
          Left = 8
          Top = 72
          Width = 97
          Height = 17
          Caption = 'From Cursor'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = ReplaceFromCursorBoxClick
        end
        object CaseSensitiveReplaceBox: TCheckBox
          Left = 8
          Top = 96
          Width = 97
          Height = 17
          Caption = 'Case sensitive'
          TabOrder = 3
          OnClick = CaseSensitiveReplaceBoxClick
        end
        object ReplaceForwardRadio: TRadioButton
          Left = 8
          Top = 128
          Width = 113
          Height = 17
          Caption = 'Forward'
          Checked = True
          TabOrder = 4
          TabStop = True
          OnClick = ReplaceForwardRadioClick
        end
        object ReplaceBackwardRadio: TRadioButton
          Left = 8
          Top = 152
          Width = 113
          Height = 17
          Caption = 'Backward'
          TabOrder = 5
          OnClick = ReplaceBackwardRadioClick
        end
        object ReplaceStatusBar: TStatusBar
          Left = 0
          Top = 185
          Width = 348
          Height = 19
          Panels = <
            item
              Width = 50
            end>
        end
      end
    end
  end
end
