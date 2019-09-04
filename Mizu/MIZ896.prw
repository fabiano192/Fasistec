#include "rwmake.ch"        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo     ³ MIZ896   ³ Autor ³ MICROSIGA Vit¢ria     ³ Data ³16/05/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo  ³ Geracao do digito verificador                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Para uso   ³ Mizu                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                         

User Function MIZ896A()

	_aAliOri := GetArea()
	_aAliSA1 := SA1->(GetArea())
	_cCod    := M->A1_YCODDEP

	If Empty(_cCod)
		SA1->(dbOrderNickName("INDSA12"))
		SA1->(dbGobottom())
		If Substr(SA1->A1_YCODDEP,2,1) <> "C"
			_cCod := Soma1(SA1->A1_YCODDEP)
		Endif
	Endif

	RestArea(_aAliSA1)
	RestArea(_aAliOri)


Return(_cCod)






User Function MIZ896()      

Local nnum := Paramixb,nsoma := 0,amat := { 2,7,6,5,4,3,2},x,cret,nresto:=0
For x:= 1 to 7
    nsoma += (VAL(Subs(nnum,x,1)) * amat[x])
Next
nresto     := nsoma % 11
If nresto == 0                  
   cret := 0
ElseIf nresto == 10                  
   cret := 1
ElseIf nresto == 1
   cret := 0         
Else             
   nresto     := 11 - nresto
   cret := nresto         
EndIf
cret := ALLTRIM(str(Int(cret)))

Return(cret) 

User Function MIZ896B()      

Local nnum := "0000"+Paramixb,nsoma := 0,amat := { 7,8,9,2,3,4,5,6,7,8,9},x,cret,nresto:=0
For x:= 1 to 11
    nsoma += (VAL(Subs(nnum,x,1)) * amat[x])
Next
nresto     := nsoma % 11
If nresto == 10                  
   cret := "X"
ElseIf nresto == 0
   cret := ALLTRIM(str(Int(0)))         
Else             
   cret := ALLTRIM(str(Int(nresto)))
EndIf
Return(cret)