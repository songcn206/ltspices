Attribute VB_Name = "LibString"
Function JoinCells(rng As Range, Optional delim As String = ",")
    Dim col As Integer
    Dim row As Integer
    Dim i As Integer
    Dim j As Integer
    Dim str As String
    
    col = rng.Columns.Count
    row = rng.Rows.Count
    str = ""
   
    For i = 1 To row
        For j = 1 To col
            str = str + rng.Cells(i, j).Text + delim
        Next j
    Next i
    
    JoinCells = Left(str, Len(str) - Len(delim))
End Function


Function DefineMatrix(rng As Range, _
    Optional delim As String = ",", _
    Optional begin_brace As String = "[", _
    Optional end_brace As String = "]")
    
    Dim str As String
    Dim col As Integer
    Dim row As Integer
    Dim i As Integer
    Dim j As Integer
    
    col = rng.Columns.Count
    row = rng.Rows.Count
    str = ""
   
    For i = 1 To row
        str = str + begin_brace
        For j = 1 To col
            str = str + rng.Cells(i, j).Text + delim
        Next j
        str = Left(str, Len(str) - Len(delim)) + end_brace + delim
    Next i
    DefineMatrix = Left(str, Len(str) - Len(delim))
End Function


Function ConcatenateCells(rng1 As Range, rng2 As Range, _
    Optional operator As String = "=", Optional delim As String = ",")
    
    If rng1.Columns.Count <> rng2.Columns.Count Or rng1.Rows.Count <> rng2.Rows.Count Then
        ConcatenateCells = CVErr(xlErrValue)
    Else
        Dim str As String
        Dim col As Integer
        Dim row As Integer
        Dim i As Integer
        Dim j As Integer
    
        col = rng1.Columns.Count
        row = rng1.Rows.Count
        str = ""
   
        For i = 1 To row
            str = str + begin_brace
            For j = 1 To col
                str = str + rng1.Cells(i, j).Text + operator + rng2.Cells(i, j).Text + delim
            Next j
            str = Left(str, Len(str) - Len(delim)) + end_brace + delim
        Next i
        ConcatenateCells = Left(str, Len(str) - Len(delim))
    End If
End Function
