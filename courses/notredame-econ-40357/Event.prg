' Event.prg For the event study

' QUESTION 6a
smpl @all
for !j = 1 to 20      'CUMULATE ABNORMAL RETURNS FULL SAMPLE
 series carq6a_{!j} = @cumsum(firm{!j})
next
group a_6a            'CREATE GROUP TO HOLD CUMULATED ARs
smpl 1  20
for !j = 1 to 20
 a_6a.add carq6a_{!j}
next
a_6a.line      ' PLOT
'----------------------------------------------------------------------
' QUESTION 6b  CALCULATING EQ(4) FROM THE LECTURE SLIDES
smpl 260 290   ' EVENT WINDOW
group a_6b     ' CREATE GROUP
for !j = 1 to 20
  series stoq6b_{!j} = firm{!j}
  series carq6b_{!j} = @cumsum(stoq6b_{!j})   ' CUMULATE AR OVER THE EVENT WINDOW
  a_6b.add stoq6b_{!j}
next

matrix(20,3) a_q6bresults   ' MATRIX TO STORE RESULTS Col_1: Cum AR Col_2: TS variance Col_3: t-ratio
for !j = 1 to 20
 a_q6bresults(!j,1) = carq6b_{!j}(290)  ' THE LAST OBSERVATION OF CUMULATED ARs
next

smpl 1 259     ' SAMPLE VARIANCE FOR FIRM !j COMPUTED OVER PRE-EVENT WINDOW
for !j = 1 to 20
  a_q6bresults(!j,2) = @var(firm{!j})   ' SAMPLE VARIANCE OVER PRE-EVENT WINDOW
next
for !j = 1 to 20       ' COLUMN 3 IS THE NORMALIZED CAR
  a_q6bresults(!j,3) = a_q6bresults(!j,1)/ ((a_q6bresults(!j,2))^0.5)
next

'----------------------------------------------------------------------
'QUESTION 6c  AVERAGE CUMULATED ARs ACROSS FIRMS, PRE-AND EVENT WINDOWS
smpl 1 290        ' PRE AND EVENT WINDOW
series csavg = carq6a_1
for !j = 2 to 20
 series csavg =  csavg + carq6a_{!j}  ' CROSS SECTIONAL SUM
next
smpl 1 290
series carq6c = csavg/20             ' CROSS SECTIONAL AVERAGE
carq6c.line      'PLOTTING THE AVERAGE ACROSS FIRMS

'----------------------------------------------------------------------
'QUESTION 6D: AVERAGE CUMULATED RETURNS AT T=290 ACROSS FIRMS, (1/(N*N)) SUM VARIANCES
' Take matrix q6bresults. Do sums in Excel
