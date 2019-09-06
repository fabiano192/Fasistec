#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CR0052   ³ Autor ³ Fabiano da Silva      ³ Data ³ 24.01.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Produtos com Estrutura                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0052()

	_aAliOri := GetArea()
	Private _cDescPa := ""
	_cComposto := _cInserto := _cMolde := ""
	_nOpc      := 0

	AtuSX1()

	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Produtos")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina criado para Gerar tabela de Produtos "     SIZE 160,7
	@ 18,18 SAY "  "     SIZE 160,7
	@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     SIZE 160,7
	@ 34,18 SAY "Programa CR0052 (TABELA) CR0052.DBF      "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("CR0052")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	If _nOpc == 1
		Proces()
	Endif

Return


Static Function Proces()

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Private _cTitulo01 := 'Processando'

	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	ZB1->(dbCloseArea())


	_cDir:= "C:\TOTVS\"
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	_cData   := DTOS(dDataBase)
	_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	TMP->(dbCloseArea())

	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
		Return
	EndIf

	_cNomArq := "\SPOOL\ESTRUTURA_"+_cData+"_"+_cHora+".XLS"
	
	dbSelectArea("TRB")
	COPY ALL TO &_cNomArq

	TRB->(dbCloseArea())

	If !__CopyFile(_cNomArq, "c:\totvs\estrutura_"+_cData+"_"+_cHora+".xls" )
		MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
	Else

		FErase(_cNomArq)
		
		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf
	
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "c:\totvs\estrutura_"+_cData+"_"+_cHora+".xls" )
		oExcelApp:SetVisible(.T.)
	Endif
	
Return



Static Function Proc1(_lFim)

	Pergunte("CR0052",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Produto De ?          ////
///// MV_PAR02 - produto Ate ?         ////
///// MV_PAR03 - Grupo De ?         ////
///// MV_PAR04 - Grupo Ate ?         ////
///////////////////////////////////////////

	Private _nNiv := 0
	Private _lGravou := .F.

	aStru := {}
	AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
	AADD(aStru,{"NOMPROD"     , "C" , 50, 0 })
	AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
	AADD(aStru,{"MATERIAL"    , "C" , 45, 0 })
	AADD(aStru,{"INSERTO"     , "C" , 45, 0 })
	AADD(aStru,{"PESO_PF1"    , "N" , 14, 4 })
	AADD(aStru,{"PESO_PF2"    , "N" , 14, 4 })
	AADD(aStru,{"AREA_VZ1"    , "N" , 14, 4 })
	AADD(aStru,{"AREA_VZ2"    , "N" , 14, 4 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "PRODUTO"

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	aStru1 := {}
	AADD(aStru1,{"PRODUTO"     , "C" , 15, 0 })
	AADD(aStru1,{"MOLDE"       , "C" , 45, 0 })
	AADD(aStru1,{"MATERIAL"    , "C" , 45, 0 })
	AADD(aStru1,{"INSERTO"     , "C" , 45, 0 })

	_cArqTrb := CriaTrab(aStru1,.T.)
	_cIndTrb := "PRODUTO"

	dbUseArea(.T.,,_cArqTrb,"TMP",.F.,.F.)

	dbSelectArea("TMP")
	IndRegua("TMP",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")


	_cQ := " SELECT * FROM SB1010 B1 "
	_cQ += " WHERE B1.D_E_L_E_T_ = '' AND B1_TIPO = 'PA' "
	_cQ += " AND B1_COD     BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQ += " AND B1_GRUPO   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQ += " ORDER BY B1_COD "

	TCQUERY _cQ NEW ALIAS "ZB1"

	ZB1->(dbGotop())
	ProcRegua(ZB1->(U_CONTREG()))

	While ZB1->(!Eof()) .And. !_lFim
	
		If _lFim
			Alert("Cancelado Pelo Usuario!!!!")
			Return
		Endif
	
		IncProc()

		_cComposto := _cMolde := _cInserto := ""
	
		SB1->(dbSeek(xFilial("SB1")+ZB1->B1_COD))
	
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+ZB1->B1_COD))
			_cProd   := SG1->G1_COD
			nNivel   := 2
		
			SB1->(dbSeek(xFilial("SB1")+_cProd))
			
			If TMP->(!dbSeek(_cProd))
				_nSdoAca   := 0
				_nQtPa     := _nQtPI1 := _nQtPI2 := _nQtBK := _nQtC1 := _nQtC2 := _nQtK1 := _nQtK2 := _nCont := _nCont1 := _nCont2 := 0
				NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
				TMP->(RecLock("TMP",.T.))
				TMP->PRODUTO  := _cProd
				TMP->MOLDE    := _cMolde
				TMP->MATERIAL := _cComposto
				TMP->INSERTO  := _cInserto
				TMP->(MsUNlock())
			Else
				_cComposto := TMP->MATERIAL
				_cMolde    := TMP->MOLDE
				_cInserto  := TMP->INSERTO
			Endif
		Else
			_nQtPI1 := _nQtC1 := _nQtPI2 := _nQtC2 := _nQtBK := _nQtK1 := _nQtBK := _nQtK2 := 0
		Endif
	
		TRB->(RecLock("TRB",.T.))
		TRB->PRODUTO  := ZB1->B1_COD
		TRB->NOMPROD  := ZB1->B1_DESC
		TRB->MOLDE    := _cMolde
		TRB->MATERIAL := _cComposto
		TRB->INSERTO  := _cInserto
		TRB->PESO_PF1 := _nQtPI1 * _nQtC1
		TRB->PESO_PF2 := _nQtPI2 * _nQtC2
		TRB->AREA_VZ1 := _nQtBK * _nQtK1
		TRB->AREA_VZ2 := _nQtBK * _nQtK2
		TRB->(MsUNlock())
	
		ZB1->(dbSkip())
	EndDo

Return



Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

	Local _nReg := 0
	Local _nRegTrb := 0

	SG1->(dbSetOrder(1))

	While SG1->(!Eof()) .And. SG1->G1_COD == _cProd  .And. !_lFim
	
		_nReg := SG1->(Recno())
	
		dbSelectArea("SG1")
		dbSetOrder(1)
	
		aAreaSB1:=SB1->(GetArea())
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
	
		_nRegTRb := SB1->(Recno())
	
		If SB1->B1_GRUPO $ "PIC /MPC "   // Material Utilizado
		
			If SB1->B1_COD != 'B45'
				_cComposto += ALLTRIM(SG1->G1_COMP)+ " "
			
				_nCont ++
				If _nCont = 1
					_nQtC1 := SG1->G1_QUANT
				ElseIf _nCont = 2
					_nQtC2 := SG1->G1_QUANT
				Endif
			Endif
		ElseIf SB1->B1_GRUPO $  "MPIM/PIPM"   // PRE FORMADO / INSERTO  METALICO
			_cInserto  += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   // Molde de Vulcanização / Ferramenta
			_cMolde    += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $  "PIPF"   // PRE FORMADO
			_nCont1 ++
			If _nCont1 = 1
				_nQtPI1 := SG1->G1_QUANT
			ElseIf _nCont1 = 2
				_nQtPI2 := SG1->G1_QUANT
			Endif
		ElseIf SB1->B1_GRUPO $  "PIBK"   // Blank Vazados
			_nQtBK := SG1->G1_QUANT
		ElseIf SB1->B1_GRUPO $  "MPVZ"   // Mat. Prima Vazados
			_cComposto += ALLTRIM(SG1->G1_COMP)+ " "
			_nCont2 ++
			If _nCont2 = 1
				_nQtK1 := SG1->G1_QUANT
			ElseIf _nCont2 = 2
				_nQtK2 := SG1->G1_QUANT
			Endif
		Endif
	
		RestArea(aAreaSB1)
	
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
	
		SG1->(dbGoto(_nReg))

		SG1->(dbSkip())
	EndDo

Return



Static Function AtuSX1()

	cPerg := "CR0052"
	aRegs :={}

///////////////////////////////////////////////
///////////////////////////////////////////////
/////  MV_PAR01 : Produto      De ?      //////
/////  MV_PAR02 : Produto     Ate ?      //////
/////  MV_PAR03 : Grupo        De ?      //////
/////  MV_PAR04 : Grupo       Ate ?      //////
///////////////////////////////////////////////
///////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Produto De            ?",""       ,""      ,"mv_ch1","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"02","Produto Ate           ?",""       ,""      ,"mv_ch2","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR02",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"03","Grupo   De            ?",""       ,""      ,"mv_ch3","C" ,04     ,0      ,0     ,"G",""        ,"MV_PAR03",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
	U_CRIASX1(cPerg,"04","Grupo   Ate           ?",""       ,""      ,"mv_ch4","C" ,04     ,0      ,0     ,"G",""        ,"MV_PAR04",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")

Return
