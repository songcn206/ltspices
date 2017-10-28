Attribute VB_Name = "SnipetFileIO"
Option Explicit

Const NAME_OUTPUTFILE = "OutputFile"
Const DEFAULT_FILENAME = "default"
Const FILE_FILTER = "CSV,*.csv"
Const NAME_SELECTEDFOLDER = "SelectedFolder"
Const NAME_SELECTEDFILES = "SelectedFiles"

Sub フォルダを選択()
    With Application.filedialog(msoFileDialogFolderPicker)
        .title = "フォルダを選択してください"
        .InitialFileName = ""
        .Show
        
        Debug.Print .SelectedItems(1)
        SetNameString NAME_SELECTEDFOLDER, CStr(.SelectedItems(1))
    End With
End Sub


Sub ファイルを選択()
    With Application.filedialog(msoFileDialogOpen)
        .title = "ファイルを1つ以上選択してください"
        .AllowMultiSelect = True
        .Show
        
        Dim tmp As String
        tmp = ""
        
        ' 選択された項目に対してループ
        Dim item As Variant
        For Each item In .SelectedItems
            Debug.Print item
            tmp = tmp & CStr(item) & ";"
        Next item
        SetNameString NAME_SELECTEDFILES, tmp
    End With
End Sub


Sub 保存先を選択()
    Dim item As Variant
    Dim outputFile As String
    outputFile = ""
    
    ' outputFileが設定されるまでループする
    Do
        Dim default As String
        If ExistsName(NAME_OUTPUTFILE) Then
            default = Dir(GetNameString(NAME_OUTPUTFILE))
        Else
            default = DEFAULT_FILENAME
        End If
        
        item = Application.GetSaveAsFilename(default, FILE_FILTER, , "保存先を指定", "OK")
        
        If item = False Then
            ' キャンセルされたら前回の値を保持
            Exit Sub
        Else
            outputFile = CStr(item)
            
            Dim answer As Long
            If Dir(outputFile) <> "" Then
                answer = MsgBox("「" & Dir(outputFile) & "」は存在します。" & vbCr & "上書きしますか?", vbQuestion + vbYesNo + vbDefaultButton2)
                If Not answer = vbYes Then
                    ' 再度ダイアログを表示するために、outputFileを空にする
                    outputFile = ""
                End If
            End If
        End If
    Loop Until outputFile <> ""
    
    SetNameString NAME_OUTPUTFILE, outputFile
End Sub
