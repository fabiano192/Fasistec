#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*
Programa 	: PXH059
Autor 		: Fabiano da Silva	-	26/08/13
Uso 		: SIGAFIN - Faturamento
Descrição 	: Gerar Fatura de Locação de máquinas e equipamentos e Boleto
*/

USER FUNCTION PXH059()

	LOCAL oDlg := NIL

	If Alltrim(SM0->M0_CODIGO) = '13' .And. (Alltrim(SM0->M0_CODFIL) = '07501'.Or. Alltrim(SM0->M0_CODFIL) = '07701')

		PRIVATE cTitulo    	:= "Fatura de Locação de Máquinas e Equipamentos - PXH059"
		PRIVATE oPrn       	:= NIL
		PRIVATE _nCont     	:= 0
		Private _nLin
		Private _lEnt

		Private _lRadio 	:= .F.
		Private _nRadio  	:= 1
		Private _oRadio  	:= Nil
		Private _oCC
		Private _cCC 		:= Space(60)
		Private _cTit		:= ""

		AtuSx1()

		_nOpc := 0

		DEFINE MSDIALOG oDlg FROM 0,0 TO 250,520 TITLE cTitulo OF oDlg PIXEL

		@ 010,010 TO 060,210 LABEL "" OF oDlg PIXEL

		@ 013,017 SAY "Esta rotina tem por objetivo gerar: 	" 									OF oDlg PIXEL Size 180,010 //FONT oFont14
		@ 023,017 SAY "Fatura de Locação de Máquinas e Equipamentos e " 						OF oDlg PIXEL Size 180,010 //FONT oFont14
		@ 033,017 SAY "Boleto(s) Bancário, conforme os parâmetros informados pelo usuário. " 	OF oDlg PIXEL Size 180,010 //FONT oFont14

		@ 62,10 TO 105,210 LABEL "Tipo" OF oDlg PIXEL
		@ 70,15 RADIO _oRadio VAR _nRadio ITEMS "Visualizar","E-mail" SIZE 60,10 On Change PHX59RAD() PIXEL OF oDlg

		@ 90,015 SAY "Cópia e-mail:"  SIZE 040,010 OF oDlg PIXEL
		@ 90,055 MSGET _oCC VAR _cCC When _lRadio SIZE 120,010 OF oDlg PIXEL

		@ 110,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PXH059"))		OF oDlg PIXEL
		@ 110,090 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
		@ 110,160 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		If _nOpc = 1
			Private _lFim      := .F.
			Private _cMsg01    := ''
			Private _lAborta01 := .T.
			Private _bAcao01   := {|_lFim| PXH59A(@_lFim) }
			Private _cTitulo01 := 'Processando'

			Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
		Endif
	Else
		MsgAlert('Este programa só poderá ser utilizado nas Empresas (13-07501) ou (13-07701)')
	Endif

Return(Nil)


//Validador Radio
Static Function PHX59RAD()

	If _nRadio = 2
		_lRadio := .T.
	Else
		_lRadio := .F.
	Endif

	_oCC:CtrlRefresh()
	_oCC:SetFocus()

Return


Static Function PXH59A()

	Pergunte("PXH059",.F.)

	_lView := .F.
	If _nRadio = 1 //Visualiza Impressão
		_lView	:= .T.
	Endif

	U_PXH59GERA(MV_PAR01,MV_PAR02,_lView,_cCC)

Return

/*
Criado função do tipo "User Function", pois a mesma é utilizado no ponto de entrada SF2460I(), no fonte PONTOS_FAT.PRW
*/
User Function PXH59GERA(_cSerie,_cNF,_lView,_cCC)

	Private oFont08    	:= TFont():New("Arial", ,-08,   , .F. , , , , .F. , .F. )
	Private oFont08B   	:= TFont():New("Arial", ,-08,   , .T. , , , , .T. , .T. )
	Private oFont10    	:= TFont():New("Arial", ,-10,   , .F. , , , , .F. , .F. )
	Private oFont10B   	:= TFont():New("Arial", ,-10,.t., .T. , , , , .F. , .F. )
	Private oFont12    	:= TFont():New("Arial", ,-12,   , .F. , , , , .F. , .F. )
	Private oFont12B   	:= TFont():New("Arial", ,-12,.t., .T. , , , , .F. , .F. )
	Private oFont14    	:= TFont():New("Arial", ,-14,   , .F. , , , , .F. , .F. )
	Private oFont14B   	:= TFont():New("Arial", ,-14,   , .T. , , , , .F. , .F. )
	Private oFont16B   	:= TFont():New("Arial", ,-16,   , .T. , , , , .F. , .F. )
	Private _cEmissao	:= ""


	_cQuery := " SELECT * FROM "+RetSqlName("SF2")+" F2 " + CRLF
	_cQuery += " INNER JOIN  "+RetSqlName("SD2")+" D2 ON F2_FILIAL = D2_FILIAL AND F2_SERIE = D2_SERIE AND F2_DOC = D2_DOC " + CRLF
	_cQuery += " INNER JOIN  "+RetSqlName("SF4")+" F4 ON D2_TES = F4_CODIGO " + CRLF
	_cQuery += " INNER JOIN  "+RetSqlName("SA1")+" A1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND LEFT (F2_FILIAL,3) = A1_FILIAL" + CRLF
	_cQuery += " INNER JOIN  "+RetSqlName("SC5")+" C5 ON D2_PEDIDO = C5_NUM AND D2_FILIAL = C5_FILIAL " + CRLF
	_cQuery += " WHERE F2.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' " + CRLF//AND F2_FILIAL = "+xFilial("SF2")+" "
	_cQuery += " AND F4_DUPLIC = 'S' AND F2_TIPO = 'N' " + CRLF
	_cQuery += " AND F2_SERIE = '"+_cSerie+"'  " + CRLF
	_cQuery += " AND F2_DOC = '"+_cNF+"'  " + CRLF

	//MemoWrite("D:\PXH059.TXT",_cQuery)

	TCQUERY _cQuery NEW ALIAS "TSF2"

	TcSetField("TSF2","F2_EMISSAO","D")

	COUNT TO _nRec

	If _nRec > 0

		_cData   := DTOS(dDataBase)
		_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cTit    := 'NF_'+_cSerie+'-'+_cNF+'_'+_cData+'_'+_cHora

		oPrn 	:= FWMSPrinter():New( _cTit   ,6       ,.F.,       ,.T. ,.F. , , ,.T. , , ,_lView )
		oPrn:SetPortrait()

		_cDir	:= "C:\TOTVS\"

		If !ExistDir( _cDir )
			If MakeDir( _cDir ) <> 0
				MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
				Return
			EndIf
		EndIf

		oPrn:cPathPDF 	:= _cDir

		TSF2->(dbGoTop())
		_cTo 	:= Alltrim(TSF2->A1_EMAIL)
		GeraFat() //Imprime Fatura

		TSF2->(dbGoTop())
		GeraBol() //Imprime Boleto

		Ms_Flush()
		oPrn:EndPage()
		oPrn:Preview()

		If !_lView //E-mail
			_cAnexo := _cDir+_cTit+".pdf"
			If CpyT2S( _cAnexo, "\WORKFLOW\EMP"+Alltrim(SM0->M0_CODIGO)+"\RELATORIOS\")

				If Empty(_cTo) .And. Empty(_cCC)
					MsgAlert('Não existe e-mail no cadastro de Cliente!')
				Else
					PXH59B(_cTo,Alltrim(_cCC),_cSerie,_cNF)
				Endif
			Else
				MsgInfo("Não foi possível copiar o arquivo para o servidor!")
			Endif
		Endif
	Endif

	TSF2->(dbCloseArea())

Return()



Static Function GeraFat()//Gera Fatura

	oPrn:StartPage()

	//1º BOX	
	oPrn:Box(0008,0008,285,0580)
	oPrn:SayBitmap(017,085,"lgrl"+Alltrim(SM0->M0_CODIGO)+Alltrim(SM0->M0_CODFIL)+".jpg",0120,0020)
	oPrn:Say(0055,0080,Alltrim(SM0->M0_NOMECOM)											,oFont08B)
	oPrn:Say(0065,0075,'Tel: '+Alltrim(SM0->M0_TEL)+' / FAX: '+Alltrim(SM0->M0_FAX)		,oFont08B)
	oPrn:Say(0075,0080,'www.polimixequipamemntos.com.br'								,oFont08B)

	oPrn:Line(0008,0288,0100,0288)
	If TSF2->F2_PREFIXO = 'FAT'
		oPrn:Say(0020,0295,"FATURA DE LOCAÇÃO DE EQUIPAMENTOS"			,oFont08B)
	Else
		oPrn:Say(0020,0295,"NOTA FISCAL ELETRONICA DE SERVIÇOS NF-e"	,oFont08B)
	Endif
	//oPrn:Say(0030,0295,"MÁQUINAS E EQUIPAMENTOS"		,oFont08B)
	oPrn:Say(0020,0500,"Nº"								,oFont08B)
	oBrush := TBrush():New( , CLR_HGRAY)
	oPrn:FillRect( {0012,520,0022,570}, oBrush)
	oPrn:Say(0020,0522,Alltrim(TSF2->F2_DOC)			,oFont08B)

	oPrn:Say(0045,0295,'Endereço: '						,oFont08)
	oPrn:Say(0045,0370,Alltrim(SM0->M0_ENDCOB)			,oFont08B)
	oPrn:Say(0055,0295,'Bairro: '						,oFont08)
	oPrn:Say(0055,0370,Alltrim(SM0->M0_BAIRCOB)			,oFont08B)
	oPrn:Say(0055,0500,'CEP: '							,oFont08)
	oPrn:Say(0055,0520,Transform(Alltrim(SM0->M0_CEPCOB), '@R 99.999-999')			,oFont08B)
	oPrn:Say(0065,0295,'Cidade: '						,oFont08)
	oPrn:Say(0065,0370,Alltrim(SM0->M0_CIDCOB)			,oFont08B)
	oPrn:Say(0065,0500,'UF: '							,oFont08)
	oPrn:Say(0065,0520,Alltrim(SM0->M0_ESTCOB)			,oFont08B)
	oPrn:Say(0075,0295,'Inscrição no CNPJ: '			,oFont08)
	oPrn:Say(0075,0370,Transform(Alltrim(SM0->M0_CGC), '@R 99.999.999/9999-99')			,oFont08B)
	oPrn:Say(0085,0295,'Inscrição Estadual: '			,oFont08)
	oPrn:Say(0085,0370,Transform(Alltrim(SM0->M0_INSC), '@R 999.999.999.999')			,oFont08B)
	oPrn:Say(0095,0295,'Emissão: '						,oFont08)
	//	oPrn:Say(0095,0370,dtoc(dDataBase)					,oFont08B)
	oPrn:Say(0095,0370,dtoc(TSF2->F2_EMISSAO)			,oFont08B)

	oPrn:Line(0100,0008,0100,0580)
	oPrn:Say(0112,0020,"Fatura:"	,oFont08)

	oPrn:Line(0120,0008,0120,0580)

	SE1->(dbSetOrder(1))
	SE1->(MsSeek(xFilial("SE1")+TSF2->F2_PREFIXO+TSF2->F2_DOC))

	_nCol := 18
	_nTotDup := 0
	While !SE1->(Eof()) .And. xFilial("SE1") == TSF2->F2_FILIAL .And.;
	TSF2->F2_PREFIXO == SE1->E1_PREFIXO .And.;
	TSF2->F2_DOC == SE1->E1_NUM 

		If SE1->E1_TIPO = 'NF'

			_cDoc		:= Alltrim(SE1->E1_PREFIXO)+'-'+Alltrim(SE1->E1_NUM)+'-'+Alltrim(SE1->E1_PARCELA)
			_nVlrAbat   := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
			_nValDupl 	:= AllTrim(TransForm(SE1->E1_SALDO - _nVlrAbat, "@E 99,999,999.99"))
			_nTotDup	+= (SE1->E1_SALDO - _nVlrAbat)

			oPrn:Say(0130,_nCol+2,_cDoc					,oFont08b)
			oPrn:Say(0138,_nCol+2,dToc(SE1->E1_VENCTO)	,oFont08b)
			oPrn:Say(0146,_nCol+2,_nValDupl				,oFont08b)

			_nCol += 80

			oPrn:Line(120,_nCol,150,_nCol)

		Endif

		SE1->(dbSkip())
	EndDo


	oPrn:Line(0150,0008,0150,0580)

	oPrn:Say(0165,0020,'Nome do Sacado: '			,oFont08)
	oPrn:Say(0165,0100,Alltrim(TSF2->A1_NOME)		,oFont08B)
	oPrn:Say(0180,0020,'Endereço: '					,oFont08)
	oPrn:Say(0180,0100,Alltrim(TSF2->A1_END)		,oFont08B)
	oPrn:Say(0180,0310,'Bairro: '					,oFont08)
	oPrn:Say(0180,0400,UPPER(Alltrim(TSF2->A1_BAIRRO))		,oFont08B)
	oPrn:Say(0195,0020,'Cidade: '					,oFont08)
	oPrn:Say(0195,0100,Alltrim(TSF2->A1_MUN)		,oFont08B)
	oPrn:Say(0195,0310,'UF: '						,oFont08)
	oPrn:Say(0195,0400,Alltrim(TSF2->A1_EST)		,oFont08B)
	oPrn:Say(0195,0480,'CEP: '						,oFont08)
	oPrn:Say(0195,0510,Transform(Alltrim(TSF2->A1_CEP), '@R 99.999-999')		,oFont08B)
	oPrn:Say(0210,0020,'Inscrição no CNPJ: '		,oFont08)
	oPrn:Say(0210,0100,Transform(Alltrim(TSF2->A1_CGC), '@R 99.999.999/9999-99')		,oFont08B)
	oPrn:Say(0210,0310,'Inscrição Estadual: '		,oFont08)
	oPrn:Say(0210,0400,Alltrim(TSF2->A1_INSCR)		,oFont08B)
	oPrn:Line(0225,0008,0225,0580)

	oPrn:Say(0240,0020,'Valor por Extenso:'			,oFont08)
	oPrn:Say(0240,0100,	Extenso(_nTotDup)			,oFont08B)
//	oPrn:Say(0240,0100,	Extenso(TSF2->F2_VALBRUT)	,oFont08B)
	oPrn:Line(0250,0008,0250,0580)

	oPrn:Say(0265,0020,'DEVE(M) À '+Alltrim(SM0->M0_NOMECOM)+', ESTABELECIDA NA '+Alltrim(SM0->M0_ENDCOB)+' - '+Alltrim(SM0->M0_BAIRCOB)+;
	' - '+Alltrim(SM0->M0_CIDCOB)+', '+Alltrim(SM0->M0_ESTCOB),oFont08)
	If  Alltrim(SM0->M0_CODFIL) = '07701'
		oPrn:Say(0275,0020,'A IMPORTÂNCIA ACIMA CORRESPONDENTE À LOCAÇÃO DE MÁQUINAS E EQUIPAMENTOS',oFont08)
	Endif

	//2º BOX
	oPrn:Box(0290,0008,0635,0580,"-6")

	oPrn:Say(0303,0020,'Prefixo'											,oFont08B)
	oPrn:Line(0290,0110,0615,0110)
	oPrn:Say(0303,0120,'Descrição das Máquinas e Equipamentos'				,oFont08B)
	oPrn:Line(0290,0510,0635,0510)
	oPrn:Say(0303,0530,'Preços R$'											,oFont08B)
	oPrn:Line(0310,0008,0310,0580)

	_nValISS	:= TSF2->F2_VALISS
	_nValIRR	:= TSF2->F2_VALIRRF
	_nValPIS	:= TSF2->F2_VALPIS
	_nValCOF	:= TSF2->F2_VALCOFI
	_nValCSL	:= TSF2->F2_VALCSLL
	_nValINS	:= TSF2->F2_VALINSS

	_cMenNota 	:= Alltrim(TSF2->C5_MENNOTA)
	_nTotal 	:= 0
	_nLin   	:= 320
	While !TSF2->(EOF())

		SB1->(dbSetOrder(1))
		SB1->(msSeek(xFilial('SB1')+TSF2->D2_COD))

		oPrn:Say(_nLin,0020,TSF2->D2_COD		,oFont08)
		oPrn:Say(_nLin,0120,SB1->B1_DESC	,oFont08)
		oPrn:SayAlign(_nLin-7,0490,Transform(TSF2->D2_TOTAL		, "@E 9,999,999.99")	,oFont08,080,,,1,1)

		_nTotal += TSF2->D2_TOTAL
		_nLin   += 10

		TSF2->(dbskip())
	EndDo

	oPrn:Line(0615,0008,0615,0580)
	oPrn:Say(0627,0480,'Total R$'											,oFont08B)
	oPrn:SayAlign(620,0490,Transform(_nTotal		, "@E 9,999,999.99")	,oFont08,080,,,1,1)


	//3º BOX	
	oPrn:Box(0640,0008,0675,0580)
	oPrn:Say(0649,0220,'RETENÇOES NA FONTE PELO TOMADOR'					,oFont08)
	oPrn:Line(0652,0008,0652,0580)
	oPrn:Line(0664,0008,0664,0580)
	oPrn:SayAlign(654,0013,'ISS'											,oFont08,090,,,2,1)
	oPrn:SayAlign(665,0008,Transform(_nValISS		, "@E 9,999,999.99")	,oFont08,090,,,2,1)
	oPrn:Line(0652,0103,0675,0103)
	oPrn:SayAlign(654,0108,'IRRF'											,oFont08,090,,,2,1)
	oPrn:SayAlign(665,0103,Transform(_nValIRR		, "@E 9,999,999.99")	,oFont08,090,,,2,1)
	oPrn:Line(0652,0198,0675,0198)
	oPrn:SayAlign(654,0203,'PIS'											,oFont08,090,,,2,1)
	oPrn:SayAlign(665,0198,Transform(_nValPIS		, "@E 9,999,999.99")	,oFont08,090,,,2,1)
	oPrn:Line(0652,0293,0675,0293)
	oPrn:SayAlign(654,0298,'COFINS'											,oFont08,090,,,2,1)
	oPrn:SayAlign(665,0293,Transform(_nValCOF		, "@E 9,999,999.99")	,oFont08,090,,,2,1)
	oPrn:Line(0652,0388,0675,0388)
	oPrn:SayAlign(654,0393,'CSLL'											,oFont08,090,,,2,1)
	oPrn:SayAlign(665,0388,Transform(_nValCSL		, "@E 9,999,999.99")	,oFont08,090,,,2,1)
	oPrn:Line(0652,0483,0675,0483)
	oPrn:SayAlign(654,0488,'INSS'											,oFont08,090,,,2,1)
	oPrn:SayAlign(665,0483,Transform(_nValINS		, "@E 9,999,999.99")	,oFont08,090,,,2,1)


	//4º BOX	
	oPrn:Box(0680,0008,0800,0580)

	oPrn:Say(0693,0020,'Observações'										,oFont08B)
	oPrn:Say(0705,0030,_cMenNota											,oFont08)

	oPrn:Line(0720,0008,0720,0580)
	oPrn:Say(0735,0020,'OPERAÇÃO ISENTA DE TRIBUTOS MUNICIPAIS,' 			,oFont08)
	oPrn:Say(0745,0020,'NÃO HAVENDO OBRIGAÇÃO DE NOTA FISCAL'				,oFont08)
	oPrn:Say(0755,0020,'CONFORME LEI FEDERAL DO ISS Nº 116 DE 31/07/2003'	,oFont08)

	oPrn:Say(0790,0470,'NÃO VALE COMO RECIBO'								,oFont08B)

	oPrn:EndPage()

Return



Static function GeraBol() //Gera Boleto

	LOCAL lBcoNaoOk
	LOCAL n := 0
	LOCAL aDadosEmp
	LOCAL aDadosTit
	LOCAL aDadosBanco
	LOCAL aDatSacado
	LOCAL i           	:= 1
	LOCAL CB_RN_NN    	:= {}
	LOCAL nRec        	:= 0
	LOCAL _nVlrAbat   	:= 0

	PRIVATE _nMora 		:= GetNewPar("PXH_BOLMOR",1)
	Private _nMulta		:= GetNewPar("PXH_BOLMUL",2)
	PRIVATE _cFilBco 	:= GetNewPar("PXH_BOLFIL","077")
	//Private _cBanco		:= Alltrim(GetNewPar("PXH_BOLBCO","237"))
	//Private _cContaKey  := Alltrim(GetNewPar("PXH_BOLCTA","5263557"))
	//Private _cAgencia	:= Alltrim(GetNewPar("PXH_BOLAGE","23744"))        
	
	Private _cBanco		:= Alltrim(GetNewPar("PXH_BOLBCO","237"))
	Private _cContaKey  := Alltrim(GetNewPar("PXH_BOLCTA","00015776"))
	Private _cAgencia	:= Alltrim(GetNewPar("PXH_BOLAGE","23744"))
	
	
	Private _cBarra     := ""
	PRIVATE _cCart		:= ''

	aDadosEmp    		:= {SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                                            ,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

	_cAgenc2 := Left(_cAgencia,4) 
	_cCont2  := Left(Alltrim(_cContaKey),Len(Alltrim(_cContaKey))-1)
	
	SA6->(DbSetOrder(1))
	If SA6->(dbSeek(xFilial("SA6") + _cBanco + Left(_cAgenc2+Space(5),5) + _cCont2))
	
		//Posiciona o SA1 (Cliente)
		SA1->(DbSetOrder(1))

		//Posiciona na Arq de Parametros CNAB 

		_cAgenc2 := Left(_cAgencia,4)+Space(1) 

		SEE->(DbSetOrder(1))
		SEE->(msSeek(xFilial("SEE")+_cBanco+_cAgenc2+_cContaKey ))

		_cQuery := " SELECT * FROM "+RetSqlName("SE1")+" E1 " + CRLF
		_cQuery += " WHERE E1.D_E_L_E_T_ = '' " + CRLF
		_cQuery += " AND E1_FILIAL 	= '"+TSF2->F2_FILIAL+"' " + CRLF
		_cQuery += " AND E1_CLIENTE = '"+TSF2->F2_CLIENTE+"' " + CRLF
		_cQuery += " AND E1_LOJA 	= '"+TSF2->F2_LOJA+"' " + CRLF
		_cQuery += " AND E1_PREFIXO = '"+TSF2->F2_SERIE+"' " + CRLF
		_cQuery += " AND E1_NUM 	= '"+TSF2->F2_DOC+"' " + CRLF
		_cQuery += " AND E1_TIPO 	= 'NF' " + CRLF

		//MemoWrite("D:\PXH059.TXT",_cQuery)

		TCQUERY _cQuery NEW ALIAS "TSE1"

		Count to nRec

		TSE1->(dbGoTop())
		ProcRegua(nRec)

		Do While !TSE1->(EOF())

			SE1->(DbSetOrder(2))
			If SE1->(msSeek(xFilial('SE1')+TSE1->E1_CLIENTE+TSE1->E1_LOJA+TSE1->E1_PREFIXO+TSE1->E1_NUM+TSE1->E1_PARCELA+TSE1->E1_TIPO))

				If SE1->E1_EMISSAO = SE1->E1_VENCTO .And. SE1->E1_TIPO = "NF"
					TSE1->(dbSkip())
					Loop
				Endif

				_cSa1Bco := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_BCO1")

				lBcoNaoOk := .T.

				If SE1->E1_PORTADO == "237" .Or. _cSa1Bco == "237"
					lBcoNaoOk := .F.
				Endif

				IF lBcoNaoOk
					ApMsgInfo("O código de banco informado no cadastro do cliente não é 237. Esta rotina imprime apenas boletos para o bradesco. Altere para 237 o banco do cliente e você conseguirar imprimir por aqui.",TSE1->(E1_CLIENTE+E1_LOJA+"-"+E1_PREFIXO+E1_NUM+E1_PARCELA) )
					TSE1->(dbSkip())
					LOOP
				ENDIF

				_cCart		:= SEE->EE_CODCOBE
				IF EMPTY(_cCart)
					_cCart		:= '09'
				ENDIF

				nBaseMod	:= 7
				nBaseMod	:= IIf(_cCart=='09',7,9)
				cNossoNum	:= Left(SE1->E1_NUMBCO,11)
				cDVNN 		:= SubStr(SE1->E1_NUMBCO,12,1)

				If Empty(cNossoNum)

					aNum := {"0","1","2","3","4","5","6","7","8","9"}
					aLet := {" ","A","B","C","D","E","F","G","H","I"}

					cNossoNum	:= CheckNumero(_cBanco)//Left(_cAgencia,4)+Padr(SE1->E1_NUM,6,"0")+Subs(aNum[Ascan(aLet,SE1->E1_PARCELA)],1)
					cDVNN 		:= Digito_BR(cNossoNum) //DIGITO DO BANCO BRADESCO

					SE1->(RecLock("SE1",.F.))
					SE1->E1_NUMBCO := cNossoNum+cDVNN
					SE1->(MsUnLock())

					cDVNN 		:= SubStr(SE1->E1_NUMBCO,12,1)
					cNossoNum	:= Left(SE1->E1_NUMBCO,11)

				ElseIf Empty(cDVNN)

					cDVNN 		:= Digito_BR(cNossoNum) //DIGITO DO BANCO BRADESCO

					//GRAVA DÍGITO NOS BOLETOS QUE NÃO TIVEREM
					SE1->(RecLock("SE1",.F.))
					SE1->E1_NUMBCO := cNossoNum+cDVNN
					SE1->(MsUnLock())
				Endif

				aDadosBanco:= {	SA6->A6_COD   			   		                    				,; // [1]Numero do Banco
				SA6->A6_NREDUZ    	            	                    			,; // [2]Nome do Banco
				Substr(AllTrim(SA6->A6_AGENCIA),1,Len(SA6->A6_AGENCIA)-1)	,; // [3]Agência  //Substr(AllTrim(SA6->A6_AGENCIA),1,Len(AllTrim(SA6->A6_AGENCIA))-1)	,; // [3]Agência
				fConta(AllTrim(SA6->A6_NUMCON)) 									,; // [4]Conta Corrente
				Substr(AllTrim(SA6->A6_NUMCON),Len(AllTrim(SA6->A6_NUMCON)),1)    	,; // [5]Dígito da conta corrente
				_cCart												    			,; // [6]Codigo da Carteira
				SA6->A6_TXCOBSI									    				,; // [7]Multa Atrazo COBRANCA SIMPLES
				_nMora                                                  			,;
				Subs(AllTrim(SA6->A6_AGENCIA),Len(AllTrim(SA6->A6_AGENCIA)),1)     }   // [9]Digito da Agencia

				If Empty(SA1->A1_ENDCOB)
					aDatSacado:= {	AllTrim(SA1->A1_NOME)              					,;      // [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;      // [2]Código
					AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;      // [3]Endereço
					AllTrim(SA1->A1_MUN )                            	,;      // [4]Cidade
					SA1->A1_EST                                      	,;      // [5]Estado
					SA1->A1_CEP                                      	,;      // [6]CEP
					AllTrim(SA1->A1_CGC)								}       // [7]CGC
				Else
					aDatSacado:= {	AllTrim(SA1->A1_NOME)              					,;   // [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
					AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRRO),;   // [3]Endereço
					AllTrim(SA1->A1_MUN)	                            ,;   // [4]Cidade
					SA1->A1_EST	                                       ,;   // [5]Estado
					SA1->A1_CEP                                        ,;   // [6]CEP 
					AllTrim(SA1->A1_CGC)								}    // [7]CGC
				Endif

				_nVlrAbat   := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],"0",AllTrim(SE1->E1_NUM),(SE1->E1_SALDO-_nVlrAbat),SE1->E1_VENCTO)
				aDadosTit   := {AllTrim(SE1->E1_NUM)+'/'+AllTrim(SE1->E1_PARCELA)	,;  // [1] Número do título
				DToC(SE1->E1_EMISSAO)                              	,;  // [2] Data da emissão do título
				DtoC(Date())                                  		,;  // [3] Data da emissão do boleto
				DToC(SE1->E1_VENCTO)                               	,;  // [4] Data do vencimento
				(SE1->E1_SALDO - _nVlrAbat)                  		,;  // [5] Valor do título
				cNossoNum                           				,;  // [6] Nosso número (Ver fórmula para calculo) CB_RN_NN[3]
				SE1->E1_PREFIXO                               		,;  // [7] Prefixo da NF
				SE1->E1_TIPO	                               		,;  // [8] Tipo do Titulo
				0 													,;  // [9] Outros acrescimos
				SE1->E1_VALJUR                                      ,;  // [10] Juros de Mora
				cDVNN 												}   // [11] Digito V. Nosso Numero

				_cEmissao := aDadosTit[2]
				nTitPag   := 1
				oPrn:StartPage()   // Inicia uma nova página
				Impress(oPrn,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,CB_RN_NN)
				oPrn:EndPage() // Finaliza a página

				TSE1->(dbSkip())
				IncProc()
				i := i + 1
			Endif
		EndDo

		TSE1->(dbCloseArea())

	Else
		MsgAlert("Banco/Agencia/Conta não encontrado!"+CRLF+CRLF+"Será Gerado somente a Fatura!")
	Endif
Return


Static Function Impress(oPrn,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,CB_RN_NN)

	// Inicia aqui a alteracao para novo layout

	oPrn:SayBitmap(003,015,"bradesco.jpg",0105,0040)
	oPrn:Line(0010,0130,040,0130)
	oPrn:Say(0035,0145,"237-2"																	,oFont16B)
	oPrn:Line(0010,0200,040,0200)
	oPrn:Say(0035,0450,"Recibo do Sacado"														,oFont16B)	//Linha digitável

	oPrn:Line(0040,0008,040,0580)
	oPrn:Line(0070,0008,070,0580)
	oPrn:Line(0100,0008,100,0580)
	oPrn:Line(0150,0010,150,0580)
	oPrn:Line(0040,0152,100,0152)
	oPrn:Line(0040,0295,100,0295)
	oPrn:Line(0040,0437,100,0437)

	//	1ª Linha
	oPrn:Say(050,0010 ,"Vencimento"			 													,oFont08)
	oPrn:Say(065,0030 ,aDadosTit[4]	 															,oFont12)

	oPrn:Say(050,0154 ,"Agência/Código Cedente"													,oFont08)
	oPrn:Say(065,0174 ,aDadosBanco[3]+"-"+aDadosBanco[9]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]	,oFont12)

	oPrn:Say(0050,0297 ,"Nº do Documento"														,oFont08)
	oPrn:Say(0065,0317 ,aDadosTit[7]+'-'+aDadosTit[1]											,oFont12)

	oPrn:Say(0050,0439 ,"Nosso Número"															,oFont08)
	oPrn:Say(0065,0459 ,aDadosTit[6]															,oFont12)

	//	2ª Linha
	oPrn:Say(0080,0010 ,"(=)Valor do Documento"													,oFont08)
	oPrn:Say(0095,0030 ,Transform(aDadosTit[5], "@E 9,999,999,999.99")							,oFont12)
	oPrn:Say(0080,0154 ,"(-)Descontos"															,oFont08)
	oPrn:Say(0080,0297 ,"(+)Acréscimos"															,oFont08)
	oPrn:Say(0080,0439 ,"(=)Valor Cobrado"														,oFont08)

	//	3ª Linha
	oPrn:Say(0110,0010 ,"Cedente: "																,oFont08)
	oPrn:Say(0110,0070 ,aDadosEmp[1]															,oFont12)
	oPrn:Say(0120,0070 ,Alltrim(aDadosEmp[2])													,oFont12)
	oPrn:Say(0130,0070 ,Alltrim(aDadosEmp[3]) + '-'+aDadosEmp[4]								,oFont12)
	oPrn:Say(0140,0070 ,Alltrim(aDadosEmp[6])													,oFont12)

	//	4ª Linha
	oPrn:Say(0160,0010 ,"Sacado:"																,oFont08)
	oPrn:Say(0160,0070 ,Alltrim(aDatSacado[1])													,oFont12)
	oPrn:Say(0170,0070 ,Alltrim(aDatSacado[3])													,oFont12)
	oPrn:Say(0180,0070 ,Alltrim(aDatSacado[4])+' - '+aDatSacado[5]+' - CEP: '+aDatSacado[6]		,oFont12)
	oPrn:Say(0190,0070 ,'CNPJ: '+Alltrim(aDatSacado[7])											,oFont12)

	oPrn:Say(0195,0500 ,"Autenticação Mecânica"													,oFont08)
	oPrn:Say(0200,0010, Replicate("- ", 130)													,oFont08)


	oPrn:SayBitmap(203,015,"bradesco.jpg",0105,0040)
	oPrn:Line(0210,0130,0240,0130)
	oPrn:Say(0235,0145,"237-2"																	,oFont16B)
	oPrn:Line(0210,0200,0240,0200)
	oPrn:Say(0235,0215,CB_RN_NN[2]																,oFont16B )	//Linha digitável

	oPrn:Line(0240,0008,0240,0580)
	oPrn:Say(250,0010 ,"Local de Pagamento" 													,oFont08)
	oPrn:Say(265,0030 ,"BANCO BRADESCO" 														,oFont12)
	oPrn:Say(275,0030 ,"PAGAR PREFERENCIALMENTE EM QUALQUER AGÊNCIA BRADESCO" 					,oFont12)
	oPrn:Line(0240,0470,0520,0470)
	oPrn:Say(250,0472 ,"Vencimento"			 													,oFont08)
	oPrn:Say(265,0520 ,aDadosTit[4]	 															,oFont12)

	oPrn:Line(0280,0008,280,0580)
	oPrn:Say(290,0010 ,"Cedente" 																,oFont08)
	oPrn:Say(305,0030 ,aDadosEmp[1]			 													,oFont12)
	oPrn:Say(290,0472 ,"Agência/Código Cedente"													,oFont08)
	oPrn:Say(305,0492 ,aDadosBanco[3]+"-"+aDadosBanco[9]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]	,oFont12)

	oPrn:Line(0310,0008,310,0580)
	oPrn:Say(0320,0010 ,"Data do Documento"														,oFont08)
	oPrn:Say(0335,0030 ,aDadosTit[2]															,oFont12)
	oPrn:Line(0310,0130,0370,0130)
	oPrn:Say(0320,0132 ,"Nº do Documento"														,oFont08)
	oPrn:Say(0335,0152 ,aDadosTit[7]+'-'+aDadosTit[1]											,oFont12)
	oPrn:Line(0310,0250,0370,0250)
	oPrn:Say(0320,0252 ,"Espécie Doc."															,oFont08)
	oPrn:Say(0335,0272 ,aDadosTit[8]															,oFont12)
	oPrn:Line(0310,0310,0340,0310)
	oPrn:Say(0320,0312 ,"Aceite"																,oFont08)
	oPrn:Line(0310,0370,0370,0370)
	oPrn:Say(0320,0372 ,"Data do Processamento"													,oFont08)
	oPrn:Say(0335,0392 ,aDadosTit[3]															,oFont12)
	oPrn:Say(0320,0472 ,"Nosso Número"															,oFont08)
	oPrn:Say(0335,0492 ,aDadosTit[6]															,oFont12)

	oPrn:Line(0340,0008,340,0580)
	oPrn:Say(0350,0010 ,"Uso do Banco"															,oFont08)
	oPrn:Line(0340,0070,0370,0070)
	oPrn:Say(0350,0072 ,"CIP"																	,oFont08)
	oPrn:Say(0350,0132 ,"Carteira"																,oFont08)
	oPrn:Say(0365,0152 ,"09"																	,oFont12)
	oPrn:Line(0340,0190,0370,0190)
	oPrn:Say(0350,0192 ,"Espécie Moeda"															,oFont08)
	oPrn:Say(0365,0212 ,"R$"																	,oFont12)
	oPrn:Say(0350,0252 ,"Quantidade"															,oFont08)
	oPrn:Say(0350,0372 ,"Valor"																	,oFont08)
	oPrn:Say(0350,0472 ,"(=)Valor do Documento"													,oFont08)
	oPrn:Say(0365,0492 ,Transform(aDadosTit[5], "@E 9,999,999,999.99")							,oFont12)

	oPrn:Line(0370,0008,370,0580)
	oPrn:Say(0380,0010 ,"Instruções (Todas informações deste BOLETO são de exclusiva responsabilidade do cedente)"	,oFont08)
	oPrn:Say(0395,0020 ,"Cedente: "																,oFont08)
	oPrn:Say(0395,0070 ,aDadosEmp[1]															,oFont12)
	oPrn:Say(0405,0070 ,Alltrim(aDadosEmp[2])													,oFont12)
	oPrn:Say(0415,0070 ,Alltrim(aDadosEmp[3]) + '-'+aDadosEmp[4]								,oFont12)
	oPrn:Say(0425,0070 ,Alltrim(aDadosEmp[6])													,oFont12)

	_cMulta := Alltrim(Transform(_nMulta, "@E 99.99"))
	_cMora  := Alltrim(Transform(_nMora, "@E 99.99"))

	_cVlMulta := Alltrim(Transform(aDadosTit[5] * (_nMulta / 100), "@E 9,999,999.99"))
	_cVlMora  := Alltrim(Transform((aDadosTit[5] * (_nMora / 100)) / 30, "@E 9,999,999.99"))

	oPrn:Say(0440,0030 ,"Cobrar Multa de "+_cMulta+"% após vencimento: "+_cVlMulta				,oFont10)
	oPrn:Say(0450,0030 ,"Acréscimo de juros de mora de "+_cMora+"%am: "+_cVlMora+" por dia de atraso, após o vencimento."			,oFont10)
	oPrn:Say(0470,0030 ,"Enviar a Cartório após 5 dias do Vencimento"							,oFont10)
	oPrn:Say(0480,0030 ,"Não nos responsabilizamos por crédito efetuado em nossa conta bancária sem a devida autorização da empresa,",oFont10)
	oPrn:Say(0490,0030 ,"por escrito em tempo hábil"											,oFont10)

	oPrn:Say(0380,0472 ,"(-)Desconto/Abatimento"												,oFont08)

	oPrn:Line(0400,0470,400,0580)
	oPrn:Say(0410,0472 ,"(+)Mora/Multa"															,oFont08)

	oPrn:Line(0430,0470,430,0580)
	oPrn:Say(0440,0472 ,"(-)Outras Deduções"													,oFont08)

	oPrn:Line(0460,0470,460,0580)
	oPrn:Say(0470,0472 ,"(+)Outros Acréscimos"													,oFont08)

	oPrn:Line(0490,0470,490,0580)
	oPrn:Say(0500,0472 ,"(=)Valor Cobrado"														,oFont08)

	oPrn:Line(0520,0010,520,0580)
	oPrn:Say(0530,0020 ,"Sacado"																,oFont08)
	oPrn:Say(0535,0070 ,Alltrim(aDatSacado[1])													,oFont12)
	oPrn:Say(0545,0070 ,Alltrim(aDatSacado[3])													,oFont12)
	oPrn:Say(0555,0070 ,Alltrim(aDatSacado[4])+' - '+aDatSacado[5]+' - CEP: '+aDatSacado[6]		,oFont12)
	oPrn:Say(0565,0070 ,'CNPJ: '+Alltrim(aDatSacado[7])											,oFont12)


	oPrn:Line(0580,0010,580,0580)
	oPrn:Say(0590,0420 ,"Autenticação Mecânica/Ficha de Compensação"							,oFont08)

	oPrn:FWMSBAR("INT25" /*cTypeBar*/,49/*nRow*/ , 05/*nCol*/	, _cBarra/*cCode*/,oPrn/*oPrint*/    ,.F./*lCheck*/,/*Color*/,.T./*lHorz*/,0.025/*nWidth*/,1.3/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/)

	SE1->(RecLock("SE1",.f.))
	SE1->E1_NUMBCO := aDadosTit[6]+ aDadosTit[11]
	SE1->E1_IDCNAB := Right(ALLTRIM(SE1->E1_NUMBCO),10)
	SE1->(MsUnlock())


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³Raimundo Pereira       ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CALCULO DO MODULO 10
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³Raimundo Pereira       ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CALCULO DO MODULO 11
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData,nBase)
	LOCAL Tamanho, Digito, Resto, Peso := 0

	Tamanho := Len(cdata)
	Digito := 0
	Peso := 1
	While Tamanho > 0
		Peso := Peso + 1
		Digito := Digito + (Val(SubStr(cData, Tamanho, 1)) * Peso)
		If Peso = nBase
			Peso := 1
		End
		Tamanho := Tamanho - 1
	End
	Resto  := Mod(Digito,11)
	Digito := 11 - Resto
	Do Case
		Case nBase == 7 // na base 7 antes de atribuir o digito, é verificado o resto da divisao antes de subtrai-lo de 11
		Do Case
			Case Resto == 10;    Digito := 'P'
			Case Resto == 11;    Digito := 0
			Case Resto ==  0;    Digito := 0
			OtherWise
			Digito := Resto
		Endcase
		Case nBase == 9 // na base 9 o resultado da subtração por 11 já pode ser o DV caso nao atenda a uma das condicoes abaixo
		If (Digito == 0 .Or. Digito == 1 .Or. Digito > 9 )
			Digito := 1
		End
	EndCase

Return(Digito)


//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela

//mj Static Function Ret_cBarra(_cBanco,_cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)

//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-_cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo da numeração do codigo de barras
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(_cBanco,_cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

	LOCAL bldocnufinal := strzero(val(cNroDoc),8)
	LOCAL blvalorfinal := strzero(int(nValor*100),10)
	LOCAL dvnn         := 0
	LOCAL dvcb         := 0
	LOCAL dv           := 0
	LOCAL NN           := ''
	LOCAL RN           := ''
	LOCAL CB           := ''
	LOCAL s            := ''
	LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
	LOCAL cAnoNN       := '11'
	LOCAL cCpoLivre    := AllTrim(_cAgencia)+_cCart+LEFT(cNossoNum,11)+cConta+'0'


	//-------- Definicao do NOSSO NUMERO / MODULO11 NA BASE 7 (BRADESCO)
	s    :=  _cCart + cNossoNum
	//dvnn := modulo11 na base 7 // carteira + sequencial de 11 digitos
	dvnn := modulo11(s,7)


	//	-------- Definicao do CODIGO DE BARRAS
	//s    := _cBanco + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator)) + cCpoLivre  // ALTERADO POR ALEXANDRO

	s    := _cBanco + _cfator + StrZero((nValor * 100),14-Len(_cfator)) + cCpoLivre

	dvcb := modulo11(s,9)
	//CB   := SubStr(s,1,4)+ AllTrim(Str(dvcb)) + SubStr(s,5,44)
	_cBarra :=  Subs(S,1,4)+ AllTrim(Str(dvcb)) + Substr(s,5,43)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCCCX		DDDDD.DDDDDY	EEEEE.EEEEEZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	  A	 = Codigo do banco na Camara de Compensacao
	//	  B  = Codigo da moeda, sempre 9
	//    C = As 5(cinco) primeiras posicoes do CAMPO LIVRE
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	s    := _cBanco + Left(cCpoLivre,5)
	dv   := modulo10(s)
	RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '


	// 	CAMPO 2:
	//	 D = Posicoes 6 a 15 do Campo Livre
	s    := SubStr(cCpoLivre, 6, 10)
	dv   := modulo10(s)
	RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

	// 	CAMPO 3:
	//	 E = Posicoes de 16 a 25 do Campo Livre
	s    := SubStr(cCpoLivre, 16, 10)
	dv   := modulo10(s)
	RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

	// 	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	RN   := RN + AllTrim(Str(dvcb)) + '  '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	//RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))  // ALTERADO POR ALEXANDRO
	RN   := RN + _cfator + StrZero((nValor * 100),14-Len(_cfator))

	Return({CB,RN,NN})

	********************************************************


Static Function fConta(wConta)
	Local wRet:=""
	For nx:=1 To Len(wConta)
		If !(SubStr(wConta,nx,1) $ '!@#$%¨&*()_-+=\/?:;.,<>|^~}]{[')
			wRet+=SubStr(wConta,nx,1)
		Endif
	Next
	wRet:=SubStr(wRet,1,Len(wRet)-1) //Retira o Digito Verificador
Return( StrZero(Val(wRet),7) )



Static FUNCTION Digito_BR(WNUMERO)

	Local _num1 := WNUMERO
	Local _num  := "09"+ WNUMERO
	NCDV := 1
	DO WHILE NCDV <= 13

		DO CASE

			CASE NCDV == 1
			CF1 := VAL(SUBS(_num,NCDV,1))*2
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 2
			CF2 := VAL(SUBS(_num,NCDV,1))*7
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 3
			CF3 := VAL(SUBS(_num,NCDV,1))*6
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 4
			CF4 := VAL(SUBS(_num,NCDV,1))*5
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 5
			CF5 := VAL(SUBS(_num,NCDV,1))*4
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 6
			CF6 := VAL(SUBS(_num,NCDV,1))*3
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 7
			CF7 := VAL(SUBS(_num,NCDV,1))*2
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 8
			CF8 := VAL(SUBS(_num,NCDV,1))*7
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 9
			CF9 := VAL(SUBS(_num,NCDV,1))*6
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 10
			CF10:= VAL(SUBS(_num,NCDV,1))*5
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 11
			CF11:= VAL(SUBS(_num,NCDV,1))*4
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 12
			CF12:= VAL(SUBS(_num,NCDV,1))*3
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 13
			CF13:= VAL(SUBS(_num,NCDV,1))*2
			NCDV := NCDV+1
			LOOP

		ENDCASE

	ENDDO
	CF := CF1+CF2+CF3+CF4+CF5+CF6+CF7+CF8+CF9+CF10+CF11+CF12+CF13
	A := CF % 11
	RESTO := 11 - A
	IF RESTO == 10
		DV := 'P'
	ELSEIF RESTO == 11
		DV := '0'
	ELSE
		DV := STR(RESTO,1,0)
	ENDIF

Return(DV)



Static Function CheckNumero(_cBcoBoleto)

	_cBcoBoleto := IIF( _cBcoBoleto==Nil,"237",_cBcoBoleto)

	wNumero := GetMv("PXH_BOL"+_cBcoBoleto)
	wNumero := IIF( Val(wNumero) > 0, wNumero, PadL("",11,"0") )
	wNumero := Soma1(wNumero)
	PutMv("PXH_BOL"+_cBcoBoleto,wNumero) //GRAVA A SEQUENCIA DO BOLETO

Return(wNumero)



//Envia E-mail
Static Function PXH59B(_cTo,_cCc,_cSerie,_cNF)

	_cAnexo := "\WORKFLOW\EMP"+Alltrim(SM0->M0_CODIGO)+"\RELATORIOS\"+_cTit+".PDF"

	ConOut("Enviando E-Mail de Fatura/Boleto(s) - PXH059")

	Conout(_cAnexo)


	oProcess := TWFProcess():New( "PXH059", "Faturamento" )
	oProcess:NewTask( "PXH059", "\WORKFLOW\EMP"+Alltrim(SM0->M0_CODIGO)+"\PXH059.htm" )
	oHTML := oProcess:oHTML

	oProcess:fDesc := "Fatura/Boleto(s)"

	_cSubject := "NF "+_cSerie+'-'+_cNF//+dToc(dDataBase)+" Hour: "+Substr(Time(),1,5)

	oHtml:ValByName("nf"  		, _cSerie+'-'+_cNF  )
	oHtml:ValByName("emissao"  	, _cEmissao   )

	oHtml:ValByName("empresa"  	, Alltrim(SM0->M0_NOMECOM)   )
	oHtml:ValByName("enderec"  	, Alltrim(SM0->M0_ENDCOB)+', '+Alltrim(SM0->M0_BAIRCOB))
	oHtml:ValByName("complem"  	, Transform(Alltrim(SM0->M0_CEPCOB), '@R 99.999-999')+' '+ Alltrim(SM0->M0_CIDCOB)+' '+Alltrim(SM0->M0_ESTCOB))

	_cBcc := ""

	oProcess:cSubject := _cSubject

	oProcess:AttachFile(_cAnexo)

	oProcess:cTo  := _cTo
	oProcess:cCC  := _cCC
	oProcess:cBCC := _cBcc

	oProcess:Start()

	oProcess:Finish()

Return



//Atualiza SX1 (Perguntas)
Static Function AtuSx1(cPerg)

	Local aHelp := {}
	cPerg       := "PXH059"

	//    	   Grupo/Ordem/Pergunta     	         /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01       /defspa1/defeng1/Cnt01/Var02/Def02		/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Série        ?",""     ,""       ,"mv_ch1","C" ,03     ,0      ,0     ,"G",""        ,"MV_PAR01",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Nota Fiscal  ?",""     ,""       ,"mv_ch2","C" ,09     ,0      ,0     ,"G",""        ,"MV_PAR02",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SF2")
	//	U_CRIASX1(cPerg,"11","Tipo		           ?",""       ,""      ,"mv_chb","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR11","Analitico" ,""     ,""     ,""   ,""   ,"Sintético",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return