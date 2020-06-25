#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa 	: PXH037
Autor 		: Fabiano da Silva
Data 		: 05/11/13
Descrição	: Plano de Ação (Mapinha Maney)
*/

User Function PXH037()

	Private oDlgPrinc, oDlgSec
	Private aCoors   := FWGetDialogSize( oMainWnd )

	Private _oMes
	Private _aMes  := {'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'}
	Private _cMes  := Left(Mesextenso(Month(dDatabase)),3)
	Private _cAno  := Strzero(Year(dDatabase),4)
	Private _lVld  := .F.
 	
	Define MsDialog oDlgSec Title 'Plano de ação' From 0,0 To 150, 250 Pixel
	
	@ 10,10 SAY 'Selecione abaixo o Mês e o Ano de Referência:' of oDlgSec Pixel
	
	@ 25,010 SAY "Mês: " 	Size 50,010 OF oDlgSec PIXEL
	@ 25,060 MsCOMBOBOX _oMes 	VAR _cMes ITEMS _aMes Size 30,04  PIXEL OF oDlgSec
	
	@ 40,010 SAY "Ano: " 	Size 50,010 OF oDlgSec PIXEL
	@ 40,060 MsGet _cAno   	Size 30,04  PIXEL OF oDlgSec

	DEFINE SBUTTON FROM 60,010 TYPE 2 ACTION (nOpc := 2,oDlgSec:End()) ENABLE Of oDlgSec
	DEFINE SBUTTON FROM 60,040 TYPE 1 ACTION (nOpc := 1,oDlgSec:End()) ENABLE Of oDlgSec
	
	ACTIVATE MSDIALOG oDlgSec CENTERED
	
	If nOpc = 1
		_nPosMes := aScan(_aMes,{|x| x == _cMes})
	
		Private _cRef  := _cAno+Strzero(_nPosMes,2)

		PXH37A()
	Endif
	
Return


Static Function PXH37A()

	Private _cFilial  	:= Alltrim(SM0->M0_NOME)
	Private _cLider		:= Space(20)
	Private _cSemest	:= If(Upper(Alltrim(_cMes)) $ ('JAN|FEV|MAR|ABR|MAI|JUN'), '1ºSem.', '2ºSem.')
	Private _nProd 	:= _nPMed 	:= _nImp 	:= _nPLiq := 0
	Private _oProd 	:= _oPMed	:= _oImp 	:= _oPLiq := Nil
	Private _nProdR	:= _nPMedR	:= _nImpR	:= _nPLiqR:= 0
	Private _oProdR	:= _oPMedR	:= _oImpR	:= _oPLiqR:= Nil
	Private _nServ	:= _nCOpr	:= _nCPes	:= _nAvia := 0
	Private _oServ	:= _oCOpr	:= _oCPes 	:= _oAvia := Nil
	Private _nServR	:= _nCOprR	:= _nCPesR	:= _nAviaR:= 0
	Private _oServR	:= _oCOprR	:= _oCPesR	:= _oAviaR:= Nil
	Private _nRLiq	:= _nDIl 	:= _nDIg  	:= _nDIMl := 0
	Private _oRLiq	:= _oDIl 	:= _oDIg  	:= _oDIMl := Nil
	Private _nRLiqR	:= _nDIlR	:= _nDIgR 	:= _nDIMlR:= 0
	Private _oRLiqR	:= _oDIlR	:= _oDIgR 	:= _oDIMlR:= Nil
	Private _nInte	:= _nPInt 	:= _nEqui 	:= _nPEqu := 0
	Private _oInte	:= _oPInt 	:= _oEqui 	:= _oPEqu := Nil
	Private _nInteR	:= _nPIntR	:= _nEquiR	:= _nPEquR:= 0
	Private _oInteR	:= _oPIntR	:= _oEquiR	:= _oPEquR:= Nil
	Private _nT80	:= _nPMPg 	:= _nRsFin 	:= 0
	Private _oT80	:= _oPMPg 	:= _oRsFin 	:= 0
	Private _nT80R	:= _nPMPgR	:= _nRsFinR	:= 0
	Private _oT80R	:= _oPMPgR	:= _oRsFinR	:= 0
	Private _nTInte	:= _nTotGer := _nTot17 	:= 0
	Private _nEncFol:= 70
	Private _oInte	:= _oEncFol := _oTotGer := _oTot17 := Nil
	Private _nTotQt	:= _nTotAlu := _nTotTot := 0
	Private _oTotQt, _oTotAlu, _oTotTot

	Private _aHeaPes := {}
	Private _aColPes := {}

	Private _aHeaEqu := {}
	Private _aColEqu := {}

	Private _cAcoes  := Space(300)
	Private _oAcoes

	Private _aHeaCus1 := {}
	Private _aColCus1 := {}
	Private _aHeaCus2 := {}
	Private _aColCus2 := {}
	Private _nTotCus1 := _nTotRS := _nTotCus2 := 0
	Private _oTotCus1,_oTotRS,_oTotCus2
				
	Private _oGetDad, _oGetEqu, _oGetCus1, _oGetCus2

	Define MsDialog oDlgPrinc Title 'Plano de Ação' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	DEFINE FONT oFont0 NAME "Arial" SIZE 0,14 		OF oDlgPrinc
	DEFINE FONT oFont1 NAME "Arial" SIZE 0,14 BOLD 	OF oDlgPrinc
	DEFINE FONT oFont3 NAME "Arial" SIZE 0,18 		OF oDlgPrinc

	_nCor1 := 12577262 //lemonchiffon 2
	_nCor2 := 25600   //DarkGreen
		
	oScroll1 := TScrollArea():New(oDlgPrinc,0,0,273,645,.T.,.T.,.T.)
	oScroll1:Align := CONTROL_ALIGN_TOP
		
	@ 000,000 MSPANEL oPanel1 OF oScroll1 SIZE 645,660
	oScroll1:SetFrame( oPanel1 )

	PXH37B() //Plano de Ação (Cabeçalho)
	PXH37C() //Custo Pessoal
	PXH37D() //Equipamentos
	PXH37E() //Ações
	PXH37F() //Custos

	SUBTOTA('P')

	bOK 		:= "{ || U_SAVESZD(),oDlgPrinc:End() }"
	bCancel 	:= "{ || oDlgPrinc:End() }"

	ACTIVATE MSDIALOG oDlgPrinc CENTERED ON INIT EnchoiceBar(oDlgPrinc,&(bOk),&(bCancel))

Return


Static Function PXH37B() //Plano de Ação (Cabeçalho)

	SZD->(dbSetOrder(1))
	If SZD->(MsSeek(xFilial('SZD')+'001'+_cRef))
		
		_nProd	:= SZD->ZD_VALOR01
		_nPMed	:= SZD->ZD_VALOR02
		_nImp	:= SZD->ZD_VALOR03
		_nCOpr	:= SZD->ZD_VALOR04
		_nAvia	:= SZD->ZD_VALOR05
		_nDIl	:= SZD->ZD_VALOR06
		_nDIg	:= SZD->ZD_VALOR07
		_nPMPg	:= SZD->ZD_VALOR08
		_cLider	:= SZD->ZD_OBS
	Endif


	@ 02, 01  TO 03,631 LABEL '' OF oPanel1 PIXEL

	oSay:= TSay():New(05,10 ,{||' Filial'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 05,45 MsGet _oGet1 VAR _cFilial					When .F. Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(05,140 ,{||' Líder'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 05,175 MsGet _oGet2 VAR _cLider					When .T. Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(05,270 ,{||' Semestre'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 05,305 MsGet _oGet3 VAR _cSemest					When .F. Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(05,400 ,{||' Ano'}				,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 05,435 MsGet _oGet4 VAR _cAno						When .F. Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(05,530 ,{||' Mês'}				,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 05,565 MsGet _oGet5 VAR _cMes						When .F. Size 50,08 Pixel Of oPanel1 FONT oFont1



	@ 19, 01  TO 20,631 LABEL '' OF oPanel1 PIXEL

	oSay:= TSay():New(24,10 ,{||' Prod.:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 24,45 MsGet _oProd VAR _nProd						When .T.  VALID SUBTOTA('P')	Picture("@E 999,999.99") 	 Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(39,10 ,{||' P. Médio:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 39,45 MsGet _oPMed VAR _nPMed						When .T. VALID SUBTOTA('O')	Picture("@E 999,999.99") 	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(54,10 ,{||' Impostos:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 54,45 MsGet _oImp VAR _nImp						When .T.  VALID SUBTOTA('O')	Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(69,10 ,{||' P. líquido:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 69,45 MsGet _oPLiq VAR _nPLiq						When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(24,140 ,{||' Serv.:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 24,175 MsGet _oServ VAR _nServ						When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(39,140 ,{||' C. oper.:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 39,175 MsGet _oCOpr VAR _nCOpr					When .T. VALID SUBTOTA('O')	Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(54,140 ,{||' C.Pessoal:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 54,175 MsGet _oCPes VAR _nCPes					When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(69,140 ,{||' Avião:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 69,175 MsGet _oAvia VAR _nAvia					When .T. VALID SUBTOTA('O')	Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(24,270 ,{||' Res. Liq.:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 24,305 MsGet _oRLiq VAR _nRLiq					When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(39,270 ,{||' DI (R$/L):'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 39,305 MsGet _oDIl VAR _nDIl						When .T. VALID SUBTOTA('O')	Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(54,270 ,{||' DI (R$/g):'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 54,305 MsGet _oDIg VAR _nDIg						When .T. VALID SUBTOTA('O')	Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(69,270 ,{||' DI mês (L):'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 69,305 MsGet _oDIMl VAR _nDIMl					When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(24,400 ,{||' NºInteg.:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 24,435 MsGet _oInte VAR _nInte					When .F. VALID SUBTOTA('O')	Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(39,400 ,{||' Prod./int.:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 39,435 MsGet _oPInt VAR _nPInt					When .F. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(54,400 ,{||' Nº equip.:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 54,435 MsGet _oEqui VAR _nEqui					When .F. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(69,400 ,{||' Prod./eq.:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 69,435 MsGet _oPEqu VAR _nPEqu					When .F. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(24,530 ,{||' Teor 80%:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 24,565 MsGet _oT80 VAR _nT80						When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(39,530 ,{||' PM Pagto:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 39,565 MsGet _oPMPg VAR _nPMPg					When .T. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(54,530 ,{||' Res. final estimado:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,85,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 69,530 MsGet _oRsFin VAR _nRsFin					When .F. Picture("@E 999,999,999.99")	Size 85,08 Pixel Of oPanel1 FONT oFont0

	@ 83, 01  TO 84,631 LABEL '' OF oPanel1 PIXEL



	oSay:= TSay():New(92,010 ,{||' Realizado:'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,200,09,,,,,.T.)
	oSay:lTransparent := .F.

	@ 104, 01  TO 105,631 LABEL '' OF oPanel1 PIXEL

	oSay:= TSay():New(108,10 ,{||' Prod.:'}			,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 108,45 MsGet _oProdR VAR _nProdR				When .T. Picture("@E 999,999.99") 	 Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(123,10 ,{||' P. Médio:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 123,45 MsGet _oPMedR VAR _nPMedR				When .T. Picture("@E 999,999.99") 	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(138,10 ,{||' Impostos:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 138,45 MsGet _oImpR VAR _nImpR				When .T.  Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(153,10 ,{||' P. líquido:'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 153,45 MsGet _oPLiqR VAR _nPLiqR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(108,140 ,{||' Serv.:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 108,175 MsGet _oServR VAR _nServR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(123,140 ,{||' C. oper.:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 123,175 MsGet _oCOprR VAR _nCOprR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(138,140 ,{||' C.Pessoal:'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 138,175 MsGet _oCPesR VAR _nCPesR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(153,140 ,{||' Avião:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 153,175 MsGet _oAviaR VAR _nAviaR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(108,270 ,{||' Res. Liq.:'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 108,305 MsGet _oRLiqR VAR _nRLiqR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(123,270 ,{||' DI (R$/L):'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 123,305 MsGet _oDIlR VAR _nDIlR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(138,270 ,{||' DI (R$/g):'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 138,305 MsGet _oDIgR VAR _nDIgR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(153,270 ,{||' DI mês (L):'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 153,305 MsGet _oDIMlR VAR _nDIMlR				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(108,400 ,{||' NºInteg.:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 108,435 MsGet _oInteR VAR _nInteR				When .T. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(123,400 ,{||' Prod./int.:'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 123,435 MsGet _oPIntR VAR _nPIntR				When .T. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(138,400 ,{||' Nº equip.:'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 138,435 MsGet _oEquiR VAR _nEquiR				When .T. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(153,400 ,{||' Prod./eq.:'}	,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 153,435 MsGet _oPEquR VAR _nPEquR				When .T. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0


	oSay:= TSay():New(108,530 ,{||' Teor 80%:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 108,565 MsGet _oT80R VAR _nT80R				When .T. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(123,530 ,{||' PM Pagto:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,31,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 123,565 MsGet _oPMPgR VAR _nPMPgR				When .T. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont0

	oSay:= TSay():New(138,530 ,{||' Res. final estimado:'}		,oPanel1,,oFont0,,,	,.T.,CLR_BLACK,_nCor1,85,09,,,,,.T.)
	oSay:lTransparent := .F.
	
	@ 153,530 MsGet _oRsFinR VAR _nRsFinR			When .T. Picture("@E 999,999,999.99")	Size 85,08 Pixel Of oPanel1 FONT oFont0

	@ 167, 01  TO 168,631 LABEL '' OF oPanel1 PIXEL

Return



Static Function PXH37C() //Custo Pessoal

	Local _aAlter 		:= {"ZD_VALOR03","ZD_VALOR05","ZD_OBS"}

	_aCampos := {'ZD_CODIGO','ZD_DESCRIC','ZD_VALOR01','ZD_VALOR02','ZD_VALOR03','ZD_VALOR04','ZD_VALOR05','ZD_VALOR06','ZD_VALOR07','ZD_OBS'}
	nUsado   := 0
	For C := 1 To Len(_aCampos)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCampos[C]))
	
			nUsado++
		
			_cName := ''
			If SX3->X3_CAMPO = 'ZD_VALOR01'
				_cName := 'Quantidade'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR02'
				_cName := 'Salário'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR03'
				_cName := 'R$/Ton'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR04'
				_cName := 'Vol.Pago'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR05'
				_cName := '%'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR06'
				_cName := 'Limite'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR07'
				_cName := 'Total Ind.'
			Endif
		
			If Alltrim(SX3->X3_CAMPO) $ 'ZD_CODIGO|ZD_DESCRIC|ZD_OBS'
				aAdd(_aHeaPes, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			Else
				aAdd(_aHeaPes, {_cName,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			Endif
		Endif
	Next C
	
	Private _nPosEqA  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	Private _nPosDeA  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	Private _nPosV1A  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
	Private _nPosV2A  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_VALOR02"})
	Private _nPosV3A  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_VALOR03"})
	Private _nPosV4A  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_VALOR04"})
	Private _nPosV5A  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_VALOR05"})
	Private _nPosV6A  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_VALOR06"})
	Private _nPosV7A  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_VALOR07"})
	Private _nPosObA  := aScan(_aHeaPes,{|x| Alltrim(x[2]) == "ZD_OBS"})

	_cQuery := " SELECT RJ_FUNCAO AS FUNCAO,RJ_DESC AS NOME ,RA_SALARIO AS SALARIO, COUNT(RA_CODFUNC) AS TOT " + CRLF
	_cQuery += " FROM "+RetSqlName("SRA")+" RA " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SRJ")+" RJ ON RA_CODFUNC = RJ_FUNCAO " + CRLF
	_cQuery += " WHERE RA.D_E_L_E_T_ = '' AND RJ.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " AND RA_SITFOLH IN (' ','F') AND RA_SALARIO > 0 " + CRLF
	_cQuery += " GROUP BY RJ_FUNCAO,RJ_DESC ,RA_SALARIO " + CRLF
	_cQuery += " ORDER BY RJ_DESC " + CRLF
	
	//MemoWrite("D:\PHX037.TXT",_cQuery)
	
	TCQUERY _cQuery NEW ALIAS "TRB"

	TRB->(dbGotop())
	
	_nTInte := _nTotGer := 0
	
	WHILE TRB->(!EOF())
	
		AADD(_aColPes,Array(nUsado+1))
		
		_cCodigo := TRB->FUNCAO
		_n100    := 100
		_cObsPes := ''
		_nRsTon  := 0
		SZD->(dbSetOrder(1))
		If SZD->(MsSeek(xFilial('SZD')+'003'+_cRef+_cCodigo))
			_nRsTon 	:= SZD->ZD_VALOR03
			_n100   	:= SZD->ZD_VALOR05
			_nEncFol	:= SZD->ZD_VALOR08
			_cObsPes    := SZD->ZD_OBS 
		Endif

		_aColPes[Len(_aColPes)][_nPosEqA]	:= _cCodigo
		_aColPes[Len(_aColPes)][_nPosDeA]	:= TRB->NOME
		_aColPes[Len(_aColPes)][_nPosV1A]	:= TRB->TOT
		_aColPes[Len(_aColPes)][_nPosV2A]	:= TRB->SALARIO
		_aColPes[Len(_aColPes)][_nPosV3A]	:= _nRsTon
		_aColPes[Len(_aColPes)][_nPosV4A]	:= _nProd
		_aColPes[Len(_aColPes)][_nPosV5A]	:= _n100
		_nLimite := TRB->SALARIO+(_nRsTon * _nProd)
		_aColPes[Len(_aColPes)][_nPosV6A]	:= _nLimite
		_nGeral := (TRB->TOT * _nLimite)+((TRB->TOT * _nLimite)* (_nEncFol/100))
		_aColPes[Len(_aColPes)][_nPosV7A]	:= _nGeral
		_aColPes[Len(_aColPes)][_nPosObA]	:= _cObsPes
		_aColPes[Len(_aColPes)][nUsado+1]	:= .F.

		_nTInte  += TRB->TOT
		_nTotGer += _nGeral
		
		TRB->(dbSkip())
	EndDo
	
	TRB->(dbCloseArea())
	
	_nInte := _nTInte
	
	oSay:= TSay():New(176,010 ,{||' Custo pessoal (salários, encargos e befefícios)'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,200,09,,,,,.T.)
	oSay:lTransparent := .F.

	@ 188, 01  TO 189,631 LABEL '' OF oPanel1 PIXEL

	_oGetDad := MsNewGetDados():New(192,10,300,615, GD_UPDATE,"AllwaysTrue()", "AllwaysTrue()",,_aAlter,,,,,,oPanel1,_aHeaPes,_aColPes)
		
	oSay:= TSay():New(305,10 ,{||' Tot.Integrantes:'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 305,60 MsGet _oTInte VAR _nTInte						When .F. Picture("@E 99,999")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(305,170 ,{||' Enc. s/ Folha:'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 305,220 MsGet _oEncFol VAR _nEncFol					When .T. VALID U_PXH37GTL('ENC','1') Picture("@E 999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(305,340 ,{||' Total Geral:'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 305,390 MsGet _oTotGer VAR _nTotGer					When .F. Picture("@E 999,999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	_nTot17	:= _nTotGer * 0.17
	oSay:= TSay():New(305,515 ,{||' Total (17%):'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 305,565 MsGet _oTot17 VAR _nTot17						When .F. Picture("@E 999,999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	@ 319, 01  TO 320,631 LABEL '' OF oPanel1 PIXEL
	
Return


Static Function SUBTOTA(_cOpc)

	_nPLiq 	:= _nPMed - _nImp
	_nServ 	:= _nPLiq - _nDIg
	_nCPes  := If(_nTot17 > _nTotCus1, (_nTotGer+_nTot17)/_nProd, (_nTotGer+_nTotCus1)/_nProd)
	_nRLiq 	:= _nServ - _nCOpr - _nCPes - _nAvia
	_nDIMl 	:= _nDIg * _nProd / _nDIl
	_nPInt 	:= _nProd / _nInte
	_nEqui  := _nTotQt
	_nPEqu 	:= _nProd / _nEqui
	_nT80  	:= _nProd * 0.80 //80 %
	_nRsFin	:= _nRLiq * _nT80
	_nTotRS := (_nTotCus2 / _nProd) / 6
	
	_oPLiq:Refresh()
	_oServ:Refresh()
	_oCPes:Refresh()
	_oRLiq:Refresh()
	_oDIMl:Refresh()
	_oPInt:Refresh()
	_oEqui:Refresh()
	_oPEqu:Refresh()
	_oT80:Refresh()
	_oRsFin:Refresh()
	_oTotRS:Refresh()
	
	If _cOpc == 'P'
		nPosVl1E := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
		nPosVl2E := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR02"})
		nPosVl3E := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR03"})
		nPosVl4E := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR04"})
		nPosVl5E := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR05"})
		nPosVl6E := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR06"})
		nPosVl7E := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR07"})

		_nTotGer := 0
		For F := 1 To Len(_oGetDad:aCols)
	
			_oGetDad:aCols[F][nPosVl4E] := _nProd
			_nSalario := _oGetDad:aCols[F][nPosVl2E]
			_nRsTon   := _oGetDad:aCols[F][nPosVl3E]
			_nVolume  := _oGetDad:aCols[F][nPosVl4E]
	
			_nLimite  := _nSalario+(_nRsTon * _nVolume)
			
			_nGeral   := (_oGetDad:aCols[F][nPosVl1E] * _nLimite)+((_oGetDad:aCols[F][nPosVl1E] * _nLimite)* (_nEncFol/100))
					
			_oGetDad:aCols[F][nPosVl6E] := _nLimite
			_oGetDad:aCols[F][nPosVl7E] := _nGeral
		
			_nTotGer += _nGeral
		Next F

		_nTot17	:= _nTotGer * 0.17
	
		_oTotGer:Refresh()
		_oTot17:Refresh()
	Endif

	GetDRefresh()

Return


User Function PXH37GTL(_cTp,_cOpt)
	
	Private nPosCodB := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	Private nPosFunB := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	Private nPosVl1B := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
	Private nPosVl2B := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR02"})
	Private nPosVl3B := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR03"})
	Private nPosVl4B := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR04"})
	Private nPosVl5B := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR05"})
	Private nPosVl6B := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR06"})
	Private nPosVl7B := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR07"})
	Private nPosObsB := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_OBS"})
	
	If _cTp $ '003|ENC'
	
		If _cTp == 'ENC'
			_nRet := .T.
		ElseIf _cTp == '003'
			_nRet := _oGetDad:aCols[n][&('nPosVl'+_cOpt+'B')]
		Endif

		_nTotGer := 0
		For F := 1 To Len(_oGetDad:aCols)
	
			_nSalario := _oGetDad:aCols[F][nPosVl2B]
			_nRsTon   := _oGetDad:aCols[F][nPosVl3B]
			_nVolume  := _oGetDad:aCols[F][nPosVl4B]
	
			_nLimite  := _nSalario+(_nRsTon * _nVolume)
			
			_nGeral   := (_oGetDad:aCols[F][nPosVl1B] * _nLimite)+((_oGetDad:aCols[F][nPosVl1B] * _nLimite)* (_nEncFol/100))
					
			_oGetDad:aCols[F][nPosVl6B] := _nLimite
			_oGetDad:aCols[F][nPosVl7B] := _nGeral
		
			_nTotGer += _nGeral
		Next F

		_nTot17	:= _nTotGer * 0.17
	
		_oTotGer:Refresh()
		_oTot17:Refresh()
		//_oGetDad:ForceRefresh()
	ElseIf _cTp $ '004'
	
		Private _nPosV1F  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
		Private _nPosV2F  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR02"})
		Private _nPosV3F  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR03"})
	
		_nRet := _oGetEqu:aCols[n][&('_nPosV'+_cOpt+'F')]
		
		_nTotAlu := _nTotTot := 0

		For F := 1 To Len(_oGetEqu:aCols)
	
			_nQtde := _oGetEqu:aCols[F][_nPosV1F]
			_nAlug := _oGetEqu:aCols[F][_nPosV2F]
	
			_oGetEqu:aCols[F][_nPosV3F] := _nQtde * _nAlug
		
			_nTotAlu += _nAlug
			_nTotTot += _nQtde * _nAlug
		Next F
	
		_oTotAlu:Refresh()
		_oTotTot:Refresh()
	
	ElseIf _cTp $ '006|007'
	
		If _cTp == '006'
			Private _nPosV1G  := aScan(_oGetCus1:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
			_nRet := aCols[n][&('_nPosV'+_cOpt+'G')]
//			_nRet := _oGetCus1:aCols[n][&('_nPosV'+_cOpt+'G')]

			_nTotCus1 := 0
			For F := 1 To Len(_oGetCus1:aCols)
				_nTotCus1 += _oGetCus1:aCols[F][_nPosV1G]
			Next F
			_oTotCus1:Refresh()

		Else
			Private _nPosV1G  := aScan(_oGetCus2:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
			_nRet := aCols[n][&('_nPosV'+_cOpt+'G')]
//			_nRet := _oGetCus2:aCols[n][&('_nPosV'+_cOpt+'G')]

			_nTotRS := _nTotCus2 := 0
			For F := 1 To Len(_oGetCus2:aCols)
				_nTotCus2 += _oGetCus2:aCols[F][_nPosV1G]
			Next F
			
			_nTotRS := (_nTotCus2 / _nProd) / 6
			
			_oTotRS:Refresh()
			_oTotCus2:Refresh()
		Endif		
	Endif
		
Return(_nRet)


Static Function PXH37D() //Equipamentos

	Local _aAlter1 		:= {"ZD_VALOR02","ZD_OBS"}
		
	nUsado   := 0
	_aCampos := {'ZD_CODIGO','ZD_DESCRIC','ZD_VALOR01','ZD_VALOR02','ZD_VALOR03','ZD_OBS'}

	For C := 1 To Len(_aCampos)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCampos[C]))
	
			nUsado++
		
			_cName := ''
			If SX3->X3_CAMPO = 'ZD_VALOR01'
				_cName := 'Quantidade'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR02'
				_cName := 'Aluguel'
			ElseIf SX3->X3_CAMPO = 'ZD_VALOR03'
				_cName := 'Subtotal'
			Endif
		
			If Alltrim(SX3->X3_CAMPO) $ 'ZD_CODIGO|ZD_DESCRIC|ZD_OBS'
				aAdd(_aHeaEqu, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			Else
				aAdd(_aHeaEqu, {_cName,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			Endif
		Endif
	Next C
	
	Private _nPosEqC  := aScan(_aHeaEqu,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	Private _nPosDeC  := aScan(_aHeaEqu,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	Private _nPosV1C  := aScan(_aHeaEqu,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
	Private _nPosV2C  := aScan(_aHeaEqu,{|x| Alltrim(x[2]) == "ZD_VALOR02"})
	Private _nPosV3C  := aScan(_aHeaEqu,{|x| Alltrim(x[2]) == "ZD_VALOR03"})
	Private _nPosObC  := aScan(_aHeaEqu,{|x| Alltrim(x[2]) == "ZD_OBS"})

	SZC->(dbSetOrder(1))
	SZC->(dbgotop())
	
	_nTotQt := _nTotAlu := _nTotTot := 0
	While SZC->(!EOF())
		
		If SZC->ZC_ATIVO == "N"
			SZC->(dbSkip())
			Loop
		Endif

		If SZC->ZC_TIPO == "004"

			AADD(_aColEqu,Array(nUsado+1))
		          		
		   	_cCodigo 	:= SZC->ZC_EQUIPAM
			_nVal2 		:= 0    
			_cObsEq		:= ''     
			SZD->(dbSetOrder(1))
			If SZD->(MsSeek(xFilial('SZD')+'004'+_cRef+_cCodigo))
   
				_nVal2 := SZD->ZD_VALOR02    
				_cObsEq:= SZD->ZD_OBS     
			Endif
			
			_aColEqu[Len(_aColEqu)][_nPosEqC] := SZC->ZC_EQUIPAM
			_aColEqu[Len(_aColEqu)][_nPosDeC] := SZC->ZC_DESCEQU
			_aColEqu[Len(_aColEqu)][_nPosV1C] := SZC->ZC_QTDE
			_aColEqu[Len(_aColEqu)][_nPosV2C] := _nVal2
			_aColEqu[Len(_aColEqu)][_nPosV3C] := _nVal2 * SZC->ZC_QTDE
			_aColEqu[Len(_aColEqu)][_nPosObC] := _cObsEq
			_aColEqu[Len(_aColEqu)][nUsado+1]:= .F.
		
			_nTotQt  += SZC->ZC_QTDE
			_nTotAlu += _nVal2
			_nTotTot += _nVal2 * SZC->ZC_QTDE
		Endif

		SZC->(dbSkip())
	EndDo
	
	_nEqui  := _nTotQt
	
	oSay:= TSay():New(328,010 ,{||' Equipamentos'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,200,09,,,,,.T.)
	oSay:lTransparent := .F.

	@ 340, 01  TO 341,631 LABEL '' OF oPanel1 PIXEL

	_oGetEqu := MsNewGetDados():New(344,10,450,615, GD_UPDATE,"AllwaysTrue()", "AllwaysTrue()",,_aAlter1,,,,,,oPanel1,_aHeaEqu,_aColEqu)
	
	oSay:= TSay():New(455,10 ,{||' Tot.Quant.:'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 455,60 MsGet _oTotQt VAR _nTotQt					When .F. Picture("@E 999,999")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(455,170 ,{||' Tot.Aluguel:'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 455,220 MsGet _oTotAlu VAR _nTotAlu				When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(455,340 ,{||' Total:'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 455,390 MsGet _oTotTot VAR _nTotTot				When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	@ 469, 01  TO 470,631 LABEL '' OF oPanel1 PIXEL
	
Return



Static Function PXH37E() //Ações

	oSay:= TSay():New(478,010 ,{||' Ações'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,200,09,,,,,.T.)
	oSay:lTransparent := .F.

	@ 490, 01  TO 491,631 LABEL '' OF oPanel1 PIXEL

	SZD->(dbSetOrder(1))
	If SZD->(MsSeek(xFilial('SZD')+'005'+_cRef))
		_cAcoes := SZD->ZD_MEMO
	Endif
	
	_oAcoes:= tMultiget():New(499,10,{|u|if(Pcount()>0,_cAcoes:=u,_cAcoes)},oPanel1,615,040,,,,,,.T.,,,,,,.F.)

	@ 545, 01  TO 546,631 LABEL '' OF oPanel1 PIXEL
Return



Static Function PXH37F() //Custos

	nUsado   := 0
	_aCampos := {'ZD_CODIGO','ZD_DESCRIC','ZD_VALOR01'}
	
	For C := 1 To Len(_aCampos)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCampos[C]))
	
			nUsado++
		
			_cName := ''
			If SX3->X3_CAMPO = 'ZD_VALOR01'
				_cName := 'Valor'
			Endif
		
			If Alltrim(SX3->X3_CAMPO) $ 'ZD_CODIGO|ZD_DESCRIC'
				aAdd(_aHeaCus1, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
				aAdd(_aHeaCus2, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			Else
				aAdd(_aHeaCus1, {_cName,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
				aAdd(_aHeaCus2, {_cName,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			Endif
		Endif
	Next C
	
	Private _nPosEqD  := aScan(_aHeaCus1,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	Private _nPosDeD  := aScan(_aHeaCus1,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	Private _nPosV1D  := aScan(_aHeaCus1,{|x| Alltrim(x[2]) == "ZD_VALOR01"})

	SZC->(dbSetOrder(1))
	SZC->(dbgotop())
	
	_nTotCus1 := _nTotCus2 := _nTotRS := 0
	While SZC->(!EOF())
		
		If SZC->ZC_ATIVO == "N"
			SZC->(dbSkip())
			Loop
		Endif

		If SZC->ZC_TIPO == "006"

			AADD(_aColCus1,Array(nUsado+1))
		          		
		    _nVal01 := 0
			_cCodigo := SZC->ZC_EQUIPAM
			SZD->(dbSetOrder(1))
			If SZD->(MsSeek(xFilial('SZD')+'006'+_cRef+_cCodigo))
				_nVal01 := SZD->ZD_VALOR01
			Endif

			_aColCus1[Len(_aColCus1)][_nPosEqD] := SZC->ZC_EQUIPAM
			_aColCus1[Len(_aColCus1)][_nPosDeD] := Alltrim(SZC->ZC_DESCEQU)
			_aColCus1[Len(_aColCus1)][_nPosV1D] := _nVal01
			_aColCus1[Len(_aColCus1)][nUsado+1]:= .F.
		
			_nTotCus1 += _nVal01
		ElseIf SZC->ZC_TIPO == "007"
			AADD(_aColCus2,Array(nUsado+1))
		          		
		    _nVal01 := 0
			_cCodigo := SZC->ZC_EQUIPAM
			SZD->(dbSetOrder(1))
			If SZD->(MsSeek(xFilial('SZD')+'007'+_cRef+_cCodigo))
				_nVal01 := SZD->ZD_VALOR01
			Endif

			_aColCus2[Len(_aColCus2)][_nPosEqD] := SZC->ZC_EQUIPAM
			_aColCus2[Len(_aColCus2)][_nPosDeD] := Alltrim(SZC->ZC_DESCEQU)
			_aColCus2[Len(_aColCus2)][_nPosV1D] := _nVal01
			_aColCus2[Len(_aColCus2)][nUsado+1]:= .F.
		
			_nTotCus2 += _nVal01
		Endif

		SZC->(dbSkip())
	EndDo

	_nTotRS := (_nTotCus2 / _nProd) / 6
	_nCPes  := If(_nTot17 > _nTotCus1, (_nTotGer+_nTot17)/_nProd, (_nTotGer+_nTotCus1)/_nProd)

	oSay:= TSay():New(554,010 ,{||' Outros Custos'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,200,09,,,,,.T.)
	oSay:lTransparent := .F.

	oSay:= TSay():New(554,345 ,{||' Outros Custos Operacionais Previstos?'}		,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,200,09,,,,,.T.)
	oSay:lTransparent := .F.

	@ 566, 01  TO 567,631 LABEL '' OF oPanel1 PIXEL

	_oGetCus1 := MsNewGetDados():New(570,10 ,630,280, GD_UPDATE,"AllwaysTrue()", "AllwaysTrue()",,,,,,,,oPanel1,_aHeaCus1,_aColCus1)
	_oGetCus2 := MsNewGetDados():New(570,345,630,615, GD_UPDATE,"AllwaysTrue()", "AllwaysTrue()",,,,,,,,oPanel1,_aHeaCus2,_aColCus2)

	oSay:= TSay():New(635,10 ,{||' Total:'}				,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 635,60 MsGet _oTotCus1 VAR _nTotCus1				When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(635,345 ,{||' R$/Ton.:'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 635,395 MsGet _oTotRS VAR _nTotRS					When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	oSay:= TSay():New(635,510 ,{||' Total:'}			,oPanel1,,oFont1,,,	,.T.,CLR_BLACK,_nCor1,45,09,,,,,.T.)
	oSay:lTransparent := .F.
	@ 635,560 MsGet _oTotCus2 VAR _nTotCus2				When .F. Picture("@E 999,999.99")	Size 50,08 Pixel Of oPanel1 FONT oFont1

	@ 649, 01  TO 650,631 LABEL '' OF oPanel1 PIXEL

	@ 546, 310  TO 650,311 LABEL '' OF oPanel1 PIXEL
		
Return



//Função para gravação na tabela SZD
User Function SAVESZD()
	
	SZD->(dbSetOrder(1))
	If !SZD->(MsSeek(xFilial('SZD')+'001'+_cRef))
		SZD->(RecLock('SZD',.T.))
		SZD->ZD_FILIAL 	:= xFilial('SZD')
		SZD->ZD_TIPO 	:= '001'
		SZD->ZD_REFEREN	:= _cRef
		SZD->ZD_VALOR01	:= _nProd
		SZD->ZD_VALOR02	:= _nPMed
		SZD->ZD_VALOR03	:= _nImp
		SZD->ZD_VALOR04	:= _nCOpr
		SZD->ZD_VALOR05	:= _nAvia
		SZD->ZD_VALOR06	:= _nDIl
		SZD->ZD_VALOR07	:= _nDIg
		SZD->ZD_VALOR08	:= _nPMPg
		SZD->ZD_OBS		:= _cLider
		SZD->(MsUnlock())
	Else
		SZD->(RecLock('SZD',.F.))
		SZD->ZD_VALOR01	:= _nProd
		SZD->ZD_VALOR02	:= _nPMed
		SZD->ZD_VALOR03	:= _nImp
		SZD->ZD_VALOR04	:= _nCOpr
		SZD->ZD_VALOR05	:= _nAvia
		SZD->ZD_VALOR06	:= _nDIl
		SZD->ZD_VALOR07	:= _nDIg
		SZD->ZD_VALOR08	:= _nPMPg
		SZD->ZD_OBS		:= _cLider
		SZD->(MsUnlock())
	Endif

	nPosCodH := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	nPosDesH := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	nPosObsH := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_OBS"})
	nPosVl1H := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
	nPosVl2H := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR02"})
	nPosVl3H := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR03"})
	nPosVl4H := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR04"})
	nPosVl5H := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR05"})
	nPosVl6H := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR06"})
	nPosVl7H := aScan(_oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR07"})

	For F := 1 To Len(_oGetDad:aCols)

		_cCodigo := _oGetDad:aCols[F][nPosCodH]
		SZD->(dbSetOrder(1))
		If !SZD->(MsSeek(xFilial('SZD')+'003'+_cRef+_cCodigo))
			SZD->(RecLock('SZD',.T.))
			SZD->ZD_FILIAL 	:= xFilial('SZD')
			SZD->ZD_TIPO 	:= '003'
			SZD->ZD_REFEREN	:= _cRef
			SZD->ZD_CODIGO	:= _cCodigo
			SZD->ZD_DESCRIC	:= _oGetDad:aCols[F][nPosDesH]
			SZD->ZD_VALOR01	:= _oGetDad:aCols[F][nPosVl1H]
			SZD->ZD_VALOR02	:= _oGetDad:aCols[F][nPosVl2H]
			SZD->ZD_VALOR03	:= _oGetDad:aCols[F][nPosVl3H]
			SZD->ZD_VALOR04	:= _oGetDad:aCols[F][nPosVl4H]
			SZD->ZD_VALOR05	:= _oGetDad:aCols[F][nPosVl5H]
			SZD->ZD_VALOR06	:= _oGetDad:aCols[F][nPosVl6H]
			SZD->ZD_VALOR07	:= _oGetDad:aCols[F][nPosVl7H]
			SZD->ZD_VALOR08	:= _nEncFol
			SZD->ZD_OBS		:= _oGetDad:aCols[F][nPosObsH]
			SZD->(MsUnlock())
		Else
			SZD->(RecLock('SZD',.F.))
			SZD->ZD_VALOR01	:= _oGetDad:aCols[F][nPosVl1H]
			SZD->ZD_VALOR02	:= _oGetDad:aCols[F][nPosVl2H]
			SZD->ZD_VALOR03	:= _oGetDad:aCols[F][nPosVl3H]
			SZD->ZD_VALOR04	:= _oGetDad:aCols[F][nPosVl4H]
			SZD->ZD_VALOR05	:= _oGetDad:aCols[F][nPosVl5H]
			SZD->ZD_VALOR06	:= _oGetDad:aCols[F][nPosVl6H]
			SZD->ZD_VALOR07	:= _oGetDad:aCols[F][nPosVl7H]
			SZD->ZD_VALOR08	:= _nEncFol
			SZD->ZD_OBS		:= _oGetDad:aCols[F][nPosObsH]
			SZD->(MsUnlock())
	
		Endif
	Next F

	Private _nPosEqI  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	Private _nPosDeI  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	Private _nPosV1I  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})
	Private _nPosV2I  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR02"})
	Private _nPosV3I  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_VALOR03"})
	Private _nPosObI  := aScan(_oGetEqu:aHeader,{|x| Alltrim(x[2]) == "ZD_OBS"})

	For F := 1 To Len(_oGetEqu:aCols)

		_cCodigo := _oGetEqu:aCols[F][_nPosEqI]
		SZD->(dbSetOrder(1))
		If !SZD->(MsSeek(xFilial('SZD')+'004'+_cRef+_cCodigo))
			SZD->(RecLock('SZD',.T.))
			SZD->ZD_FILIAL 	:= xFilial('SZD')
			SZD->ZD_TIPO 	:= '004'
			SZD->ZD_REFEREN	:= _cRef
			SZD->ZD_CODIGO	:= _cCodigo
			SZD->ZD_DESCRIC	:= _oGetEqu:aCols[F][_nPosDeI]
			SZD->ZD_VALOR01	:= _oGetEqu:aCols[F][_nPosV1I]
			SZD->ZD_VALOR02	:= _oGetEqu:aCols[F][_nPosV2I]
			SZD->ZD_VALOR03	:= _oGetEqu:aCols[F][_nPosV3I]
			SZD->ZD_OBS		:= _oGetEqu:aCols[F][_nPosObI]
			SZD->(MsUnlock())
		Else
			SZD->(RecLock('SZD',.F.))
			SZD->ZD_DESCRIC	:= _oGetEqu:aCols[F][_nPosDeI]
			SZD->ZD_VALOR01	:= _oGetEqu:aCols[F][_nPosV1I]
			SZD->ZD_VALOR02	:= _oGetEqu:aCols[F][_nPosV2I]
			SZD->ZD_VALOR03	:= _oGetEqu:aCols[F][_nPosV3I]
			SZD->ZD_OBS		:= _oGetEqu:aCols[F][_nPosObI]
			SZD->(MsUnlock())
		Endif
	Next F

	SZD->(dbSetOrder(1))
	If !SZD->(MsSeek(xFilial('SZD')+'005'+_cRef))
		SZD->(RecLock('SZD',.T.))
		SZD->ZD_FILIAL 	:= xFilial('SZD')
		SZD->ZD_TIPO 	:= '005'
		SZD->ZD_REFEREN	:= _cRef
		SZD->ZD_MEMO	:= _cAcoes
		SZD->(MsUnlock())
	Else
		SZD->(RecLock('SZD',.F.))
		SZD->ZD_MEMO	:= _cAcoes
		SZD->(MsUnlock())
	Endif

	Private _nPosEqJ  := aScan(_oGetCus1:AHeader,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	Private _nPosDeJ  := aScan(_oGetCus1:AHeader,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	Private _nPosV1J  := aScan(_oGetCus1:AHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})

	For F := 1 To Len(_oGetCus1:aCols)

		_cCodigo := _oGetCus1:aCols[F][_nPosEqJ]
		SZD->(dbSetOrder(1))
		If !SZD->(MsSeek(xFilial('SZD')+'006'+_cRef+_cCodigo))
			SZD->(RecLock('SZD',.T.))
			SZD->ZD_FILIAL 	:= xFilial('SZD')
			SZD->ZD_TIPO 	:= '006'
			SZD->ZD_REFEREN	:= _cRef
			SZD->ZD_CODIGO	:= _cCodigo
			SZD->ZD_DESCRIC	:= _oGetCus1:aCols[F][_nPosDeJ]
			SZD->ZD_VALOR01	:= _oGetCus1:aCols[F][_nPosV1J]
			SZD->(MsUnlock())
		Else
			SZD->(RecLock('SZD',.F.))
			SZD->ZD_VALOR01	:= _oGetCus1:aCols[F][_nPosV1J]
			SZD->(MsUnlock())
		Endif
	
	Next F

	Private _nPosEqK  := aScan(_oGetCus2:AHeader,{|x| Alltrim(x[2]) == "ZD_CODIGO"})
	Private _nPosDeK  := aScan(_oGetCus2:AHeader,{|x| Alltrim(x[2]) == "ZD_DESCRIC"})
	Private _nPosV1K  := aScan(_oGetCus2:AHeader,{|x| Alltrim(x[2]) == "ZD_VALOR01"})

	For F := 1 To Len(_oGetCus2:aCols)

		_cCodigo := _oGetCus2:aCols[F][_nPosEqK]
		SZD->(dbSetOrder(1))
		If !SZD->(MsSeek(xFilial('SZD')+'007'+_cRef+_cCodigo))
			SZD->(RecLock('SZD',.T.))
			SZD->ZD_FILIAL 	:= xFilial('SZD')
			SZD->ZD_TIPO 	:= '007'
			SZD->ZD_REFEREN	:= _cRef
			SZD->ZD_CODIGO	:= _cCodigo
			SZD->ZD_DESCRIC	:= _oGetCus2:aCols[F][_nPosDeK]
			SZD->ZD_VALOR01	:= _oGetCus2:aCols[F][_nPosV1K]
			SZD->(MsUnlock())
		Else
			SZD->(RecLock('SZD',.F.))
			SZD->ZD_VALOR01	:= _oGetCus2:aCols[F][_nPosV1K]
			SZD->(MsUnlock())
		Endif
	Next F

Return
