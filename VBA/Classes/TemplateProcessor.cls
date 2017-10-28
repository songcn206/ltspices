VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TemplateProcessor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
' 文字列に含まれるテンプレート(デフォルトでは << >> で囲まれた部分)がある場合、
' << >> 内の文字列をExcelの数式として評価した結果に置き換える
' テンプレートの「開始」と「終了」の囲み文字は変更可能。
' 数式として評価する際にエラーが発生した場合は、エラーメッセージが出る

Dim RegExp As Object
Const DefaultBeginClause = "<<"     '
Const DefaultEndClause = ">>"
Const MatchPattern = "(.+?)"        ' 最小マッチ

Private Sub Class_Initialize()
    Set RegExp = CreateObject("VBScript.RegExp")
    Call SetClause(DefaultBeginClause, DefaultEndClause)
    RegExp.Global = True
End Sub

' テンプレート置き換え処理
Public Function Process(str As String) As String
    Dim matches As Object
    Set matches = RegExp.Execute(str)
    
    If matches.Count = 0 Then
        Process = str
    Else
        Dim tmpStr As String
        tmpStr = ""
        
        Dim cursor As Long
        cursor = 0
        
        Dim i As Long
        For i = 0 To matches.Count - 1
            tmpStr = tmpStr & TrailingString(str, cursor, matches.item(i)) & ReplacementString(matches.item(i))
            cursor = NextCursor(matches.item(i))
        Next i
        tmpStr = tmpStr & RemainingString(str, cursor)
        Process = tmpStr
    End If
End Function
' 囲み文字を変更
Public Sub SetClause(beginClause As String, endClause As String)
    RegExp.Pattern = beginClause + MatchPattern + endClause
End Sub

' 以下テンプレート置き換え処理で使用する関数
' カーソル位置から次のテンプレートが始まるまでの文字列を返す
Private Function TrailingString(str As String, cursor As Long, item As Variant)
    TrailingString = Mid(str, (cursor + 1), item.FirstIndex - cursor)
End Function

' テンプレート内の文字列を数式として評価した結果を返す
' 数式が正常に評価できない場合エラーを出す
Private Function ReplacementString(item As Variant)
    Dim Result As Variant
    Dim Formula As String
    Formula = item.Submatches(0)
    
    Result = Application.Evaluate(Formula)
    If VBA.VarType(Result) = vbError Then
        Err.Raise vbObjectError, "ReplacementString", "数式の計算に失敗 : " & Formula
    End If
    ReplacementString = Result
End Function

' 次のカーソル位置(テンプレートの次の文字を指す)を返す
Private Function NextCursor(item As Variant)
    NextCursor = item.FirstIndex + item.Length
End Function

' 最後のテンプレートを処理後に残った文字列を返す
Private Function RemainingString(str As String, cursor As Long)
    RemainingString = Right(str, Len(str) - cursor)
End Function

Private Sub Class_Terminate()
    Set RegExp = Nothing
End Sub
