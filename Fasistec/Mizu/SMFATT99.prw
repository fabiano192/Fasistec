#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#DEFINE CRLF Chr(13)+CHR(10) // 10 LF ( Nova Linha ) 13 CR ( Retorno de Carro )
#DEFINE 	_wEnter_	chr(13)+chr(10)

#XCommand ROLLBACK TRANSACTION => DisarmTransaction()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT99                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Monitor do trafego de carga e descarga                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT99()
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Private nMVC       := SuperGetMv("MV_MAXVECA",,25)
	Private nMVD       := SuperGetMv("MV_MAXVEDE",,20)
	Private nMVP       := SuperGetMv("MV_MAXVEPA",,30)
	Private nVC        := 0
	Private nVD        := 0
	Private nVPC,nVPD  := 0
	Private wNumOC     := ""
	PRIVATE bFiltraBrw:={|| .t. }
	PRIVATE aFilBrw    :={}

	//private lUsaPager := ( cEmpAnt $ getNewPar('MV_USAPAGE', '20' ) )		//Comentado por Rodrigo (Semar) - 21/06/16
	private lUsaPager := ( cEmpAnt + cFilAnt $ getNewPar('MV_USAPAGE', '2001|0223' ) )

	//PRIVATE  nPosPager := iif(cEmpAnt $ '01', 11, 03)		//Comentado por Rodrgio (Semar) - 21/06/16
	PRIVATE  nPosPager := iif(cEmpAnt + cFilAnt $ '0101|0218', 11, 03)

	//Private cEmpRastroOC := getNewPar('MZ_RASTEMP','30')  //codigo da empresa que controla o rastro da OC	 //Comentado por Rodrigo (Semar) - 21/06/16
	Private cEmpRastroOC := getNewPar('MZ_RASTEMP','3001|0210')  //codigo da empresa que controla o rastro da OC

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oFont1","oFont2","oFont3","oDlg1","oBmp1","oSay1","oBmp8","oSay14","oBrw1","oGrp1","oBmp3","oSay2")
	SetPrvt("oSay4","oSay5","oSay6","oSay7","oBmp2","oBmp4","oBmp5","oBmp6","oBmp7","oGrp2","oSay8","oSay9")
	SetPrvt("oSay11","oSay12","oSay13","oVP","oVC","oVD","oMVP","oMVC","oMVD","oBrw2")

	SetPrvt("oBmp1d","oSay1d","oBmp8d","oSay14d","oGrp1d","oBmpd3","oSay2d")
	SetPrvt("oSay4d","oSay5d","oSay6d","oSay7d","oBmp2d","oBmp4d","oBmp5d","oBmp6d","oBmp7d","oGrp2d","oSay8d","oSay9d")
	SetPrvt("oSay11d","oSay12d","oSay13d","oVPd","oVCd","oVDd","oMVPd","oMVCd","oMVDd","oBrw2d")

	Private waheader  := {}
	Private waColSizes:= {}
	Private aList1	  := {}
	Private aList2	  := {}
	Private aList3	  := {}
	Private aList4	  := {}
	Private aList5	  := {}
	Private aList6	  := {}
	Private aList7	  := {}
	Private aList8	  := {}
	Private aList9	  := {}

	Private	TABCARGP  := ""
	Private TABDESCP  := ""

	private cperg:='MZ999TEL1'
	private lUsaDescSaco:=.t.
	private lUsaCarrSaco:=.t.

	private lUsaNewOC := ( cFilAnt $  getnewPar('MV_USNEWOC','01') ) //if lUsaNewOC


	Private luserFull := .f.

	//Adicionado por Rodrigo
	Private oMenu01
	Private oMenuItem01,oMenuItem02,oMenuItem03,oMenuItem04
	Private oBrwMenu
	Private aGrpUsu		:= u_smGetGrupo()
	Private aPerfil		:= u_carregaPerfil(aGrpUsu)


	//testa liberação de acesso a rotina
	if !u_SMGETACCESS(funname(),.f.); return; endif



	// DEFINE USUARIOS COM DIREITO DE OPERAR A TELA
	wUsers:=Upper(getnewPar('MV_MIZ999',''))
	if empty( wUsers )
		Alert('Parametro MV_MIZ999, nao localizado! Cadastre-o antes de continuar esta rotina. ')
		return
	endif

	lUserFull := u_ChkAcesso("MIZ999",6,.F.)  .or. ( Upper(Alltrim(SUBS(CUSUARIO,7,15))) $ 	wUsers  )
	//lUserFull := .t.  .or. ( Upper(Alltrim(SUBS(CUSUARIO,7,15))) $ 	wUsers  )

	//lUserFull := .t.

	//define modelo da tela c/ F12
	SMFATF61(cperg)


	oAmarelo    := LoadBitmap(GetResources(),'BR_AMARELO')
	oVerde 		:= LoadBitmap(GetResources(),'BR_VERDE')
	oPink 		:= LoadBitmap(GetResources(),'BR_PINK')
	oVermelho 	:= LoadBitmap(GetResources(),'BR_VERMELHO')
	oAzul 		:= LoadBitmap(GetResources(),'BR_AZUL')
	oCinza 		:= LoadBitmap(GetResources(),'BR_PRETO')
	oCinzaLona	:= LoadBitmap(GetResources(),'BR_LONA')
	oBranco		:= LoadBitmap(GetResources(),'BR_BRANCO')
	oMarrom	    := LoadBitmap(GetResources(),'BR_MARROM')
	oLaranja    := LoadBitmap(GetResources(),'BR_LARANJA')
	oLarNF		:= LoadBitmap(GetResources(),'BR_LARNFE')
	oCinz		:= LoadBitmap(GetResources(),'BR_VIOLETA')
	oVermAtt	:= LoadBitmap(GetResources(),'BR_VERMELHO_ATT')

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oFont1     := TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "Verdana",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont3     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	oDlg1      := MSDialog():New( 080,092,680,1280,"Controle do Tráfego de Carga e Descarga",,,.F.,,,,,,.T.,,,.T. )


	nTimeOut := getnewPar('MV_TIME999',30000)  // 1minuto - tempo em milesegundos
	oTimer001:= ""
	oTimer001:= TTimer():New(nTimeOut,{ || U_SMFATA07(0) },oDlg1)
	oTimer001:Activate()



	/*nTimeOut2 := 2000 //getnewPar('MV_TIME999',30000)  // 1minuto - tempo em milesegundos
	oTimer002:= ""
	oTimer002:= TTimer():New(nTimeOut2,{ ||;
	iif( !empty(cCB := U_SMFATF68(.f.)), u_SMFATC02(cCB,"E") , .t.),;            // LE LEITOR DE CB DA ENTRADA
	iif( !empty(cCB := U_SMFATF69(.f.)), u_SMFATC02(cCB,"S") , .T.)  },oDlg1)    // LE LEITOR DE CB DA SAIDA
	oTimer002:Activate()*/




	oFolder1   := TFolder():New( 0,0,{"Carregamento","Descarregamento"},,oDlg1,,,,.T.,.F.,540,300,)


	//************************************* OBJETOS PAGE1 *************************************//
	if lusaCarrSaco
		//lado esquerdo
		//
		oBmp1      := TBitmap():New( 000,005,265,013,,"\images\azul.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay1      := TSay():New( 001,105,{||"Pátio Saco"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,051,010)

		oBmp8      := TBitmap():New( 000,275,265,013,,"\images\azul.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay14     := TSay():New( 001,358,{||"Pátio Granel"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,059,010)

		//lado direito
		//
		oBmp9      := TBitmap():New( 121,005,265,013,,"\images\verde.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay15     := TSay():New( 123,100,{||"Fábrica Saco"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,061,010)

		oBmp10     := TBitmap():New( 121,275,265,013,,"\images\verde.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay16     := TSay():New( 123,353,{||"Fábrica Granel"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,069,009)

	else
		//granel
		oBmp8      := TBitmap():New( 000,005,530,013,,"\images\azul.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay14     := TSay():New( 001,250,{||"Pátio Granel"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,059,010)
		oBmp10     := TBitmap():New( 121,005,530,013,,"\images\verde.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay16     := TSay():New( 123,250,{||"Fábrica Granel"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,069,009)
	endif

	oGrp1      := TGroup():New( 245,006,285,270,"Legendas",oFolder1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBmp3      := TBitmap():New( 257,007,008,008,,"\images\leg_amarelo.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oSay2      := TSay():New( 258,017,{||"1-Pátio"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay3      := TSay():New( 258,070,{||"2-Chamado"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay4      := TSay():New( 258,153,{||"3-Pesado na Entrada"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay5      := TSay():New( 271,017,{||"4-Início C/D"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay6      := TSay():New( 271,070,{||"5-Aguardar Liberação"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay7      := TSay():New( 271,153,{||"6-Em Espera"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay17     := TSay():New( 258,230,{||"7-Pronto"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay18     := TSay():New( 271,230,{||"8-Fat Granel"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)

	oBmp2      := TBitmap():New( 257,060,008,008,,"\images\leg_verde.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp4      := TBitmap():New( 257,143,008,008,,"\images\leg_rosa.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp5      := TBitmap():New( 270,007,008,008,,"\images\leg_azul.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp6      := TBitmap():New( 270,060,008,008,,"\images\leg_preto.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp7      := TBitmap():New( 270,143,008,008,,"\images\leg_vermelho.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp17	    := TBitmap():New( 257,220,008,008,,"\images\leg_marrom.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F.)
	oBmp18     := TBitmap():New( 270,220,008,008,,"\images\leg_laranja.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F.)

	oGrp2      := TGroup():New( 245,275,285,535,"Estatísticas",oFolder1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay11     := TSay():New( 255,285,{||"Veículos no Pátio:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay12     := TSay():New( 265,285,{||"Veículos Carregando:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,063,008)
	oSay13     := TSay():New( 275,285,{||"Veículos Descarregando:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)

	oSay8      := TSay():New( 255,402,{||"Máximo Veículos no Pátio:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,085,008)
	oSay9      := TSay():New( 265,402,{||"Máximo Veículos Carregando:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
	oSay10     := TSay():New( 275,402,{||"Máximo Veículos Descarregando:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
	oVP        := TGet():New( 252,359,{|u| If(PCount()>0,nVPC:=u,nVPC)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVPC",,)
	oVC        := TGet():New( 262,359,{|u| If(PCount()>0,nVC:=u,nVC)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVC",,)
	oVD        := TGet():New( 273,359,{|u| If(PCount()>0,nVD:=u,nVD)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVD",,)
	oMVD       := TGet():New( 273,499,{|u| If(PCount()>0,nMVD:=u,nMVD)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVD",,)
	oMVC       := TGet():New( 262,499,{|u| If(PCount()>0,nMVC:=u,nMVC)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVC",,)
	oMVP       := TGet():New( 252,499,{|u| If(PCount()>0,nMVP:=u,nMVP)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVP",,)

	//Adicionado por Rodrigo
	//oMenu01      := tMenu():new(0,0,0,0,.T.)
	//oMenuItem01  := tMenuItem():new(oMenu01, "Detalhes - Pedido",,,,{||},,,,,,,,,.T.)
	//oMenuItem02  := tMenuItem():new(oMenu01, "Detalhes - OC",,,,{|| SMFATI01("OC",oBrw1:aArray[oBrw1:nAT,7])},,,,,,,,,.T.)
	//oMenuItem02  := tMenuItem():new(oMenu01, "Detalhes - OC",,,,{|| SMFATI01("OC",oBrwMenu)},,,,,,,,,.T.)
	//oMenuItem03  := tMenuItem():new(oMenu01, "Detalhes - Produto",,,,{|| SMFATI01("Produto",oBrw1:aArray[oBrw1:nAT,7])},,,,,,,,,.T.)
	//oMenuItem04  := tMenuItem():new(oMenu01, "Detalhes - Cliente",,,,{||},,,,,,,,,.T.)
	//oMenu01:Add(oMenuItem01)
	//oMenu01:Add(oMenuItem02)
	//oMenu01:Add(oMenuItem03)
	//oMenu01:Add(oMenuItem04)

	//************************************* OBJETOS PAGE2 *************************************//

	ctitGrdES := getnewPar("MV_TITGRES","Materia Prima - Patio CPIND")     //Esquerdo Superior
	ctitGrdEI := getnewPar("MV_TITGREI","Materia Prima - Fábrica CPIND")    // Esquerdo Inferior
	ctitGrdDS := getnewPar("MV_TITGRDS","Materia Prima - Patio EMAF")     //Direito Superior
	ctitGrdDI := getnewPar("MV_TITGRDI","Materia Prima - Fábrica EMAF")    // Direito Inferior


	if lusaDescSaco
		oBmp1d      := TBitmap():New( 000,005,251,013,,"\images\azul.png",.T.,oFolder1:aDialogs[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay1d      := TSay():New( 001,080,{|| ctitGrdES },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,150,010)
		oBmp9d      := TBitmap():New( 121,005,251,013,,"\images\verde.png",.T.,oFolder1:aDialogs[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay15d     := TSay():New( 123,080,{||ctitGrdEI },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,150,010)

		//granel
		oBmp8d      := TBitmap():New( 000,262,251,013,,"\images\azul.png",.T.,oFolder1:aDialogs[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay14d     := TSay():New( 001,330,{||ctitGrdDS },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,150,010)
		oBmp10d     := TBitmap():New( 121,262,251,013,,"\images\verde.png",.T.,oFolder1:aDialogs[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay16d     := TSay():New( 123,330,{|| ctitGrdDI },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,150,009)

	else
		//granel
		oBmp8d      := TBitmap():New( 000,005,510,013,,"\images\azul.png",.T.,oFolder1:aDialogs[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay14d     := TSay():New( 001,200,{||ctitGrdDS },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,200,010)
		oBmp10d     := TBitmap():New( 121,005,510,013,,"\images\verde.png",.T.,oFolder1:aDialogs[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay16d     := TSay():New( 123,200,{||ctitGrdDI },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,200,009)

	endif


	oGrp1d      := TGroup():New( 245,006,285,257,"Legendas",oFolder1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBmp3d      := TBitmap():New( 257,007,008,008,,"\images\leg_amarelo.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oSay2d      := TSay():New( 258,017,{||"1-Pátio"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay3d      := TSay():New( 258,070,{||"2-Chamado"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay4d      := TSay():New( 258,145,{||"3-Pesado na Entrada"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay5d      := TSay():New( 271,017,{||"4-Início C/D"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay6d      := TSay():New( 271,070,{||"5-Aguardar Liberação"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay7d      := TSay():New( 271,145,{||"6-Em Espera"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay17d     := TSay():New( 258,220,{||"7-Pronto"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oSay18d     := TSay():New( 271,220,{||"8-Fat Granel"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
	oBmp2d      := TBitmap():New( 257,060,008,008,,"\images\leg_verde.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp4d      := TBitmap():New( 257,135,008,008,,"\images\leg_rosa.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp5d      := TBitmap():New( 270,007,008,008,,"\images\leg_azul.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp6d      := TBitmap():New( 270,060,008,008,,"\images\leg_preto.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp7d      := TBitmap():New( 270,135,008,008,,"\images\leg_vermelho.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oBmp17d     := TBitmap():New( 257,220,008,008,,"\images\leg_marrom.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F.)
	oBmp18d     := TBitmap():New( 270,220,008,008,,"\images\leg_laranja.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F.)
	oGrp2d      := TGroup():New( 245,261,285,512,"Estatísticas",oFolder1:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay8d      := TSay():New( 255,382,{||"Máximo Veículos no Pátio:"},oGrp2d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,085,008)
	oSay9d      := TSay():New( 265,382,{||"Máximo Veículos Carregando:"},oGrp2d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
	oSay10d     := TSay():New( 275,382,{||"Máximo Veículos Descarregando:"},oGrp2d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
	oSay11d     := TSay():New( 255,265,{||"Veículos no Pátio:"},oGrp2d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay12d     := TSay():New( 265,265,{||"Veículos Carregando:"},oGrp2d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,063,008)
	oSay13d     := TSay():New( 275,265,{||"Veículos Descarregando:"},oGrp2d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oVPd        := TGet():New( 252,339,{|u| If(PCount()>0,nVPD:=u,nVPD)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVPD",,)
	oVCd        := TGet():New( 262,339,{|u| If(PCount()>0,nVC:=u,nVC)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVC",,)
	oVDd        := TGet():New( 273,339,{|u| If(PCount()>0,nVD:=u,nVD)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVD",,)
	oMVDd       := TGet():New( 273,479,{|u| If(PCount()>0,nMVD:=u,nMVD)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVD",,)
	oMVCd       := TGet():New( 262,479,{|u| If(PCount()>0,nMVC:=u,nMVC)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVC",,)
	oMVPd       := TGet():New( 252,479,{|u| If(PCount()>0,nMVP:=u,nMVP)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVP",,)

	// Define o tamanho e as colunas dos browses.
	SMFATF49()

	if lusaCarrSaco
		oBrw1 := TCBrowse():New( 012,005,265,109,,waHeader,waColSizes,oFolder1:aDialogs[1],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw3 := TCBrowse():New( 134,005,265,109,,waHeader,waColSizes,oFolder1:aDialogs[1],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)

		oBrw2 := TCBrowse():New( 012,275,265,109,,waHeader,waColSizes,oFolder1:aDialogs[1],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw4 := TCBrowse():New( 134,275,265,109,,waHeader,waColSizes,oFolder1:aDialogs[1],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	else
		oBrw2 := TCBrowse():New( 012,005,530,109,,waHeader,waColSizes,oFolder1:aDialogs[1],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw4 := TCBrowse():New( 134,005,530,109,,waHeader,waColSizes,oFolder1:aDialogs[1],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	endif


	////descarregamento
	if lUsaDescSaco
		oBrw5 := TCBrowse():New( 012,005,251,109,,waHeader,waColSizes,oFolder1:aDialogs[2],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw7 := TCBrowse():New( 134,005,251,109,,waHeader,waColSizes,oFolder1:aDialogs[2],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)

		oBrw6 := TCBrowse():New( 012,262,251,109,,waHeader,waColSizes,oFolder1:aDialogs[2],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw8 := TCBrowse():New( 134,262,251,109,,waHeader,waColSizes,oFolder1:aDialogs[2],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	else
		oBrw6 := TCBrowse():New( 012,005,510,109,,waHeader,waColSizes,oFolder1:aDialogs[2],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw8 := TCBrowse():New( 134,005,510,109,,waHeader,waColSizes,oFolder1:aDialogs[2],,,,,{||},,oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	endif

	// Realiza a consulta para popular os browses
	U_SMFATA07(0)
	//SMFATC01()

	if luserFull
		if lusaCarrSaco
			oBrw1:blDBLClick:= {|| SMFATF50(@oBrw1)  }
			oBrw1:BSEEKCHANGE:= {|| SMFATF59(@oBrw1 ) }
			//oBrw1:BCHANGE := {|| Alert(oBrw1:aArray[oBrw1:nAT,7]) } comentado por Alexandro em 21/05/15
			oBrw1:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw1),oMenu01:Activate( X, Y, oObj )}

			oBrw3:blDBLClick:= {|| SMFATF50(@oBrw3) }
			oBrw3:BSEEKCHANGE:= {|| SMFATF59(@oBrw3 ) }
			oBrw3:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw3),oMenu01:Activate( X, Y, oObj )}
		endif

		oBrw2:blDBLClick:= {|| SMFATF50(@oBrw2) }
		oBrw2:BSEEKCHANGE:= {|| SMFATF59(@oBrw2 ) }
		oBrw2:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw2),oMenu01:Activate( X, Y, oObj )}

		oBrw4:blDBLClick:= {|| SMFATF50(@oBrw4) }
		oBrw4:BSEEKCHANGE:= {|| SMFATF59(@oBrw4 ) }
		oBrw4:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw4),oMenu01:Activate( X, Y, oObj )}


		if lusaDescSaco
			oBrw5:blDBLClick:= {|| SMFATF50(@oBrw5) }
			oBrw5:BSEEKCHANGE:= {|| SMFATF59(@oBrw5 ) }
			oBrw5:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw5),oMenu01:Activate( X, Y, oObj )}


			oBrw7:blDBLClick:= {|| SMFATF50(@oBrw7) }
			oBrw7:BSEEKCHANGE:= {|| SMFATF59(@oBrw7 ) }
			oBrw7:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw7),oMenu01:Activate( X, Y, oObj )}
		endif

		oBrw6:blDBLClick:= {|| SMFATF50(@oBrw6) }
		oBrw6:BSEEKCHANGE:= {|| SMFATF59(@oBrw6 ) }
		oBrw6:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw6),oMenu01:Activate( X, Y, oObj )}

		oBrw8:blDBLClick:= {|| SMFATF50(@oBrw8) }
		oBrw8:BSEEKCHANGE:= {|| SMFATF59(@oBrw8 ) }
		oBrw8:bRClicked:= {|oObj,X,Y| SMFATI01("Prov",oBrw8),oMenu01:Activate( X, Y, oObj )}




	endif


	//botoes laterais

	naltura:=009
	nnLin:= 015
	nEspaco:=10

	oSayNf      := TSay():New( nnLin ,545,{||"Nota Fiscal"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
	oBt_nfe      := TButton():New( nnLin+=nEspaco ,542,"NF-e Sefaz",oDlg1	, {||  SMFATF58('NFE')    }  ,050,naltura,,,,.T.,,"",,,,.F. )
	oBt_Mnt      := TButton():New( nnLin+=nEspaco ,542,"Monitor",oDlg1		, {||  u_SMFATF56('MNT')    } ,050,naltura,,,,.T.,,"",,,,.F. )
	oBt_Dan      := TButton():New( nnLin+=nEspaco ,542,"Danfe",oDlg1		, {||  u_SMFATF56('DAN')    } ,050,naltura,,,,.T.,,"",,,,.F. )
	oBt_Sta      := TButton():New( nnLin+=nEspaco ,542,"Status Sefaz",oDlg1		, {||  u_SMFATF56('STA')    } ,050,naltura,,,,.t.,,"",,,,.f. )
	oBt_Rem      := TButton():New( nnLin+=nEspaco ,542,"Transmisão",oDlg1		, {||   u_SMFATF56('REM')    } ,050,naltura,,,,.t.,,"",,,,.f. )

	nnLin+=10

	oSayVda      := TSay():New( nnLin+=nEspaco  ,545,{||"Pedido"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
	oBt_Ped      := TButton():New( nnLin+=nEspaco ,542,"Pedido Mizu" , oDlg1		, {||  SMFATF58('PED')   } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	oBt_Age      := TButton():New( nnLin+=nEspaco ,542,"Agenciamento" , oDlg1		, {||  SMFATF58('AGE')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	oBt_IOC      := TButton():New( nnLin+=nEspaco ,542,"Imp.Ord.Carreg" , oDlg1		, {||  SMFATF58('IOC')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )

	//Sergio (Semar) 19/05/2015 Não havera cancelamento de entrada quando a empresa utiizar as regras de rastreabilidade
	//if !(cEmpAnt $ cEmpRastroOC)	//Comentado por Rodrgio (Semar) 21/06/16
	if !(cEmpAnt + cFilAnt $ cEmpRastroOC)
		oBt_CEN    := TButton():New( nnLin+=nEspaco ,542,"Cancela Entrada" , oDlg1		, {||  SMFATF58('CEN')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	endif

	oBt_LAC      := TButton():New( nnLin+=nEspaco ,542,"Lacre" , oDlg1		, {||  SMFATF58('LAC')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	//
	//if cEmpAnt $ '01'	 //Comentado por Rodrigo (Semar) - 21/06/16
	if cEmpAnt + cFilAnt $ '0101|0218'
		oBt_RPE      := TButton():New( nnLin+=nEspaco ,542,"Recup.Pes.Ent." , oDlg1		, {||  SMFATF58('RPE')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	endif

	If cFilAnt $ SuperGetMV('MZ_GESTPED',,'')
		oBt_GPe      := TButton():New( nnLin+=nEspaco ,542,"Gestão Pedidos" , oDlg1		, {||  U_MZ0223()    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	Endif
	//Ticket
	nnLin+=10

	//if cEmpAnt $ '30'	//Comentado por Rodrgio (Semar) - 21/06/16
	if cEmpAnt + cFilAnt $ '3001|0210'
		oSayTic      := TSay():New( nnLin+=nEspaco  ,545,{||"Imp. Ticket"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
		oBt_TIC1      := TButton():New( nnLin+=nEspaco ,542,"Ticket Balanca" , oDlg1	, {||  SMFATF58('TK1')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
		oBt_TIC2      := TButton():New( nnLin+=nEspaco ,542,"Ticket Bal. Ent/Sai" , oDlg1	, {||  SMFATF58('TK2')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	endif



	nnLin+=10

	oSayVda      := TSay():New( nnLin+=nEspaco  ,545,{||"Cadastro"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
	oBt_Cli      := TButton():New( nnLin+=nEspaco ,542,"Cliente" , oDlg1		, {||  SMFATF58('CLI')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	oBt_Mot      := TButton():New( nnLin+=nEspaco ,542,"Motorista" , oDlg1		, {||  SMFATF58('MOT')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	oBt_Tra      := TButton():New( nnLin+=nEspaco ,542,"Transportador" , oDlg1		, {||  SMFATF58('TRA')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	oBt_Cam      := TButton():New( nnLin+=nEspaco ,542,"Caminhão" , oDlg1		, {||  SMFATF58('CAM')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	oBt_Car      := TButton():New( nnLin+=nEspaco ,542,"Carreta" , oDlg1		, {||  SMFATF58('CAR')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )



	//oBt_Pag      := TButton():New( nnLin+=nEspaco ,542,"P a g e r" , oDlg1		, {||  SMFATF58('PAG')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
	oBt_Por      := TButton():New( nnLin+=nEspaco ,542,"Portaria"  , oDlg1		, {||  U_SMFATT40()    } ,050,naltura,,          ,,.T.,,"",,,,.F. )

	//oImg_Semar   := TBitmap():New( nnLin+=30,538,260,184,,"\Imagens\semar3.png",.T.,oDlg1,,,.F.,.F.,,,.F.,,.T.,,.F.)
	if !luserFull

		oBt_nfe:disable()
		oBt_nfe:disable()
		oBt_Mnt:disable()
		oBt_Dan:disable()
		oBt_Sta:disable()
		oBt_Rem:disable()

		//oBt_Ped:disable()
		//oBt_Age:disable()

		oBt_Cli:disable()

		//oBt_Pag:disable()
		oBt_Por:disable()

		/*
		oBt_Mot:disable()
		oBt_Tra:disable()
		oBt_Cam:disable()
		oBt_Car:disable()
		*/

	endif




	//oBtn := TButton():New( 250,500, 'lEditCell (Edita a celula)', ,oFolder1:aDialogs[1]], {|| lEditCell(@aList,oBrw2,'@!',3) }, 90, 010,,,.F.,.T.,.F.,,.F.,,,.F. )

	//nTimeMsg  := 6000
	//oTimer:= TTimer():New((nTimeMsg),{|| Alert("A cada 1 minuto atualiza os status.... atualizou!") },,oDlg1) // Ativa timer
	//oTimer:Activate()

	//DEFINE TIMER oTimer INTERVAL 1 ACTION ALERT('EXECUTOU O TIMER') OF oDlg1
	//oTimer:Activate()

	Set Key VK_F12 TO getSX1()

	Set Key VK_F5 TO U_SMFATA07()



	oDlg1:Activate(,,,.T.)

	Set Key VK_F5 TO


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF49                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Funcao que monta aHeader e Monta Area de Trabalho          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF49()

	DbSelectArea("SX3")
	DbSetOrder(2) // Nome Campo

	//if cEmpAnt $ '30|01|40' // EMPRESA 40	// Comentado por Rodrigo (Semar) - 21/06/16
	if cEmpAnt+cFilAnt $ '3001|0210|0101|0218|4001|0203' // EMPRESA 40
		dbSeek("Z8_STATUS2");aAdd(waHeader, " ") 			 ; aAdd(waColSizes,1)
	else
		dbSeek("Z8_STATUS");aAdd(waHeader, " ")				 ; aAdd(waColSizes,1)
	endif
	dbSeek("Z8_HRAGENC"); 	aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)

	//define a posicao 3 do array
	// para vitoria é o campo HORA PESO
	//###############################
	//if cEmpAnt $ '01|11|30|40' // EMPRESA 40	//Comentado por Rodrgio (Semar) 21/06/16
	if cEmpAnt + cFilAnt $ '0101|0218|1101|0213|3001|0210|4001|0203' // EMPRESA 40
		dbSeek("Z8_HORPES");	aAdd(waHeader, "Hr.P.Ent")			 ; aAdd(waColSizes,20)
	else
		//If cEmpant $ '20' .And. cFilAnt == "04"
		If cEmpant + cFilAnt $ '2004|0222' 		// EMPRESA 02
			dbSeek("Z8_HORPES");	aAdd(waHeader, "Hr.P.Ent")			 ; aAdd(waColSizes,20)
		Else
			dbSeek("Z8_PAGER");	aAdd(waHeader, "Pager")			 ; aAdd(waColSizes,20)
		Endif
	endif
	//###############################

	dbSeek("Z8_PLACA");	aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
	dbSeek("Z8_MOTOR");	aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,100)
	dbSeek("Z8_PSENT");	aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,30)
	dbSeek("Z8_OC");	aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
	dbSeek("Z8_PALLET"); aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
	dbSeek("Z1_FRETE"); aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
	//if cEmpAnt == "30" .AND. SZZ->(FIELDPOS("ZZ_CACAMBA")) > 0	//Comentado por Rodrigo (Semar) 21/06/16
	if (cEmpAnt + cFilAnt $ "3001|0210") .AND. SZZ->(FIELDPOS("ZZ_CACAMBA")) > 0
		dbSeek("ZZ_CACAMBA"); aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
	else
		dbSeek("Z8_CILINDR"); aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
	endif

	//define a posicao 11 do array
	// para vitoria é o campo PAGER
	//###############################
	//If cEmpAnt $ '01|11|30|40' // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	If cEmpAnt + cFilAnt $ '0101|0218|1101|0213|3001|0210|4001|0203' // EMPRESA 40
		dbSeek("Z8_PAGER");	aAdd(waHeader, "Pager")			 ; aAdd(waColSizes,20)
	Else
		//If cEmpAnt $ '20' .And. cFilAnt == "04"
		If cEmpant + cFilAnt $ '2004|0222' 		// EMPRESA 02
			dbSeek("Z8_PAGER");	aAdd(waHeader, "Pager")			 ; aAdd(waColSizes,20)
		Else
			dbSeek("Z8_HORPES");	aAdd(waHeader, "Hr.P.Ent")			 ; aAdd(waColSizes,20)
		Endif
	Endif
	//###############################

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATC01                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATC01()

	Local aAreaAtu := GetArea()
	Local cCores1
	Local cCores2
	Local cCores3
	Local cCores4
	Local cCores5
	Local cCores6
	Local cCores7
	Local cCores8
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40   //Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat	:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40
	Local aCPG := {}, aCFG := {}
	Local aCPS := {}, aCFS := {}
	Local aDPS := {}, aDFS := {}
	Local aDPG := {}, aDFG := {}
	aList1	  := {}
	aList2	  := {}
	aList3	  := {}
	aList4	  := {}
	aList5	  := {}
	aList6	  := {}
	aList7	  := {}
	aList8	  := {}

	nVPC	    := 0
	nVPD       := 0
	nVC        := 0
	nVD        := 0

	cz1Frete:= ''

	cColuna03:=''
	ccampo03:=''
	cColuna11:=''
	ccampo11:=''


	cSQL := "SELECT "+cStat+", Z8_HRAGENC, Z8_PAGER, Z8_PLACA, Z8_NOMMOT, Z8_PSENT, Z8_OC, "
	cSQL += " Z8_TPOPER, Z8_SACGRA , Z8_IHM, Z8_PALLET, Z8_CILINDR, LEFT(Z8_CATEGMP,2) AS Z8_CATEGMP, Z8_HORPES "
	cSQL += " FROM "+RetSqlName("SZ8") +" SZ8 "
	cSQL += " WHERE Z8_DATA >= '"+DTOS(dDataBase-20)+"' "
	//cSQL += " WHERE Z8_DATA   <= '" +DTOS(dDataBase)+ "'" //Marcus Vinicius - 13/03/2018 - Ajustado validação de data para buscar apenas os ultimos 20 dias
	//cSQL += " AND   "+cStat+" <= '9'"
	cSQL += " AND   Z8_FATUR <> 'S'" // NAO FATURADOS
	cSQL += " AND   SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '" + xFilial("SZ8") + "' "
	cSQL += " ORDER BY Z8_DATA, Z8_HORA "


	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), "SZ8001", .F., .T.)

	DbSelectArea("SZ8001")

	While SZ8001->(!EOF())

		aListAux := {}

		cColuna03:=''
		ccampo03:=''

		cColuna11:=''
		ccampo11:=''

		do case
			//case cEmpAnt $ '01|11|30|40' // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
			case cEmpAnt + cFilAnt $ '0101|0218|1101|0213|3001|0210|4001|0203' // EMPRESA 40
			cColuna03:=SZ8001->Z8_HORPES
			ccampo03 := 'Z8_HORPES'

			cColuna11:=SZ8001->Z8_PAGER
			ccampo11 := 'Z8_PAGER'

			otherwise
			//If cEmpAnt $ '20' .And. cFilAnt == "04"
			If cEmpant + cFilAnt $ '2004|0222' 		// EMPRESA 02
				cColuna03:=SZ8001->Z8_HORPES
				ccampo03 := 'Z8_HORPES'

				cColuna11:=SZ8001->Z8_PAGER
				ccampo11 := 'Z8_PAGER'
			Else
				cColuna03:=SZ8001->Z8_PAGER
				ccampo03 := 'Z8_PAGER'

				cColuna11:=SZ8001->Z8_HORPES
				ccampo11 := 'Z8_HORPES'
			Endif
		endcase

		if SZ8001->&(cStat) == "9"
			cz1Frete := Posicione("SZ7",8,xFilial("SZ7")+SZ8001->Z8_OC,"Z7_FRETE")
		else
			cz1Frete := Posicione("SZ1",8,xFilial("SZ1")+SZ8001->Z8_OC,"Z1_FRETE")
		endif
		cCilindro:= iif( SZ8001->Z8_CILINDR=='1', 'S','N')

		aListAux := {SZ8001->&(cStat),SZ8001->Z8_HRAGENC,cColuna03,SZ8001->Z8_PLACA,SUBSTR(SZ8001->Z8_NOMMOT,1,30),SZ8001->Z8_PSENT, SZ8001->Z8_OC, SZ8001->Z8_PALLET, cz1Frete, cCilindro, cColuna11}

		do case
			case SZ8001->Z8_TPOPER == "C" .AND. SZ8001->Z8_SACGRA == "G" .AND. SZ8001->&(cStat) $ '1/2/7/A' 						//CARREGAMENTO PATIO GRANEL
			AADD(aCPG,aListAux)
			case SZ8001->Z8_TPOPER == "C" .AND. SZ8001->Z8_SACGRA == "G" .AND. SZ8001->&(cStat) $ '3/4/5/6/8/9/L'					//CARREGAMENTO FABRICA GRANEL
			AADD(aCFG,aListAux)
			case SZ8001->Z8_TPOPER == "C" .AND. SZ8001->Z8_SACGRA == "S" .AND. SZ8001->&(cStat) $ '1/2/7/A'						//CARREGAMENTO PATIO SACO
			AADD(aCPS,aListAux)
			case SZ8001->Z8_TPOPER == "C" .AND. SZ8001->Z8_SACGRA == "S" .AND. SZ8001->&(cStat) $ '3/4/5/6/F/8/9'						//CARREGAMENTO FABRICA SACO
			AADD(aCFS,aListAux)
			case SZ8001->Z8_TPOPER == "D" .AND. SZ8001->Z8_SACGRA == "S" .AND. lUsaDescSaco .AND. SZ8001->Z8_CATEGMP =='CP';
			.AND. SZ8001->&(cStat) $ '1/2' 																						//DESCARREGAMENTO PATIO SACO
			AADD(aDPS,aListAux)
			case SZ8001->Z8_TPOPER == "D" .AND. SZ8001->Z8_SACGRA == "S" .AND. lUsaDescSaco .AND. SZ8001->Z8_CATEGMP =='CP';
			.AND. SZ8001->&(cStat) > '2' 																						//DESCARREGAMENTO FABRICA SACO
			AADD(aDFS,aListAux)
			case SZ8001->Z8_TPOPER == "D" .AND. SZ8001->Z8_SACGRA == "G" .AND. SZ8001->Z8_CATEGMP =='EM';
			.AND. SZ8001->&(cStat) $ '1/2'  																					//DESCARREGAMENTO PATIO GRANEL
			AADD(aDPG,aListAux)
			case SZ8001->Z8_TPOPER == "D" .AND. SZ8001->Z8_SACGRA == "G" .AND. SZ8001->Z8_CATEGMP =='EM';
			.AND. SZ8001->&(cStat) $ '3/4/5/6/8/9/L' 																			//DESCARREGAMENTO FABRICA GRANEL
			AADD(aDFG,aListAux)
		endcase

		SZ8001->(DbSkip())
	End
	SZ8001->(DbCloseArea())
	/*
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aCPG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aCFG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aCPS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aCFS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aDPS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aDFS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aDPG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001',SMFATFX01(@aDFG,9,'F|C| '),)
	*/
	/*
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aCPG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aCFG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aCPS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aCFS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aDPS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aDFS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aDPG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001/4001',SMFATFX01(@aDFG,9,'F|C| '),)
	*/ //Comentado por Rodrigo (Semar) - 21/06/16
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aCPG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aCFG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aCPS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aCFS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aDPS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aDFS,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aDPG,9,'F|C| '),)
	if(cEmpAnt+cFilAnt $ '3001|0210|4001|0203',SMFATFX01(@aDFG,9,'F|C| '),)


	//CARREGAMENTO PATIO GRANEL
	aList2 := aCPG
	nVPC += LEN(aCPG)

	//CARREGAMENTO FABRICA GRANEL
	aList4 := aCFG
	nVC += LEN(aCFG)

	// CARREGAMENTO PATIO SACO
	aList1 := aCPS
	nVPC += LEN(aCPS)

	// CARREGAMENTO FABRICA SACO
	aList3 := aCFS
	nVC += LEN(aCFS)

	// DESCARREGAMENTO PATIO GRANEL
	aList6 := aDPG
	nVPD += LEN(aDPG)

	// DESCARREGAMENTO FABRICA GRANEL
	aList8 := aDFG
	nVD += LEN(aDFG)

	if lUsaDescSaco
		// DESCARREGAMENTO PATIO SACO
		aList5 := aDPS
		nVPD += LEN(aDPS)

		// DESCARREGAMENTO FABRICA SACO
		aList7 := aDFS
		nVD += LEN(aDFS)
	endif

	If Len(aList1) = 0 .and.  lUsaCarrSaco
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList1, aListAux)
	EndIf
	If Len(aList2) = 0
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList2, aListAux)
	EndIf
	If Len(aList3) = 0 .and.  lUsaCarrSaco
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList3, aListAux)
	EndIf
	If Len(aList4) = 0
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList4, aListAux)
	EndIf
	If Len(aList5) = 0 .and.  lUsaDescSaco
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList5, aListAux)
	EndIf
	If Len(aList6) = 0
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList6, aListAux)
	EndIf
	If Len(aList7) = 0 .and.  lUsaDescSaco
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList7, aListAux)
	EndIf
	If Len(aList8) = 0
		aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar(cCampo03),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
		aAdd(aList8, aListAux)
	EndIf

	// Seta a fonte de dados do browse
	if lusaCarrSaco
		oBrw1:SetArray(aList1)
		oBrw3:SetArray(aList3)
	endif

	oBrw2:SetArray(aList2)
	oBrw4:SetArray(aList4)


	if lusadescSaco
		oBrw5:SetArray(aList5)
		oBrw7:SetArray(aList7)
	endif
	oBrw6:SetArray(aList6)
	oBrw8:SetArray(aList8)

	//Variavel auxiliar para determinar a condicao das cores na primeira coluna do browse

	cCond5:=" oBrw4:aArray[oBrw4:nAt,01]='3' .and.  oBrw4:aArray[oBrw4:nAt,06]=0 .and. !empty( posicione('SZ8',1,xfilial('SZ8')+oBrw4:aArray[oBrw4:nAt,07],'Z8_IHM') )  "


	cCores1 :=	"If(oBrw1:aArray[oBrw1:nAt,01]=' ',oBranco,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='A',oCinz,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='1',oAmarelo,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='2',oVerde,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='3',oPink,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='4',oAzul,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='5',oCinza,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='7',oMarrom,"+;
	"If(oBrw1:aArray[oBrw1:nAt,01]='6',oVermelho,'')))))))))"

	cCores2 :=	"If(oBrw2:aArray[oBrw2:nAt,01]=' ',oBranco,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='A',oCinz,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='1',oAmarelo,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='2',oVerde,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='3',oPink,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='4',oAzul,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='5',oCinza,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='7',oMarrom,"+;
	"If(oBrw2:aArray[oBrw2:nAt,01]='6',oVermelho,'')))))))))"

	cCores3 :=	"If(oBrw3:aArray[oBrw3:nAt,01]=' ',oBranco,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='A',oCinz,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='1',oAmarelo,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='2',oVerde,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='3',oPink,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='4',oAzul,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='5',oCinza,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='F',oCinzaLona,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='8',oLaranja,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='9',oLarNF,"+;
	"If(oBrw3:aArray[oBrw3:nAt,01]='6',oVermelho,'')))))))))))"

	/*cCores4 :=	"If(oBrw4:aArray[oBrw4:nAt,01]=' ',oBranco,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='1',oAmarelo,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='2',oVerde,"+;
	"If("+cCond5+",oCinza,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='3',oPink,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='4',oAzul,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='6',oVermelho,'')))))))" */

	cCores4 :=	"If(oBrw4:aArray[oBrw4:nAt,01]=' ',oBranco,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='A',oCinz,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='1',oAmarelo,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='2',oVerde,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='3',oPink,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='4',oAzul,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='5',oCinza,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='6' .AND. !EMPTY(oBrw4:aArray[oBrw4:nAt,11]),oVermelho,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='8',oLaranja,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='9',oLarNF,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='L',oLibSens,"+;
	"If(oBrw4:aArray[oBrw4:nAt,01]='6' .AND. EMPTY(oBrw4:aArray[oBrw4:nAt,11]),oVermAtt,''))))))))))))"

	cCores5 :=	"If(oBrw5:aArray[oBrw5:nAt,01]=' ',oBranco,"+;
	"If(oBrw5:aArray[oBrw5:nAt,01]='A',oCinz,"+;
	"If(oBrw5:aArray[oBrw5:nAt,01]='1',oAmarelo,"+;
	"If(oBrw5:aArray[oBrw5:nAt,01]='2',oVerde,"+;
	"If(oBrw5:aArray[oBrw5:nAt,01]='3',oPink,"+;
	"If(oBrw5:aArray[oBrw5:nAt,01]='4',oAzul,"+;
	"If(oBrw5:aArray[oBrw5:nAt,01]='5',oCinza,"+;
	"If(oBrw5:aArray[oBrw5:nAt,01]='6',oVermelho,''))))))))"

	cCores6 :=	"If(oBrw6:aArray[oBrw6:nAt,01]=' ',oBranco,"+;
	"If(oBrw6:aArray[oBrw6:nAt,01]='A',oCinz,"+;
	"If(oBrw6:aArray[oBrw6:nAt,01]='1',oAmarelo,"+;
	"If(oBrw6:aArray[oBrw6:nAt,01]='2',oVerde,"+;
	"If(oBrw6:aArray[oBrw6:nAt,01]='3',oPink,"+;
	"If(oBrw6:aArray[oBrw6:nAt,01]='4',oAzul,"+;
	"If(oBrw6:aArray[oBrw6:nAt,01]='5',oCinza,"+;
	"If(oBrw6:aArray[oBrw6:nAt,01]='6',oVermelho,''))))))))"

	cCores7 :=	"If(oBrw7:aArray[oBrw7:nAt,01]=' ',oBranco,"+;
	"If(oBrw7:aArray[oBrw7:nAt,01]='A',oCinz,"+;
	"If(oBrw7:aArray[oBrw7:nAt,01]='1',oAmarelo,"+;
	"If(oBrw7:aArray[oBrw7:nAt,01]='2',oVerde,"+;
	"If(oBrw7:aArray[oBrw7:nAt,01]='3',oPink,"+;
	"If(oBrw7:aArray[oBrw7:nAt,01]='4',oAzul,"+;
	"If(oBrw7:aArray[oBrw7:nAt,01]='5',oCinza,"+;
	"If(oBrw7:aArray[oBrw7:nAt,01]='6',oVermelho,''))))))))"

	/*cCores8 :=	"If(oBrw8:aArray[oBrw8:nAt,01]=' ',oBranco,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='A',oCinz,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='1',oAmarelo,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='2',oVerde,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='3',oPink,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='4',oAzul,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='5',oCinza,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='6',oVermelho,''))))))))"*/

	cCores8 :=	"If(oBrw8:aArray[oBrw8:nAt,01]=' ',oBranco,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='A',oCinz,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='1',oAmarelo,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='2',oVerde,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='3',oPink,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='4',oAzul,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='5',oCinza,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='6' .AND. !EMPTY(oBrw8:aArray[oBrw8:nAt,11]),oVermelho,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='8',oLaranja,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='9',oLarNF,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='L',oLibSens,"+;
	"If(oBrw8:aArray[oBrw8:nAt,01]='6' .AND. EMPTY(oBrw8:aArray[oBrw8:nAt,11]),oVermAtt,''))))))))))))"

	//Define o conteudo de cada coluna do browse
	If lUsaCarrSaco .and.  Len(oBrw1:aArray) <> 0
		oBrw1:bLine := {|| { &cCores1,oBrw1:aArray[oBrw1:nAt,02],;
		oBrw1:aArray[oBrw1:nAt,03],;
		oBrw1:aArray[oBrw1:nAT,04],;
		oBrw1:aArray[oBrw1:nAT,05],;
		Transform(aList1[oBrw1:nAT,06],'@E 99,999.999'),;
		oBrw1:aArray[oBrw1:nAT,07],;
		oBrw1:aArray[oBrw1:nAT,08],;
		oBrw1:aArray[oBrw1:nAT,09],;
		oBrw1:aArray[oBrw1:nAT,10],;
		oBrw1:aArray[oBrw1:nAT,11]  }}
	EndIf

	If Len(oBrw2:aArray) <> 0
		oBrw2:bLine := {|| { &cCores2, oBrw2:aArray[oBrw2:nAt,02],;
		oBrw2:aArray[oBrw2:nAt,03],;
		oBrw2:aArray[oBrw2:nAT,04],;
		oBrw2:aArray[oBrw2:nAT,05],;
		Transform(oBrw2:aArray[oBrw2:nAT,06],'@E 99,999.999'),;
		oBrw2:aArray[oBrw2:nAT,07],;
		oBrw2:aArray[oBrw2:nAT,08],;
		oBrw2:aArray[oBrw2:nAT,09],;
		oBrw2:aArray[oBrw2:nAT,10],;
		oBrw2:aArray[oBrw2:nAT,11]  }}
	EndIf

	If lUsaCarrSaco .and.   Len(oBrw3:aArray) <> 0
		oBrw3:bLine := {|| { &cCores3, oBrw3:aArray[oBrw3:nAt,02],;
		oBrw3:aArray[oBrw3:nAt,03],;
		oBrw3:aArray[oBrw3:nAT,04],;
		oBrw3:aArray[oBrw3:nAT,05],;
		Transform(oBrw3:aArray[oBrw3:nAT,06],'@E 99,999.999'),;
		oBrw3:aArray[oBrw3:nAT,07],;
		oBrw3:aArray[oBrw3:nAT,08],;
		oBrw3:aArray[oBrw3:nAT,09],;
		oBrw3:aArray[oBrw3:nAT,10],;
		oBrw3:aArray[oBrw3:nAT,11]  }}
	EndIf

	If Len(oBrw4:aArray) <> 0
		oBrw4:bLine := {|| { &cCores4, oBrw4:aArray[oBrw4:nAt,02],;
		oBrw4:aArray[oBrw4:nAt,03],;
		oBrw4:aArray[oBrw4:nAT,04],;
		oBrw4:aArray[oBrw4:nAT,05],;
		Transform(oBrw4:aArray[oBrw4:nAT,06],'@E 99,999.999'),;
		oBrw4:aArray[oBrw4:nAT,07],;
		oBrw4:aArray[oBrw4:nAT,08],;
		oBrw4:aArray[oBrw4:nAT,09],;
		oBrw4:aArray[oBrw4:nAT,10],;
		oBrw4:aArray[oBrw4:nAT,11] 	 }}
	EndIf

	If lUsaDescSaco .and. Len(oBrw5:aArray) <> 0
		oBrw5:bLine := {|| { &cCores5, oBrw5:aArray[oBrw5:nAt,02],;
		oBrw5:aArray[oBrw5:nAt,03],;
		oBrw5:aArray[oBrw5:nAT,04],;
		oBrw5:aArray[oBrw5:nAT,05],;
		Transform(oBrw5:aArray[oBrw5:nAT,06],'@E 99,999.999'),;
		oBrw5:aArray[oBrw5:nAT,07],;
		oBrw5:aArray[oBrw5:nAT,08],;
		oBrw5:aArray[oBrw5:nAT,09],;
		oBrw5:aArray[oBrw5:nAT,10],;
		oBrw5:aArray[oBrw5:nAT,11] 	 }}
	EndIf

	If Len(oBrw6:aArray) <> 0
		oBrw6:bLine := {|| { &cCores6, oBrw6:aArray[oBrw6:nAt,02],;
		oBrw6:aArray[oBrw6:nAt,03],;
		oBrw6:aArray[oBrw6:nAT,04],;
		oBrw6:aArray[oBrw6:nAT,05],;
		Transform(oBrw6:aArray[oBrw6:nAT,06],'@E 99,999.999'),;
		oBrw6:aArray[oBrw6:nAT,07],;
		oBrw6:aArray[oBrw6:nAT,08],;
		oBrw6:aArray[oBrw6:nAT,09],;
		oBrw6:aArray[oBrw6:nAT,10],;
		oBrw6:aArray[oBrw6:nAT,11] 	 }}
	EndIf

	If lUsaDescSaco .and. Len(oBrw7:aArray) <> 0
		oBrw7:bLine := {|| { &cCores7, oBrw7:aArray[oBrw7:nAt,02],;
		oBrw7:aArray[oBrw7:nAt,03],;
		oBrw7:aArray[oBrw7:nAT,04],;
		oBrw7:aArray[oBrw7:nAT,05],;
		Transform(oBrw7:aArray[oBrw7:nAT,06],'@E 99,999.999'),;
		oBrw7:aArray[oBrw7:nAT,07],;
		oBrw7:aArray[oBrw7:nAT,08],;
		oBrw7:aArray[oBrw7:nAT,09],;
		oBrw7:aArray[oBrw7:nAT,10],;
		oBrw7:aArray[oBrw7:nAT,11] 	 }}
	EndIf

	If Len(oBrw8:aArray) <> 0
		oBrw8:bLine := {|| { &cCores8, oBrw8:aArray[oBrw8:nAt,02],;
		oBrw8:aArray[oBrw8:nAt,03],;
		oBrw8:aArray[oBrw8:nAT,04],;
		oBrw8:aArray[oBrw8:nAT,05],;
		Transform(oBrw8:aArray[oBrw8:nAT,06],'@E 99,999.999'),;
		oBrw8:aArray[oBrw8:nAT,07],;
		oBrw8:aArray[oBrw8:nAT,08],;
		oBrw8:aArray[oBrw8:nAT,09],;
		oBrw8:aArray[oBrw8:nAT,10],;
		oBrw8:aArray[oBrw8:nAT,11] }}
	EndIf

	if lusaCarrSaco
		oBrw1:Refresh()
		oBrw3:Refresh()
	endif
	oBrw2:Refresh()
	oBrw4:Refresh()

	if lusaDescSaco
		oBrw5:Refresh()
		oBrw7:Refresh()
	endif

	oBrw6:Refresh()
	oBrw8:Refresh()

	//u_SMFATA01(,,"E")
	//u_SMFATA01(,,"C")
	//u_SMFATF75()

	RestArea(aAreaAtu)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF50                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF50(oBrwAux)

	Local cHora
	Local cPlacaCar
	Local cMotorCar
	//Local cStatFat	:= if(cEmpAnt $ '30|01|40',"6","B") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStatFat	:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"6","B") // EMPRESA 40
	//Local lUsaSeri  := if(cEmpAnt $ '01',.T.,.F.)	//Comentado por Rodrigo (Semar) - 21/06/16
	Local lUsaSeri  := if(cEmpAnt + cFilAnt $ '0101|0218',.T.,.F.)
	If Len(oBrwAux:aArray) = 0
		Return
	EndIf
	cHora     := oBrwAux:aArray[oBrwAux:nAT,2]
	cPlacaCar := oBrwAux:aArray[oBrwAux:nAT,4]
	cMotorCar := oBrwAux:aArray[oBrwAux:nAT,5]

	If !u_ChkAcesso("SMFATF50",6,.F.)          // Marcus Vinicius - 26/09/2017 - Controle de acesso para bloquear transportadora
		Return
	EndIf

	dbSelectArea("SZ8")
	dbsetorder(1)
	dbSeek(xFilial("SZ8")+oBrwAux:aArray[oBrwAux:nAT,7]) //Posiciona na OC para faturar

	lCarrGranel:= (sz8->z8_sacgra=='G') .AND. (sz8->z8_tpoper=='C')

	//lSemPeso:= lCarrGranel .and. (oBrwAux:aArray[oBrwAux:nAT,1] == "2")  .and. cEmpAnt $ '20'

	lSemPeso:= lCarrGranel .and. (oBrwAux:aArray[oBrwAux:nAT,1] == "2")  .and. cEmpant + cFilAnt $ '2001|2004|0222|0223' 	// EMPRESA 02

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg2","oSay1","oSay2","oSay3","oBtGranel","oBtn2","oBtn3","oGet1","oGet2","oGet3","cStatus")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg2      := MSDialog():New( 241,349,383,729,"Operações",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 018,012,{||"Placa"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay2      := TSay():New( 031,012,{||"Motorista"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay3      := TSay():New( 005,012,{||"Hora"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	cStatus    := oBrwAux:aArray[oBrwAux:nAT,1]

	If oBrwAux:aArray[oBrwAux:nAT,1] == "1"
		oBtn2  := TButton():New( 050,069,"Chamar no Pager",oDlg2,{|| MsAguarde({|| SMFATF53(@oBrwAux,1), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn2,"SMFATF53",SZ8->Z8_TPOPER+"1",aPerfil)
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] == "2"
		oBtn1  := TButton():New( 050,010,iif(cStatus="2","Cancelar Chamar","Cancelar Chamar 2"),oDlg2,{|| MsAguarde({|| SMFATF53(@oBrwAux,VAL(cStatus)), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn1,"SMFATF53",SZ8->Z8_TPOPER+"2",aPerfil)
		oBtn2  := TButton():New( 050,069,iif(!lCarrGranel.or.!lSemPeso, "Pesar", "S/ Peso" ),oDlg2,{|| MsAguarde( {|| SMFATF51(@oBrwAux,lCarrGranel,lSemPeso,,lUsaSeri) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn2,"SMFATF51",SZ8->Z8_TPOPER+if(!lCarrGranel.or.!lSemPeso,"1","3"),aPerfil)
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] == "A"
		oBtn2  := TButton():New( 050,010,"Cancelar Portaria",oDlg2,{|| MsAguarde({|| SMFATF96(@oBrwAux,2,cStatus), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn2,"SMFATF96","",aPerfil)
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] == "7"
		oBtn1  := TButton():New( 050,010,iif(cStatus="2","Cancelar Chamar","Cancelar Chamar 2"),oDlg2,{|| MsAguarde({|| SMFATF53(@oBrwAux,VAL(cStatus)), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn1,"SMFATF53",SZ8->Z8_TPOPER+"2",aPerfil)
		oBtn2  := TButton():New( 050,069,iif(!lCarrGranel.or.!lSemPeso, "Pesar", "S/ Peso" ),oDlg2,{|| MsAguarde( {|| SMFATF51(@oBrwAux,lCarrGranel,lSemPeso,,lUsaSeri) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn2,"SMFATF51",SZ8->Z8_TPOPER+"1",aPerfil)
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] $ "6/8"
		If SZ8->Z8_TPOPER == "C"
			//if cEmpAnt == "30" .AND. EMPTY(SZ8->Z8_DTSAIDA)	//Comentado por Rodrigo (Semar) - 21/06/16
			if (cEmpAnt + cFilAnt $ "3001|0210|0101|0218") .AND. EMPTY(SZ8->Z8_DTSAIDA)
				oBtn1  := TButton():New( 050,010,"Pesar Saída",oDlg2,{|| MsAguarde( {|| SMFATF52(@oBrwAux, lCarrGranel, lUsaSeri) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
				u_trataLiberacao(oBtn1,"SMFATF52","C1",aPerfil)
			endif
			oBtn2  := TButton():New( 050,069,"Faturar",oDlg2,{|| SMFATF54(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
			u_trataLiberacao(oBtn2,"SMFATF54","",aPerfil)
		ElseIf SZ8->Z8_TPOPER == "D"

			oBtn1  := TButton():New( 050,010,"Pesar Saída",oDlg2,{|| MsAguarde( {|| SMFATF52(@oBrwAux, lCarrGranel, lUsaSeri) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			u_trataLiberacao(oBtn1,"SMFATF52","D1",aPerfil)
			// ESSA É FORMA COMPLETA DO COMANDO. ALTERADO ATÉ DEFINICAO DO USU DA PRE-NOTA
			//oBtn2  := TButton():New( 050,069,"Pré-Nota"   ,oDlg2,{|| MsAguarde( {|| ExecBlock("MIZ993",.F.,.F.,SZ8->Z8_OC),oDlg2:End(),SMFATC01() },"Pré-Nota...") },055,015,,,,.T.,,"",,,,.F. )
		EndIf
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] = "9"
		oBtn2  := TButton():New( 050,069,"Nota Entregue",oDlg2,{|| NOTAENTREGUE(@oBrwAux),oDlg2:End() },055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn2,"NOTAENTREGUE","",aPerfil)
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] $ "5/4/F"
		if luserFull .and. ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  )
			oBtn2  := TButton():New( 050,010,"Status Sigex",oDlg2,{|| SMFATA08(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
			u_trataLiberacao(oBtn2,"SMFATA08","",aPerfil)
		endif
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] == "3"
		if luserFull .and. ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  )
			oBtn1  := TButton():New( 050,010,"Status Sigex",oDlg2,{|| SMFATA08(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
			u_trataLiberacao(oBtn1,"SMFATA08","",aPerfil)
		endif

		if  ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  )
			oBtn2  := TButton():New( 050,069,"Cancelar Peso",oDlg2,{|| MsAguarde( {|| SMFATF51(@oBrwAux,lCarrGranel,lSemPeso,2,lUsaSeri) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			u_trataLiberacao(oBtn2,"SMFATF51",SZ8->Z8_TPOPER+"2",aPerfil)
		elseif lCarrGranel
			oBtn2  := TButton():New( 050,069,"Captura Peso",oDlg2,{|| MsAguarde( {|| SMFATF51(@oBrwAux,lCarrGranel, lSemPeso,,lUsaSeri) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			u_trataLiberacao(oBtn2,"SMFATF51",SZ8->Z8_TPOPER+"1",aPerfil)
		endif
	ElseIf oBrwAux:aArray[oBrwAux:nAT,1] == "L"
		oBtn1  := TButton():New( 050,010,"Cancelar",oDlg2,{|| U_BTN_LIBERAR(@oBrwAux,.F.),oDlg2:End() },055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn1,"U_BTN_LIBERAR",SZ8->Z8_TPOPER+"1",aPerfil)
		oBtn2  := TButton():New( 050,069,"Liberar",oDlg2,{|| U_BTN_LIBERAR(@oBrwAux),oDlg2:End() },055,015,,,,.T.,,"",,,,.F. )
		u_trataLiberacao(oBtn2,"U_BTN_LIBERAR",SZ8->Z8_TPOPER+"2",aPerfil)
	EndIf

	oBtn3      := TButton():New( 050,128,"Fechar",oDlg2,{|| oDlg2:End()},055,015,,,,.T.,,"",,,,.F. )
	u_trataLiberacao(oBtn3,"END",SZ8->Z8_TPOPER+"1",aPerfil)
	oGet1      := TGet():New( 017,043,{|u| If(PCount()>0,cPlacaCar:=u,cPlacaCar)},oDlg2,033,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPlacaCar",,)
	oGet2      := TGet():New( 030,043,{|u| If(PCount()>0,cMotorCar:=u,cMotorCar)},oDlg2,116,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cMotorCar",,)
	oGet3      := TGet():New( 004,043,{|u| If(PCount()>0,cHora:=u,cHora)},oDlg2,021,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHora",,)

	oDlg2:Activate(,,,.T.)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF51                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF51(_oBrwAux,p_lCarrGranel,p_lSemPeso,p_nOpcao,p_lUsaSeri)
	Local nPesoAux := 0
	Local aAreaAtu := GetArea()
	local cStatus:= _oBrwAux:aArray[_oBrwAux:nAT,1]
	local cOC	 := _oBrwAux:aArray[_oBrwAux:nAT,7]
	local cPager := _oBrwAux:aArray[_oBrwAux:nAT,3]
	local cpgLacre := 'LACRE02'
	local lCancelPeso  := (p_nOpcao==2)
	Local aContent := FWGETSX5("PG")
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat	:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40
	Local lUsaSeri := if(p_lUsaSeri==nil,.F.,p_lUsaSeri)
	//Verifica se a filial usa portaria.
	Local lUsaPort := SuperGetMV("MV_USAPORT",,.F.)
	Local lUsaLetr := SuperGetMV("MV_SMUSALT",,.F.)
	Local lUsaNT   := SuperGetMV("MV_SMUSANT",,.F.) // Utiliza nova tela para dif. de peso?
	Local lUsaSens := SuperGetMV("MV_SMUSASE",,.F.) // Utiliza sensores?
	Local cMot:=""
	Local cJust:=""
	Local cApro:=""

	PRIVATE cColeta:="A"  //A-AUTOMATICA   M- MANUAL

	//Private cEmpRastroOC := getNewPar('MZ_RASTEMP','30')  //codigo da empresa que controla o rastro da OC  Comentado por Alison 19/07/2016
	Private cEmpRastroOC := getNewPar('MZ_RASTEMP','3001|0210')  //codigo da empresa que controla o rastro da OC

	//Adicionado em 20/10/16 Por Rodrigo (Semar) - Verifica se a unidade utiliza sensor e faz a verificação antes de capturar o peso
	if lUsaSens //.AND. SZ8->Z8_TPOPER == "C" //Ajustado em 10/04/17 para não realizar essa validação no descarregamento
		//Comentado o tipo de operação em 03/11/2017 barauna agora utiliza sensor para descarregamento também.
		if !u_SMSENSOR(SZ8->(Z8_PALLET+Z8_LOCCARR+Z8_STATUS2),SZ8->Z8_SACGRA,,,,)
			return .F.
		endif
	endif

	SMFATV01(cpgLacre)

	//*** PEGA O PESO DA BALANÇA E CONFIRMACAO DO USUARIO ***//
	//nPesoAux := u_fPesBal() // chamar a funcao para obter o peso da balanca
	//nPesoAux := 14000

	// Grava o peso e status na SZ8
	dbSelectArea("SZ8")
	dbSetOrder(1)
	//dbSeek(xFilial("SZ8")+_oBrwAux:aArray[_oBrwAux:nAT,7])
	dbSeek(xFilial("SZ8")+cOC)


	// so aceita passar sem peso, quando for granel e o status for "2-aguardando pesagem"
	lSemPeso:= p_lSemPeso

	lpesoOk:=.f.
	While  !lpesoOK .and. !lSemPeso .and. !lcancelPeso
		nPesoAux :=0
		//if lUsaNewOC .and. cEmpAnt $ '20|01|10|11|30|40' // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
		if lUsaNewOC .and. (cEmpAnt + cFilAnt $ '2001|0223|0101|0218|1001|0226|1101|0213|3001|0210|4001|0203') // EMPRESA 40
			if(lUsaSeri,u_frmPesoBal(@nPesoAux,"ENTRADA",@cColeta) ,u_smFrmPeso(@nPesoAux,"ENTRADA",@cColeta))
		elseif lUsaNewOC .and. cEmpAnt + cFilAnt $ '0222|0223'	// EMPRESA 02
			if(lUsaSeri,u_frmPesoBal(@nPesoAux,"ENTRADA",@cColeta) ,u_smFrmPeso(@nPesoAux,"ENTRADA",@cColeta))
		Else
			nPesoAux := u_getPSer('E',@cColeta) // chamar novamente a funcao para obter o peso da balanca
		endif

		//Verificacao peso maximo permitido(ZZJ_PEBRTO - PESO DA BALANÇA) com o peso do pedido da SZ1 -  Semar - Juailson em 28/11/14

		// SO fazer a verficacao quando for ENSACADO --->   nao for GRANEL   !p_lCarrGranel  -- Juailson Semar 26/03/15

		/*

		POR SOLICITAÇÃO DE CIRO, EM 10/03/16, ESSA ROTINA DE VALIDAÇÃO DO PBT, FOI COMENTADA, PARA AGUARDAR
		AS ALTERAÇÕES DA REGRA DE VENDA DE ( PESO X QUANTIDADE X PRODUTO )

		2 - EM 07/04/16 FOI REATIVADA , USANDO COMO REFERENCIA A LOTAÇÃO DO CAMINHÃO AO INVÉS DO PBT.

		*/
		//IF  !empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '3001' .AND. !p_lCarrGranel // vai verificar PESO MAXIMO PERMITIDO se tipo veiculo estiver preenchido	//Comentado por Rodrigo (Semar) - 21/06/16
		IF  !empty(SZ8->Z8_TPVEIC) .AND. (cEmpAnt+cFilAnt $ '3001|0210|0101|0218') .AND. !p_lCarrGranel .AND. !lUsaNT // vai verificar PESO MAXIMO PERMITIDO se tipo veiculo estiver preenchido
			lPMPOk:= u_testePMP(cOC, /*0*/nPesoAux)
			if !lPMPOk
				if MSGYESNO("Deseja alterar o(s) pedido(s)?"  )
					U_SMFATF80(nil,cOC,'CENTRALTRAFEGO')
					//Adicionado por Rodrigo (Semar) - 14/03/17 - Validação para garantir integridade das quantidades PV x OS
					u_atuQtdOCxPed(cOC)
				endif
				nPesoaux:=0  // zera a variavel, pq nao passou na validação acima
				lpesoOK:=.t. // verdadeiro para nao parar na pergunta abaixo
			endif
			//Adicionado por Rodrigo (Semar) - 14/09/16 - Nova tela para excesso de peso
		elseif !empty(SZ8->Z8_TPVEIC) .AND. (cEmpAnt+cFilAnt $ '3001|0210|0101|0218') .AND. !p_lCarrGranel .AND. lUsaNT
			if !U_SMEXCPESO('Entrada',nPesoAux)
				nPesoAux := 0
			endif
		ENDIF





		//fim da verificacao  - Semar - Juailson em 28/11/14


		if !( lpesoOK:=( nPesoaux > 0 ) )
			lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
		endif
	EndDo


	if (nPesoAux==0) .and. !lSemPeso  .and. !lcancelPeso//saco
		Alert('Nao e permitido prosseguir sem peso!')
	else


		if p_lCarrGranel   .and. empty(sz8->z8_lacre)


			//Verificar produto que não precisa de LACRES -  Juailson - Semar 04/031/2015
			lNaoLacrar := U_SmPrdNLacr("SEM_MENS")

			if !lNaoLacrar // se falso, Receber os lacres.

				cLacre:=''
				while empty(cLacre)
					cLacre:= u_frmLacres(nil, cOC)  // Essa funcao esta dentro do programa  MIZ996
				end
			else
				cLacre := "."    // "Sem lacres"

			endif

		endif

		//original
		/*
		if p_lCarrGranel   .and. empty(sz8->z8_lacre)

		cLacre:=''
		while empty(cLacre)
		cLacre:= u_frmLacres(nil, cOC)  // Essa funcao esta dentro do programa  MIZ996
		end


		endif
		*/


		//****************


		nPEntAnt:= sz8->z8_psent // grava o peso antes de altera-lo mais abaixo. para comparar se estava zerado
		DbSelectArea("SZ8")
		If dbSeek(xFilial("SZ8")+_oBrwAux:aArray[_oBrwAux:nAT,7])

			//****************
			//
			//LOG-MOTIVO/JUSTIFI. DE COLETA PESO MANUAL -
			//Sergio - Semar| fev/2016
			//****************

			//If cColeta=="M" .and. cEmpAnt $ "30"	//Comentado por Rodrigo (Semar) 21/06/16
			If cColeta=="M" .and. cEmpAnt + cFilAnt $ "3001|0210"
				If !U_SMJUS(@cMot, @cJust, @cApro)
					Alert("Não foi possivel gravar a justificativa para Coleta PESO MANUAL.  A operaçao com esta OC, será abortada!")
					Return
				Endif
			Endif

			Begin Transaction
				//ROLLBACK TRANSACTION

				RecLock("SZ8",.F.)
				SZ8->Z8_PSENT   := nPesoAux
				SZ8->Z8_HORPES  := iif( lcancelPeso, '', Substr(Time(),1,5) )
				if SZ8->(FieldPos("Z8_DTPENT")) > 0; SZ8->Z8_DTPENT := iif( lcancelPeso, CTOD(""), DATE() ) ; endif
				SZ8->&(cStat) := iif( lcancelPeso, iif(lUsaPort,'A','2') , '3' )
				SZ8->Z8_COLEENT := cColeta
				SZ8->Z8_HORAATU := time()
				if p_lCarrGranel .and. empty(sz8->z8_lacre)
					sz8->z8_lacre := iif( !empty( Alltrim(cLacre) ) , Alltrim(cLacre) , 'Nao informado na entrada' )
				endif

				//LOG-MOTIVO/JUSTIFI. DE COLETA PESO MANUAL -
				//Sergio - Semar| fev/2016

				//If cColeta=="M" .and. cEmpAnt $ cEmpRastroOC	//Comentado por Rodrigo (Semar) - 21/06/16
				If cColeta=="M" .and. cEmpAnt + cFilAnt $ cEmpRastroOC


					awLogs:={}
					aAdd(awLogs, {/*Entidade1*/'SZ8',;
					/*Tipo Docto*/'OC',;
					/*Recno Doc1*/sz8->(recno()),;
					/*Tipo Log*/'PMS',;
					/*dES Log*/'Peso Manual SAIDA',;
					/*Entidade2*/'',;
					/*Recno Doc2*/0,;
					/*Recno Bpk1*/0,;
					/*Motivo*/cMot,;
					/*Justificat.*/cJust,;
					/*Usuario*/cUserName,;
					/*Rotina Orig*/'SMFATT99',;
					/*Liberador1*/cApro} )
					u_SMGRVLG(awLogs)


				endif

				SZ8->(MsUnLock())


				SMFATF62(sz8->z8_oc, sz8->z8_lacre,sz8->z8_psent)
				//Backup SZ2 - Adicionado por Rodrigo Semar - 25/03/2015
				aCamposZ2 := {{"Z2_PSENT",SZ8->Z8_PSENT},;
				{"Z2_HORPES",SZ8->Z8_HORPES}}
				U_SMSetSZ2(SZ8->Z8_PLACA,aCamposZ2)
				//

				//Grava no BANCO DE DADOS SIGEX a mensagem na tabela de mensagens
				//****************************************************************
				//p_cTexto  := "FAVOR PROSSEGUIR"
				//p_cStatus :=  "3"

			End Transaction

			u_SMFATF60(_oBrwAux:aArray[_oBrwAux:nAT,7] , _oBrwAux:aArray[_oBrwAux:nAT,4], lcancelPeso)
			if lUsaLetr; u_SMLETR('',SZ8->(Z8_PALLET+Z8_LOCCARR)+SZ8->(&cStat),'',.T.,,,,SZ8->Z8_PALLET); endif

		EndIf

	endif

	// Atualiza os grids
	SMFATC01()

	RestArea(aAreaAtu)

	oDlg2:End()

Return


//Verificar produtos que nao devem pedir lacres - Juailson - Semar em 24/02/2015

User function SmPrdNLacr(P_MENS) // Produtos que nao devem pedir lacres

	Local aAreaNLACRE := GetArea()

	Local lRet     := .F. //  Se sair como .T. existem produtos que não  é para lacrar
	Local cItem    := ""
	Local cLoop    := "S"
	Local nPosIni  := 1
	Local cPrdParam := getnewPar('MV_SMPRDNL', "")

	// MV_SMPNDL = PNDL -Produtos que Nao Devem Lacrar

	//If cEmpAnt $ "30"		// Comentado por Rodrigo (Semar) - 21/06/16
	If cEmpAnt + cFilAnt $ "3001|0210"

		While  cLoop == "S"
			cItem := substr(SZ8->Z8_ITENSOC,nPosIni,15)

			if !empty(cItem)

				dbSelectArea("SB1")
				dbSetOrder(1)
				if dbSeek(xFilial("SB1")+Alltrim(cItem) )
					// pode comparar com parametro, MV_SMPRDNL
					If alltrim(cItem) $ cPrdParam
						lRet := .T.  // Quando verdadeiro não pede lacres.

						If P_MENS == "COM_MENS"
							alert("Atencao: Produto " + alltrim(cItem) + " nao requer lacre.  OC: " + ALLTRIM(SZ8->Z8_OC))
						endif

					endif

					/*  ficou definido  por paramentro  de PRODUTOS em 04/03/2015

					//Pode compara com o Grupo(B1_GRUPO) --- pode criar um parametro

					if SB1->B1_GRUPO == "M001" //Materia prima

					alert("Produto " + alltrim(cItem) + ",do grupo " +  SB1->B1_GRUPO +",nao requer lacre. ")

					endif

					//Pode compara com o tIPO(B1_TIPO) --- pode criar um parametro

					if SB1->B1_GRUPO == "M001" //Materia prima

					alert("Produto " + alltrim(cItem) + ",do grupo " +  SB1->B1_GRUPO +",nao requer lacre. ")

					endif

					*/
					nPosIni := nPosIni + 48
				else

					cLoop := "N" // Saida senao existir no cad produto

				endif

			else
				cLoop := "N"  // Saida se cItem vazio
			endif


		Enddo

	Endif

	RestArea(aAreaNLACRE)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF52                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF52(_oBrwAux,p_lCarrGranel,p_lUsaSeri)
	Local nPesoAux := 0
	Local aAreaAtu := GetArea()
	local cStatus:= _oBrwAux:aArray[_oBrwAux:nAT,1]
	Local cOC	:= _oBrwAux:aArray[_oBrwAux:nAT,7]
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat	:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40
	Local lBold := .T.
	Local oFont  := TFont():New("Courier New",0,-16,,.T.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("Courier New",0,-16,,.F.,,,,,.F.,.F.)
	Local oSay
	Local _aPedSZ1 := {}
	Local lUsaSeri := if(p_lUsaSeri==nil,.F.,p_lUsaSeri)
	Local lUsaLetr	:= SuperGetMV("MV_SMUSALT",,.F.)
	Local lUsaNT	:= SuperGetMV("MV_SMUSANT",,.F.) // Utiliza nova tela para dif. de peso?
	Local lUsaSens  := SuperGetMV("MV_SMUSASE",,.F.) // Utiliza sensores?
	Local cMot:=""
	Local cJust:=""
	Local cApro:=""


	private cColeta:= "A"

	//Adicionado em 20/10/16 Por Rodrigo (Semar) - Verifica se a unidade utiliza sensor e faz a verificação antes de capturar o peso
	if lUsaSens //.AND. SZ8->Z8_TPOPER == "C" //Ajustado em 10/04/17 para não realizar essa validação no descarregamento
		//Comentado o tipo de operação em 03/11/2017 barauna agora utiliza sensor para descarregamento também.
		if !u_SMSENSOR(SZ8->(Z8_PALLET+Z8_LOCCARR+Z8_STATUS2),SZ8->Z8_SACGRA,,,,)
			return .F.
		endif
	endif

	//*** PEGA O PESO DA BALANÇA E CONFIRMACAO DO USUARIO ***//
	//nPesoAux := u_fPesBal() // chamar a funcao para obter o peso da balanca
	//nPesoAux := 14000

	// peso modelo II
	lpesoOk:=.f.
	lyes:=.f.
	While  !lpesoOK
		//IF lUsaNewOC .and. cEmpAnt $ '20|01|10|11|30|40' // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/08/16
		IF lUsaNewOC .and. cEmpAnt + cFilAnt $ '2001|0223|0101|0218|1001|0226|1101|0213|3001|0210|4001|0203' // EMPRESA 40
			nPesoAux := 0
			if(lUsaSeri,u_frmPesoBal(@nPesoAux,"SAIDA",@cColeta) ,u_smFrmPeso(@nPesoAux,"SAIDA",@cColeta))
			//u_frmPesoBal(@nPesoAux,"SAIDA",@cColeta)
			//u_smFrmPeso(@nPesoAux,"SAIDA",@cColeta)
			if !( lpesoOK:=( nPesoAux > 0 ) )
				lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
			endif

		ElseIf lUsaNewOC .and. cEmpAnt + cFilAnt $ '0222|0223' 	// EMPRESA 02
			nPesoAux := 0
			u_smFrmPeso(@nPesoAux,"SAIDA",@cColeta)
			if !( lpesoOK:=( nPesoAux > 0 ) )
				lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
			endif

		ELSE
			nPesoAux := u_getPSer("S",@cColeta) // chamar novamente a funcao para obter o peso da balanca

			lyes := MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
			if !lyes
				lpesoOK:=.f.
				exit
			endif
		ENDIF
	ENDDO
	//Comparar PESO MAXIMO PERMITIDO como PESO DE SAIDA PARA  GRANEL  - Juailson Semar 27/03/15


	//  Para Granel  p_lCarrGranel  -- Juailson Semar 27/03/2015

	DO CASE
		CASE empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '0101|0218' //temporario apenas para passar


		//CASE !empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '3001' .AND.p_lCarrGranel // vai verificar PESO MAXIMO PERMITIDO	//Comentado por Rodrgio (Semar) - 21/06/16
		CASE !empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '3001|0210|0101|0218' .AND. p_lCarrGranel .AND. !lUsaNT // vai verificar PESO MAXIMO PERMITIDO

		//nPBT := POSICIONE("ZZJ",1,xFilial("ZZJ")+SZ8->Z8_TPVEIC,"ZZJ_PEBRTO")
		nPBT := POSICIONE("ZZJ",1,xFilial("ZZJ")+SZ8->Z8_TPVEIC,"ZZJ_LOTACA")
		nPBT := nPBT * 1000
		_peso_ent := SZ8->Z8_PSENT
		_peso_sai := nPesoAux
		_peso_liq := (_peso_sai - _peso_ent)
		_margem   := getmv("MV_YMARGEM")
		_lota_max := nPBT + ( nPBT * _margem / 100 )

		if _peso_liq > _lota_max
			if MSGYESNO('Peso superior ao maximo permitido para este veiculo, ' + CRLF + CRLF + ;
			' Capacidade do veiculo        : ' + alltrim(str(nPBT))  + CRLF + ;
			' Capacidade maxima permitida  : ' + alltrim(str(_lota_max)) + CRLF + ;
			' Diferença               : ' + alltrim ( str( _peso_liq - nPBT ) )  + CRLF + CRLF + ' LIBERAR ? ' )

				//  					 if !u_smvld2Psw('PESOMANUAL',cOpcao)

				//TRECHO COMENTADO POR RODRIGO FEITOSA NO DIA 06/04/15 - SOLICITAÇÃO DO CIRO POR CAUSA DE UMA BALANÇA QUEBRADA
				if !u_smvld2Psw('PESOMANUAL', 'SMS') // 'SMS' ou 'Email'
					help("",1,"Y_MIZ008")
					nPesoAux := 0
				endif

			else
				nPesoAux := 0
			endif
		endif
		// Validação da margem de diferença de peso

		//Nova tela excesso de peso para carregamento granel na SAIDA
		CASE !empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '3001|0210|0101|0218' .AND. p_lCarrGranel .AND. lUsaNT
		if !U_SMEXCPESO('Saida',nPesoAux)
			nPesoAux := 0
		endif

		//Nova tela excesso de peso para carregamento ensacado na SAIDA
		CASE !empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '3001|0210|0101|0218' .AND. !p_lCarrGranel .AND. lUsaNT
		if !U_SMEXCPESO('Saida',nPesoAux)
			nPesoAux := 0
		endif

		//Normando (Semar) 20/08/2015 - Verificar peso ensacado com margem
		//CASE !empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '3001' .AND. !p_lCarrGranel; // vai verificar PESO MAXIMO PERMITIDO se tipo veiculo estiver preenchido //Comentado por Rodrigo (Semar) - 21/06/16
		CASE !empty(SZ8->Z8_TPVEIC) .AND. cEmpAnt+cFilAnt $ '3001|0210' .AND. !p_lCarrGranel .AND. !lUsaNT // vai verificar PESO MAXIMO PERMITIDO se tipo veiculo estiver preenchido

		//FUNÇÃO COMENTADA PARA NAO VALIDAR PBT A PEDIDO DE CIRO /// 11/03/16
		//FUNÇÃO DESCOMENTADA E ALTERADA PARA VALIDAR LOTAÇÃO AO INVES DE PBT /// 06/04/16
		// DIFERENÇA DE PESO PARA SACOS / SACARIAS
		//nPBT := POSICIONE("ZZJ",1,xFilial("ZZJ")+SZ8->Z8_TPVEIC,"ZZJ_PEBRTO")
		nPBT := POSICIONE("ZZJ",1,xFilial("ZZJ")+SZ8->Z8_TPVEIC,"ZZJ_LOTACA")
		nPBT := nPBT * 1000
		_nOpc 	   := 0
		_margem    := 0
		_MargOk    := 0
		_peso_ent  := SZ8->Z8_PSENT
		_peso_sai  := nPesoAux
		_peso_liqcalc := (_peso_sai - _peso_ent)
		ntotsc  := 0
		_OrdemCarreg := SZ8->Z8_OC	// Marcus Vinicius - Grava OC posicionado na tela da Central de Tráfego.

		DbSelectArea("SZ1")
		DbSetOrder(8)
		//			DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
		//			Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_OC == SZ8->Z8_OC    // Marcus Vinicius - 07/06/2017 - Desabilitado
		DbSeek(xFilial("SZ1")+_OrdemCarreg)
		Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_OC == _OrdemCarreg
			If SZ1->Z1_UNID $ "SC,SA"
				ntotsc+=SZ1->Z1_QUANT
				AADD(_aPedSZ1,{SZ1->Z1_PRODUTO,SZ1->Z1_QUANT})
			EndIf
			DbSkip()
		EndDo

		//------------------------------------------------------------------------------------------------------------------------------------
		// Marcus Vinicius - 07/06/2017 - posicionado novamente no pedido pois ao passar pelo Do While desposiciona o ponteiro devido o dbskip
		// Chamado: 35285
		//------------------------------------------------------------------------------------------------------------------------------------
		DbSelectArea("SZ1")
		DbSetOrder(8)
		DbSeek(xFilial("SZ1")+_OrdemCarreg)
		//------------------------------------------------------------------------------------------------------------------------------------

		If  SZ1->Z1_UNID = "TL"
			_peso_liqcalc := (_peso_liqcalc / 1000)
		EndIf
		_peso_liq      := _peso_liqcalc
		If  SZ1->Z1_UNID $ "SC,SA"
			_qtd_fat := ntotsc
		End

		SB1->(dbSelectArea("SB1"))
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

		IF SZ1->Z1_YPM $ "P/E"
			_margem      := getmv("MV_YMARGEM")
		ELSEIF SZ1->Z1_YPM == "M"
			_margem      := getmv("MV_YMRGMAN")
		ELSEIF SZ1->Z1_YPM $  "BG"
			_margem      := 0
		END

		_nQtTot:= 0
		_aConv := {}

		If SZ1->Z1_UNID $ 'SC*SA'
			//_peso_total  := _qtd_fat  * SB1->B1_CONV ALTERADO POR ALEXANDRO EM  08/03/13

			For AX:= 1 To Len(_aPedSZ1)
				_cProd := _aPedSZ1[AX,1]

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+ _cProd))

				If  AScan(_aConv,SB1->B1_CONV) == 0
					AADD(_aConv,SB1->B1_CONV)
				Endif

				_nQt    := _aPedSZ1[AX,2] * SB1->B1_CONV
				_nQtTot += _nQt

			Next AX

			_peso_total := _nQtTot

		Else
			_peso_total := _peso_liq * SB1->B1_CONV
		Endif

		_peso_maximo := _peso_total + (_peso_total * _margem / 100)
		_peso_minimo := _peso_total - (_peso_total * _margem / 100)

		_peso_exced  := _peso_liq - _peso_total

		_CargaVeiculo:=Posicione("SZ2",1,xFilial('SZ2')+SZ8->Z8_PLACA,"Z2_PESOTRA")

		If _peso_total > _CargaVeiculo
			//Marcus Vinicius - 15/06/2016 - Ajustado para impedir carregamento com seu peso de transporte acima do cadastrado na SZ2.
			MsgBox("Peso acima da capacidade maxima do veiculo, verifique o pedido utilizado ou o cadastro do caminhão. ","Peso excedido","STOP")
			Return .F.

			/*				If !MsgBox("Peso acima da capacidade maxima do veiculo. Liberar mesmo assim?  ","Escolha","YESNO")
			Return .F.
			Endif*/				// Desabilitado por Marcus Vinicius - 15/06/2016 - Solicitação efetuada por Kenia

		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula peso / tolerancia para cimento em Sacos                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_MargOk := SuperGetMv("MV_YMRGOK", .F., 0 )
		_MargPbt := SuperGetMv("MV_YMRGPBT", .F., 0 )
		_loDlg4 := .F.
		If  SZ1->Z1_UNID $ "SC,SA"
			//Ultrapassando a margem estabelecida
			_lMAler1 := (_peso_liq > (_peso_total + (_peso_total * (_MargOk / 100))) .AND. _peso_liq <= _peso_maximo)
			_lMAler2 := (_peso_liq < (_peso_total - (_peso_total * (_MargOk / 100))) .AND. _peso_liq >= _peso_minimo)
			_lMagUltr := (_peso_liq > _peso_maximo .or. _peso_liq < _peso_minimo)
			_lLotacao := (_peso_liqcalc > (nPBT + (nPBT * (_MargPbt / 100) )))
			If  (_lMAler1 .or. _lMagUltr .or. _lMAler2 .Or. _lLotacao)
				_loDlg4 := .T.

				DEFINE MSDIALOG oDlg4 TITLE "Excesso de Peso - OC: "+SZ8->Z8_OC FROM 0,0 TO 300,450 PIXEL
				@ 8,10 To 120,220

				_nLin := 10
				@ _nlin,15  Say oSay PROMPT "Lotação:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,20  Say oSay PROMPT Transform(nPBT, "@E 999,999,999.99") FONT oFont2 OF oDlg4 PIXEL
				@ _nLin,100 Say oSay PROMPT "Capacidade:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,140	 Say oSay PROMPT Transform(_CargaVeiculo, "@E 999,999,999.99") FONT oFont2 OF oDlg4 PIXEL

				_nLin += 15
				@ _nlin,15  Say oSay PROMPT "Total de Sacos:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,95  Say oSay PROMPT Transform(_qtd_fat ,"@E 9999.99") FONT oFont2 OF oDlg4 PIXEL
				@ _nLin,135 Say oSay PROMPT "/" FONT oFont OF oDlg4 PIXEL
				@ _nLin,150 Say oSay PROMPT "Saco de:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,190	Say oSay PROMPT IIF(Len(_aConv) > 0, Transform(_aConv[1],"@E 999"), " ")FONT oFont2 OF oDlg4 PIXEL

				_nLin+= 10
				@ _nLin,15  Say oSay PROMPT "Peso Liquido:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,70  Say oSay PROMPT Transform(_peso_total ,"@E 999,999,999.99") FONT oFont2 OF oDlg4 PIXEL
				//					@ _nLin,150 Say oSay PROMPT "Margem:" FONT oFont OF oDlg4 PIXEL
				//					@ _nLin,190 Say oSay PROMPT Transform(_margem,"@E 999")+"%" FONT oFont2 OF oDlg4 PIXEL

				_nLin+=20
				@ _nLin,15 Say oSay PROMPT "Peso Bruto:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,70 Say oSay PROMPT Transform(_peso_sai  ,"@E 999,999,999.99") FONT oFont2 OF oDlg4 PIXEL

				_nLin+= 10
				@ _nLin,15 Say oSay PROMPT "Peso Entrada:"  FONT oFont OF oDlg4 PIXEL
				@ _nLin,70 say oSay PROMPT Transform(_peso_ent ,"@E 999,999,999.99") FONT oFont2 OF oDlg4 PIXEL

				_nLin+= 10
				@ _nLin,15 Say oSay PROMPT "Peso Calculado:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,70 say oSay PROMPT Transform(_peso_liq ,"@E 999,999,999.99")  FONT oFont2 OF oDlg4 PIXEL

				_nLin+= 13
				@ _nLin,15 Say oSay PROMPT "Min. Permitido:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,70 say oSay PROMPT Transform(_peso_minimo ,"@E 999,999,999.99")  FONT oFont2 OF oDlg4 PIXEL

				_nLin+= 10
				@ _nLin,15 Say oSay PROMPT "Max. Permitido:" FONT oFont OF oDlg4 PIXEL
				@ _nLin,70 say oSay PROMPT Transform(_peso_maximo ,"@E 999,999,999.99")  FONT oFont2 OF oDlg4 PIXEL

				_nLin+= 13
				@ _nLin,15 Say oSay PROMPT "Diferença:" FONT oFont COLOR CLR_HRED OF oDlg4 PIXEL
				//@ _nLin,70 Say oSay PROMPT Transform( _peso_liq - (_qtd_fat*SB1->B1_CONV) ,"@E 999,999,999.99")  FONT oFont COLOR CLR_HRED OF oDlg4 PIXEL
				@ _nLin,70 Say oSay PROMPT Transform( _peso_liq - _peso_total ,"@E 999,999,999.99")  FONT oFont COLOR CLR_HRED OF oDlg4 PIXEL
				@ _nLin,150 Say oSay PROMPT "Sacos:" FONT oFont COLOR CLR_HRED OF oDlg4 PIXEL
				@ _nLin,180 Say oSay PROMPT Transform((_peso_liq /SB1->B1_CONV) - _qtd_fat ,"@E 9999.99")  FONT oFont COLOR CLR_HRED OF oDlg4 PIXEL

				_nLin+= 20
				@ _nLin,140 BmpButton Type 1 Action (_nOpc:= 1 , Close(odlg4))
				@ _nLin,190 BmpButton Type 2 Action Close(odlg4)
				Activate MsDialog oDlg4 Centered

				If _nOpc == 1
					//If _peso_sai > (nPBT + (nPBT * (_MargPbt / 100))) // Provavel problema no cadastro
					If _peso_liqcalc > (nPBT + (nPBT * (_MargPbt / 100))) // Peso liquido maior que lotação
						//MsgAlert("Peso bruto maior que o PBT, operação cancelada!", "Verificar Cadastro")
						MsgAlert("Peso liquido maior que a LOTAÇÃO, operação cancelada!", "Verificar Cadastro")
						if !u_smvld2Psw("PESOMANUAL", "Email", SZ8->Z8_OC, "00:00", "23:59",,SZ8->Z8_TPOPER) // 'SMS' ou 'Email'
							help("",1,"Y_MIZ008")
							return
						endif
					EndIf
					If (_lMAler1 .or. _lMAler2) // Margem para operadores
						if !u_smvld2Psw("PESOMANUAL", "SMS") // 'SMS' ou 'Email'
							help("",1,"Y_MIZ008")
							nPesoAux := 0
						endif
					Else // Margem para superiores
						if !u_smvld2Psw("PESOMANUAL", "Email", SZ8->Z8_OC, "00:00", "23:59",,SZ8->Z8_TPOPER) // 'SMS' ou 'Email'
							help("",1,"Y_MIZ008")
							nPesoAux := 0
						endif
					EndIf
				Else
					nPesoAux := 0
				EndIf
			EndIf
		EndIf

		OTHERWISE
		nPesoAux := 0
	ENDCASE


	if (nPesoAux==0)
		Alert('Nao e permitido prosseguir sem peso!')
		return
	endif


	//validação da margem de diferença de peso
	lpesoOK:=.t.
	if  sz8->z8_tpoper == 'D'

		nPesLiq:=0
		nPesLiq:= sz8->z8_psent - nPesoAux

		nDifPes:=0
		nDifPes:= sz8->z8_nfpesen - nPesLiq

		if  nDifPes > getnewPar('MV_MXDIFPS',200)
			MsgBox("ATENCAO!   A diferença de Peso é maior que a permitida! ","Peso Errado!!! ", "ALERT")
			lpesoOK:= u_SMFATT25()
		endif
	endif

	//****************
	//
	//MOTIVO/JUSTIFI. DE COLETA PESO MANUAL -
	//Sergio - Semar| fev/2016
	//****************
	//If cColeta=="M" .and. cEmpAnt $ "30"	//Comentado por Rodrigo (Semar) - 21/06/16
	If cColeta=="M" .and. cEmpAnt + cFilAnt $ "3001|0210"
		if !u_smvld2Psw("PESOMANUAL", "Email", SZ8->Z8_OC, "00:00", "00:01",,SZ8->Z8_TPOPER) // 'SMS' ou 'Email'
			help("",1,"Y_MIZ008")
			return
		endif
		If !U_SMJUS(@cMot, @cJust, @cApro)
			Alert("Não foi possivel gravar a justificativa para Coleta PESO MANUAL.  A operaçao com esta OC, será abortada!")
			Return
		Endif
	Endif

	//****************
	// Grava o peso e status na SZ8
	dbSelectArea("SZ8")
	dbSetOrder(1)

	//nPEntAnt:= sz8->z8_psent // grava o peso antes de altera-lo mais abaixo. para comparar se estava zerado

	If dbSeek(xFilial("SZ8")+cOC)


		RecLock("SZ8",.F.)
		SZ8->Z8_PSSAI := nPesoAux
		if SZ8->Z8_TPOPER == "D"
			SZ8->Z8_DTSAIDA := dDatabase
			SZ8->Z8_HSAIDA:= Substr(Time(),1,5)
			SZ8->Z8_COLESAI := cColeta
			SZ8->&(cStat)   := '6'
			SZ8->Z8_FATUR   := 'S'
			SZ8->Z8_PAGER   := ''
		endif
		//Adicionado por Rodrigo Semar - 20/08/2015 -> Ao pesar saida assumir novo status "8"
		//if cEmpAnt $ '30'	//Comentado por Rodrigo (Semar) - 21/06/16
		if cEmpAnt+cFilAnt $ '3001|0210'
			SZ8->&(cStat)	:= "8"
		endif
		SZ8->Z8_HORAATU := time()

		//MOTIVO/JUSTIFI. DE COLETA PESO MANUAL -
		//Sergio - Semar| fev/2016
		//If cColeta=="M" .and. cEmpAnt $ cEmpRastroOC	//Comentado por Rodrigo (Semar)
		If cColeta=="M" .and. cEmpAnt+cFilAnt $ cEmpRastroOC

			awLogs:={}
			aAdd(awLogs, {/*Entidade1*/'SZ8',;
			/*Tipo Docto*/'OC',;
			/*Recno Doc1*/sz8->(recno()),;
			/*Tipo Log*/'PMS',;
			/*dES Log*/'Peso Manual SAIDA',;
			/*Entidade2*/'',;
			/*Recno Doc2*/0,;
			/*Recno Bpk1*/0,;
			/*Motivo*/cMot,;
			/*Justificat.*/cJust,;
			/*Usuario*/cUserName,;
			/*Rotina Orig*/'SMFATT99',;
			/*Liberador1*/cApro} )
			u_SMGRVLG(awLogs)

		endif

		SZ8->(MsUnLock())

		if lUsaLetr; u_SMLETR('',SZ8->(Z8_PALLET+Z8_LOCCARR)+SZ8->(&cStat),'',.T.,,,,SZ8->Z8_PALLET); endif

		//Backup SZ2 - Adicionado por Rodrigo Semar - 25/03/2015
		aCamposZ2 := {{"Z2_PSSAI",SZ8->Z8_PSSAI},;
		{"Z2_HSAIDA",SZ8->Z8_HSAIDA}}
		U_SMSetSZ2(SZ8->Z8_PLACA,aCamposZ2)
		//

		//Adicionado por Rodrigo Semar - 20/08/2015 -> Novo ponto para chamar as msgs do pager (Status 8)
		//if cEmpAnt $ '30'	//Comentado por Rodrigo (Semar) - 21/06/16
		if cEmpAnt+cFilAnt $ '3001|0210'
			U_SMFATF60(SZ8->Z8_OC,SZ8->Z8_PLACA)
		endif

		if SZ8->Z8_TPOPER == "D"
			//imprime tickt de balança
			u_RTICKET(sz8->z8_oc)
		endif

	EndIf

	// Atualiza os grids
	SMFATC01()

	RestArea(aAreaAtu)

	oDlg2:End()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF53                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF53(_oBrwAux,p_nOpcao)

	Local aAreaAtu  := GetArea()
	Local cStAux	:= ""
	local cPager 	:= _oBrwAux:aArray[_oBrwAux:nAT,11]
	Local aContent 	:= FWGETSX5("PG")
	//Local cStat		:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat		:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40
	Local cZZPag	:= Replicate("Z",TAMSX3("Z8_PAGER")[1])

	If empty(cPager) .OR. cPager == cZZPag
		cPagEsc := u_SMFATT27()
		while cPagEsc == cZZPag
			if !(MsgBox("Não é possivel prosseguir sem pager e no momento não há nenhum disponivel, deseja tentar de novo?","Atenção", "YESNO"))
				return (.F.)
			endif
			cPagEsc := u_SMFATT27()
		end
		if empty(cPagEsc); return (.F.); endif
		_oBrwAux:aArray[_oBrwAux:nAT,11] := cPagEsc
		dbselectarea("SZ8")
		dbsetorder(1)
		dbSeek(xFilial("SZ8")+_oBrwAux:aArray[_oBrwAux:nAT,7])
		RecLock("SZ8",.F.)
		SZ8->Z8_PAGER := cPagEsc
		SZ8->Z8_CBPAGER := U_SMFATF95(cPagEsc) //cValtoChar(10000000 + val(cPagEsc))
		SZ8->(MsUnLock())
		//	Alert("ATENCAO:    Ordem de Carregamento sem PAGER !  ... Favor informar numero do pagar no agenciamento.")
		RestArea(aAreaAtu)
	EndIf


	If UPPER(_oBrwAux:oParent:cCaption) = "CARREGAMENTO" .AND. nVC >= nMVC
		Alert("A quantidade máxima de veículos na fábrica para carregamento foi atingida. Aguarde a saída de veículos.")
		RestArea(aAreaAtu)
		Return(.F.)
	EndIf

	If UPPER(_oBrwAux:oParent:cCaption) = "DESCARREGAMENTO" .AND. nVD >= nMVD
		Alert("A quantidade máxima de veículos na fábrica para descarregamento foi atingida. Aguarde a saída de veículos.")
		RestArea(aAreaAtu)
		Return(.F.)
	EndIf

	//
	dbSelectArea("SZ8")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ8")+_oBrwAux:aArray[_oBrwAux:nAT,7])
		// Testa na base se o status é 1 e impede alteracao caso nao seja.

		If ( p_nOpcao == 1 .and. SZ8->&(cStat) <> '1' ) .or. ( p_nOpcao == 2 .and. SZ8->&(cStat) <> '2' )
			MsgInfo("Houve alteração do status desse registro, possivelmente por outro usuário. O sistema irá atualizar a tela. Verifique!")
			SMFATC01()

			RestArea(aAreaAtu)
			//Return(.f.)
		EndIf

		SZ8->(RecLock("SZ8",.F.))
		// Retorna para o status 2
		if SZ8->&(cStat) = '7'
			SZ8->&(cStat) := '2'
		endif
		// Grava status
		if SZ8->&(cStat) <'3'
			SZ8->&(cStat) := iif(p_nOpcao==1, '2', '1' )
		endif
		SZ8->Z8_HORAATU := time()
		SZ8->Z8_HRCHPG  := time()
		SZ8->(MsUnLock())


		//Grava no BANCO DE DADOS SIGEX a mensagem na tabela de mensagens
		//###############################################################
		u_SMFATF60(_oBrwAux:aArray[_oBrwAux:nAT,7] , _oBrwAux:aArray[_oBrwAux:nAT,4])

	EndIf

	SMFATC01()

	RestArea(aAreaAtu)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATA07                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATA07(p_nOpc)

	//Local cHoraIni := Time()
	//Local cHora := Time()
	Local cTipo := if(oFolder1:nOption=1,"C","D")

	U_MIZ997(,cTipo) // atualiza status de inicio de carga, fim e espera
	//cHora1 := ELAPTIME(cHora,TIME())
	//cHora := Time()

	SMFATC01() // atualiza os grids
	//cHora2 := ELAPTIME(cHora,TIME())
	//cHora := Time()

	if p_nOpc== nil .or. p_nOpc>0
		//u_SigexRegrava()
		//cHora3 := ELAPTIME(cHora,TIME())
		//cHora := Time()
		//if !empty(U_SMFATF65(.t.)); u_SMFATC02() ; endif

		MsgInfo("Status Atualizado as "+time())
	endif


	u_SMFATF60()
	//cHora4 := ELAPTIME(cHora,TIME())
	//cHora  := Time()

	/*MsgInfo("Fim da rotina de atualização"+CHR(13)+CHR(10)+;
	"Tempo para executar a rotina MIZ997: "+cHora1+CHR(13)+CHR(10)+;
	"Tempo para executar a rotina fConsulta: "+cHora2+CHR(13)+CHR(10)+;
	if(p_nOpc==nil .or. p_nOpc>0,"Tempo para executar a rotina SigexRegrava: "+cHora3+CHR(13)+CHR(10),"")+;
	"Tempo para executar a rotina setZZL: "+cHora4+CHR(13)+CHR(10)+;
	"Tempo total para executar a rotina de atualização: "+ELAPTIME(cHoraIni,TIME()))*/

	if dDataBase != DATE()  // 30/09/14 - Adicionado para evitar que notas sejam faturadas com a variavel dDataBase errada.
		dDataBase := DATE()
	endif


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF54                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF54(_oBrwAux)

	local cOC	 	:= _oBrwAux:aArray[_oBrwAux:nAT,7]
	local cPlaca 	:= _oBrwAux:aArray[_oBrwAux:nAT,4]
	local aNotas 	:= {}
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat	:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40
	Local cRet
	Local lUsaLetr	:= SuperGetMV("MV_SMUSALT",,.F.)
	Local cChKStat	:= ''

	//Adicionado por Rodrigo Semar - 20/08/2015 -> Se não tiver pesado a saida, não permitir o faturamento.
	//if cEmpAnt $ '30'		//Comentado por Rodrigo (Semar) - 21/06/16
	if cEmpAnt+cFilAnt $ '3001|0210|0101|0218'
		DbSelectArea("SZ8")
		DbSetOrder(1)
		if SZ8->(DbSeek(xFilial("SZ8")+cOC))
			cChKStat := SZ8->&(cStat)
			if EMPTY(SZ8->Z8_PSSAI)
				Alert("OC sem Peso de Saida, favor capturar peso antes!")
				return
			endif
		endif
	endif
	//
	//if cEmpAnt $ '30' .AND. EMPTY(_oBrwAux:aArray[_oBrwAux:nAT,11])	//Comentado por Rodrigo (Semar) - 21/06/16
	if cEmpAnt+cFilAnt $ '3001|0210' .AND. EMPTY(_oBrwAux:aArray[_oBrwAux:nAT,11])
		if MsgYesNo('Carregamento com Nota Fiscal cancelada. Deseja refaturar?')
			cRet := U_MIZ035('MIZ999')
		else
			return
		endif
	else
		cRet := U_MIZ035('MIZ999')
	endif

	//rodrigo
	if SuperGetMV("MV_USASMS",,.F.) .AND. ValType(cRet) == "L"
		DbSelectArea("SZ7")
		DbSetOrder(8)
		if DbSeek(xFilial("SZ7")+cOC)
			aInfoSMS := {SZ7->Z7_NUM,TRIM(SZ7->Z7_PRODUTO),TRIM(STR(SZ7->Z7_QUANT)),SZ7->Z7_UNID,SZ7->Z7_PLACA}		// Marcus Vinicius - Adicionado elementos (Z7_PRODUTO|Z7_QUANT|Z7_UNID|Z7_PLACA) no array aInfoSMS
			u_SMFATF79('NOTAFISCAL',,3,,aInfoSMS)
		endif
	endif

	if ValType(cRet) == "L"
		//Backup SZ2 - Adicionado por Rodrigo Semar - 25/03/2015
		aCamposZ2 := {{"Z2_PSSAI",Posicione("SZ8",1,xFilial("SZ8")+cOC,"Z8_PSSAI")},;
		{"Z2_HSAIDA",Posicione("SZ8",1,xFilial("SZ8")+cOC,"Z8_HSAIDA")},;
		{"Z2_PEDIDO",Posicione("SZ7",8,xFilial("SZ7")+cOC,"Z7_NUM")},;
		{"Z2_MOTOR",Posicione("SZ8",1,xFilial("SZ8")+cOC,"Z8_MOTOR")},;
		{"Z2_QUANT",Posicione("SZ8",1,xFilial("SZ8")+cOC,"Z8_QUANT")},;
		{"Z2_NUMNF",Posicione("SZ7",8,xFilial("SZ7")+cOC,"Z7_NUMNF")}}
		U_SMSetSZ2(cPlaca,aCamposZ2)
		//
	endif

	//Verifica se a filial usa portaria
	//if SuperGetMV("MV_USAPORT",,.F.)
	//	DbSelectArea("SZ8")
	//	DbSetOrder(1)
	//	if MsSeek(xFilial("SZ8")+cOC)
	//		RecLock("SZ8",.F.)
	//		SZ8->Z8_VLDANFE := "S"
	//		SZ8->(MsUnlock())
	//	endif
	//endif
	//

	//Verifica se a filial usa validação da danfe
	if SuperGetMV("MV_VALDANF",,.F.) .AND. ValType(cRet) == "L"
		DbSelectArea("SZ8")
		DbSetOrder(1)
		if MsSeek(xFilial("SZ8")+cOC)
			RecLock("SZ8",.F.)
			SZ8->&(cStat) := "B"
			SZ8->(MsUnlock())
		endif
	endif

	//if cEmpAnt $ "30|01|40"	// EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	if cEmpAnt+cFilAnt $ "3001|0210|0101|0218|4001|0203"	// EMPRESA 40
		if Posicione("SZ8",1,xFilial("SZ8")+cOC,cStat) $ '9'
			U_SMFATF60(cOC,cPlaca)
		endif
	endif

	// Alterado por Rodrigo (Semar) em 01/04/2017 - apenas chamar a função caso o faturamento tenha ocorrido de fato.
	if lUsaLetr .AND. cChKStat != SZ8->&(cStat)
		u_SMLETR('',SZ8->(Z8_PALLET+Z8_LOCCARR)+SZ8->(&cStat),'',.T.,,,,SZ8->Z8_PALLET)
	endif

	//	PUTMV("MZ_LIBFAT",.T.)
	oDlg2:End()
	SMFATC01()
	//Else
	//	MSGSTOP("Rotina de Faturamento Bloqueado por outro Usuario!!")
	//Endif


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF61                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF61(cperg)

	PutSX1(cperg,"01","Usar Descarregamento SACO ?","","","mv_ch1","N",01,0,1,"C","","","","","mv_par01","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")
	PutSX1(cperg,"02","Usar Carregamento SACO ?"   ,"","","mv_ch2","N",01,0,1,"C","","","","","mv_par02","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")

	pergunte(cperg,.f.)
	lusaDescSaco:=(mv_par01==1)
	lusaCarrSaco:=(mv_par02==1)
return

Static Function getSx1()
	if pergunte(cperg,.T.)

		lUsaDescSaco:=(mv_par01==1)
		lusaCarrSaco:=(mv_par02==1)

		// Calcula area do centro
		if type("oPanMid") != 'U'
			U_AlteraBrw(1,oPanMid,lUsaCarrSaco,'',0)		// Carregamento
			U_AlteraBrw(1,oPanMidD,lUsaDescSaco,'d',4)	// Descarregamento
		endif

	endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATA08                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATA08(_oBrwAux)
	Local aAreaAtu 	:= GetArea()
	Local wOC 		:= _oBrwAux:aArray[_oBrwAux:nAT,7]
	//Local cStat		:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat		:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40
	Local cHoraI	:= Alltrim(GetNewPar("MV_SMHLSIS","07:00"))
	Local cHoraF	:= Alltrim(GetNewPar("MV_SMHLSFS","07:00"))

	if cempant=='20' .Or. (cEmpant+cFilAnt == "0104")
		if !u_smvldPsw('PESOMANUAL','SMS')
			return .f.
		endif
	ElseIf cEmpant+cFilAnt $ "0222|0223"	// EMPRESA 02
		if !u_smvldPsw('PESOMANUAL','SMS')
			return .f.
		endif
		//elseif cEmpAnt == '30' //Adicionado por rodrigo 20/08/15 - evitar que o status sigex seja usado durante o horario de expediente(adm). //Comentado por Rodrigo (Semar) - 21/06/16
	elseif cEmpAnt + cFilAnt $ '3001|0210' //Adicionado por rodrigo 20/08/15 - evitar que o status sigex seja usado durante o horario de expediente(adm).
		if !U_smvld2Psw("SIGEX","Email",wOC,cHoraI,cHoraF)
			return .f.
		endif
	endif

	// Grava o peso e status na SZ8
	dbSelectArea("SZ8")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ8")+wOC)
		RecLock("SZ8",.F.)
		SZ8->&(cStat)   := '6'
		SZ8->Z8_PESOFIN := 55
		SZ8->Z8_PSSAI   := 0
		SZ8->Z8_HORAATU := time()
		SZ8->(MsUnLock())
	EndIf

	// Atualiza os grids
	SMFATC01()

	RestArea(aAreaAtu)

	oDlg2:End()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF55                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF55()

	MATA140(xAutoCab,xAutoItens,nOpcAuto,lSimulaca,nTelaAuto)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATV01                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATV01(cperg)

	cperg:=padr(cperg,10)
	aRegs :={}
	//cPerg := PADR(cPerg,10)
	aAdd(aRegs,{cPerg,"01","Lacre 1			? ","","","mv_ch1","C",50,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Lacre 2			? ","","","mv_ch2","C",50,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//aAdd(aRegs,{cPerg,"03","Lacre 3			? ","","","mv_ch3","C",1,0,0,"C","","mv_par03","Modelo 1","","","","","Modelo 2","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF62                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


static function SMFATF62(p_cOC, p_cLacre,p_nPSEnt)
	local warea:= getarea()

	DbSelectArea("SZ1")
	DbSetOrder(8)
	DbSeek(xFilial("SZ1")+p_cOC)
	Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. Z1_OC == p_cOC
		sz1->(reclock('SZ1',.f.))
		if !empty(p_cLacre)
			sz1->z1_lacre := p_cLacre
		endif
		sz1->z1_psent := p_nPSEnt

		sz1->(msunlock())
		DbSkip()
	EndDo


	restArea(warea)
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT25                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


user function SMFATT25()
	local warea:= getArea()
	local lret:=.t.
	local oDlgSenha

	local _senha    := space(10)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe janela solicitando senha                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//@ 40,50 to 100,300 Dialog oDlg2 Title "Senha"
	DEFINE MSDIALOG oDlgSenha TITLE "Senha" FROM 40,50 TO 100,300 PIXEL
	@ 08,10 say "Senha:"
	@ 08,35 get _senha PassWord
	@ 14,100 BmpButton Type 1 Action Close(oDlgSenha)
	Activate MsDialog oDlgSenha Centered
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a senha ‚ valida                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  alltrim(_senha) <> alltrim(getmv("MV_YSENHA"))
		help("",1,"Y_MIZ008")
		lret:=.f.
	End

	restArea(warea)
return lret

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF63                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF63(cperg)

	PutSX1(cperg,"01","Lin 1 ?","","","mv_ch1","N",04,0,1,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSX1(cperg,"02","Col 2 ?","","","mv_ch2","N",04,0,1,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSX1(cperg,"03","Lin 1 ?","","","mv_ch3","N",04,0,1,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSX1(cperg,"04","Col 2 ?","","","mv_ch4","N",04,0,1,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")

	pergunte(cperg,.T.)

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF56                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


user function SMFATF56(p_cOpcao,cSerie,cNotaIni,cNotaFim)
	local warea:= getarea()
	local lret:=.t.
	Local cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
	Local cParNfeMnt := '000179_'+SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
	Local aPerg       := {}
	Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}



	PRIVATE cCondicao := ""
	PRIVATE bFiltraBrw:={|| .t. }


	if p_cOpcao $ 'TODAS/REM'

		spedNFeRe2(cSerie,cNotaIni,cNotaFim)

	endif

	if p_cOpcao $ 'TODAS/MNT'

		//MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfeRem,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
		if p_cOpcao == 'TODAS'

			aParam[01] := cSerie
			aParam[02] := cNotaIni
			aParam[03] := cNotaFim

			MV_PAR01 := aParam[01]
			MV_PAR02 := aParam[02]
			MV_PAR03 := aParam[03]


			while alltrim(ParamLoad(cParNfeMnt,aParam,2)) <>  alltrim(cNotaIni)
				ParamSave(cParNfeMnt,aParam,"1")
			end


			//xPerg:='NFSIGW'
			//pergunte(xperg,.f.)

			//cnotaIni:= mv_par02


			aadd(aPerg,{1,'STR0010',aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
			aadd(aPerg,{1,'STR0011',aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
			aadd(aPerg,{1,'STR0012',aParam[03],"",".T.","",".T.",30,.T.})  //"Nota fiscal final"

			/*
			aadd(aPerg,{1,'STR0010',aParam[03],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
			aadd(aPerg,{1,'STR0011',aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
			aadd(aPerg,{1,'STR0012',aParam[01],"",".T.","",".T.",30,.T.})  //"Nota fiscal final"
			*/

			/*
			while alltrim(ParamLoad(cParNfeMnt,aPerg,2)) <>  alltrim(cNotaIni)
			ParamSave(cParNfeMnt,aPerg,"1")
			end
			*/

		endif

		SpedNFe1Mnt()

	endif

	if p_cOpcao $ 'TODAS/DAN'

		if p_cOpcao == 'TODAS'
			xPerg:='NFSIGW'
			aParametros:={}
			aAdd( aParametros, cNotaIni ) //da nota
			aAdd( aParametros, cNotaFim ) //da nota
			aAdd( aParametros, cSerie ) //da nota
			aAdd( aParametros, '2' ) // 1-entrada ou 2-saida
			aAdd( aParametros, '2' )  //1-imprimir ou 2-visualizar
			aAdd( aParametros, '2' )  //imprimi no verso - 1-Sim  2-Nao

			u_SMFATF57(aParametros,xPerg)
		endif

		cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
		aFilBrw		:=	{'SF2',cCondicao}

		SpedDanfe()

	Endif

	if p_cOpcao $ 'STA'

		SpedNFeStatus()

	endif

	restarea(warea)
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF57                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF57(aParametros,cPerg)

	Local wArea:=GetArea()

	//uso expecifico no profile
	//**************************
	Private p_name  := cEmpAnt + cUserName // variavel publica
	Private p_prog  := iif( !empty(cPerg),cPerg,FunName())  // rotina do sistema
	Private p_task  := "PERGUNTE" // padrao do sistema para parametros tipo SX1
	Private p_type  := "MV_PAR"   //  ""     "" 			"" 				""
	Private p_defs  := ""
	//*****************************

	dbSelectArea("SX1")
	SX1->(DbSetOrder(1))

	For i:=1 to Len(aParametros)
		If SX1->(dbSeek(      PadR( cperg , 10 ) + strzero(i,2)    ))
			RecLock("SX1",.f.)
			do case
				case valtype(aParametros[i]) == 'C'
				sx1->x1_cnt01 := aParametros[i]
				case valtype(aParametros[i]) == 'N'
				sx1->x1_cnt01 := val(aParametros[i])
			endcase
			MsUnlock()
		Endif
	Next


	//PREENCHE A VARIAVEL COM TODOS OS PARAMETROS, CONFORME A SEQUENCIA DO PROPRIO GRUPO DE PERGUNTAS
	if sx1->(dbSeek( PadR( cperg , 10 )   ))
		while !sx1->(eof()) .and.  alltrim(sx1->x1_grupo) == cPerg
			p_defs+=  sx1->x1_tipo+"#"+alltrim(sx1->x1_gsc)+"#"+sx1->x1_cnt01 + _wEnter_
			sx1->(dbskip())
		end
	endif

	if !empty(p_defs)
		if ( FindProfDef( p_name,p_prog,p_task,p_type) )
			WriteProfDef( p_name,p_prog,p_task,p_type, p_name,p_prog,p_task,p_type, p_defs )
		else
			WriteNewProf( p_name,p_prog,p_task,p_type, p_defs )
		endif
	endif

	RestArea(wArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF58                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


static function SMFATF58(p_cOpcao)
	local warea:= getArea()

	local aParamibx := {SZ7->Z7_NUMNF, SZ7->Z7_SERIE}
	//odlg1:disable()


	do case
		case p_cOpcao =='PED' ; u_Miz016()
		case p_cOpcao =='CLI' ; MATA030()
		//case p_cOpcao == 'CLI'; iif( u_ChkAcesso("MATA030",6,.T.) , MATA030()  , .f. )
		case p_cOpcao =='AGE' ; u_SMFatT13()
		case p_cOpcao =='MOT' ; u_Miz010()
		case p_cOpcao =='TRA' ; MATA050()
		case p_cOpcao =='CAM' ; u_Miz005()
		case p_cOpcao =='CAR' ; u_Miz1030()
		case p_cOpcao =='IOC' ; u_MIZ050GR('botaomiz999',wnumOC)
		case p_cOpcao =='NFE' ; SpedNFe()
		case p_cOpcao =='CEN' ; u_miz030(wnumOC)
		case p_cOpcao =='PAG' ; u_SMFATT01()
		//	case p_cOpcao =='LAC' ; u_SMFATI02(wnumOC)
		case p_cOpcao =='LAC'

		//if cEmpAnt $ '30' 	 //Comentado por Rodrigo (Semar) - 21/06/16
		if cEmpAnt+cFilAnt $ '3001|0210'
			u_SMCBPAGER()  // SEMAR JFS 15/10/14	- ESTA FUNCAO É PARA LER COD BARRA PAGER E CAD LACRES - FUNCAO NO FINAL DO PROGRAMA
			// Alterei para aceita pelo CODIGO do pager tambem - Juailson Semar em 31/03/15
		else
			u_SMFATI02(wnumOC)
		endif


		case p_cOpcao =='RPE' ; u_SMFATT41()
		//Ticket
		//	case p_cOpcao =='TK1' ; u_MIZ790()
		case p_cOpcao =='TK1' ; EXECBLOCK("MIZ790",.F.,.F.,aParamibx)
		case p_cOpcao =='TK2' ; u_RTICKET()
		case p_cOpcao =='FLW' ; U_SMFLWUP()
		case p_cOpcao =='CAN' ; U_SMCANCEP(wnumOC)
		case p_cOpcao =='RES' ; U_SMRESTP(wnumOC)


	endcase

	//odlg1:enable()

	RestArea(wArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF59                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


static function SMFATF59(oBrwAux)
	local warea:= getArea()

	oBrwAux:Refresh()

	wNumOC:=oBrwAux:aArray[oBrwAux:nAT,7]

	if empty(oBrwAux:aArray[oBrwAux:nAT,7]) ; return; endif


	dbSelectArea("SZ8")
	dbsetorder(1)
	dbSeek(xFilial("SZ8")+wNumOC) //Posiciona na OC para faturar


	RestArea(wArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATC02                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Funcao de consulta por codigo de barras                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User function SMFATC02(p_cCB,p_cTipo,p_lUsaCanc)

	local aTbPager:=FWGETSX5("PG")
	local warea:= getArea()
	local cCB := iif(  p_cCB==nil, U_SMFATF65(.t.) , p_cCB )  //captura CB no leitor
	local cTipo := iif( p_cTipo==nil, cTipo := "N" , cTipo := p_cTipo)
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat	:= if(cEmpAnt+cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40
	Local lUsaCanc  := if(p_lUsaCanc==nil, .F., p_lUsaCanc)
	Local cNStat := if(lUsaCanc,"A","2")
	Local lUsaLetr	:= SuperGetMV("MV_SMUSALT",,.F.)
	Local lSepLona	:= SuperGetMV("MV_SMSEPLO",,.F.) //Separa lonamento ?
	//Local cFatStat := if(lUsaCanc,"B","6")
	Local lUsaCancela := GetNewPar("MV_USACANC",.F.)
	Local cTabMLETR	:= Alltrim(GetNewPar("MV_SMLETTM","ZP"))
	Local nWaitClose:= GetNewPar("MV_SMLETCT",3000)
	Private lThread

	DbSelectArea("SZ8")
	DbSetOrder(1)


	if cTipo = "N"
		return
	elseif cTipo = "E"
		cSQL := "SELECT Z8_NOMMOT,Z8_OC,Z8_PAGER FROM "+RetSqlName("SZ8")+" SZ8 "
		cSQL += " WHERE SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '" + xFilial("SZ8") + "'"
		cSQL += " AND "+cStat+" = '"+cNStat+"' AND Z8_PSENT = 0"
		cSQL += " AND Z8_DATA >= '"+DTOS(dDataBase-3)+"'"
		cSQL += " AND Z8_CBPAGER = '"+ALLTRIM(cCB)+"'"
	elseif cTipo = "S"
		cSQL := "SELECT Z8_NOMMOT,Z8_OC,Z8_PAGER FROM "+RetSqlName("SZ8")+" SZ8 "
		cSQL += " WHERE SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '" + xFilial("SZ8") + "'"
		cSQL += " AND (("+cStat+" = '"+iif(lSepLona,"F","5")+"' AND Z8_PALLET != 'G' ) OR ("+cStat+" IN ('5','8','9') AND Z8_PALLET = 'G') )"
		cSQL += " AND Z8_PSENT != '0'"
		cSQL += " AND Z8_DATA >= '"+DTOS(dDataBase-3)+"'"
		cSQL += " AND Z8_CBPAGER = '"+ALLTRIM(cCB)+"'"
	elseif cTipo = "E|S"
		cSQL := "SELECT Z8_NOMMOT,Z8_OC,Z8_PAGER,Z8_STATUS2 FROM "+RetSqlName("SZ8")+" SZ8 "
		cSQL += " WHERE SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '" + xFilial("SZ8") + "'"
		cSQL += " AND (("+cStat+" = '"+iif(lSepLona,"F","5")+"' AND Z8_PSENT != '0') OR ("+cStat+" = '"+cNStat+"' AND Z8_PSENT = 0))"
		cSQL += " AND Z8_DATA >= '"+DTOS(dDataBase-3)+"'"
		cSQL += " AND Z8_CBPAGER = '"+ALLTRIM(cCB)+"'"
	endif


	if select('SZ8991')>0
		SZ8991->(DbCloseArea())
	endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), "SZ8991", .F., .T.)
	dbSelectArea('SZ8991')
	SZ8991->(DbGoTop())

	if sz8->( dbseek( xfilial('SZ8') + SZ8991->z8_oc  ) ) .and. Alltrim(sz8->z8_cbpager) == Alltrim(cCB)

		//Adicionado em 03/03/17 por Rodrigo Feitosa - Alterações para abertura de cancela na balança -
		// 1 - Verifica se o local de carregamento da OC possui balança, como essa função só é chamada
		//		na balança de entrada ou saida, significa que se ela foi chamada por uma oc que vai carregar
		//		em um local com balança, apenas vai utilizar da cancela se a mesma estiver cadastrada.
		DbSelectArea("SX5")
		DbSetOrder(1)
		//If SX5->(DbSeek(xFilial("SX5")+"ZC"+SZ8->Z8_LOCCARR))
		If SX5->(DbSeek(cFilAnt+"ZC"+SZ8->Z8_LOCCARR))

			if AT("BL",ALLTRIM(SX5->X5_DESCENG)) > 0 .AND. lUsaCancela //Local tem balança e a unidade utiliza cancelas.
				// 2 - Verificar na tabela generica 'ZP' se no local de carregamento + status da OC existe
				//		uma cancela cadastrada para que a mesma seja acionada.
				DbSelectArea("SX5")
				DbSetOrder(1)
				//If SX5->(DbSeek(xFilial("SX5")+cTabMLETR+SZ8->(Z8_PALLET+Z8_LOCCARR)+'C'+SZ8->(&cStat)))
				If SX5->(DbSeek(cFilAnt+cTabMLETR+SZ8->(Z8_PALLET+Z8_LOCCARR)+'C'+SZ8->(&cStat)))

					u_SMLETR('',SZ8->(Z8_PALLET+Z8_LOCCARR)+'C'+SZ8->(&cStat),'',.T.,,,,SZ8->Z8_PALLET)

				endif

			elseif !EMPTY(SZ8->Z8_LOCCAR2) .AND. ; // O Local não tem balança, mas foi finalizado em outro local, verifficar se o mesmo tem.
			AT("BL",Alltrim(Posicione("SX5",1,cFilAnt+"ZC"+SZ8->Z8_LOCCAR2,"X5_DESCENG"))) > 0 .AND. ;
			lUsaCancela

				// 2 - Verificar na tabela generica 'ZP' se no local de carregamento + status da OC existe
				//        uma cancela cadastrada para que a mesma seja acionada.
				DbSelectArea("SX5")
				DbSetOrder(1)
				//If SX5->(DbSeek(xFilial("SX5")+cTabMLETR+SZ8->(Z8_PALLET+Z8_LOCCAR2)+'C'+SZ8->(&cStat)))
				If SX5->(DbSeek(cFilAnt+cTabMLETR+SZ8->(Z8_PALLET+Z8_LOCCAR2)+'C'+SZ8->(&cStat)))

					u_SMLETR('',SZ8->(Z8_PALLET+Z8_LOCCAR2)+'C'+SZ8->(&cStat),'',.T.,,,,SZ8->Z8_PALLET)

				endif

			else //Continua execução normal

				RecLock("SZ8",.F.)
				if cTipo = "E"
					SZ8->&(cStat)   := '7'
					SZ8->Z8_HORAATU := time()
				elseif cTipo = "S"
					SZ8->&(cStat)   := "6"
					SZ8->Z8_HORAATU := time()
				elseif cTipo = "E|S"
					if SZ8991->&(cStat) == 'A'
						SZ8->&(cStat)   := '7'
						SZ8->Z8_HORAATU := time()
					elseif SZ8991->&(cStat) == "5"
						SZ8->&(cStat)   := "6"
						SZ8->Z8_HORAATU := time()
					endif
				endif
				SZ8->(MsUnLock())

				u_SMFATF60(SZ8->Z8_OC, SZ8->Z8_PLACA)
				if lUsaLetr; u_SMLETR('',SZ8->(Z8_PALLET+Z8_LOCCARR)+SZ8->(&cStat),'',.T.,,,,SZ8->Z8_PALLET); endif

			endif
		endif
	endif

	SZ8991->(DbCloseArea())
	RestArea(warea)
return

User function SMFATF75()

	local cOC := ""
	local wArea := getArea()
	local aNotas := {}
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat	:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40

	cSQL := "SELECT * FROM "+RetSqlName("SZ8")+" SZ8 "
	cSQL += "WHERE SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '"+xFilial("SZ8")+"' AND "+cStat+" = '6' "
	cSQL += "AND Z8_FATUR = 'S' AND Z8_PSENT <> '0' AND Z8_PSSAI <> '0' "
	cSQL += "AND Z8_DATA = '" +DTOS(dDataBase)+ "' AND SUBSTRING(Z8_WRKFLW,3,1) <> '1'"

	TCQUERY cSQL New Alias "BPF" // BUSCA PEDIDOS FATURADOS
	dbSelectArea('BPF')
	BPF->(DbGoTop())
	while BPF->(!eof())
		cOC += "'"+BPF->Z8_OC+"',"
		BPF->(DbSkip())
	end
	BPF->(DbCloseArea())
	RestArea(wArea)
	cOC := substr(cOC,1,LEN(cOC)-1)

	if LEN(cOC)=0; return; endif

	cSQL := "SELECT Z7_FILIAL,Z7_NUMNF,Z7_NUMNF2,Z7_SERIE,Z7_OC FROM "+RetSqlName("SZ7")+" SZ7 "
	cSQL += "WHERE Z7_OC IN ("+cOC+") AND SZ7.D_E_L_E_T_= ' ' AND Z7_FILIAL = '"+xFilial("SZ7")+"'"

	TCQUERY cSQL New Alias "BNF" // BUSCA NOTA FISCAL
	dbSelectArea('BNF')
	BNF->(DbGoTop())
	while BNF->(!eof())
		AAdd(aNotas,{ALLTRIM(BNF->Z7_FILIAL),ALLTRIM(BNF->Z7_NUMNF),ALLTRIM(BNF->Z7_SERIE),ALLTRIM(BNF->Z7_OC)})
		iif(!empty(ALLTRIM(BNF->Z7_NUMNF2)), AAdd(aNotas,{ALLTRIM(BNF->Z7_FILIAL),ALLTRIM(BNF->Z7_NUMNF2),ALLTRIM(BNF->Z7_SERIE),ALLTRIM(BNF->Z7_OC)}) , )
		BNF->(DbSkip())
	end
	BNF->(DbCloseArea())
	RestArea(wArea)

	for a:= 1 to len(aNotas)
		U_SMFATA04(aNotas[a][1],aNotas[a][2],aNotas[a][3],aNotas[a][4])
	next

	RestArea(wArea)
return

Static function NOTAENTREGUE(_oBrwAux)

	local cOC	 := _oBrwAux:aArray[_oBrwAux:nAT,7]
	//Local cStat	:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat	:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40

	if SZ8->Z8_OC = cOC
		//u_SMFATF60(SZ8->Z8_OC,SZ8->Z8_PLACA)
		RecLock("SZ8",.F.)
		SZ8->&(cStat)   := 'D'
		SZ8->Z8_FATUR   := "S"
		SZ8->Z8_HORAATU := time()
		SZ8->Z8_PAGER	:= ''
		MsUnlock()
	endif

	U_SMFATA07(0)

return

Static function SMFATI01(p_cOrigem,p_oBrwAux)

	Local wArea      := getArea()
	Local cOrigem    := iif(p_cOrigem == nil, "", ALLTRIM(p_cOrigem))
	Local oBrwAux    := iif(p_oBrwAux == nil, "", p_oBrwAux)
	Local cOC        := iif(oBrwAux == nil, "", ALLTRIM(oBrwAux:aArray[oBrwAux:nAT,7]))
	Local cItensOC   := ""
	Local aCampos
	Local aItens     := {}
	Local oMenuItem
	Private cCadastro

	if Empty(cOrigem) .Or. Empty(cOC)
		return .F.
	endif

	do case
		case cOrigem == "Produto"

		cCadastro := "Detalhes - Produto"
		aCampos   := {"NOUSER","B1_COD","B1_DESC","B1_TIPO","B1_PRV1"}

		dbSelectArea("SZ8")
		dbSetOrder(1)
		if dbSeek(xFilial("SZ8")+cOC)
			dbSelectArea("SB1")
			dbSetOrder(1)
			if dbSeek(xFilial("SB1")+SZ8->Z8_PRODUTO)
				AxVisual("SB1",RECNO(),1,aCampos)
			endif
		endif

		case cOrigem == "OC"

		cCadastro := "Detalhes - OC"
		aCampos   := {"NOUSER","Z8_OC","Z8_PLACA","Z8_NOMMOT"}

		dbSelectArea("SZ8")
		dbSetOrder(1)
		if dbSeek(xFilial("SZ8")+cOC)
			iif(Empty(SZ8->Z8_ITENSOC),AAdd(aCampos,"Z8_PRODUTO"),AAdd(aCampos,"Z8_ITENSOC"))
			AxVisual("SZ8",RECNO(),1,aCampos)
		endif

		case cOrigem == "Prov"

		oMenu01 := tMenu():new(0,0,0,0,.T.)
		dbSelectArea("SZ8")
		dbSetOrder(1)
		if dbSeek(xFilial("SZ8")+cOC)
			if !Empty(SZ8->Z8_ITENSOC)
				cItensOC := ALLTRIM(SZ8->Z8_ITENSOC)
				aItens := StrTokArr(cItensOC,"#")
				for i := 1 to LEN(aItens)
					aItens[i] := "Produto: "+substr(aItens[i],1,at("/",aItens[i])-1)
					oMenuItem := tMenuItem():new(oMenu01,aItens[i],,,,{||},,,,,,,,,.T.)
					oMenu01:Add(oMenuItem)
				next
			else
				AAdd(aItens,"Produto: "+ALLTRIM(SZ8->Z8_PRODUTO))
				for i := 1 to LEN(aItens)
					oMenuItem := tMenuItem():new(oMenu01,aItens[i],,,,{||},,,,,,,,,.T.)
					oMenu01:Add(oMenuItem)
				next
			endif
		endif
	endcase

	restArea(wArea)

return

User function SMFATI02(p_cOC)
	// p_cOC = wNumOC
	Local wArea     := getArea()
	Local cLacre
	Local cOC       := iif(p_cOC == nil,'',p_cOC)
	Local cTPoper   := SZ8->Z8_TPOPER
	Local cPallet   := SZ8->Z8_PALLET
	Local cLacreAnt := SZ8->Z8_LACRE

	dbSelectArea("SZ8")
	dbsetorder(1)
	dbSeek(xFilial("SZ8") + cOC) //Posiciona na OC para forcar o posiconamento


	if Empty(cOC) .Or. cTPoper <> 'C' .Or. cPallet <> 'G'
		restArea(wArea)
		return .F.
	endif




	//Verificar produto que não precisa de LACRES -  Juailson - Semar 04/03/2015
	lNaoLacrar := U_SmPrdNLacr("COM_MENS")

	if lNaoLacrar // Se verdadeiro não recebe os lacres, pois tem produto na empresa 30 com produtos para nao lacrar
		restArea(wArea)
		return .F.
	endif



	while empty(cLacre)
		cLacre:= u_frmLacres(Nil,cOC, "SMFATT99") // Essa funcao esta dentro do programa  MIZ996
		if empty(cLacre)
			if MsgNoYes("Nenhum lacre foi adicionado, deseja sair?","Atencao")
				restArea(wArea)
				return .f.
			endif
		endif
	end

	if !empty(SZ8->Z8_LACRE) .And. Alltrim(cLacre) <> Alltrim(SZ8->Z8_LACRE)
		if !MsgNoYes("Já existem lacres cadastrados para essa Ordem de Carregamento, deseja substituir?","Atencao")
			restArea(wArea)
			return .F.
		endif
	endif

	if reclock('SZ8',.F.) .And. !Empty(Alltrim(cLacre))
		SZ8->Z8_LACRE := Alltrim(cLacre)
		MsUnlock()
	endif

	dbSelectArea("SZ1")
	dbSetOrder(8)
	if MsSeek(xFilial("SZ1")+cOC)
		if reclock('SZ1',.F.) .And. !Empty(Alltrim(cLacre))
			SZ1->Z1_LACRE := Alltrim(cLacre)
			MsUnlock()
		endif
	endif

	restArea(wArea)

Return

// Ponto de entrada pada adicionar botão na enchoicebar do cadastro de cliente
// Adicionado por Rodrigo Feitosa 30/04/13
User function MA030BUT

	Local aUsrBut := {}
	//Local cEmps := GETNEWPAR("MV_SMCLIPL",'30')	// Desabilitado por Marcus Vinicius - 01/02/2016 - Função será utilizada em todas as filiais

	//if cEmpAnt $ cEmps	// Desabilitado por Marcus Vinicius - 01/02/2016
	AADD( aUsrBut, {"PEDIDO", {|| If(!Empty(M->A1_COD),SMFATT35(),ALERT('Operação inválida em caso de inclusão.'))},"Info Cliente"} )
	//endif					// Desabilitado por Marcus Vinicius - 01/02/2016

return aUsrBut

Static function SMFATT35()

	Private oDlg,oFolder,oBrw,oBrw2
	Private aHeader,aColSize,aCols
	Private aHeadee2,aColSize2,aCols2
	Private _aCampos,_aCampos2


	//--------------------------------------------- Primeira aba ---------------------------

	aHeader  := {}
	aColSize := {}
	//Monta aHeader e aColSize
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZI")

	nUsado := 0
	//_aCampos := {"ZI_LIBER","ZI_DTBLOQ","ZI_PRODUTO","ZI_DESC","ZI_DESCON","ZI_PRECO","ZI_DESCONF","ZI_PRECOF","ZI_DTREAJ","ZI_PGER","ZI_PRCUNIT","ZI_DTVIGEN","ZI_USRINC"}
	_aCampos := {"ZI_PRODUTO","ZI_PRECO","ZI_PRECOF","ZI_PRECOD"}

	for i := 1 to LEN(_aCampos)

		dbSelectArea("SX3")
		dbSetOrder(2)
		if DbSeek(_aCampos[i])
			If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
				nUsado := nUsado + 1
				aadd(aHeader,{ trim(SX3->X3_TITULO)} )
				aadd(aColSize,{ SX3->X3_TAMANHO } )
			Endif
		endif
	next

	//Monta aCabec
	aCabec := Array(LEN(aHeader))
	for x := 1 to LEN(aHeader)
		aCabec[x] := aHeader[x,1]
	next

	//Monta aCols
	aCols := {}
	dbSelectArea("SZI")
	dbSetOrder(1)
	if dbSeek(xFilial('SZI')+M->A1_COD+M->A1_LOJA)
		While !eof() .and. SZI->ZI_FILIAL   == xFilial("SZI") ;
		.and. SZI->ZI_CLIENTE   == M->A1_COD ;
		.and. SZI->ZI_LOJA      == M->A1_LOJA
			if SZI->ZI_LIBER <> 'L'
				DbSkip()
				Loop
			endif
			aadd(aCols,array(nUsado+1))
			For a := 1 to nUsado
				aCols[len(aCols),a]    := FieldGet(FieldPos(_aCampos[a]))
			Next
			aCols[len(aCols),nUsado+1] := .F.
			dbSkip()
		EndDo
	endif

	//--------------------------------------------- Segunda aba ---------------------------
	aHeader2  := {}
	aColSize2 := {}
	//Monta aHeader2 e aColSize2
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("ZA6")

	nUsado := 0
	_aCampos2 := {"ZA6_VALOR","ZA6_PRAZO"}

	for i := 1 to LEN(_aCampos2)

		dbSelectArea("SX3")
		dbSetOrder(2)
		if DbSeek(_aCampos2[i])
			If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
				nUsado := nUsado + 1
				aadd(aHeader2,{ trim(SX3->X3_TITULO)} )
				aadd(aColSize2,{ SX3->X3_TAMANHO } )
			Endif
		endif
	next

	//Monta aCabec2
	aCabec2 := Array(LEN(aHeader2))
	for x := 1 to LEN(aHeader2)
		aCabec2[x] := aHeader2[x,1]
	next

	//Monta aCols2
	aCols2 := {}
	dbSelectArea("ZA6")
	dbSetOrder(1)
	if dbSeek(xFilial('ZA6')+M->A1_COD+M->A1_LOJA)
		While !eof() .and. ZA6->ZA6_FILIAL   == xFilial("ZA6") ;
		.and. ZA6->ZA6_CLIENTE   == M->A1_COD ;
		.and. ZA6->ZA6_LOJA      == M->A1_LOJA
			if ZA6->ZA6_LIBER <> 'L'
				dbSkip()
				Loop
			endif
			aadd(aCols2,array(nUsado+1))
			For a := 1 to nUsado
				aCols2[len(aCols2),a]    := FieldGet(FieldPos(_aCampos2[a]))
			Next
			aCols2[len(aCols2),nUsado+1] := .F.
			dbSkip()
		EndDo
	endif


	oDlg      := MSDialog():New( 080,092,400,980,"Informações do Cliente",,,.F.,,,,,,.T.,,,.T. )
	oFolder   := TFolder():New( 0,0,{"Tabela de Preços","Limite de Credito"},,oDlg,,,,.T.,.F.,540,300,)
	oBrw      := TCBrowse():New( 012,005,430,109,,aCabec,aColSize,oFolder:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	oBrw2     := TCBrowse():New( 012,005,430,109,,aCabec2,aColSize2,oFolder:aDialogs[2],,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	oBrw:SetArray(aCols)
	if LEN(aCols) > 0
		/*oBrw:bLine := {||{ aCols[oBrw:nAt,01], ;
		aCols[oBrw:nAt,02], ;
		aCols[oBrw:nAt,03], ;
		aCols[oBrw:nAt,04], ;
		Transform(aCols[oBrw:nAt,05],'@E 999.9999'), ;
		Transform(aCols[oBrw:nAt,06],'@e 999,999,999.99'), ;
		Transform(aCols[oBrw:nAt,07],'@e 999.9999'), ;
		Transform(aCols[oBrw:nAt,08],'@E 999,999,999.99'), ;
		aCols[oBrw:nAt,09], ;
		Transform(aCols[oBrw:nAt,10],'@E 99,999,999.99'), ;
		Transform(aCols[oBrw:nAt,11],'@E 9,999,999.999999'), ;
		aCols[oBrw:nAt,12], ;
		aCols[oBrw:nAt,13]}}   */
		oBrw:bLine := {||{ aCols[oBrw:nAt,01], ;
		Transform(aCols[oBrw:nAt,02],'@e 999,999,999.99'), ;
		Transform(aCols[oBrw:nAt,03],'@E 999,999,999.99'), ;
		Transform(aCols[oBrw:nAt,04],'@E 999,999,999.99')}}
	endif
	oBrw2:SetArray(aCols2)
	if LEN(aCols2) > 0
		oBrw2:bLine := {||{ Transform(aCols2[oBrw2:nAt,01],'@E 999,999,999.99'), ;
		aCols2[oBrw2:nAt,02]}}
	endif
	oDlg:Activate(,,,.T.)

return

Static Function SMFATF96(_oBrwAux,p_nOpcao,p_cStatus)

	Local aAreaAtu  := GetArea()
	//Local cStat		:= if(cEmpAnt $ '30|01|40',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40	//Comentado por Rodrigo (Semar) - 21/06/16
	Local cStat		:= if(cEmpAnt + cFilAnt $ '3001|0210|0101|0218|4001|0203',"Z8_STATUS2","Z8_STATUS") // EMPRESA 40

	dbSelectArea("SZ8")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ8")+_oBrwAux:aArray[_oBrwAux:nAT,7])
		Reclock("SZ8",.F.)
		do case
			case p_cStatus == "A"
			if p_nOpcao == 2
				SZ8->&(cStat) 	:= "1"
				SZ8->Z8_HORAATU := time()
				SZ8->Z8_HRCHPG  := ''
			endif
		endcase
		SZ8->(MsUnlock())

		//Grava no BANCO DE DADOS SIGEX a mensagem na tabela de mensagens
		//###############################################################
		u_SMFATF60(_oBrwAux:aArray[_oBrwAux:nAT,7] , _oBrwAux:aArray[_oBrwAux:nAT,4])

	EndIf

	SMFATC01()

	RestArea(aAreaAtu)

return

Static function SMFATFX01(p_aArray,p_nPosSep,p_cValSep)

	Local nPosSep	:= if(p_nPosSep==nil,1,p_nPosSep)
	Local cValSep	:= if(p_cValSep==nil,'',p_cValSep)
	Local aValSep := StrToKArr(cValSep,"|")
	Local nQtdSep	:= LEN(aValSep)
	Local aArrSep	:= {}
	Local nContN	:= 1
	Local nContP	:= 1
	Local nContU	:= 1
	Local aRet		:= {}

	// Verifica quantos valores vão separar o array, e cria seus arrays correpondentes.
	for nX := 1 to nQtdSep
		&("aArrayS"+cValtoChar(nX)) := {}
		AAdd(aArrSep,"aArrayS"+cValtoChar(nX))
	next

	// Realiza a separação
	for nX := 1 to LEN(p_aArray)
		for nY := 1 to nQtdSep
			if p_aArray[nX][nPosSep] == aValSep[nY]
				AAdd(&(aArrSep[nY]),p_aArray[nX])
				EXIT
			endif
		next nY
	next nX

	// Realiza a ordenação
	for nX := 1 to LEN(p_aArray)
		do case
			case (nX%2==0 .AND. nContN <= LEN(aArrayS1)) .Or. (nContP > LEN(aArrayS2) .And. nContN <= LEN(aArrayS1))
			AAdd(aRet,aArrayS1[nContN])
			nContN++
			case (nX%2!=0 .AND. nContP <= LEN(aArrayS2)) .Or. (nContN > LEN(aArrayS1) .And. nContP <= LEN(aArrayS2))
			AAdd(aRet,aArrayS2[nContP])
			nContP++
			otherwise
			AAdd(aRet,aArrayS3[nContU])
			nContU++
		endcase
	next nX

	p_aArray := aRet

return

// L  A C R E
/*
receber o Codigo do PAGER(Z8_CBPAGER)   procurar na SZ8, e retornar o Z8_OC

e chamar o programa que cadastra os lacres.

Em 15/10/14 -

*/

User Function SMCBPAGER() //  U_SMCBPAGER()
	Private   cOC := ""
	private  cCbPager := SPACE(TAMSX3('Z8_CBPAGER')[1])

	//COORDENADAS
	//  300 horiz             800 horizontal
	//  + 300 =Vertical -----+
	//  |
	//  |
	//  + 380 vertical
	oDlgP 			:= TDialog():New(300,600,380,800,"Codigo do PAGER",,,,,,,,,.T.)

	oGetPager		:= TGet():New(4,6,{|u| If(PCount() > 0 , cCbPager   := u, cCbPager  ) },oDlgP,;
	90,9,,{|| },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cCbPager ,,,,)
	//									90,9,,{|| U_SMLERSZ8(cCbPager)},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cCbPager ,,,,)

	oButtonOC		:= TButton():New(25,28,"OK",oDlgP,{|| U_SMLERSZ8(cCbPager),oDlgP:End()},45,10,,,,.T.)
	//    oButtonOC		:= TButton():New(20,4,"OK",oDlgP,{|| U_SMLERSZ8(cCbPager),oDlgP:End()},40,10,,,,.T.)

	oDlgP:Activate()

Return cOC

//ler SZ8

User Function SMLERSZ8(cCbPager)
	local lRet := .T.
	Local nCont := 0
	local cSair := "N"
	Local cTableQry		:= "SZ8PAGER"
	local cOC           := ""
	Local cStatDF		:= "B" //Qual status vai representar o momento da validação da danfe.

	if empty(cCbPager)
		cCbPager := SPACE(TAMSX3('Z8_CBPAGER')[1])
		return cOC
	endif


	cQuery := "SELECT  Z8_CBPAGER, Z8_DATA, Z8_OC, Z8_PLACA, Z8_MOTOR, Z8_NOMMOT, Z8_LACRE, R_E_C_N_O_ AS RECNO FROM "+RetSqlName("SZ8")+ " "
	if    len(alltrim(cCbPager))  >= len(SPACE(TAMSX3('Z8_CBPAGER')[1])) // se for tamanho menor ler pelo codigo do pager Jualson Semar 31/03/15

		cQuery += "WHERE Z8_CBPAGER = '"+cCbPager+"' AND Z8_FILIAL = '"+xFilial("SZ8")+"' "

	else
		cQuery += "WHERE Z8_PAGER = '"+ alltrim(cCbPager) +"' AND Z8_FILIAL = '"+xFilial("SZ8")+"' "

	endif
	cQuery += "AND D_E_L_E_T_ = ' ' AND Z8_DATA >= '"+DTOS(dDataBase-1)+"' "
	cQuery += "AND Z8_FATUR <> 'S' "
	cQuery += "AND Z8_TPOPER = 'C' "
	cQuery += "AND Z8_PALLET = 'G' "

	If Select(cTableQry)>0
		DbSelectArea(cTableQry)
		DbCloseArea()
	Endif

	TCQUERY cQuery New Alias (cTableQry)

	nCont :=Contar(cTableQry,"!Eof()") //
	if nCont > 1
		alert ("Encontrou " + alltrim(str(nCont)) + " OCs." )
	endif

	(cTableQry)->(DbGoTop())


	If (cTableQry)->(!EOF())
		DbSelectArea("SZ8")
		DbSetOrder(1)
		//	DbGoTo((cTableQry)->RECNO)
		if !MsSeek(xFilial("SZ8") +(cTableQry)->Z8_OC)
			Alert ("Não econtrou OC na SZ8" + (cTableQry)->Z8_OC )
		endif
		While (cTableQry)->(!EOF()) .and. cSair == "N"

			wData := substr((cTableQry)->Z8_DATA, 7, 2) + "-" + substr((cTableQry)->Z8_DATA, 5, 2) + "-" + substr((cTableQry)->Z8_DATA, 1, 4)

			/*
			if !MSGYESNO("OC: " + (cTableQry)->Z8_OC + CRLF +  "Data: " + wData + CRLF + "Placa: " + (cTableQry)->Z8_PLACA + ;
			CRLF + "Motorista: " + (cTableQry)->Z8_NOMMOT + CRLF + "Confirma ?")
			(cTableQry)->(DbSkip())
			else
			*/
			cOC := (cTableQry)->Z8_OC

			//RECEBER OS LACRES
			lRet := u_SMFATI02(cOC) //   Chama a funcao frmLacres que esta no MIZ996
			cSair := "S"
			/*
			if lRet == .F.
			alert("Não foi cadastrado lacres.")
			endif
			*/

			//     endif


		EndDo
	else
		alert("Não foi encontrada OC para o PAGER, que satisfaça condições para Lacre"  + CRLF + "Data entre ontem e hoje," + ;
		CRLF + "Nao faturada, " + CRLF + "Ser carregamento a granel")
	endif

	(cTableQry)->(DbCloseArea())

return cOC

User Function SMFATT90()

	Local oLayer 		:= FWLayer():new()
	Local oLayerD 	:= FWLayer():new()
	Local nQtdBtns	:= 6
	Local aAreaBtns
	Local aAux
	//Array da Capacidade Em andamento
	Local aCapAnd		:= {{"",{|u| If(PCount()>0,nVPC:=u,nVPC)},"nVPC"},;
	{"",{|u| If(PCount()>0,nVC:=u,nVC)},"nVC"},;
	{"",{|u| If(PCount()>0,nVD:=u,nVD)},"nVD"},;
	{"",{|u| If(PCount()>0,nVPD:=u,nVPD)},"nVPD"}}

	//Array da Capacidade Fabrica
	Local aCapFab		:= {{{|| "No Pátio:"},{|u| If(PCount()>0,nMVP:=u,nMVP)},"nMVP"},;
	{{|| "Carregamento:"},{|u| If(PCount()>0,nMVC:=u,nMVC)},"nMVC"},;
	{{|| "Descarregando:"},{|u| If(PCount()>0,nMVD:=u,nMVD)},"nMVD"}}

	//Array de Legendas
	Local nQtdLinhas	:= 0
	Local nQtdCols	:= 5
	Local aLegs		:= {{{||"1 - Pátio"},"BR_AMARELO"},;
	{{||"2 - Chamado"},"BR_VERDE"},;
	{{||"3 - Pesado na Entrada"},"BR_PINK"},;
	{{||"4 - Início Carg/Desc"},"BR_AZUL"},;
	{{||"5 - Fim Carg/Desc"},"BR_PRETO"},;
	{{||"5 - Fim Loneamento"},"BR_LONA"},;
	{{||"6 - Pesar Saida"},"BR_VERMELHO"},;
	{{||"6 - NF Cancelada"},"BR_VERMELHO_ATT"},;
	{{||"7 - Pesar Entrada"},"BR_MARROM"},;
	{{||"8 - Pronto p/Faturar"},"BR_LARANJA"},;
	{{||"9 - Entregar NF"},"BR_LARNFE"},;
	{{||"A - Entrada liberada"},"BR_VIOLETA"},;
	{{||"B - Validar danfe"},"NOTE_PQ"},;
	{{||"L - Liberar sensor"},"BR_SIRENE"}}

	//Array de botões
	/*Local aBtnsNF		:= {{"NF-e Sefaz",{|| SMFATF58('NFE')  },'3001|0210|0101|0218'},;
	{"Monitor",{|| u_SMFATF56('MNT')},'3001|0210|0101|0218'},;
	{"Danfe",{|| u_SMFATF56('DAN')},'3001|0210|0101|0218'},;
	{"Status Sefaz",{|| u_SMFATF56('STA')},'3001|0210|0101|0218'},;
	{"Transmissão",{|| u_SMFATF56('REM')},'3001|0210|0101|0218'}}*/

	Local aBtnsNF		:= {{"NF-e Sefaz",{|| SMFATF58('NFE')  },'3001|0210|0101|0218', 'SPEDNFE' },;
	{"Monitor",{|| u_SMFATF56('MNT')},'3001|0210|0101|0218', 'SPEDNFE1MN' },;
	{"Danfe",{|| u_SMFATF56('DAN')},'3001|0210|0101|0218', 'SPEDDANFE' },;
	{"Status Sefaz",{|| u_SMFATF56('STA')},'3001|0210|0101|0218', 'SPEDNFESTA' },;
	{"Transmissão",{|| u_SMFATF56('REM')},'3001|0210|0101|0218', 'SPEDNFERE2' }}

	/*Local aBtnsPed	:= {{"Pedido Mizu",{||  SMFATF58('PED')},'3001|0210|0101|0218'},;
	{"Agenciamento",{||  SMFATF58('AGE')},'3001|0210|0101|0218'},;
	{"Imp.Ord.Carreg",{||  SMFATF58('IOC')},'3001|0210|0101|0218'},;
	{"Lacre",{||  SMFATF58('LAC')},'3001|0210|0101|0218'},;
	{"Cancela Entrada",{||  SMFATF58('CEN')},'0101|0218'},; //Sergio(semar) 19.05.16 - desabilitada para empresa 30, devido a rastreabilidade
	{"Recup.Pes.Ent",{|| SMFATF58('RPE')},'0101|0218'}}*/

	Local aBtnsPed	:= {{"Pedido Mizu",{||  SMFATF58('PED')},'3001|0210|0101|0218', 'MIZ016' },;
	{"Agenciamento",{||  SMFATF58('AGE')},'3001|0210|0101|0218', 'SMFATT13' },;
	{"Imp.Ord.Carreg",{||  SMFATF58('IOC')},'3001|0210|0101|0218', 'MIZ050GR' },;
	{"Lacre",{||  SMFATF58('LAC')},'3001|0210|0101|0218', 'SMCBPAGER' },;
	{"Cancela Entrada",{||  SMFATF58('CEN')},'0101|0218', 'MIZ030' },;
	{"Recup.Pes.Ent",{|| SMFATF58('RPE')},'0101|0218', 'SMFATT41' }}

	// SERGIO - DEVERÁ SER DESSA FORMA COM 4 PARAMETROS
	Local aBtnsIT		:= {{"Ticket Balanca",{||  SMFATF58('TK1')},'3001|0210', 'MIZ790' },;
	{"Ticket Bal. Ent/Sai",{||  SMFATF58('TK2')},'3001|0210' , 'RTICKET' }}


	/*Local aBtnsIT		:= {{"Ticket Balanca",{||  SMFATF58('TK1')},'3001|0210' },;
	{"Ticket Bal. Ent/Sai",{||  SMFATF58('TK2')},'3001|0210'  }}*/

	/*Local aBtnsCad	:= {{"Cliente",{||  SMFATF58('CLI') },'3001|0210|0101|0218'},;
	{"Motorista",{||  SMFATF58('MOT')},'3001|0210|0101|0218'},;
	{"Transportador",{||  SMFATF58('TRA')},'3001|0210|0101|0218'},;
	{"Caminhão",{||  SMFATF58('CAM')},'3001|0210|0101|0218'},;
	{"Carreta",{||  SMFATF58('CAR')},'3001|0210|0101|0218'},;
	{"Portaria",{|| U_SMFATT40()},'0101|0218'}}*/

	Local aBtnsCad	:= {{"Cliente",{||  SMFATF58('CLI') },'3001|0210|0101|0218', 'MATA030' },;
	{"Motorista",{||  SMFATF58('MOT')},'3001|0210|0101|0218', 'U_MIZ010' },;
	{"Transportador",{||  SMFATF58('TRA')},'3001|0210|0101|0218', 'MATA050' },;
	{"Caminhão",{||  SMFATF58('CAM')},'3001|0210|0101|0218', 'MIZ005' },;
	{"Carreta",{||  SMFATF58('CAR')},'3001|0210|0101|0218', 'MIZ1030' },;
	{"Portaria",{|| U_SMFATT40()},'0101|0218', 'SMFATT40' }}

	////               ////
	//Variaveis Privadas//
	////             ////

	// Variaveis do quadro estatistico
	Private nMVC       := SuperGetMv("MV_MAXVECA",,25)
	Private nMVD       := SuperGetMv("MV_MAXVEDE",,20)
	Private nMVP       := SuperGetMv("MV_MAXVEPA",,30)
	Private nVC        := 0
	Private nVD        := 0
	Private nVP        := 0
	Private nVPC,nVPD  := 0
	// Variaveis dos browsers
	Private oBrw1,oBrw2,oBrw3,oBrw4
	Private oBrw5,oBrw6,oBrw7,oBrw8
	Private oPnl1,oPnl2,oPnl3,oPnl4
	Private oPnl5,oPnl6,oPnl7,oPnl8
	Private oPanMid,oPanMidD
	Private waheader  	:= {}
	Private waColSizes	:= {}
	Private lUsaDescSaco	:= .T.
	Private lUsaCarrSaco	:= .T.
	Private aTitBrw		:= {"Pátio Saco","Pátio Granel","Fábrica Saco","Fábrica Granel"}
	Private aTitBrwD		:= {"Pátio Saco","Matéria Prima - Pátio","Fábrica Saco","Matéria Prima - Descarregamento"}
	// Variaveis da tela antiga
	Private cperg			:='MZ999TEL1'
	Private luserFull 	:= .F.
	Private oMenu01
	Private oMenuItem01,oMenuItem02,oMenuItem03,oMenuItem04
	Private oBrwMenu
	Private wNumOC     	:= ""
	Private aFilBrw	    :={}
	Private aList1 := {}, aList2 := {}, aList3 := {}
	Private aList4 := {}, aList5 := {}, aList6 := {}
	Private aList7 := {}, aList8 := {}
	Private lUsaNewOC 	:= ( cFilAnt $  getnewPar('MV_USNEWOC','01') )
	Private oAmarelo    	:= LoadBitmap(GetResources(),'BR_AMARELO')
	Private oVerde 		:= LoadBitmap(GetResources(),'BR_VERDE')
	Private oPink 		:= LoadBitmap(GetResources(),'BR_PINK')
	Private oVermelho 	:= LoadBitmap(GetResources(),'BR_VERMELHO')
	Private oAzul 		:= LoadBitmap(GetResources(),'BR_AZUL')
	Private oCinza 		:= LoadBitmap(GetResources(),'BR_PRETO')
	Private oCinzaLona	:= LoadBitmap(GetResources(),'BR_LONA')
	Private oBranco		:= LoadBitmap(GetResources(),'BR_BRANCO')
	Private oMarrom	  	:= LoadBitmap(GetResources(),'BR_MARROM')
	Private oLaranja    	:= LoadBitmap(GetResources(),'BR_LARANJA')
	Private oCinz			:= LoadBitmap(GetResources(),'BR_VIOLETA')
	Private oVermAtt		:= LoadBitmap(GetResources(),'BR_VERMELHO_ATT')
	Private oLarNF			:= LoadBitmap(GetResources(),'BR_LARNFE')
	Private oLibSens		:= LoadBitmap(GetResources(),'BR_SIRENE')
	// Variaveis de font
	Private oFont1		:= TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
	Private oFont2		:= TFont():New( "Verdana",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	Private oFont3		:= TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	//Private cEmpRastroOC := getNewPar('MZ_RASTEMP','30')  //codigo da empresa que controla o rastro da OC  Comentado por Alison 19/07/2016
	Private cEmpRastroOC := getNewPar('MZ_RASTEMP','3001|0210')  //codigo da empresa que controla o rastro da OC
	Private aGrpUsu		:= u_smGetGrupo()
	Private aPerfil		:= u_carregaPerfil(aGrpUsu)

	//testa liberação de acesso a rotina
	if !u_SMGETACCESS(funname(),.f.); return; endif

	// DEFINE USUARIOS COM DIREITO DE OPERAR A TELA
	wUsers:=Upper(getnewPar('MV_MIZ999',''))
	if empty( wUsers )
		Alert('Parametro MV_MIZ999, nao localizado! Cadastre-o antes de continuar esta rotina. ')
		return
	endif

	lUserFull := u_ChkAcesso("MIZ999",6,.F.)  .or. ( Upper(Alltrim(SUBS(CUSUARIO,7,15))) $ 	wUsers  )



	//define modelo da tela c/ F12
	SMFATF61(cperg)

	// Define o tamanho e as colunas dos browses.
	SMFATF49()

	// Define a ordem de exibição dos botões por area
	/*aAreaBtns		:= {{aBtnsNF,{|| "Nota Fiscal"},'0101,3001'},;
	{aBtnsPed,{|| "Pedido"},'0101,3001'},;
	{aBtnsIT,{|| "Imp. Ticket"},'0101,3001'},;
	{aBtnsCad,{|| "Cadastros"},'3001'}}
	*/	//Comentado por Rodrigo (Semar) - 21/06/16
	aAreaBtns		:= {{aBtnsNF,{|| "Nota Fiscal"},'0101|0218|3001|0210'},;
	{aBtnsPed,{|| "Pedido"},'0101|0218|3001|0210'},;
	{aBtnsIT,{|| "Imp. Ticket"},'0101|0218|3001|0210'},;
	{aBtnsCad,{|| "Cadastros"},'3001|0210'}}

	aTam 			:= MsAdvSize(.F.)

	oDlg 			:= TDialog():New(aTam[7],0,aTam[6],aTam[5],"Controle do Tráfego de Carga e Descarga",,,,,,,,,.T.)

	aAreaTotal1 	:= {aTam[1],aTam[2],aTam[3],aTam[4],0,0}
	nDivisoes1		:= 2
	aProp1			:= {{0,5},{0,95}}
	oArea1 		:= redimensiona():New(aAreaTotal1,nDivisoes1,aProp1,.F.)
	aArea1			:= oArea1:RetArea()

	oFolder1   	:= TFolder():New(aArea1[2,1],aArea1[2,2],{"Carregamento","Descarregamento"},,oDlg,,,,.T.,.F.,;
	aArea1[2,4]-aArea1[2,2],aArea1[2,3]-aArea1[2,1],)

	// Cria menu no topo
	oTMenuBar := TMenuBar():New(oDlg)

	oTMenu1 := TMenu():New(0,0,0,0,.T.,,oDlg)
	oTMenuBar:AddItem('Ordem de Carregamento'  , oTMenu1, .T.)
	// Cria Itens do Menu
	oTMenuItem := TMenuItem():New(oDlg,'Agenciamento',,,u_smVldAcesso("SMFATT13",aGrpUsu),{||SMFATF58('AGE')},,'carga',,,,,,,.T.)
	oTMenu1:Add(oTMenuItem)
	oTMenuItem := TMenuItem():New(oDlg,'Lacre',,,u_smVldAcesso("SMCBPAGER",aGrpUsu),{||SMFATF58('LAC')},,'cadeado',,,,,,,.T.)
	oTMenu1:Add(oTMenuItem)
	oTMenuItem := TMenuItem():New(oDlg,'Follow Up',,,u_smVldAcesso("SMFLWUP",aGrpUsu),{||SMFATF58('FLW')},,'SelectAll',,,,,,,.T.)
	oTMenu1:Add(oTMenuItem)
	//oTMenuItem := TMenuItem():New(oDlg,'Cancelamento',,,,{||SMFATF58('CAN')},,'excluir',,,,,,,.T.)
	//oTMenuItem := TMenuItem():New(oDlg,IIF(cEmpAnt $ "30",'Alterar OC','Cancelar'),,,,{||SMFATF58('CAN')},,'excluir',,,,,,,.T.) //Normando (Semar) 12/11/2015 - Mudar botão caso sejá 30 //Comentado por Rodrigo (Semar) - 21/06/16
	oTMenuItem := TMenuItem():New(oDlg,IIF(cEmpAnt+cFilAnt $ "3001|0210",'Alterar OC','Cancelar'),,;
	,u_smVldAcesso("SMCANCEP",aGrpUsu),{||SMFATF58('CAN')},,'excluir',,,,,,,.T.) //Normando (Semar) 12/11/2015 - Mudar botão caso sejá 30
	oTMenu1:Add(oTMenuItem)
	//oTMenuItem := TMenuItem():New(oDlg,'Restaurar',,,,{||SMFATF58('RES')},,'CTBREPLA',,,,,,,.T.)
	//oTMenuItem := TMenuItem():New(oDlg,IIF(cEmpAnt $ "30",'Restaurar OC','Restaurar'),,,,{||SMFATF58('RES')},,'CTBREPLA',,,,,,,.T.)   //Normando (Semar) 12/11/2015 - Mudar botão caso sejá 30 //COmentado por Rodrigo (Semar) - 21/06/16
	oTMenuItem := TMenuItem():New(oDlg,IIF(cEmpAnt+cFilAnt $ "3001|0210",'Restaurar OC','Restaurar'),,;
	,u_smVldAcesso("SMRESTP",aGrpUsu),{||SMFATF58('RES')},,'CTBREPLA',,,,,,,.T.)   //Normando (Semar) 12/11/2015 - Mudar botão caso sejá 30
	oTMenu1:Add(oTMenuItem)
	oTMenuItem := TMenuItem():New(oDlg,'Alt. Local Carreg',,,u_smVldAcesso("SMFATF97",aGrpUsu),{|| U_SMFATF97("TRAF",wnumOC) },,'carga',,,,,,,.T.)
	oTMenu1:Add(oTMenuItem)
	//
	//bloqueado por Semar(sergio) em 16/03/16 - a mando de gustavo
	/*
	oTMenu2 := TMenu():New(0,0,0,0,.T.,,oDlg)
	oTMenuBar:AddItem('Financeiro'  , oTMenu2, .T.)
	oTMenuItem := TMenuItem():New(oDlg,'Tele-Cobrança',,,,{|| U_MZ0146() },,,,,,,,,.T.)
	oTMenu2:Add(oTMenuItem)
	*/
	oTMenu2 := TMenu():New(0,0,0,0,.T.,,oDlg)
	oTMenuBar:AddItem('Relatorios'  , oTMenu2, .T.)
	oTMenuItem := TMenuItem():New(oDlg,'Relatorio Ctr',,,u_smVldAcesso("MIZ755",aGrpUsu),{|| U_MIZ755() },,,,,,,,,.T.)
	oTMenu2:Add(oTMenuItem)
	oTMenuItem := TMenuItem():New(oDlg,'Emissao Ctr',,,u_smVldAcesso("MIZ751",aGrpUsu),{|| U_MIZ751() },,,,,,,,,.T.)
	oTMenu2:Add(oTMenuItem)
	///

	for nL := 1 to 2
		oLayerAux := if(nL==1,oLayer,oLayerD)

		bValue 	:= "{|| U_AlteraBrw(1,"+if(nL==1,'oPanMid','oPanMidD')+","+if(nL==1,'lUsaCarrSaco','lUsaDescSaco')+;
		",'"+if(nL==1,'','d')+"',"+if(nL==1,'0','4')+") }"

		//Inicializa o FWLayer com a janela que ele pertencera e se sera exibido o botão de fechar
		oLayerAux:init(oFolder1:aDialogs[nL],.F.)
		//Cria as colunas do Layer
		oLayerAux:addCollumn('Col01',90,.F.)
		oLayerAux:addCollumn('Col02',10,.F.)
		//Adiciona Janelas as colunas
		oLayerAux:addWindow('Col01','C1_Win01','',75,.T.,.F.,{||  },,{||  })
		oLayerAux:addWindow('Col01','C1_Win02','Legendas / Estatísticas',25,.T.,.T.,;
		&(bValue),,{||  })
		oLayerAux:addWindow('Col02','C2_Win01','Botões',100,.T.,.F.,{||  },,{|| })
		oLayerAux:getWinPanel('Col02','C2_Win01')
		//Coloca o botão de split na coluna
		oLayerAux:setColSplit('Col02',CONTROL_ALIGN_LEFT,,&(bValue))
	next nL

	//Paineis
	oPanBtns		:= oLayer:GetWinPanel('Col02','C2_Win01')
	oPanMid		:= oLayer:GetWinPanel('Col01','C1_Win01')
	oPanLeg		:= oLayer:GetWinPanel('Col01','C1_Win02')
	oPanBtnsD		:= oLayerD:GetWinPanel('Col02','C2_Win01')
	oPanMidD		:= oLayerD:GetWinPanel('Col01','C1_Win01')
	oPanLegD		:= oLayerD:GetWinPanel('Col01','C1_Win02')

	// Cria browsers
	for nX := 1 to 2
		cNX := cValtoChar(nX)
		oPanAux := if(nX==1,oPanMid,oPanMidD)
		for nY := 1 to 4
			cNY := cValtoChar(if(nX==1,nY,nY+4))
			blDBLClick  := "{|| SMFATF50(@oBrw"+cNY+")}"
			bSEEKCHANGE := "{|| SMFATF59(@oBrw"+cNY+")}"
			bRClicked   := "{|oObj,X,Y| SMFATI01('Prov',oBrw"+cNY+"),oMenu01:Activate( X, Y, oObj )}"
			&("oPnl"+cNY)	:= TPanel():New(0,0,"abc",oPanAux,oFont1,.T.,,CLR_WHITE,,0,0)
			&("oBrw"+cNY) := TCBrowse():New(0,0,0,0,,waHeader,waColSizes,oPanAux,,,,,{||},,/*oFont3*/,,,,,.F.,,.T.,,.F.,,.T.,.T.)
			&("oBrw"+cNY):blDBLClick		:= &(blDBLClick)
			&("oBrw"+cNY):BSEEKCHANGE	:= &(bSEEKCHANGE)
			if nX == 1
				//BGOTFOCUS		:= "{|| if(LEN(oBrw"+cNY+":aArray) == 1 .Or. oBrw"+cNY+":nAT == 1,(Alert(oBrw"+cNY+":aArray[oBrw"+cNY+":nAT,7])),) }"
				//BGOTFOCUS		:= "{|| Alert(cValToChar(oBrw"+cNY+":nRowPos)) }"
				&("oBrw"+cNY):BGOTFOCUS		:= &(bSEEKCHANGE)   //Rodrigo/Juailson Semar - em 30/12/14 - Para pegar a OC da primeira ocorrencia no browser
			endif
			&("oBrw"+cNY):bRClicked		:= &(bRClicked)
		next nY
	next nX
	// Calcula area do centro
	U_AlteraBrw(1,oPanMid,lUsaCarrSaco,'',0)		// Carregamento
	U_AlteraBrw(1,oPanMidD,lUsaDescSaco,'d',4)	// Descarregamento

	// Realiza a consulta para popular os browses
	U_SMFATA07(0)

	//
	////
	// Calcula area de legendas/Estatisticas
	aAreaTotal5 	:= {0,0,oPanLeg:nWidth/2,oPanLeg:nHeight/2,1,1}
	nDivisoes5		:= 3
	aProp5			:= {{80,0},{12,0},{8,0}}
	oArea5 		:= redimensiona():New(aAreaTotal5,nDivisoes5,aProp5,.T.)
	aArea5			:= oArea5:RetArea()
	////
	// Calcula area de legendass

	// Calcula a quantidade de linhas de legenda de acordo com resolução do usuario
	nClientHeight	:= oDlg:nClientHeight
	nClientWidth	:= oDlg:nClientWidth

	if nClientHeight < 900
		nQtdLinhas := 3
	else
		nQtdLinhas := 4
	endif
	// Cria os arrays de legenda
	for nX := 1 to nQtdCols
		if type("aLegs"+cValtoChar(nX)) != 'A'
			&("aLegs"+cValtoChar(nX)) := {}
		endif
	next nX
	// popula os arrays
	nColAux := 1
	nLinAux := 1
	for nX := 1 to Len(aLegs)
		if nLinAux > nQtdLinhas
			nLinAux := 1
			nColAux++
		endif

		AAdd(&("aLegs"+cValtoChar(nColAux)),aLegs[nX])
		nLinAux++
	next nX


	aAreaT20	 	:= {aArea5[1,2],aArea5[1,1],aArea5[1,4],aArea5[1,3],3,3}
	nDivis20		:= nQtdCols
	aProp20		:= {}
	for nA :=  1 to nQtdCols
		AAdd(aProp20,{25,0})
	next nA
	oArea20 		:= redimensiona():New(aAreaT20,nDivis20,aProp20,.T.)
	aArea20		:= oArea20:RetArea()

	for nX := 1 to nQtdCols
		cNX := cValtoChar(nX)
		&("aAreaT2"+cNX)	:= {aArea20[nX,2],aArea20[nX,1],aArea20[nX,4],aArea20[nX,3],1,1}
		&("nDivis2"+cNX)	:= nQtdLinhas
		&("aProp2"+cNX)	:= {}
		for nA := 1 to nQtdLinhas
			AAdd(&("aProp2"+cNX),{0,25})
		next nA
		&("oArea2"+cNX)	:= redimensiona():New(&("aAreaT2"+cNX),;
		&("nDivis2"+cNX),;
		&("aProp2"+cNX),;
		.F.)
		&("aArea2"+cNX)	:= &("oArea2"+cNX):RetArea()

		for nY := 1 to nQtdLinhas
			cNY := cValtoChar(nX+5)
			&("aAreaT2"+cNY)	:= {&("aArea2"+cNX)[nY,2],&("aArea2"+cNX)[nY,1],&("aArea2"+cNX)[nY,4],&("aArea2"+cNX)[nY,3],1,1}
			&("nDivis2"+cNY)	:= 2
			&("aProp2"+cNY)	:= {{10,0},{90,0}}
			&("oArea2"+cNY)	:= redimensiona():New(&("aAreaT2"+cNY),;
			&("nDivis2"+cNY),;
			&("aProp2"+cNY),;
			.T.)
			&("aArea2"+cNY)	:= &("oArea2"+cNY):RetArea()


			aAux := &("aLegs"+cNX)

			for nL := 1 to 2
				cNL := cValtoChar(nL)
				oPanAux := if(nL==1,oPanLeg,oPanLegD)

				if(nX==1 .AND. nY==1,(oGroup  := TGroup():New(aArea5[1,1],aArea5[1,2],aArea5[1,3],aArea5[1,4],"",oPanAux,,,.T.)),)

				if nY <= LEN(aAux)
					&("oBmp"+cNX+cNY+cNL)		:= TBitmap():New( &("aArea2"+cNY)[1,1],&("aArea2"+cNY)[1,2],&("aArea2"+cNY)[1,4]-&("aArea2"+cNY)[1,2],;
					&("aArea2"+cNY)[1,3]-&("aArea2"+cNY)[1,1],aAux[nY][2],,.T.,oPanAux,,,.F.,.T.,,"",.T.,,.T.,,.F.)

					&("oSayL"+cNX+cNY+cNL)		:= TSay():New(&("aArea2"+cNY)[2,1],&("aArea2"+cNY)[2,2],aAux[nY][1],oPanAux,"",/*oFont*/,,,,.T.,,,;
					&("aArea2"+cNY)[2,4]-&("aArea2"+cNY)[2,2],&("aArea2"+cNY)[2,3]-&("aArea2"+cNY)[2,1])

				endif

			next nL
		next nY
	next nX
	////
	// Calcula area do quadro estatistico - Capacidade Fabrica
	aAreaTotal7 	:= {aArea5[2,2],aArea5[2,1],aArea5[2,4],aArea5[2,3],1,5}
	nDivisoes7		:= 2
	aProp7			:= {{60,0},{40,0}}
	oArea7 		:= redimensiona():New(aAreaTotal7,nDivisoes7,aProp7,.T.)
	aArea7			:= oArea7:RetArea()

	for nX := 1 to 2
		cNX := cValtoChar(nX)
		&("aAreaT3"+cNX)	:= {aArea7[nX,2],aArea7[nX,1],aArea7[nX,4],aArea7[nX,3],1,1}
		&("nDivis3"+cNX)	:= 3
		&("aProp3"+cNX)	:= {{0,25},{0,25},{0,25}}
		&("oArea3"+cNX)	:= redimensiona():New(&("aAreaT3"+cNX),;
		&("nDivis3"+cNX),;
		&("aProp3"+cNX),;
		.F.)
		&("aArea3"+cNX)	:= &("oArea3"+cNX):RetArea()

		for nY := 1 to 3
			cNY := cValtoChar(nY)
			for nL := 1 to 2
				cNL := cValtoChar(nL)
				oPanAux := if(nL==1,oPanLeg,oPanLegD)

				if(nX==1 .AND. nY==1,(oGrpCF  := TGroup():New(aArea5[2,1],aArea5[2,2],aArea5[2,3],aArea5[2,4],"Capacidade Fabrica",oPanAux,,,.T.)),)

				do case
					case nX == 1 .AND.  nX <= LEN(aCapFab)
					&("oSayCF"+cNX+cNY)	:= TSay():New(&("aArea3"+cNX)[nY,1]+((&("aArea3"+cNX)[nY,3]-&("aArea3"+cNX)[nY,1])/3),;
					&("aArea3"+cNX)[nY,2],aCapFab[nY][1],oPanAux,"",/*oFont*/,,,,.T.,,,;
					&("aArea3"+cNX)[nY,4]-&("aArea3"+cNX)[nY,2],&("aArea3"+cNX)[nY,3]-&("aArea3"+cNX)[nY,1])
					case nX == 2 .AND. nX <= Len(aCapFab)
					&("oGetCF"+cNX+cNY)	:= TGet():New(&("aArea3"+cNX)[nY,1],&("aArea3"+cNX)[nY,2],aCapFab[nY][2],oPanAux,;
					&("aArea3"+cNX)[nY,4]-&("aArea3"+cNX)[nY,2],&("aArea3"+cNX)[nY,3]-&("aArea3"+cNX)[nY,1],;
					"999",,,,/*oFont*/,,,.T.,,,,,,,.T.,.F.,,aCapFab[nY][3])
				endcase
			next nL
		next nY
	next nX
	////
	// Calcula area do quadro estatistico - Em andamento
	aAreaTotal8 	:= {aArea5[3,2],aArea5[3,1],aArea5[3,4],aArea5[3,3],1,5}
	nDivisoes8		:= 1
	aProp8			:= {{100,0}}
	oArea8 		:= redimensiona():New(aAreaTotal8,nDivisoes8,aProp8,.T.)
	aArea8			:= oArea8:RetArea()

	aAreaTotal9 	:= {aArea8[1,2],aArea8[1,1],aArea8[1,4],aArea8[1,3],10,1}
	nDivisoes9		:= 3
	aProp9			:= {{0,30},{0,30},{0,30}}
	oArea9 		:= redimensiona():New(aAreaTotal9,nDivisoes9,aProp9,.F.)
	aArea9			:= oArea9:RetArea()

	for nX := 1 to 3
		cNX := cValtoChar(nX)
		for nL := 1 to 2
			cNL := cValtoChar(nL)
			oPanAux := if(nL==1,oPanLeg,oPanLegD)

			if(nX==1,(oGrpEA  := TGroup():New(aArea5[3,1],aArea5[3,2],aArea5[3,3],aArea5[3,4],"Em andamento",oPanAux,,,.T.)),)

			&("oGetEM"+cNX)	:= TGet():New(aArea9[nX,1],aArea9[nX,2],;
			if(nL==2 .AND. nX == 1,aCapAnd[4][2],aCapAnd[nX][2]),;
			oPanAux,aArea9[nX,4]-aArea9[nX,2],aArea9[nX,3]-aArea9[nX,1],;
			"999",,,,/*oFont*/,,,.T.,,,,,,,.T.,.F.,,;
			if(nL==2 .AND. nX == 1,aCapAnd[4][3],aCapAnd[nX][3]))
		next nL
	next nX

	////
	// Calcula area de botões
	aAreaTotal6 	:= {0,0,oPanBtns:nWidth/2,oPanBtns:nHeight/2,1,1}
	nDivisoes6		:= 4
	aProp6			:= {{0,25},{0,25},{0,25},{0,25}}
	oArea6 		:= redimensiona():New(aAreaTotal6,nDivisoes6,aProp6,.F.)
	aArea6			:= oArea6:RetArea()

	// Cria os botões de acordo com os arrays
	//// Botões - Nota Fiscal
	for nX := 1 to 4
		cNX := cValtoChar(nX+6)
		&("aAreaT"+cNX)	:= {aArea6[nX,2],aArea6[nX,1],aArea6[nX,4],aArea6[nX,3],1,1}
		&("nDivis"+cNX)	:= nQtdBtns+1
		&("aProp"+cNX)	:= {{0,12},{0,15},{0,15},{0,15},{0,15},{0,15},{0,15}}
		&("oArea"+cNX)	:= redimensiona():New(&("aAreaT"+cNX),;
		&("nDivis"+cNX),;
		&("aProp"+cNX),;
		.F.)
		&("aArea"+cNX)	:= &("oArea"+cNX):RetArea()

		aAux := aAreaBtns[nX][1]

		for nL := 1 to 2


			if cEmpAnt+cFilAnt $ aAreaBtns[nX][3] // Verifica se a empresa/filial utiliza a categoria de botões
				cNL := cValtoChar(nL)
				oPanAux := if(nL==1,oPanBtns,oPanBtnsD)
				&("oSay"+cNX)		:= TSay():New(&("aArea"+cNX)[1,1],&("aArea"+cNX)[1,2],aAreaBtns[nX][2],oPanAux,"",/*oFont*/,,,,.T.,,,;
				&("aArea"+cNX)[1,4]-&("aArea"+cNX)[1,2],&("aArea"+cNX)[1,3]-&("aArea"+cNX)[1,1])

				for nY := 2 to LEN(aAux)+1
					if cEmpAnt+cFilAnt $ aAux[nY-1][3] // Verifica se a empresa/filial utiliza o botão
						cNY := cValtoChar(nY)
						&("oBtn"+cNX+cNY) := TButton():New(&("aArea"+cNX)[nY,1],&("aArea"+cNX)[nY,2],aAux[nY-1][1],oPanAux,aAux[nY-1][2],;
						&("aArea"+cNX)[nY,4]-&("aArea"+cNX)[nY,2],&("aArea"+cNX)[nY,3]-&("aArea"+cNX)[nY,1],,,,.T.)

						SetPrvt(&("oBtn"+cNX+cNY))

						//Sergio(SEMAR)  -  NAO LIBERADO AINDA..  27/10/2010
						//Desabilita os botoes para usuarios sem acesso

						if len(aAux[nY-1]) > 3
							/*if !(&(aAux[nY-1,4]))//!Eval(aAux[nY-1,4])
							&("oBtn"+cNX+cNY):Disable()
							endif*/
							u_trataLiberacao(&("oBtn"+cNX+cNY),aAux[nY-1,4],'',aPerfil)
						endif

					endif
				next nY
			endif
		next nL
	next nX

	// Desabilita alguns botões em casa do usuario não ser full
	if !luserFull
		// Sintaxe do objeto : oBtn + Numero do grupo (Ex: 1 para botoes de NF) + Numero do botão dentro do grupo acrescido de 1 (Ex: 3 para o botão Monitor)
		aBtnDis := {"oBtn72",;	// NF-e Sefaz
		"oBtn73",;	// Monitor
		"oBtn74",;	// Danfe
		"oBtn75",;	// Status Sefaz
		"oBtn76",;	// Transmissão
		"oBtn102",;	// Cliente
		"oBtn106"}		// Portaria

		for nX := 1 to LEN(aBtnDis)
			&(aBtnDis[nX]):disable()
		next nX

	endif

	//Cria timer para refresh da central
	nTimeOut := getnewPar('MV_TIME999',30000)  // 1minuto - tempo em milesegundos
	oTimer001:= ""
	oTimer001:= TTimer():New(nTimeOut,{ || U_SMFATA07(0) },oDlg)
	oTimer001:Activate()

	Set Key VK_F12 TO getSX1()

	Set Key VK_F5 TO U_SMFATA07()

	oDlg:Activate()

Return

User function AlteraBrw(p_nStep,p_oPanel,p_lUsaSaco,p_cTipo,p_nFator)

	Local oPanel		:= if(p_oPanel==nil,,p_oPanel)
	Local nStep		:= if(p_nStep==nil,2,p_nStep)
	Local lUsaSaco	:= if(p_lUsaSaco==nil,,p_lUsaSaco)
	Local cTipo		:= if(p_cTipo==nil,'',p_cTipo)
	Local nFator		:= if(p_nFator==nil,0,p_nFator)

	// Calcula area do centro
	for nL := 1 to nStep
		if lUsaSaco == nil
			bValid		:= {|| if(nL == 1,lUsaCarrSaco,lUsaDescSaco)}
		else
			bValid		:= {|| lUsaSaco}
		endif

		// define o painel correto
		if oPanel == nil
			oPanel := if(nL==1,oPanMid,oPanMidD)
		endif

		//// divide a area do centro em 2 areas horizontais
		aAreaTotal2 	:= {0,0,oPanel:nWidth,oPanel:nHeight,1,1}
		nDivisoes2		:= 2
		aProp2			:= {{0,50},{0,50}}
		oArea2 		:= redimensiona():New(aAreaTotal2,nDivisoes2,aProp2,.F.)
		aArea2			:= oArea2:RetArea()
		if Eval(bValid)
			//// divide a primeira area horizontal  do centro em 2 verticais
			aAreaTotal3 	:= {aArea2[1,2],aArea2[1,1],aArea2[1,4],aArea2[1,3],1,1}
			nDivisoes3		:= 2
			aProp3			:= {{50,0},{50,0}}
			oArea3 		:= redimensiona():New(aAreaTotal3,nDivisoes3,aProp3,.T.)
			aArea3			:= oArea3:RetArea()
			//// divide a segunda area horizontal  do centro em 2 verticais
			aAreaTotal4 	:= {aArea2[2,2],aArea2[2,1],aArea2[2,4],aArea2[2,3],1,1}
			nDivisoes4		:= 2
			aProp4			:= {{50,0},{50,0}}
			oArea4 		:= redimensiona():New(aAreaTotal4,nDivisoes4,aProp4,.T.)
			aArea4			:= oArea4:RetArea()
			// Adicionando areas em um unico array
			aAreaA			:= {aArea3[1],aArea3[2],aArea4[1],aArea4[2]}
		else
			aAreaA			:= {aArea2[1],aArea2[2]}
		endif
		// Divide os arrays resultantes para 1 - Area do titulo do browse ; 2 - Area do browse
		aAreaB				:= {}
		for nX := 1 to LEN(aAreaA)
			cNX := cValtoChar(nX)
			&("aAreaTB"+cNX)	:= {aAreaA[nX,2],aAreaA[nX,1],aAreaA[nX,4],aAreaA[nX,3],1,1}
			&("nDivisB"+cNX)	:= 2
			&("aPropB"+cNX)	:= {{0,10},{0,90}}
			&("oAreaB"+cNX)	:= redimensiona():New(&("aAreaTB"+cNX),;
			&("nDivisB"+cNX),;
			&("aPropB"+cNX),;
			.F.)
			&("aAreaB"+cNX)	:= &("oAreaB"+cNX):RetArea()
			AAdd(aAreaB,&("aAreaB"+cNX))
		next nX

		// Atualiza posicionamento dos browsers / barra de titulo
		for nX := 1 to LEN(aAreaB)
			oBrwAux := &("oBrw"+cValtoChar(if(Eval(bValid),nX+nFator,nX+nFator+if(nX==1,1,2))))
			oBrwAux:nTop 		:= aAreaB[nX,2,1]
			oBrwAux:nLeft 	:= aAreaB[nX,2,2]
			oBrwAux:nBottom	:= aAreaB[nX,2,3]
			oBrwAux:nRight	:= aAreaB[nX,2,4]
			oBrwAux:CoorsUpdate()
			oPnlAux := &("oPnl"+cValtoChar(if(Eval(bValid),nX+nFator,nX+nFator+if(nX==1,1,2))))
			oTitAux := &("aTitBrw"+cTipo)
			oPnlAux:nTop		:= aAreaB[nX,1,1]
			oPnlAux:nLeft		:= aAreaB[nX,1,2]
			oPnlAux:nBottom	:= aAreaB[nX,1,3]
			oPnlAux:nRight	:= aAreaB[nX,1,4]
			oPnlAux:cTitle	:= oTitAux[if(Eval(bValid),nX,nX+if(nX==1,1,2))]
			oPnlAux:nClrPane	:= if(nX%2==0,CLR_GREEN,CLR_BLUE)
			oPnlAux:CoorsUpdate()
		next nX

	next nL
	//

return

User function SMTEST()

	Private lAltPed := .T.

	AxAltera("SZ1",130540,4,,{"Z1_QUANT","Z1_OBSER"})

return


User function SMEXCPESO(p_cSit,p_nPeso)

	Local cTitulo	:= "Excesso de peso - "+IF(SZ8->Z8_SACGRA=="G","Granel","Ensacado")
	Local oFontTit1 := TFont():New('Verdana',,20,,.T.)
	Local oFontTex1 := TFont():New('Verdana',,20,,.F.)
	Local oFontTit2 := TFont():New('Verdana',,18,,.T.)
	Local oFontTex2 := TFont():New('Verdana',,18,,.F.)
	Local oFontTit3 := TFont():New('Verdana',,16,,.T.)
	Local oFontTex3 := TFont():New('Verdana',,30,,.F.)
	Local oFontTex4 := TFont():New('Verdana',,16,,.F.)
	Local nPeso		:= if(p_nPeso==nil,0,p_nPeso)
	Local cSit		:= if(p_cSit==nil,'Saida',p_cSit)
	Local cDifPor	:= Alltrim(SuperGetMv("MV_SMDIFFP",,'PBT'))
	Local cTitDif	:= ''		//Titutlo da diferença, se vai ser por PBT ou LOTAÇÃO
	Local nValDif	:= 0		//Valor do PBT ou da LOTAÇÃO
	Local lTemDif	:= .F.
	Local nDiff		:= 0		//Diferença Pesagem em KG
	Local nDiffPrc	:= 0		//Diferença Pesagem em %
	Local nDiffPed	:= 0		//Diferença Pedido em KG
	Local nDiffSaco	:= 0		//Diferença Pedido em Saco
	Local nMargemE	:= SuperGetMv("MV_SMMAREN",,0)	//Margem para o Ensacado
	Local nMargemG	:= SuperGetMV("MV_SMMARGR",,0)	//Margem para o Granel
	Local nMargem	:= IF(SZ8->Z8_SACGRA=="G",nMargemG,nMargemE) //getmv("MV_YMARGEM")
	Local cProds	:= ''		//Qtd+Produto para exibição
	Local lUsaSenha	:= SuperGetMV("MV_SMUSENL",,.F.)
	Local cDesSit	:= ''
	Local lRet		:= .F.
	Local wAreaSZ2	:= SZ2->(GetArea())
	Local lConsidZ2	:= SuperGetMV("MV_SMCOSZ2",,.T.) //Considera os valores da SZ2?
	Private lJust	:= .F.

	//APAGAR
	/*RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv('99','01',,,"FAT")
	DbSelectArea("SZ8")
	cDifPor	:= Alltrim(SuperGetMv("MV_SMDIFFP",,'LOTACAO'))
	nMargem := getmv("MV_YMARGEM")*/
	//****

	DbSelectArea("ZZJ")
	DbSetOrder(1)
	DbSeek(xFilial("ZZJ")+SZ8->Z8_TPVEIC)

	DbSelectArea("SZ2")
	DbSetOrder(1)
	DbSeek(xFilial("SZ2")+SZ8->Z8_PLACA)

	//A diferença vai ser calcula por PBT ou Lotação?
	do case
		// 1 - Diferença por PBT na SAIDA
		case upper(cDifPor) == "PBT" .AND. upper(substr(cSit,1,3)) == "SAI"
		cTitDif := "PBT: "
		cDesSit := "PESANDO SAIDA"
		if lConsidZ2
			if !EMPTY(SZ2->Z2_TARA) .AND. !EMPTY(SZ2->Z2_PESOTRA)
				nValDif := SZ2->(Z2_TARA + Z2_PESOTRA) //Na SZ2 o valor já está em KG
			else
				nValDif	:= ZZJ->ZZJ_PEBRTO * 1000
			endif
		else
			nValDif	:= ZZJ->ZZJ_PEBRTO * 1000
		endif
		nDiff	:= nPeso - nValDif
		nDiffPrc:= (100 * nDiff) / nValDif
		aPedido := CALCPED(cSit)
		nDiffPed:= (nPeso - SZ8->Z8_PSENT) - aPedido[LEN(aPedido)][3]
		if SZ8->Z8_SACGRA != "G"
			//lTemDif := !(nValDif >=  nPeso - (nPeso*(nMargem/100)) .AND. nValDif <= nPeso + (nPeso*(nMargem/100)))//nPeso > nValDif
			lTemDIf := !(nValDif >=  nPeso - (nPeso*(nMargem/100)))
			// Calculo do fator de conversão aproximado, segue a formula abaixo:
			// Diferença de peso / (Somatoria dos fatores de conversão / quantidade de produtos distintos)
			nDiffSaco := nDiffPed / (aPedido[LEN(aPedido)][4]/(LEN(aPedido)-1))
		else
			lTemDif := !(nValDif >=  nPeso - (nPeso*(nMargem/100)))
		endif

		// 2 - Diferença por LOTAÇÃO na SAIDA
		case upper(substr(cDifPor,1,3)) == "LOT" .AND. upper(substr(cSit,1,3)) == "SAI"
		cTitDif := "LOTAÇÃO: "
		cDesSit := "PESANDO SAIDA"
		if lConsidZ2
			if !EMPTY(SZ2->Z2_PESOTRA)
				nValDif := SZ2->Z2_PESOTRA	//Na SZ2 o valor já está em KG
			else
				nValDif := ZZJ->ZZJ_LOTACA * 1000
			endif
		else
			nValDif := ZZJ->ZZJ_LOTACA * 1000
		endif
		nPLiq	:= nPeso - SZ8->Z8_PSENT
		nDiff	:= (nPeso - SZ8->Z8_PSENT) - nValDif
		nDiffPrc:= (100 * nDiff) / nValDif
		aPedido := CALCPED(cSit)
		nDiffPed:= (nPeso - SZ8->Z8_PSENT) - aPedido[LEN(aPedido)][3]
		if SZ8->Z8_SACGRA != "G"
			lTemDif := !(nValDif >= nPLiq - (nPLiq*(nMargem/100)) .AND. nValDif <= nPLiq + (nPLiq*(nMargem/100))) //(nPeso - SZ8->Z8_PSENT) > nValDif
			// Calculo do fator de conversão aproximado, segue a formula abaixo:
			// Diferença de peso / (Somatoria dos fatores de conversão / quantidade de produtos distintos)
			nDiffSaco := nDiffPed / (aPedido[LEN(aPedido)][4]/(LEN(aPedido)-1))
		else
			lTemDif := !(nValDif >=  nPeso - (nPeso*(nMargem/100)))
		endif

		// 2 - Diferença por LOTAÇÃO no AGENCIAMENTO
		case upper(substr(cSit,1,3)) == "AGE"
		cTitDif	:= "LOTAÇÃO: "
		cDesSit := "AGENCIAMENTO"
		if lConsidZ2
			if !EMPTY(SZ2->Z2_PESOTRA)
				nValDif	:= SZ2->Z2_PESOTRA	//Na SZ2 o valor já está em KG
			else
				nValDif	:= ZZJ->ZZJ_LOTACA * 1000
			endif
		else
			nValDif	:= ZZJ->ZZJ_LOTACA * 1000
		endif
		aPedido := CALCPED(cSit)
		nDiffPed:= aPedido[LEN(aPedido)][3] - nValDif
		if SZ8->Z8_SACGRA != "G"
			// Calculo do fator de conversão aproximado, segue a formula abaixo:
			// Diferença de peso / (Somatoria dos fatores de conversão / quantidade de produtos distintos)
			nDiffSaco := nDiffPed / (aPedido[LEN(aPedido)][4]/(LEN(aPedido)-1))
		endif
		nDiff	:= nDiffPed
		nDiffPrc:= (100 * nDiff) / nValDif
		lTemDif := aPedido[LEN(aPedido)][3] > nValDif + (nValDif*(nMargem/100)) .AND. nValDif != aPedido[LEN(aPedido)][3]

		// 3 - Diferença por LOTAÇÃO na ENTRADA
		otherwise
		cTitDif := "LOTAÇÃO: "
		cDesSit := "PESANDO ENTRADA"
		if lConsidZ2
			if !EMPTY(SZ2->Z2_PESOTRA)
				nValDif	:= SZ2->Z2_PESOTRA	//Na SZ2 o valor já está em KG
			else
				//nValDif := ZZJ->ZZJ_LOTACA * 1000
				nValDif	:= (ZZJ->ZZJ_PEBRTO * 1000) - nPeso // Nova formula = Peso bruto - Tara (Lotação de acordo com a tara)
			endif
		else
			//nValDif := ZZJ->ZZJ_LOTACA * 1000
			nValDif	:= (ZZJ->ZZJ_PEBRTO * 1000) - nPeso // Nova formula = Peso bruto - Tara (Lotação de acordo com a tara)
		endif
		aPedido := CALCPED(cSit)
		nDiffPed:= aPedido[LEN(aPedido)][3] - nValDif
		if SZ8->Z8_SACGRA != "G"
			// Calculo do fator de conversão aproximado, segue a formula abaixo:
			// Diferença de peso / (Somatoria dos fatores de conversão / quantidade de produtos distintos)
			nDiffSaco := nDiffPed / (aPedido[LEN(aPedido)][4]/(LEN(aPedido)-1))
		endif
		nDiff 	:= nDiffPed
		nDiffPrc:= (100 * nDiff) / nValDif
		//lTemDif := !( aPedido[LEN(aPedido)][3] >= nValDif - (nValDif*(nMargem/100)) .AND. aPedido[LEN(aPedido)][3] <= nValDif + (nValDif*(nMargem/100)) )
		//lTemDif := aPedido[LEN(aPedido)][3] >= nValDif - (nValDif*(nMargem/100)) .AND. nValDif != aPedido[LEN(aPedido)][3]
		lTemDif := aPedido[LEN(aPedido)][3] > nValDif + (nValDif*(nMargem/100)) .AND. nValDif != aPedido[LEN(aPedido)][3]
		//A pedido de sergio, exibir a LOTAÇÃO + DIFERENÇA...
		nValDif   := (aPedido[LEN(aPedido)][3] + nPeso) - ((ZZJ->(ZZJ_PEBRTO-ZZJ_LOTACA))*1000)
	endcase

	if !lTemDif
		return .T.
	endif

	oExcDlg := TDialog():New(0,0,500,900,cTitulo,,,,,,16777205/*16639917*/,,,.T.)

	aAreaTotal1 	:= {0,0,450,250,2,2}
	nDivisoes1		:= 5
	aProp1			:= {{0,15},{0,2.5},{0,65},{0,2.5},{0,15}}
	oArea1 			:= redimensiona():New(aAreaTotal1,nDivisoes1,aProp1,.F.)
	aArea1			:= oArea1:RetArea()

	aAreaTotal2 	:= {aArea1[1,2],aArea1[1,1],aArea1[1,4],aArea1[1,3],2,2}
	nDivisoes2		:= 5
	aProp2			:= {{14,0},{14,0},{16,0},{23,0},{33,0}}
	oArea2 			:= redimensiona():New(aAreaTotal2,nDivisoes2,aProp2,.T.)
	aArea2			:= oArea2:RetArea()

	aAreaTotal3 	:= {aArea2[1,2],aArea2[1,1],aArea2[1,4],aArea2[1,3],1,1}
	nDivisoes3		:= 2
	aProp3			:= {{0,50},{0,50}}
	oArea3 			:= redimensiona():New(aAreaTotal3,nDivisoes3,aProp3,.F.)
	aArea3			:= oArea3:RetArea()

	TSay():New(aArea3[1,1],aArea3[1,2],{|| "OC: " },oExcDlg,'@!',oFontTit1,,,,.T.,CLR_BLACK,,;
	aArea3[1,4]-aArea3[1,2],aArea3[1,3]-aArea3[1,1])

	TSay():New(aArea3[2,1],aArea3[2,2],{|| SZ8->Z8_OC },oExcDlg,X3Picture('Z8_OC'),oFontTex1,,,,.T.,CLR_BLACK,,;
	aArea3[2,4]-aArea3[2,2],aArea3[2,3]-aArea3[2,1])

	aAreaTotal4 	:= {aArea2[2,2],aArea2[2,1],aArea2[2,4],aArea2[2,3],1,1}
	nDivisoes4		:= 2
	aProp4			:= {{0,50},{0,50}}
	oArea4 			:= redimensiona():New(aAreaTotal4,nDivisoes4,aProp4,.F.)
	aArea4			:= oArea4:RetArea()

	TSay():New(aArea4[1,1],aArea4[1,2],{|| "DATA: " },oExcDlg,'@!',oFontTit1,,,,.T.,CLR_BLACK,,;
	aArea4[1,4]-aArea4[1,2],aArea4[1,3]-aArea4[1,1])

	TSay():New(aArea4[2,1],aArea4[2,2],{|| SZ8->Z8_DATA },oExcDlg,X3Picture('Z8_DATA'),oFontTex1,,,,.T.,CLR_BLACK,,;
	aArea4[2,4]-aArea4[2,2],aArea4[2,3]-aArea4[2,1])

	aAreaTotal5 	:= {aArea2[3,2],aArea2[3,1],aArea2[3,4],aArea2[3,3],1,1}
	nDivisoes5		:= 2
	aProp5			:= {{0,50},{0,50}}
	oArea5 			:= redimensiona():New(aAreaTotal5,nDivisoes5,aProp5,.F.)
	aArea5			:= oArea5:RetArea()

	TSay():New(aArea5[1,1],aArea5[1,2],{|| "PLACA: " },oExcDlg,'@!',oFontTit1,,,,.T.,CLR_BLACK,,;
	aArea5[1,4]-aArea5[1,2],aArea5[1,3]-aArea5[1,1])

	TSay():New(aArea5[2,1],aArea5[2,2],{|| SZ8->Z8_PLACA },oExcDlg,X3Picture('Z8_PLACA'),oFontTex1,,,,.T.,CLR_BLACK,,;
	aArea5[2,4]-aArea5[2,2],aArea5[2,3]-aArea5[2,1])

	aAreaTotal6 	:= {aArea2[4,2],aArea2[4,1],aArea2[4,4],aArea2[4,3],1,1}
	nDivisoes6		:= 2
	aProp6			:= {{0,50},{0,50}}
	oArea6 			:= redimensiona():New(aAreaTotal6,nDivisoes6,aProp6,.F.)
	aArea6			:= oArea6:RetArea()

	TSay():New(aArea6[1,1],aArea6[1,2],{|| "SITUAÇÃO: " },oExcDlg,'',oFontTit1,,,,.T.,CLR_BLACK,,;
	aArea6[1,4]-aArea6[1,2],aArea6[1,3]-aArea6[1,1])

	TSay():New(aArea6[2,1],aArea6[2,2],{|| cDesSit },oExcDlg,'@!',oFontTex1,,,,.T.,CLR_BLACK,,;
	aArea6[2,4]-aArea6[2,2],aArea6[2,3]-aArea6[2,1])

	aAreaTotalY 	:= {aArea2[5,2],aArea2[5,1],aArea2[5,4],aArea2[5,3],0,0}
	nDivisoesY		:= 2
	aPropY			:= {{0,40},{0,60}}
	oAreaY 			:= redimensiona():New(aAreaTotalY,nDivisoesY,aPropY,.F.)
	aAreaY			:= oAreaY:RetArea()

	TSay():New(aAreaY[1,1],aAreaY[1,2],{|| "TRANSPORTADORA: " },oExcDlg,'',oFontTit1,,,,.T.,CLR_BLACK,,;
	aAreaY[1,4]-aAreaY[1,2],aAreaY[1,3]-aAreaY[1,1])

	TSay():New(aAreaY[2,1],aAreaY[2,2],{|| SZ8->Z8_NMTRANS },oExcDlg,'@!',oFontTex1,,,,.T.,CLR_BLACK,,;
	aAreaY[2,4]-aAreaY[2,2],aAreaY[2,3]-aAreaY[2,1])

	TPanel():New(aArea1[2,1],aArea1[2,2],'',oExcDlg,,,,,15576320,aArea1[2,4]-aArea1[2,2],aArea1[2,3]-aArea1[2,1])

	aAreaTotal7 	:= {aArea1[3,2],aArea1[3,1],aArea1[3,4],aArea1[3,3],1,0}
	nDivisoes7		:= 3
	aProp7			:= {{38.5,0},{1.5,0},{60,0}}
	oArea7 			:= redimensiona():New(aAreaTotal7,nDivisoes7,aProp7,.T.)
	aArea7			:= oArea7:RetArea()

	TPanel():New(aArea7[2,1],aArea7[2,2],'',oExcDlg,,,,,15576320,aArea7[2,4]-aArea7[2,2],aArea7[2,3]-aArea7[2,1])

	aAreaTotal8 	:= {aArea7[1,2],aArea7[1,1],aArea7[1,4],aArea7[1,3],1,1}
	nDivisoes8		:= 6
	aProp8			:= {{0,14},{0,27},{0,1},{0,14},{0,14},{0,30}}
	oArea8 			:= redimensiona():New(aAreaTotal8,nDivisoes8,aProp8,.F.)
	aArea8			:= oArea8:RetArea()

	TSay():New(aArea8[1,1],aArea8[1,4]/4,{|| "VEICULO " },oExcDlg,'',oFontTit1,,,,.T.,CLR_BLACK,,;
	aArea8[1,4]-aArea8[1,2],aArea8[1,3]-aArea8[1,1])

	aAreaTotal9 	:= {aArea8[2,2],aArea8[2,1],aArea8[2,4],aArea8[2,3],0,0}
	nDivisoes9		:= 2
	aProp9			:= {{30,0},{70,0}}
	oArea9 			:= redimensiona():New(aAreaTotal9,nDivisoes9,aProp9,.T.)
	aArea9			:= oArea9:RetArea()

	TSay():New(aArea9[1,1],aArea9[1,2],{|| "TIPO: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aArea9[1,4]-aArea9[1,2],aArea9[1,3]-aArea9[1,1])

	TSay():New(aArea9[2,1],aArea9[2,2],{|| ZZJ->ZZJ_CODIGO + " - " + ZZJ->ZZJ_VEICUL },oExcDlg,X3Picture('ZZJ_CODIGO'),oFontTex2,;
	,,,.T.,CLR_BLACK,,aArea9[2,4]-aArea9[2,2],aArea9[2,3]-aArea9[2,1])

	aAreaTotalB 	:= {aArea8[4,2],aArea8[4,1],aArea8[4,4],aArea8[4,3],0,0}
	nDivisoesB		:= 2
	aPropB			:= {{40,0},{60,0}}
	oAreaB 			:= redimensiona():New(aAreaTotalB,nDivisoesB,aPropB,.T.)
	aAreaB			:= oAreaB:RetArea()

	TSay():New(aAreaB[1,1],aAreaB[1,2],{|| "PBT: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaB[1,4]-aAreaB[1,2],aAreaB[1,3]-aAreaB[1,1])

	TSay():New(aAreaB[2,1],aAreaB[2,2],{|| ZZJ->ZZJ_PEBRTO * 1000},oExcDlg,"@E 999,999.99",oFontTex2,,,,.T.,CLR_BLACK,,;
	aAreaB[2,4]-aAreaB[2,2],aAreaB[2,3]-aAreaB[2,1])

	aAreaTotalC 	:= {aArea8[5,2],aArea8[5,1],aArea8[5,4],aArea8[5,3],0,0}
	nDivisoesC		:= 2
	aPropC			:= {{40,0},{60,0}}
	oAreaC 			:= redimensiona():New(aAreaTotalC,nDivisoesC,aPropC,.T.)
	aAreaC			:= oAreaC:RetArea()

	TSay():New(aAreaC[1,1],aAreaC[1,2],{|| "LOTAÇÃO: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaC[1,4]-aAreaC[1,2],aAreaC[1,3]-aAreaC[1,1])

	TSay():New(aAreaC[2,1],aAreaC[2,2],{|| ZZJ->ZZJ_LOTACA * 1000 },oExcDlg,"@E 999,999.99",oFontTex2,,,,.T.,CLR_BLACK,,;
	aAreaC[2,4]-aAreaC[2,2],aAreaC[2,3]-aAreaC[2,1])

	TBitmap():New(aArea8[6,1],aArea8[6,2],aArea8[6,4]-aArea8[6,2],aArea8[6,3]-aArea8[6,1],,'\Imagens\tipoVeiculo\'+Alltrim(ZZJ->ZZJ_BITMAP)+'.jpg',.T.,oExcDlg,{||},;
	{||},.F.,.T.,,,,{||},.T.)

	//** CARREGAMENTO **
	aAreaTotalD 	:= {aArea7[3,2],aArea7[3,1],aArea7[3,4],aArea7[3,3],1,1}
	nDivisoesD		:= 8
	aPropD			:= {{0,100},{0,100},{0,100},{0,100},{0,100},{0,100},{0,50},{0,250}}
	oAreaD 			:= redimensiona():New(aAreaTotalD,nDivisoesD,aPropD,.F.)
	aAreaD			:= oAreaD:RetArea()

	TSay():New(aAreaD[1,1],((aAreaD[1,4]-aAreaD[1,2])/3)+aAreaD[1,2],{|| IF(SZ8->Z8_SACGRA=="G","GRANEL ","ENSACADO") },;
	oExcDlg,'',oFontTit1,,,,.T.,CLR_BLACK,,aAreaD[1,4]-aAreaD[1,2],aAreaD[1,3]-aAreaD[1,1])

	aAreaTotalE 	:= {aAreaD[2,2],aAreaD[2,1],aAreaD[2,4],aAreaD[2,3],1,1}
	nDivisoesE		:= 4
	aPropE			:= {{28,0},{22,0},{28,0},{22,0}}
	oAreaE 			:= redimensiona():New(aAreaTotalE,nDivisoesE,aPropE,.T.)
	aAreaE			:= oAreaE:RetArea()

	TSay():New(aAreaE[1,1],aAreaE[1,2],{|| "TARA: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaE[1,4]-aAreaE[1,2],aAreaE[1,3]-aAreaE[1,1])

	TSay():New(aAreaE[2,1],aAreaE[2,2],{|| if(upper(substr(cSit,1,3))=="SAI",SZ8->Z8_PSENT,nPeso) },oExcDlg,'@E 999,999.99',oFontTex2,,,,.T.,CLR_BLACK,,;
	aAreaE[2,4]-aAreaE[2,2],aAreaE[2,3]-aAreaE[2,1])

	TSay():New(aAreaE[3,1],aAreaE[3,2],{|| "PEDIDO KG: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaE[3,4]-aAreaE[3,2],aAreaE[3,3]-aAreaE[3,1])

	TSay():New(aAreaE[4,1],aAreaE[4,2],{|| aPedido[len(aPedido)][3] },oExcDlg,'@E 999,999.99',oFontTex2,,,,.T.,;
	CLR_BLACK,,aAreaE[4,4]-aAreaE[4,2],aAreaE[4,3]-aAreaE[4,1])

	aAreaTotalF 	:= {aAreaD[3,2],aAreaD[3,1],aAreaD[3,4],aAreaD[3,3],1,1}
	nDivisoesF		:= 4
	aPropF			:= {{28,0},{22,0},{28,0},{22,0}}
	oAreaF 			:= redimensiona():New(aAreaTotalF,nDivisoesF,aPropF,.T.)
	aAreaF			:= oAreaF:RetArea()

	if upper(cSit) == "SAIDA"

		TSay():New(aAreaF[1,1],aAreaF[1,2],{|| "P.SAIDA: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaF[1,4]-aAreaF[1,2],aAreaF[1,3]-aAreaF[1,1])

		TSay():New(aAreaF[2,1],aAreaF[2,2],{|| nPeso },oExcDlg,'@E 999,999.99',oFontTex2,,,,.T.,CLR_BLACK,,;
		aAreaF[2,4]-aAreaF[2,2],aAreaF[2,3]-aAreaF[2,1])

	else

		TSay():New(aAreaF[1,1],aAreaF[1,2],{|| cTitDif },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaF[1,4]-aAreaF[1,2],aAreaF[1,3]-aAreaF[1,1])

		TSay():New(aAreaF[2,1],aAreaF[2,2],{|| nValDif },oExcDlg,'@E 999,999.99',oFontTex2,,,,.T.,CLR_BLACK,,;
		aAreaF[2,4]-aAreaF[2,2],aAreaF[2,3]-aAreaF[2,1])

	endif

	if SZ8->Z8_SACGRA != "G"

		TSay():New(aAreaF[3,1],aAreaF[3,2],{|| "PEDIDO SC: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaF[3,4]-aAreaF[3,2],aAreaF[3,3]-aAreaF[3,1])

		TSay():New(aAreaF[4,1],aAreaF[4,2],{|| aPedido[LEN(aPedido)][2] },oExcDlg,'@E 999,999.99',oFontTex2,,,,.T.,CLR_BLACK,,aAreaF[4,4]-aAreaF[4,2],aAreaF[4,3]-aAreaF[4,1])

	endif

	aAreaTotalG 	:= {aAreaD[4,2],aAreaD[4,1],aAreaD[4,4],aAreaD[4,3],1,1}
	nDivisoesG		:= 4
	aPropG			:= {{28,0},{22,0},{28,0},{22,0}}
	oAreaG 			:= redimensiona():New(aAreaTotalG,nDivisoesG,aPropG,.T.)
	aAreaG			:= oAreaG:RetArea()

	if upper(cSit) == "SAIDA"

		TSay():New(aAreaG[1,1],aAreaG[1,2],{|| "P.LIQUIDO: " },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaG[1,4]-aAreaG[1,2],aAreaG[1,3]-aAreaG[1,1])

		TSay():New(aAreaG[2,1],aAreaG[2,2],{|| nPeso - SZ8->Z8_PSENT },oExcDlg,'@E 999,999.99',oFontTex2,,,,.T.,CLR_BLACK,,;
		aAreaG[2,4]-aAreaG[2,2],aAreaG[2,3]-aAreaG[2,1])

		aAreaTotalH 	:= {aAreaD[5,2],aAreaD[5,1],aAreaD[5,4],aAreaD[5,3],1,1}
		nDivisoesH		:= 4
		aPropH			:= {{28,0},{22,0},{28,0},{22,0}}
		oAreaH 			:= redimensiona():New(aAreaTotalH,nDivisoesH,aPropH,.T.)
		aAreaH			:= oAreaH:RetArea()

		TSay():New(aAreaH[1,1],aAreaH[1,2],{|| cTitDif },oExcDlg,'',oFontTit2,,,,.T.,CLR_BLACK,,aAreaH[1,4]-aAreaH[1,2],aAreaH[1,3]-aAreaH[1,1])

		TSay():New(aAreaH[2,1],aAreaH[2,2],{|| nValDif },oExcDlg,'@E 999,999.99',oFontTex2,,,,.T.,CLR_BLACK,,;
		aAreaH[2,4]-aAreaH[2,2],aAreaH[2,3]-aAreaH[2,1])

	endif

	if SZ8->Z8_SACGRA != "G"

		aAreaTotalI 	:= {aAreaD[4,2],aAreaD[4,1],aAreaD[5,4],aAreaD[5,3],1,1}
		nDivisoesI		:= 3
		aPropI			:= {{28,0},{22,0},{50,0}}
		oAreaI 			:= redimensiona():New(aAreaTotalI,nDivisoesI,aPropI,.T.)
		aAreaI			:= oAreaI:RetArea()

		for nP := 1 to LEN(aPedido)-1
			cProds += cValtoChar(aPedido[nP][2]) + ' - ' + Alltrim(aPedido[nP][1]) + if(nP!=LEN(aPedido)-1,' | ','')
		next nP

		TSay():New(aAreaI[3,1],aAreaI[3,2],{|| cProds },oExcDlg,'',oFontTex4,,,,.T.,CLR_BLACK,,aAreaI[3,4]-aAreaI[3,2],aAreaI[3,3]-aAreaI[3,1])

	endif

	TSay():New(aAreaD[6,1],((aAreaD[6,4]-aAreaD[6,2])/3)+aAreaD[6,2],{|| "DIFERENÇA" },;
	oExcDlg,'',oFontTit1,,,,.T.,CLR_BLACK,,aAreaD[6,4]-aAreaD[6,2],aAreaD[6,3]-aAreaD[6,1])

	aAreaTotalJ 	:= {aAreaD[7,2],aAreaD[7,1],aAreaD[7,4],aAreaD[7,3],1,1}
	nDivisoesJ		:= 2
	aPropJ			:= {{50,0},{50,0}}
	oAreaJ 			:= redimensiona():New(aAreaTotalJ,nDivisoesJ,aPropJ,.T.)
	aAreaJ			:= oAreaJ:RetArea()

	TSay():New(aAreaJ[1,1],((aAreaJ[1,4]-aAreaJ[1,2])/3)+aAreaJ[1,2],{|| "PESAGEM" },;
	oExcDlg,'',oFontTit3,,,,.T.,CLR_BLACK,,aAreaJ[1,4]-aAreaJ[1,2],aAreaJ[1,3]-aAreaJ[1,1])

	TSay():New(aAreaJ[2,1],((aAreaJ[2,4]-aAreaJ[2,2])/3)+aAreaJ[2,2],{|| "PEDIDO" },;
	oExcDlg,'',oFontTit3,,,,.T.,CLR_BLACK,,aAreaJ[2,4]-aAreaJ[2,2],aAreaJ[2,3]-aAreaJ[2,1])

	aAreaTotalK 	:= {aAreaD[8,2],aAreaD[8,1],aAreaD[8,4],aAreaD[8,3],3,1}
	nDivisoesK		:= 2
	aPropK			:= {{50,0},{50,0}}
	oAreaK 			:= redimensiona():New(aAreaTotalK,nDivisoesK,aPropK,.T.)
	aAreaK			:= oAreaK:RetArea()

	aAreaTotalP 	:= {aAreaK[1,2],aAreaK[1,1],aAreaK[1,4],aAreaK[1,3],0,0}
	nDivisoesP		:= 2
	aPropP			:= {{0,50},{0,50}}
	oAreaP 			:= redimensiona():New(aAreaTotalP,nDivisoesP,aPropP,.F.)
	aAreaP			:= oAreaP:RetArea()

	aAreaTotalL 	:= {aAreaP[1,2],aAreaP[1,1],aAreaP[1,4],aAreaP[1,3],0,0}
	nDivisoesL		:= 2
	aPropL			:= {{27,0},{73,0}}
	oAreal 			:= redimensiona():New(aAreaTotalL,nDivisoesL,aPropL,.T.)
	aAreaL			:= oAreaL:RetArea()

	TSay():New(aAreaL[1,1],aAreaL[1,2],{|| "EM KG:" },oExcDlg,'',oFontTit3,,,,.T.,CLR_BLACK,,aAreaL[1,4]-aAreaL[1,2],aAreaL[1,3]-aAreaL[1,1])

	TSay():New(aAreaL[2,1],aAreaL[2,2],{|| nDiff },oExcDlg,'@E 999,999.99',oFontTex3,,,,.T.,255,,aAreaL[2,4]-aAreaL[2,2],aAreaL[2,3]-aAreaL[2,1])

	aAreaTotalQ 	:= {aAreaP[2,2],aAreaP[2,1],aAreaP[2,4],aAreaP[2,3],0,0}
	nDivisoesQ		:= 2
	aPropQ			:= {{27,0},{73,0}}
	oAreaQ 			:= redimensiona():New(aAreaTotalQ,nDivisoesQ,aPropQ,.T.)
	aAreaQ			:= oAreaQ:RetArea()

	TSay():New(aAreaQ[1,1],aAreaQ[1,2],{|| "EM %:" },oExcDlg,'',oFontTit3,,,,.T.,CLR_BLACK,,aAreaQ[1,4]-aAreaQ[1,2],aAreaQ[1,3]-aAreaQ[1,1])

	TSay():New(aAreaQ[2,1],aAreaQ[2,2],{|| nDiffPrc },oExcDlg,'@E 999.99%',oFontTex3,,,,.T.,255,,aAreaQ[2,4]-aAreaQ[2,2],aAreaQ[2,3]-aAreaQ[2,1])

	if SZ8->Z8_SACGRA != "G"
		aAreaTotalM 	:= {aAreaK[2,2],aAreaK[2,1],aAreaK[2,4],aAreaK[2,3],0,0}
		nDivisoesM		:= 2
		aPropM			:= {{0,50},{0,50}}
		oAreaM 			:= redimensiona():New(aAreaTotalM,nDivisoesM,aPropM,.F.)
		aAreaM			:= oAreaM:RetArea()

		aAreaTotalN 	:= {aAreaM[1,2],aAreaM[1,1],aAreaM[1,4],aAreaM[1,3],0,0}
		nDivisoesN		:= 2
		aPropN			:= {{30,0},{70,0}}
		oAreaN 			:= redimensiona():New(aAreaTotalN,nDivisoesN,aPropN,.T.)
		aAreaN			:= oAreaN:RetArea()

		TSay():New(aAreaN[1,1],aAreaN[1,2],{|| "EM KG:" },oExcDlg,'',oFontTit3,,,,.T.,CLR_BLACK,,aAreaN[1,4]-aAreaN[1,2],aAreaN[1,3]-aAreaN[1,1])

		TSay():New(aAreaN[2,1],aAreaN[2,2],{|| nDiffPed },oExcDlg,'@E 999,999.99',oFontTex3,,,,.T.,255,,aAreaN[2,4]-aAreaN[2,2],aAreaN[2,3]-aAreaN[2,1])

		aAreaTotalO 	:= {aAreaM[2,2],aAreaM[2,1],aAreaM[2,4],aAreaM[2,3],0,0}
		nDivisoesO		:= 2
		aPropO			:= {{30,0},{70,0}}
		oAreaO 			:= redimensiona():New(aAreaTotalO,nDivisoesO,aPropO,.T.)
		aAreaO			:= oAreaO:RetArea()

		TSay():New(aAreaO[1,1],aAreaO[1,2],{|| "EM SC:" },oExcDlg,'',oFontTit3,,,,.T.,CLR_BLACK,,aAreaO[1,4]-aAreaO[1,2],aAreaO[1,3]-aAreaO[1,1])

		TSay():New(aAreaO[2,1],aAreaO[2,2],{|| nDiffSaco },oExcDlg,'@E 999,999.99',oFontTex3,,,,.T.,255,,aAreaO[2,4]-aAreaO[2,2],aAreaO[2,3]-aAreaO[2,1])

	else
		aAreaTotalM 	:= {aAreaK[2,2],aAreaK[2,1],aAreaK[2,4],aAreaK[2,3],0,0}
		nDivisoesM		:= 2
		aPropM			:= {{30,0},{70,0}}
		oAreaM 			:= redimensiona():New(aAreaTotalM,nDivisoesM,aPropM,.T.)
		aAreaM			:= oAreaM:RetArea()

		TSay():New(aAreaM[1,1],aAreaM[1,2],{|| "EM KG:" },oExcDlg,'',oFontTit3,,,,.T.,CLR_BLACK,,aAreaM[1,4]-aAreaM[1,2],aAreaM[1,3]-aAreaM[1,1])

		TSay():New(aAreaM[2,1],aAreaM[2,2],{|| nDiffPed },oExcDlg,'@E 999,999.99',oFontTex3,,,,.T.,255,,aAreaM[2,4]-aAreaM[2,2],aAreaM[2,3]-aAreaM[2,1])
	endif


	TPanel():New(aArea1[4,1],aArea1[4,2],'',oExcDlg,,,,,15576320,aArea1[4,4]-aArea1[4,2],aArea1[4,3]-aArea1[4,1])

	aAreaTotalN 	:= {aArea1[5,2],aArea1[5,1],aArea1[5,4],aArea1[5,3],2,10}
	nDivisoesN		:= 5
	aPropN			:= {{20,0},{20,0},{20,0},{20,0},{20,0}}
	oAreaN 			:= redimensiona():New(aAreaTotalN,nDivisoesN,aPropN,.T.)
	aAreaN			:= oAreaN:RetArea()

	if lUsaSenha
		TButton():New(aAreaN[4,1],aAreaN[4,2],"Liberar",oExcDlg,{|| /*if(LIBEXC(),oExcDlg:End(),)*/},;
		aAreaN[4,4]-aAreaN[4,2],aAreaN[4,3]-aAreaN[4,1],,,,.T.,,"",,,,.F.)
	endif
	//TButton():New(aAreaN[4,1],aAreaN[4,2],"OK",oExcDlg,{|| oExcDlg:End()},aAreaN[4,4]-aAreaN[4,2],aAreaN[4,3]-aAreaN[4,1],,,,.T.,,"",,,,.F.)
	TButton():New(aAreaN[5,1],aAreaN[5,2],"Sair",oExcDlg,{|| oExcDlg:End()},aAreaN[5,4]-aAreaN[5,2],aAreaN[5,3]-aAreaN[5,1],,,,.T.,,"",,,,.F.)

	oExcDlg:Activate(,,,.T.)

return lRet

Static function LIBEXC()

	Local cMot
	Local cJust
	Local cApro
	Local awLogs	:= {}
	Local lRet		:= .F.

	if !lJust // Se ainda não foi preenchido o motivo/justificativa (abre a janela)
		If U_SMJUS(@cMot, @cJust, @cApro)
			aAdd(awLogs, {/*Entidade1*/'SZ8',;
			/*Tipo Docto*/'OC',;
			/*Recno Doc1*/sz8->(recno()),;
			/*Tipo Log*/'EXC',;
			/*Tipo Log*/'Excesso de Peso',;
			/*Entidade2*/'SZ1',;
			/*Recno Doc2*/sz1->(recno()),;
			/*Recno Bpk1*/0,;
			/*Motivo*/cMot,;
			/*Justificat.*/cJust,;
			/*Usuario*/cUserName,;
			/*Rotina Orig*/'SMFATT99',;
			/*Liberador1*/cApro} )

			u_SMGRVLG(awLogs)
		else
			Alert("Não foi possivel gravar a justificativa para Excesso de Peso.  A liberação desta OC, será abortada!")
			return lRet
		endif
	endif


	if !u_smvld2Psw("EXCESSO", "Email", SZ8->Z8_OC, "00:00", "00:00")
		Alert("A senha de liberação informada está inválida! Tente novamente")
	else
		lRet := .T.
	endif

return lRet



Static function CALCPED(p_cSit)

	Local wAreaSZ1	:= SZ1->(GetArea())
	Local wAreaSB1	:= SB1->(GetArea())
	Local wAreaATU	:= GetArea()
	Local aPedido	:= {} //{Produto,Quantidade,Peso}
	Local nPeso		:= 0
	Local nPesoTot	:= 0
	Local nQtdTot	:= 0
	Local nConvTot	:= 0
	Local cSit		:= if(p_cSit==nil,'SAIDA',p_cSit)


	if upper(substr(cSit,1,3)) == "AGE"
		//Calcula pedidos no AGENCIAMENTO
		aAuxPrds := StrToKArr(M->Z8_ITENSOC,"#")
		for nP := 1 to LEN(aAuxPrds)
			aAuxPrd := StrToKArr(aAuxPrds[nP],"/\")
			If LEN(aAuxPrd) != 3
				LOOP
			Endif

			aAuxPrd[3] := Val(STRTRAN(aAuxPrd[3],',','.'))

			DbSelectArea("SB1")
			DbSetOrder(1)
			if SB1->(DbSeek(xFilial("SB1")+aAuxPrd[1]))
				if SZ1->Z1_PALLET != "G"
					if SB1->B1_TIPCONV == "M"
//						nPeso := SZ1->Z1_QUANT * SB1->B1_CONV
						nPeso := aAuxPrd[3] * SB1->B1_CONV
					else
//						nPeso := SZ1->Z1_QUANT / SB1->B1_CONV
						nPeso := aAuxPrd[3] / SB1->B1_CONV
					endif
					nConvTot += SB1->B1_CONV
				else
//					nPeso := SZ1->Z1_QUANT * 1000
					nPeso := aAuxPrd[3] * 1000
				endif
			endif
			nAux := aScan(aPedido,{|x| x[1] == aAuxPrd[1]})
			if nAux == 0
				AADD(aPedido,{aAuxPrd[1],aAuxPrd[3],nPeso})
			else
				aPedido[nAux][2] += aAuxPrd[3]
				aPedido[nAux][3] += nPeso
			endif
			nQtdTot  += aAuxPrd[3]
			nPesoTot += nPeso
		next nP
		AADD(aPedido,{"TOTAL",nQtdTot,nPesoTot,nConvTot})

	else
		//Calcula pedidos na ENTRADA ou SAIDA
		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(8))
		If SZ1->(DbSeek(xFilial("SZ1")+SZ8->Z8_OC))
			While SZ1->Z1_OC == SZ8->Z8_OC
				DbSelectArea("SB1")
				DbSetOrder(1)
				SB1->(DbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

				if SZ1->Z1_PALLET != "G"
					if SB1->B1_TIPCONV == "M"
						nPeso := SZ1->Z1_QUANT * SB1->B1_CONV
					else
						nPeso := SZ1->Z1_QUANT / SB1->B1_CONV
					endif
					nConvTot += SB1->B1_CONV
				else
					nPeso := SZ1->Z1_QUANT * 1000
				endif


				nAux := aScan(aPedido,{|x| x[1] == SZ1->Z1_PRODUTO})
				if nAux == 0
					AADD(aPedido,{SZ1->Z1_PRODUTO,SZ1->Z1_QUANT,nPeso})
				else
					aPedido[nAux][2] += SZ1->Z1_QUANT
					aPedido[nAux][3] += nPeso
				endif
				nQtdTot  += SZ1->Z1_QUANT
				nPesoTot += nPeso
				SZ1->(DbSkip())
			end
			AADD(aPedido,{"TOTAL",nQtdTot,nPesoTot,nConvTot})
		endif
	endif

	//Retorna Areas
	RestArea(wAreaSB1)
	RestArea(wAreaSZ1)
	RestArea(wAreaATU)

return aPedido

User function LIBPESCAM()

	Local cMot
	Local cJust
	Local cApro
	Local awLogs	:= {}
	Local lRet		:= .F.
	Local lTry		:= .F.
	Local lConsidZ2	:= SuperGetMV("MV_SMCOSZ2",,.F.)

	if !lConsidZ2 // Se não considerar os SZ2 no DIF PESO, permite a edição do campo sem justificativa/senha.
		return .T.
	endif

	While !lTry
		if !u_smvld2Psw("CAMPO", "Email", '', "00:00", "00:00",ReadVar())
			lTry := !(MSGYESNO('A senha de liberação informada está inválida! Deseja tentar novamente?','Atenção'))
		else
			lRet := .T.
			EXIT
		endif
	end

	if !lRet
		return .F.
	endif

	If U_SMJUS(@cMot, @cJust, @cApro)
		aAdd(awLogs, {/*Entidade1*/'SZ2',;
		/*Tipo Docto*/'CAD CAMINHAO',;
		/*Recno Doc1*/SZ2->(recno()),;
		/*Tipo Log*/'CPO',;
		/*Tipo Log*/'Alteração de campo',;
		/*Entidade2*/'',;
		/*Recno Doc2*/0,;
		/*Recno Bpk1*/0,;
		/*Motivo*/cMot,;
		/*Justificat.*/cJust,;
		/*Usuario*/cUserName,;
		/*Rotina Orig*/'MIZ005',;
		/*Liberador1*/cApro} )

		u_SMGRVLG(awLogs)
	else
		Alert("Não foi possivel alterar o campo ["+READVAR()+"].")
		return .F.
	endif

return .T.

User function LIBCPO(p_cTipo)

	Local cTipo		:= if(p_cTipo==nil,'',p_cTipo)
	Local lExp		:= .T.
	Local cCpo		:= ReadVar()
	Local cPreCpo	:= if( at('>',cCpo)>0 , substr(cCpo,at('>',cCpo)+1,at("_",cCpo)-at('>',cCpo)-1) , SubStr(cCpo,1,at("_",cCpo)-1) )
	Local cTable	:= if(LEN(cPreCpo)==2,'S'+cPreCpo,cPreCpo)
	Local lRet		:= .F.
	Local lTry		:= .F.
	Local cMot
	Local cJust
	Local cApro

	//Verifica se o tipo de operação foi especificado
	do case
		case Alltrim(upper(cTipo)) == "INCLUSAO" .AND. ValType('INCLUI') != "U"
		IF !INCLUI; return .T.; endif

		case Alltrim(upper(cTipo)) == "ALTERACAO" .AND. ValType('ALTERA') != "U"
		IF !ALTERA; return .T.; endif
	endcase

	While !lTry
		if !u_smvld2Psw("CAMPO", "Email", '', "00:00", "00:00",cCpo)
			lTry := !(MSGYESNO('A senha de liberação informada está inválida! Deseja tentar novamente?','Atenção'))
		else
			lRet := .T.
			EXIT
		endif
	end

	if !lRet
		return .F.
	endif

	If U_SMJUS(@cMot, @cJust, @cApro)
		aAdd(awLogs, {/*Entidade1*/cTable,;
		/*Tipo Docto*/Alltrim(Posicione("SX2",1,cTable,"X2_NOME")),;
		/*Recno Doc1*/(cTable)->(recno()),;
		/*Tipo Log*/'CPO',;
		/*Tipo Log*/'Alteração de campo',;
		/*Entidade2*/'',;
		/*Recno Doc2*/0,;
		/*Recno Bpk1*/0,;
		/*Motivo*/cMot,;
		/*Justificat.*/cJust,;
		/*Usuario*/cUserName,;
		/*Rotina Orig*/FunName(),;
		/*Liberador1*/cApro} )

		u_SMGRVLG(awLogs)
	else
		Alert("Não foi possivel alterar o campo ["+cCpo+"].")
		return .F.
	endif

return .T.

User function atuQtdOCxPed(p_cOC)

	Local wArea		:= GetArea()
	Local wAreaZ1	:= SZ1->(GetArea())
	Local wAreaZ8	:= SZ8->(GetArea())
	Local wAreaB1	:= SB1->(GetArea())
	Local cOC		:= if(p_cOC==nil,'',p_cOC)
	Local aItensZ1	:= {}						// 1 = Z1_PRODUTO | 2 = B1_DESC (25) | 3 = Z1_QUANT
	Local aItensZ8	:= {}
	Local nQtdTot	:= 0
	Local cItensOC	:= ''
	Local lTemDif	:= .F.
	Private awLogs	:= {}

	DbSelectArea("SZ1")
	DbSetOrder(8) //Z1_FILIAL + Z1_OC
	If SZ1->(DbSeek(xFilial("SZ1")+cOC))
		While SZ1->Z1_OC == cOC
			nPosAux := aScan(aItensZ1,{|x| x[1] == SZ1->Z1_PRODUTO})
			if nPosAux > 0
				aItensZ1[nPosAux,3] += SZ1->Z1_QUANT
			else
				AADD(aItensZ1,{SZ1->Z1_PRODUTO,;
				LEFT(Posicione('SB1',1,xFilial('SB1')+SZ1->Z1_PRODUTO,'B1_YDESCRE'),25),;
				SZ1->Z1_QUANT})
			endif
			nQtdTot += SZ1->Z1_QUANT
			SZ1->(DbSkip())
		end
		//
		DbSelectArea("SZ8")
		DbSetOrder(1)
		If SZ8->(DbSeek(xFilial("SZ8")+cOC))
			aItensZ8 := StrToKArr(SZ8->Z8_ITENSOC,"#")
			aSize(aItensZ8,LEN(aItensZ8)-1) //Remove o ultimo elemento (vazio).
			for nV := 1 to LEN(aItensZ8) 	//Verifica se tem diferença SZ1(PV) x SZ8(OC)
				aItensZ8[nV]:= StrToKArr(aItensZ8[nV],"/")
				nPosZ1		:= aScan(aItensZ1,{|x| x[1] == aItensZ8[nV][1]})
				lTemDif 	:= if(nPosZ1==0,.T.,if(aItensZ1[nPosZ1,3] == val(aItensZ8[nV,3]),.F.,.T.))
				if lTemDif; exit; endif
			next nV
		endif
	endif

	For nI := 1 to LEN(aItensZ1)
		For nX := 1 to LEN(aItensZ1[nI])
			cItensOC += if(ValType(aItensZ1[nI][nX])=="C",aItensZ1[nI][nX],cValToChar(aItensZ1[nI][nX])) + if(nX<LEN(aItensZ1[nI]),"/","#")
		next nX
	next nI

	DbSelectArea("SZ8")
	DbSetOrder(1)
	If SZ8->(DbSeek(xFilial("SZ8")+cOC)) .AND. !EMPTY(nQtdTot) .AND. !EMPTY(cItensOC)
		//Verifica se houve divergencias nos campos Z8_QUANT e Z8_ITENSOC após a atualização do pedido
		//devido a quantidade superior.
		if lTemDif
			//Realiza BKP da SZ8 antes da alteração
			nRecnoBkp := 0
			nRecnoBkp := u_smBkpTbLog('SZ8')

			//Grava LOG da Operação
			aAdd(awLogs, {/*Entidade1*/'SZ8',;
			/*Tipo Docto*/'OC',;
			/*Recno Doc1*/SZ8->(recno()),;
			/*Tipo Log*/'ALT',;
			/*Des Log*/'OC-Atu.QTDD P/ CENTRAL',;
			/*Entidade2*/'',;
			/*Recno Doc2*/0,;
			/*Recno Bpk1*/nrecnoBkp,;
			/*Motivo*/'70',;
			/*Justificat.*/'DIVERGENCIA PV X OS APOS ATU',;
			/*Usuario*/cUserName,;
			/*Rotina Orig*/'SMFATT99',;
			/*Liberador1*/cUserName} )

			u_SMGRVLG(awLogs)

			//Efetua atualização
			RecLock("SZ8",.F.)
			SZ8->Z8_QUANT	:= nQtdTot
			SZ8->Z8_ITENSOC	:= cItensOC
			SZ8->(MsUnlock())
		endif
	endif

	restArea(wAreaZ1)
	restArea(wAreaZ8)
	restArea(wAreaB1)
	restArea(wArea)

return