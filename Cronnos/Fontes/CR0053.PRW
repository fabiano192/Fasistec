#include "TOTVS.ch"
#INCLUDE "TOPCONN.CH"

/*
Programa:	CR0053
Autor:		Fabiano da Silva
Data:		31/01/14
Descrição:	Geração de planilha em Excel dos Pedidos Faturados
*/

User Function CR0053()


	Private oDlg

	_aAliOri := GetArea()
	Private _cDescPa := ""
	Private _cLocPad   := _cQtCav := ""
	Private _nMedida   := 0
	Private _cComposto := _cMolde := _cInserto := ""
	Private _nOpc      := 0

	AtuSX1()

	DEFINE MSDIALOG oDlg FROM 0,0 TO 290,390 PIXEL TITLE "Pedidos Faturados"

	@ 10 ,10 SAY "Rotina criada para gerar relatório em Excel " OF oDlg PIXEL Size 150,010
	@ 25 ,10 SAY "dos Pedidos Faturados conforme parâmetros   "	OF oDlg PIXEL Size 150,010
	@ 40 ,10 SAY "informados pelo usuário.   				  "	OF oDlg PIXEL Size 150,010
	@ 55 ,10 SAY "Programa CR0053" 								OF oDlg PIXEL Size 150,010

	@ 90,030 BUTTON "Parametros" SIZE 036,012 PIXEL ACTION (Pergunte("CR0053")) 				OF oDlg
	@ 90,070 BUTTON "OK" 		 SIZE 036,012 PIXEL ACTION (Processa({|| Proces() }),oDlg:End()) OF oDlg
	@ 90,110 BUTTON "Sair"       SIZE 036,012 PIXEL ACTION ( oDlg:End()) 						OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function Proces()

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Private _cTitulo01 := 'Processando'

	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	ZD2->(dbCloseArea())

	_cDir:= "C:\TOTVS\"
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	_cData   := DTOS(dDataBase)
	_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cNomArq := "\SPOOL\FAT_CRONNOS_"+_cData+"_"+_cHora+".XLS"

	dbSelectArea("TRB")
	COPY ALL TO &_cNomArq

	TRB->(dbCloseArea())

	If !__CopyFile(_cNomArq, "C:\TOTVS\FAT_CRONNOS_"+_cData+"_"+_cHora+".xls" )
		MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
	Else

		FErase(_cNomArq)
		
		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf
	
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "C:\TOTVS\FAT_CRONNOS_"+_cData+"_"+_cHora+".xls" )
		oExcelApp:SetVisible(.T.)
	Endif

Return



Static Function Proc1(_lFim)

	Pergunte("CR0053",.F.)

	Private _nNiv := 0
	Private _lGravou := .F.

	aStru := {}
	AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
	AADD(aStru,{"NOMPROD"     , "C" , 50, 0 })
	AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
	AADD(aStru,{"PO"     	  , "C" , 15, 0 })
	AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
	AADD(aStru,{"LOJA"        , "C" , 02, 0 })
	AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
	AADD(aStru,{"EMIS_PV"     , "D" , 08, 0 })
	AADD(aStru,{"PEDIDO"      , "C" , 06, 0 })
	AADD(aStru,{"ITEMPV"      , "C" , 02, 0 })
	AADD(aStru,{"TIPOPV"      , "C" , 20, 0 })
	AADD(aStru,{"DTENTR"      , "D" , 08, 0 })
	AADD(aStru,{"QTDPED"      , "N" , 12, 2 })
	AADD(aStru,{"QTDENT"      , "N" , 12, 2 })
	AADD(aStru,{"QTDSDO"      , "N" , 12, 2 })
	AADD(aStru,{"RESIADUO"    , "C" , 01, 0 })
	AADD(aStru,{"EMIS_FT"     , "D" , 08, 0 })
	AADD(aStru,{"NF"          , "C" , 09, 0 })
	AADD(aStru,{"MATERIAL"    , "C" , 45, 0 })
	AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
	AADD(aStru,{"INSERTO"     , "C" , 45, 0 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "PRODUTO+PEDIDO"

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	aStru := {}
	AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
	AADD(aStru,{"MATERIAL"    , "C" , 45, 0 })
	AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
	AADD(aStru,{"INSERTO"     , "C" , 45, 0 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "PRODUTO"

	dbUseArea(.T.,,_cArqTrb,"TMP",.F.,.F.)

	dbSelectArea("TMP")
	IndRegua("TMP",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	_cPed := "("
	For Ax:= 1 To Len(MV_PAR13)
		If Substr(MV_PAR13,AX,1) != "*"
			If _cPed == "("
				_cPed += "'"+Substr(MV_PAR13,AX,1)
			Else
				_cPed += "','"+Substr(MV_PAR13,AX,1)
			Endif
		Endif
	Next AX
            
	_cPed += "')"

	_cQ := " SELECT * FROM SD2010 D2 "
	_cQ += " INNER JOIN SC5010 C5 ON D2_PEDIDO=C5_NUM "
	_cQ += " INNER JOIN SC6010 C6 ON D2_PEDIDO+D2_ITEMPV=C6_NUM+C6_ITEM "
	_cQ += " INNER JOIN SF4010 F4 ON D2_TES=F4_CODIGO  "
	_cQ += " INNER JOIN SB1010 B1 ON D2_COD=B1_COD  "
	_cQ += " WHERE D2.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
	_cQ += " AND C6_PEDAMOS IN "+_cPed+" "
	_cQ += " AND D2_TIPO = 'N' "
	_cQ += " AND F4_DUPLIC = 'S' "
//	_cQ += "  AND C6_BLQ = '' "
	_cQ += " AND D2_COD     BETWEEN '"+MV_PAR01+"'       AND '"+MV_PAR02+"' "
	_cQ += " AND D2_CLIENTE BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"' "
	_cQ += " AND D2_LOJA    BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"' "
	_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
	_cQ += " AND D2_PEDIDO  BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' "
	_cQ += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"' "
	_cQ += " ORDER BY D2_COD "

	TCQUERY _cQ NEW ALIAS "ZD2"

	TCSETFIELD("ZD2","C6_ENTREG","D")
	TCSETFIELD("ZD2","C5_EMISSAO","D")
	TCSETFIELD("ZD2","D2_EMISSAO","D")

	ZD2->(dbGotop())
	ProcRegua(ZD2->(U_CONTREG()))
        
	While ZD2->(!Eof()) .And. !_lFim
	
		If _lFim
			Alert("Cancelado Pelo Usuario!!!!")
			Return
		Endif
	
		IncProc()
	
		SB1->(dbSeek(xFilial("SB1")+ZD2->D2_COD))
				   
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+ZD2->D2_COD))
			_cProd   := SG1->G1_COD
			nNivel   := 2
							
			SB1->(dbSeek(xFilial("SB1")+_cProd))

			_cDescPa   := SB1->B1_DESC
			_cLocPad   := SB1->B1_LOCPAD
			_cQtCav    := SB1->B1_CAV
			_cComposto := _cMolde := _cInserto := ""

			If TMP->(!dbSeek(_cProd))
				NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
				TMP->(RecLock("TMP",.T.))
				TMP->PRODUTO  := _cProd
				TMP->MATERIAL := _cComposto
				TMP->MOLDE    := _cMolde
				TMP->INSERTO  := _cInserto
				TMP->(MsUNlock())
			Else
				_cComposto := TMP->MATERIAL
				_cMolde    := TMP->MOLDE
				_cInserto  := TMP->INSERTO
			Endif
		
		Endif
	
		SA1->(dbSetOrder(1))
		SA1->(dbseek(xFilial("SA1")+ZD2->D2_CLIENTE+ZD2->D2_LOJA))

		TRB->(RecLock("TRB",.T.))
		TRB->PRODUTO  := ZD2->D2_COD
		TRB->NOMPROD  := ZD2->B1_DESC
		TRB->PRODCLI  := ZD2->D2_PROCLI
		TRB->PO  	  := ZD2->D2_PEDCLI
		TRB->CLIENTE  := ZD2->D2_CLIENTE
		TRB->LOJA     := ZD2->D2_LOJA
		TRB->NOMECLI  := SA1->A1_NOME
		TRB->EMIS_PV  := ZD2->C5_EMISSAO
		TRB->PEDIDO   := ZD2->D2_PEDIDO
		TRB->ITEMPV   := ZD2->D2_ITEMPV
		_cDesTipo := ""
		If ZD2->C6_PEDAMOS == "N"
			_cDesTipo := "NORMAL"
		ElseIf ZD2->C6_PEDAMOS == "A"
			_cDesTipo := "AMOSTRA"
		ElseIf ZD2->C6_PEDAMOS == "D"
			_cDesTipo := "DESPES.ACESS."
		ElseIf ZD2->C6_PEDAMOS == "M"
			_cDesTipo := "AQUIS.MAT."
		ElseIf ZD2->C6_PEDAMOS == "Z"
			_cDesTipo := "PREVISAO"
		ElseIf ZD2->C6_PEDAMOS == "I"
			_cDesTipo := "INDUSTRIALIZ."
		Endif
		TRB->TIPOPV   := _cDesTipo
		TRB->DTENTR   := ZD2->C6_ENTREG
		TRB->QTDPED   := ZD2->C6_QTDVEN
		TRB->QTDENT   := ZD2->D2_QUANT
		TRB->QTDSDO   := ZD2->C6_QTDVEN - ZD2->D2_QUANT
		TRB->EMIS_FT  := ZD2->D2_EMISSAO
		TRB->NF 	  := ZD2->D2_DOC
		TRB->MATERIAL := _cComposto
		TRB->MOLDE    := _cMolde
		TRB->INSERTO  := _cInserto
		TRB->(MsUNlock())
	
		ZD2->(dbSkip())
	EndDo
Return



Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

	Local _nReg := 0
	Local _nRegTrb := 0

	SG1->(dbSetOrder(1))

	While SG1->(!Eof()) .And. SG1->G1_COD == _cProd  .And. !_lFim
	
		_nReg := SG1->(Recno())
	
		nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
		dbSelectArea("SG1")
		dbSetOrder(1)
		
		aAreaSB1:=SB1->(GetArea())
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
		
		_nRegTRb := SB1->(Recno())
		
		If SB1->B1_GRUPO $ "PIC /MPC "   // Material Utilizado
			If SB1->B1_COD != 'B45'
				_cComposto += ALLTRIM(SG1->G1_COMP)+ " "
			Endif
		ElseIf SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   // Molde de Vulcanização / Ferramenta
			_cMolde    += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $  "MPIM/PIPM"   // PRE FORMADO / INSERTO  METALICO
			_cInserto  += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $  "PIPF"   // PRE FORMADO
		ElseIf SB1->B1_GRUPO $  "PIBK"   // Blank Vazados
		ElseIf SB1->B1_GRUPO $  "MPVZ"   // Mat. Prima Vazados
			_cComposto += ALLTRIM(SG1->G1_COMP)+ " "
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

	cPerg := "CR0053"

//    	   Grupo/Ordem/Pergunta               		/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid	/Var01      /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02		/Defspa2/defeng2/Cnt02/Var03/Def03	/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Produto De            	?",""       ,""      ,"mv_ch1","C" ,15     ,0      ,0     ,"G",""        		,"MV_PAR01",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"02","Produto Ate           	?",""       ,""      ,"mv_ch2","C" ,15     ,0      ,0     ,"G",""        		,"MV_PAR02",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"03","Cliente De            	?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""        		,"MV_PAR03",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
	U_CRIASX1(cPerg,"04","Cliente Ate           	?",""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G",""        		,"MV_PAR04",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
	U_CRIASX1(cPerg,"05","Loja De               	?",""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""        		,"MV_PAR05",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"06","Loja Ate              	?",""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""        		,"MV_PAR06",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"07","Faturamento De        	?",""       ,""      ,"mv_ch7","D" ,08     ,0      ,0     ,"G",""        		,"MV_PAR07",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"08","Faturamento Ate       	?",""       ,""      ,"mv_ch8","D" ,08     ,0      ,0     ,"G",""        		,"MV_PAR08",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"09","Pedido De        			?",""       ,""      ,"mv_ch9","C" ,06     ,0      ,0     ,"G",""        		,"MV_PAR09",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC5")
	U_CRIASX1(cPerg,"10","Pedido Ate       			?",""       ,""      ,"mv_cha","C" ,06     ,0      ,0     ,"G",""        		,"MV_PAR10",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC5")
	U_CRIASX1(cPerg,"11","Emissao Pedido De     	?",""       ,""      ,"mv_chb","D" ,08     ,0      ,0     ,"G",""        		,"MV_PAR11",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"12","Emissao Pedido Ate    	?",""       ,""      ,"mv_chc","D" ,08     ,0      ,0     ,"G",""        		,"MV_PAR12",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
//	U_CRIASX1(cPerg,"13","Imprimi Ped. não Faturados?",""       ,""      ,"mv_chd","N" ,01     ,0      ,0     ,"C",""        		,"MV_PAR13","Sim"  		,""     ,""     ,""   ,""   ,"Não"	,""     ,""     ,""   ,""   ,""  	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"13","Quais Pedidos  			?",""       ,""      ,"mv_chd","C" ,06     ,0      ,0     ,"G","U_FTIPOPED()"	,"MV_PAR13",""     		,""     ,""     ,""   ,""   ,"" 	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
