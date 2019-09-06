#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACEDIVER  º Autor ³ Alexandro da Silva º Data ³  06/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao Produto X Cliente                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACEDIVER()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Acertos Diversos ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina Para Efetuar atualizações diversas 			 "     SIZE 160,7

	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	If _nOpc == 1
		Private _cMsg01    := ''
		Private _lFim      := .F.
		Private _lAborta01 := .T.
		Private _bAcao01       := {|_lFim| PROC1(@_lFim) }    /// PARAMETROS
		Private _cTitulo01 := 'Acerto Diversos!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	Endif

	Return


Static Function PROC1(_lFim)

	Local aContab 		:= {}
	Local nOpc   		:= 3

/*
_cArqDbf := "PLANO.DBF"
_cArqInd := "CT1"

_cIndTRB := "CONTA"

dbUseArea(.T.,,_cArqDBF,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqInd,_cIndTRB,,,"Criando Trabalho...")

TRB->(dbGotop())
*/

	SB1->(dbGotop())

	While SB1->(!Eof())

		CG1->(dbsetOrder(1))
		If CG1->(dbSeek(xFilial("CG1")+LEFT(SB1->B1_POSIPI,8)))
			SB5->(dbSetOrder(1))
			If SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
				SB5->(RecLock("SB5",.F.))
				SB5->B5_INSPAT	:= "1"
				SB5->B5_CODATIV	:= CG1->CG1_CODIGO
				SB5->(MsUnlock())
			Else
				Proc2()
			Endif
		Endif

		SB1->(dbSkip())
	Enddo

	MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")

	Return



Static Function PROC2()

	Local aCab := {}

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	_aAliORI  := GetArea()
	_aAliSB5  := SB5->(GetArea())
	_aAliSB1  := SB1->(GetArea())


	_cCod 		:= SB1->B1_COD
	_cNome		:= SB1->B1_DESC
	_cInsPat	:= "1"
	_cCodAti	:= CG1->CG1_CODIGO

	aCab:= { 	{"B5_COD"   	,_cCod  	,Nil},;		// Codigo identificador do produto
	{"B5_CEME"  	,_cNome 	,Nil},;		// Nome cientifico do produto
	{"B5_INSPAT"   	,_cInsPat 	,Nil},;		// INSS patronal
	{"B5_CODATIV"  	,_cCodAti 	,Nil}}		// Código de atividade

	MSExecAuto({|x,y| Mata180(x,y)},aCab,3) //Inclusao

	conout("Acabou de executar a rotina automatica do Cadastro de Complemento do Produto")//-- Retorno de erro na execucao da rotina

	If lMsErroAuto
		conout("erro")
		cErro:=MostraErro()
	Else
		conout("Ok")
	Endif

	RestArea(_aAliSB1)
	RestArea(_aAliSB5)
	RestArea(_aAliOri)

	Return
