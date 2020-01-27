#include 'totvs.ch'

User Function ImpDcTst()

	Local aVetDoc  := {}
	Local aVetVlr  := {}
	Local aVetNFc  := {}

	Local aItemDTC := {}
	Local aCabDTC  := {}
	Local aItem    := {}
	Local lCont    := .T.
	Local cLotNfc  := ''
	Local cRet     := ''
	Local aCab     := {}
	Local aErrMsg  := {}

	cLotNfc := "000010"

	If lCont
		lMsErroAuto := .F.

		aCabDTC := { {"DTC_FILORI" ,"01"  , Nil},;
			{"DTC_LOTNFC" ,cLotNfc	, Nil},;
			{"DTC_CLIREM" ,"003493"	, Nil},;
			{"DTC_LOJREM" ,"01"		, Nil},;
			{"DTC_DATENT" ,dDataBase, Nil},;
			{"DTC_CLIDES" ,"000001"	, Nil},;
			{"DTC_LOJDES" ,"IF"		, Nil},;
			{"DTC_CLIDEV" ,"003493" ,Nil},;
			{"DTC_LOJDEV" ,"01" 	,Nil},;
			{"DTC_CLICAL" ,"003493"	, Nil},;
			{"DTC_LOJCAL" ,"01"		, Nil},;
			{"DTC_DEVFRE" ,"1"       , Nil},;
			{"DTC_SERTMS" ,"3"       , Nil},;
			{"DTC_TIPTRA" ,"1"       , Nil},;
			{"DTC_SERVIC" ,"SNE"     , Nil},;
			{"DTC_CODNEG" ,"01"      , Nil},;
			{"DTC_TIPNFC" ,"0"       , Nil},;
			{"DTC_TIPFRE" ,"1"       , Nil},;
			{"DTC_SELORI" ,"1"       , Nil},;
			{"DTC_CDRORI" ,'SP', Nil},;
			{"DTC_CDRDES" ,'SP', Nil},;
			{"DTC_CDRCAL" ,'SP', Nil},;
			{"DTC_DISTIV" ,'2', Nil}}

		aItem := {{"DTC_NUMNFC" ,"000144694" , Nil},;
			{"DTC_SERNFC" ,"007"  , Nil},;
			{"DTC_CODPRO" ,"CALC.FRETE", Nil},;
			{"DTC_CODEMB" ,"CX" , Nil},;
			{"DTC_EMINFC" ,dDataBase , Nil},;
			{"DTC_QTDVOL" ,10, Nil},;
			{"DTC_PESO"   ,100.0000, Nil},;
			{"DTC_PESOM3" ,0.0000, Nil},;
			{"DTC_VALOR"  ,1000.00, Nil},;
			{"DTC_BASSEG" ,0.00 , Nil},;
			{"DTC_METRO3" ,0.0000, Nil},;
			{"DTC_QTDUNI" ,0 , Nil},;
			{"DTC_EDI"    ,"2" , Nil}}

		AAdd(aItemDTC,aClone(aItem))
		//
		// Parametros da TMSA050 (notas fiscais do cliente)
		// xAutoCab - Cabecalho da nota fiscal
		// xAutoItens - Itens da nota fiscal
		// xItensPesM3 - acols de Peso Cubado
		// xItensEnder - acols de Enderecamento
		// nOpcAuto - Opcao rotina automatica
		MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)
		If lMsErroAuto
			MostraErro()
			lCont := .F.
		Else
			DTC->(dbCommit())
		EndIf
	EndIf

	If lCont
		AAdd(aVetDoc,{"DT6_FILORI","01"})
		AAdd(aVetDoc,{"DT6_LOTNFC",cLotNfc})
		AAdd(aVetDoc,{"DT6_FILDOC","01"})
		AAdd(aVetDoc,{"DT6_DOC"   ,"000007"})
		AAdd(aVetDoc,{"DT6_SERIE" ,"UNI"})
		AAdd(aVetDoc,{"DT6_DATEMI",dDataBase})
		AAdd(aVetDoc,{"DT6_HOREMI","0934"})
		AAdd(aVetDoc,{"DT6_VOLORI", 10})
		AAdd(aVetDoc,{"DT6_QTDVOL", 10})
		AAdd(aVetDoc,{"DT6_PESO"  , 100.0000})
		AAdd(aVetDoc,{"DT6_PESOM3", 0.0000})
		AAdd(aVetDoc,{"DT6_PESCOB", 0.0000})
		AAdd(aVetDoc,{"DT6_METRO3", 0.0000})
		AAdd(aVetDoc,{"DT6_VALMER", 1000.00})
		AAdd(aVetDoc,{"DT6_QTDUNI", 0})
		AAdd(aVetDoc,{"DT6_VALFRE", 1050.00})
		AAdd(aVetDoc,{"DT6_VALIMP", 230.49})
		AAdd(aVetDoc,{"DT6_VALTOT", 1280.49})
		AAdd(aVetDoc,{"DT6_BASSEG", 0.00})
		AAdd(aVetDoc,{"DT6_SERTMS","2"})
		AAdd(aVetDoc,{"DT6_TIPTRA","1"})
		AAdd(aVetDoc,{"DT6_DOCTMS","2"})
		AAdd(aVetDoc,{"DT6_CDRORI","B06200"})
		AAdd(aVetDoc,{"DT6_CDRDES","Q50308"})
		AAdd(aVetDoc,{"DT6_CDRCAL","Q50308"})
		AAdd(aVetDoc,{"DT6_TABFRE","R007"})
		AAdd(aVetDoc,{"DT6_TIPTAB","01"})
		AAdd(aVetDoc,{"DT6_SEQTAB","00"})
		AAdd(aVetDoc,{"DT6_TIPFRE","1"})
		AAdd(aVetDoc,{"DT6_FILDES","01"})
		AAdd(aVetDoc,{"DT6_BLQDOC","2"})
		AAdd(aVetDoc,{"DT6_PRIPER","2"})
		AAdd(aVetDoc,{"DT6_PERDCO", 0.00000})
		AAdd(aVetDoc,{"DT6_FILDCO",""})
		AAdd(aVetDoc,{"DT6_DOCDCO",""})
		AAdd(aVetDoc,{"DT6_SERDCO",""})
		AAdd(aVetDoc,{"DT6_CLIREM",Padr("000002",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJREM",Padr("01"    ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLIDES",Padr("000001",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJDES",Padr("01"    ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLIDEV",Padr("000002",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJDEV",Padr("01"    ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLICAL",Padr("000002",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJCAL",Padr("01"    ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_DEVFRE","1"})
		AAdd(aVetDoc,{"DT6_FATURA",""})
		AAdd(aVetDoc,{"DT6_SERVIC","030"})
		AAdd(aVetDoc,{"DT6_CODNEG","01"})
		AAdd(aVetDoc,{"DT6_CODMSG",""})
		AAdd(aVetDoc,{"DT6_STATUS","1"})
		AAdd(aVetDoc,{"DT6_DATEDI",CToD("  /  /  ")})
		AAdd(aVetDoc,{"DT6_NUMSOL",""})
		AAdd(aVetDoc,{"DT6_VENCTO",CToD("  /  /  ")})
		AAdd(aVetDoc,{"DT6_FILDEB","01"})
		AAdd(aVetDoc,{"DT6_PREFIX",""})
		AAdd(aVetDoc,{"DT6_NUM"   ,""})
		AAdd(aVetDoc,{"DT6_TIPO"  ,""})
		AAdd(aVetDoc,{"DT6_MOEDA" , 1})
		AAdd(aVetDoc,{"DT6_BAIXA" ,CToD("  /  /  ")})
		AAdd(aVetDoc,{"DT6_FILNEG","01"})
		AAdd(aVetDoc,{"DT6_ALIANC",""})
		AAdd(aVetDoc,{"DT6_REENTR", 0})
		AAdd(aVetDoc,{"DT6_TIPMAN",""})
		AAdd(aVetDoc,{"DT6_PRZENT",Ctod('31/08/18')})
		AAdd(aVetDoc,{"DT6_FIMP"  ,"1"})

		AAdd(aVetVlr,{{"DT8_CODPAS","01"},;
			{"DT8_VALPAS", 50.00},;
			{"DT8_VALIMP", 10.98},;
			{"DT8_VALTOT", 60.98},;
			{"DT8_FILORI",""},;
			{"DT8_TABFRE","R007"},;
			{"DT8_TIPTAB","01"},;
			{"DT8_FILDOC","01"},;
			{"DT8_CODPRO","000001"},;
			{"DT8_DOC"   ,"000007"},;
			{"DT8_SERIE" ,"UNI"},;
			{"VLR_ICMSOL",0}})
		AAdd(aVetVlr,{{"DT8_CODPAS","02"},;
			{"DT8_VALPAS",  1000.00},;
			{"DT8_VALIMP",  219.51},;
			{"DT8_VALTOT",  1219.51},;
			{"DT8_FILORI",""},;
			{"DT8_TABFRE","R007"},;
			{"DT8_TIPTAB","01"},;
			{"DT8_FILDOC","01"},;
			{"DT8_CODPRO","000001"},;
			{"DT8_DOC"   ,"000007"},;
			{"DT8_SERIE" ,"UNI"},;
			{"VLR_ICMSOL",0}})
		AAdd(aVetVlr,{{"DT8_CODPAS","TF"},;
			{"DT8_VALPAS", 1050.00},;
			{"DT8_VALIMP", 230.49},;
			{"DT8_VALTOT", 1280.49},;
			{"DT8_FILORI",""},;
			{"DT8_TABFRE",""},;
			{"DT8_TIPTAB",""},;
			{"DT8_FILDOC","01"},;
			{"DT8_CODPRO","000001"},;
			{"DT8_DOC"   ,"000007"},;
			{"DT8_SERIE" ,"UNI"},;
			{"VLR_ICMSOL",0}})

		AAdd(aVetNFc,{{"DTC_CLIREM",Padr("000002",Len(DTC->DTC_CLIREM))},;
			{"DTC_LOJREM",Padr("01"    ,Len(DTC->DTC_LOJREM))},;
			{"DTC_NUMNFC",Padr("010",Len(DTC->DTC_NUMNFC))},;
			{"DTC_SERNFC",Padr("UNI"     ,Len(DTC->DTC_SERNFC))},;
			{"DTC_CODPRO","000001"},;
			{"DTC_QTDVOL", 10},;
			{"DTC_PESO"  , 100.0000},;
			{"DTC_PESOM3", 0.0000},;
			{"DTC_METRO3", 0.0000},;
			{"DTC_VALOR" , 1000.00}})

		aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,0,1,.T.,.T.,.T.,.T.)

	EndIf

Return

