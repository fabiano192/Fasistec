#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH030   º Autor ³ Alexandro Silva    º Data ³  15/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Boletim Diario de Producao                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH030()

/*
PXH30_D
PXH30_E
PXH30_F
PXH30_G
PXH30_H
PXH30_I
PXH30_J
PXH30_K

*/

Private cCadastro := "Boletim Diario"
Private aRotina   := {}
Private _lEncont  := .F.
Private _cGrAprov := ""

aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
aAdd(aRotina,{"Visualizar","U_PXH30A",0,2})
aAdd(aRotina,{"Incluir"   ,"U_PXH30A",0,3})
aAdd(aRotina,{"Alterar"   ,"U_PXH30A",0,4})
aAdd(aRotina,{"Excluir"   ,"U_PXH30A",0,5})
aAdd(aRotina,{"Legenda"   ,"U_PXH30A",0,6})

dbSelectArea("SZ8")
dbSetOrder(1)
dbGoTop()

MBrowse(6,1,22,75,"SZ8",,,,,,)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PXH030   ³ Autor  ³ Alexandro da Silva     ³ Data ³08/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PXH30A(cAlias,nReg,nOpcX)

//PREPARE ENVIRONMENT EMPRESA "06" FILIAL "08501" TABLES "SZ8""

Private   Acols	:= {}
Private	_oCodigo,_oCliente,_oLoja,_oNomCli,oGetDados
Private VISUAL  := (nOpcX == 2)
Private INCLUI  := (nOpcX == 3)
Private ALTERA  := (nOpcX == 4)
Private DELETA  := (nOpcX == 5)
Private EXCLUI  := (nOpcX == 5)
Private aHeader := {}
Private _nOpcao := nOpcx

nOpcE := nOpcx
nOpcG := nOpcx

_aCampos := {"Z8_ITEM","Z8_DTMOV","Z8_QTVIAIT","Z8_PRODDIA","Z8_QTAUFIN","Z8_QTPUREZA","Z8_TEOR"}

For AX:= 1 TO Len(_aCampos)
	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AX])
		
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
Next Ax

Private _lEdit      := .F.
Private _lEdit2     := .F.
Private	_cCodigo    := Space(06)
Private	_cAno       := Space(04)
Private	_cMes       := Space(02)
Private	_nQTDCAC    := 0
Private	_nM3CAC     := 0
Private	_nDENSID    := 0
Private	_nQTVIACA   := 0
Private	_nTOTTON    := 0
Private	_nAUACUM    := 0
Private	_nTEORREC   := 0
Private	_nPROAUVL   := 0
Private	_nPROAUPE   := 0
Private	_nPROJVL    := 0
Private	_nPROJPE    := 0
Private	_nFATVAL    := 0
Private	_nFATPER    := 0
Private	_nPRJFAVL   := 0
Private	_nPRJFAPE   := 0
Private	_cUSUARIO   := cUserName
Private	_nPROAUAD   := 0
Private	_nFATAUAD   := 0
Private	_nTEORAD    := 0
Private	_cEmp 		:= SM0->M0_CODIGO
Private	_cFil 		:= Left(SM0->M0_CODFIL,5)

If INCLUI
	
	nOpcE  := 3
	nOpcG  := 3	
	_lEdit := .T.
	_lEdit2:= .T.
	aCols  := {Array(Len(_aCampos)+1)}
	
	aCols[1,Len(_aCampos)+1]:=.F.
	For _ni:=1 to Len(_aCampos)
		If aHeader[_ni,2] = "Z8_ITEM"
			aCols[1,_ni]:= "001"
		Else
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Endif
	Next
	
	_cCodigo    := GETSXENUM("SZ8","Z8_CODIGO")
	ConfirmSX8()
	
	SZ8->(dbSetOrder(2))
	If SZ8->(dbSeek(xFilial("SZ8")+ Left(_cEmp+'   ',5) + _cFil + _cCodigo))
		_lCont := .T.
		While _lCont
			
			_cCodigo    := GETSXENUM("SZ8","Z8_CODIGO")
			ConfirmSX8()
			
			SZ8->(dbSetOrder(2))
			If SZ8->(dbSeek(xFilial("SZ8")+ Left(_cEmp+'   ',5) + _cFil + _cCodigo))
				_lCont := .F.
			Endif
		EndDo
	Endif
	
ElseIf ALTERA
	_lEdit      := .F.
	_lEdit2     := .T.
Endif

Private _nPITEM    := aScan( aHeader, { |x| Alltrim(x[2])== "Z8_ITEM"    } )
Private _nPDTMOV   := aScan( aHeader, { |x| Alltrim(x[2])== "Z8_DTMOV"   } )
Private _nPQTVIAIT := aScan( aHeader, { |x| Alltrim(x[2])== "Z8_QTVIAIT" } )
Private _nPPRODDIA := aScan( aHeader,{ |x| Alltrim(x[2]) == "Z8_PRODDIA" } )
Private _nPQTAUFIN := aScan( aHeader,{ |x| Alltrim(x[2]) == "Z8_QTAUFIN" } )
Private _nPQTPUREZ := aScan( aHeader,{ |x| Alltrim(x[2]) == "Z8_QTPUREZ" } )
Private _nPTEOR    := aScan( aHeader, { |x| Alltrim(x[2])==	"Z8_TEOR"    } )

If nOpcX == 2 .OR. nOpcX == 4 .OR. nOpcX == 5
	
	
	_cANO       := LEFT(SZ8->Z8_ANOMES,4)
	_cMES       := RIGHT(SZ8->Z8_ANOMES,2)
	_cCodigo    := SZ8->Z8_CODIGO
	_nQTDCAC    := SZ8->Z8_QTDCAC
	_nM3CAC     := SZ8->Z8_M3CAC
	_nDENSID    := SZ8->Z8_DENSID
	_nQTVIACA   := SZ8->Z8_QTVIACA
	_nTOTTON    := SZ8->Z8_TOTTON
	_nAUACUM    := SZ8->Z8_AUACUM
	_nTEORREC   := SZ8->Z8_TEORREC
	_nPROAUVL   := SZ8->Z8_PROAUVL
	_nPROAUPE   := SZ8->Z8_PROAUPE
	_nPROJVL    := SZ8->Z8_PROJVL
	_nPROJPE    := SZ8->Z8_PROJPE
	_nFATVAL    := SZ8->Z8_FATVAL
	_nFATPER    := SZ8->Z8_FATPER
	_nPRJFAVL   := SZ8->Z8_PRJFAVL
	_nPRJFAPE   := SZ8->Z8_PRJFAPE
	_cUSUARIO   := SZ8->Z8_USUARIO
	_nPROAUAD   := SZ8->Z8_PROAUAD
	_nFATAUAD   := SZ8->Z8_FATAUAD
	_NQTAUFIN   := SZ8->Z8_QTAUFIN
	_NQTPUREZ   := SZ8->Z8_QTPUREZ
	_nTEORAD    := SZ8->Z8_TEORAD
	
	SZ8->(dbSetOrder(2))
	If SZ8->(dbSeek(xFilial("SZ8")+ Left(_cEmp+'   ',5) + _cFil + _cCodigo))
		
		aCols:={}
		
		While SZ8->(!Eof()) .And. _cCodigo	== SZ8->Z8_CODIGO
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_nPITEM]       := SZ8->Z8_ITEM
			aCols[Len(aCols),_nPDTMOV]      := SZ8->Z8_DTMOV
			aCols[Len(aCols),_nPQTVIAIT]    := SZ8->Z8_QTVIAIT
			aCols[Len(aCols),_nPPRODDIA]    := SZ8->Z8_PRODDIA
			aCols[Len(aCols),_nPQTAUFIN]    := SZ8->Z8_QTAUFIN
			aCols[Len(aCols),_nPQTPUREZ]    := SZ8->Z8_QTPUREZ
			aCols[Len(aCols),_nPTEOR]       := SZ8->Z8_TEOR
			
			aCols[Len(aCols),Len(_aCampos)+1]  := .F.
			
			SZ8->(dbSkip())
		EndDo
	Endif
Endif

cTitulo       := "APONTAMENTO DA PRODUCAO"
cAliasGetD    := "SZ8"
cLinOk        := "AllwaysTrue()"
cTudOk        := PXH30_B()
cFieldOk      := "AllwaysTrue()"

_lRetMod2     := PXH30_C(cTitulo,cAliasGetD,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)

If _lRetMod2
	GravaFat()
Endif



Return




Static Function PXH30_C(cTitulo,cAlias2,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)

Local _lRet83A, _nOpca := 0,cSaveMenuh,oDlg

Private _oCodigo ,_oANO   ,_oMES   ,_oQTDCAC,	_oM3CAC ,_oDENSID ,	_oQTVIACA,_oTOTTON , _oAUACUM,	_oTEORREC,	_oPROAUVL
Private _oPROAUPE,_oPROJVL,_oPROJPE,_oFATVAL,	_oFATPER,_oPRJFAVL,	_oPRJFAPE,_oUSUARIO, _oFATAD ,  _oTEORAD ,  _oPROAUAD

Private aSize	  := MsAdvSize()
Private aObjects  := {}
Private aPosObj   := {}
Private aSizeAut  := MsAdvSize()
Private aButtons  := {}

AAdd( aObjects, { 0,    25, .T., .F. })
AAdd( aObjects, { 100, 100, .T., .T. })
AAdd( aObjects, { 0,    3, .T., .F. })

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T. )

aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

//linha,coluna to linha,coluna
@ 0.3,0.5 TO 3.6, 80.2

@ 0.5,001  Say   "Numero: "
@ 0.5,005  MSGET _oCodigo  Var _cCodigo          When .F. SIZE 25,10

@ 0.5,010  Say   "Ano:"
@ 0.5,012  MSGET _oAno     Var _cAno             When _lEdit  Valid PXH30_D() PICTURE "@!" SIZE 25,10

@ 1.7,010  Say 	"Mes: "
@ 1.7,012  MSCOMBOBOX oMes VAR _cMes   ITEMS {" ","01=Janeiro","02=Fevereiro","03=Marco","04=Abril","05=Maio","06=Junho","07=Julho","08=Agosto","09=Setembro","10=Outubro","11=Novembro","12=Dezembro"}  When _lEdit Valid PXH30_D() SIZE 50,10

@ 0.5,020  Say   "Caç/Viag:"
@ 0.5,025  MSGET _oQTDCAC  Var _nQTDCAC          When _lEdit2  Valid PXH30_G() PICTURE "@E 9999"   SIZE 25,10

@ 1.7,020  Say   "M3/Caçamba:"
@ 1.7,025  MSGET _oM3CAC   Var _nM3CAC          When _lEdit2  Valid PXH30_G() PICTURE "@E 999.99" SIZE 25,10

@ 0.5,030  Say   "Densid.:"
@ 0.5,033  MSGET _oDENSID  Var _nDENSID         When _lEdit2  Valid PXH30_G() PICTURE "@E 9999.99" SIZE 25,10

@ 1.7,030  Say   "Viagem:"
@ 1.7,033  MSGET _oQTVIACA Var _nQTVIACA        When .F.  Valid PXH30_G() PICTURE "@E 9999.99" SIZE 25,10

@ 0.5,039  Say   "Toneladas:"
@ 0.5,044  MSGET _oTOTTON  Var _nTOTTON         When .F. PICTURE "@E 9,999,999" SIZE 55,10

@ 1.7,039  Say   "Au.Acum (g):"
@ 1.7,044  MSGET _oAUACUM  Var _nAUACUM         When .F. PICTURE "@E 9999.99" SIZE 55,10

@ 0.5,055  Say   "Teor de Recuperacao:"
@ 1.7,055  MSGET _oTEORREC Var _nTEORREC        When .F. PICTURE "@E 9999.99" SIZE 20,10
@ 1.7,060  Say   "g/t. Benef."

@ 0.5,065  Say   "Producao Au (g):"
@ 0.5,071  MSGET _oPROAUAD Var _nPROAUAD        When _lEdit2 Valid PXH30_I() PICTURE "@E 9,999,999.99" SIZE 55,10

@ 1.7,065  Say   "Faturamento.(R$):"
@ 1.7,071  MSGET _oFATAUAD Var _nFATAUAD        When _lEdit2 Valid PXH30_J() PICTURE "@E 99,999,999.99" SIZE 55,10

@ 2.9,065  Say   "Teor Ant.(g/t):"
@ 2.9,071  MSGET _oTEORAD  Var _nTEORAD         When _lEdit2 PICTURE "@E 9999.99" SIZE 55,10

@ 2.9,001  Say "Usuario: "
@ 2.9,005  MSGET oUsuario  Var _cUsuario        WHEN .F. SIZE 50,10

@ 4.1,001  Say "Desempenho Em Relação ao PA"

@ 4.3,0.5 TO 6.0, 80.2

@ 4.5,0.7  TO 5.8, 20
@ 4.5,20.5 TO 5.8, 40

@ 4.5,40.5 TO 5.8, 60
@ 4.5,60.5 TO 5.8, 80

@ 5.1,001  Say "Prod.Au(g):"
@ 5.1,005  MSGET _oPROAUVL Var _nPROAUVL        When .F. PICTURE "@E 999,999.99" SIZE 45,10
@ 5.1,012  MSGET _oPROAUPE Var _nPROAUPE        When .F. PICTURE "@E 9999.99"    SIZE 45,10
@ 5.1,018  Say "% PA"

@ 5.1,021  Say "Proj.Prod.Au:"
@ 5.1,025  MSGET _oPROJVL  Var _nPROJVL         When .F. PICTURE "@E 999,999.99" SIZE 45,10
@ 5.1,032  MSGET _oPROJPE  Var _nPROJPE         When .F. PICTURE "@E 9999.99"    SIZE 45,10
@ 5.1,038  Say "% PA"

@ 5.1,041  Say "Faturamento:"
@ 5.1,045  MSGET _oFATVAL  Var _nFATVAL         When _lEdit2 Valid PXH30_J() PICTURE "@E 9,999,999.99" SIZE 50,10
@ 5.1,052  MSGET _oFATPER  Var _nFATPER         When .F. PICTURE "@E 9999.99"      SIZE 45,10
@ 5.1,058  Say "% PA"

@ 5.1,061  Say "Proj.Fatur.:"
@ 5.1,065  MSGET _oPRJFAVL Var _nPRJFAVL        When .F. PICTURE "@E 999,999.99" SIZE 45,10
@ 5.1,072  MSGET _oPRJFAPE Var _nPRJFAPE        When .F. PICTURE "@E 9999.99"    SIZE 45,10
@ 5.1,078  Say "% PA"

nGetLin     := aPosObj[3,1]
oGetDados   := MsGetDados():New(90            ,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_PXH30_E()","AllwaysTrue()","+Z8_ITEM",.T.)

bOK 		:= "{|| If(Empty(_cAno) .Or. Empty(_cMes),(_nOpca := 0, MsgAlert('Ano ou Mês não preenchido!')),"+;
"If(!oGetDados:TudoOk(), (_nOpca := 0 ),"+;
"If(!obrigatorio(aGets,aTela),(_nOpca := 0),(_nOpca := 1 , oDlg:End()))))}"

bCancel 	:= "{ || _nOpca := 0, oDlg:End() }"

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,&(bOk),&(bCancel),,aButtons)

_lRetA := (_nOpca==1)

Return(_lRetA)




Static Function PXH30_B()

Private _lRetorno := .t.

Return(_lRetorno)



Static Function GravaFat()

If INCLUI
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If aCols[AX,_cFim]
			AX := AX
		Else
			
			SZ8->(RecLock("SZ8",.T.))
			SZ8->Z8_FILIAL  := xFilial("SZ8")
			SZ8->Z8_CODEMP  := _cEmp
			SZ8->Z8_CODFIL  := _cFil
			SZ8->Z8_ANOMES	:= _cANO+_cMES
			SZ8->Z8_CODIGO	:= _cCodigo
			SZ8->Z8_QTDCAC	:= _nQTDCAC
			SZ8->Z8_M3CAC	:= _nM3CAC
			SZ8->Z8_DENSID	:= _nDENSID
			SZ8->Z8_QTVIACA	:= _nQTVIACA
			SZ8->Z8_TOTTON	:= _nTOTTON
			SZ8->Z8_AUACUM	:= _nAUACUM
			SZ8->Z8_TEORREC	:= _nTEORREC
			SZ8->Z8_PROAUVL	:= _nPROAUVL
			SZ8->Z8_PROAUPE	:= _nPROAUPE
			SZ8->Z8_PROJVL	:= _nPROJVL
			SZ8->Z8_PROJPE	:= _nPROJPE
			SZ8->Z8_FATVAL	:= _nFATVAL
			SZ8->Z8_FATPER	:= _nFATPER
			SZ8->Z8_PRJFAVL	:= _nPRJFAVL
			SZ8->Z8_PRJFAPE	:= _nPRJFAPE
			SZ8->Z8_USUARIO	:= _cUSUARIO
			SZ8->Z8_PROAUAD	:= _nPROAUAD
			SZ8->Z8_FATAUAD	:= _nFATAUAD
			SZ8->Z8_TEORAD	:= _nTEORAD
			SZ8->Z8_ITEM	:= aCols[AX,_nPITEM]
			SZ8->Z8_DTMOV	:= aCols[AX,_nPDTMOV]
			SZ8->Z8_QTVIAIT	:= aCols[AX,_nPQTVIAIT]
			SZ8->Z8_PRODDIA	:= aCols[AX,_nPPRODDIA]
			SZ8->Z8_QTAUFIN := aCols[AX,_nPQTAUFIN]
			SZ8->Z8_QTPUREZ := aCols[AX,_nPQTPUREZ]
			SZ8->Z8_TEOR	:= aCols[AX,_nPTEOR]
			SZ8->(MsUnlock())
			
		Endif
	Next Ax
	
ElseIf ALTERA
	
	SZ8->(dbSetOrder(2))
	If SZ8->(dbSeek(xFilial("SZ8")+ Left(_cEmp+'   ',5) + _cFil + _cCodigo))
		
		_cChav := SZ8->Z8_CODEMP + SZ8->Z8_CODFIL + SZ8->Z8_CODIGO
		
		While SZ8->(!EOF()) .And. _cChav == SZ8->Z8_CODEMP + SZ8->Z8_CODFIL + SZ8->Z8_CODIGO
			
			SZ8->(RecLock("SZ8",.F.))
			SZ8->(dbDelete())
			SZ8->(MsUnlock())
			
			SZ8->(dbSkip())
		EndDo
		
		
		For AX:= 1 To Len(ACOLS)
			
			_cFim := (Len(aHeader)+1)
			If aCols[AX,_cFim]
				AX := AX
			Else
				SZ8->(RecLock("SZ8",.T.))
				SZ8->Z8_FILIAL  := xFilial("SZ8")
				SZ8->Z8_CODEMP  := _cEmp
				SZ8->Z8_CODFIL  := _cFil
				SZ8->Z8_ANOMES	:= _cANO+_cMES
				SZ8->Z8_CODIGO	:= _cCodigo
				SZ8->Z8_QTDCAC	:= _nQTDCAC
				SZ8->Z8_M3CAC	:= _nM3CAC
				SZ8->Z8_DENSID	:= _nDENSID
				SZ8->Z8_QTVIACA	:= _nQTVIACA
				SZ8->Z8_TOTTON	:= _nTOTTON
				SZ8->Z8_AUACUM	:= _nAUACUM
				SZ8->Z8_TEORREC	:= _nTEORREC
				SZ8->Z8_PROAUVL	:= _nPROAUVL
				SZ8->Z8_PROAUPE	:= _nPROAUPE
				SZ8->Z8_PROJVL	:= _nPROJVL
				SZ8->Z8_PROJPE	:= _nPROJPE
				SZ8->Z8_FATVAL	:= _nFATVAL
				SZ8->Z8_FATPER	:= _nFATPER
				SZ8->Z8_PRJFAVL	:= _nPRJFAVL
				SZ8->Z8_PRJFAPE	:= _nPRJFAPE
				SZ8->Z8_USUARIO	:= _cUSUARIO
				SZ8->Z8_PROAUAD	:= _nPROAUAD
				SZ8->Z8_FATAUAD	:= _nFATAUAD
				SZ8->Z8_TEORAD	:= _nTEORAD
				SZ8->Z8_ITEM	:= aCols[AX,_nPITEM]
				SZ8->Z8_DTMOV	:= aCols[AX,_nPDTMOV]
				SZ8->Z8_QTVIAIT	:= aCols[AX,_nPQTVIAIT]
				SZ8->Z8_PRODDIA	:= aCols[AX,_nPPRODDIA]
				SZ8->Z8_QTAUFIN := aCols[AX,_nPQTAUFIN]
				SZ8->Z8_QTPUREZ := aCols[AX,_nPQTPUREZ]
				SZ8->Z8_TEOR	:= aCols[AX,_nPTEOR]
				SZ8->(MsUnlock())
				
			Endif
		Next Ax
	Endif
	
ElseIf EXCLUI
	
	SZ8->(dbSetOrder(2))
	If SZ8->(dbSeek(xFilial("SZ8")+ Left(_cEmp+'   ',5) + _cFil + _cCodigo))
		
		_cChav := SZ8->Z8_CODEMP + SZ8->Z8_CODFIL + SZ8->Z8_CODIGO
		
		While SZ8->(!EOF()) .And. _cChav == SZ8->Z8_CODEMP + SZ8->Z8_CODFIL + SZ8->Z8_CODIGO
			
			SZ8->(RecLock("SZ8",.F.))
			SZ8->(dbDelete())
			SZ8->(MsUnlock())
			
			SZ8->(dbSkip())
		EndDo
	Endif
Endif


Return



User Function MZ2103()

lOk      := .T.
_aVerDup := {}

For Ax:= 1 To Len(Acols)
	
	_cProduto := Acols[AX,_nPPRODUT]
	_cStatus  := Acols[AX,_nPSTATUS]
	
	If _cStatus == "B"
		Loop
	Endif
	
	_cFim := (Len(aHeader)+1)
	If aCols[AX,_cFim]
		If !Empty(_cProduto)
			MSGSTOP("LINHA NAO PODE SER DELETADA!!")
			lOK := .F.
		Endif
	Else
		If ASCAN( _aVerDup,{|x| x[1] == _cProduto .And. X[2] = _cStatus }) == 0
			AADD( _aVerDup,{_cProduto,_cStatus})
		Else
			MSGSTOP(" Produto Ja lançado!!!")
			lOK := .F.
		Endif
	Endif
Next Ax

Return(lOk)


Static Function PXH30_D()

If _cAno >= "2012" .And. _cAno <= "2030"
	
	_nUltDia := DAY(LastDay(CTOD("01/"+_cMes+"/"+_cAno)))
	
	If !Empty(Alltrim(_cMes)) .And. !Empty(Alltrim(_cAno))
		
		SZ8->(dbSetOrder(1))
		If !SZ8->(dbSeek(xFilial("SZ8")+ Left(_cEmp+'   ',5) + _cFil + _cAno+_cMes))
			
			For AX:= 1 To Len(Acols)
				
				ACOLS[AX,_nPDTMOV]       := CTOD(STRZERO(AX,2)+"/"+_cMes+"/"+_cAno)
				ACOLS[AX,Len(_aCampos)+1]:= .F.
				
				If AX > _nUltDia
					aCols[AX,Len(_aCampos)+1]:=.T.
				Endif
			Next AX
			
			If Len(Acols) < _nUltDia
				For AX:= Len(Acols)+1 To _nUltDia
					
					AADD(aCols,Array(Len(_aCampos)+1))
					
					For AZ:=1 to Len(_aCampos)
						If aHeader[AZ,2] = "Z8_ITEM"
							aCols[Len(aCols),AZ]:= StrZero(AX,3)
						ElseIf aHeader[AZ,2] = "Z8_DTMOV"
							aCols[Len(aCols),AZ]:= CTOD(STRZERO(AX,2)+"/"+_cMes+"/"+_cAno)
						Else
							aCols[Len(aCols),AZ]:=CriaVar(aHeader[AZ,2])
						Endif
					Next AZ
					
					aCols[Len(aCols),Len(_aCampos)+1]:=.F.
				Next AX
			Endif
			
			_nDiaTrab  := 0
			_nTOT      := 0
			_nTOTVIACA := 0
			For Ax:= 1 To Len(Acols)
				
				_cFim := (Len(aHeader)+1)
				If !aCols[AX,_cFim]
					_nTOTVIACA += Acols[AX,_nPQTVIAIT]
					_nProdDia  := Acols[AX,_nPPRODDIA]
					_nQtViag   := Acols[AX,_nPQTVIAIT]
					
					If _nQtViag > 0
						_nDiaTrab++
					Endif
					
					_nTOT += Acols[AX,_nPPRODDIA]
					
					If _nProdDia > 0
						Acols[AX,_nPTEOR] := _nProdDia / (_nQtViag * _nQTDCAC * _nM3CAC * _nDENSID)
					Endif
				Endif
			Next Ax
			
			_nAUACUM := _nTOT
			_nPROAUVL:= _nTOT
			_nPROAUPE:= (_nTOT / _nPROAUAD) * 100
			
			If _nTOT > 0
				_nPROJVL:= (_nAUACUM / _nDiaTrab) * Len(Acols)
				_nPROJPE:= _nPROJVL / _nPROAUAD
			Endif
			
			If _nTOTTON == 0
				_nTEORREC := 0
			Else
				_nTEORREC := Round(_nAUACUM / _nTOTTON,2)
			Endif
			
			_nQTVIACA:= _nTOTVIACA
			_nTOTTON := _nQTDCAC * _nM3CAC * _nDENSID * _nQTVIACA
			
			_oTEORREC:Refresh()
			_oAUACUM:Refresh()
			_oPROAUVL:Refresh()
			_oPROAUPE:Refresh()
			_oTOTTON:Refresh()
			_oQTVIACA:Refresh()
			
			oGetDados:oBrowse:Refresh()
			
		Else
			MSGAlert("Já existem dados para o Ano e Mês selecionados!")
			Return(.F.)
		Endif
	Endif
Else
	MSGSTOP("Favor Digitar o Ano Corretamente!!")
	Return(.F.)
Endif

Return


User Function PXH30_E()

_lRet := .T.
_cFim := (Len(aHeader)+1)
If aCols[N,_cFim]
	MSGSTOP("LINHA NAO PODE SER DELETADA!!")
	_lRet := .F.
Endif

Return(_lRet)


User Function PXH30_F()

Local _nProdDia  := 0
Local _nQtViag   := 0

_aAliOri   := GetArea()
_nTOTVIACA := 0
_nRet      := Acols[N,_nPQTVIAIT]

For Ax:= 1 To Len(Acols)
	
	_cFim := (Len(aHeader)+1)
	If !aCols[AX,_cFim]
		_nTOTVIACA += Acols[AX,_nPQTVIAIT]
		_nProdDia  := Acols[AX,_nPPRODDIA]
		_nQtViag   := Acols[AX,_nPQTVIAIT]
		
		Acols[AX,_nPTEOR] := _nProdDia / (_nQtViag * _nQTDCAC * _nM3CAC * _nDENSID)
	Endif
Next Ax

_nQTVIACA:= _nTOTVIACA
_nTOTTON := _nQTDCAC * _nM3CAC * _nDENSID * _nQTVIACA

_oTOTTON:Refresh()
_oQTVIACA:Refresh()

RestArea(_aAliOri)

Return(_nRet)


Static Function PXH30_G()

Local _nProdDia := 0
Local _nQtViag  := 0

_lRet := .T.

_nTOTTON:= _nQTDCAC * _nM3CAC * _nDENSID * _nQTVIACA

If _nTOTTON == 0
	_nTEORREC := 0
Else
	_nTEORREC := Round(_nAUACUM / _nTOTTON,2)
Endif

_nTOT := 0

For Ax:= 1 To Len(Acols)
	
	_cFim    := (Len(aHeader)+1)
	_nProdDia:= Acols[AX,_nPPRODDIA]
	_nQtViag := Acols[AX,_nPQTVIAIT]
	
	If !aCols[AX,_cFim]
		_nTOT += Acols[AX,_nPPRODDIA]
		
		If _nProdDia > 0
			Acols[AX,_nPTEOR] := _nProdDia / (_nQtViag * _nQTDCAC * _nM3CAC * _nDENSID)
		Endif
	Endif
Next Ax

_oTOTTON:Refresh()
_oTEORREC:Refresh()
oGetDados:oBrowse:Refresh()

Return(_lRet)


User Function PXH30_H()

Local _nProdDia:= 0
LOcal _nQtViag := 0
Local _nDiaTrab   := 0

_aAliOri  := GetArea()

_nTOT                := 0
_nRet                := Acols[N,_nPPRODDIA]
Acols[N,_nPQTPUREZ]  := Acols[N,_nPQTAUFIN] / Acols[N,_nPPRODDIA]

For Ax:= 1 To Len(Acols)
	
	_cFim    := (Len(aHeader)+1)
	
	If !aCols[AX,_cFim]
		
		_nProdDia:= Acols[AX,_nPPRODDIA]
		_nQtViag := Acols[AX,_nPQTVIAIT]
		
		If _nQtViag > 0
			_nDiaTrab++
		Endif
		
		_nTOT += Acols[AX,_nPPRODDIA]
		
		If _nProdDia > 0
			Acols[AX,_nPTEOR] := _nProdDia / (_nQtViag * _nQTDCAC * _nM3CAC * _nDENSID)
		Endif
	Endif
Next Ax

_nAUACUM := _nTOT
_nPROAUVL:= _nTOT
_nPROAUPE:= (_nTOT / _nPROAUAD) * 100

If _nTOT > 0
	_nPROJVL:= (_nAUACUM / _nDiaTrab) * Len(Acols)
	_nPROJPE:= _nPROJVL / _nPROAUAD
Endif

If _nTOTTON == 0
	_nTEORREC := 0
Else
	_nTEORREC := Round(_nAUACUM / _nTOTTON,2)
Endif

_oTEORREC:Refresh()
_oAUACUM:Refresh()
_oPROAUVL:Refresh()
_oPROAUPE:Refresh()

RestArea(_aAliOri)

Return(_nRet)


Static Function PXH30_I()

_lRet    := .T.
_nPROAUPE:= _nPROAUVL / _nPROAUAD
_nPRJFAPE:= _nPRJFAVL / _nPROAUAD

_oPROAUPE:Refresh()
_oPRJFAPE:Refresh()

Return(_lRet)


Static Function PXH30_J()

_lRet    := .T.

_nFATPER := _nFATVAL / _nFATAUAD

If _nFATVAL > 0
	_nPRJFAVL:= _nFATVAL * Len(Acols) // Quantidade de Dias trabalhados
	_nPRJFAPE:= _nPRJFAVL / _nPROAUAD
Endif

_oFATPER:Refresh()
_oPRJFAVL:Refresh()
_oPRJFAPE:Refresh()

Return(_lRet)

User Function PXH30_K()

_nPureza  := Acols[N,_nPQTAUFIN] / Acols[N,_nPPRODDIA] 

Return(_nPureza)