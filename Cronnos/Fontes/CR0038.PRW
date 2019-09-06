#INCLUDE 'TOTVS.CH'
#INCLUDE "EECPEM11.CH"
#INCLUDE "EECRDM.CH"

#define NUMLINPAG 23
#define TAMDESC 29


/*
Programa	: CR0038
Autor		: Fabiano da Silva
Data		: 16/08/2013
Descrição	: Relatório Commercial Invoice - Fating.rpt
*/


User Function CR0038()

	Local lRet    := .t.
	Local lIngles := "INGLES" $ Upper(WorkId->EEA_IDIOMA)
	Local nAlias  := Select()
	Local aOrd    := SaveOrd({"EE9","SA2","EE2","DETAIL_P"})
	Local nCod, aFields, cFile
	LOCAL aMESES  := {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}

	Local nInc, cPackag, acRETPAC

	Private cPict       := "999,999,999.99"
	Private _nQuant     := nFobValue  := 0
	Private cPictDecPrc := if(EEC->EEC_DECPRC > 0, "."+Replic("9",EEC->EEC_DECPRC),"")
	Private cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
	Private cPictDecQtd := if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")

	Private cPictPreco  := "9,999"+cPictDecPrc
	Private cPictPeso   := "9,999,999"+cPictDecPes
	Private cPictQtde   := "9,999,999"+cPictDecQtd

	SA1->(dbsetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))

	Private cObs        := ""
	Private aNotify[6]
	aFill(aNotify,"")

	Private cFileMen:=""
	Private cMarca := GetMark(), lInverte := .f.
	Private lNcm := .t., lPesoBru := .t.

	Private M->cSEEKEXF:=""
	Private M->cSEEKLOJA:=""

	Private aHeader := {}, aCAMPOS := ARRAY(0)
	Private lUnidade:=.f.,cUnQtde,cUnPeso,cUnPreco,nPesLiq:=0,nPesBru:=0
	cUnQtde  := "PC"
	cUnPreco := "PC"
	cUnPeso  := "KG"

	Begin Sequence

		If EE9->(FieldPos("EE9_UNPES")) # 0 .And. EE9->(FieldPos("EE9_UNPRC")) # 0
			lUnidade:=.t.
			cUnQtde:=CriaVar("EE9_UNPRC")
			cUnPeso:=CriaVar("EE9_UNPES")
			cUnPreco:=CriaVar("EE9_UNPRC")
		EndIf

// *** Cria Arquivo de Trabalho ...
		nCod := AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3)

		aFields := {{"WKMARCA","C",02,0},;
			{"WKTIPO","C",01,0},;
			{"WKCODIGO","C",nCod,0},;
			{"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}}

		cFile := E_CriaTrab(,aFields,"Work")
		IndRegua("Work",cFile+OrdBagExt(),"WKTIPO+WKCODIGO")

		EEM->(dbSetOrder(1)) // FILIAL+PREEMB+TIPO
		EE2->(dbSetOrder(1))
		EE9->(dbSetOrder(4)) // FILIAL+PREEMB+NCM
		EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
// ***

// regras para carregar dados
		SA2->(dbSetOrder(1))
		IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
				SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
			cExp_Cod     := EEC->EEC_EXPORT+EEC->EEC_EXLOJA
			cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
			cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1
			cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4)  //fone do contato seq 1
			cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7)  //fax do contato seq 1
			cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",2)  //CARGO
			M->cSEEKEXF  := EEC->EEC_EXPORT
			M->cSEEKLOJA := EEC->EEC_EXLOJA
		ELSE
			SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
			cExp_Cod     := EEC->EEC_FORN+EEC->EEC_FOLOJA
			cEXP_NOME    := SA2->A2_NOME
			cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
			cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
			cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
			cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2,EEC->EEC_RESPON)  //CARGO
			M->cSEEKEXF  :=EEC->EEC_FORN
			M->cSEEKLOJA :=EEC->EEC_FOLOJA
		ENDIF

		cC2160 := EEC->EEC_IMPODE
		cC2260 := EEC->EEC_ENDIMP
		cC2360 := EEC->EEC_END2IM
		cC2460 := SPACE(60)
		cC2960 := SPACE(60)
		cC3060 := SPACE(60)

		IF ! TelaGets()
			lRet := .f.
			Break
		Endif

		cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
		CONFIRMSX8()

// adicionar registro no HEADER_P
		HEADER_P->(DBAPPEND())
		HEADER_P->AVG_FILIAL:=xFilial("SY0")
		HEADER_P->AVG_SEQREL:=cSEQREL
		HEADER_P->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo

// Dados do Exportador/Fornecedor
		HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
		HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)+','+ALLTRIM(SA2->A2_NR_END)
		HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_MUN)+'-'+ ALLTRIM(SA2->A2_EST+" "+Alltrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM"))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
//HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
		HEADER_P->AVG_C04_60:=ALLTRIM("TEL.: +"+AllTrim(SA2->A2_DDI)+" "+AllTrim(SA2->A2_DDD)+" "+AllTrim(SA2->A2_TEL)+;
							" FAX: +"+AllTrim(SA2->A2_DDI)+" "+AllTrim(SA2->A2_DDD)+" "+AllTrim(cEXP_FAX))
//		HEADER_P->AVG_C04_60:=ALLTRIM("TEL.:" +AllTrim(cEXP_FONE)+" FAX: " +AllTrim(cEXP_FAX))

//Cobrança
		cMemo2 := MSMM(SA1->A1_OBS,AVSX3("A1_VM_OBS",3))

		HEADER_P->AVG_C10_60 := MemoLine(cMemo2,60,1)
		HEADER_P->AVG_C11_60 := MemoLine(cMemo2,60,2)
		HEADER_P->AVG_C12_60 := MemoLine(cMemo2,60,3)
		HEADER_P->AVG_C13_60 := MemoLine(cMemo2,60,4)
		HEADER_P->AVG_C14_60 := MemoLine(cMemo2,60,5)

// Informacoes do Cabecalho
		HEADER_P->AVG_C06_60 := AllTrim(SA2->A2_MUN)+", "+Upper(IF(lIngles,cMonth(EEC->EEC_DTINVO),IF(EMPTY(EEC->EEC_DTINVO),"",aMeses[Month(EEC->EEC_DTINVO)])))+" "+StrZero(Day(EEC->EEC_DTINVO),2)+", "+Str(Year(EEC->EEC_DTINVO),4)+"."
		HEADER_P->AVG_C07_10 := Substr(dtos(EEC->EEC_DTINVO),5,2)+'/'+Right(dtos(EEC->EEC_DTINVO),2)+'/'+Left(dtos(EEC->EEC_DTINVO),4)
//HEADER_P->AVG_C01_20 := EEC->EEC_NRCONH
		HEADER_P->AVG_C08_10 := ALLTRIM(SA1->A1_SUPCODE)
		HEADER_P->AVG_C02_20 := EEC->EEC_PREEMB

		_cPais    :=  Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_PAIS")
		_cNomPais :=  Posicione("SYA",1,xFilial("SYA")+_cPais,"YA_NOIDIOM")
// TO
		HEADER_P->AVG_C07_60 := Alltrim(SA1->A1_NOME)
		HEADER_P->AVG_C08_60 := Alltrim(SA1->A1_ADDRESS)+" - "+Alltrim(SA1->A1_CITY)+"-"+Alltrim(SA1->A1_STATE)
		HEADER_P->AVG_C09_60 := Alltrim(SA1->A1_POSCODE)+" - "+_cNomPais
		HEADER_P->AVG_M01_06 := EEC->EEC_IMPORT
// Titulos ...
		HEADER_P->AVG_C01_10 := EEC->EEC_MOEDA

		If lUnidade
	// ** Verifica se a unidade de medida para o peso esta cadastrada no idioma ...
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPeso))
				MsgStop("Unidade de medida "+cUnPeso+"nao cadastrada em"+EEC->EEC_IDIOMA,"Aviso")
			EndIf
			HEADER_P->AVG_C02_10 := AllTrim(EE2->EE2_DESCMA)
		Else
			HEADER_P->AVG_C02_10 := "KG"
		EndIf

		If !lUnidade
	// Pesos/Cubagem
			HEADER_P->AVG_C03_20 := AllTrim(Transf(EEC->EEC_PESLIQ,cPictPeso))
			HEADER_P->AVG_C04_20 := AllTrim(Transf(EEC->EEC_PESBRU,cPictPeso))
		EndIf

		cPictCub := AllTrim(StrTran(Upper(AVSX3("EEC_CUBAGE",6)),"@E",""))

// TOTAIS
		nFobValue 			:= (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
//nFobValue 			:= (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))+EEC->EEC_FRPREV+EEC->EEC_FRPREV + EEC->EEC_SEGPRE

		_nVlOut    			:= EEC->EEC_FRPCOM+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")-EEC->EEC_DESCON
		_nAbat               := EEC->EEC_FRPREV + EEC->EEC_SEGPRE + _nVlOut
		_nVlTotExw 			:= nFobValue - _nAbat

//   HEADER_P->AVG_C14_20 := ALLTRIM(Transf(nFobValue,cPICT))  //AVSX3("EEC_TOTPED",6))
		HEADER_P->AVG_C14_20 := ALLTRIM(Transf(_nVlTotExw,cPICT))  //AVSX3("EEC_TOTPED",6))
		HEADER_P->AVG_C15_20 := ALLTRIM(Transf(EEC->EEC_FRPREV,cPICT))  //AVSX3("EEC_FRPREV",6))
//HEADER_P->AVG_C15_20 := ALLTRIM(Transf(798.00,cPICT))  //AVSX3("EEC_FRPREV",6))
		HEADER_P->AVG_C16_20 := ALLTRIM(Transf(EEC->EEC_SEGPRE,cPICT))  //AVSX3("EEC_SEGPRE",6))
		HEADER_P->AVG_C17_20 := ALLTRIM(Transf(EEC->EEC_FRPCOM+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")-EEC->EEC_DESCON,cPict))
//   HEADER_P->AVG_C18_20 := ALLTRIM(Transf(EEC->EEC_TOTPED,cPICT))  //AVSX3("EEC_TOTPED",6))
		HEADER_P->AVG_C18_20 := ALLTRIM(Transf(nFobValue,cPICT))  //AVSX3("EEC_TOTPED",6))

		HEADER_P->AVG_C03_10 := EEC->EEC_INCOTE

// pais de origem
		HEADER_P->AVG_C01_30 := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")

// VIA
		SYQ->(dbSetOrder(1))
		SYQ->(dbSeek(xFilial("SYQ")+EEC->EEC_VIA))

		HEADER_P->AVG_C02_30 := IF(Left(SYQ->YQ_COD_DI,1) == "4",IF(lIngles,"BY AIR","CORRETO AEREA"),SYQ->YQ_DESCR) // VIA

		IF Left(SYQ->YQ_COD_DI,1) == "1" // MARITIMO
//	HEADER_P->AVG_C05_10:="FOB"
		Else
//	HEADER_P->AVG_C05_10:="FCA"
		Endif

		SYR->(dbSeek(xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))

///   IF Posicione("SYJ",1,xFilial("SYJ")+EEC->EEC_INCOTE,"YJ_CLFRETE") $ cSim
		HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
//   Else
//      HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem
//   Endif

// Port of Unloading
		HEADER_P->AVG_C04_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // +" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_PAIS")))

// Port of Loading
		HEADER_P->AVG_C03_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")) //+" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_PAIS")))

// MARKS
		cMemo := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
		HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1)
		HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2)
		HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3)
		HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4)
		HEADER_P->AVG_C10_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5)
		HEADER_P->AVG_C11_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6)

// NOTIFY
		HEADER_P->AVG_C15_60 := aNotify[1]
		HEADER_P->AVG_C16_60 := aNotify[2]
		HEADER_P->AVG_C17_60 := aNotify[3]


//Consignee
		If Empty(EEC->EEC_CONSIG)
			HEADER_P->AVG_C18_60 := HEADER_P->AVG_C07_60
			HEADER_P->AVG_C19_60 := HEADER_P->AVG_C08_60
			HEADER_P->AVG_C20_60 := HEADER_P->AVG_C09_60
		Else

			_aAliSA1 := SA1->(GetArea())
			_aAliSYA := SYA->(GetArea())

			SA1->(dbsetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA))
	
			_cPais1   :=  SA1->A1_PAIS
			_cNoPai1  :=  Posicione("SYA",1,xFilial("SYA")+_cPais1,"YA_NOIDIOM")
	
			HEADER_P->AVG_C18_60 := Alltrim(SA1->A1_NOME)
			HEADER_P->AVG_C19_60 := Alltrim(SA1->A1_ADDRESS)+" - "+Alltrim(SA1->A1_CITY)+"-"+Alltrim(SA1->A1_STATE)
			HEADER_P->AVG_C20_60 := Alltrim(SA1->A1_POSCODE)+" - "+_cNoPai1

			RestArea(_aAliSYA)
			RestArea(_aAliSA1)

		Endif

/*
HEADER_P->AVG_C18_60 := aNotify[4]
HEADER_P->AVG_C19_60 := aNotify[5]
HEADER_P->AVG_C20_60 := aNotify[6]
*/
//DOCUMENTS
		HEADER_P->AVG_C21_60 := cC2160
		HEADER_P->AVG_C22_60 := cC2260
		HEADER_P->AVG_C23_60 := cC2360
		HEADER_P->AVG_C24_60 := cC2460
		HEADER_P->AVG_C29_60 := cC2960
		HEADER_P->AVG_C30_60 := cC3060

// Cond.Pagto ...
		HEADER_P->AVG_C01100 := SY6Descricao(EEC->EEC_CONDPA+Str(EEC->EEC_DIASPA,AVSX3("EEC_DIASPA",3),AVSX3("EEC_DIASPA",4)),EEC->EEC_IDIOMA,1) // Terms of Payment

// I/L
		HEADER_P->AVG_C25_60 := EEC->EEC_LICIMP
// L/C
		HEADER_P->AVG_C04_10 := EEC->EEC_LC_NUM

// RODAPE
    
//_cNome := _cEnd := _cBairro := _cCidade := _cEst := _cCEP := "" 

		/*
		dbSelectArea("SY5")
		dbSetOrder(1)
		If dbSeek(xfilial("SY5")+EEC->EEC_AGENTE)
			HEADER_P->AVG_C06_30 := SY5->Y5_NOME
			HEADER_P->AVG_C07_30 := SY5->Y5_END
			HEADER_P->AVG_C05_30 := SY5->Y5_BAIRRO
			HEADER_P->AVG_C01_20 := SY5->Y5_CIDADE
			HEADER_P->AVG_C05_10 := SY5->Y5_ESTADO
			HEADER_P->AVG_C06_10 := SY5->Y5_CEP
		Endif
	*/
		HEADER_P->AVG_C26_60 := cEXP_NOME

		HEADER_P->AVG_C27_60 := cEXP_CONTATO
		HEADER_P->AVG_C28_60 := cEXP_CARGO

		_cFone := cEXP_FONE
		dbSelectArea("EE3")
		dbSetOrder(1)
		If dbSeek(xFilial("EE3")+"X")
			_cFone := EE3->EE3_FONE
		Endif

		HEADER_P->AVG_C31_60 := _cFone

		HEADER_P->AVG_C01150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),1)
		HEADER_P->AVG_C02150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),2)
		HEADER_P->AVG_C03150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),3)
		HEADER_P->AVG_C04150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),4)
		HEADER_P->AVG_C05150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),5)

		GravaItens()

		HEADER_P->AVG_C05_20 := Transf(_nQuant,cPictCub)  //AVSX3("EEC_CUBAGE",6))

		If lUnidade
			HEADER_P->AVG_C03_20 := AllTrim(Transf(nPesLiq,cPictPeso))
			HEADER_P->AVG_C04_20 := AllTrim(Transf(nPesBru,cPictPeso))
		EndIf

		HEADER_P->(dbUnlock())

		HEADER_H->(dbAppend())
		AvReplace("HEADER_P","HEADER_H")

		DETAIL_P->(dbSetOrder(0))
		DETAIL_P->(DbGoTop())
		Do While ! DETAIL_P->(Eof())
			DETAIL_H->(DbAppend())
			AvReplace("DETAIL_P","DETAIL_H")
			DETAIL_P->(DbSkip())
		EndDo

		DETAIL_P->(dbSetOrder(1))

// (Fim)
	End Sequence

	IF Select("Work_Men") > 0
		Work_Men->(E_EraseArq(cFileMen))
	Endif

	Work->(E_EraseArq(cFile))
	RestOrd(aOrd)
	Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  :
Retorno     :
Objetivos   :
Autor       : Cristiano A. Ferreira
Data/Hora   :
Revisao     :
Obs.        :
*/
Static Function GravaItens

	Local nTotQtde := 0
	Local nTotal   := 0
	Local cUnidade := ""
	Local bCond    := IF(lNcm,{|| EE9->EE9_POSIPI == cNcm },{|| .t. })
	Local cNcm     := "",lDescUnid:=.f.
	PRIVATE nLin :=0,nPag := 1

	While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
			EE9->EE9_PREEMB == EEC->EEC_PREEMB
	
	/*
	IF lNcm
		cNcm := EE9->EE9_POSIPI
		
		If lUnidade .And. !lDescUnid
			AppendDet()
			// ** Verifica se a unidade de medida para o qtde esta cadastrada no idioma ...
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnQtde))
				MsgStop("Unidade de medida "+cUnQtde+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
			EndIf
			
			DETAIL_P->AVG_C01_20 := AllTrim(EE2->EE2_DESCMA)
			
			// ** Verifica se a unidade de medida para o preco esta cadastrada no idioma ...
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPreco))
				MsgStop("Unidade de medida "+cUnPreco+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
			EndIf
			
			DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
			
			lDescUnid:=.t.
			
			UnlockDet()
			
		ElseIf !lUnidade
			IF cUnidade <> EE9->EE9_UNIDAD
				cUnidade := EE9->EE9_UNIDAD
				AppendDet()
				
				IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
					MsgStop("Unidade de medida "+EE9->EE9_UNIDAD+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
				Endif
				DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
				
				UnlockDet()
			Endif
			
		EndIf
		
		AppendDet()
		DETAIL_P->AVG_C01_60 := "N.C.M. : "+Transf(EE9->EE9_POSIPI,AVSX3("EE9_POSIPI",6))
		UnlockDet()
		
		AppendDet()
		DETAIL_P->AVG_C01_60 := Replic("-",25)
		UnlockDet()
	Endif
	*/
		While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
				EE9->EE9_PREEMB == EEC->EEC_PREEMB
//		EE9->EE9_PREEMB == EEC->EEC_PREEMB .And. ;
//		Eval(bCond)
		
		/*
		If lUnidade .And. !lDescUnid
			AppendDet()
			// ** Verifica se a unidade de medida para o qtde esta cadastrada no idioma ...
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnQtde))
				MsgStop("Unidade de medida "+cUnQtde+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
			EndIf
			
			DETAIL_P->AVG_C01_20 := AllTrim(EE2->EE2_DESCMA)
			
			// ** Verifica se a unidade de medida para o preco esta cadastrada no idioma ...
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPreco))
				MsgStop("Unidade de medida "+cUnPreco+" nào cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
			EndIf
			
			DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
			
			UnlockDet()
			
			lDescUnid:=.t.
			
		ElseIf !lUnidade
			
			IF cUnidade <> EE9->EE9_UNIDAD
				cUnidade := EE9->EE9_UNIDAD
				AppendDet()
				
				IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
					MsgStop("Unidade de medida "+EE9->EE9_UNIDAD+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
				Endif
				
				DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
				
			EndIf
			
			UnlockDet()
		Endif
		  */

			AppendDet()
		
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnQtde))
				MsgStop("Unidade de medida "+cUnQtde+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
			EndIf
			
			DETAIL_P->AVG_C01_10 := AllTrim(EE2->EE2_DESCMA)
		
			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPreco))
				MsgStop("Unidade de medida "+cUnPreco+" nào cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
			EndIf

			IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
				MsgStop("Unidade de medida "+EE9->EE9_UNIDAD+" nao cadastrada em "+EEC->EEC_IDIOMA,"Aviso")
			Endif
			
			DETAIL_P->AVG_C02_60 := Transf(EE9->EE9_POSIPI,AVSX3("EE9_POSIPI",6))

			If lUnidade
				DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(AVTransUnid(EE9->EE9_UNIDAD,cUnQtde,EE9->EE9_COD_I,EE9->EE9_SLDINI,.f.),cPictQtde))
				DETAIL_P->AVG_C04_20 := AllTrim(Transf(AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSLQTO,.f.),cPictPeso))
			Else
				DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(EE9->EE9_SLDINI,cPictQtde))
				DETAIL_P->AVG_C04_20 := AllTrim(Transf(EE9->EE9_PSLQTO,cPictPeso))
			EndIf

			DETAIL_P->AVG_C02_20 := Transf(EE9->EE9_COD_I,AVSX3("EE9_COD_I",6))
			DETAIL_P->AVG_C08_20 := Alltrim(EE9->EE9_PART_N)
			DETAIL_P->AVG_C03_20 := Alltrim(EE9->EE9_REFCLI)
		
			cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
		
		// Alterado em 26/10/05
			If lUnidade
				nTotQtde := nTotQtde+AVTransUnid(EE9->EE9_UNIDAD,cUnQtde,EE9->EE9_COD_I,EE9->EE9_SLDINI,.f.)
//			nPesLiq  += AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSLQTO,.f.)
				nPesLiq  += EE9->EE9_PSLQTO
			
				IF lPesoBru
//				nPesBru +=AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSBRTO,.f.)
					nPesBru += EE9->EE9_PSBRTO
				EndIf
			
			Else
				nTotQtde := nTotQtde+EE9->EE9_SLDINI
			EndIf
		
		// Alterado em 26/10/05
			_nPrTot := (_nVlTotExw * (EE9->EE9_PRECO * EE9->EE9_SLDINI)) / nFobValue
		
			DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1)
			dbSelectArea("SZ2")
			dbSetorder(1)
			IF dbSeek(xFilial("SZ2")+EEC->EEC_IMPORT + EEC->EEC_IMLOJA + EE9->EE9_COD_I + Substr(EE9->EE9_PART_N,1,15)+"1" )
				If Empty(DETAIL_P->AVG_C01_60)
					DETAIL_P->AVG_C01_60 := SZ2->Z2_DESCCLI
				Endif
			Endif

			DETAIL_P->AVG_C05_20 := AllTrim(Transf(EE9->EE9_PSBRTO,cPictPeso))
		//      DETAIL_P->AVG_C06_20 := AllTrim(Transf(EE9->EE9_PRECO,cPictPreco))
//			DETAIL_P->AVG_C06_20 := AllTrim(Transf(_nPrTot / EE9->EE9_SLDINI,cPict))
			DETAIL_P->AVG_C06_20 := AllTrim(Transf(_nPrTot / EE9->EE9_SLDINI,cPictPreco))
		
			If EEC->EEC_PRECOA = "1"
			//         DETAIL_P->AVG_C07_20 := AllTrim(Transf(EE9->EE9_PRCINC,cPict))
				DETAIL_P->AVG_C07_20 := AllTrim(Transf(_nPrTot,cPict))
			Else
			//         DETAIL_P->AVG_C07_20 := AllTrim(Transf(Round(EE9->EE9_PRECO*EE9->EE9_SLDINI,2),cPict))
				DETAIL_P->AVG_C07_20 := AllTrim(Transf(Round(_nPrTot,2),cPict))
			EndIf
		
			For i := 2 To MlCount(cMemo,TAMDESC,3)
				IF !EMPTY(MemoLine(cMemo,TAMDESC,i))
					UnLockDet()
					AppendDet()
					DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
				ENDIF
			Next
		
		// Totaliza os valores da quantidade e dos pesos liquido e bruto...
		/*
		If lUnidade
		nTotQtde := nTotQtde+AVTransUnid(EE9->EE9_UNIDAD,cUnQtde,EE9->EE9_COD_I,EE9->EE9_SLDINI,.f.)
		nPesLiq  += AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSLQTO,.f.)
		
		IF lPesoBru
		nPesBru +=AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSBRTO,.f.)
		EndIf
		
		Else
		nTotQtde := nTotQtde+EE9->EE9_SLDINI
		EndIf
		*/
			If EEC->EEC_PRECOA = "1"
				nTotal   := nTotal  + EE9->EE9_PRCINC
			Else
				nTotal   := nTotal  + Round(EE9->EE9_PRECO*EE9->EE9_SLDINI,2)
			EndIf
		
			_nQuant2 := 0
			dbSelectArea("EE5")
			dbsetOrder(1)
			If dbSeek(xFilial("EE5")+EE9->EE9_EMBAL1)
				_nQuant2 := Round((EE9->EE9_QTDEM1 * ( EE5->EE5_CCOM * EE5->EE5_LLARG * EE5->EE5_HALT )),4)
			Endif
		
			_nQuant += _nQuant2
		
			UnLockDet()
		
			EE9->(dbSkip())
		Enddo
	Enddo

	AppendDet()
	DETAIL_P->AVG_C01_20 := Replic("-",20)
	DETAIL_P->AVG_C04_20 := Replic("-",20)
	DETAIL_P->AVG_C05_20 := Replic("-",20)
	DETAIL_P->AVG_C07_20 := Replic("-",20)
	UnLockDet()

	AppendDet()

	DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(nTotQtde,cPictQtde))

	If lUnidade
		DETAIL_P->AVG_C04_20 := ALLTRIM(Transf(nPesLiq,cPictPeso))
		DETAIL_P->AVG_C05_20 := ALLTRIM(Transf(nPesBru,cPictPeso))
	//   DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal,cPict))
		DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal - _nAbat,cPict))
	Else
		DETAIL_P->AVG_C04_20 := ALLTRIM(Transf(EEC->EEC_PESLIQ,cPictPeso))
		DETAIL_P->AVG_C05_20 := ALLTRIM(Transf(EEC->EEC_PESBRU,cPictPeso))
	//   DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal,cPict))
		DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal - _nAbat,cPict))
	EndIf

	UnLockDet()

// Gravar todas as N.F.
	cNotas := ""
	EEM->(dbSeek(xFilial("EEM")+EEC->EEC_PREEMB+EEM_NF))

	While EEM->(!Eof() .And. EEM_FILIAL == xFilial("EEM")) .And.;
			EEM->EEM_PREEMB == EEC->EEC_PREEMB .And. EEM->EEM_TIPOCA == EEM_NF
	
		SysRefresh()
		IF Empty(cNotas)
			cNotas := cNotas+"Notas Fiscais:"
		Endif
	
		dbSelectArea("SE1")
		dbSetOrder(2)
		If dbseek(xFilial("SE1")+EEC->EEC_IMPORT+ EEC->EEC_IMLOJA + Substr(EEM->EEM_SERIE,1,3)+Substr(EEM->EEM_NRNF,1,9))
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_NUMINVO := EEM->EEM_PREEMB
			MsUnlock()
		Endif
	
		cNotas := cNotas+" "+AllTrim(EEM->EEM_NRNF)+if(!Empty(EEM->EEM_SERIE),"-"+AllTrim(EEM->EEM_SERIE),"")
		EEM->(dbSkip())
	Enddo

/*
AppendDet()
DETAIL_P->AVG_C01_60 := ""
UnlockDet()

AppendDet()
DETAIL_P->AVG_C01_60 := "*** SAMPLE ***"
UnlockDet()

AppendDet()
DETAIL_P->AVG_C01_60 := ""
UnlockDet()
  */

	For i:=1 To MlCount(cNotas,30)
		AppendDet()
		DETAIL_P->AVG_C01_60 := MemoLine(cNotas,30,i)
		UnLockDet()
	Next i

//HEADER_P->AVG_C12_20 := ALLTRIM(Transf(nTotal,cPict))
	HEADER_P->AVG_C12_20   := ALLTRIM(Transf(nTotal - _nAbat,cPict))

	IF Select("Work_Men") > 0
		Work_Men->(dbGoTop())
	
		While !Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
			gi_nTotLin:=MLCOUNT(Work_Men->WKOBS,40)
			For gi_W := 1 To gi_nTotLin
				If !Empty(MEMOLINE(Work_Men->WKOBS,40,gi_W))
					AppendDet()
					DETAIL_P->AVG_C01_60 := MemoLine(Work_Men->WKOBS,40,gi_W)
					UnLockDet()
				EndIf
			Next
			Work_Men->(dbSkip())
		Enddo
	Endif

	_cDesc := ""
	dbSelectArea("SYP")
	dbSetOrder(1)
	If dbSeek(xFilial("SYP")+EEC->EEC_CODOBP)
		_cChav := EEC->EEC_CODOBP
		_cDesc := ""
		nTam    := Len(SYP->YP_TEXTO)
		While !Eof() .And. _cChav == SYP->YP_CHAVE
							
			_cDesc += RTrim(Subs(SYP->YP_TEXTO,1,nTam))
		
			dbSkip()
		EndDo
	Endif

	AppendDet()
	DETAIL_P->AVG_C01_60 := ""
	UnlockDet()

	For i:=1 To MlCount(_cDesc,30)
		AppendDet()
		DETAIL_P->AVG_C01_60 := MemoLine(_cDesc,30,i)
		UnLockDet()
	Next i

	DO WHILE MOD(nLin,NUMLINPAG) <> 0
		APPENDDET()
	ENDDO

Return NIL

/*
Funcao      : AppendDet
Parametros  :
Retorno     :
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira
Data/Hora   : 05/05/2000
Revisao     :
Obs.        :
*/
Static Function AppendDet()

	Begin Sequence
		nLin := nLin+1
		IF nLin > NUMLINPAG
			nLin := 1
			nPag := nPag+1
		ENDIF
		DETAIL_P->(dbAppend())
		DETAIL_P->AVG_FILIAL := xFilial("SY0")
		DETAIL_P->AVG_SEQREL := cSEQREL
		DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB //nr. do processo
		DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
	End Sequence

Return NIL

/*
Funcao      : UnlockDet
Parametros  :
Retorno     :
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira
Data/Hora   : 05/05/2000
Revisao     :
Obs.        :
*/
Static Function UnlockDet()

	Begin Sequence
		DETAIL_P->(dbUnlock())
	End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  :
Retorno     :
Objetivos   :
Autor       : Cristiano A. Ferreira
Data/Hora   :
Revisao     :
Obs.        :
*/
Static Function TelaGets

	Local lRet := .f.
	Local nOpc := 0
	Local oDlg

	Local bOk     := {||nOpc:=1,oDlg:End()}
	Local bCancel := {||nOpc:=0,oDlg:End()}

	Local bSet  := {|x,o| lNcm := x, o:Refresh(), lNcm }
	Local bSetP := {|x,o| lPesoBru := x, o:Refresh(), lPesoBru }
	Local bHide,bHideAll

	Local aCampos := {{"WKMARCA",," "},;
		{"WKCODIGO",,"Código"},;
		{"WKDESCR",,"Descrição"}}

	Local oFld, oFldDoc, oFldNot,oFldCFG, oBtnOk, oBtnCancel
	Local oYes, oNo, oYesP, oNoP, oMark, oMark2, oMark3

	Local bShow    := {|nTela,o| if(nTela==2,dbSelectArea("Work"),if(nTela==3,dbSelectArea("WkMsg"),;
		if(nTela==4,dbSelectArea("Work_Men"),))),;
		o := if(nTela==2,oMark,if(nTela==3,oMark2,oMark3)):oBrowse,;
		o:Show(),o:SetFocus() }
	
	Local n,i,nTamLoj,cKey,cLoja,cImport
	Local xx := "",nPosLin:=20
	
	Private aMarcados[2], nMarcado := 0
	
	Begin Sequence
	
		If lUnidade
			bHide    := {|nTela| if(nTela==2,oMark:oBrowse:Hide(),;
				if(nTela==3,oMark2:oBrowse:Hide(),;
				if(nTela==4,oMark3:oBrowse:Hide(),;
				If(nTela==5,(oMark:oBrowse:Hide(),oMark2:oBrowse:Hide(),oMark3:oBrowse:Hide()),))))}
					
			bHideAll := {|| Eval(bHide,2), Eval(bHide,3), Eval(bHide,4),Eval(bHide,5) }
					
		Else
			bHide    := {|nTela| if(nTela==2,oMark:oBrowse:Hide(),;
				if(nTela==3,oMark2:oBrowse:Hide(),;
				if(nTela==4,oMark3:oBrowse:Hide(),))) }
							
			bHideAll := {|| Eval(bHide,2), Eval(bHide,3), Eval(bHide,4)}
		EndIf
						
						
						// Notify
		EEN->(dbSeek(xFilial("EEN")+EEC->EEC_PREEMB+OC_EM))
						
		While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
				EEN->EEN_PROCES+EEN->EEN_OCORRE == EEC->EEC_PREEMB+OC_EM
							
			SysRefresh()
							
			Work->(dbAppend())
			Work->WKTIPO   := "N"
			Work->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
			Work->WKDESCR  := EEN->EEN_IMPODE
							
			EEN->(dbSkip())
		Enddo
						
		Work->(dbGoTop())
						
		DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,0 TO 28,80 OF oMainWnd
						
		oFld := TFolder():New(1,1,If(lUnidade,{"Documentos Para","Notify's","Mensagens","Observações","Configurações"},{"Documentos Para","Notify's","Mensagens","Observações"}),;
		If(lUnidade,{"IPC","IBC","OBS","MEN","CFG"},{"IPC","IBC","OBS","MEN"}),oDlg,,,,.T.,.F.,315,127)
							
			aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont) })
							
							// Documentos Para
			oFldDoc := oFld:aDialogs[1]
							
							
			If !lUnidade
				@ 10,001 SAY "Imprime N.C.M." SIZE 232,10 PIXEL OF oFldDoc
								
				oYes := TCheckBox():New(10,42,"Sim",{|x| If(PCount()==0, lNcm,Eval(bSet, x,oNo ))},oFldDoc,21,10,,,,,,,,.T.) //
				oNo  := TCheckBox():New(10,65,"Não",{|x| If(PCount()==0,!lNcm,Eval(bSet,!x,oYes))},oFldDoc,21,10,,,,,,,,.T.) //
								
				@ 10,100 SAY "Imprime Peso Bruto" SIZE 232,10 PIXEL OF oFldDoc //
								
				oYesP := TCheckBox():New(10,157,"Sim",{|x| If(PCount()==0, lPesoBru,Eval(bSetP, x,oNoP ))},oFldDoc,21,10,,,,,,,,.T.) //
				oNoP  := TCheckBox():New(10,180,"Não",{|x| If(PCount()==0,!lPesoBru,Eval(bSetP,!x,oYesP))},oFldDoc,21,10,,,,,,,,.T.) //
			Else
				nPosLin := 10
			EndIf
							
			M->cCONTATO   := EEC->EEC_RESPON  //cEXP_CONTATO
			M->cEXP_CARGO := "EXPORT COORDINATOR"
							
			@ nPosLin,001 SAY "Assinante" SIZE 232,10 PIXEL OF oFldDoc //
			@ nPosLin,043 GET M->cCONTATO SIZE 120,08 PIXEL OF oFldDoc
							
			@ nPosLin+10,001 SAY "Cargo" SIZE 232,10 PIXEL OF oFldDoc //
			@ nPosLin+10,043 GET M->cEXP_CARGO SIZE 120,08 PIXEL OF oFldDoc
							
			@ nPosLin+24,001 SAY "Doct.Para" SIZE 232,10 PIXEL OF oFldDoc
							
			@ nPosLin+24,043 GET cC2160 SIZE 120,08 PIXEL OF oFldDoc
			@ nPosLin+34,043 GET cC2260 SIZE 120,08 PIXEL OF oFldDoc
			@ nPosLin+44,043 GET cC2360 SIZE 120,08 PIXEL OF oFldDoc
			@ nPosLin+54,043 GET cC2460 SIZE 120,08 PIXEL OF oFldDoc
			@ nPosLin+64,043 GET cC2960 SIZE 120,08 PIXEL OF oFldDoc
			@ nPosLin+74,043 GET cC3060 SIZE 120,08 PIXEL OF oFldDoc
							
							// Folder Notify's ...
			oMark := MsSelect():New("Work","WKMARCA",,aCampos,@lInverte,@cMarca,{18,3,125,312})
			oMark:bAval := {|| ChkMarca(oMark,cMarca) }
			@ 14,043 GET xx OF oFld:aDialogs[2]
			AddColMark(oMark,"WKMARCA")
							
							
							// Folder Mensagens ...
			@ 14,043 GET xx OF oFld:aDialogs[3]
			oMark3 := EECMensagem(EEC->EEC_IDIOMA,"#",{18,3,125,312},,,,oDlg)
							
							// Folder Observações ...
			oMark2 := Observacoes("New",cMarca)
			@ 14,043 GET xx OF oFld:aDialogs[4]
			AddColMark(oMark2,"WKMARCA")
			lPesoBru := .T.
			cUnQtde  := "PC"
			cUnPreco := "PC"
			cUnPeso  := "KG"
							
			Eval(bHideAll)
							
			If lUnidade
				oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
					IF(nOption <> 1 .And. nOption <> 5,Eval(bShow,nOption),) }
			ELse
				oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
					IF(nOption <> 1,Eval(bShow,nOption),)}
			EndIf
									
			DEFINE SBUTTON oBtnOk     FROM 130,258 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
			DEFINE SBUTTON oBtnCancel FROM 130,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
									
			ACTIVATE MSDIALOG oDlg CENTERED
									
			IF nOpc == 0
				Break
			Endif
									
			lRet := .t.
									
			n := 1
			For i:=1 To 2
				IF !Empty(aMarcados[i])
					nTamLoj := AVSX3("EEN_IMLOJA",3)
					cKey    := Subst(aMarcados[i],2)
					cLoja   := Right(cKey,nTamLoj)
					cImport := Subst(cKey,1,Len(cKey)-nTamLoj)
											
					IF EEN->(dbSeek(xFilial("EEN")+AvKey(EEC->EEC_PREEMB,"EEN_PROCES")+OC_EM+AvKey(cImport,"EEN_IMPORT")+AvKey(cLoja,"EEN_IMLOJA")))
						aNotify[n]   := EEN->EEN_IMPODE
						aNotify[n+1] := EEN->EEN_ENDIMP
						aNotify[n+2] := EEN->EEN_END2IM
						n := n+3
					Endif
				Endif
			Next
									
			cEXP_CONTATO := M->cCONTATO
									
		End Sequence
									
		OBSERVACOES("END")
									
	Return lRet
									
									/*
									Funcao      : ChkMarca
									Parametros  :
									Retorno     :
									Objetivos   :
									Autor       : Cristiano A. Ferreira
									Data/Hora   :
									Revisao     :
									Obs.        :
									*/
	Static Function ChkMarca(oMark,cMarca)
									
		Local n
									
		Begin Sequence
			IF ! Work->(Eof() .Or. Bof())
				IF !Empty(Work->WKMARCA)
											// Desmarca
					n := aScan(aMarcados,Work->WKTIPO+Work->WKCODIGO)
					IF n > 0
						aMarcados[n] := ""
					Endif
											
					Work->WKMARCA := Space(2)
				Else
											// Marca
					IF !Empty(aMarcados[1]) .And. !Empty(aMarcados[2])
						HELP(" ",1,"AVG0005046") //MsgStop("Já existem dois notify's selecionados !","Aviso")
						Break
					Endif
											
					IF Empty(aMarcados[1])
						aMarcados[1] := Work->WKTIPO+Work->WKCODIGO
					Else
						aMarcados[2] := Work->WKTIPO+Work->WKCODIGO
					Endif
											
					Work->WKMARCA := cMarca
				Endif
										
				oMark:oBrowse:Refresh()
			Endif
		End Sequence
									
	Return NIL
									
									/*
									Funcao      : Observacoes
									Parametros  : cAcao := New/End
									Retorno     :
									Objetivos   :
									Autor       :
									Data/Hora   :
									Revisao     : Cristiano A. Ferreira
									04/05/2000 - Protheus
									Obs.        :
									*/
	Static Function Observacoes(cAcao,cMarca)
									
		Local xRet := nil
									
		Local cPaisEt := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_PAIS")
		Local nAreaOld, aOrd, aSemSx3
		Local cTipMen, cIdioma, cTexto, i
									
		Local oMark
		Local lInverte := .F.
									
		Static aOld
									
		Begin Sequence
			cAcao := Upper(AllTrim(cAcao))
									
			IF cAcao == "NEW"
				aOrd := SaveOrd({"EE4","EE1"})
										
				EE1->(dbSetOrder(1))
				EE4->(dbSetOrder(1))
										
				Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
				aSemSX3 := { {"WKMARCA","C",02,0},{"WKTEXTO","M",10,0}}
										
				aOld := {Select(), E_CriaTrab("EE4",aSemSX3,"WkMsg")}
										
				EE1->(dbSeek(xFilial("EE1")+TR_MEN+cPAISET))
										
				While !EE1->(Eof()) .And. EE1->EE1_FILIAL == xFilial("EE1") .And.;
						EE1->EE1_TIPREL == TR_MEN .And.;
						EE1->EE1_PAIS == cPAISET
											
					cTipMen := EE1->EE1_TIPMEN+"-"+Tabela("Y8",AVKEY(EE1->EE1_TIPMEN,"X5_CHAVE"))
					cIdioma := Posicione("SYA",1,xFilial("SYA")+EE1->EE1_PAIS,"YA_IDIOMA")
											
					IF EE4->(dbSeek(xFilial("EE4")+AvKey(EE1->EE1_DOCUM,"EE4_COD")+AvKey(cTipMen,"EE4_TIPMEN")+AvKey(cIdioma,"EE4_IDIOMA")))
						WkMsg->(dbAppend())
						cTexto := MSMM(EE4->EE4_TEXTO,AVSX3("EE4_VM_TEX",3))
												
						For i:=1 To MlCount(cTexto,AVSX3("EE4_VM_TEX",3))
							WkMsg->WKTEXTO := WkMsg->WKTEXTO+MemoLine(cTexto,AVSX3("EE4_VM_TEX",3),i)+ENTER
						Next
												
						WkMsg->EE4_TIPMEN := EE4->EE4_TIPMEN
						WkMsg->EE4_COD    := EE4->EE4_COD
					ENDIF
											
					EE1->(dbSkip())
				Enddo
										
				dbSelectArea("WkMsg")
				WkMsg->(dbGoTop())
										
				aCampos := { {"WKMARCA",," "},;
					ColBrw("EE4_COD","WkMsg"),;
					ColBrw("EE4_TIPMEN","WkMsg"),;
					{{|| MemoLine(WkMsg->WKTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),1)},"",AVSX3("EE4_VM_TEX",AV_TITULO)}}
										
				oMark := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{18,3,125,312}) //{1,1,110,315})
				oMark:bAval := {|| EditObs(cMarca), oMark:oBrowse:Refresh() }
				xRet := oMark
										
				RestOrd(aOrd)
			Elseif cAcao == "END"
				IF Select("WkMsg") > 0
					WkMsg->(E_EraseArq(aOld[2]))
				Endif
										
				Select(aOld[1])
			Endif
		End Sequence
									
	Return xRet
									
									/*
									Funcao      : EditObs
									Parametros  :
									Retorno     :
									Objetivos   :
									Autor       :
									Data/Hora   :
									Revisao     : Cristiano A. Ferreira
									04/05/2000 - Protheus
									Obs.        :
									*/
									
	Static Function EditObs(cMarca)
									
		Local nOpc, cMemo, oDlg
									
		Local bOk     := {|| nOpc:=1, oDlg:End() }
		Local bCancel := {|| oDlg:End() }
									
		Local nRec
									
		IF WkMsg->(!Eof())
			IF Empty(WkMsg->WKMARCA)
				nOpc:=0
				cMemo := WkMsg->WKTEXTO
											
				DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
											
				@ 05,05 SAY "Tipo Mensagem" PIXEL //
				@ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
				@ 20,05 GET cMemo MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL
											
				DEFINE SBUTTON oBtnOk     FROM 130,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
				DEFINE SBUTTON oBtnCancel FROM 130,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
											
				ACTIVATE MSDIALOG oDlg CENTERED // ON INIT EnchoiceBar(oDlg,bOk,bCancel)
											
				IF nOpc == 1
					IF !Empty(nMarcado)
						nRec := WkMsg->(RecNo())
						WkMsg->(dbGoTo(nMarcado))
						WkMsg->WKMARCA := Space(2)
						WkMsg->(dbGoTo(nRec))
					Endif
					cObs := cObs + CMemo
					WkMsg->WKTEXTO := cMemo
					WkMsg->WKMARCA := cMarca
					nMarcado := nRec
				Endif
			Else
				cObs := ""
				WkMsg->WKMARCA := Space(2)
				nMarcado := 0
			Endif
		Endif
									
	Return NIL
