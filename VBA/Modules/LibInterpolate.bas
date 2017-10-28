Attribute VB_Name = "LibInterpolate"
Option Explicit

Private Function IsVector(x As Range) As Boolean
    IsVector = (x.Columns.Count = 1 And x.Rows.Count > 0) Or (x.Columns.Count > 0 And x.Rows.Count = 1)
End Function

Private Function IsRowVector(x As Range) As Boolean
    IsRowVector = IsVector(x) And x.Rows.Count > 1
End Function

Private Function GetVectorLength(x As Range) As Long
    If IsRowVector(x) Then
        GetVectorLength = x.Rows.Count
    Else
        GetVectorLength = x.Columns.Count
    End If
End Function

' 折れ線を線形補間する関数
' y : 折れ線のy座標(行または列であること) ← 昇順に整列されていないとNG
' x : 折れ線のx座標(行または列であること)
' xp : y座標を求めたいx座標
' offset : オフセット
Function Interpolate(y As Range, x As Range, xp As Double, Optional offset As Double = 0) As Variant
    If IsVector(x) And IsVector(y) Then
        Dim var As Variant
        Dim n As Long
        Dim i As Long
        
        ' Application.WorksheetFunction.Match(...) とやると検索値がないときに#VALUE!となって動かない
        ' xpが下限より小さい場合は var にエラーが入るので、i=1 として最初の線分を選択する
        ' xpが上限より大きい場合は i = n-1 として最後の線分を選択する
        ' これにより、xpが上限・下限の外にあっても、外挿により値が返せるようになる
        var = Application.Match(xp, x, 1)
        If Not IsError(var) Then
            i = CLng(var)
            
            n = GetVectorLength(x)              ' 上限以上の場合
            If i = n Then
                i = n - 1
            End If
        Else                                    ' 下限未満の場合
            i = 1
        End If
            
        ' 列か行かで処理を分けているが､もっと良いやり方があるかも
        Dim x1 As Double
        Dim x2 As Double
        Dim y1 As Double
        Dim y2 As Double
        If IsRowVector(x) Then
            x1 = x.Cells(i, 1)
            x2 = x.Cells(i + 1, 1)
        Else
            x1 = x.Cells(1, i)
            x2 = x.Cells(1, i + 1)
        End If
        
        If IsRowVector(y) Then
            y1 = y.Cells(i, 1)
            y2 = y.Cells(i + 1, 1)
        Else
            y1 = y.Cells(1, i)
            y2 = y.Cells(1, i + 1)
        End If
        
    Interpolate = (y2 * (xp - x1) + (x2 - xp) * y1) / (x2 - x1) + offset
    End If
End Function
