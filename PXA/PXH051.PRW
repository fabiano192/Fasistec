#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE 	_wEnter_	chr(13)+chr(10)

#XCommand ROLLBACK TRANSACTION => DisarmTransaction()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH051                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Monitor do trafego de carga e descarga                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PXH051()

/*

PXH044    - MIZ997
PXH045    - SMFATT13  / MIZ996
PXH04501  - ALTERA_PESO
PXH04502  - getPSer

PXH051    - SMFATT99
PXH052    - SMGETACCESS
PXH05101  - SMFATF61
PXH05102  - SMFATF49
PXH05103  - SMFATA07
PXH05104  - SMFATC01
PXH05105  - SMFATF60
PXH05106  - SMFATF50
PXH05107  - SMFATF53
PXH05108  - SMFATF51
PXH05109  - SMFATV01
PXH05110  - SMFATF59
PXH05111  - SMFATI01
PXH05112  - SMFATF56
PXH05113  - SMFATF57
PXH05114  - SMFATF58
PXH05115  - SMFATF52
PXH05116  - SMFATF54
PXH053    - SMFATT27
PXH05301  - SMFATF71

PXH054    - SMFATF64
PXH05401  - smFrmPeso
PXH05402  - smGetPeso
PXH05403  - getPesIP
PXH055    - MIZ035
PXH05501  - frmDadosNF

PXH060    - RTICKET
        
PXH06101  - smvldPsw


SZ1-SZF   - PEDIDO DE VENDA AUXILIAR
SZ8-SZE   - AGENCIAMENTO

LINHA--> 891
			1256	
  				PXH055
  					Linha 1835
  					
  					Continuar no Ponto de Entrada do Pedido de Venda para Gravar na Tabela SZF

	
--------

PXH046  - MIZ050GR
PXH047  - MIZ992
PXH048  - frmfiltpv - OK
PXH049  - MIZ050GR

MATA410 - Miz016          -- PEDIDO DE VENDA
OMSA040 - Miz010          -- CADASTRO DE MOTORISTA
OMSA060 - Miz005/Miz1030  -- CADASTRO DE VEICULOS (CAMINHA / CARRETA)

SZ2-DA3 - VEICULOS     PLACA ---> INDICE 03
SZ3-DA4 - MOTORISTA    CODIGO --> INDICE 01
SZG-SZG - TABELA DE PRECO FRETE

Z3_SENHMOT : DA4_SYENMO


ZE_PLACA-C07 --> ALTERADO PARA C-08
ZE_PLCAR-C07 --> ALTERADO PARA C-08

ZZL-ZZL
*/

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nMVC       := SuperGetMv("PXH_VECA",,100) //SuperGetMv("MV_MAXVECA",,100)
Private nMVD       := SuperGetMv("PXH_VEDE",,100) //SuperGetMv("MV_MAXVEDE",,100)
Private nMVP       := SuperGetMv("PXH_VEPA",,100) //SuperGetMv("MV_MAXVEPA",,100)

Private nVC        := 0
Private nVD        := 0
Private nVP        := 0
Private wNumOC     := ""
PRIVATE bFiltraBrw := {|| .t. }
PRIVATE aFilBrw    := {}

private lUsaPager  := ( cEmpAnt $ getNewPar('MV_USAPAGE', '20' ) )

PRIVATE  nPosPager := 03 //iif(cempant $ '01', 11, 03)

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
private cperg     := "PX051TEL1" //'MZ999TEL1'
private lUsaDescSaco:=.t.
private lUsaCarrSaco:=.t.

private lUsaNewOC := ( cFilAnt $  getnewPar('MV_USNEWOC','01') ) //if lUsaNewOC

Private luserFull := .f.

Private oMenu01
Private oMenuItem01,oMenuItem02,oMenuItem03,oMenuItem04
Private oBrwMenu

If !U_PXH052(funname(),.f.); Return; Endif

lUserFull := .t.

//define modelo da tela c/ F12
PXH05101(cperg)

oAmarelo    := LoadBitmap(GetResources(),'BR_AMARELO')
oVerde 		:= LoadBitmap(GetResources(),'BR_VERDE')
oPink 		:= LoadBitmap(GetResources(),'BR_PINK')
oVermelho 	:= LoadBitmap(GetResources(),'BR_VERMELHO')
oAzul 		:= LoadBitmap(GetResources(),'BR_AZUL')
oCinza 		:= LoadBitmap(GetResources(),'BR_PRETO')
oBranco		:= LoadBitmap(GetResources(),'BR_BRANCO')
oMarrom	   := LoadBitmap(GetResources(),'BR_MARROM')
oLaranja		:= LoadBitmap(GetResources(),'BR_LARANJA')

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oFont1     := TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Verdana",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 080,092,680,1280,"Controle do Tráfego de Carga e Descarga",,,.F.,,,,,,.T.,,,.T. )

nTimeOut := getnewPar('MV_TIME999',30000)  // 1minuto - tempo em milesegundos
oTimer001:= ""
oTimer001:= TTimer():New(nTimeOut,{ || U_PXH05103(0) },oDlg1)
oTimer001:Activate()

oFolder1   := TFolder():New( 0,0,{"Carregamento","Descarregamento"},,oDlg1,,,,.T.,.F.,540,300,)

//************************************* OBJETOS PAGE1 *************************************//
if lusaCarrSaco
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
	
Else
	//granel
	oBmp8      := TBitmap():New( 000,005,530,013,,"\images\azul.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oSay14     := TSay():New( 001,250,{||"Pátio       "},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,059,010)
	oBmp10     := TBitmap():New( 121,005,530,013,,"\images\verde.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oSay16     := TSay():New( 123,250,{||"Fábrica       "},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,069,009)
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
oVP        := TGet():New( 252,359,{|u| If(PCount()>0,nVP:=u,nVP)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVP",,)
oVC        := TGet():New( 262,359,{|u| If(PCount()>0,nVC:=u,nVC)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVC",,)
oVD        := TGet():New( 273,359,{|u| If(PCount()>0,nVD:=u,nVD)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVD",,)
oMVD       := TGet():New( 273,499,{|u| If(PCount()>0,nMVD:=u,nMVD)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVD",,)
oMVC       := TGet():New( 262,499,{|u| If(PCount()>0,nMVC:=u,nMVC)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVC",,)
oMVP       := TGet():New( 252,499,{|u| If(PCount()>0,nMVP:=u,nMVP)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVP",,)

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
	oSay14d     := TSay():New( 001,250,{||ctitGrdDS },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,059,010)
	oBmp10d     := TBitmap():New( 121,005,510,013,,"\images\verde.png",.T.,oFolder1:aDialogs[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oSay16d     := TSay():New( 123,250,{||ctitGrdDI },oFolder1:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,069,009)
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
oVPd        := TGet():New( 252,339,{|u| If(PCount()>0,nVP:=u,nVP)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVP",,)
oVCd        := TGet():New( 262,339,{|u| If(PCount()>0,nVC:=u,nVC)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVC",,)
oVDd        := TGet():New( 273,339,{|u| If(PCount()>0,nVD:=u,nVD)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nVD",,)
oMVDd       := TGet():New( 273,479,{|u| If(PCount()>0,nMVD:=u,nMVD)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVD",,)
oMVCd       := TGet():New( 262,479,{|u| If(PCount()>0,nMVC:=u,nMVC)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVC",,)
oMVPd       := TGet():New( 252,479,{|u| If(PCount()>0,nMVP:=u,nMVP)},oGrp2d,020,008,'',,CLR_BLACK,CLR_WHITE,oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nMVP",,)

// Define o tamanho e as colunas dos browses.
PXH05102()

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

U_PXH05103(0)

if luserFull
	if lusaCarrSaco
		oBrw1:blDBLClick := {|| PXH05106(@oBrw1) }
		oBrw1:BSEEKCHANGE:= {|| PXH05110(@oBrw1 ) }
		oBrw1:bRClicked:= {|oObj,X,Y| PXH05111("Prov",oBrw1),oMenu01:Activate( X, Y, oObj )}
		
		oBrw3:blDBLClick := {|| PXH05106(@oBrw3) }
		oBrw3:BSEEKCHANGE:= {|| PXH05110(@oBrw3 ) }
		oBrw3:bRClicked:= {|oObj,X,Y| PXH05111("Prov",oBrw3),oMenu01:Activate( X, Y, oObj )}
	endif
	
	oBrw2:blDBLClick := {|| PXH05106(@oBrw2) }
	oBrw2:BSEEKCHANGE:= {|| PXH05110(@oBrw2 ) }
	oBrw2:bRClicked:= {|oObj,X,Y| PXH05111("Prov",oBrw2),oMenu01:Activate( X, Y, oObj )}
	
	oBrw4:blDBLClick := {|| PXH05106(@oBrw4) }
	oBrw4:BSEEKCHANGE:= {|| PXH05110(@oBrw4 ) }
	oBrw4:bRClicked:= {|oObj,X,Y| PXH05111("Prov",oBrw4),oMenu01:Activate( X, Y, oObj )}
	
	if lusaDescSaco
		oBrw5:blDBLClick := {|| PXH05106(@oBrw5) }
		oBrw5:BSEEKCHANGE:= {|| PXH05110(@oBrw5 ) }
		oBrw5:bRClicked:= {|oObj,X,Y| PXH05111("Prov",oBrw5),oMenu01:Activate( X, Y, oObj )}
		
		oBrw7:blDBLClick := {|| PXH05106(@oBrw7) }
		oBrw7:BSEEKCHANGE:= {|| PXH05110(@oBrw7 ) }
		oBrw7:bRClicked:= {|oObj,X,Y| PXH05111("Prov",oBrw7),oMenu01:Activate( X, Y, oObj )}
	endif
	
	oBrw6:blDBLClick := {|| PXH05106(@oBrw6) }
	oBrw6:BSEEKCHANGE:= {|| PXH05110(@oBrw6 ) }
	oBrw6:bRClicked  := {|oObj,X,Y| PXH05111("Prov",oBrw6),oMenu01:Activate( X, Y, oObj )}
	
	oBrw8:blDBLClick := {|| PXH05106(@oBrw8) }
	oBrw8:BSEEKCHANGE:= {|| PXH05110(@oBrw8 ) }
	oBrw8:bRClicked  := {|oObj,X,Y| PXH05111("Prov",oBrw8),oMenu01:Activate( X, Y, oObj )}
	
endif

//botoes laterais

naltura:= 009
nnLin  := 015
nEspaco:= 10

oSayNf       := TSay():New( nnLin ,545,{||"Nota Fiscal"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
oBt_nfe      := TButton():New( nnLin+=nEspaco ,542,"NF-e Sefaz",oDlg1	, {||  PXH05114('NFE')    }  ,050,naltura,,,,.T.,,"",,,,.F. )
oBt_Mnt      := TButton():New( nnLin+=nEspaco ,542,"Monitor",oDlg1		, {||  u_PXH05112('MNT')    } ,050,naltura,,,,.T.,,"",,,,.F. )
oBt_Dan      := TButton():New( nnLin+=nEspaco ,542,"Danfe",oDlg1		, {||  u_PXH05112('DAN')    } ,050,naltura,,,,.T.,,"",,,,.F. )
oBt_Sta      := TButton():New( nnLin+=nEspaco ,542,"Status Sefaz",oDlg1	, {||  u_PXH05112('STA')    } ,050,naltura,,,,.t.,,"",,,,.f. )
oBt_Rem      := TButton():New( nnLin+=nEspaco ,542,"Transmisão",oDlg1	, {||  u_PXH05112('REM')    } ,050,naltura,,,,.t.,,"",,,,.f. )

nnLin+=30

oSayVda      := TSay():New( nnLin+=nEspaco  ,545,{||"Pedido"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
oBt_Ped      := TButton():New( nnLin+=nEspaco ,542,"Pedido Mizu" , oDlg1		, {||  PXH05114('PED')   } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Age      := TButton():New( nnLin+=nEspaco ,542,"Agenciamento" , oDlg1		, {||  PXH05114('AGE')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_IOC      := TButton():New( nnLin+=nEspaco ,542,"Imp.Ord.Carreg" , oDlg1		, {||  PXH05114('IOC')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_CEN      := TButton():New( nnLin+=nEspaco ,542,"Cancela Entrada" , oDlg1	, {||  PXH05114('CEN')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_LAC      := TButton():New( nnLin+=nEspaco ,542,"Lacre" , oDlg1		        , {||  PXH05114('LAC')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )

nnLin+=30

oSayVda      := TSay():New( nnLin+=nEspaco  ,545,{||"Cadastro"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
oBt_Cli      := TButton():New( nnLin+=nEspaco ,542,"Cliente" , oDlg1		, {||  PXH05114('CLI')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Mot      := TButton():New( nnLin+=nEspaco ,542,"Motorista" , oDlg1		, {||  PXH05114('MOT')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Tra      := TButton():New( nnLin+=nEspaco ,542,"Transportador" , oDlg1	, {||  PXH05114('TRA')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Cam      := TButton():New( nnLin+=nEspaco ,542,"Caminhão" , oDlg1		, {||  PXH05114('CAM')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Car      := TButton():New( nnLin+=nEspaco ,542,"Carreta" , oDlg1		, {||  PXH05114('CAR')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Pag      := TButton():New( nnLin+=nEspaco ,542,"P a g e r" , oDlg1		, {||  PXH05114('PAG')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )

if !luserFull
	
	oBt_nfe:disable()
	oBt_nfe:disable()
	oBt_Mnt:disable()
	oBt_Dan:disable()
	oBt_Sta:disable()
	oBt_Rem:disable()
	oBt_Cli:disable()
	
endif

Set Key VK_F12 TO getSX1()

Set Key VK_F5 TO U_PXH05103()

oDlg1:Activate(,,,.T.)

Set Key VK_F5 TO

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05102                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Funcao que monta aHeader e Monta Area de Trabalho          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05102()

DbSelectArea("SX3")
DbSetOrder(2)

dbSeek("ZE_STATUS2"); aAdd(waHeader, " ") 			   ; aAdd(waColSizes,1)
dbSeek("ZE_HRAGENC"); aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
dbSeek("ZE_HORPES") ; aAdd(waHeader, "Hr.P.Ent")	   ; aAdd(waColSizes,20)
dbSeek("ZE_PLACA")  ; aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
dbSeek("ZE_MOTOR")  ; aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,100)
dbSeek("ZE_PSENT")  ; aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,30)
dbSeek("ZE_OC")     ; aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
dbSeek("ZE_PALLET") ; aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
dbSeek("ZF_FRETE")  ; aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
dbSeek("ZE_CILINDR"); aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
dbSeek("ZE_PAGER")  ; aAdd(waHeader, "Pager")		   ; aAdd(waColSizes,20)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05104                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05104()

Local aAreaAtu := GetArea()
Local cCores1
Local cCores2
Local cCores3
Local cCores4
Local cCores5
Local cCores6
Local cCores7
Local cCores8
aList1	  := {}
aList2	  := {}
aList3	  := {}
aList4	  := {}
aList5	  := {}
aList6	  := {}
aList7	  := {}
aList8	  := {}

nVP        := 0
nVC        := 0
nVD        := 0

cZFFrete := ''
cColuna03:= ''
ccampo03 := ''
cColuna11:= ''
ccampo11 := ''

cSQL := " SELECT ZE_STATUS2, ZE_HRAGENC, ZE_PAGER, ZE_PLACA, ZE_NOMMOT, ZE_PSENT, ZE_OC, "
cSQL += " ZE_TPOPER, ZE_SACGRA , ZE_IHM, ZE_PALLET, ZE_CILINDR, LEFT(ZE_CATEGMP,2) AS ZE_CATEGMP, ZE_HORPES "
cSQL += " FROM "+RetSqlName("SZE") +" SZE "
cSQL += " WHERE ZE_DATA   <= '" +DTOS(dDataBase)+ "'"
cSQL += " AND   ZE_STATUS2 <= '9'"
cSQL += " AND   ZE_FATUR <> 'S'" // NAO FATURADOS
cSQL += " AND   SZE.D_E_L_E_T_= ' ' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
cSQL += " ORDER BY ZE_DATA, ZE_HORA "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), "SZE001", .F., .T.)

DbSelectArea("SZE001")

While SZE001->(!EOF())
	
	aListAux := {}
	
	cZFFrete := Posicione("SZF",8,xFilial("SZF")+SZE001->ZE_OC,"ZF_FRETE")
	cCilindro:= iif( SZE001->ZE_CILINDR=='1', 'S','N')
	
	cColuna03:= SZE001->ZE_HORPES
	ccampo03 := 'ZE_HORPES'
	
	cColuna11:= SZE001->ZE_PAGER
	ccampo11 := 'ZE_PAGER'
	
	// ** //
	// CARREGAMENTO PATIO SACO
	if lusaCarrSaco
		If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS2 $ '1/2/7' .AND. SZE001->ZE_SACGRA = 'S'
			aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
			aAdd(aList1, aListAux)
			nVP++
		EndIf
	Endif
	
	// CARREGAMENTO PATIO GRANEL
	If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS2 $ '1/2/7' .AND. SZE001->ZE_SACGRA = 'G'
		aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
		aAdd(aList2, aListAux)
		nVP++
	EndIf
	
	// CARREGAMENTO FABRICA SACO
	if lusaCarrSaco
		If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS2 > '2' .AND. SZE001->ZE_STATUS2 < '7' .AND. SZE001->ZE_SACGRA = 'S'
			aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
			aAdd(aList3, aListAux)
			nVC++
		EndIf
	endif
	
	// CARREGAMENTO FABRICA GRANEL
	If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS2 $ '3/4/5/6/8/9' .AND. SZE001->ZE_SACGRA = 'G'
		aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
		aAdd(aList4, aListAux)
		nVC++
	EndIf
	
	// ** DESCACARREGAMENTO ** //
	// DESCARREGAMENTO PATIO SACO
	if lUsaDescSaco
		If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS2 $ '1/2' .AND. ( SZE001->ZE_SACGRA = 'G' .AND. SZE001->ZE_CATEGMP =='CP' )
			aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
			aAdd(aList5, aListAux)
			nVP++
		EndIf
	endif
	
	// DESCARREGAMENTO PATIO GRANEL
	If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS2 $ '1/2' .AND. ( SZE001->ZE_SACGRA = 'G'  .AND. SZE001->ZE_CATEGMP =='EM' )
		aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
		aAdd(aList6, aListAux)
		nVP++
	EndIf
	
	// DESCARREGAMENTO FABRICA SACO
	if lUsaDescSaco
		If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS2 > '2' .AND.  ( SZE001->ZE_SACGRA = 'G' .AND. SZE001->ZE_CATEGMP =='CP' )
			aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
			aAdd(aList7, aListAux)
			nVD++
		EndIf
	endif
	
	// DESCARREGAMENTO FABRICA GRANEL
	If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS2 > '2' .AND.  ( SZE001->ZE_SACGRA = 'G'  .AND. SZE001->ZE_CATEGMP =='EM' )
		aListAux := {SZE001->ZE_STATUS2,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cZFFrete, cCilindro, cColuna11}
		aAdd(aList8, aListAux)
		nVD++
	EndIf
	
	SZE001->(DbSkip())
EndDO

SZE001->(DbCloseArea())

If Len(aList1) = 0 .and.  lUsaCarrSaco
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
	aAdd(aList1, aListAux)
EndIf

If Len(aList2) = 0
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
	aAdd(aList2, aListAux)
EndIf

If Len(aList3) = 0 .and.  lUsaCarrSaco
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
	aAdd(aList3, aListAux)
EndIf
If Len(aList4) = 0
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
	aAdd(aList4, aListAux)
EndIf
If Len(aList5) = 0 .and.  lUsaDescSaco
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
	aAdd(aList5, aListAux)
EndIf
If Len(aList6) = 0
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
	aAdd(aList6, aListAux)
EndIf
If Len(aList7) = 0 .and.  lUsaDescSaco
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
	aAdd(aList7, aListAux)
EndIf
If Len(aList8) = 0
	aListAux := {" ",Criavar("ZE_HRAGENC"),Criavar(cCampo03),Criavar("ZE_PLACA"),Criavar("ZE_NOMMOT"),Criavar("ZE_PSENT"), space( TamSx3('ZE_OC')[1] ), space( 1 ), space( 1 ), space( 1 ), Criavar(cCampo11)}
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

cCond5:=" oBrw4:aArray[oBrw4:nAt,01]='3' .and.  oBrw4:aArray[oBrw4:nAt,06]=0 .and. !empty( posicione('SZE',1,xfilial('SZE')+oBrw4:aArray[oBrw4:nAt,07],'ZE_IHM') )  "

cCores1 :=	"If(oBrw1:aArray[oBrw1:nAt,01]=' ',oBranco,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='1',oAmarelo,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='2',oVerde,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='3',oPink,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='4',oAzul,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='5',oCinza,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='7',oMarrom,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='6',oVermelho,''))))))))"

cCores2 :=	"If(oBrw2:aArray[oBrw2:nAt,01]=' ',oBranco,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='1',oAmarelo,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='2',oVerde,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='3',oPink,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='4',oAzul,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='5',oCinza,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='7',oMarrom,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='6',oVermelho,''))))))))"

cCores3 :=	"If(oBrw3:aArray[oBrw3:nAt,01]=' ',oBranco,"+;
"If(oBrw3:aArray[oBrw3:nAt,01]='1',oAmarelo,"+;
"If(oBrw3:aArray[oBrw3:nAt,01]='2',oVerde,"+;
"If(oBrw3:aArray[oBrw3:nAt,01]='3',oPink,"+;
"If(oBrw3:aArray[oBrw3:nAt,01]='4',oAzul,"+;
"If(oBrw3:aArray[oBrw3:nAt,01]='5',oCinza,"+;
"If(oBrw3:aArray[oBrw3:nAt,01]='6',oVermelho,'')))))))"

cCores4 :=	"If(oBrw4:aArray[oBrw4:nAt,01]=' ',oBranco,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='1',oAmarelo,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='2',oVerde,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='3',oPink,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='4',oAzul,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='5',oCinza,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='6',oVermelho,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='8',oLaranja,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='9',oLaranja,'')))))))))"

cCores5 :=	"If(oBrw5:aArray[oBrw5:nAt,01]=' ',oBranco,"+;
"If(oBrw5:aArray[oBrw5:nAt,01]='1',oAmarelo,"+;
"If(oBrw5:aArray[oBrw5:nAt,01]='2',oVerde,"+;
"If(oBrw5:aArray[oBrw5:nAt,01]='3',oPink,"+;
"If(oBrw5:aArray[oBrw5:nAt,01]='4',oAzul,"+;
"If(oBrw5:aArray[oBrw5:nAt,01]='5',oCinza,"+;
"If(oBrw5:aArray[oBrw5:nAt,01]='6',oVermelho,'')))))))"

cCores6 :=	"If(oBrw6:aArray[oBrw6:nAt,01]=' ',oBranco,"+;
"If(oBrw6:aArray[oBrw6:nAt,01]='1',oAmarelo,"+;
"If(oBrw6:aArray[oBrw6:nAt,01]='2',oVerde,"+;
"If(oBrw6:aArray[oBrw6:nAt,01]='3',oPink,"+;
"If(oBrw6:aArray[oBrw6:nAt,01]='4',oAzul,"+;
"If(oBrw6:aArray[oBrw6:nAt,01]='5',oCinza,"+;
"If(oBrw6:aArray[oBrw6:nAt,01]='6',oVermelho,'')))))))"

cCores7 :=	"If(oBrw7:aArray[oBrw7:nAt,01]=' ',oBranco,"+;
"If(oBrw7:aArray[oBrw8:nAt,01]='1',oAmarelo,"+;
"If(oBrw7:aArray[oBrw7:nAt,01]='2',oVerde,"+;
"If(oBrw7:aArray[oBrw7:nAt,01]='3',oPink,"+;
"If(oBrw7:aArray[oBrw7:nAt,01]='4',oAzul,"+;
"If(oBrw7:aArray[oBrw7:nAt,01]='5',oCinza,"+;
"If(oBrw7:aArray[oBrw7:nAt,01]='6',oVermelho,'')))))))"

cCores8 :=	"If(oBrw8:aArray[oBrw8:nAt,01]=' ',oBranco,"+;
"If(oBrw8:aArray[oBrw8:nAt,01]='1',oAmarelo,"+;
"If(oBrw8:aArray[oBrw8:nAt,01]='2',oVerde,"+;
"If(oBrw8:aArray[oBrw8:nAt,01]='3',oPink,"+;
"If(oBrw8:aArray[oBrw8:nAt,01]='4',oAzul,"+;
"If(oBrw8:aArray[oBrw8:nAt,01]='5',oCinza,"+;
"If(oBrw8:aArray[oBrw8:nAt,01]='6',oVermelho,'')))))))"

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

RestArea(aAreaAtu)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05106                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05106(oBrwAux)

Local cHora
Local cPlacaCar
Local cMotorCar
If Len(oBrwAux:aArray) = 0
	Return
EndIf
cHora     := oBrwAux:aArray[oBrwAux:nAT,2]
cPlacaCar := oBrwAux:aArray[oBrwAux:nAT,4]
cMotorCar := oBrwAux:aArray[oBrwAux:nAT,5]

dbSelectArea("SZE")
dbsetorder(1)
dbSeek(xFilial("SZE")+oBrwAux:aArray[oBrwAux:nAT,7])

lCarrGranel:= (sZE->ZE_sacgra=='G') .AND. (sZE->ZE_tpoper=='C')

lSemPeso:= lCarrGranel .and. (oBrwAux:aArray[oBrwAux:nAT,1] == "2")  .and. cEmpAnt $ '20'

SetPrvt("oDlg2","oSay1","oSay2","oSay3","oBtGranel","oBtn2","oBtn3","oGet1","oGet2","oGet3","cStatus")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 241,349,383,729,"Operações",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 018,012,{||"Placa"}    ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
oSay2      := TSay():New( 031,012,{||"Motorista"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
oSay3      := TSay():New( 005,012,{||"Hora"}     ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
cStatus    := oBrwAux:aArray[oBrwAux:nAT,1]

If oBrwAux:aArray[oBrwAux:nAT,1] == "1"
	oBtn2  := TButton():New( 050,069,"Chamar no Pager",oDlg2,{|| MsAguarde({|| PXH05107(@oBrwAux,1), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
ElseIf oBrwAux:aArray[oBrwAux:nAT,1] $ "2/7"
	oBtn1  := TButton():New( 050,010,iif(cStatus="2","Cancelar Chamar","Cancelar Chamar 2"),oDlg2,{|| MsAguarde({|| PXH05107(@oBrwAux,VAL(cStatus)), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
	oBtn2  := TButton():New( 050,069,iif(!lCarrGranel.or.!lSemPeso, "Pesar", "S/ Peso" )   ,oDlg2,{|| MsAguarde({|| PXH05108(@oBrwAux,lCarrGranel,lSemPeso) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
ElseIf oBrwAux:aArray[oBrwAux:nAT,1] $ "6/8"
	If SZE->ZE_TPOPER == "C"
		oBtn2  := TButton():New( 050,069,"Faturar",oDlg2,{|| PXH05116(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
	ElseIf SZE->ZE_TPOPER == "D"
		oBtn1  := TButton():New( 050,010,"Pesar Saída",oDlg2,{|| MsAguarde( {|| PXH05115(@oBrwAux, lCarrGranel) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
	EndIf
ElseIf oBrwAux:aArray[oBrwAux:nAT,1] = "9"
	oBtn2  := TButton():New( 050,069,"Nota Entregue",oDlg2,{|| NOTAENTREGUE(@oBrwAux),oDlg2:End() },055,015,,,,.T.,,"",,,,.F. )
ElseIf oBrwAux:aArray[oBrwAux:nAT,1] $ "3/4"
	if luserFull .and. ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  )
		oBtn1  := TButton():New( 050,010,"Status Sigex",oDlg2,{|| SMFATA08(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
	endif
	
	if  ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  )
		oBtn2  := TButton():New( 050,069,"Cancelar Peso",oDlg2,{|| MsAguarde( {|| PXH05108(@oBrwAux,lCarrGranel,lSemPeso,2) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
	elseif lCarrGranel
		oBtn2  := TButton():New( 050,069,"Captura Peso",oDlg2,{|| MsAguarde( {|| PXH05108(@oBrwAux,lCarrGranel, lSemPeso) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
	endif
EndIf

oBtn3      := TButton():New( 050,128,"Fechar",oDlg2,{|| oDlg2:End()},055,015,,,,.T.,,"",,,,.F. )
oGet1      := TGet():New( 017,043,{|u| If(PCount()>0,cPlacaCar:=u,cPlacaCar)},oDlg2,033,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPlacaCar",,)
oGet2      := TGet():New( 030,043,{|u| If(PCount()>0,cMotorCar:=u,cMotorCar)},oDlg2,116,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cMotorCar",,)
oGet3      := TGet():New( 004,043,{|u| If(PCount()>0,cHora:=u,cHora)},oDlg2,021,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHora",,)

oDlg2:Activate(,,,.T.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05108                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05108(_oBrwAux,p_lCarrGranel,p_lSemPeso,p_nOpcao)

Local nPesoAux     := 0
Local aAreaAtu     := GetArea()
local cStatus      := _oBrwAux:aArray[_oBrwAux:nAT,1]
local cOC	       := _oBrwAux:aArray[_oBrwAux:nAT,7]
local cPager       := _oBrwAux:aArray[_oBrwAux:nAT,3]
local cpgLacre     := 'LACRE02'
local lCancelPeso  := (p_nOpcao==2)
Local aContent     := FWGETSX5("PG")

PRIVATE cColeta:="A"  //A-AUTOMATICA   M- MANUAL

PXH05109(cpgLacre)

dbSelectArea("SZE")
dbSetOrder(1)
dbSeek(xFilial("SZE")+cOC)

lSemPeso:= p_lSemPeso

lpesoOk:=.f.

While  !lpesoOK .and. !lSemPeso .and. !lcancelPeso
	nPesoAux :=0
	
	U_PXH05401(@nPesoAux,"ENTRADA",@cColeta)
	
	if !( lpesoOK:=( nPesoaux > 0 ) )
		lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
	endif
EndDo

if (nPesoAux==0) .and. !lSemPeso  .and. !lcancelPeso//saco
	Alert('Nao e permitido prosseguir sem peso!')
Else
	if p_lCarrGranel   .and. empty(sZE->ZE_lacre)
		
		cLacre:=''
		while empty(cLacre)
			cLacre:= u_frmLacres()
		end
	Endif
	
	//****************
	
	nPEntAnt:= sZE->ZE_psent // grava o peso antes de altera-lo mais abaixo. para comparar se estava zerado
	
	If dbSeek(xFilial("SZE")+_oBrwAux:aArray[_oBrwAux:nAT,7])
		
		Begin Transaction
		
		RecLock("SZE",.F.)
		SZE->ZE_PSENT   := nPesoAux
		SZE->ZE_HORPES  := iif( lcancelPeso, '', Substr(Time(),1,5) )
		SZE->ZE_STATUS2 := iif( lcancelPeso, '2' , '3' )
		SZE->ZE_COLEENT := cColeta
		SZE->ZE_HORAATU := time()
		if p_lCarrGranel .and. empty(sZE->ZE_lacre)
			sZE->ZE_lacre := iif( !empty( Alltrim(cLacre) ) , Alltrim(cLacre) , 'Nao informado na entrada' )
		endif
		SZE->(MsUnLock())
		
		SMFATF62(sZE->ZE_oc, sZE->ZE_lacre,sZE->ZE_psent)
		
		//Grava no BANCO DE DADOS SIGEX a mensagem na tabela de mensagens
		//****************************************************************
		//p_cTexto  := "FAVOR PROSSEGUIR"
		//p_cStatus :=  "3"
		
		End Transaction
		
		u_PXH05105(_oBrwAux:aArray[_oBrwAux:nAT,7] , _oBrwAux:aArray[_oBrwAux:nAT,4], lcancelPeso)
		
	EndIf
	
endif

// Atualiza os grids
PXH05104()

RestArea(aAreaAtu)

oDlg2:End()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05115                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05115(_oBrwAux,p_lCarrGranel)

Local nPesoAux := 0
Local aAreaAtu := GetArea()
local cStatus  := _oBrwAux:aArray[_oBrwAux:nAT,1]
private cColeta:= "A"

// peso modelo II
lpesoOk        := .f.
lyes           := .f.

While  !lpesoOK
	IF lUsaNewOC .and. cempant $ '20|01|10|11|30'
		nPesoAux := 0
		u_frmPesoBal(@nPesoAux,"SAIDA",@cColeta)
		if !( lpesoOK:=( nPesoAux > 0 ) )
			lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
		endif
		
	ELSE
		nPesoAux := u_PXH04502("S",@cColeta) // chamar novamente a funcao para obter o peso da balanca
		
		lyes := MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
		if !lyes
			lpesoOK:=.f.
			exit
		endif
	ENDIF
ENDDO


if (nPesoAux==0)
	Alert('Nao e permitido prosseguir sem peso!')
	return
endif

lpesoOK:=.t.
if  sZE->ZE_tpoper == 'D'
	
	nPesLiq:=0
	nPesLiq:= sZE->ZE_psent - nPesoAux
	
	nDifPes:=0
	nDifPes:= sZE->ZE_nfpesen - nPesLiq
	
	if  nDifPes > getnewPar('MV_MXDIFPS',200)
		MsgBox("ATENCAO!   A diferença de Peso é maior que a permitida! ","Peso Errado!!! ", "ALERT")
		lpesoOK:= u_SMFATT25()
	endif
endif


//****************
// Grava o peso e status na SZE
dbSelectArea("SZE")
dbSetOrder(1)

If dbSeek(xFilial("SZE")+_oBrwAux:aArray[_oBrwAux:nAT,7])
	
	RecLock("SZE",.F.)
	SZE->ZE_PSSAI   := nPesoAux
	SZE->ZE_DTSAIDA := dDatabase
	SZE->ZE_HSAIDA  := Substr(Time(),1,5)
	SZE->ZE_COLESAI := cColeta
	SZE->ZE_STATUS2 := '6'
	SZE->ZE_FATUR   := 'S'
	SZE->ZE_PAGER   := ''
	SZE->ZE_HORAATU := time()
	SZE->(MsUnLock())
	
	_cPager:= sZE->ZE_pager
	
	//imprime tickt de balança
	U_PXH060(SZE->ZE_oc)
EndIf

// Atualiza os grids
PXH05104()

RestArea(aAreaAtu)

oDlg2:End()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05107                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05107(_oBrwAux,p_nOpcao)

Local aAreaAtu  := GetArea()
Local cStAux	:= ""
local cPager    := _oBrwAux:aArray[_oBrwAux:nAT,11]
Local aContent   := FWGETSX5("PG")

If Empty(cPager) .OR. cPager="ZZ"
	cPagEsc := u_PXH053()
	while cPagEsc="ZZ"
		if !(MsgBox("Não é possivel prosseguir sem pager e no momento não há nenhum disponivel, deseja tentar de novo?","Atenção", "YESNO"))
			
			return (.F.)
		endif
		cPagEsc := u_PXH053()
	end
	if empty(cPagEsc); return (.F.); endif
	_oBrwAux:aArray[_oBrwAux:nAT,11] := cPagEsc
	dbselectarea("SZE")
	dbsetorder(1)
	dbSeek(xFilial("SZE")+_oBrwAux:aArray[_oBrwAux:nAT,7])
	RecLock("SZE",.F.)
	SZE->ZE_PAGER := cPagEsc
	SZE->ZE_CBPAGER := cValtoChar(10000000 + val(cPagEsc))
	SZE->(MsUnLock())
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
dbSelectArea("SZE")
dbSetOrder(1)
If dbSeek(xFilial("SZE")+_oBrwAux:aArray[_oBrwAux:nAT,7])
	// Testa na base se o status é 1 e impede alteracao caso nao seja.
	
	If ( p_nOpcao == 1 .and. SZE->ZE_STATUS2 <> '1' ) .or. ( p_nOpcao == 2 .and. SZE->ZE_STATUS2 <> '2' )
		MsgInfo("Houve alteração do status desse registro, possivelmente por outro usuário. O sistema irá atualizar a tela. Verifique!")
		PXH05104()
		
		RestArea(aAreaAtu)
		//Return(.f.)
	EndIf
	
	SZE->(RecLock("SZE",.F.))
	if SZE->ZE_STATUS2 = '7'
		SZE->ZE_STATUS2 := '2'
	endif
	
	// Grava status
	if SZE->ZE_STATUS2 <'3'
		SZE->ZE_STATUS2 := iif(p_nOpcao==1, '2', '1' )
	endif
	SZE->ZE_HORAATU := time()
	SZE->(MsUnLock())
	
	u_PXH05105(_oBrwAux:aArray[_oBrwAux:nAT,7] , _oBrwAux:aArray[_oBrwAux:nAT,4])
	
EndIf

PXH05104()

RestArea(aAreaAtu)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05103                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PXH05103(p_nOpc)

Local cTipo := if(oFolder1:nOption=1,"C","D")

U_PXH044(,cTipo)

PXH05104()

if p_nOpc== nil .or. p_nOpc>0
	
	MsgInfo("Status Atualizado as "+time())
endif

U_PXH05105()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05116                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05116(_oBrwAux)

local cOC	 := _oBrwAux:aArray[_oBrwAux:nAT,7]
local cPlaca := _oBrwAux:aArray[_oBrwAux:nAT,4]
local aNotas := {}

U_MIZ035('MIZ999')

if SuperGetMV("MV_USASMS",,.F.)
	DbSelectArea("SZ7")
	DbSetOrder(8)
	if DbSeek(xFilial("SZ7")+cOC)
		aInfoSMS := {SZ7->Z7_NUM,SZ7->Z7_NUMNF}
		u_SMFATF79('NOTAFISCAL',,3,,aInfoSMS)
	endif
endif

if Posicione("SZE",1,xFilial("SZE")+cOC,"ZE_STATUS2") == '9'
	U_PXH05105(cOC,cPlaca)
Endif

oDlg2:End()
PXH05104()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05101                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05101(cperg)

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
Local aAreaAtu := GetArea()
Local wOC := _oBrwAux:aArray[_oBrwAux:nAT,7]

if cempant=='20'
	if !u_PXH06101('PESOMANUAL')
		return .f.
	endif
endif

// Grava o peso e status na SZE
dbSelectArea("SZE")
dbSetOrder(1)
If dbSeek(xFilial("SZE")+wOC)
	RecLock("SZE",.F.)
	//SZE->ZE_STATUS  := "6"
	SZE->ZE_STATUS2 := '6'
	SZE->ZE_PESOFIN := 99
	SZE->ZE_PSSAI   := 0
	SZE->ZE_HORAATU := time()
	SZE->(MsUnLock())
EndIf

// Atualiza os grids
PXH05104()

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
±±³Fun‡Æo    ³ PXH05109                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function PXH05109(cperg)

cperg:=padr(cperg,10)
aRegs :={}

aAdd(aRegs,{cPerg,"01","Lacre 1			? ","","","mv_ch1","C",50,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Lacre 2			? ","","","mv_ch2","C",50,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

DbSelectArea("SZF")
DbSetOrder(8)
DbSeek(xFilial("SZF")+p_cOC)
Do while .not. eof() .and. ZF_FILIAL == xFilial("SZF") .and. ZF_OC == p_cOC
	sZF->(reclock('SZF',.f.))
	if !empty(p_cLacre)
		sZF->ZF_lacre := p_cLacre
	endif
	sZF->ZF_psent := p_nPSEnt
	
	sZF->(msunlock())
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
±±³Fun‡Æo    ³ PXH05112                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User function PXH05112(p_cOpcao,cSerie,cNotaIni,cNotaFim)

local warea       := getarea()
local lret        :=.t.
Local cParNfeRem  := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local cParNfeMnt  := '000179_'+SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local aPerg       := {}
Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}

PRIVATE cCondicao := ""
PRIVATE bFiltraBrw:= {|| .t. }

if p_cOpcao $ 'TODAS/REM'
	
	spedNFeRe2(cSerie,cNotaIni,cNotaFim)
	
endif

if p_cOpcao $ 'TODAS/MNT'
	
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
		
		aadd(aPerg,{1,'STR0010',aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
		aadd(aPerg,{1,'STR0011',aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
		aadd(aPerg,{1,'STR0012',aParam[03],"",".T.","",".T.",30,.T.})  //"Nota fiscal final"
		
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
		
		u_PXH05113(aParametros,xPerg)
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
±±³Fun‡Æo    ³ PXH05113                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PXH05113(aParametros,cPerg)

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
±±³Fun‡Æo    ³ PXH05114                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static function PXH05114(p_cOpcao)

local warea:= getArea()

do case
	case p_cOpcao =='PED' ; u_Miz016()
	case p_cOpcao =='CLI' ; MATA030()
	case p_cOpcao =='AGE' ; u_SMFatT13()
	case p_cOpcao =='MOT' ; u_Miz010()
	case p_cOpcao =='TRA' ; MATA050()
	case p_cOpcao =='CAM' ; u_Miz005()
	case p_cOpcao =='CAR' ; u_MiZF030()
	case p_cOpcao =='IOC' ; u_MIZ050GR('botaomiz999',wnumOC)
	case p_cOpcao =='NFE' ; SpedNFe()
	case p_cOpcao =='CEN' ; u_miz030(wnumOC)
	case p_cOpcao =='PAG' ; u_SMFATT01()
	case p_cOpcao =='LAC' ; u_SMFATI02(wnumOC)
		
endcase

//odlg1:enable()


RestArea(wArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH05110                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static function PXH05110(oBrwAux)

local warea:= getArea()

oBrwAux:Refresh()

wNumOC:=oBrwAux:aArray[oBrwAux:nAT,7]

if empty(oBrwAux:aArray[oBrwAux:nAT,7]) ; return; endif

dbSelectArea("SZE")
dbsetorder(1)
dbSeek(xFilial("SZE")+wNumOC)

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


User function SMFATC02(p_cCB,p_cTipo)

local aTbPager:=FWGETSX5("PG")
local warea:= getArea()
local cCB := iif(  p_cCB==nil, U_SMFATF65(.t.) , p_cCB )  //captura CB no leitor
local cTipo := iif( p_cTipo==nil, cTipo := "N" , cTipo := p_cTipo)

DbSelectArea("SZE")
DbSetOrder(1)


if cTipo = "N"
	return
elseif cTipo = "E"
	cSQL := "SELECT ZE_NOMMOT,ZE_OC,ZE_PAGER FROM "+RetSqlName("SZE")+" SZE "
	cSQL += " WHERE SZE.D_E_L_E_T_= ' ' AND ZE_FILIAL = '" + xFilial("SZE") + "'"
	cSQL += " AND ZE_STATUS2 = '2' AND ZE_PSENT = 0"
	cSQL += " AND ZE_DATA >= '"+DTOS(dDataBase-2)+"'"
	cSQL += " AND ZE_CBPAGER = '"+ALLTRIM(cCB)+"'"
elseif cTipo = "S"
	cSQL := "SELECT ZE_NOMMOT,ZE_OC,ZE_PAGER FROM "+RetSqlName("SZE")+" SZE "
	cSQL += " WHERE SZE.D_E_L_E_T_= ' ' AND ZE_FILIAL = '" + xFilial("SZE") + "'"
	cSQL += " AND ZE_STATUS2 = '5' AND ZE_PSENT != '0'"
	cSQL += " AND ZE_DATA >= '"+DTOS(dDataBase-2)+"'"
	cSQL += " AND ZE_CBPAGER = '"+ALLTRIM(cCB)+"'"
endif


if select('SZE991')>0
	SZE991->(DbCloseArea())
endif
dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), "SZE991", .F., .T.)
dbSelectArea('SZE991')
SZE991->(DbGoTop())

if sZE->( dbseek( xfilial('SZE') + SZE991->ZE_oc  ) ) .and. Alltrim(sZE->ZE_cbpager) == Alltrim(cCB)
	
	RecLock("SZE",.F.)
	if cTipo = "E"
		//SZE->ZE_STATUS  := '7'
		SZE->ZE_STATUS2 := '7'
		SZE->ZE_HORAATU := time()
	elseif cTipo = "S"
		//SZE->ZE_STATUS  := '6'
		SZE->ZE_STATUS2 := '6'
		SZE->ZE_HORAATU := time()
	endif
	SZE->(MsUnLock())
	
	u_PXH05105(SZE->ZE_OC, SZE->ZE_PLACA)
endif

SZE991->(DbCloseArea())
RestArea(warea)
return


User function SMFATF75()

local cOC := ""
local wArea := getArea()
local aNotas := {}

cSQL := "SELECT * FROM "+RetSqlName("SZE")+" SZE "
cSQL += "WHERE SZE.D_E_L_E_T_= ' ' AND ZE_FILIAL = '"+xFilial("SZE")+"' AND ZE_STATUS2 = '6' "
cSQL += "AND ZE_FATUR = 'S' AND ZE_PSENT <> '0' AND ZE_PSSAI <> '0' "
cSQL += "AND ZE_DATA = '" +DTOS(dDataBase)+ "' AND SUBSTRING(ZE_WRKFLW,3,1) <> '1'"

TCQUERY cSQL New Alias "BPF" // BUSCA PEDIDOS FATURADOS
dbSelectArea('BPF')
BPF->(DbGoTop())
while BPF->(!eof())
	cOC += "'"+BPF->ZE_OC+"',"
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

if SZE->ZE_OC = cOC
	RecLock("SZE",.F.)
	//SZE->ZE_STATUS  := "6"
	SZE->ZE_STATUS2 := '6'
	SZE->ZE_FATUR   := "S"
	SZE->ZE_HORAATU := time()
	MsUnlock()
endif

U_PXH05103(0)

return

Static function PXH05111(p_cOrigem,p_oBrwAux)

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
		
		dbSelectArea("SZE")
		dbSetOrder(1)
		if dbSeek(xFilial("SZE")+cOC)
			dbSelectArea("SB1")
			dbSetOrder(1)
			if dbSeek(xFilial("SB1")+SZE->ZE_PRODUTO)
				AxVisual("SB1",RECNO(),1,aCampos)
			endif
		endif
		
	case cOrigem == "OC"
		
		cCadastro := "Detalhes - OC"
		aCampos   := {"NOUSER","ZE_OC","ZE_PLACA","ZE_NOMMOT"}
		
		dbSelectArea("SZE")
		dbSetOrder(1)
		if dbSeek(xFilial("SZE")+cOC)
			iif(Empty(SZE->ZE_ITENSOC),AAdd(aCampos,"ZE_PRODUTO"),AAdd(aCampos,"ZE_ITENSOC"))
			AxVisual("SZE",RECNO(),1,aCampos)
		endif
		
	case cOrigem == "Prov"
		
		oMenu01 := tMenu():new(0,0,0,0,.T.)
		dbSelectArea("SZE")
		dbSetOrder(1)
		if dbSeek(xFilial("SZE")+cOC)
			if !Empty(SZE->ZE_ITENSOC)
				cItensOC := ALLTRIM(SZE->ZE_ITENSOC)
				aItens := StrTokArr(cItensOC,"#")
				for i := 1 to LEN(aItens)
					aItens[i] := "Produto: "+substr(aItens[i],1,at("/",aItens[i])-1)
					oMenuItem := tMenuItem():new(oMenu01,aItens[i],,,,{||},,,,,,,,,.T.)
					oMenu01:Add(oMenuItem)
				next
			else
				AAdd(aItens,"Produto: "+ALLTRIM(SZE->ZE_PRODUTO))
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

Local cLacre
Local cOC       := iif(p_cOC == nil,'',p_cOC)
Local cTPoper   := SZE->ZE_TPOPER
Local cPallet   := SZE->ZE_PALLET
Local cLacreAnt := SZE->ZE_LACRE
Local wArea     := getArea()

if Empty(cOC) .Or. cTPoper <> 'C' .Or. cPallet <> 'G'
	return .F.
endif

while empty(cLacre)
	cLacre:= u_frmLacres()
	if empty(cLacre)
		if MsgNoYes("Nenhum lacre foi adicionado, deseja sair?","Atencao")
			return .f.
		endif
	endif
end

if !empty(SZE->ZE_LACRE) .And. Alltrim(cLacre) <> Alltrim(SZE->ZE_LACRE)
	if !MsgNoYes("Já existem lacres cadastrados para essa Ordem de Carregamento, deseja substituir?","Atencao")
		return .F.
	endif
endif

if reclock('SZE',.F.) .And. !Empty(Alltrim(cLacre))
	SZE->ZE_LACRE := Alltrim(cLacre)
	MsUnlock()
endif

dbSelectArea("SZF")
dbSetOrder(8)
if MsSeek(xFilial("SZF")+cOC)
	if reclock('SZF',.F.) .And. !Empty(Alltrim(cLacre))
		SZF->ZF_LACRE := Alltrim(cLacre)
		MsUnlock()
	endif
endif

restArea(wArea)

Return

/*
// Ponto de entrada pada adicionar botão na enchoicebar do cadastro de cliente
// Adicionado por Rodrigo Feitosa 30/04/13
User function MA030BUT

Local aUsrBut := {}
Local cEmps := GETNEWPAR("MV_SMCLIPL",'30')

if cEmpAnt $ cEmps
AADD( aUsrBut, {"PEDIDO", {|| If(!Empty(M->A1_COD),SMFATT35(),ALERT('Operação inválida em caso de inclusão.'))},"Info Cliente"} )
endif

return aUsrBut
*/
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
_aCampos := {"ZI_PRODUTO","ZI_PRECO","ZI_PRECOF"}

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
	Transform(aCols[oBrw:nAt,03],'@E 999,999,999.99')}}
endif
oBrw2:SetArray(aCols2)
if LEN(aCols2) > 0
	oBrw2:bLine := {||{ Transform(aCols2[oBrw2:nAt,01],'@E 999,999,999.99'), ;
	aCols2[oBrw2:nAt,02]}}
endif
oDlg:Activate(,,,.T.)

return

User function SMFATT01()

//Variaveis Locais
Local oBitmap1
Local oGet1
Local cGet1 := space(3)
Local oGet2
Local cGet2 := space(3)
Local oGroup1
Local oMultiGe1
Local cMultiGe1 := space(200)
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oRadio
Local oRadio2
Local oRadio3
Local nRadio := GETMV("MV_SMPAG01")
Local nRadio2 := GETMV("MV_SMPAG02")
Local nRadio3 := GETMV("MV_SMPAG03")
Local aItens := {"Sim","Não"}
Local oBMP
Local nI 	   := 0
Local lPAG   :=.F.
Local lENV :=.F.
Local lCANC :=.F.
Static oDlg

DEFINE MSDIALOG oDlg TITLE "SIGEX - SISTEMA INTEGRADO DE GESTÃO DE EXPEDIÇÃO" FROM 000, 000  TO 570, 480 COLORS 0, 16777215 PIXEL

@ 100, 081 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 078, 041 COLORS 0, 16777215 HSCROLL PIXEL
@ 002, 005 GROUP oGroup1 TO 030, 235 PROMPT "Informações" OF oDlg COLOR 50, 16777215 PIXEL
@ 015, 050 SAY oSay1 PROMPT "Do pager :" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
oGet1:=TGet():Create(oDlg2,{|u| If(PCount() > 0, cGet1 := u, cGet1)},012,080,015,010,"999",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGet1,,,, )
@ 015, 110 SAY oSay2 PROMPT "Até:" SIZE 011, 007 OF oDlg COLORS 0, 16777215 PIXEL
oGet2:=TGet():Create(oDlg2,{|u| If(PCount() > 0, cGet2 := u, cGet2)},012,125,015,010,"999",{|| iif(val(cGet2)<=GETMV("MV_MAXPAGE"),.T.,(Alert("O Numero máximo de pager no momento é de : "+cValtoChar(GETMV("MV_MAXPAGE"))),.F.))},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGet2,,,, )
//oTButton1 := TButton():New( 270, 005, "Configurações",oDlg,{|| SMFATT02()}, 232,13,,,.F.,.T.,.F.,,.F.,,,.F. )
@ 033, 004 BITMAP oBitmap1 SIZE 254, 239 OF oDlg FILENAME "\Imagens\pager.png" NOBORDER PIXEL
oBitmap1:lAutoSize := .T.
oBmp3:= TBitmap():New(151, 090,063, 018,,"\Imagens\enviar.png",.T.,oDlg,{|| Processa( {|| U_SMFATF01(cGet1,cGet2,ALLTRIM(cMultiGe1),"I")} )},,.F.,.F.,,,.F.,,.T.,,.F.)
oBmp3:lAutoSize := .T.
oBmp3:lStretch := .F.
//oBmp4:= TBitmap():New(173, 090,063, 018,,"\Imagens\limpar.png",.T.,oDlg,{|| cMultiGe1 := space(200)},,.F.,.F.,,,.F.,,.T.,,.F.)
oBmp4:= TBitmap():New(173, 090,063, 018,,"\Imagens\limpar.png",.T.,oDlg,{|| Processa( {|| U_SMFATF78()},"Limpar") },,.F.,.F.,,,.F.,,.T.,,.F.)
oBmp4:lAutoSize := .T.
oBmp4:lStretch := .F.
//oBmp5:= TBitmap():New(196, 090,063, 018,,"\Imagens\cancelar.png",.T.,oDlg,{|| Processa( {|| U_SMFATF01(cGet1,cGet2,"","E")} ) },,.F.,.F.,,,.F.,,.T.,,.F.)
//oBmp5:lAutoSize := .T.
//oBmp5:lStretch := .F.



ACTIVATE MSDIALOG oDlg CENTERED

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT02                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Tela de configurações dos pagers	                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static function SMFATT02()

//Variaveis Locais
Local oButton1
Local oGet1
Local cGet1 := cValToChar(GETMV("MV_SMPAGVL"))
Local oGet2
Local cGet2 := STR(GETMV("MV_SMPAGTA"),3)
Local oGet3
Local cGet3 := cValToChar(GETMV("MV_SMPAGPT"))
Local oGroup1
Local oRadio
Local oRadio2
Local oRadio3
Local nRadio := GETMV("MV_SMPAG04")
Local nRadio2 := GETMV("MV_SMPAG05")
Local nRadio3 := GETMV("MV_SMPAG06")
Local aItens := {"Alto","Baixo","Vibra/Beepa(1seg)"}
Local aItens2 := {"Constante","1s ON / 1s OFF"}
Local aItens3 := {"Padrão","Ciclos"}
Local oRadio4
Local oRadio5
Local oRadio6
Local nRadio4 := GETMV("MV_SMPAG01")
Local nRadio5 := GETMV("MV_SMPAG02")
Local nRadio6 := GETMV("MV_SMPAG03")
Local aItens4 := {"Sim","Não"}
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Static oDlg2

DEFINE MSDIALOG oDlg2 TITLE "Parâmetros & Configurações" FROM 000, 000  TO 470, 435 COLORS 0, 16777215 PIXEL

@ 125, 004 GROUP oGroup1 TO 220, 215 PROMPT "Configurações" OF oDlg2 COLOR 0, 16777215 PIXEL
@ 135, 015 SAY oSay1 PROMPT "- Beep" SIZE 031, 008 OF oDlg2 COLORS 0, 16777215 PIXEL
oRadio:=TRadMenu():Create(oDlg2,{|u| IIF (PCount()==0,nRadio,nRadio := u)},145,017,aItens,,{|| PUTMV("MV_SMPAG04",nRadio)},,,,,,110,025,,,,.T.)
@ 175, 015 SAY oSay2 PROMPT "- Vibração" SIZE 044, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
oRadio2:=TRadMenu():Create(oDlg2,{|u| IIF (PCount()==0,nRadio2,nRadio2 := u)},185,017,aItens2,,{|| PUTMV("MV_SMPAG05",nRadio2)},,,,,,092,020,,,,.T.)
//  @ 117, 015 SAY oSay3 PROMPT "- Luzes" SIZE 025, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
// oRadio3:=TRadMenu():Create(oDlg2,{|u| IIF (PCount()==0,nRadio3,nRadio3 := u)},127,017,aItens3,,{|| PUTMV("MV_SMPAG06",nRadio3)},,,,,,092,017,,,,.T.)
//@ 035, 140 SAY oSay4 PROMPT "Volume (0-5)" SIZE 051, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
//oGet1:=TGet():Create(oDlg2,{|u| If(PCount() > 0, cGet1 := u, cGet1)},045,140,060,010,"9",,0,,,.F.,,.T.,,.F.,,.F.,.F.,{|| IIF (VAL(cGet1)>5,PUTMV("MV_SMPAGVL",5),PUTMV("MV_SMPAGVL",VAL(cGet1)))},.F.,.F.,,cGet1,,,, )
@ 140, 140 SAY oSay5 PROMPT "Porta COM" SIZE 044, 007 OF oDlg2 COLORS 0, 167775215 PIXEL
oGet2:=TGet():Create(oDlg2,{|u| If(PCount() > 0, cGet2 := u, TRIM(cGet2))},180,140,060,010,"999",,0,,,.F.,,.T.,,.F.,,.F.,.F.,{|| PUTMV("MV_SMPAGTA",VAL(cGet2))},.F.,.F.,,cGet2,,,, )
@ 222, 004 BUTTON oButton1 PROMPT "OK" SIZE 210, 013 OF oDlg2 ACTION (oDlg2:end()) PIXEL
@ 170, 140 SAY oSay6 PROMPT "Tempo de Alerta(em seg)" SIZE 074, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
oGet3:=TGet():Create(oDlg2,{|u| If(PCount() > 0, cGet3 := u, cGet3)},150,140,060,010,"9",,0,,,.F.,,.T.,,.F.,,.F.,.F.,{|| PUTMV("MV_SMPAGPT",VAL(cGet3))},.F.,.F.,,cGet3,,,, )

@ 005, 004 GROUP oGroup1 TO 125, 215 PROMPT "Parâmetros" OF oDlg2 COLOR 0, 16777215 PIXEL
@ 020, 015 SAY oSay7 PROMPT "Alerta de beep?" SIZE 046, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
oRadio4:=TRadMenu():Create(oDlg2,{|u| IIF (PCount()==0,nRadio4,nRadio4 := u)},030,017,aItens4,,{|| PUTMV("MV_SMPAG01",nRadio4)},,,,,,092,018,,,,.T.)
@ 050, 015 SAY oSay8 PROMPT "Alerta luminoso?" SIZE 046, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
oRadio5:=TRadMenu():Create(oDlg2,{|u| IIF (PCount()==0,nRadio5,nRadio5 := u)},060,017,aItens4,,{|| PUTMV("MV_SMPAG02",nRadio5)},,,,,,092,018,,,,.T.)
@ 080, 015 SAY oSay9 PROMPT "Alerta de vibração?" SIZE 062, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
oRadio6:=TRadMenu():Create(oDlg2,{|u| IIF (PCount()==0,nRadio6,nRadio6 := u)},90,017,aItens4,,{|| PUTMV("MV_SMPAG03",nRadio6)},,,,,,092,018,,,,.T.)
ACTIVATE MSDIALOG oDlg2 CENTERED

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF01                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Função de gravação das mensagens na tabela ZZL             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function SMFATF01(p_cInicial, p_cFinal, p_cMensagem, p_cOpcao)

local warea:= getArea()
local nPagIni:= iif(!empty(p_cInicial),val(p_cInicial),0)
local nPagFin:=iif(!empty(p_cFinal),val(p_cFinal),0)
local ntamPager:= TAMSX3("ZZL_PAGER")[1]
local nMaxQtd := GETNEWPAR("MV_SMPAGMQ",03)

Alert("Rotina desativada. Contate o administrador!")
return .f.

if npagini+npagfin == 0 .or. empty(p_cMensagem)
	Alert("Não é possivel mandar mensagem vazia ou para nenhum pager!")
	return .f.
endif

// faz tratamento para conectar em outro banco/servidor
//#######################################################
nCon1:=-1
nCon1:= u_smConect(nCon1)
if nCon1<0 ;return ; endif
//TCSetConn(nCon1)

dbSelectArea("ZZL")
dbSetOrder(1)
lAchou:=.t.
for i:=  nPagIni to nPagFin
	lAchou := dbSeek(xFilial("ZZL")+ iif(i<10,strzero(i,2),cValtoChar(i))  ) // busca pelo pager
	RecLock("ZZL",iif(lAchou,.F.,.T.))
	ZZL->ZZL_FILIAL := xFilial('ZZL')
	ZZL->ZZL_PAGER  := iif(i<10,strzero(i,2),cValtoChar(i))   //strzero(i, ntamPager)
	ZZL->ZZL_TEXTO  := iif(p_cOpcao="E","CANCELADO",p_cMensagem)
	ZZL->ZZL_QTENVI := iif(p_cOpcao="E",nMaxQtd-1,0)
	ZZL->ZZL_DATA   := date()
	ZZL->ZZL_HORA   := time()
	ZZL->(MsUnLock())
next

//finaliza conexao ao banco sigex
//###############################
u_smConect(nCon1)

restArea(warea)

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF02                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Função de cancelamento da mensagem enviada ao pager        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function SMFATF02(nIni,nFim)

Local nCnt
Local i
Local nMax
Local cEnv := ""
Local nHdll
Local xPort := "COM"+cValtoChar(GETMV("MV_SMPAGPT"))+":9600,N,8,1"


Alert('SMFATF02 - Rotina desativada. Contate o administrador!')
return .t.

nMax := (nFim - nIni)+1
ProcRegua(nMax)

for nCnt := nIni to nFim
	lRet := MsOpenPort(@nHdll,xPort)
	if lRet
		IncProc("Cancelando mensagem ao Pager #"+cValtoChar(nCnt))
		cEnv := "PAGE,"+cValtoChar(nCnt)+",0,\fC54"
		for i := 1 to LEN(cEnv)
			MsWrite(nHdll,SUBSTR(cEnv,i,1))
		next
		MsWrite(nHdll,CHR(13))
		Sleep(3000)
		MsClosePort(nHdll)
	endif
next

return


User function PXH05105(p_cOC,p_cPlaca, p_lcancelPeso)

local warea          := getArea()
local lautom         :=.T.
local _cOC           := p_cOC
local _cPlaca        := p_cPlaca
local lcancelPeso    := iif( p_lcancelPeso==nil, .f., p_lcancelPeso )
local nMaxQtd        := GETMV("MV_SMPAGMQ")
local cBusca
Local lTrava

aAreaATU := GetArea()
aAreaSZE := SZE->(GetArea())

dbSelectArea("SZE")

cQuery := ""
cQuery := "SELECT TOP 6 * FROM " + RetSqlName("SZE") + " "
cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' AND   ZE_FATUR <> 'S'"
if _cOC==nil
	cQuery += " AND ZE_PAGER <> '' "
	cQuery += " AND ZE_STATUS2 IN ('1','2','3','4','5','6','7','8','9')  "
else
	cQuery += " AND ZE_OC = '"+_cOC+"'"
	cQuery += " AND ZE_PLACA = '"+_cPlaca+"'"
endif
cQuery += " AND ZE_DATA >= '"+DTOS(dDataBase-1)+"'"
cQuery += " ORDER BY ZE_DATA,ZE_HORAATU DESC"

if select('sZE_pro')>0
	sZE_pro->(dbCloseArea())
endif

dbUseArea(.F., "TOPCONN", TCGenQry(,,cQuery), "SZE_PRO", .F., .T.)
DbSelectArea("SZE_PRO")
sZE_pro->(DbGotop())

_cTexto:=''
aTbPager:=FWGETSX5("PG")

while !sZE_pro->(eof())
	
	cBusca     := SZE_PRO->ZE_PALLET + SZE_PRO->ZE_LOCCARR + SZE_PRO->ZE_STATUS2     //monta a composição da chave na sx5
	nposStatus := aScan(  aTbPager    ,    { |x|  AllTrim( x[3] )  ==  cBusca  })   //procura se existe a chave na sx5
	
	_cTexto:= iif( nposStatus==0, 'SEM MENSAGEM NA TABELA-PG' , aTbPager[nposStatus, 4] )   //caso ache o registro, armazena a mensagem
	
	if sZE_pro->ZE_status2 $ '1' .and. _cOC == nil
		_cTexto:=''
	endif
	
	if lcancelPeso
		_cTexto  := "CANCELAR PROSSEGUIR"
	endif
	
	if empty(_cTexto)
		sZE_pro->(dbskip())
		loop
	endif
	
	dbSelectArea("ZZL")
	dbSetOrder(1)
	
	lAchou:= dbSeek(xFilial("ZZL")+ sZE_pro->ZE_pager  ) // busca pelo pager
	lGrava:= !lAchou .or. !(alltrim(_cTexto) $ alltrim(zzl->zzl_texto) )  // significa que nao mudou de status, logo nao precisa gravar a mesma mensagem
	if lgrava
		lTrava := RecLock("ZZL", iif(lAchou,.f.,.t.))
		while !lTrava
			lTrava := RecLock("ZZL", iif(lAchou,.f.,.t.))
		end
		ZZL->ZZL_FILIAL := xFilial()
		ZZL->ZZL_PAGER  := sZE_pro->ZE_pager
		ZZL->ZZL_PLACA  := sZE_pro->ZE_placa
		ZZL->ZZL_NOME   := Substr( sZE_pro->ZE_nommot ,1,20)
		ZZL->ZZL_TEXTO  := _cTexto
		ZZL->ZZL_QTENVI := 0
		ZZL->ZZL_DATA   := date()
		ZZL->ZZL_HORA   := sZE_pro->ZE_horaatu
		ZZL->(MsUnLock())
	Endif
	
	dbselectArea('sZE_pro')
	sZE_pro->(dbskip())
EndDo

dbSelectArea("SZE")

RestArea(aAreaSZE)
RestArea(aAreaATU)

caux:= "fim atualizacao banco SIGEX ..."
iif( !lautom , Alert(caux) , conout( caux )	)

restArea(warea)

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF73                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Função de transmissão das mensagens para os pagers         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function SMFATF73()

local warea:= getArea()
local aArray := {}
//local nMaxQtd := GETNEWPAR("MV_SMPAGMQ",03)
local nMaxQtd := 3
Local nHdll
//Local xPort := "COM"+cValtoChar(GETMV("MV_SMPAGPT"))+":9600,N,8,1"
Local xPort := "COM8:9600,N,8,1"
Local cForm := "\f"
Local cFormCanc   := "\fC54"
Local lBeepa      := iif(GETMV("MV_SMPAG01")=1,.t.,.f.)
Local lPisca      := iif(GETMV("MV_SMPAG02")=1,.t.,.f.)
Local lVibra      := iif(GETMV("MV_SMPAG03")=1,.t.,.f.)
Local nTipoBeep   := GETMV("MV_SMPAG04")
Local nTipoVibra  := GETMV("MV_SMPAG05")
Local nTempoAlert := GETMV("MV_SMPAGTA")

//Conecta ao banco SIGEX
//######################
nCon1:=-1
nCon1 := u_smConect(nCon1)
if nCon1 < 0 ; return ; endif
//if u_smConect(@nCon1)<0 ;return ; endif
//TCSetConn(nCon1)

//Monta e executa a QUERY populando o aArray com o retorno
//########################################################
cSQL := "SELECT ZZL_PAGER,ZZL_TEXTO,ZZL_QTENVI FROM "+RetSqlName("ZZL")+" ZZL "
cSQL += "WHERE ZZL_QTENVI < '"+cValtoChar(nMaxQtd)+"' AND ZZL.D_E_L_E_T_= ' ' AND ZZL_FILIAL = '" + xFilial("SZE") + "'"

TCQUERY cSQL New Alias "BMP"
dbSelectArea('BMP')
BMP->(DbGoTop())
While BMP->(!EOF())
	AAdd(aArray,{BMP->ZZL_PAGER,BMP->ZZL_TEXTO,BMP->ZZL_QTENVI})
	BMP->(DbSkip())
end
BMP->(DbCloseArea())
RestArea(warea)

//finaliza conexao ao banco sigex
//###############################
//u_smConect(@nCon1)

//Monta o cForm de acordo com os parametros escolhidos
//####################################################
if lBeepa
	DO CASE
		CASE nTipoBeep = 1
			cForm += "b0"
		CASE nTipoBeep = 2
			cForm += "b1"
		CASE nTipoBeep = 3
			cForm += "b2"
	ENDCASE
	cForm += "B"
endif
if lPisca
	cForm += "F"
endif
if lVibra
	DO CASE
		CASE nTipoVibra = 1
			cForm += "v0"
		CASE nTipoVibra = 2
			cForm += "v6"
	ENDCASE
	cForm += "V"
endif
cForm += cValtoChar(nTempoAlert)

//Validação do aArray e envio das mensagens
//#########################################
if LEN(aArray) = 0
	u_smConect(nCon1)
	return
endif

for i := 1 to LEN(aArray)
	if !lAtivo; exit; endif
	lRet := MsOpenPort(@nHdll,xPort)
	if lRet
		oBitmap1:Load(,"\Imagens\pager2.png")
		cAux1:= "Enviando mensagem ao Pager #"+cValtoChar(aArray[i][1]) +' - '+ALLTRIM(aArray[i][2])
		LjMsgRun(cAux1)
		conout( cAux1 )
		cEnv := "PAGE,"+ALLTRIM(cValtoChar(aArray[i][1]))+",0,"+iif(ALLTRIM(aArray[i][2])="CANCELADO",cFormCanc,ALLTRIM(aArray[i][2])+cForm)
		for a := 1 to LEN(cEnv)
			MsWrite(nHdll,SUBSTR(cEnv,a,1))
		next
		MsWrite(nHdll,CHR(13))
		oBitmap1:Load(,"\Imagens\pager3.png")
		dbselectarea("ZZL")
		dbsetorder(1)
		if dbseek(xFilial("ZZL")+aArray[i][1])
			reclock("ZZL",.F.)
			ZZL->ZZL_QTENVI += 1
			ZZL->(MsUnLock())
		endif
		ZZL->(DbCloseArea())
		Sleep(3000)
		MsClosePort(nHdll)
	endif
next i
u_smConect(nCon1)
RestArea(warea)


return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT28                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Tela com timer para chamar a função SMFATF73() - temporaria³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function SMFATT28()

private oBitmap1
private lAtivo:=.t.


DEFINE MSDIALOG oDlg TITLE "SIGEX - SISTEMA INTEGRADO DE GESTÃO DE EXPEDIÇÃO" FROM 000, 000  TO 480, 480 COLORS 0, 16777215 PIXEL

nMilissegundos := 5000 // Disparo será de 5 em 5 segundos
oTimer := TTimer():New(nMilissegundos, {||;
U_LERMSGS(),; //Chama a função de envio
}, oDlg )

@ 003, 004 BITMAP oBitmap1 SIZE 254, 239 OF oDlg FILENAME "\Imagens\pager3.png" NOBORDER PIXEL
oBitmap1:lAutoSize := .T.
oBmp3:= TBitmap():New(121, 090,063, 018,,"\Imagens\enviar.png",.T.,oDlg,{||},,.F.,.F.,,,.F.,,.T.,,.F.)
oBmp3:lAutoSize := .T.
oBmp3:lStretch := .F.
oBmp4:= TBitmap():New(143, 090,063, 018,,"\Imagens\limpar.png",.T.,oDlg,{||},,.F.,.F.,,,.F.,,.T.,,.F.)
oBmp4:lAutoSize := .T.
oBmp4:lStretch := .F.
oBmp5:= TBitmap():New(166, 090,063, 018,,"\Imagens\cancelar.png",.T.,oDlg,{||  lativo:= .f.   },,.F.,.F.,,,.F.,,.T.,,.F.)
oBmp5:lAutoSize := .T.
oBmp5:lStretch := .F.

oTimer:Activate()   //Ativa o Timer

ACTIVATE MSDIALOG oDlg CENTERED


return


User function SMFATF78()

Local wArea := GetArea()
Local nCon1  := -1

if !MsgYesNo("Deseja limpar as mensagens do banco?","ATENÇÃO")
	return
endif

/*
nCon1 := u_smConect(nCon1)
if nCon1 < 0
Alert("Não foi possivel se conectar ao banco sigex!")
return
endif
*/

DBSelectArea("ZZL")
DBGoTop()
ProcRegua(ZZL->(RecCount()))

While ZZL->(!EOF())
	IncProc("Limpando mensagem do pager ["+ZZL_PAGER+"]")
	if ZZL->ZZL_QTENVI < 3
		reclock("ZZL",.F.)
		ZZL->ZZL_QTENVI := 3
		ZZL->(MsUnLock())
	endif
	ZZL->(DBSkip())
end

ZZL->(DBCloseArea())
//u_smConect(nCon1)
RestArea(wArea)

return