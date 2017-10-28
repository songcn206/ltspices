Attribute VB_Name = "LibName"
Option Explicit

' 範囲に名前を付ける
Sub SetNameRange(str As String, rng As Range, Optional isSheetName As Boolean = True)
    If isSheetName Then
        ActiveSheet.Names.Add name:=str, refersTo:=rng
    Else
        ThisWorkbook.Names.Add name:=str, refersTo:=rng
    End If
End Sub

' 名前の範囲を取得する
Function GetNameRange(name As String, Optional isSheetName As Boolean = True) As Range
    If isSheetName Then
        Set GetNameRange = ActiveSheet.Range(name)
    Else
        Set GetNameRange = Range(name)
    End If
End Function

' 文字列に名前を付ける
Sub SetNameString(name As String, str As String, Optional isSheetName As Boolean = True)
    If isSheetName Then
        ActiveSheet.Names.Add name:=name, refersTo:="=""" & str & """"
    Else
        ThisWorkbook.Names.Add name:=name, refersTo:="=""" & str & """"
    End If
End Sub

' 名前の文字列を取得する
Function GetNameString(name As String, Optional isSheetName As Boolean = True) As String
    If isSheetName Then
        GetNameString = Evaluate(ActiveSheet.Names(name).refersTo)
    Else
        GetNameString = Evaluate(ThisWorkbook.Names(name).refersTo)
    End If
End Function

' 名前が存在するか確認する
Function ExistsName(str As String, Optional isSheetName As Boolean = True) As Boolean
    On Error GoTo notExists
    Dim dummy As name
    If isSheetName Then
        Set dummy = ActiveSheet.Names(str)
    Else
        Set dummy = ThisWorkbook.Names(str)
    End If
    ExistsName = True
    Exit Function
notExists:
    ExistsName = False
End Function
