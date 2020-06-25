#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ BRI008   ³ Autor ³Alexandro da Silva     ³ Data ³ 28.08.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acerto dos Registros do CENTRO DE CUSTOS                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONTABIL                     -                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BRI008()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Atualizaçao")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Atualizacao do Centro de Custos         "     SIZE 160,7
@ 18,18 SAY "                                                    "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "Programa BRI008.prw                                 "     SIZE 160,7

@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| BRI08_01(@_lFim) }
	Private _cTitulo01 := 'Atualizando Cadastros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return (Nil)


Static Function BRI08_01()

_aCampos := {{"SPH","PH_CC"},{"SPI","PI_CC"},{"SPK","PK_CC"},{"SPL","PL_CC"},{"SPN","PN_CC"},{"SPY","PY_CC"},{"SQ3","Q3_CC"},{"SQ4","Q4_CC"},;
{"SQB","QB_CC"},{"SQG","QG_CC"},{"SQS","QS_CC"},{"SR0","R0_CC"},{"SR1","R1_CC"},{"SRA","RA_CC"},{"SRC","RC_CC"},{"SRD","RD_CC"},{"SRE","RE_CCD"},;
{"SRE","RE_CCP"},{"SRI","RI_CC"},{"SRK","RK_CC"},{"SRL","RL_CC"},{"SRO","RO_CC"},{"SRR","RR_CC"},{"SRT","RT_CC"},{"SRZ","RZ_CC"}}

_aEmpresa := {"01","02","03","04","06","08","09","10","11"}

_cQ := "SELECT * FROM CTTNOVO WHERE D_E_L_E_T_ = ''  AND CODANT <> '' "
_cQ += "ORDER BY CODANT "

TCQUERY _cQ NEW ALIAS "ZZ"

ZZ->(dbGotop())

ProcRegua(ZZ->(U_CONTREG()))

While ZZ->(!Eof())
	
	_cCRDE   := ZZ->CODANT
	_cCRPARA := ZZ->CTT_CUSTO
	
	Incproc("Centro Custo--> "+_cCRDE)
	
	ConOut("Centro de Custo-->"+_cCRDE)
	
	For AX:= 1 TO Len(_aEMPRESA)
		
		FOR AZ:= 1 TO LEN(_aCampos)
			_cQ := "UPDATE "+_aCampos[AZ,1]+_aEmpresa[AX]+"0 SET "+_aCampos[AZ,2]+" = '"+_cCRPARA+"' WHERE "+_aCampos[AZ,2]+" = '"+_cCRDE+"' "
			TCSQLEXEC(_cq)
		Next AZ
		
	Next AX
	
	ZZ->(dbSkip())
EndDo

ZZ->(dbCloseArea())

MSGINFO("Alteracao Efetuada com Sucesso !!! ")

Return ()