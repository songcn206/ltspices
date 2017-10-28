Attribute VB_Name = "SnipetFileIO"
Option Explicit

Const NAME_OUTPUTFILE = "OutputFile"
Const DEFAULT_FILENAME = "default"
Const FILE_FILTER = "CSV,*.csv"
Const NAME_SELECTEDFOLDER = "SelectedFolder"
Const NAME_SELECTEDFILES = "SelectedFiles"

Sub �t�H���_��I��()
    With Application.filedialog(msoFileDialogFolderPicker)
        .title = "�t�H���_��I�����Ă�������"
        .InitialFileName = ""
        .Show
        
        Debug.Print .SelectedItems(1)
        SetNameString NAME_SELECTEDFOLDER, CStr(.SelectedItems(1))
    End With
End Sub


Sub �t�@�C����I��()
    With Application.filedialog(msoFileDialogOpen)
        .title = "�t�@�C����1�ȏ�I�����Ă�������"
        .AllowMultiSelect = True
        .Show
        
        Dim tmp As String
        tmp = ""
        
        ' �I�����ꂽ���ڂɑ΂��ă��[�v
        Dim item As Variant
        For Each item In .SelectedItems
            Debug.Print item
            tmp = tmp & CStr(item) & ";"
        Next item
        SetNameString NAME_SELECTEDFILES, tmp
    End With
End Sub


Sub �ۑ����I��()
    Dim item As Variant
    Dim outputFile As String
    outputFile = ""
    
    ' outputFile���ݒ肳���܂Ń��[�v����
    Do
        Dim default As String
        If ExistsName(NAME_OUTPUTFILE) Then
            default = Dir(GetNameString(NAME_OUTPUTFILE))
        Else
            default = DEFAULT_FILENAME
        End If
        
        item = Application.GetSaveAsFilename(default, FILE_FILTER, , "�ۑ�����w��", "OK")
        
        If item = False Then
            ' �L�����Z�����ꂽ��O��̒l��ێ�
            Exit Sub
        Else
            outputFile = CStr(item)
            
            Dim answer As Long
            If Dir(outputFile) <> "" Then
                answer = MsgBox("�u" & Dir(outputFile) & "�v�͑��݂��܂��B" & vbCr & "�㏑�����܂���?", vbQuestion + vbYesNo + vbDefaultButton2)
                If Not answer = vbYes Then
                    ' �ēx�_�C�A���O��\�����邽�߂ɁAoutputFile����ɂ���
                    outputFile = ""
                End If
            End If
        End If
    Loop Until outputFile <> ""
    
    SetNameString NAME_OUTPUTFILE, outputFile
End Sub
