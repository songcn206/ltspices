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

' �܂������`��Ԃ���֐�
' y : �܂����y���W(�s�܂��͗�ł��邱��) �� �����ɐ��񂳂�Ă��Ȃ���NG
' x : �܂����x���W(�s�܂��͗�ł��邱��)
' xp : y���W�����߂���x���W
' offset : �I�t�Z�b�g
Function Interpolate(y As Range, x As Range, xp As Double, Optional offset As Double = 0) As Variant
    If IsVector(x) And IsVector(y) Then
        Dim var As Variant
        Dim n As Long
        Dim i As Long
        
        ' Application.WorksheetFunction.Match(...) �Ƃ��ƌ����l���Ȃ��Ƃ���#VALUE!�ƂȂ��ē����Ȃ�
        ' xp��������菬�����ꍇ�� var �ɃG���[������̂ŁAi=1 �Ƃ��čŏ��̐�����I������
        ' xp��������傫���ꍇ�� i = n-1 �Ƃ��čŌ�̐�����I������
        ' ����ɂ��Axp������E�����̊O�ɂ����Ă��A�O�}�ɂ��l���Ԃ���悤�ɂȂ�
        var = Application.Match(xp, x, 1)
        If Not IsError(var) Then
            i = CLng(var)
            
            n = GetVectorLength(x)              ' ����ȏ�̏ꍇ
            If i = n Then
                i = n - 1
            End If
        Else                                    ' ���������̏ꍇ
            i = 1
        End If
            
        ' �񂩍s���ŏ����𕪂��Ă��邪������Ɨǂ����������邩��
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
