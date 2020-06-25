#INCLUDE "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH039   º Autor ³ Alexandro da Silvaº Data ³  23/11/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Manutencao da Movimentacao Bancaria                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH039()

cCadastro := "Alteracao da Natureza - Movimentacao Bancaria "

aRotina   := { {"Pesquisar"  ,"AxPesqui"   ,0,1},;
{"Visualizar" ,"AxVisual"   ,0,2},;
{"Alterar"    ,'U_PX39_01()',0,3} }


DbSelectArea("SE5")

MBrowse(6,1,22,75,"SE5")

Return


User Function PX39_01()

If !Empty(SE5->E5_TIPO)
	MSGINFO("Esse Registro Nao Pode Ser Alterado!!")
	Return
Endif

If SE5->E5_TIPODOC $ "PA/RA/CH"
	MSGINFO("Esse Registro Nao Pode Ser Alterado!!")
	Return
Endif

If !Empty(SE5->E5_SITUACA)
	MSGINFO("Esse Registro Nao Pode Ser Alterado!!")
	Return
Endif

If !Empty(SE5->E5_MOTBX)
	MSGINFO("Esse Registro Nao Pode Ser Alterado!!")
	Return
Endif

If !Empty(SE5->E5_RECONC)
	MSGINFO("Esse Registro Nao Pode Ser Alterado!!")
	Return
Endif

Private _cNatureza:= SE5->E5_NATUREZ
Private _cDesNaT  := space(30)

SED->(dbSetOrder(1))
SED->(dbSeek(xFilial("SED") + SE5->E5_NATUREZ))

_cDesNat := SED->ED_DESCRIC

_nOpc := 0

@ 000,000 TO 160,450 DIALOG oDlg    TITLE "Alteraracao da Natureza"

@ 005,005 Say "Data : "
@ 005,030 Get SE5->E5_DATA    WHEN .F.  Size 40,040
@ 005,080 Say "Valor: "
@ 005,110 Get SE5->E5_VALOR	  WHEN .F.  SIZE 60,040	PICTURE TM(SE5->E5_VALOR,14)

@ 020,005 Say "Banco"
@ 020,030 get SE5->E5_BANCO   WHEN .F.  Size 30,040 PICTURE "@!"

@ 020,080 Say "Agencia"
@ 020,110 get SE5->E5_AGENCIA WHEN .F.  Size 30,040 PICTURE "@!"

@ 020,155 Say "Conta"
@ 020,175 get SE5->E5_CONTA   WHEN .F.  Size 40,040

@ 050,005 Say "Natureza"
@ 050,030 get _cNatureza 	  WHEN .T.  Valid PX39_01() F3 "SED" Size 40,040

@ 050,080 get _cDesnat        WHEN .F.  Size 120,040

@ 065,150 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 065,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg    CENTER

If _nOpc == 1
	dbSelectArea("SE5")
	If RecLock("SE5",.F.)
		SE5->E5_NATUREZ := _cNatureza
		MsUnLock()
	Endif
Endif

Return


Static Function PX39_01()

_lRet := .F.

If !Empty(_cNatureza)
	
	SED->(dbSetOrder(1))
	If SED->(dbSeek(xFilial("SED") + _cNatureza))
		
		_cDesNat := SED->ED_DESCRIC
		_lRet    := .T.
		
	Endif
Endif

Return(_lRet)