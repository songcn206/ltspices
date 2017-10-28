Attribute VB_Name = "LibDigitizer"
' 外部トリガバージョン
' 引数 Trigger は内部の処理では使用しない
' 関数にするには好ましくない中身のため、Volatileにすると負荷が高い。
' 必要なタイミングでTriggerの値を更新することで再計算されるようにしている。
Function Digitize(coordName As String, curveName As String, index As Long, xySelect As String, Optional Trigger As Variant) As Variant
    On Error GoTo returnErrorValue
    Dim curve As Shape
    Set curve = ActiveSheet.Shapes(curveName)
        
    If index > curve.Nodes.Count Or index < 1 Then
        GoTo returnErrorValue
    End If
    
    Dim node As ShapeNode
    Set node = curve.Nodes(index)
    
    Dim coord As Shape
    Set coord = ActiveSheet.Shapes(coordName)
    
    Dim Xo As Double
    Dim Yo As Double
    Dim W As Double
    Dim H As Double

    Select Case xySelect
        Case "X"
            Xo = coord.Left
            W = coord.Width
            Digitize = (node.Points(1, 1) - Xo) / W 'X座標
        Case "Y"
            Yo = coord.Top + coord.Height
            H = coord.Height
            Digitize = -(node.Points(1, 2) - Yo) / H 'Y座標
        Case Default
            GoTo returnErrorValue
    End Select
    Exit Function
returnErrorValue:
    ' インデックスが範囲外の場合はエラー値を返すことでグラフ化しやすくなる
    Digitize = CVErr(xlErrNA)
End Function

