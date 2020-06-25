#include "Totvs.ch"
#include "FWPrintSetup.ch"

/*
Programa 	: PXH073
Autor 		: Fabiano da Silva
Data		: 27/05/15
Uso 		: SIGAFAT - FAT
Descrição 	: Impressão de Orçamento
*/

USER FUNCTION PXH073()
	
	LOCAL oDlg := NIL
	
	Private aRadio  	:= {}
	Private nRadio  	:= 1
	Private oRadio  	:= Nil
	Private _oPrinter   := NIL
	Private _oFont1, _oFont2, _oFont3, _oFont4
	
	Private _cPXH73001 := _cPXH73002 := _cPXH73003 := _cPXH73004 := _cPXH73005 := _cPXH73006 := _cPXH73007 := _cPXH73008 := _cPXH73009 := _cPXH73010 := ""
	Private _cPXH73011 := _cPXH73012 := _cPXH73013 := _cPXH73014 := _cPXH73015 := _cPXH73016 := _cPXH73017 := _cPXH73018 := _cPXH73019 := _cPXH73020 := ""
	Private _cPXH73021 := _cPXH73022 := _cPXH73023 := _cPXH73024 := _cPXH73025 := _cPXH73026 := _cPXH73027 := _cPXH73028 := _cPXH73029 := _cPXH73030 := ""
	Private _cPXH73031 := _cPXH73032 := _cPXH73033 := _cPXH73034 := _cPXH73035 := _cPXH73036 := _cPXH73037 := _cPXH73038 := _cPXH73039 := _cPXH73040 := ""
	Private _cPXH73041 := _cPXH73042 := _cPXH73043 := _cPXH73044 := _cPXH73045 := _cPXH73046 := _cPXH73047 := _cPXH73048 := _cPXH73049 := ""
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 110,250 TITLE "Orçamento" OF oDlg PIXEL
	
	@ 007,017 SAY "Deseja imprimir o Orçamento: "+SCJ->CJ_NUM OF oDlg PIXEL Size 150,010
	
	@ 018,017 RADIO oRadio VAR nRadio ITEMS "Português","Inglês" SIZE 36,10 PIXEL OF oDlg
	
	@ 40,020 BUTTON "OK" 		 SIZE 036,012 ACTION (PXH73A(),oDlg:End()) 	OF oDlg PIXEL
	@ 40,080 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return(Nil)





Static Function PXH73A()
	
	Local cLogo      	:= FisxLogo("1")
	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	Local _oPrinter
	Local _cDir 		:= "C:\TOTVS\"
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf
	
	PXH73DESC()
	
	_oFont1 	:= TFont():New('Arial',,-12,,.T.,,,,,.T.,.T.)
	_oFont2 	:= TFont():New('Arial',,-09,,.T.,,,,,.F.,.F.)
	_oFont3 	:= TFont():New('Arial',,-10,,.F.,,,,,.F.,.F.)
	_oFont4 	:= TFont():New('Arial',,-10,,.T.,,,,,.T.,.F.)
	
	cTitulo := "Orçamento_"+SCJ->CJ_NUM
	
	_oPrinter := FWMSPrinter():New(cTitulo, 6, lAdjustToLegacy,_cDir, lDisableSetup,    , , ,    , , .F., )
	
	_oPrinter:StartPage()
	
	oBrush := TBrush():New( , CLR_HGRAY)
	
	_oPrinter:SetPortrait()
	
	_oPrinter:SayBitmap(025,018,cLogo,65,18)
	_oPrinter:line(010,095,060,095)
	
	_oPrinter:line(010,010,010,570)
	_oPrinter:line(010,010,060,010)
	_oPrinter:Say(037,230,_cPXH73001,_oFont1) //"PROPOSTA COMERCIAL"
	_oPrinter:line(010,515,060,515)
	_oPrinter:Say(025,530,"PASP",_oFont3)
	_oPrinter:line(030,515,030,570)
	_oPrinter:Say(042,530,_cPXH73047,_oFont3) //"Folha"
	_oPrinter:Say(052,532,"01/01",_oFont3) //"Folha"
	_oPrinter:line(010,570,060,570)
	_oPrinter:line(060,010,060,570)
	
	//	_oPrinter:FillRect( {0082,468,0092,495}, oBrush)
	
	_oPrinter:FillRect( {082,011,0092,070}, oBrush)
	_oPrinter:Say(090,015,_cPXH73046	,_oFont2) //"PROPOSTA Nº"
	_oPrinter:Say(090,080,SCJ->CJ_NUM	,_oFont2)
	
	_oPrinter:SayBitmap(070,250,"\SYSTEM\ISO_9001.BMP",70,35)
	
	_oPrinter:FillRect( {0082,468,0092,495}, oBrush)
	_oPrinter:Say(090,470,_cPXH73002	,_oFont2) //"DATA"
	
	If nRadio = 1
		_demis := DTOC(SCJ->CJ_EMISSAO)
	Else
		_dEmis := Strzero(Month(SCJ->CJ_EMISSAO),2)+"/"+Strzero(Day(SCJ->CJ_EMISSAO),2)+"/"+Str(Year(SCJ->CJ_EMISSAO),4)
	Endif
	
	_oPrinter:Say(090,500,_dEmis	,_oFont2)
	
	_oPrinter:FillRect( {0112,011,0122,569}, oBrush)
	_oPrinter:Say(120,250,"POLIMIX AMBIENTAL"	,_oFont2)
	
	_oPrinter:Say(135,015,_cPXH73003		,_oFont3) //"Somos uma empresa brasileira que recicla pneus inservíveis para produção de Óleo Combustível e Negro de Carbono Ecológico, localizada em Santana do "
	_oPrinter:Say(145,015,_cPXH73004		,_oFont3) //"Parnaíba - SP. Estamos preparados para atender clientes de pequeno, médio e grande porte, oferecendo sempre uma solução inteligente, econômica e "
	_oPrinter:Say(155,015,_cPXH73005		,_oFont3) //"ambientalmente correta para quem precisa reduzir custos e manter a qualidade do produto. Podemos contribuir de forma positiva com produtos que atendem "
	_oPrinter:Say(165,015,_cPXH73006		,_oFont3) //"as normas internacionais."
	_oPrinter:Say(175,015,_cPXH73048		,_oFont3) //"A Polimix Ambiental fornece suporte técnico especializado a todos os seus clientes e todos os seus produtos acompanham laudo de qualidade."
	
	_oPrinter:FillRect( {0187,011,0197,569}, oBrush)
	_oPrinter:Say(195,250,_cPXH73007		,_oFont2) //"DADOS DO CLIENTE"
	
	_cRazao := _cContato := _cEnd := _cBairro := _cCidade := _cUF := _cCEP := _cCNPJ := _cIE := _cIM := ''
	_nAliq  := 0
	If !Empty(SCJ->CJ_PROSPE)
		SUS->(dbSetOrder(1))
		If SUS->(msSeek(xFilial('SUS')+SCJ->CJ_PROSPE+SCJ->CJ_LOJPRO))
			_cRazao 	:= Alltrim(SUS->US_NOME)
			_cContato 	:= Alltrim(SUS->US_CONTATO)
			_cEnd 		:= Alltrim(SUS->US_END)
			_cBairro 	:= Alltrim(SUS->US_BAIRRO)
			_cCidade 	:= Alltrim(SUS->US_MUN)
			_cUF 		:= Alltrim(SUS->US_EST)
			_cCEP 		:= Transform(Alltrim(SUS->US_CEP), "@R 99999-999")
			_cCNPJ 		:= Transform(Alltrim(SUS->US_CGC), "@R 99.999.999/9999-99")
			_cIE 		:= Alltrim(SUS->US_INSCR)
			_cIM 		:= Alltrim(SUS->US_INSCRM)
		Endif
	Else
		SA1->(dbSetOrder(1))
		If SA1->(msSeek(xFilial('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
			_cRazao 	:= Alltrim(SA1->A1_NOME)
			_cContato 	:= Alltrim(SA1->A1_CONTATO)
			_cEnd 		:= Alltrim(SA1->A1_END)
			_cBairro 	:= Alltrim(SA1->A1_BAIRRO)
			_cCidade 	:= Alltrim(SA1->A1_MUN)
			//			If !Empty(SA1->A1_YUFENT)
			//				_cUF 		:= Alltrim(SA1->A1_YUFENT)
			//			Else
			_cUF 		:= Alltrim(SA1->A1_EST)
			//			Endif
			_cCEP 		:= Transform(Alltrim(SA1->A1_CEP), "@R 99999-999")
			_cCNPJ 		:= Transform(Alltrim(SA1->A1_CGC), "@R 99.999.999/9999-99")
			_cIE 		:= Alltrim(SA1->A1_INSCR)
			_cIM 		:= Alltrim(SA1->A1_INSCRM)
			
			//VERIFICA A ALIQUOTA DE ICMS DO CLIENTE
			cEstf  := SA1->A1_EST
			_nAliq := AliqIcms(	"N",; // Tipo de Operacao
								"S",; // Tipo de Nota ('E'ntrada/'S'aida)
								"C",; // Tipo do Cliente ou Fornecedor
								"I",; // Tipo da Aliquota ("S"olidario/"I"cms)
								'')   // Numero do Registro caso seja devolucao
			
		Endif
	Endif
	
	_oPrinter:Say(210,015,_cPXH73008		,_oFont3) //"Razão Social:"
	_oPrinter:Say(210,080,_cRazao			,_oFont3)
	_oPrinter:Say(225,015,_cPXH73009		,_oFont3) //"Contato:"
	_oPrinter:Say(225,080,_cContato			,_oFont3)
	_oPrinter:Say(240,015,_cPXH73010		,_oFont3) //"Endereço:"
	_oPrinter:Say(240,080,_cEnd				,_oFont3)
	_oPrinter:Say(240,400,_cPXH73011		,_oFont3) //"Bairro:"
	_oPrinter:Say(240,455,_cBairro			,_oFont3)
	_oPrinter:Say(255,015,_cPXH73012		,_oFont3) //"Cidade:"
	_oPrinter:Say(255,080,_cCidade			,_oFont3)
	_oPrinter:Say(255,210,_cPXH73013		,_oFont3) //"UF:"
	_oPrinter:Say(255,240,_cUF				,_oFont3)
	_oPrinter:Say(255,400,_cPXH73014		,_oFont3) //"CEP:"
	_oPrinter:Say(255,455,_cCEP				,_oFont3)
	_oPrinter:Say(270,015,_cPXH73015		,_oFont3) //"CNPJ:"
	_oPrinter:Say(270,080,_cCNPJ			,_oFont3)
	_oPrinter:Say(270,210,_cPXH73016		,_oFont3) //"IE:"
	If nRadio = 1
		_oPrinter:Say(270,240,_cIE				,_oFont3)
	ElseIf nRadio = 2
		_oPrinter:Say(270,270,_cIE				,_oFont3)
	Endif
	_oPrinter:Say(270,400,_cPXH73017		,_oFont3) //"IM:"
	_oPrinter:Say(270,450,_cIM				,_oFont3)
	
	_oPrinter:Say(290,015,_cPXH73018		,_oFont3) //"Atendendo à sua consulta, apresentamos esta proposta para apreciação de V.Sas.;"
	
	_oPrinter:FillRect( {0302,011,0327,569}, oBrush)
	_oPrinter:SayAlign(303,250,_cPXH73019	,_oFont2,200,,,0,1) //"ITENS SOLICITADOS"
	_oPrinter:SayAlign(315,015,_cPXH73020	,_oFont2,055,,,0,1) //"ITEM"
	_oPrinter:SayAlign(315,070,_cPXH73021	,_oFont2,180,,,0,1) //"DESCRIÇÃO"
	_oPrinter:SayAlign(315,260,_cPXH73022	,_oFont2,020,,,0,1) //"UM"
	_oPrinter:SayAlign(315,280,_cPXH73023	,_oFont2,060,,,1,1) //"QUANTIDADE"
	_oPrinter:SayAlign(315,340,_cPXH73024	,_oFont2,060,,,1,1) //"VALOR UNIT"
	_oPrinter:SayAlign(315,400,_cPXH73025	,_oFont2,060,,,1,1) //"VALOR TOTAL"
	_oPrinter:SayAlign(315,470,_cPXH73026	,_oFont2,100,,,0,1) //"OBSERVAÇÕES"
	
	SCK->(dbSetOrder(1))
	If SCK->(MsSeek(xFilial("SCK")+SCJ->CJ_NUM))
		
		_cKey   := SCJ->CJ_FILIAL+SCJ->CJ_NUM
		_nLin   := 330
		_nTotal := 0
		While !SCK->(EOF()) .And. _cKey == SCK->CK_FILIAL+SCK->CK_NUM
			
			If _nLin < 465
				
				_cDescProd := SCK->CK_DESCRI
				If nRadio = 2
					SB5->(dbSetOrder(1))
					If SB5->(msSeek(xFilial('SB5')+SCK->CK_PRODUTO))
						_cDescProd := SB5->B5_CEME
					Endif
				Endif
				
				_oPrinter:SayAlign(_nLin,015,SCK->CK_PRODUTO									,_oFont3,055,,,0,1)
				_oPrinter:SayAlign(_nLin,070,_cDescProd											,_oFont3,180,,,0,1)
				_oPrinter:SayAlign(_nLin,260,SCK->CK_UM											,_oFont3,020,,,0,1)
				_oPrinter:SayAlign(_nLin,280,Transform(SCK->CK_QTDVEN	, "@E 9,999,999.99")	,_oFont3,060,,,1,1)
				_oPrinter:SayAlign(_nLin,340,Transform(SCK->CK_PRCVEN	, "@E 9,999,999.99")	,_oFont3,060,,,1,1)
				_oPrinter:SayAlign(_nLin,400,Transform(SCK->CK_VALOR	, "@E 9,999,999.99")	,_oFont3,060,,,1,1)
				_oPrinter:SayAlign(_nLin,470,SCK->CK_OBS										,_oFont3,100,,,0,1)
				
			Endif
			
			_nTotal += SCK->CK_VALOR
			_nLin += 15
			
			SCK->(dbSkip())
		EndDo
		
		
		
		//_nAliq := Val(Subs(GETMV("MV_ESTICM"),AT(_cUF,GETMV("MV_ESTICM"))+2,2))
		
		
		If _cUF != 'SP'
			_oPrinter:SayAlign(440,015,_cPXH73049+' ('+_cUF+'):'						,_oFont2,120,,,1,1) //"IMPOSTOS INCLUSOS"
			_oPrinter:SayAlign(440,100,"ICMS:"											,_oFont3,060,,,1,1)
			_oPrinter:SayAlign(440,128,Transform(_nAliq,"@e 99.99")+'%'					,_oFont3,060,,,1,1)
		Else
		
			_oPrinter:SayAlign(455,015,_cPXH73049+' ('+_cUF+'):'						,_oFont2,120,,,1,1) //"IMPOSTOS INCLUSOS"
		Endif
		_oPrinter:SayAlign(455,100,"PIS:"											,_oFont3,060,,,1,1)
		_oPrinter:SayAlign(455,128,"1,65%"											,_oFont3,060,,,1,1)
		_oPrinter:SayAlign(470,100,"COFINS:"										,_oFont3,060,,,1,1)
		_oPrinter:SayAlign(470,128,"7,60%"											,_oFont3,060,,,1,1)
		
		_oPrinter:SayAlign(470,350,_cPXH73027										,_oFont2,060,,,1,1) //"VALOR TOTAL:"
		_oPrinter:SayAlign(470,400,Transform(_nTotal		, "@E 9,999,999.99")	,_oFont2,060,,,1,1)
		
	Endif
	
	_oPrinter:FillRect( {0487,011,0497,569}, oBrush)
	_oPrinter:Say(495,230,_cPXH73028				,_oFont2) //"OBSERVAÇÕES DA PROPOSTA"
	
	SE4->(dbSetOrder(1))
	SE4->(msSeek(xFilial("SE4")+SCJ->CJ_CONDPAG))
	
	_cTpFrete := If(SCJ->CJ_YTPFRET = 'C',"CIF",If(SCJ->CJ_YTPFRET = 'F' , 'FOB',''))
	_oPrinter:Say(510,015,_cPXH73029				,_oFont3) //"PRAZO DE ENTREGA:"
	_oPrinter:Say(510,130,_cPXH73030				,_oFont3) //"7 DDL"
	_oPrinter:Say(510,330,_cPXH73031				,_oFont3) //"FRETE:"
	_oPrinter:Say(510,500,_cTpFrete					,_oFont3)
	//	_oPrinter:Say(510,500,Transform(SCJ->CJ_FRETE, "@E 9,999,999.99"),_oFont3)
	_oPrinter:Say(525,015,_cPXH73032				,_oFont3) //"FORMA DE PAGAMENTO:"
	
	_cDesCPgto :=  Alltrim(SE4->E4_DESCRI)
	If nRadio = 2 .And. !Empty(SE4->E4_YDESCIN)
		_cDesCPgto := Alltrim(SE4->E4_YDESCIN)
	Endif
	
	_oPrinter:Say(525,130,_cDesCPgto				,_oFont3)
	_oPrinter:Say(525,330,_cPXH73033				,_oFont3) //"VALIDADE DA PROPOSTA:"
	
	/*
	If nRadio = 1
		_dValid := DTOC(SCJ->CJ_VALIDA)
	Else
		_dValid := Strzero(Month(SCJ->CJ_VALIDA),2)+"/"+Strzero(Day(SCJ->CJ_VALIDA),2)+"/"+Strzero(Year(SCJ->CJ_VALIDA),4)
	Endif
	
	_oPrinter:Say(525,500,_dValid		,_oFont3)
	*/
	_oPrinter:Say(525,500,"30 DIAS"			,_oFont3)
	
	_oPrinter:FillRect( {0532,011,0542,569}, oBrush)
	_oPrinter:Say(540,190,_cPXH73034	,_oFont2) //"RESPONSÁVEL PELA ELABORAÇÃO DA PROPOSTA"
	
	_cNome   := _cCargo := _cMail  := _cFone  := ''
	_aInfUsr := {}
	
	PswOrder(1)
	If PswSeek( SCJ->CJ_USUARIO, .T. )
		_aInfUsr := PswRet() // Retorna vetor com informações do usuário
		_cNome   := Alltrim(_aInfUsr[1][4])
		_cCargo  := Alltrim(_aInfUsr[1][13])
		_cMail   := Alltrim(_aInfUsr[1][14])
		_cFone   := Alltrim(SM0->M0_TEL)
	EndIf
	
	_oPrinter:Say(555,015,_cPXH73035		,_oFont3) //"NOME:"
	_oPrinter:Say(555,080,_cNome			,_oFont3)
	_oPrinter:Say(555,330,_cPXH73038		,_oFont3) //"TELEFONE:"
	_oPrinter:Say(555,400,_cFone			,_oFont3)
	//	_oPrinter:Say(555,330,_cPXH73036		,_oFont3) //"CARGO:"
	//	_oPrinter:Say(555,400,_cCargo			,_oFont3)
	_oPrinter:Say(570,015,_cPXH73037		,_oFont3) //"E-MAIL:"
	_oPrinter:Say(570,080,_cMail			,_oFont4,,CLR_HBLUE)
	
	_oPrinter:FillRect( {0577,011,0587,569}, oBrush)
	_oPrinter:Say(585,250,_cPXH73039		,_oFont2) //"ACEITE DO CLIENTE"
	
	_oPrinter:Say(630,015,"___________________",_oFont1)
	_oPrinter:Say(630,155,"___________________",_oFont1)
	_oPrinter:Say(630,305,"___________________",_oFont1)
	_oPrinter:Say(630,455,"___________________",_oFont1)
	
	_oPrinter:Say(645,015,_cPXH73040			,_oFont3) //"NOME DO RESPONSÁVEL"
	_oPrinter:Say(645,190,_cPXH73041			,_oFont3) //"CARGO"
	_oPrinter:Say(645,340,_cPXH73042			,_oFont3) //"DATA"
	_oPrinter:Say(645,480,_cPXH73043			,_oFont3) //"ASSINATURA"
	
	_oPrinter:Say(690,015,_cPXH73044			,_oFont2) //"OBS: CASO O ACEITE DA PROPOSTA SEJA DADO VIA E-MAIL, DESCREVER NO CAMPO ASSINATURA VIA E-MAIL"
	_oPrinter:Say(700,015,_cPXH73045			,_oFont2) //
	
	_oPrinter:EndPage()
	_oPrinter:Preview()
	
Return()



Static Function PXH73Desc()
	
	If nRadio = 1
		_cPXH73001 := "PROPOSTA COMERCIAL"
		_cPXH73002 := "DATA"
		/*
		_cPXH73003 := "Somos uma empresa brasileira no ramo de Negro de Carbono situada em Santana de Parnaíba - SP, estamos preparados para atender clientes de pequeno,"
		_cPXH73004 := "médio e grande porte, oferecendo sempre uma solução inteligente e econômica para quem precisa reduzir custos e manter a qualidade do produto."
		_cPXH73005 := "Podemos contribuir de forma positiva com produtos produzidos que atendem as normas internacionais. Nossos processos de produção seguem um"
		_cPXH73006 := "rígido controle de qualidade oferecendo suporte técnico, bem como laudos que caracterizam o produto comercializado."
		*/
		_cPXH73003 := "Somos uma empresa brasileira que recicla pneus inservíveis para produção de Óleo Combustível e Negro de Carbono Ecológico, localizada em Santana do "
		_cPXH73004 := "Parnaíba - SP. Estamos preparados para atender clientes de pequeno, médio e grande porte, oferecendo sempre uma solução inteligente, econômica e "
		_cPXH73005 := "ambientalmente correta para quem precisa reduzir custos e manter a qualidade do produto. Podemos contribuir de forma positiva com produtos que atendem "
		_cPXH73006 := "as normas internacionais."
		_cPXH73048 := "A Polimix Ambiental fornece suporte técnico especializado a todos os seus clientes e todos os seus produtos acompanham laudo de qualidade."
		
		_cPXH73007 := "DADOS DO CLIENTE"
		_cPXH73008 := "Razão Social:"
		_cPXH73009 := "Contato:"
		_cPXH73010 := "Endereço:"
		_cPXH73011 := "Bairro:"
		_cPXH73012 := "Cidade:"
		_cPXH73013 := "UF:"
		_cPXH73014 := "CEP:"
		_cPXH73015 := "CNPJ:"
		_cPXH73016 := "IE:"
		_cPXH73017 := "IM:"
		_cPXH73018 := "Atendendo à sua consulta, apresentamos esta proposta para apreciação de V.Sas.;"
		_cPXH73019 := "ITENS SOLICITADOS"
		_cPXH73020 := "ITEM"
		_cPXH73021 := "DESCRIÇÃO"
		_cPXH73022 := "UM"
		_cPXH73023 := "QUANT."
		_cPXH73024 := "VALOR UNIT"
		_cPXH73025 := "VALOR TOTAL"
		_cPXH73026 := "OBSERVAÇÕES"
		_cPXH73027 := "VALOR TOTAL:"
		_cPXH73028 := "OBSERVAÇÕES DA PROPOSTA"
		_cPXH73029 := "PRAZO DE ENTREGA:"
		_cPXH73030 := "7 DDL"
		_cPXH73031 := "FRETE:"
		_cPXH73032 := "FORMA DE PAGAMENTO:"
		_cPXH73033 := "VALIDADE DA PROPOSTA:"
		_cPXH73034 := "RESPONSÁVEL PELA ELABORAÇÃO DA PROPOSTA"
		_cPXH73035 := "NOME:"
		_cPXH73036 := "CARGO:"
		_cPXH73037 := "E-MAIL:"
		_cPXH73038 := "TELEFONE:"
		_cPXH73039 := "ACEITE DO CLIENTE"
		_cPXH73040 := "NOME DO RESPONSÁVEL"
		_cPXH73041 := "CARGO"
		_cPXH73042 := "DATA"
		_cPXH73043 := "ASSINATURA"
		_cPXH73044 := "OBS: CASO O ACEITE DA PROPOSTA SEJA DADO VIA E-MAIL, DESCREVER NO CAMPO ASSINATURA VIA E-MAIL"
		_cPXH73046 := "PROPOSTA Nº"
		_cPXH73047 := "Folha:"
		_cPXH73049 := "IMPOSTOS INCLUSOS"
		
	ElseIf nRadio = 2
		_cPXH73001 := "COMMERCIAL PROPOSAL"
		_cPXH73002 := "DATE"
		_cPXH73003 := "We are a Brasilian Company in the Carbon Black Industry located in Santana de Parnaiba in São Paulo state, we are prepared to attend the small,"
		_cPXH73004 := "medium and large-sized companies, always offering a smart and economic solution to reduce cost for our customer with quality."
		_cPXH73005 := "We can contribute in a positive way with products that meet the international standarts. All our production process has a strict quality"
		_cPXH73006 := "control offering a excelent technical support."
		_cPXH73007 := "CLIENT DATA"
		_cPXH73008 := "Company Name:"
		_cPXH73009 := "Contact:"
		_cPXH73010 := "Adress:"
		_cPXH73011 := "Neighborhood:"
		_cPXH73012 := "City:"
		_cPXH73013 := "FU:"
		_cPXH73014 := "Zip Code:"
		_cPXH73015 := "CNPJ:"
		_cPXH73016 := "State Taxpayer:"
		_cPXH73018 := "Serving your query, we present this commercial proposal and, eventually, supply of:"
		_cPXH73019 := "REQUESTED ITEMS"
		_cPXH73020 := "ITEM"
		_cPXH73021 := "DESCRIPTION"
		_cPXH73022 := "UNIT"
		_cPXH73023 := "QUANTITY"
		_cPXH73024 := "UNIT PRICE"
		_cPXH73025 := "TOTAL PRICE"
		_cPXH73026 := "OBSERVATIONS"
		_cPXH73027 := "Total Price:"
		_cPXH73028 := "OBSERVATIONS"
		_cPXH73029 := "DEADLINE:"
		_cPXH73030 := "5 DAYS AFTER APPROVAL"
		_cPXH73031 := "SHIPPING:"
		_cPXH73032 := "PAYMENT FORM:"
		_cPXH73033 := "BID VALIDITY:"
		_cPXH73034 := "RESPONSIBLE FOR BID ELABORATION"
		_cPXH73035 := "NAME:"
		_cPXH73036 := "POSITION:"
		_cPXH73037 := "E-MAIL:"
		_cPXH73038 := "PHONE:"
		_cPXH73039 := "CUSTOMER ACCEPTANCE"
		_cPXH73040 := "RESPONSIBLE NAME"
		_cPXH73041 := "POSITION"
		_cPXH73042 := "DATE"
		_cPXH73043 := "ASSIGNATURE"
		_cPXH73044 := '¹: BRASILIAN REGISTRATION OF CORPORATE TAXPAYERS'
		_cPXH73045 := 'OBS: IF THE CUSTOMER ACCEPTS THE PROPOSAL BY MAIL, DESCRIBE IN THE FIELD ASSIGNATURE "BY E-MAIL"'
		_cPXH73047 := "Page"
	Endif
	
Return(Nil)
