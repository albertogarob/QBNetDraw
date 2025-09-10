' ============================================
' QBasic Network Drawer (CSV, SCREEN 12, labels)
' Reads edges.csv (no header):
'   source,target,x1,y1,x2,y2,label1,label2
' x/y are normalized [0,1]
' ============================================

CONST W% = 640
CONST H% = 480
CONST EDGECOLOR% = 7
CONST NODESIZE% = 5      ' node radius (pixels)
CONST BORDERCOLOR% = 15  ' white border color

SCREEN 12
CLS

OPEN "CSV\LESMIS.CSV" FOR INPUT AS #1 ' Modify to your CSV file

DO WHILE NOT EOF(1)
    ' Read edge data
    INPUT #1, x1!, y1!, x2!, y2!, color1%, color2%
    
    ' Scale normalized coords to pixels
    sx1! = x1! * W%: sy1! = y1! * H%
    sx2! = x2! * W%: sy2! = y2! * H%
    
    ' Draw edge
    LINE (sx1!, sy1!)-(sx2!, sy2!), EDGECOLOR%
    
    ' Draw source node with white border
    CIRCLE (sx1!, sy1!), NODESIZE%, BORDERCOLOR%
    PAINT (sx1!, sy1!), color1%, BORDERCOLOR%
    
    ' Draw target node with white border
    CIRCLE (sx2!, sy2!), NODESIZE%, BORDERCOLOR%
    PAINT (sx2!, sy2!), color2%, BORDERCOLOR%
LOOP

CLOSE #1

' Keep window open
SLEEP
END