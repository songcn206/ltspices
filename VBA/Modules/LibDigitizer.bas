Attribute VB_Name = "LibDigitizer"
' �O���g���K�o�[�W����
' ���� Trigger �͓����̏����ł͎g�p���Ȃ�
' �֐��ɂ���ɂ͍D�܂����Ȃ����g�̂��߁AVolatile�ɂ���ƕ��ׂ������B
' �K�v�ȃ^�C�~���O��Trigger�̒l���X�V���邱�ƂōČv�Z�����悤�ɂ��Ă���B
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
            Digitize = (node.Points(1, 1) - Xo) / W 'X���W
        Case "Y"
            Yo = coord.Top + coord.Height
            H = coord.Height
            Digitize = -(node.Points(1, 2) - Yo) / H 'Y���W
        Case Default
            GoTo returnErrorValue
    End Select
    Exit Function
returnErrorValue:
    ' �C���f�b�N�X���͈͊O�̏ꍇ�̓G���[�l��Ԃ����ƂŃO���t�����₷���Ȃ�
    Digitize = CVErr(xlErrNA)
End Function

