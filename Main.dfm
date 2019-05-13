object MainFormPND: TMainFormPND
  Left = 0
  Top = 0
  Caption = 'PHPNotepad'
  ClientHeight = 558
  ClientWidth = 953
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnAfterMonitorDpiChanged = FormAfterMonitorDpiChanged
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object LeftSplitter: TSplitter
    Left = 200
    Top = 52
    Height = 333
    MinSize = 150
    ExplicitHeight = 485
  end
  object BottomSplitter: TSplitter
    Left = 0
    Top = 385
    Width = 953
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    MinSize = 150
    Visible = False
    ExplicitTop = 315
    ExplicitWidth = 961
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 538
    Width = 953
    Height = 20
    Panels = <
      item
        Bevel = pbRaised
        Width = 100
      end
      item
        Bevel = pbRaised
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object LeftPanel: TPanel
    Left = 0
    Top = 52
    Width = 200
    Height = 333
    Align = alLeft
    BevelOuter = bvLowered
    Caption = 'LeftPanel'
    UseDockManager = False
    TabOrder = 1
    OnResize = LeftPanelResize
    object PageControl: TPageControl
      Left = 1
      Top = 1
      Width = 198
      Height = 331
      ActivePage = ClassViewSheet
      Align = alClient
      TabOrder = 0
      TabPosition = tpBottom
      object ClassViewSheet: TTabSheet
        Caption = 'Class View'
        object ClassTreeView: TTreeView
          Left = 0
          Top = 0
          Width = 190
          Height = 305
          Align = alClient
          DoubleBuffered = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          Images = TreeImageList
          Indent = 19
          ParentDoubleBuffered = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          OnDblClick = ClassTreeViewDblClick
          Items.NodeData = {
            030400000024000000000000000000000000000000FFFFFFFF00000000000000
            0007000000010350004800500030000000010000000100000001000000FFFFFF
            FF010000000000000000000000010943006F006E007300740061006E00740073
            0030000000020000000200000002000000FFFFFFFF0200000000000000000000
            0001095600610072006900610062006C00650073002C00000003000000030000
            0003000000FFFFFFFF030000000000000000000000010743006C006100730073
            006500730030000000040000000400000004000000FFFFFFFF04000000000000
            00000000000109460075006E006300740069006F006E0073002A000000070000
            000700000007000000FFFFFFFF07000000000000000000000001065400720061
            0069007400730032000000080000000800000008000000FFFFFFFF0800000000
            00000000000000010A49006E00740065007200660061006300650073002E0000
            00090000000900000009000000FFFFFFFF090000000000000000000000010849
            006E0063006C007500640065007300260000000E0000000E0000000E000000FF
            FFFFFF0E00000000000000010000000104480054004D004C002E000000090000
            000900000009000000FFFFFFFF090000000000000000000000010849006E0063
            006C007500640065007300320000000B0000000B0000000B000000FFFFFFFF0B
            0000000000000003000000010A4A006100760061005300630072006900700074
            0030000000020000000200000002000000FFFFFFFF0200000000000000000000
            0001095600610072006900610062006C00650073002C00000003000000030000
            0003000000FFFFFFFF030000000000000000000000010743006C006100730073
            006500730030000000040000000400000004000000FFFFFFFF04000000000000
            00000000000109460075006E006300740069006F006E007300240000000C0000
            000C0000000C000000FFFFFFFF0C000000000000000100000001034300530053
            00300000000F0000000F0000000F000000FFFFFFFF0F00000000000000000000
            000109530065006C006500630074006F0072007300}
        end
      end
      object FileExplorerSheet: TTabSheet
        Caption = 'File Explorer'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 205
      end
    end
  end
  object ToolPanel: TPanel
    Left = 0
    Top = 0
    Width = 953
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object ToolBar: TToolBar
      Left = 0
      Top = 0
      Width = 953
      Height = 29
      Caption = 'ToolBar'
      Images = ImageList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object NewBtn: TToolButton
        Left = 0
        Top = 0
        Hint = 'New'
        ImageIndex = 12
        OnClick = NewBtnClick
      end
      object OpenBtn: TToolButton
        Left = 23
        Top = 0
        Hint = 'Open'
        ImageIndex = 14
        OnClick = OpenBtnClick
      end
      object SaveBtn: TToolButton
        Left = 46
        Top = 0
        Hint = 'Save'
        Enabled = False
        ImageIndex = 11
        OnClick = SaveBtnClick
      end
      object SaveAllBtn: TToolButton
        Left = 69
        Top = 0
        Hint = 'Save All'
        Enabled = False
        ImageIndex = 10
        OnClick = SaveAllBtnClick
      end
      object CloseBtn: TToolButton
        Left = 92
        Top = 0
        Hint = 'Close'
        Enabled = False
        ImageIndex = 9
        OnClick = CloseBtnClick
      end
      object CloseAllBtn: TToolButton
        Left = 115
        Top = 0
        Hint = 'Close All'
        Enabled = False
        ImageIndex = 8
        OnClick = CloseAllBtnClick
      end
      object Sep_1: TToolButton
        Left = 138
        Top = 0
        Width = 8
        ImageIndex = 16
        Style = tbsSeparator
      end
      object CutBtn: TToolButton
        Left = 146
        Top = 0
        Hint = 'Cut'
        Enabled = False
        ImageIndex = 7
        OnClick = CutBtnClick
      end
      object CopyBtn: TToolButton
        Left = 169
        Top = 0
        Hint = 'Copy'
        Enabled = False
        ImageIndex = 6
        OnClick = CopyBtnClick
      end
      object PasteBtn: TToolButton
        Left = 192
        Top = 0
        Hint = 'Paste'
        Enabled = False
        ImageIndex = 5
        OnClick = PasteBtnClick
      end
      object UndoBtn: TToolButton
        Left = 215
        Top = 0
        Hint = 'Undo'
        Enabled = False
        ImageIndex = 4
        OnClick = UndoBtnClick
      end
      object RedoBtn: TToolButton
        Left = 238
        Top = 0
        Hint = 'Redo'
        Enabled = False
        ImageIndex = 3
        OnClick = RedoBtnClick
      end
      object Sep_2: TToolButton
        Left = 261
        Top = 0
        Width = 8
        ImageIndex = 14
        Style = tbsSeparator
      end
      object FindBtn: TToolButton
        Left = 269
        Top = 0
        Hint = 'Find'
        Enabled = False
        ImageIndex = 2
        OnClick = FindBtnClick
      end
      object ReplaceBtn: TToolButton
        Left = 292
        Top = 0
        Hint = 'Replace'
        Enabled = False
        ImageIndex = 1
        OnClick = ReplaceBtnClick
      end
      object Sep_3: TToolButton
        Left = 315
        Top = 0
        Width = 8
        ImageIndex = 14
        Style = tbsSeparator
      end
      object ZoomInBtn: TToolButton
        Left = 323
        Top = 0
        Hint = 'Zoom In'
        Caption = 'ZoomInBtn'
        ImageIndex = 15
        OnClick = ZoomInBtnClick
      end
      object ZoomOutBtn: TToolButton
        Left = 346
        Top = 0
        Hint = 'Zoom Out'
        Caption = 'ZoomOutBtn'
        ImageIndex = 16
        OnClick = ZoomOutBtnClick
      end
      object Sep_4: TToolButton
        Left = 369
        Top = 0
        Width = 8
        Caption = 'Sep_4'
        ImageIndex = 14
        Style = tbsSeparator
      end
      object DebBtn: TToolButton
        Left = 377
        Top = 0
        Hint = 'Debug'
        Caption = 'DebBtn'
        ImageIndex = 17
        OnClick = DebBtnClick
      end
      object ToolButton2: TToolButton
        Left = 400
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 14
        Style = tbsSeparator
      end
      object PrintBtn: TToolButton
        Left = 408
        Top = 0
        Hint = 'Print'
        Enabled = False
        ImageIndex = 0
        OnClick = PrintBtnClick
      end
      object ExitBtn: TToolButton
        Left = 431
        Top = 0
        Hint = 'Close'
        ImageIndex = 13
        OnClick = ExitBtnClick
      end
    end
  end
  object MainPanel: TPanel
    Left = 203
    Top = 52
    Width = 750
    Height = 333
    Align = alClient
    BevelOuter = bvLowered
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clSilver
    Font.Height = -21
    Font.Name = 'Arial Narrow'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    OnResize = MainPanelResize
    object TabPanel: TPanel
      Left = 1
      Top = 1
      Width = 748
      Height = 20
      Align = alTop
      BevelOuter = bvNone
      Color = 14145495
      ParentBackground = False
      TabOrder = 0
    end
  end
  object ModePanel: TPanel
    Left = 0
    Top = 25
    Width = 953
    Height = 27
    Align = alTop
    BevelOuter = bvLowered
    Color = cl3DLight
    TabOrder = 4
    object ModeBar: TToolBar
      Left = 1
      Top = 1
      Width = 951
      Height = 25
      Align = alClient
      ButtonHeight = 24
      ButtonWidth = 39
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ShowCaptions = True
      TabOrder = 0
      object HTMLBTN: TToolButton
        Left = 0
        Top = 0
        AutoSize = True
        Caption = 'HTML'
        Enabled = False
        Grouped = True
        ImageIndex = 0
        Style = tbsCheck
        OnClick = HTMLBTNClick
      end
      object PHPBTN: TToolButton
        Left = 43
        Top = 0
        Caption = 'PHP'
        Enabled = False
        Grouped = True
        ImageIndex = 1
        Style = tbsCheck
        OnClick = PHPBTNClick
      end
      object JSBTN: TToolButton
        Left = 82
        Top = 0
        Caption = 'JS'
        Enabled = False
        Grouped = True
        ImageIndex = 2
        Style = tbsCheck
        OnClick = JSBTNClick
      end
      object CSSBTN: TToolButton
        Left = 121
        Top = 0
        Caption = 'CSS'
        Enabled = False
        Grouped = True
        ImageIndex = 3
        Style = tbsCheck
        OnClick = CSSBTNClick
      end
      object XMLBTN: TToolButton
        Left = 160
        Top = 0
        Caption = 'XML'
        Enabled = False
        Grouped = True
        ImageIndex = 5
        Style = tbsCheck
        OnClick = XMLBTNClick
      end
      object TXTBTN: TToolButton
        Left = 199
        Top = 0
        Caption = 'TXT'
        Enabled = False
        Grouped = True
        ImageIndex = 4
        Style = tbsCheck
        OnClick = TXTBTNClick
      end
    end
  end
  object LicensePanel: TPanel
    Left = 0
    Top = 385
    Width = 953
    Height = 0
    Align = alBottom
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 5
    Visible = False
    object LicenseAgreeBox: TCheckBox
      Left = 8
      Top = 6
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'I agree'
      TabOrder = 0
      OnClick = LicenseAgreeBoxClick
    end
  end
  object DebugPanel: TPanel
    Left = 0
    Top = 388
    Width = 953
    Height = 150
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    Visible = False
    OnResize = DebugPanelResize
    object DebugPageControl: TPageControl
      Left = 0
      Top = 25
      Width = 953
      Height = 125
      ActivePage = GlobalSheet
      Align = alClient
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      TabPosition = tpBottom
      object GlobalSheet: TTabSheet
        Caption = 'Global context'
        object GlobalTreeView: TTreeView
          Left = 0
          Top = 0
          Width = 945
          Height = 99
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          Indent = 19
          ParentFont = False
          TabOrder = 0
        end
      end
      object LocalSheet: TTabSheet
        Caption = 'Local context'
        DoubleBuffered = True
        ImageIndex = 1
        ParentDoubleBuffered = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object LocalTreeView: TTreeView
          Left = 0
          Top = 0
          Width = 945
          Height = 99
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          Indent = 19
          ParentFont = False
          TabOrder = 0
        end
      end
      object WatchesSheet: TTabSheet
        Caption = 'Watches'
        DoubleBuffered = True
        ImageIndex = 2
        ParentDoubleBuffered = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object WatchesView: TListView
          Left = 0
          Top = 0
          Width = 945
          Height = 99
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
          DoubleBuffered = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ReadOnly = True
          RowSelect = True
          ParentDoubleBuffered = False
          ParentFont = False
          PopupMenu = WatchPopupMenu
          TabOrder = 0
          TabStop = False
          ViewStyle = vsReport
        end
      end
      object StackSheet: TTabSheet
        Caption = 'Stack'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object StackView: TListView
          Left = 0
          Top = 0
          Width = 945
          Height = 99
          Align = alClient
          Columns = <
            item
              Caption = 'Level'
            end
            item
              Caption = 'File'
              Width = 300
            end
            item
              Caption = 'Line'
              Width = 70
            end
            item
              Caption = 'Where'
              Width = 70
            end
            item
              Caption = 'Type'
              Width = 70
            end>
          DoubleBuffered = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ReadOnly = True
          RowSelect = True
          ParentDoubleBuffered = False
          ParentFont = False
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object BreakpointsSheet: TTabSheet
        Caption = 'Breakpoints'
        ImageIndex = 4
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object BreakPointsView: TListView
          Left = 0
          Top = 0
          Width = 945
          Height = 99
          Align = alClient
          Columns = <
            item
              Caption = 'Type'
              Width = 100
            end
            item
              Caption = 'Line No'
              Width = 70
            end
            item
              Caption = 'Hits'
              Width = 70
            end>
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object DebugMenuPanel: TPanel
      Left = 0
      Top = 0
      Width = 953
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      object DebugToolBar: TToolBar
        Left = 0
        Top = 0
        Width = 812
        Height = 25
        Align = alClient
        Caption = 'DebugToolBar'
        Images = DebugImageList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object DebSep: TToolButton
          Left = 0
          Top = 0
          Width = 8
          ImageIndex = 0
          Style = tbsSeparator
        end
        object ListenBtn: TToolButton
          Left = 8
          Top = 0
          Hint = 'Listen'
          ImageIndex = 0
        end
        object ToolButton6: TToolButton
          Left = 31
          Top = 0
          Width = 8
          Caption = 'ToolButton6'
          ImageIndex = 9
          Style = tbsSeparator
        end
        object RunNextBtn: TToolButton
          Left = 39
          Top = 0
          Hint = 'Run'
          Caption = 'RunNextBtn'
          ImageIndex = 2
        end
        object RunToCursorBtn: TToolButton
          Left = 62
          Top = 0
          Hint = 'Run to cursor'
          Caption = 'RunToCursorBtn'
          ImageIndex = 3
        end
        object TraceIntoBtn: TToolButton
          Left = 85
          Top = 0
          Hint = 'Trace Into'
          Caption = 'TraceIntoBtn'
          ImageIndex = 4
        end
        object StepOverBtn: TToolButton
          Left = 108
          Top = 0
          Hint = 'Step Over'
          Caption = 'StepOverBtn'
          ImageIndex = 5
        end
        object StepOutBtn: TToolButton
          Left = 131
          Top = 0
          Hint = 'Step Out'
          Caption = 'StepOutBtn'
          ImageIndex = 6
        end
        object ToolButton7: TToolButton
          Left = 154
          Top = 0
          Width = 8
          Caption = 'ToolButton7'
          ImageIndex = 7
          Style = tbsSeparator
        end
        object AddWatchBtn: TToolButton
          Left = 162
          Top = 0
          Hint = 'Add Watch'
          Caption = 'AddWatchBtn'
          ImageIndex = 7
          OnClick = AddWatchBtnClick
        end
        object EvalBtn: TToolButton
          Left = 185
          Top = 0
          Hint = 'Eval'
          Caption = 'EvalBtn'
          ImageIndex = 8
          OnClick = EvalBtnClick
        end
        object ToolButton1: TToolButton
          Left = 208
          Top = 0
          Width = 8
          Caption = 'ToolButton1'
          ImageIndex = 9
          Style = tbsSeparator
        end
        object DebOptionBtn: TToolButton
          Left = 216
          Top = 0
          Hint = 'Options'
          Caption = 'DebOptionBtn'
          ImageIndex = 9
          OnClick = DebOptionBtnClick
        end
      end
      object DebugInfoPanel: TPanel
        Left = 812
        Top = 0
        Width = 141
        Height = 25
        Align = alRight
        BevelOuter = bvNone
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object MainMenu: TMainMenu
    Images = ImageList
    OwnerDraw = True
    Left = 360
    Top = 104
    object MFile: TMenuItem
      Caption = 'File'
      object ItNew: TMenuItem
        Caption = 'New                                '
        ShortCut = 16462
        OnClick = ItNewClick
      end
      object ItOpen: TMenuItem
        Caption = 'Open'
        ShortCut = 16463
        OnClick = ItOpenClick
      end
      object ItReopen: TMenuItem
        Caption = 'Reopen'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ItSave: TMenuItem
        Caption = 'Save'
        Enabled = False
        ShortCut = 16467
        OnClick = ItSaveClick
      end
      object ItSaveAs: TMenuItem
        Caption = 'Save As'
        Enabled = False
        ShortCut = 49235
        OnClick = ItSaveAsClick
      end
      object ItSaveAll: TMenuItem
        Caption = 'Save All'
        Enabled = False
        ShortCut = 24659
        OnClick = ItSaveAllClick
      end
      object ItClose: TMenuItem
        Caption = 'Close'
        Enabled = False
        ShortCut = 16471
        OnClick = ItCloseClick
      end
      object ItCloseAll: TMenuItem
        Caption = 'Close All'
        Enabled = False
        ShortCut = 24663
        OnClick = ItCloseAllClick
      end
      object ItPrint: TMenuItem
        Caption = 'Print'
        Enabled = False
        ShortCut = 16464
        OnClick = ItPrintClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object ItExit: TMenuItem
        Caption = 'Exit'
        ShortCut = 32883
        OnClick = ItExitClick
      end
    end
    object MEdit: TMenuItem
      Caption = 'Edit'
      object ItUndoItem: TMenuItem
        Caption = 'Undo'
        Enabled = False
        ShortCut = 16474
        OnClick = ItUndoItemClick
      end
      object ItRedoItem: TMenuItem
        Caption = 'Redo'
        Enabled = False
        ShortCut = 24666
        OnClick = ItRedoItemClick
      end
      object ItSep_1: TMenuItem
        Caption = '-'
      end
      object ItCut: TMenuItem
        Caption = 'Cut'
        Enabled = False
        ShortCut = 16472
        OnClick = ItCutClick
      end
      object ItCopy: TMenuItem
        Caption = 'Copy'
        Enabled = False
        ShortCut = 16451
        OnClick = ItCopyClick
      end
      object ItPaste: TMenuItem
        Caption = 'Paste'
        Enabled = False
        ShortCut = 16470
        OnClick = ItPasteClick
      end
      object ItDelete: TMenuItem
        Caption = 'Delete'
        Enabled = False
        ShortCut = 46
        OnClick = ItDeleteClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object ItSelectAll: TMenuItem
        Caption = 'Select All'
        Enabled = False
        ShortCut = 16449
        OnClick = ItSelectAllClick
      end
    end
    object Search: TMenuItem
      Caption = 'Search'
      object ItFind: TMenuItem
        Caption = 'Find...'
        Enabled = False
        ShortCut = 16454
        OnClick = ItFindClick
      end
      object ItReplace: TMenuItem
        Caption = 'Replace...'
        Enabled = False
        ShortCut = 16466
        OnClick = ItReplaceClick
      end
    end
    object Encoding: TMenuItem
      Caption = 'Encoding'
      object ItANSI: TMenuItem
        Caption = 'ANSI'
        GroupIndex = 1
        RadioItem = True
      end
      object ItUTF8WithOutBOM: TMenuItem
        Caption = 'UTF-8'
        GroupIndex = 1
        RadioItem = True
      end
      object ItUTF8: TMenuItem
        Caption = 'UTF-8 BOM'
        GroupIndex = 1
        RadioItem = True
      end
      object ItUCSBigEndian: TMenuItem
        Caption = 'UCS-2 Big Endian'
        GroupIndex = 1
        RadioItem = True
      end
      object ItUCS2LittleEndian: TMenuItem
        Caption = 'UCS-2 Little Endian'
        GroupIndex = 1
        RadioItem = True
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object IttoANSI: TMenuItem
        Caption = 'to ANSI'
        GroupIndex = 1
        OnClick = IttoANSIClick
      end
      object IttoUTF8WithOutBOM: TMenuItem
        Caption = 'to UTF-8'
        GroupIndex = 1
        OnClick = IttoUTF8WithOutBOMClick
      end
      object IttoUTF8: TMenuItem
        Caption = 'to UTF-8 BOM'
        GroupIndex = 1
        OnClick = IttoUTF8Click
      end
      object IttoUCS2BigEndian: TMenuItem
        Caption = 'to UCS-2 Big Endian'
        GroupIndex = 1
        OnClick = IttoUCS2BigEndianClick
      end
      object IttoUCS2LittleEndian: TMenuItem
        Caption = 'to UCS-2 Little Endian'
        GroupIndex = 1
        OnClick = IttoUCS2LittleEndianClick
      end
    end
    object View: TMenuItem
      Caption = 'View'
      object ItPageSeparator: TMenuItem
        Caption = 'Page Separator'
        Checked = True
        OnClick = ItPageSeparatorClick
      end
      object ItDocumentMap: TMenuItem
        Caption = 'Document Map'
        Checked = True
        OnClick = ItDocumentMapClick
      end
      object ItClassView: TMenuItem
        Caption = 'Class View'
        Checked = True
        OnClick = ItClassViewClick
      end
      object ItFileExplorer: TMenuItem
        Caption = 'File Explorer'
        Checked = True
        OnClick = ItFileExplorerClick
      end
      object ItDebugger: TMenuItem
        Caption = 'Debugger'
        OnClick = ItDebuggerClick
      end
      object ItBlockEdging: TMenuItem
        Caption = 'Block Edging'
        Checked = True
        OnClick = ItBlockEdgingClick
      end
      object ItZoomIn: TMenuItem
        Caption = 'Zoom In'
        OnClick = ItZoomInClick
      end
      object ItZoomOut: TMenuItem
        Caption = 'Zoom Out'
        OnClick = ItZoomOutClick
      end
      object itFonts: TMenuItem
        Caption = 'Fonts'
        object itCourierNew: TMenuItem
          Caption = 'Courier New'
          GroupIndex = 2
          RadioItem = True
          OnClick = itCourierNewClick
        end
        object itConsolas: TMenuItem
          Caption = 'Consolas'
          GroupIndex = 2
          RadioItem = True
          OnClick = itConsolasClick
        end
        object ItUbuntuMono: TMenuItem
          Caption = 'Ubuntu Mono'
          GroupIndex = 2
          RadioItem = True
          Visible = False
          OnClick = ItUbuntuMonoClick
        end
      end
      object ItStyleConfigurator: TMenuItem
        Caption = 'Style Configurator'
        OnClick = ItStyleConfiguratorClick
      end
    end
    object Run1: TMenuItem
      Caption = 'XDebug'
      object ItListen: TMenuItem
        Caption = 'Listen'
        OnClick = ItListenClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object ItRun: TMenuItem
        Caption = 'Run'
        ShortCut = 120
        OnClick = ItRunClick
      end
      object ItRunToCursor: TMenuItem
        Caption = 'Run To Cursor'
        ShortCut = 115
        OnClick = ItRunToCursorClick
      end
      object ItTraceInto: TMenuItem
        Caption = 'Trace Into'
        ShortCut = 118
        OnClick = ItTraceIntoClick
      end
      object ItStepOver: TMenuItem
        Caption = 'Step Over'
        ShortCut = 119
        OnClick = ItStepOverClick
      end
      object ItStepOut: TMenuItem
        Caption = 'Step Out'
        ShortCut = 8311
        OnClick = ItStepOutClick
      end
      object ItAddWatch: TMenuItem
        Caption = 'Add Watch'
        ShortCut = 8308
        OnClick = ItAddWatchClick
      end
      object ItEval: TMenuItem
        Caption = 'Evaluate'
        ShortCut = 8309
        OnClick = ItEvalClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object ItDebOptions: TMenuItem
        Caption = 'Options'
        OnClick = ItDebOptionsClick
      end
    end
    object Help: TMenuItem
      Caption = 'Help'
      object PHPNotepad: TMenuItem
        Caption = 'PHPNotepad  Help'
        OnClick = PHPNotepadClick
      end
      object ItHelpLanguage: TMenuItem
        Caption = 'Help Language'
        object ItLangEn: TMenuItem
          AutoCheck = True
          Caption = 'Lang En'
          Checked = True
          GroupIndex = 1
          OnClick = ItLangEnClick
        end
        object ItLangRu: TMenuItem
          AutoCheck = True
          Caption = 'Lang Ru'
          GroupIndex = 1
          OnClick = ItLangRuClick
        end
      end
      object About: TMenuItem
        Caption = 'About...'
        OnClick = AboutClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'PHP Hypertext Preprocessor file (*.php, *.php3, *.php4, *.php5, ' +
      '*.phps, *.phpt, *.phtml)|*.php; *.php3; *.php4; *.php5; *.phps; ' +
      '*.phpt; *.phtml|JavaScript file (*.js, *.jsx, *.jsm, *.ts, *.tsx' +
      ')|*.js; *.jsx; *.jsm; *.ts; *.tsx|JSON file (*.json)|*.json|Hype' +
      'r Text Markup Language file (*.html, *.htm, *.shtml, *.shtm, *.x' +
      'html, *.xht, *.hta)|*.html; *.htm; *.shtml; *.shtm; *.xhtml; *.x' +
      'ht; *.hta|Cascade Style Sheets file (*.css)|*.css|XML file (*.xm' +
      'l)|*.xml|Normal text file (*.txt)|*.txt|All types (*.*)|*.*'
    Left = 288
    Top = 104
  end
  object PopupMenu: TPopupMenu
    Left = 224
    Top = 104
    object pmCut: TMenuItem
      Caption = 'Cut'
      Enabled = False
      ShortCut = 16472
      OnClick = pmCutClick
    end
    object pmCopy: TMenuItem
      Caption = 'Copy'
      Enabled = False
      ShortCut = 16451
      OnClick = pmCopyClick
    end
    object pmPaste: TMenuItem
      Caption = 'Paste'
      Enabled = False
      ShortCut = 16470
      OnClick = pmPasteClick
    end
    object pmDelete: TMenuItem
      Caption = 'Delete'
      Enabled = False
      ShortCut = 46
      OnClick = pmDeleteClick
    end
    object pmSelectAll: TMenuItem
      Caption = 'Select All'
      Enabled = False
      ShortCut = 16449
      OnClick = pmSelectAllClick
    end
  end
  object ImageList: TImageList
    Left = 412
    Top = 105
    Bitmap = {
      494C01011300E805040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F3F2F00096959500DEDDDB000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0F5ED006DC06A00D2E9CF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F9F8F600D6D5D400D1D1CF00D1D1CF008D8D8C006D6D6D00B1B0AF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F9F8F600C8E4C500C0E3BD00C0E3BD0060BC5D0033AA300093CF90000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005284
      AD0021639C006394B5000000000000000000000000000000000000000000DAD9
      D8008A8A8A006D6D6D006D6D6D006D6D6D006D6D6D0083828200F7F6F400E5E5
      E300DEDDDB00000000000000000000000000000000000000000000000000CDE7
      CA005CBA5A0033AA300033AA300033AA300033AA300052B54F00F6F7F300DCEE
      DA00D3E9CF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005A8CB500528C
      BD008CB5DE00185A940000000000000000000000000000000000DAD9D8006E6E
      6E006D6D6D006D6D6D006D6D6D006D6D6D006D6D6D006D6D6D00949493007C7C
      7C0078787800F1F0EE0000000000000000000000000000000000CDE7CA0034AB
      310033AA300033AA300033AA300033AA300033AA300033AA30006AC0670048B3
      450042B04000EEF3EB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006B94BD006394C6009CC6
      E700639CC600296BA500000000000000000000000000F9F8F6008A8A8A006D6D
      6D006D6D6D006D6D6D006D6D6D00717171006D6D6D006D6D6D006D6D6D006D6D
      6D00C4C3C20000000000F5F4F2000000000000000000F9F8F6005CBA5A0033AA
      300033AA300033AA300033AA300038AC360033AA300033AA300033AA300033AA
      3000AEDAAB0000000000F3F6F000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6BD
      AD00D6AD8C00D6A58400D6A57B00CEA58400A59C940073A5CE00ADCEEF0073A5
      CE00397BAD0000000000000000000000000000000000D6D5D4006D6D6D006D6D
      6D006D6D6D006D6D6D00ABAAAA00E1E0DE00797979006D6D6D006D6D6D006D6D
      6D009A999900D1D1CF007B7B7B00DEDDDB0000000000C7E5C40033AA300033AA
      300033AA300033AA30008ACC8800D7EBD30043B1410033AA300033AA300033AA
      300072C36F00C0E3BD0047B24400D3E9CF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DEBDA500EFCE
      AD00F7DECE00F7E7D600F7E7D600F7DEC600DEBD9C00CEA5840084ADD6004A84
      B5000000000000000000000000000000000000000000D0D0CE006D6D6D006D6D
      6D006D6D6D00ABAAAA0000000000E5E5E3007C7C7C006D6D6D006D6D6D006D6D
      6D006D6D6D006E6E6E0076767600DDDCDA0000000000BFE2BC0033AA300033AA
      300033AA30008ACC880000000000DCEEDA0048B3450033AA300033AA300033AA
      300033AA300034AB31003FAF3D00D1E8CE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DECEB500EFCEB500FFEF
      DE00F7DEC600F7D6BD00F7D6B500F7DEC600F7E7D600DEBD9C009C9494000000
      00000000000000000000000000000000000000000000D1D1CF006D6D6D006D6D
      6D0071717100E1E0DE00E5E5E3007C7C7C006E6E6E00B4B4B300797979006D6D
      6D006D6D6D006F6F6F00DDDCDA000000000000000000C0E3BD0033AA300033AA
      300038AC3600D7EBD300DCEEDA0048B3450034AA320098D2950043B1410033AA
      300033AA300036AB3300D1E8CE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFCEAD00F7E7D600F7DE
      CE00F7DEC600F7DEC600F7D6BD007373F7005252F7004A42F7003931EF002921
      EF002118EF002118EF000000000000000000F2F1EF008D8D8C006D6D6D006D6D
      6D006D6D6D00797979007C7C7C006E6E6E00C7C6C50000000000BEBDBC006D6D
      6D006D6D6D00717171000000000000000000EFF4EC0060BC5D0033AA300033AA
      300033AA300043B1410048B3450034AA3200B2DCAF0000000000A5D7A20033AA
      300033AA300038AC360000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFCEAD00FFEFDE00F7DE
      C600F7DEC600F7DEC600F7DEC6006B6BFF0094A5F70094A5F7008C9CEF008494
      EF00848CEF002118EF000000000000000000969595006D6D6D00838282006D6D
      6D006D6D6D006D6D6D006D6D6D00B4B4B30000000000D2D1D000717171006D6D
      6D006D6D6D006D6D6D00F4F3F100F5F4F2006DC06A0033AA300052B54F0033AA
      300033AA300033AA300033AA300098D2950000000000C1E2BF0038AC360033AA
      300033AA300033AA3000F2F5EF00F3F6F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7D6B500FFEFDE00F7DE
      CE00F7DEC600F7DEC600F7DEC6007B84FF006B6BFF006363FF005252F7004A42
      F7003931EF003931EF000000000000000000DEDDDB00B1B0AF00F7F6F4009494
      93006D6D6D006D6D6D006D6D6D0079797900BEBDBC00717171006D6D6D006D6D
      6D006D6D6D006D6D6D006D6D6D0070707000D3E9CF0093CF9000F6F7F3006AC0
      670033AA300033AA300033AA300043B14100A5D7A20038AC360033AA300033AA
      300033AA300033AA300033AA300037AB35000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7D6B500FFEFDE00F7E7
      D600F7DECE00F7DECE00F7DEC600F7DEC600F7DECE00F7E7D600DEB594000000
      0000000000000000000000000000000000000000000000000000E5E5E3007C7C
      7C006D6D6D006D6D6D006D6D6D006D6D6D006D6D6D006D6D6D006D6D6D006D6D
      6D006D6D6D00929291009D9D9C00A0A09F000000000000000000DCEEDA0048B3
      450033AA300033AA300033AA300033AA300033AA300033AA300033AA300033AA
      300033AA300067BF640076C574007BC778000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7D6C600F7DECE00FFEF
      DE00F7E7D600F7DECE00F7DECE00F7E7D600FFEFDE00EFCEB500D6BDAD000000
      0000000000000000000000000000000000000000000000000000DEDDDB007878
      7800C4C3C2009A9999006D6D6D006D6D6D006D6D6D006D6D6D006D6D6D006D6D
      6D009C9C9B00F9F8F60000000000000000000000000000000000D3E9CF0042B0
      4000AEDAAB0072C36F0033AA300033AA300033AA300033AA300033AA300033AA
      300075C57200F9F8F60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFDEC600F7DE
      CE00FFEFDE00FFEFDE00FFEFDE00FFEFDE00F7D6B500DEC6AD00000000000000
      000000000000000000000000000000000000000000000000000000000000F2F1
      EF0000000000D0D0CE006D6D6D006F6F6F00707070006D6D6D006D6D6D009191
      9000F9F8F600000000000000000000000000000000000000000000000000EFF4
      EC0000000000BFE2BC0033AA300036AB330037AB350033AA300033AA300066BE
      6300F9F8F6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7D6
      C600F7D6BD00F7D6B500F7D6B500EFCEB5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F5F4F2007B7B7B0076767600DEDDDB0000000000F3F2F0006D6D6D009C9C
      9B00000000000000000000000000000000000000000000000000000000000000
      0000F3F6F00047B244003FAF3D00D2E9CF0000000000F0F5ED0033AA300075C4
      7300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DEDDDB00DEDDDB000000000000000000F5F4F20070707000A0A0
      9F00000000000000000000000000000000000000000000000000000000000000
      000000000000D3E9CF00D2E9CF000000000000000000F3F6F00037AC34007BC7
      7800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3C1AB00CD8E6700C071
      4000BC6B3700BC6B3700BC6B3700BC6A3700BC6A3600BB6A3500BB6A3500BB69
      3500BE6E3C00CA8B6300E4C3AF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ECF3F700CDDCE900A6C2
      D70081A8C6006494B800175F94001E6497004B94D600328CDE00328CDE00328C
      DE00328CDE00328CDE00328CDE00328CDE00328CDE00328CDE00328CDE00328C
      DE00328CDE004B94D60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C57D4E00F8F2EB00F7EC
      DF00F6EBDE00F6EADE00F6EADC00F6EADC00FAF3EB00FAF3EB00FAF2EA00FCF7
      F300FCF8F400FEFEFD00C37B4E00000000009999990072727200555555005252
      5200505050004D4D4D004B4B4B00484848004646460026689D003375A8003E7D
      AF004884B5004F8ABA003F7FAD0021669900328CDE00DEF7FF009CE7F70094DE
      F70094DEF7008CDEF7008CDEF70084DEF70084DEF7007CD6F70074D6F70074D6
      F700C6EFFF003294DE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2774100F5EBDF00FDBF
      6900FCBD6800FBBE6600FCBE6500FCBE6500FCBD6300FBBD6400FBBC6200FCBE
      6100FCBC6300FDFBF800BD6C380000000000000000000000000059595900A2A2
      A200A2A2A200A3A3A300A4A4A400A4A4A400A5A5A5003070A50079ABD20079AB
      D30074A7D1006AA0CD004180AE0024679B003A94DE00EFF7FF0094E7F7008CDE
      F7008CDEF70084DEF7007CDEF70074DEF70064DEF7005BDEF7004BD6F70043D6
      F700CEF7FF003294DE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005284
      AD0021639C006394B500000000000000000000000000C37D4300F7EDE300FDC2
      6F00FFD8A000FFD79E00FFD69B00FFD79800FFD69600FFD69500FFD59400FFD4
      9300FBBE6600FBF7F400BD6C38000000000000000000000000005D5D5D00A1A1
      A1003D744100A0A1A100A3A3A300A3A3A300A4A4A4003775AA007EAFD4005C9A
      C9005595C7005996C8004281AE00276A9D003A9CDE00F7FFFF0094E7F70094E7
      F70094E7F7008CDEF70084DEF7007CDEF70074DEF7006CDEF7005BDEF7004BD6
      F700CEF7FF003294DE0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005A8CB500528C
      BD008CB5DE00185A9400000000000000000000000000C6814700F7F0E600F8B4
      5600F7B45700F7B55500F8B45400F8B25400F7B35300F7B35300F7B25200F7B2
      5000F7B25000FCF9F500C1743D0000000000000000000000000061616100A0A0
      A0003E77420037723A00A2A2A200A2A2A200A3A3A3003E7AB00082B3D700639F
      CC005B9AC9005F9BCA004481AF002D6EA1003AA5DE00F7FFFF0094E7F70094E7
      F70094E7F70094E7F70094D6E70094D6E70094D6DE0094CED6008CCECE0084C6
      C600CED6D6003294DE00C67C5300CE845B000000000000000000000000000000
      000000000000000000000000000000000000000000006B94BD006394C6009CC6
      E700639CC600296BA500000000000000000000000000C7854900F8F1E800FEE5
      D500FDE5D300FDE5D300FCE5D300FCE5D300FCE4D100FCE2CE00FCE2CC00FBE0
      C900FBE1C800FDFAF700C37B42000000000038823F00357F3C00327A38002F76
      35004A915100478F4D003A743E00A1A1A100A2A2A200467FB40088B7D90068A3
      CF00629ECC00649FCC004683B1003271A5003AA5DE000000000000000000F7FF
      FF00F7FFFF00F7FFFF009CE7F7009CE7F7009CE7F7009CE7F7009CE7F7009CE7
      F700DEF7FF003294DE00FFEFE700CE845300000000000000000000000000D6BD
      AD00D6AD8C00D6A58400D6A57B00CEA58400A59C940073A5CE00ADCEEF0073A5
      CE00397BAD0000000000000000000000000000000000C7864C00F8F2EB00FEE7
      D600FDE7D600FDE7D600FDE7D600FDE6D500FDE5D300FCE4D100FCE2CD00FBE1
      CB00FBE1C900FBF7F200C7814600000000003C87430089CB920084C88D0081C6
      88007CC3830078C18000488F4E003C754000A1A1A1004D84BA008DBBDB006FA8
      D10067A6D10060B4DF004885B1003876A9003AADDE00EFF7FF0074BDE70053AD
      E7004BA5E70094CEEF00FFEFE700000000000000000000000000000000000000
      0000000000003294DE00EFF7EF00CE8453000000000000000000DEBDA500EFCE
      AD00F7DECE00F7E7D600F7E7D600F7DEC600DEBD9C00397B390029733100296B
      39000000000000000000000000000000000000000000C8884E00F9F3EC00FEE8
      D600FEE8D700FDE7D600FDE7D600FDE7D500FDE5D300FBE4D000FBE3CC00FADF
      C700FADFC600FAF2EA00C8854900000000003F8B47008FCE99007EC6870079C3
      810074C07D0075C07D007AC281004A905000558058005589BF0094BFDD0076AD
      D40064B8E1004CD4FF00438BB8003E7BAE003AADDE00F7FFFF0094DEF70094DE
      F70064BDEF003294DE003294DE003294DE003294DE003294DE003294DE003294
      DE003294DE003294DE00FFEFE700CE84530000000000DECEB500EFCEB500FFEF
      DE00F7DEC600F7D6BD00F7D6B500F7DEC600F7E7D6003984420052AD73002973
      31000000000000000000000000000000000000000000C88C4F00F9F4ED00FEE8
      D800FEE8D800FEE8D700FEE7D600FDE5D300FCE4D100FBE1CC00FAE0C700F9DD
      C300F8DCC200FAF4ED00C8864C000000000042904B0094D29F0091D09A008DCD
      960089CB920084C88D0052985900427D47009F9F9F005B8EC40098C3E0007DB3
      D70075AFD6005FC4ED004C88B300467FB2003AB5DE00F7FFFF008CDEF70094DE
      F7009CE7F700ADE7F700CE845300FFF7EF00FFE7D600FFE7D600FFE7D600FFE7
      CE00FFE7CE00FFDECE00FFF7EF00CE84530000000000EFCEAD00F7E7D600F7DE
      CE00F7DEC600F7DEC600F7D6BD0063AD63004A9C520052A5630063B57B004294
      5200317B310029733100000000000000000000000000C88C5000F9F4EF00FEE7
      D700FDE7D600FDE7D500FDE6D400FCE6D200FBE1CC00FADFC700F8DCC200F6DA
      BD00F6D8BB00FAF4EF00C8874D000000000045944E0043914C00408D49003E89
      46005EA466005BA0620046834C009E9E9E009E9E9E006192C9009EC7E20083B8
      DA007EB4D7007FB3D7005089B4004C85B8003AB5DE0000000000000000000000
      00000000000000000000E7BD9400FFF7EF00FFE7CE00FFE7CE00FFE7CE00FFE7
      CE00FFDECE00FFDEC600FFEFE700CE84530000000000EFCEAD00FFEFDE00F7DE
      C600F7DEC600F7DEC600F7DEC6005AAD63007BC69C0073BD94006BBD8C0063B5
      84005AB57B00317B3100000000000000000000000000C88D5100F9F4F000FCE6
      D300FCE6D400FDE7D300FCE4D100FBE3CD00FAE0C800F8DCC200F5D6BB00F3D4
      B500F1D2B300F8F4F000C6864D00000000000000000000000000787878009A9A
      9A003E8A46004A8A50009C9C9C009D9D9D009D9D9D006796CC00A2CBE30089BD
      DC0083B9DA0084B9DA00528BB5005389BC004BBDDE0064C6E70064C6E70064C6
      E70064C6E70064C6E700E7BD9400FFF7EF00FFE7CE00FFE7CE00FFE7CE00FFDE
      CE00FFDEC600F7D6BD00FFEFE700CE84530000000000F7D6B500FFEFDE00F7DE
      CE00F7DEC600F7DEC600F7DEC6006BBD6B005AB5630063B57B007BC69C005AA5
      6B00428C4A00428C4A00000000000000000000000000C88D5100F9F5F100FCE3
      CF00FBE4D000FCE4CF00FCE3CD00FAE1CA00F9DDC400F6D9BC00F4E9DF00F7F2
      EC00FBF7F300F5EFE900C38149000000000000000000000000007B7B7B009999
      990053915A00999A99009B9B9B009C9C9C009C9C9C006D9AD000A7CEE5008FC1
      DF0089BDDC008BBDDC00548DB6005B8FC2000000000000000000000000000000
      00000000000000000000E7BD9400FFF7EF00FFE7CE00FFE7CE00FFDECE00FFDE
      C600F7D6BD00F7D6AD00F7EFDE00CE845B0000000000F7D6B500FFEFDE00F7E7
      D600F7DECE00F7DECE00F7DEC600F7DEC600F7DECE005AB5630084CEA5004AA5
      52000000000000000000000000000000000000000000C88E5300F9F5F100FCE3
      CD00FBE3CE00FBE3CD00FBE2CB00F9E0C800F8DCC200F5D6BA00FDFBF800FCE6
      CD00FAE5C900E2B68400D6A885000000000000000000000000007E7E7E009999
      9900999999009A9A9A009A9A9A009B9B9B009B9B9B00709DD300AAD1E700ABD1
      E70098C7E10091C2DE00578FB7006193C6000000000000000000000000000000
      00000000000000000000E7BD9400FFF7EF00FFDECE00FFDECE00FFDEC600F7D6
      BD00F7EFDE00FFEFE700FFF7EF00CE84530000000000E7D6C600F7DECE00FFEF
      DE00F7E7D600F7DECE00F7DECE00F7E7D600FFEFDE006BBD73005AB563005AAD
      63000000000000000000000000000000000000000000CA925B00FAF6F200FAE0
      C700FBE1C900FBE2C900FBE0C800F9DFC500F8DBC100F4D6B800FFFBF800F6D8
      B400E1B07E00DC966A0000000000000000000000000000000000818181007F7F
      7F007D7D7D007B7B7B00787878007676760073737300729ED400709ED60087B2
      DC00ABD3E800A9D0E6005990B8006798CB000000000000000000000000000000
      00000000000000000000E7BD9400FFEFE700FFDEC600FFDEC600FFDEC600F7D6
      B500FFF7EF00FFDEC600EFC69400C6A584000000000000000000EFDEC600F7DE
      CE00FFEFDE00FFEFDE00FFEFDE00FFEFDE00F7D6B500DEC6AD00000000000000
      00000000000000000000000000000000000000000000D2A27500F8F3EE00F8F4
      EE00F8F4ED00F8F3ED00F8F3ED00F8F3ED00F8F2EC00F7F2EC00F2E6D700E2B2
      7E00DD996C000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000085AC
      DC006E9CD40085B1DA005B91B9006E9CD0000000000000000000000000000000
      00000000000000000000E7BD940000000000FFEFE700FFEFE700FFEFE700F7EF
      DE00FFEFE700EFBD8C00CE9C7C0000000000000000000000000000000000E7D6
      C600F7D6BD00F7D6B500F7D6B500EFCEB5000000000000000000000000000000
      00000000000000000000000000000000000000000000E8CFBA00D7AB7D00CC94
      5B00CA915600CA905500CA905500CA915500CB905500C98F5500CF9D6A00DEB2
      9000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B1CAE8006D9CD300719ED2000000000000000000000000000000
      00000000000000000000EFC69C00E7BD9400E7BD9400E7BD9400D6A57400D6A5
      7400CE9C7400C6A58C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D9AB8E00BC6B3A00BD6E3D00BD6E3C00BD6E3C00BD6E
      3C00BB6A3800BB6A3800C6825900E2C1AA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE957000BD744300B769
      3600B5693600B4683500B2673500B0663400AE653400AC643300AA633300A962
      3300A8613200A8613300AB693D00BD8662000000000000000000000000000000
      00000000000000000000D2976A00FBF3EC00FBF3EC00FBF3EC00FBF3EC00FBF3
      EC00FBF3EC00FBF3EC00FBF3EC00C1794C00000000000000000000000000CFCE
      FB00FAFAFF00000000000000000000000000000000000000000000000000F9F9
      FF00C7C6F8000000000000000000000000000000000000000000000000000000
      000000000000CA8B6200C3845900D38B6900E18F7100DC8D6D00DA8B6E00D78A
      6F00CD8B6D00AB6E4500A6602F0000000000C37E5000EBC6AD00EAC5AD00FEFB
      F800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFB
      F800FEFBF800C89A7D00C7987A00AE6C40000000000000000000000000005E57
      E800BC6B3A00F7F2F300CD864700F8B76300F6BF7900F1B16E00FABE6400FABF
      6700473EDB00FBB95700FBEBD000C07443000000000000000000D2D1FC00504D
      F2004240ED00FAFAFF0000000000000000000000000000000000F9F9FF002725
      E4003230EA00C7C6F80000000000000000000000000000000000000000000000
      000000000000C6835600EFCEBA00DDFFFF0087EEC700A2F4D700A2F6D7008CEE
      C700E0FFFF00DDA28500AB6B3F0000000000BB6C3900EDCAB300E0A27B00FEFA
      F70063C0880063C0880063C0880063C0880063C0880063C0880063C0880063C0
      8800FDF9F600CA8D6600C99B7D00A861330000000000000000006A68F600706A
      EF006359E300BC6B3A00F4EDEC00F8B76300F6BF7900F8F1F000FABE6400554D
      E3005F57E600473EDB00FBEBD000C074430000000000D4D4FD005957F5006462
      FA005956F6004442ED00FAFAFF000000000000000000FAF9FF002F2DE6004240
      F1004D4BF6003230EA00C7C6F80000000000000000000000000000000000D19A
      7600CB946E00C3805200EFB69A00EAF3E80052BF840070C9980072C9990055BF
      8400E4F4E900DD9C7C00AA6A3B0000000000BB6D3900EECCB600E1A27B00FEFA
      F700BFDCC200BFDCC200BFDCC200BFDCC200BFDCC200BFDCC200BFDCC200BFDC
      C200FDF9F600CD906900CC9E8100A86233000000000000000000000000007169
      EB00807FFD006B67F500CF763700ECAB7600F7F1F000DE8D48005A54E900736E
      F5005D56E900F7C58900FBEDDC00C47E4A0000000000E4E3FE005C59F6006663
      FA007271FF005A57F6004543EE00FAFAFF00FAFAFF003835E9004846F2006463
      FF004B49F400302EE900DBDAFB0000000000000000000000000000000000CE94
      6C00F1D5C300C4815500EAB69700F3F3EA00EDF1E600EFF1E600EFF0E600EDF1
      E500F3F5ED00D59C7A00B071450000000000BB6C3900EFCEB800E1A27A00FEFA
      F70063C0880063C0880063C0880063C0880063C0880063C0880063C0880063C0
      8800FDF9F600CF936B00CEA38400AA62330000000000D9AB8E00BC6B3A00CD86
      4700746CEC008179F0006A61E800FADFCF00F9DECA006158E600766FF100625D
      EF00FCE7D900FCE7D900FBF3EC00C6834C000000000000000000E4E4FE005C5A
      F6006764FA007572FF005B59F6004644EE00403EEC00514EF4006968FF00514F
      F5003735EB00DCDCFB00000000000000000000000000D6A48400D09F7C00C784
      5800EFB49900C98B6200E6B59200E2A78100E1A78100DEA37E00DCA17C00DB9F
      7A00D99E7800D49A7400BB7F580000000000BA6B3700EFD0BB00E2A27B00FEFB
      F800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFBF800FEFB
      F800FEFBF800D3966E00D2A78A00AB63330000000000D2976A00FBF3EC00CF76
      3700E8AB5D00756DEA00817BF200817DFA007F7BFA007C74F000675EE700F2C8
      A800FADEC400FADEC400FAF1E600C9895200000000000000000000000000E4E4
      FE005D5BF6006865FA007573FF007471FF00716FFF006F6DFF005856F700403E
      EE00DDDDFC0000000000000000000000000000000000D29E7A00F3D9C900C992
      6B00E1BE9F00CA8D6600EAB89900DDA57F00DDA68100DBA37D00D9A07B00D9A0
      7A00D89F7900D89E7900BF845E0000000000BB6B3700F0D2BE00E2A37B00E2A3
      7B00E1A37B00E2A37C00E1A37C00E0A17900DE9F7800DD9F7700DC9D7500D99B
      7300D8997200D6997100D5AB8E00AD64340000000000CF763700E8AB5D00EDBC
      8300FCE3D300FCE3D300827BEE006A65F8006862F600807AF300F8DDC300F8E0
      CB00F5E3D200F5E3D200FBF3EC00C07D40000000000000000000000000000000
      0000E4E4FE005E5CF7007A77FF005A57FF005855FF007371FF004947F000DFDF
      FC000000000000000000000000000000000000000000D09B7700F3C6B000CE99
      7400D7B89400C8885E00EFBFA100FDFCFA00FEFCFB00FEFDFD00FEFDFC00FDFB
      FA00FDFCFB00DDA88500C180540000000000BB6B3700F2D5C200E3A37B00E3A3
      7B00E2A37C00E2A37C00E2A47C00E1A27A00E0A17900DEA07800DE9E7600DC9D
      7500DA9B7400D99B7400DAB09500AF653400E8AE7100E8A76F00FADFCF00D98F
      3D00FAF4F500F2C79B00867FF100706BFB006C67F9008481FA00FADDC200F7F3
      F400E8CCAF00E8CCAF00EEC7AB00E3C6AE000000000000000000000000000000
      0000FBFBFF005F5CF6007E7AFF005F5CFF005C59FF007775FF004845EF00FAFA
      FF000000000000000000000000000000000000000000D19C7900EFC6AE00D09B
      7700EBC0A400C7865C00EFC09E0000000000CC936F000000000000000000FFFB
      F700FFF8F100E4AF8C00C78A620000000000BB6B3700F2D8C500E3A47C00E3A3
      7B00E3A47B00E2A47C00E2A37C00E1A37C00E1A27A00DFA07800DE9F7700DD9E
      7500DB9C7300DC9D7500DDB59A00B1663500E8AB5D00EDBC8300FCE3D300F6F0
      EE00F9DAB9007F79F4008984F3008B88FD008985FB008683FB006F6CF500EFDF
      D000F7F3F300E2B68700F0D1B70000000000000000000000000000000000FBFB
      FF006865F900716EFB00817FFF007F7CFF007D7AFF007A78FF005F5DF7004A47
      EF00FAFAFF0000000000000000000000000000000000D5A48300ECC5AA00CD8F
      6600EFBEA100CC8D6600F3CDB00000000000E3C7B30000000000000000000000
      000000000000EABFA100C989610000000000BB6C3700F4D9C700E6A67E00C88C
      6500C98D6600C98E6800CB926D00CB926E00CA906A00C88C6600C88C6500C88C
      6500C88C6500DA9C7500E1BA9F00B367350000000000D98F3D00F2C79B00D6A5
      77008581F900938DFB00817CF200D0A17100D1A273007871EC00847EF0006D66
      EB00D9AC82000000000000000000000000000000000000000000FCFBFF00706D
      FC007875FD008682FF007774FC006563F800615EF7006E6BFA007C7AFF00615E
      F7004B48EF00FAFAFF00000000000000000000000000D6A68600EFC7AF00CB8D
      6400EEBF9E00D4976F00D49E7C00D0987200D6A48200CD8E6900CD906A00D09A
      7600D1997400C88B6300EEDDD10000000000BC6C3800F4DCC900E7A77E00F9EC
      E100F9ECE100F9EDE300FCF4EE00FDFAF700FDF7F300FAEDE500F7E7DB00F7E5
      D900F6E5D800DEA07800E4BEA400B468350000000000D98F3D00F2C79B008680
      F0009691FB008A85F900E0BFA100D0A17100D1A27300D1A273007973EC008680
      F2006E68EB00D9AC8200000000000000000000000000FCFCFF007673FE007E7B
      FE008A87FF007D7AFD006D6AFB00E6E5FF00E5E4FE00625FF8006F6DFA007E7B
      FF006260F7004C49F000FCFCFF000000000000000000D4A28000F3CDB500D29C
      7900F4D3BA0000000000E7CFBD00FFFFFE0000000000FBF6F200F8F1EE00EDC8
      AE00D0997500000000000000000000000000BE6E3B00F5DDCC00E7A87F00FAF0
      E800FAF0E800C98D6700FAF0E900FDF8F300FEFAF800FCF4EF00F9E9DF00F7E7
      DB00F7E5D900E0A27900E7C2A900B669360000000000D09658008781F8008A84
      F3008E8AFC00FBF5EC00F7ECDF00F7EBDF00F8EEE400EFDFD000E2B687007D78
      F4008B8AFF007370F900000000000000000000000000EFEFFF007B78FF00817F
      FF00817FFE007572FD00E7E7FF000000000000000000E5E5FE006360F800706E
      FB007F7DFF006360F800B1B0F9000000000000000000D3A07E00F3CEB300DAA5
      8100D4A07E00D6A68400DBB19300D39D7B00D39E7B00D39F7B00D29A7500CF9B
      7700F1E2D700000000000000000000000000C0744300F6DFD000E8A87F00FCF6
      F100FCF6F100C88C6500FAF1E900FBF4EE00FDFAF700FDF9F600FAF0E800F8E8
      DD00F7E6DB00E1A37B00EFD5C300B86A370000000000D6A57700FFE9D7008580
      F500D0A17100D0A17100D1A27300D1A27300D0A07100D5AC8100D9AC82000000
      00007A79FA000000000000000000000000000000000000000000EFEFFF007B78
      FF007A77FE00E8E8FF0000000000000000000000000000000000E5E5FF006562
      F8006B69F9008F8DF700E4E3FE000000000000000000D7A68600F6D8C1000000
      0000E9D3C40000000000000000000000000000000000EFCDB500D5A382000000
      000000000000000000000000000000000000C7825600F6DFD100E9AA8100FEFA
      F600FDFAF600C88C6500FBF3EE00FBF1EA00FCF6F200FEFBF800FCF6F100F9EC
      E200F8E7DB00EED0BA00ECD0BD00BD75440000000000DAB28B00FBF5EC00F7EC
      DF00F7EBDF00F7EBDF00F8EEE400EFDFD000E2B68700F0D1B700000000000000
      000000000000000000000000000000000000000000000000000000000000EFEF
      FF00E9E8FF00000000000000000000000000000000000000000000000000E5E5
      FF00B9B8FC00D8D7FD00000000000000000000000000DDAE8D00DDB39800DAAE
      9000DFB89D00D8A68900D8A88900DAB09300DBAF9100D4A48400F2E4DA000000
      000000000000000000000000000000000000D7A68600F6E0D100F7E0D100FEFB
      F800FEFBF700FDF9F600FCF5F000FAF0EA00FBF2ED00FDF9F600FDFAF700FBF1
      EB00F8E9DF00ECD1BE00CD926B00E3C6B10000000000E0BFA100D0A17100D1A2
      7300D1A27300D1A27300D0A07100D5AC8100D9AC820000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FAFAFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E2BEA700DAAC8E00CA895F00C175
      4400BE6E3B00BC6C3800BB6C3700BB6B3700BB6B3700BC6D3A00BD6F3C00BB6E
      3B00C0754500C98E6600E8CEBD00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A1DB
      E700A2DBE700E8F7FA0000000000000000000000000000000000000000000000
      00000000000000000000B3B3B300A5A5A500A4A4A400A2A2A200A1A1A1009F9F
      9F009E9E9E009D9D9D009C9C9C00B5B5B5000000000000000000000000000000
      00000000000000000000D4967100CC835800C8764600CA7C4E00CB7C4E00CA7C
      4E00CA7C4E00CB7C4F00CB815600CD875D000000000000000000000000000000
      0000000000000000000000000000F6F7FB007279C8003C46CB006068C500E4E5
      F300000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A3DD
      EA0095E6F1005EC3D6000000000000000000BFD3E2004B81AC00216498002164
      9800216498002564950059748800F7F7F700F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F3F3F300A0A0A0000000000000000000000000000000
      00000000000000000000CB835700FCF3EC00FAF1E800FAF0E700FBF1E900FBF2
      EA00FBF2EA00FBF2EB00FDF4EE00CB845900000000000000000000000000E2E3
      F200DBDCEF00FDFDFF0000000000989CD400414CD9004951C8003E48D1006F75
      C800000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEF3
      F80046C5DC0044C5D80092D3E000000000005689B10063A5D70066A8DA0065A6
      D90063A4D800639FD100768EA400EFEFEF00E7E7E700E7E7E700E7E7E700E7E7
      E700E6E6E600E6E6E600ECECEC00A2A2A2000000000000000000000000000000
      00000000000000000000CF825400EFF1E700FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00EFF2E800CE8157000000000000000000A3A7D7003843
      C9003842CF00656CC600E8E9F5006970CC003742CD00E8E9F4007B82CD003A44
      C700ECEDF7000000000000000000000000000000000000000000000000000000
      0000000000000000000001A0C400000000000000000000000000000000000000
      000010ABCB005EDAE90032ACC400000000002164980069ABDC00498ECF00478B
      CE004487CD004584C6006985A100F0F0F000B4B4B400B4B4B400B4B4B400B4B4
      B400B4B4B400B3B3B300EDEDED00A3A3A3000000000000000000000000000000
      00000000000000000000CD855500FBF5EE00FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00FBF6EF00CC84560000000000000000004B54C6004A53
      CF005A62C600404BDD00555EC000525BC2003D47C900FDFDFF009196D2003842
      C800E1E2F2000000000000000000000000000000000000000000000000000000
      00000000000001A0C40001A0C40000000000000000000000000000000000E6F6
      FA0003ACC80089E7F20012A2C20000000000216498006AAEDC004B93D100498F
      D000478BCE004888C7006D88A300F0F0F000E8E8E800E8E8E800E7E7E700E7E7
      E700E7E7E700E7E7E700EDEDED00A5A5A500D79E7C00D3936E00D0885F00D18D
      6500D28D6500D18D6500CA845300FFF7F100FFE9D900FFEADB00FFE9D900FFE7
      D700FFE5D200FFE2CB00FFF7F100CB8656000000000000000000424BC8006970
      C70000000000777DCB004351D200CBA476004250D6007077C700535BCB004952
      C700F6F7FB00000000000000000000000000000000000000000000000000EFF7
      F70001A0C40077EDFB0001A0C4000000000000000000D0EEF500B0E0EA0037B5
      D1006EE6F50077E2EF001AA3C10000000000216498006CB1DE004E97D3004C93
      D200498FD0004B8CC900708BA500F1F1F100B6B6B600B5B5B500B5B5B500B4B4
      B400B4B4B400B4B4B400EDEDED00A7A7A700D2936D00FDF5EF00FBF3EB00FBF2
      EA00FCF3EC00FCF4ED00E4BA9100FFF7F000FFE7D500FDE7D600FDE6D400FCE4
      D000FBE3CB00FADCC200FEF3E800CC8757000000000000000000767CCB003C47
      CC00C8CAE700AFB3DC003C49D400DBBD9C00EECCA600414DDE003B44D1009DA1
      D500000000000000000000000000000000000000000000000000EFF7F70001A0
      C40077EDFB0077EDFB0001A0C40001A0C40001A0C40001A0C40002A9C4006FE1
      EE0010C9DF006AE4F20021A7C20000000000216498006EB3DF00519CD5004F98
      D3004C94D1004D91CB00718EA700F1F1F100E9E9E900E9E9E900E8E8E800E8E8
      E800E8E8E800E7E7E700EDEDED00A8A8A800D6936A00F1F3EA00FFECDE00FFED
      E000FFECDE00FFEADC00E4BB9100FFF7F200FEE7D500FEE7D500FDE5D100FAE0
      CA00F9DEC400F7D9BC00FDF2E700CC8858000000000000000000E1E3F2004E56
      C4003D47CF003E49CD00404DD700D8BC9A00F6EAE100CDAE8400E7DCCB000000
      00000000000000000000000000000000000000000000EFF7F70001A0C40077ED
      FB0005C3DA0077EDFB006AEAF9006AEAF9006AEAF9006AEAF90006DDF7000BC8
      DF0008C2D80070DCEB0026A7C200000000002164980071B5E000539FD700519C
      D6004F98D4005095CD007491AA00F1F1F100B7B7B700B6B6B600B6B6B600B6B6
      B600B5B5B500B5B5B500EEEEEE00AAAAAA00D4956B00FCF6F000FFECDE00FFED
      E000FFECDE00FFEADC00E4BB9200FEF7F100FCE5D200FCE4D100FBE2CC00F9DD
      C400F6D7BB00F3D1AF00FAEFE400CC885900000000000000000000000000E1E3
      F200777ECB00555DC8008086CB00C9AD8800F0E0D000C8AB8400FBF9F6000000
      000000000000000000000000000000000000EFF7F70001A0C4007AEDFB0033E2
      F8002DDFF40005C0D60005C0D60005C0D6001ED2E8001ED2E8001ED2E8000CC8
      DF006BE5F30022AEC70046B4CA00000000002164980074B7E10058A3D70054A0
      D700519DD5005399CF007694AC00F8F8F800F2F2F200F2F2F200F2F2F200F2F2
      F200F2F2F200F1F1F100F4F4F400ACACAC00D2966B00FFF8F300FFECDE00FFED
      E000FFECDE00FFEADC00E4BB9200FEF6F000FCE2CD00FCE3CD00FADFC800F7D9
      BC00F5E9DD00FAF3EB00FBF8F300CA8454000000000000000000000000000000
      000000000000FEFEFF0000000000D5C0A300F6EADD00E1CDB400C5AA86000000
      00000000000000000000000000000000000001A0C400ADF3FB0030E0F60033E2
      F80033E2F70033E2F70030E0F5002ADBF1001ED2E8001ED2E8001ED2E80037D9
      EC0041CDE10047B5CB00F6FBFB00000000002164980077B9E2005DA7D90059A4
      D80054A0D700549ED500628BA9006588A1006587A1006486A0006A879F004B69
      8100AFAFAF00AEAEAE00ACACAC00C3C3C300D3976C00FFF8F200FFEADB00FDEA
      DC00FDE9DA00FDE8D600E4BB9300FEF5ED00FCDEC500FBE0C700F9DCC200F5D3
      B400FEF9F300FAE2C400ECC19300DDB596000000000000000000000000000000
      0000000000000000000000000000D7C2A600F1E2D400D0B69300F5EBE000C9B1
      900000000000000000000000000000000000F6FBFB0001A0C400ADF3FB0030E0
      F60033E2F7002ADBF10030E0F5002ADBF10017CDE30037D9EC006AE7F60042CE
      E3002DADC800CFE6E6000000000000000000216498007BBBE30062AADB005BA5
      D90054A0D700539FD700539FD700539FD700539FD700539FD70063A3D8002164
      980000000000000000000000000000000000D3986D00FFF8F400FEEADB00FEEA
      DB00FDE9D700FBE4D100E5BE9600FFFFFE00FDF3E900FDF3EA00FCF2E800FAEF
      E300FAF2E700EABB8800DEAA8800FCF9F7000000000000000000000000000000
      0000000000000000000000000000D7C3A700EEDFCE00D7C3A800CBB19000E9D8
      C600D6C3AA0000000000000000000000000000000000EFF7F70001A0C400ADF3
      FB0032E1F60021E3FA0074ECFA0070EBFA006FE8F70071E9F7003DB1C8003CB3
      CC00E5F1F200000000000000000000000000216498007DBDE40066AEDD0063AB
      DC005FA8DA005DA7D9005DA7D9005DA7D9005DA7D900539FD70063A3D8002164
      980000000000000000000000000000000000D3986E00FEF8F300FDE9D800FDE8
      D700FCE6D300FAE2CC00EAC39D00E6BF9600E4BB9200E4BB9200D3A47200D2A2
      7300D4A67700E2BEA200FDFBF900000000000000000000000000000000000000
      0000000000000000000000000000D9C5AB00E7D5C100EEE6DA00F4EFE700CBB0
      8F00DAC4A900E3D6C40000000000000000000000000000000000EFF7F70001A0
      C400ADF3FB0026E4FB0001A0C40001A0C4002AAAC40042B2C8006DC3D400F5FA
      FA00000000000000000000000000000000002164980080BFE4006AB2DE004B9B
      DA004597DC004496DC004396DC004395DC004295DB00529ED6006DB2DE002164
      980000000000000000000000000000000000D3986E00FEF7F200FDE6D400FDE7
      D400FBE3CF00F8DEC500F6ECE200FBF5EE00FCF9F500D4A47B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000DAC7AD00DEC9AF00F3EDE50000000000F0E8
      DD00C8AC8700C5A784000000000000000000000000000000000000000000EFF7
      F70001A0C400ADF3FB0001A0C400000000000000000000000000000000000000
      0000000000000000000000000000000000003C77A50072B4DB007FBFE4004F9D
      DF00B5EEFD0076D4F00076D4F000B5EEFD004C9BDE006FB4E00071B5E0002B6B
      9D0000000000000000000000000000000000D3986F00FEF6F000FDE3CD00FCE4
      CF00FAE1CA00F6D9BE00FEFAF500FBE6CC00EFC9A100E2BFA400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000DBC9B000D7BFA200F9F6F200000000000000
      0000EEE6DA00BB9B700000000000000000000000000000000000000000000000
      0000ECF8FB0001A0C40001A0C400000000000000000000000000000000000000
      000000000000000000000000000000000000D4E1EC006493B800216498003876
      A400B6EFFE0081DBF30081DBF300B6EFFE002F6FA10021649800709BBD00B7CD
      DE0000000000000000000000000000000000D49C740000000000FDF5EC00FDF5
      ED00FDF4EB00FBF1E700FBF4EA00EDC49800E2B59800FDFAF800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000DCCAB200D3BA9A00FCFAF800000000000000
      000000000000FDFCFB0000000000000000000000000000000000000000000000
      0000000000000000000001A0C400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DBE6EF002164
      9800216498002164980021649800216498002E6D9F0000000000000000000000
      000000000000000000000000000000000000DAA68500D69E7600D3986D00D399
      6F00D4996F00D3986F00D49A7100E6C6AE00FEFBFA0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000ECE3D600CAAE8900FEFDFB00000000000000
      000000000000000000000000000000000000000000000000000000000000C997
      6400CA986600CA976600CA976600CA976600CA976500C9976500C9976500CA98
      6600C99664000000000000000000000000000000000000000000000000000000
      000019445B002C6289004D8ABE0071A9CD00E4EEF60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E8F7FA00A2DB
      E700A1DBE7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8B8B8008E8E8E0059595900C795
      6200F9F7F600F9F1EC00F9F1EB00F8F0E900F7EDE600F4EAE100F2E8DE00FAF8
      F600C79462002525250067676700B1B1B1000000000000000000000000000000
      00002F68850094C7F90091C9F9004285C900286CAE00D9E7F300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005EC3D60095E6
      F100A3DDEA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006D6D6D00A7A7A700B5B5B5008181
      8100AFACAA00C5C0BD00C5C0BD00C5C0BD00C5C0BD00C5C0BD00C5C0BD00ADAA
      A8002D2D2D00B5B5B5009B9B9B00242424000000000000000000000000000000
      00004489AA00E0F2FF00559AD8001B7BBE004A98C5004181B600000000000000
      000000000000000000000000000000000000000000003F3A35003A3531003430
      2C002D2A260028252200211E1C00E8E8E800343231000C0B0A00080807000505
      0400010101000101010000000000000000000000000092D3E00044C5D80046C5
      DC00DEF3F8000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000071717100B5B5B500B5B5B5009595
      950081818100818181007A7A7A006F6F6F006262620053535300444444004343
      43006F6F6F00B5B5B500B5B5B500262626003F3A35003A35310034302C002D2A
      260097B5C9007BB6D50090B7D10056C9E4005CDFF50079D0ED00509BDB000101
      0100010101000000000000000000000000000000000047423C00857B7100C3B8
      AE007D73690080766C0037332E00F3F3F2004D4B480095897E00BAAEA2007D73
      690080766C000202020000000000000000000000000032ACC4005EDAE90010AB
      CB00000000000000000000000000000000000000000001A0C400000000000000
      00000000000000000000000000000000000076767600BBBBBB00BBBBBB008D8D
      8D00D4D4D400B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900D3D3
      D30083838300BBBBBB00BBBBBB002B2B2B0047423C00857B7100C3B8AE007D73
      690080766C00A4C6D70076B8D600C2F6FD0064DFF7005EE2F8007AD3F0004B99
      DC0002020200000000000000000000000000000000004E48420083797000CCC3
      BA00797066007C72680035312E00000000002D2B280095897E00C2B8AD007970
      66007D7369000706060000000000000000000000000012A2C20089E7F20003AC
      C800E6F6FA000000000000000000000000000000000001A0C40001A0C4000000
      0000000000000000000000000000000000007B7B7B00D7D7D700D7D7D7009797
      9700D8D8D800BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00D7D7
      D7008E8E8E00D7D7D700D7D7D700404040004E48420083797000CCC3BA007970
      66007C72680035312E0089AEBF0078CBE700C7F7FD005FDCF5005BE1F7007CD4
      F1004D9ADE0000000000000000000000000000000000564F490083797000CCC3
      BA007A7167007269600059555100000000004A474600857B7100C2B8AD007970
      66007C7268000E0D0C000000000000000000000000001AA3C10077E2EF006EE6
      F50037B5D100B0E0EA00D0EEF500000000000000000001A0C40077EDFB0001A0
      C400EFF7F7000000000000000000000000007F7F7F00F9F9F900F9F9F900ABAB
      AB00DFDFDF00CBCBCB00CBCBCB00CBCBCB00CBCBCB00CBCBCB00CBCBCB00DFDF
      DF00A3A3A300F9F9F900F9F9F90062626200564F490083797000CCC3BA007A71
      670072696000595551000000000095BDCA007AD3EE00C7F7FD0060DCF5005CE2
      F7007BD6F20051A0E000000000000000000000000000827B77009F928600CCC3
      BA00C0B4AA00A6988B00817D7A00000000007573700090847A00C2B8AD00C0B4
      AA00A89B8E004A48480000000000000000000000000021A7C2006AE4F20010C9
      DF006FE1EE0002A9C40001A0C40001A0C40001A0C40001A0C40077EDFB0077ED
      FB0001A0C400EFF7F700000000000000000087878700FCFCFC00FCFCFC00CBCB
      CB00F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2
      F200C6C6C600FCFCFC00FCFCFC0072727200827B77009F928600CCC3BA00C0B4
      AA00A6988B00817D7A000000000075737000B5DEEB007ED4EE00C4F6FD006DDD
      F6006ECAED0064A3D7006499C900E6F0F800FDFDFD00605A5300433E39005952
      4B003E39340034302C003A383500D4D4D400605F5D001B191700262321001A18
      1600100F0E001313130000000000000000000000000026A7C20070DCEB0008C2
      D8000BC8DF0006DDF7006AEAF9006AEAF9006AEAF9006AEAF90077EDFB0005C3
      DA0077EDFB0001A0C400EFF7F70000000000A7A7A700D2D2D200E8E8E8007E7E
      7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E7E007E7E
      7E007E7E7E00E8E8E800C4C4C4007F7F7F00605A5300433E390059524B003E39
      340034302C003A383500D4D4D400605F5D001B191700B5E6F50081D6EE00B2E3
      F9008BC0E700AED3F600C4E0FC006BA2D500FEFEFE009D918500B1A396008076
      6C007D736900786E65006D645C002F2B27005750490081776D007D736900786E
      650071685F000202020000000000000000000000000046B4CA0022AEC7006BE5
      F3000CC8DF001ED2E8001ED2E8001ED2E80005C0D60005C0D60005C0D6002DDF
      F40033E2F8007AEDFB0001A0C400EFF7F700E4E4E4009A9A9A00CCCCCC00C78B
      4F00F9F4ED00FEE8D800FEE8D700FDE5D300FCE4D100FAE0C700F9DDC300FAF4
      ED00C7854B00C3C3C30075757500D7D7D7009D918500B1A3960080766C007D73
      6900786E65006D645C002F2B27005750490081776D007D736900B1E6F50078BE
      E700B4D2F000E5F3FF00ACD2EF005997CC00FFFEFE00B9ADA100BAAEA2008278
      6E0082786E00AA917C00BAA79400B9A69100B09781009F8D7E00836E5C007264
      580095897E0024242300000000000000000000000000F6FBFB0047B5CB0041CD
      E10037D9EC001ED2E8001ED2E8001ED2E8002ADBF10030E0F50033E2F70033E2
      F70033E2F80030E0F600ADF3FB0001A0C40000000000DADADA008D8D8D00C589
      4D00F9F4EF00FEE7D700FDE7D500FCE6D200FBE1CC00F8DCC200F6DABD00FAF4
      EF00C483490068686800CCCCCC0000000000B9ADA100BAAEA20082786E008278
      6E00AA917C00BAA79400B9A69100B09781009F8D7E00836E5C007264580094BD
      CC0059A5D80085B1DB00479DD000B2D9EF00FEFDFD00DEDBD8009B8E82009D91
      8500867C720057504900514B450081776D006F675E00826D5900A6917E009484
      7500575049008C8B8B0000000000000000000000000000000000CFE6E6002DAD
      C80042CEE3006AE7F60037D9EC0017CDE3002ADBF10030E0F5002ADBF10033E2
      F70030E0F600ADF3FB0001A0C400F6FBFB00000000000000000000000000C88F
      5400F9F4F000FCE6D300FDE7D300FBE3CD00FAE0C800F5D6BB00F3D4B500F8F4
      F000C6884F00000000000000000000000000DEDBD8009B8E82009D918500867C
      720057504900514B450081776D006F675E00826D5900A6917E00948475005750
      49008C8B8B000000000000000000000000000000000000000000756C6300A497
      8A0095897E009F9286003F3A3500000000004D4741007F756B00857B71003F3A
      350086827F00F6F6F6000000000000000000000000000000000000000000E5F1
      F2003CB3CC003DB1C80071E9F7006FE8F70070EBFA0074ECFA0021E3FA0032E1
      F600ADF3FB0001A0C400EFF7F70000000000000000000000000000000000CA91
      5700F9F5F100FCE3CF00FCE4CF00FAE1CA00F9DDC400F4E9DF00F7F2EC00F5EF
      E900C4834C0000000000000000000000000000000000756C6300A4978A009589
      7E009F9286003F3A3500000000004D4741007F756B00857B71003F3A35008682
      7F00F6F6F600FEFEFE0000000000000000000000000000000000000000000000
      00009B928800C3B8AE00665E5600000000007D736900A89B8E00A79B91000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F5FAFA006DC3D40042B2C8002AAAC40001A0C40001A0C40026E4FB00ADF3
      FB0001A0C400EFF7F7000000000000000000000000000000000000000000CA91
      5900F9F5F100FCE3CD00FBE3CD00F9E0C800F8DCC200FDFBF800FCE6CD00E2B6
      8400DFBCA1000000000000000000000000000000000000000000000000009B92
      8800C3B8AE00665E5600000000007D736900A89B8E00A79B9100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A89C9200BCB0A4009D91850000000000AEA093009D9185007C756E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001A0C400ADF3FB0001A0
      C400EFF7F700000000000000000000000000000000000000000000000000C68B
      5100F7F2EC00F8F4EE00F8F3ED00F8F3ED00F8F2EC00F2E6D700E2B27E00DC99
      6F0000000000000000000000000000000000000000000000000000000000A89C
      9200BCB0A4009D91850000000000AEA093009D9185007C756E00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001A0C40001A0C400ECF8
      FB0000000000000000000000000000000000000000000000000000000000EEDA
      CA00DFBB9600C88D5100C88C5000CC955B00CD945B00C58A4E00E6C3A9000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001A0C400000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF00FFFFFF1FFF1F0000FFFFF01FF01F0000
      FFE3E007E0070000FFC3C003C0030000FF83800580050000E007800080000000
      C00F820082000000801F80018001000080030043004300008003008000800000
      8003000000000000801FC000C0000000801FC003C0030000C03FE807E8070000
      E0FFF08FF08F0000FFFFF98FF98F00008001FF800003FFFF800100000003FFFF
      8001C0000003FFE38001C0000003FFC38001C0000000FF83800100006000E007
      8001000001F8C00F800100000000800F8001000000008003800100007C008003
      8001C000000080038001C000FC00800F8001C000FC00800F8003C000FC00C03F
      8007FFE0FD01E0FF800FFFF8FC03FFFFFC00FFFFFFFF8000FC00E7E7F8010000
      E000C3C3F8010000C0008181E0010000E0008001E00100008000C00380010000
      8000E007800100008000F00F800100000000F00F816100000001E00781790000
      8007C00380010000800380018487000080038181800700008017C3C1979F0000
      803FE7E3801F0000807FFFF7FFFF0000FFE3FC00FC00FE0FFFE30000FC00E20F
      FFE10000FC00C007FDF10000FC00C007F9E100000000C807E18100000000C00F
      C00100000000C01F800100000000E01F000100000000FA1F000100000000FE0F
      0003000F0000FE078007000F0001FE03C00F000F003FFE23E1FF000F003FFE33
      F1FF000F403FFE3BFDFFC07F007FFE3FE007F07FFFFFC7FF0000F03FFFFFC7FF
      0000F03F800387FF0000000780038FBF000000078103879F0000000781038187
      0000020381038003000002000003800100000000000380000000000000038000
      800100000003C000E0070007C103E001E0078203F11FF003E007E23FF11FFF87
      E00FE23FFFFFFF8FE01FFFFFFFFFFFBF00000000000000000000000000000000
      000000000000}
  end
  object CloseQueryTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = CloseQueryTimerTimer
    Left = 480
    Top = 105
  end
  object SaveDialog: TSaveDialog
    Filter = 
      'PHP Hypertext Preprocessor file (*.php, *.php3, *.php4, *.php5, ' +
      '*.phps, *.phpt, *.phtml)|*.php; *.php3; *.php4; *.php5; *.phps; ' +
      '*.phpt; *.phtml|JavaScript file (*.js, *.jsx, *.jsm, *.ts, *.tsx' +
      ')|*.js; *.jsx; *.jsm; *.ts; *.tsx|JSON file (*.json)|*.json|Hype' +
      'r Text Markup Language file (*.html, *.htm, *.shtml, *.shtm, *.x' +
      'html, *.xht, *.hta)|*.html; *.htm; *.shtml; *.shtm; *.xhtml; *.x' +
      'ht; *.hta|Cascade Style Sheets file (*.css)|*.css|XML file (*.xm' +
      'l)|*.xml|Normal text file (*.txt)|*.txt|All types (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialogTypeChange
    Left = 556
    Top = 105
  end
  object PrintDialog: TPrintDialog
    Left = 620
    Top = 103
  end
  object TreeImageList: TImageList
    Left = 683
    Top = 100
    Bitmap = {
      494C01011000D000040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6BC
      BC00B2A4A500AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E
      9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6BC
      BC00B2A4A500AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E
      9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300F9F5F500F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3
      F400F9F3F400F9F3F400FAF6F700AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300F9F5F500F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3
      F400F9F3F400F9F3F400FAF6F700AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F1EBEC00F0EAEB00F0EAEB00F0EAEB00F0EAEB00F1EBEC00F5EFF000F7F1
      F200F7F1F200F7F1F200F9F4F500AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F0EAEB00F0EAEB00F0EAEB00F1EBEC00F1EBEC00F1EBEC00F5EFF000F7F1
      F200F7F1F200F7F1F200F9F4F500AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000069373C0060292E0060292E006029
      2E0060292E0069373C0069373C0069373C0069373C0069373C00F3EDEE00F3ED
      EE00F9F3F400F9F3F400FAF5F600AC9E9F000000000000000000000000000000
      0000000000008080800080808000808080000000000000000000000000000000
      00000000000000000000000000000000000069373C0060292E00FFFFFF00FFFF
      FF0069373C0069373C00FFFFFF00FFFFFF0069373C0069373C00F3EDEE00F3ED
      EE00F9F3F400F9F3F400FAF5F600AC9E9F000000000000000000000000000000
      0000000000007FABD6007F7F7F00D6AB7F007FABD6007F7F7F00D6AB7F000000
      0000000000000000000000000000000000006B393E0083474E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0083474E0083474E0083474E00F1EDED00F1ED
      ED00F9F5F500F9F5F500FAF6F600AC9E9F000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000808080008080
      8000808080008080800000000000000000006B393E0083474E00FFFFFF00FFFF
      FF0083474E0083474E00FFFFFF00FFFFFF0083474E0083474E00F1EDED00F1ED
      ED00F9F5F500F9F5F500FAF6F600AC9E9F000000000000000000000000000000
      0000C1EBFF007F7F9500FFD6AB000000000000000000ABD6FF00957F7F00FFEB
      C10000000000000000000000000000000000713D430083474E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0083474E0083474E0083474E00F2EEEE00F2EE
      EE00FAF6F600FAF6F600FBF8F900AC9E9F000000000000000000000000000000
      000000FFFF0000FFFF0000808000000000008080800000FFFF0000FFFF0000FF
      FF0000FFFF00808080000000000000000000713D430083474E00FFFFFF00FFFF
      FF0083474E0083474E00FFFFFF00FFFFFF0083474E0083474E00F2EEEE00F2EE
      EE00FAF6F600FAF6F600FBF8F900AC9E9F000000000000000000000000000000
      0000ABD6FF007F7F7F00FFD6AB000000000000000000ABD6FF007F7F7F00FFD6
      AB0000000000000000000000000000000000764147008D505700FFFFFF00FFFF
      FF008D505700FFFFFF00FFFFFF008D5057008D5057008D505700F4F1F100F4F1
      F100FCF9F900FCF9F900FCFAFA00AC9E9F0000000000000000000000000000FF
      FF0000FFFF0000FFFF000080800000000000808080000080800000FFFF0000FF
      FF0000FFFF00808080000000000000000000764147008D505700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0083474E008D505700F4F1F100F4F1
      F100FCF9F900FCF9F900FCFAFA00AC9E9F000000000000000000000000000000
      0000ABD6FF007F7F7F00FFD6AB000000000000000000ABD6FF007F7F7F00FFD6
      AB00000000000000000000000000000000007B464C008D505700FFFFFF00FFFF
      FF008D5057008D5057008D5057008D5057008D5057008D505700F5F3F400F5F3
      F400FDFBFC00FDFBFC00FDFBFB00AC9E9F00000000008080800000FFFF0000FF
      FF0000FFFF00808080000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF008080800000000000000000007B464C008D505700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0083474E008D505700F5F3F400F5F3
      F400FDFBFC00FDFBFC00FDFBFB00AC9E9F000000000000000000000000000000
      000095C1EB00AB7F7F00FFFFD6000000000000000000D6FFFF007F7FAB00EBC1
      95000000000000000000000000000000000080494F0095575E00FFFFFF00FFFF
      FF0095575E0095575E0095575E0095575E0095575E0095575E00F5F4F400F5F4
      F400FDFCFC00FDFCFC00FEFDFE00AC9E9F0000000000000000008080800000FF
      FF0080808000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0080808000000000000000000080494F0095575E00FFFFFF00FFFF
      FF008D5057008D505700FFFFFF00FFFFFF008D50570095575E00F5F4F400F5F4
      F400FDFCFC00FDFCFC00FEFDFE00AC9E9F000000000000000000000000007FAB
      D600957F7F00FFEBC10000000000000000000000000000000000C1EBFF007F7F
      9500D6AB7F00000000000000000000000000874E550095575E00FFFFFF00FFFF
      FF0095575E00FFFFFF00FFFFFF0095575E0095575E0095575E00F7F6F700F7F6
      F700FFFEFF00FFFEFF00FFFEFF00AC9E9F000000000000000000000000008080
      800000000000000000000000000000000000000000000000000000FFFF000000
      000000FFFF00000000000000000000000000874E550095575E00FFFFFF00FFFF
      FF008D5057008D505700FFFFFF00FFFFFF008D50570095575E00F7F6F700F7F6
      F700FFFEFF00FFFEFF00FFFEFF00AC9E9F000000000000000000000000000000
      000095C1EB00AB7F7F00FFFFD6000000000000000000D6FFFF007F7FAB00EBC1
      9500000000000000000000000000000000008C5259009D5E6600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D5E66009D5E66009D5E6600F7F7F700F7F7
      F700FFFFFF00FFFFFF00FFFFFF00AEA0A1000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000008C5259009D5E6600FFFFFF00FFFF
      FF008D5057008D505700FFFFFF00FFFFFF009D5E66009D5E6600F7F7F700F7F7
      F700FFFFFF00FFFFFF00FFFFFF00AEA0A1000000000000000000000000000000
      0000ABD6FF007F7F7F00FFD6AB000000000000000000C1EBFF007F7F9500FFD6
      AB000000000000000000000000000000000090555C009D5E6600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D5E66009D5E66009D5E6600F7F7F700F7F7
      F700AC9E9F00AC9E9F00AC9E9F00BBAFB0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000090555C009D5E6600FFFFFF00FFFF
      FF008D5057008D505700FFFFFF00FFFFFF009D5E66009D5E6600F7F7F700F7F7
      F700AC9E9F00AC9E9F00AC9E9F00BBAFB0000000000000000000000000000000
      0000ABD6FF007F7F7F00FFD6AB000000000000000000ABD6FF007F7F7F00FFD6
      AB000000000000000000000000000000000093585F0093585F0093585F009358
      5F0093585F0093585F0093585F0093585F0093585F0093585F00F9F9F900C0B5
      B600FFFFFF00FDFDFD00E7E3E300CFC7C7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000093585F0093585F0093585F009358
      5F008D5057008D50570093585F0093585F0093585F0093585F00F9F9F900C0B5
      B600FFFFFF00FDFDFD00E7E3E300CFC7C7000000000000000000000000000000
      0000C1EBFF007F7F9500FFD6AB000000000000000000ABD6FF00957F7F00FFEB
      C10000000000000000000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F9F9F900FDFDFD00CCC3
      C300FDFDFD00E7E3E300CFC7C700F3F2F2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F9F9F900FDFDFD00CCC3
      C300FDFDFD00E7E3E300CFC7C700F3F2F2000000000000000000000000000000
      0000000000007FABD6007F7F7F00D6AB7F007FABD6007F7F7F00D6AB7F000000
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCC3
      C300E7E3E300CFC7C700F3F2F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCC3
      C300E7E3E300CFC7C700F3F2F200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3
      C300CFC7C700F3F2F20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3
      C300CFC7C700F3F2F20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6BC
      BC00B2A4A500AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E
      9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F000000000000000000000000000000
      00000000000000000000C6C6C600C6C6C6008484840084848400000000000000
      0000848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F4F8F000ABCE860078AF3E0068B151004ECCF70063D5FC009EE5FD00F3FA
      FC0000000000000000000000000000000000000000000000000000000000CCC3
      C300F9F5F500F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3
      F400F9F3F400F9F3F400FAF6F700AC9E9F000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600C6C6C6008484840084848400848484008484
      8400000000000000000084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D2E4
      BF0071AA32005B9E13005B9E13005B9E13004EC0BE0042CDFF0041CDFF0058D3
      FE00CCF1FD00000000000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F1EBEC00F0EAEB00F0EAEB00F0EAEB00F0EAEB00F1EBEC00F5EFF000F7F1
      F200F7F1F200F7F1F200F9F4F500AC9E9F000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6008484840084848400848484008484
      8400848484000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D2E4BF005EA1
      17005DA016005DA016005C9F15005B9F14005A9D230046CCF80042CDFF0041CD
      FF0041CEFF00CCF1FD00000000000000000069373C0069373C0069373C006937
      3C0060292E0060292E0060292E0060292E0069373C0069373C00F3EDEE00F9F3
      F400F9F3F400F9F3F400FAF5F600AC9E9F0084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60000000000000000008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      00000000000000000000745A45006D544000694F3A00654A3600624732006247
      32006247320062473200624732000000000000000000F4F8F00072AB34005EA0
      18005EA018005DA017005DA0170069A7290067A2290050B1910043CDFF0042CD
      FF0041CDFF0059D3FE00F3FAFC00000000006B393E006B393E00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0083474E0083474E0083474E00F1EDED00F9F5
      F500F9F5F500F9F5F500FAF6F600AC9E9F0084848400C6C6C600C6C6C600C6C6
      C600000000000000000084848400848484000000000000000000848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      000000000000856C5900EDE6E300BFA79A00B89F9000B2978800AB908000A589
      7800A08471009B806D00967B68006247320000000000ACCF88005FA11A005FA1
      1A005FA119006EA82F00CFD5B100F3C3A700F3C3A700CDD1B0005FCDE90043CD
      FF0042CDFF0041CDFF009EE5FD0000000000713D4300713D4300FFFFFF00FFFF
      FF00672F3400FFFFFF00FFFFFF0083474E0083474E0083474E00F2EEEE00FAF6
      F600FAF6F600FAF6F600FBF8F900AC9E9F0084848400C6C6C600000000000000
      0000848484008484840000000000848484008484840000000000000000000000
      000084848400000000000000000000000000CEBBB000B69C8D00A48B7C000000
      0000000000008E756300F2EDEA00EEE6E200E9E0DC00E4D9D400DFD2CB00DACB
      C300D5C5BC00D1BEB4009A7E6B0062473200000000007CB2440060A11B0060A1
      1B0062A21E00DDDBCB00F4945B00F48A4A00F4894900F4925900DBE2DC0044CE
      FF0043CDFF0042CDFF0064D6FE0000000000764147007641470070373C007037
      3C0070373C00FFFFFF00FFFFFF008D5057008D5057008D505700F4F1F100FCF9
      F900FCF9F900FCF9F900FCFAFA00AC9E9F008484840000000000848484008484
      84000000FF000000FF0000848400008484000084840000848400000000000000
      000000000000000000000000000000000000DCCDC500C7B1A500B69C8E00C7B1
      A500AA8E7D0097806E00F6F2F100F2EDEA00EDE6E300E8E0DC00E4D9D300DFD2
      CB00DACCC300D5C5BC009D837000624732000000000069A7280062A31E0062A3
      1E005F8C5B00F3C4A900F48B4C00F48A4A00F48A4A00F4894900F3C3A70053CF
      FD0043CDFF0042CDFF004AD0FF00000000007B464C007B464C00793F4500793F
      4500793F4500FFFFFF00FFFFFF008D5057008D5057008D505700F5F3F400FDFB
      FC00FDFBFC00FDFBFC00FDFBFB00AC9E9F000000000084848400848484000000
      FF000000FF000000FF000084840000FFFF000084840000848400008484000000
      000000000000000000000000000000000000DCCDC500C7B1A500B69C8E00C7B1
      A500AA8E7D0097806E00F6F2F100F2EDEA00EDE6E300E8E0DC00E4D9D300DFD2
      CB00DACCC300D5C5BC009D83700062473200000000006BA92B0063A31F00619D
      28004C5DA800F3C4A900F48C4D00F48B4C00F48A4A00F48A4A00F3C3A70052CF
      FD0044CEFF0043CDFF004BD0FF000000000080494F0080494F0083474E008347
      4E0083474E00FFFFFF00FFFFFF0095575E0095575E0095575E00F5F4F400FDFC
      FC00FDFCFC00FDFCFC00FEFDFE00AC9E9F000000000000000000000000000000
      FF000000FF000000840000848400848484008484840000000000000000000000
      000000000000000000000000000000000000EEE7E400DBCDC600C9B8AF000000
      000000000000A08A7900F9F7F600F6F2F100F2EDEA00EDE7E300E9E0DC00E4D9
      D400DFD2CC00DACCC300A287740062473200000000007EB4470065A421004F77
      64003D49CA00C7C2DE00F4965E00F48C4D00F48B4C00F4945B00C8DFE60045CE
      FF0045CEFF0043CEFF0064D6FE0000000000874E5500874E55008D5057008D50
      57008D505700FFFFFF00FFFFFF0095575E0095575E0095575E00F7F6F700FFFE
      FF00FFFEFF00FFFEFF00FFFEFF00AC9E9F000000000000000000000000000000
      FF00000084000000840000000000000000000000000084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      000000000000A9948400FDFBFC00F9F7F700F6F3F000F2EDEA00EDE7E300E9E0
      DC00E4D9D400DFD2CC00A68C7A006449340000000000AFD08B005F973A003B4A
      BB00444FDB005762DE00C7C1DD00F3C5AA00F3C4A800C6D6DF004FB4EA003CB5
      F2003FBCF7003EC0FB009DE2FD00000000008C5259008C52590095575E009557
      5E0095575E009D5E6600A1656D009D5E66009D5E66009D5E6600F7F7F700FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00AEA0A1000000000000000000000000000000
      8400000084000000000084848400C6C6C600C6C6C60084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      000000000000B29D8E0000000000FCFCFB00FAF8F700F6F2F100F2EDEA00EEE7
      E300E9E0DB00E4D9D400DFD2CB00684D390000000000F4F8F000637E92004450
      D4004854DE004652DD004551DD00525DDC006986E2005A7CE200597BE2005B7B
      E300597BE3006887E500F2F3FB000000000090555C0090555C009D5E66009D5E
      66009D5E6600FFFFFF00FFFFFF009D5E66009D5E66009D5E6600F7F7F700AC9E
      9F00AC9E9F00AC9E9F00AC9E9F00BBAFB0000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      00000000000000000000B6A19300AE9A8B00A79181009F89780097806E008F76
      6400876E5C007E665200775E4B00000000000000000000000000CCCFF0004A56
      DE004854DE004753DD004551DD004450DD00424FDD00414EDC00414DDC003F4C
      DC003E4ADD00CACDF400000000000000000093585F0093585F0093585F009358
      5F0093585F0093585F0093585F0093585F0093585F0093585F00F9F9F900C0B5
      B600FFFFFF00FDFDFD00E7E3E300CFC7C700000000008484840000000000C6C6
      C600C6C6C600C6C6C600C6C6C6008484840084848400C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CBCE
      F400606AE3004753DD004652DD004551DD00434FDD00414EDC00404CDC005862
      E100CACDF400000000000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F9F9F900FDFDFD00CCC3
      C300FDFDFD00E7E3E300CFC7C700F3F2F2000000000000000000848484000000
      0000C6C6C6008484840084848400C6C6C600C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F2F3FB009EA5ED006873E300525CE000505ADF006570E3009DA3EC00F2F3
      FB0000000000000000000000000000000000000000000000000000000000CCC3
      C300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCC3
      C300E7E3E300CFC7C700F3F2F200000000000000000000000000000000008484
      840084848400C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3
      C300CFC7C700F3F2F20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000777777007777770000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848484008484840084848400C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848484008484840084848400C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000777777007777770000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840000000000848484008484
      8400848484008484840000000000000000000000000000000000000000008484
      84008484840000000000C6C6C60000000000C6C6C60084848400848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      84008484840000000000C6C6C60000000000C6C6C60084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000777777007777770000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000840000000000008484840000FF000000FF000000FF
      000000FF0000848484000000000000000000000000000000000084848400C6C6
      C60000000000C6C6C60000000000C6C6C600C6C6C60084848400848484008484
      840000000000000000000000000000000000000000000000000084848400C6C6
      C60000000000C6C6C60000000000C6C6C600C6C6C60084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000B2773C00000000000000000077777700777777000000000000000000B277
      3C000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF00000084000000000000848484000084000000FF000000FF
      000000FF00008484840000000000000000000000000000000000848484000000
      0000C6C6C60000000000C6C6C60000000000C6C6C60084848400848484008484
      8400848484000000000000000000000000000000000000000000848484000000
      0000C6C6C60000000000C6C6C60000000000C6C6C60084848400848484008484
      840084848400000000000000000000000000000000000000000000000000B277
      3C00000000000000000000000000777777007777770000000000000000000000
      0000B2773C00000000000000000000000000000000008484840000FF000000FF
      000000FF0000848484000084000000000000000000000000000000FF000000FF
      000000FF0000848484000000000000000000000000000000000084848400C6C6
      C6000000000000000000C6C6C600C6C6C600C6C6C60084848400848484008484
      840084848400000000000000000000000000000000000000000084848400C6C6
      C6000000000000000000C6C6C600C6C6C600C6C6C60084848400848484008484
      8400848484000000000000000000000000000000000000000000B2773C00B277
      3C00B2773C00B2773C0000000000777777007777770000000000B2773C00B277
      3C00B2773C00B2773C00000000000000000000000000000000008484840000FF
      0000848484008484840000840000008400000084000000FF000000FF000000FF
      000000FF00008484840000000000000000000000000000000000848484000000
      0000C6C6C600C6C6C600C6C6C600241CED00C6C6C600C6C6C600848484008484
      8400848484000000000000000000000000000000000000000000848484000000
      0000C6C6C600C6C6C600C6C6C600CC483F00C6C6C600C6C6C600848484008484
      840084848400000000000000000000000000000000000000000000000000B277
      3C00000000000000000000000000777777007777770000000000000000000000
      0000B2773C000000000000000000000000000000000000000000000000008484
      84000000000084848400008400000084000000FF000000FF000000FF00000000
      000000FF0000000000000000000000000000000000000000000084848400C6C6
      C600C6C6C600C6C6C600241CED00241CED00241CED00C6C6C600C6C6C6008484
      840084848400000000000000000000000000000000000000000084848400C6C6
      C600C6C6C600C6C6C600CC483F00CC483F00CC483F00C6C6C600C6C6C6008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000B2773C00000000000000000077777700777777000000000000000000B277
      3C00000000000000000000000000000000000000000000000000000000000000
      000000000000848484000084000000FF000000FF000000FF0000000000000000
      000000000000000000000000000000000000000000000000000084848400C6C6
      C600C6C6C600241CED00C6C6C600241CED00C6C6C600241CED00C6C6C6008484
      840084848400000000000000000000000000000000000000000084848400C6C6
      C600C6C6C600CC483F00C6C6C600CC483F00C6C6C600CC483F00C6C6C6008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000777777007777770000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000FF000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600241CED00C6C6C600C6C6C600C6C6C600C6C6
      C600848484008484840000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600CC483F00C6C6C600C6C6C600C6C6C600C6C6
      C600848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000777777007777770000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008484840000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400C6C6C600C6C6C600241CED00C6C6C600C6C6C600848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      000084848400C6C6C600C6C6C600CC483F00C6C6C600C6C6C600848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000777777007777770000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400C6C6C600241CED008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400C6C6C600CC483F008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000777777007777770000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6BC
      BC00B2A4A500AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F00AC9E
      9F00AC9E9F00AC9E9F00AC9E9F00AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840084848400000000000000000000000000000000000000000000000000CCC3
      C300F9F5F500F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3F400F9F3
      F400F9F3F400F9F3F400FAF6F700AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400848484000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F0EAEB00F0EAEB00F0EAEB00F1EBEC00F1EBEC00F1EBEC00F5EFF000F7F1
      F200F7F1F200F7F1F200F9F4F500AC9E9F000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000008484840000848400008484000084
      84000000000084848400848484000000000069373C0060292E00FFFFFF00FFFF
      FF0069373C0069373C0069373C0069373C0069373C0069373C00F3EDEE00F3ED
      EE00F9F3F400F9F3F400FAF5F600AC9E9F000000000000000000000000000000
      000000000000848484008484840084848400E8A20000CC483F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848484008484840084848400C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484000000000000000000000000000084840000848400008484000084
      8400008484000000000084848400000000006B393E0083474E00FFFFFF00FFFF
      FF0083474E0083474E0083474E0083474E0083474E0083474E00F1EDED00F1ED
      ED00F9F5F500F9F5F500FAF6F600AC9E9F000000000000000000000000008484
      84008484840000000000E8A2000000000000E8A20000CC483F00CC483F000000
      0000000000000000000000000000000000000000000000000000000000008484
      84008484840000000000C6C6C60000000000C6C6C60084848400848484000000
      0000000000000000000000000000000000000000FF0000000000000000008484
      8400848484008484840084848400008484000084840000848400008484000084
      840000848400000000008484840000000000713D430083474E00FFFFFF00FFFF
      FF0083474E0083474E0083474E0083474E0083474E0083474E00F2EEEE00F2EE
      EE00FAF6F600FAF6F600FBF8F900AC9E9F00000000000000000084848400E8A2
      000000000000E8A2000000000000E8A20000E8A20000CC483F00CC483F00CC48
      3F0000000000000000000000000000000000000000000000000084848400C6C6
      C60000000000C6C6C60000000000C6C6C600C6C6C60084848400848484008484
      8400000000000000000000000000000000000000FF000000FF000000FF000000
      00008484840084848400848484000084840000FFFF0000848400008484000084
      840000848400008484000000000000000000764147008D505700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0083474E008D505700F4F1F100F4F1
      F100FCF9F900FCF9F900FCFAFA00AC9E9F000000000000000000848484000000
      0000E8A2000000000000E8A2000000000000E8A20000CC483F00CC483F00CC48
      3F00CC483F000000000000000000000000000000000000000000848484000000
      0000C6C6C60000000000C6C6C60000000000C6C6C60084848400848484008484
      8400848484000000000000000000000000000000FF000000FF000000FF000000
      FF000000000000000000848484000084840000FFFF0000FFFF00008484000084
      8400008484000084840000000000000000007B464C008D505700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0083474E008D505700F5F3F400F5F3
      F400FDFBFC00FDFBFC00FDFBFB00AC9E9F00000000000000000084848400E8A2
      00000000000000000000E8A20000E8A20000E8A20000CC483F00CC483F00CC48
      3F00CC483F00000000000000000000000000000000000000000084848400C6C6
      C6000000000000000000C6C6C600C6C6C600C6C6C60084848400848484008484
      8400848484000000000000000000000000000000FF000000FF000000FF000000
      8400000084000000840000000000000000008484840000FFFF0000FFFF000084
      84000084840000000000000000000000000080494F0095575E00FFFFFF00FFFF
      FF008D5057008D505700FFFFFF00FFFFFF008D50570095575E00F5F4F400F5F4
      F400FDFCFC00FDFCFC00FEFDFE00AC9E9F000000000000000000848484000000
      0000E8A20000E8A20000E8A20000E8A20000E8A20000E8A20000CC483F00CC48
      3F00CC483F000000000000000000000000000000000000000000848484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600848484008484
      8400848484000000000000000000000000000000FF000000FF00000084000000
      8400000084000000840000000000000000000000000000848400008484000084
      840000000000000000000000000000000000874E550095575E00FFFFFF00FFFF
      FF008D5057008D505700FFFFFF00FFFFFF008D50570095575E00F7F6F700F7F6
      F700FFFEFF00FFFEFF00FFFEFF00AC9E9F00000000000000000084848400E8A2
      0000E8A20000E8A20000E8A20000E8A20000E8A20000E8A20000E8A20000CC48
      3F00CC483F00000000000000000000000000000000000000000084848400C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6008484
      8400848484000000000000000000000000000000FF000000FF00000084000000
      8400000000000000000084848400848484008484840084848400848484008484
      8400848484000000000000000000000000008C5259009D5E6600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009D5E66009D5E6600F7F7F700F7F7
      F700FFFFFF00FFFFFF00FFFFFF00AEA0A100000000000000000084848400E8A2
      0000E8A20000E8A20000E8A20000E8A20000E8A20000E8A20000E8A20000CC48
      3F00CC483F00000000000000000000000000000000000000000084848400C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6008484
      8400848484000000000000000000000000000000FF0000008400000000000000
      0000000000008484840000000000FF00000084840000FF000000FF0000000000
      00008484840000000000000000000000000090555C009D5E6600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009D5E66009D5E6600F7F7F700F7F7
      F700AC9E9F00AC9E9F00AC9E9F00BBAFB0000000000000000000000000008484
      8400E8A20000E8A20000E8A20000E8A20000E8A20000E8A20000E8A20000E8A2
      0000CC483F00CC483F0000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600848484008484840000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FF000000FF000000FF0000000000
      00008484840000000000000000000000000093585F0093585F0093585F009358
      5F0093585F0093585F0093585F0093585F0093585F0093585F00F9F9F900C0B5
      B600FFFFFF00FDFDFD00E7E3E300CFC7C7000000000000000000000000000000
      000084848400E8A20000E8A20000E8A20000E8A20000E8A20000848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      000084848400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008484000084840000FF000000FF0000000000
      000084848400000000000000000000000000F6F6F600F4F4F400F4F4F400C5BD
      BD00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F9F9F900FDFDFD00CCC3
      C300FDFDFD00E7E3E300CFC7C700F3F2F2000000000000000000000000000000
      00000000000084848400E8A20000E8A200008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400C6C6C600C6C6C6008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FF000000FF000000FF0000000000
      000084848400000000000000000000000000000000000000000000000000CCC3
      C300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CCC3
      C300E7E3E300CFC7C700F3F2F200000000000000000000000000000000000000
      0000000000000000000084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008484000084840000FF000000FF0000008400
      000000000000000000000000000000000000000000000000000000000000CCC3
      C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3C300CCC3
      C300CFC7C700F3F2F20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E000FFFFE000FFFFE000FFFFE000FFFF
      0000FFFF0000FFFF0000F8FF0000F81F0000F0430000F18F0000E0030000F18F
      0000C0030000F18F000083830000F18F0000C7C30000E3C70000EFD70000F18F
      0000FFBF0000F18F0000FFFF0000F18F0000FFFF0000F18F0000FFFF0000F81F
      E001FFFFE001FFFFE003FFFFE003FFFFFC07FFFFFFFFE000F001FFFFF00FE000
      C000FFFFE00700000001FFFFC00300000303FC01800100000CC3F80080010000
      3033180080010000400B0000800100008007000080010000E003180080010000
      E001F80080010000E001FA0080010000C003FC01C0030000A007FFFFE0070000
      D03FFFFFF00FE001E1FFFFFFFFFFE003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF3FFF3FFE7FF8FFF81FF81FFE7FF043E50FE50FFE7FE003CA07CA07F66F
      C003D503D503EE778003CC03CC03C243C003D003D003EE77E817C003C003F66F
      F83FC003C003FE7FF87FE003E003FE7FFCFFF00FF00FFE7FFFFFF83FF83FFE7F
      FFFFFCFFFCFFFFFFFFFFFFFFFFFFFFFFE000FFFFFFFFFFC7E000FFFFFFFFFF83
      0000FF3FFF3FEF010000F81FF81FC7010000E50FE50F00010000CA07CA070003
      0000D503D50300030000CC03CC0301070000D003D003038F0000C003C0030C07
      0000C003C0033A070000E003E003FD070000F00FF00FFE070000F83FF83FFD07
      E001FCFFFCFFFE0FE003FFFFFFFFFC0F00000000000000000000000000000000
      000000000000}
  end
  object DebugImageList: TImageList
    Left = 668
    Top = 181
    Bitmap = {
      494C01010A002400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000918E8A0077777700E5DFD800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0
      E9007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7D
      7B00777777007777770077777700E6E0D9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0
      E9007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007E7C7A007777
      7700000000000000000078787700777777000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7B7900777777007777
      77000000000000000000777777007E7C7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0
      E9007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7A790077777700777777007777
      7700777777007777770079787700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0
      E9007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      00000000000000000000000000007A7978007777770077777700777777007777
      7700777777007D7C7A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000009C99
      95008C8A8700A5A29D007E7C7B00777777007777770077777700777777007777
      770083817F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0
      E9007F7F7F007F7F7F00000000000000000000000000CAC5BF00767676007676
      7600767676007676760077777700777777007777770077777700777777008B89
      8500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0E9007F7F7F00F6F0E900F6F0
      E9007F7F7F007F7F7F0000000000000000000000000076767600777777007777
      7700777777007777770077777700777777007777770077777700979490000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000008885830077777700777777007777
      77007777770077777700777777007777770077777700A5A19D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F000000000000000000777777007777770077777700D1CC
      C5000000000077777700777777007777770076767600BFBBB500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F0000000000000000007777770077777700D1CCC5000000
      00000000000000000000777777007777770076767600A4A19C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF009F9F9F00AEAEAE00ACACAC00AFAFAF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F00000000000000000076767600D2CDC700000000000000
      000000000000D7D2CB00767676007777770076767600C6C1BB00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF008A8A8A00A4A4A400C7C7C700A5A5A500FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F000000000000000000D1CCC50000000000000000000000
      0000D7D2CB007676760077777700777777007676760000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F000000000000000000000000000000000000000000D6D1
      CA0076767600777777007777770076767600EEE8E10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000E2DCD5007676
      7600777777007A79780099969200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006CA7FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000077ADFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006CA7FF006CA7
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000077ADFF0077ADFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF0064A2
      FF0064A2FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004646460046464600464646004646460046464600464646004646
      46004646460046464600464646000000000061412100614121006CA7FF006CA7
      FF006CA7FF000000000000000000464646004646460046464600464646004646
      4600464646004646460046464600000000007868580061412100614121006141
      210077ADFF0077ADFF0077ADFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF0064A2
      FF0064A2FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000061412100000000006CA7FF006CA7
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      000077ADFF0077ADFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000064A2FF0064A2FF0064A2
      FF0064A2FF0064A2FF0064A2FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006CA7FF000000000000000000000000004646460046464600464646004646
      46004646460046464600464646000000000061412100000000006CA7FF000000
      0000000000000000000000000000000000004646460046464600464646004646
      4600464646004646460046464600000000006141210000000000000000000000
      000077ADFF0000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000064A2FF0064A2FF0064A2
      FF0064A2FF0064A2FF0064A2FF00000000000000000000000000000000008080
      80007B7B7B00EDEDED0000000000000000000000000000000000000000000000
      00006CA7FF006CA7FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000000000000000000000000000EFEFEF0064A2
      FF0064A2FF0000000000EFEFEF000000000000000000EAEAEA00595959005F5F
      5F006565650059595900DDDDDD00000000007868580061412100614121006141
      21006CA7FF006CA7FF006CA7FF00000000004646460046464600464646004646
      4600464646004646460046464600000000006141210000000000000000000000
      0000000000000000000000000000000000004646460046464600464646004646
      4600464646004646460046464600000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F000000000000000000000000000000000000000000CCCCCC00EFEFEF0064A2
      FF0064A2FF0000000000606060006D6D6D000000000062626200696969000000
      0000000000009898980058585800D5D5D5006141210000000000000000000000
      00006CA7FF006CA7FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F0000000000000000000000000000000000000000005E5E5E00EFEFEF00FFFF
      FF00FFFFFF00000000008686860058585800C7C7C70059595900989898000000
      000000000000DDDDDD005A5A5A005B5B5B006141210000000000000000000000
      00006CA7FF000000000000000000000000004646460046464600464646004646
      4600464646004646460046464600000000006141210000000000000000000000
      0000000000000000000000000000000000004646460046464600464646004646
      4600464646004646460046464600000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F0000000000000000000000000000000000000000007A7A7A00E3E3E300EFEF
      EF000000000000000000585858005A5A5A005A5A5A005A5A5A0058585800EEEE
      EE00000000005C5C5C005E5E5E007E7E7E006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F000000000000000000000000000000000000000000B0B0B0005B5B5B006161
      61005A5A5A005A5A5A00727272000000000000000000EFEFEF006B6B6B005A5A
      5A005A5A5A00656565005C5C5C00ADADAD006141210000000000000000000000
      0000000000004646460046464600464646004646460046464600464646004646
      4600464646004646460046464600000000006141210000000000000000000000
      0000000000004646460046464600464646004646460046464600464646004646
      4600464646004646460046464600000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000000000000000000000000000626262008E8E
      8E00EFEFEF00EFEFEF000000000000000000000000000000000000000000EFEF
      EF00EFEFEF009595950061616100000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000000000000000000000000000EFEFEF005A5A
      5A00D5D5D5000000000000000000000000000000000000000000000000000000
      0000DBDBDB0058585800EFEFEF00000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F00000000000000000000000000000000000000000000000000EFEF
      EF00585858000000000000000000000000000000000000000000000000000000
      000058585800EEEEEE0000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D4D4D4005B5B5B0000000000000000000000000000000000000000005C5C
      5C00CDCDCD000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006141210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000ADADAD00EEEEEE00000000000000000000000000EFEFEF00AAAA
      AA00000000000000000000000000000000007868580061412100614121006141
      2100614121006141210061412100614121006141210061412100000000000000
      0000000000000000000000000000000000007868580061412100614121006141
      2100614121006141210061412100614121006141210061412100000000000000
      0000000000000000000000000000000000007868580061412100614121006141
      2100614121006141210061412100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E9E9E900AFAFAF00A3A3A300E9E9
      E900000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E9E9E900AFAFAF00A3A3A300E9E9
      E900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000DADADA00494949001B1B1B00262626000000
      0000BCBCBC00F3F3F30000000000000000000000000000000000000000000000
      0000000000000000000000000000DADADA00494949001B1B1B00262626000000
      0000BCBCBC00F3F3F30000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B0B0B00030303000292929002E2E2E002F2F2F008D8D
      8D00C3C3C300AEAEAE0000000000000000000000000000000000000000000000
      00000000000000000000B0B0B00030303000292929002E2E2E002F2F2F008D8D
      8D00C3C3C300AEAEAE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009D9D9D002A2A2A00272727002B2B2B003535350095959500C1C1
      C1003F3F3F008D8D8D0000000000000000000000000000000000000000000000
      0000000000009D9D9D002A2A2A00272727002B2B2B003535350095959500C1C1
      C1003F3F3F008D8D8D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009B9B9B00313131002E2E2E008787870087878700A1A1A100A8A8A8002D2D
      2D0072727200E2E2E20000000000000000000000000000000000000000000000
      00009B9B9B00313131002E2E2E008787870087878700A1A1A100A8A8A8002D2D
      2D0072727200E2E2E20000000000000000000000000000000000000000000000
      000000000000000000004CB12200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F00000000000000000000000000000000000000000000000000B2B2
      B2003E3E3E0023232300A6A6A6000000000000000000BCBCBC004E4E4E008B8B
      8B00E4E4E400000000000000000000000000000000000000000000000000B2B2
      B2003E3E3E0023232300A6A6A6000000000000000000BCBCBC004E4E4E008B8B
      8B00E4E4E4000000000000000000000000000000000000000000000000000000
      000000000000000000004CB122004CB122000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22004CB122000000000000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000000000000000000000000000000000005050
      50001A1A1A009696960000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005050
      50001A1A1A009696960000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004CB122004CB122004CB1220000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22004CB122004CB1220000000000000000000000000000000000000000007F7F
      7F00000000000000000000000000000000000000000000000000848484002323
      23006D6D6D00E9E9E90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484002323
      23006D6D6D00E9E9E90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004CB122004CB122004CB122004CB12200000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22004CB122004CB122004CB12200000000000000000000000000000000007F7F
      7F000000000000000000000000000000000000000000D5D5D500353535003737
      3700B9B9B9000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D5D5D500353535003737
      3700B9B9B9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004CB122004CB122004CB122004CB122004CB122000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22004CB122004CB122004CB122004CB122000000000000000000000000007F7F
      7F00000000000000000000000000000000000000000077777700292929002E2E
      2E009D9D9D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000077777700292929002E2E
      2E009D9D9D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004CB122004CB122004CB122004CB12200000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22004CB122004CB122004CB12200000000000000000000000000000000007F7F
      7F0000000000000000000000000000000000EBEBEB0026262600303030003838
      3800B2B2B2008B8B8B00000000000000000000000000241CED00000000000000
      000000000000241CED000000000000000000EBEBEB0026262600303030003838
      3800B2B2B2008B8B8B00000000000000000000000000000000004CB122000000
      00004CB12200000000004CB12200000000000000000000000000000000000000
      000000000000000000004CB122004CB122004CB1220000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22004CB122004CB1220000000000000000000000000000000000000000007F7F
      7F0000000000000000000000000000000000D1D1D100191919002C2C2C008686
      8600ABABAB001616160000000000000000000000000000000000241CED000000
      0000241CED00000000000000000000000000D1D1D100191919002C2C2C008686
      8600ABABAB001616160000000000000000000000000000000000000000004CB1
      2200000000004CB12200000000004CB122000000000000000000000000000000
      000000000000000000004CB122004CB122000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22004CB122000000000000000000000000000000000000000000000000007F7F
      7F0000000000000000000000000000000000000000002F2F2F0054545400C1C1
      C1003B3B3B006E6E6E000000000000000000000000000000000000000000241C
      ED0000000000000000000000000000000000000000002F2F2F0054545400C1C1
      C1003B3B3B006E6E6E00000000000000000000000000000000004CB122000000
      00004CB12200000000004CB12200000000000000000000000000000000000000
      000000000000000000004CB12200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      22000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F0000000000000000000000000000000000C4C4C400AEAEAE006363
      630042424200D8D8D80000000000000000000000000000000000241CED000000
      0000241CED0000000000000000000000000000000000C4C4C400AEAEAE006363
      630042424200D8D8D80000000000000000000000000000000000000000004CB1
      2200000000004CB1220000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D8D8D8008484
      8400BEBEBE0000000000000000000000000000000000241CED00000000000000
      000000000000241CED0000000000000000000000000000000000D8D8D8008484
      8400BEBEBE0000000000000000000000000000000000000000004CB122000000
      00004CB122000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004CB1
      2200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00C003FFF100000000C003FFE000000000
      C003FFCC00000000C003FF8C00000000C003FF0100000000C003FE0300000000
      C003E00700000000C003800F00000000C003801F00000000C003003F00000000
      C003083F00000000C0031C3F00000000C003383F00000000C003707F00000000
      C003E07F00000000C003C1FF00000000FFFFDFFFF7FFFFFFFFFFCFFFF3FFC7FF
      F801060101FFC7FFFFFF4FFF73FF81FFF7015F0177C781E3F3FF7FFF7FEFC581
      01017F017FEF849873FF7FFF7FEF841877017F017FEF8C087FFF7FFF7FEF8180
      780178017FEFC3E17FFF7FFF7FEFC7F17FFF7FFF7FC7E7F37FFF7FFF7FFFF3E7
      7FFF7FFF7FFFF9CF003F003F01FFFFFFFF0FFF0FFFFFFFFFFE03FE03FFFFFFFF
      FC03FC03FFFFFFFFF803F803FFFFFFFFF003F003FDFFEFC7E187E187FCFFE7EF
      E3FFE3FFFC7FE3EFC3FFC3FFFC3FE1EF87FF87FFFC1FE0EF87FF87FFFC3FE1EF
      03BB03D5FC7FE3EF03D703EAFCFFE7EF83EF83D5FDFFEFC783D783EBFFFFFFFF
      C7BBC7D7FFFFFFFFFFFFFFEFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object WatchPopupMenu: TPopupMenu
    Left = 579
    Top = 172
    object Addwatch: TMenuItem
      Caption = 'Add watch'
      OnClick = AddwatchClick
    end
    object Deletewatch: TMenuItem
      Caption = 'Delete watch'
      OnClick = DeletewatchClick
    end
  end
end
