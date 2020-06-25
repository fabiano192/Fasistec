#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE 	_wEnter_	chr(13)+chr(10)

#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PXH043   ³ Autor ³ Alexandro da Silva           ³ 21/03/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monitor do Trafego de Carga e Descarga     				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PXH043()

/*
PXH043  - MIZ999    - OK
PXH044  - MIZ997    - OK
PXH045  - MIZ996
PXH046  - MIZ050GR
PXH047  - MIZ992
PXH048  - frmfiltpv - OK
PXH049  - MIZ050GR

MATA410 - Miz016          -- PEDIDO DE VENDA
OMSA040 - Miz010          -- CADASTRO DE MOTORISTA
OMSA060 - Miz005/Miz1030  -- CADASTRO DE VEICULOS (CAMINHA / CARRETA)

SZ1-SZF - PEDIDO DE VENDA AUXILIAR
SZ2-DA3 - VEICULOS     PLACA ---> INDICE 03
SZ3-DA4 - MOTORISTA    CODIGO --> INDICE 01
SZG-SZG - TABELA DE PRECO FRETE

Z3_SENHMOT : DA4_SYENMO
SZ8-SZE - AGENCIAMENTO

ZE_PLACA-C07 --> ALTERADO PARA C-08
ZE_PLCAR-C07 --> ALTERADO PARA C-08

ZZL-ZZL

LINHA 1619 --> PXH045, COMECAR A ALTERAR PXH050

*/


Private nMVC       := SuperGetMv("PXH_VECA",,100) //SuperGetMv("MV_MAXVECA",,100)
Private nMVD       := SuperGetMv("PXH_VEDE",,100) //SuperGetMv("MV_MAXVEDE",,100)
Private nMVP       := SuperGetMv("PXH_VEPA",,100) //SuperGetMv("MV_MAXVEPA",,100)
Private nVC        := 0
Private nVD        := 0
Private nVP        := 0
Private wNumOC     := ""
PRIVATE bFiltraBrw := {|| .t. }
PRIVATE aFilBrw    := {}

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

Private	TABCARGP    := ""
Private TABDESCP    := ""
private cperg       := 'MZ999TEL1'
private lUsaDescSaco:= .t.
private lUsaCarrSaco:= .f.
private oFolder1

Private luserFull := .f.

lUserFull := U_PXH042("PXH043",6,.F.)

setSX1(cperg)

oAmarelo    := LoadBitmap(GetResources(),'BR_AMARELO')
oVerde 		:= LoadBitmap(GetResources(),'BR_VERDE')
oPink 		:= LoadBitmap(GetResources(),'BR_PINK')
oVermelho 	:= LoadBitmap(GetResources(),'BR_VERMELHO')
oAzul 		:= LoadBitmap(GetResources(),'BR_AZUL')
oCinza 		:= LoadBitmap(GetResources(),'BR_PRETO')
oBranco		:= LoadBitmap(GetResources(),'BR_BRANCO')

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont1     := TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Verdana",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 080,092,680,1280,"Controle do Tráfego de Carga e Descarga",,,.F.,,,,,,.T.,,,.T. )

nTimeOut := getnewPar('MV_TIME999',30000)  // 1minuto - tempo em milesegundos
oTimer001:= ""
oTimer001:= TTimer():New(nTimeOut,{ || fAtuStatus(0) },oDlg1)
oTimer001:Activate()

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
	oSay14     := TSay():New( 001,250,{||"Pátio"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,059,010)
	oBmp10     := TBitmap():New( 121,005,530,013,,"\images\verde.png",.T.,oFolder1:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oSay16     := TSay():New( 123,250,{||"Fábrica"},oFolder1:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,069,009)
endif

oGrp1      := TGroup():New( 245,006,285,270,"Legendas",oFolder1:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
oBmp3      := TBitmap():New( 257,010,008,008,,"\images\leg_amarelo.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay2      := TSay():New( 258,021,{||"1-Pátio"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay3      := TSay():New( 258,110,{||"2-Chamado"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay4      := TSay():New( 258,190,{||"3-Pesado na Entrada"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay5      := TSay():New( 271,021,{||"4-Início Carga/Descarga"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay6      := TSay():New( 271,110,{||"5-Aguardar Liberacao"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay7      := TSay():New( 271,190,{||"6-Em Espera"},oGrp1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)

oBmp2      := TBitmap():New( 257,100,008,008,,"\images\leg_verde.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp4      := TBitmap():New( 257,179,008,008,,"\images\leg_rosa.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp5      := TBitmap():New( 270,010,008,008,,"\images\leg_azul.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp6      := TBitmap():New( 270,100,008,008,,"\images\leg_preto.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp7      := TBitmap():New( 270,179,008,008,,"\images\leg_vermelho.png",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )

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
oBmp3d      := TBitmap():New( 257,010,008,008,,"\images\leg_amarelo.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oSay2d      := TSay():New( 258,021,{||"1-Pátio"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay3d      := TSay():New( 258,110,{||"2-Chamado"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay4d      := TSay():New( 258,190,{||"3-Pesado na Entrada"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay5d      := TSay():New( 271,021,{||"4-Início Carga/Descarga"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay6d      := TSay():New( 271,110,{||"5-Aguardar Liberação"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oSay7d      := TSay():New( 271,190,{||"6-Em Espera"},oGrp1d,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,074,008)
oBmp2d      := TBitmap():New( 257,100,008,008,,"\images\leg_verde.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp4d      := TBitmap():New( 257,179,008,008,,"\images\leg_rosa.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp5d      := TBitmap():New( 270,010,008,008,,"\images\leg_azul.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp6d      := TBitmap():New( 270,100,008,008,,"\images\leg_preto.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
oBmp7d      := TBitmap():New( 270,179,008,008,,"\images\leg_vermelho.png",.T.,oGrp1d,,,.F.,.T.,,"",.T.,,.T.,,.F. )
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
fHeaders()

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
fAtuStatus(0)
//fConsulta()

if luserFull
	if lusaCarrSaco
		oBrw1:blDBLClick:= {|| fCarregar(@oBrw1) }
		oBrw1:BSEEKCHANGE:= {|| setOC(@oBrw1 ) }
		
		oBrw3:blDBLClick:= {|| fCarregar(@oBrw3) }
		oBrw3:BSEEKCHANGE:= {|| setOC(@oBrw3 ) }
	endif
	
	oBrw2:blDBLClick:= {|| fCarregar(@oBrw2) }
	oBrw2:BSEEKCHANGE:= {|| setOC(@oBrw2 ) }
	
	oBrw4:blDBLClick:= {|| fCarregar(@oBrw4) }
	oBrw4:BSEEKCHANGE:= {|| setOC(@oBrw4 ) }
	
	if lusaDescSaco
		oBrw5:blDBLClick:= {|| fCarregar(@oBrw5) }
		oBrw5:BSEEKCHANGE:= {|| setOC(@oBrw5 ) }
		
		oBrw7:blDBLClick:= {|| fCarregar(@oBrw7) }
		oBrw7:BSEEKCHANGE:= {|| setOC(@oBrw7 ) }
	endif
	
	oBrw6:blDBLClick:= {|| fCarregar(@oBrw6) }
	oBrw6:BSEEKCHANGE:= {|| setOC(@oBrw6 ) }
	
	oBrw8:blDBLClick:= {|| fCarregar(@oBrw8) }
	oBrw8:BSEEKCHANGE:= {|| setOC(@oBrw8 ) }
	
endif


//botoes laterais

naltura:=009
nnLin:= 015
nEspaco:=10

oSayNf      := TSay():New( nnLin ,545,{||"Nota Fiscal"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
oBt_nfe      := TButton():New( nnLin+=nEspaco ,542,"NF-e Sefaz",oDlg1	, {||  chamadaBtns('NFE')    }  ,050,naltura,,,,.T.,,"",,,,.F. )
oBt_Mnt      := TButton():New( nnLin+=nEspaco ,542,"Monitor",oDlg1		, {||  u_mzNfetransm('MNT')    } ,050,naltura,,,,.T.,,"",,,,.F. )
oBt_Dan      := TButton():New( nnLin+=nEspaco ,542,"Danfe",oDlg1		, {||  u_mzNfetransm('DAN')    } ,050,naltura,,,,.T.,,"",,,,.F. )
oBt_Sta      := TButton():New( nnLin+=nEspaco ,542,"Status Sefaz",oDlg1		, {||  u_mzNfetransm('STA')    } ,050,naltura,,,,.t.,,"",,,,.f. )
oBt_Rem      := TButton():New( nnLin+=nEspaco ,542,"Transmisão",oDlg1		, {||   u_mzNfetransm('REM')    } ,050,naltura,,,,.t.,,"",,,,.f. )

nnLin+=30

oSayVda      := TSay():New( nnLin+=nEspaco  ,545,{||"Pedido"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
oBt_Ped      := TButton():New( nnLin+=nEspaco ,542,"Pedido" , oDlg1		, {||  chamadaBtns('PED')   } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Age      := TButton():New( nnLin+=nEspaco ,542,"Agenciamento" , oDlg1		, {||  chamadaBtns('AGE')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_IOC      := TButton():New( nnLin+=nEspaco ,542,"Imp.Ord.Carreg" , oDlg1		, {||  chamadaBtns('IOC')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_CEN      := TButton():New( nnLin+=nEspaco ,542,"Cancela Entrada" , oDlg1		, {||  chamadaBtns('CEN')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )


nnLin+=30

oSayVda      := TSay():New( nnLin+=nEspaco  ,545,{||"Cadastro"},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
oBt_Cli      := TButton():New( nnLin+=nEspaco ,542,"Cliente" , oDlg1		, {||  chamadaBtns('CLI')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Mot      := TButton():New( nnLin+=nEspaco ,542,"Motorista" , oDlg1		, {||  chamadaBtns('MOT')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Tra      := TButton():New( nnLin+=nEspaco ,542,"Transportador" , oDlg1		, {||  chamadaBtns('TRA')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Cam      := TButton():New( nnLin+=nEspaco ,542,"Caminhão" , oDlg1		, {||  chamadaBtns('CAM')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )
oBt_Car      := TButton():New( nnLin+=nEspaco ,542,"Carreta" , oDlg1		, {||  chamadaBtns('CAR')    } ,050,naltura,,          ,,.T.,,"",,,,.F. )

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

Set Key VK_F5 TO fAtuStatus()

oDlg1:Activate(,,,.T.)

Set Key VK_F5 TO


Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que "Monta aHeader" e "Monta Area de Trabalho"                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fHeaders()

DbSelectArea("SX3")
DbSetOrder(2) // Nome Campo

dbSeek("ZE_STATUS");    aAdd(waHeader, " ") 			 ; aAdd(waColSizes,1)
dbSeek("ZE_HRAGENC"); 	aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
dbSeek("ZE_HORPES");	aAdd(waHeader, "Hr.P.Ent")		 ; aAdd(waColSizes,20)
dbSeek("ZE_PLACA");	    aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
dbSeek("ZE_MOTOR");	    aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,100)
dbSeek("ZE_PSENT");	    aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,30)
dbSeek("ZE_OC");	    aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,20)
dbSeek("ZE_PALLET");    aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
dbSeek("ZE_FRETE");     aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
dbSeek("ZE_CILINDR");   aAdd(waHeader, Trim(X3Titulo())) ; aAdd(waColSizes,1)
dbSeek("ZE_PAGER");	    aAdd(waHeader, "Pager")			 ; aAdd(waColSizes,20)


Return


Static Function fConsulta()

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

cC5Frete:= ''

cColuna03:=''
ccampo03:=''
cColuna11:=''
ccampo11:=''


cSQL := "SELECT ZE_STATUS, ZE_HRAGENC, ZE_PAGER, ZE_PLACA, ZE_NOMMOT, ZE_PSENT, ZE_OC, "
cSQL += " ZE_TPOPER, ZE_SACGRA , ZE_IHM, ZE_PALLET, ZE_CILINDR, LEFT(ZE_CATEGMP,2) AS ZE_CATEGMP, ZE_HORPES "
cSQL += " FROM "+RetSqlName("SZE") +" SZE "
cSQL += " WHERE ZE_DATA   <= '" +DTOS(dDataBase)+ "'"
cSQL += " AND   ZE_STATUS <= '6'"
cSQL += " AND   ZE_FATUR <> 'S'" // NAO FATURADOS
cSQL += " AND   SZE.D_E_L_E_T_= ' ' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
cSQL += " ORDER BY ZE_DATA, ZE_HORA "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), "SZE001", .F., .T.)

cColuna03:=SZE001->ZE_HORPES
ccampo03 := 'ZE_HORPES'

cColuna11:=SZE001->ZE_PAGER
ccampo11 := 'ZE_PAGER'

DbSelectArea("SZE001")

While SZE001->(!EOF())
	
	aListAux := {}
	
	cC5Frete := ""
	
	SC5->(dbOrderNickName("INDSC51"))
	If SC5->(dbSeek(xFilial("SC5")+SZE001->ZE_OC))
		cC5Frete := SC5->C5_TPFRETE
	Endif
	
	cCilindro:= iif( SZE001->ZE_CILINDR=='1', 'S','N')
	
	cColuna03:= ''
	ccampo03 := ''
	
	cColuna11:= ''
	ccampo11 := ''
	
	cColuna03:= SZE001->ZE_HORPES
	ccampo03 := 'ZE_HORPES'
	
	cColuna11:= SZE001->ZE_PAGER
	ccampo11 := 'ZE_PAGER'
	
	// ** //
	// CARREGAMENTO PATIO SACO
	if lusaCarrSaco
		If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS $ '1/2' .AND. SZE001->ZE_SACGRA = 'S'
			aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
			aAdd(aList1, aListAux)
			nVP++
		EndIf
		
		
	endif
	
	// CARREGAMENTO PATIO GRANEL
	If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS $ '1/2' .AND. SZE001->ZE_SACGRA = 'G'
		aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
		aAdd(aList2, aListAux)
		nVP++
	EndIf
	
	// CARREGAMENTO FABRICA SACO
	if lusaCarrSaco
		If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS > '2' .AND. SZE001->ZE_SACGRA = 'S'
			aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
			aAdd(aList3, aListAux)
			nVC++
		EndIf
	endif
	
	// CARREGAMENTO FABRICA GRANEL
	If SZE001->ZE_TPOPER = 'C' .AND. SZE001->ZE_STATUS > '2' .AND. SZE001->ZE_SACGRA = 'G'
		aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
		aAdd(aList4, aListAux)
		nVC++
	EndIf
	
	// ** DESCACARREGAMENTO ** //
	// DESCARREGAMENTO PATIO SACO
	if lUsaDescSaco
		If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS $ '1/2' .AND. ( SZE001->ZE_SACGRA = 'G' .AND. SZE001->ZE_CATEGMP =='CP' )
			aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
			aAdd(aList5, aListAux)
			nVP++
		EndIf
	endif
	
	// DESCARREGAMENTO PATIO GRANEL
	If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS $ '1/2' .AND. ( SZE001->ZE_SACGRA = 'G'  .AND. SZE001->ZE_CATEGMP =='EM' )
		aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
		aAdd(aList6, aListAux)
		nVP++
	EndIf
	
	// DESCARREGAMENTO FABRICA SACO
	if lUsaDescSaco
		If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS > '2' .AND.  ( SZE001->ZE_SACGRA = 'G' .AND. SZE001->ZE_CATEGMP =='CP' )
			aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
			aAdd(aList7, aListAux)
			nVD++
		EndIf
	endif
	
	// DESCARREGAMENTO FABRICA GRANEL
	If SZE001->ZE_TPOPER = 'D' .AND. SZE001->ZE_STATUS > '2' .AND.  ( SZE001->ZE_SACGRA = 'G'  .AND. SZE001->ZE_CATEGMP =='EM' )
		aListAux := {SZE001->ZE_STATUS,SZE001->ZE_HRAGENC,cColuna03,SZE001->ZE_PLACA,SUBSTR(SZE001->ZE_NOMMOT,1,30),SZE001->ZE_PSENT, SZE001->ZE_OC, SZE001->ZE_PALLET, cC5Frete, cCilindro, cColuna11}
		aAdd(aList8, aListAux)
		nVD++
	EndIf
	
	
	SZE001->(DbSkip())
End
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

//Variavel auxiliar para determinar a condicao das cores na primeira coluna do browse

cCond5:=" oBrw4:aArray[oBrw4:nAt,01]='3' .and.  oBrw4:aArray[oBrw4:nAt,06]=0 .and. !empty( posicione('SZE',1,xfilial('SZE')+oBrw4:aArray[oBrw4:nAt,07],'ZE_IHM') )  "


cCores1 :=	"If(oBrw1:aArray[oBrw1:nAt,01]=' ',oBranco,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='1',oAmarelo,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='2',oVerde,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='3',oPink,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='4',oAzul,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='5',oCinza,"+;
"If(oBrw1:aArray[oBrw1:nAt,01]='6',oVermelho,'')))))))"

cCores2 :=	"If(oBrw2:aArray[oBrw2:nAt,01]=' ',oBranco,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='1',oAmarelo,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='2',oVerde,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='3',oPink,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='4',oAzul,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='5',oCinza,"+;
"If(oBrw2:aArray[oBrw2:nAt,01]='6',oVermelho,'')))))))"

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
"If("+cCond5+",oCinza,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='3',oPink,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='4',oAzul,"+;
"If(oBrw4:aArray[oBrw4:nAt,01]='6',oVermelho,'')))))))"

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


Static Function fCarregar(oBrwAux)

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
dbSeek(xFilial("SZE")+oBrwAux:aArray[oBrwAux:nAT,7]) //Posiciona na OC para faturar

lCarrGranel:= (SZE->ZE_sacgra=='G') .AND. (SZE->ZE_tpoper=='C')

lSemPeso:= lCarrGranel .and. (oBrwAux:aArray[oBrwAux:nAT,1] == "2")  .and. cEmpAnt $ '20'

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oSay1","oSay2","oSay3","oBtGranel","oBtn2","oBtn3","oGet1","oGet2","oGet3")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 241,349,383,729,"Operações",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 018,012,{||"Placa"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
oSay2      := TSay():New( 031,012,{||"Motorista"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
oSay3      := TSay():New( 005,012,{||"Hora"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)

If oBrwAux:aArray[oBrwAux:nAT,1] == "1"
	oBtn2  := TButton():New( 050,069,"Chamar no Pager",oDlg2,{|| MsAguarde({|| fChamar(@oBrwAux,1), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
ElseIf oBrwAux:aArray[oBrwAux:nAT,1] == "2"
	oBtn1  := TButton():New( 050,010,"Cancelar Chamar",oDlg2,{|| MsAguarde({|| fChamar(@oBrwAux,2), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
	oBtn2  := TButton():New( 050,069,iif(!lCarrGranel.or.!lSemPeso, "Pesar", "S/ Peso" ),oDlg2,{|| MsAguarde( {|| fPesar(@oBrwAux,lCarrGranel,lSemPeso) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
ElseIf oBrwAux:aArray[oBrwAux:nAT,1] == "6"
	If SZE->ZE_TPOPER == "C"
		oBtn2  := TButton():New( 050,069,"Faturar",oDlg2,{|| fFaturar(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
	ElseIf SZE->ZE_TPOPER == "D"
		
		oBtn1  := TButton():New( 050,010,"Pesar Saída",oDlg2,{|| MsAguarde( {|| fPesarSai(@oBrwAux, lCarrGranel) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
		
		// ESSA É FORMA COMPLETA DO COMANDO. ALTERADO ATÉ DEFINICAO DO USU DA PRE-NOTA
		//oBtn2  := TButton():New( 050,069,"Pré-Nota"   ,oDlg2,{|| MsAguarde( {|| ExecBlock("MIZ993",.F.,.F.,SZE->ZE_OC),oDlg2:End(),fConsulta() },"Pré-Nota...") },055,015,,,,.T.,,"",,,,.F. )
	EndIf
ElseIf oBrwAux:aArray[oBrwAux:nAT,1] $ "3/4"
	if luserFull .and. ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  )
		oBtn1  := TButton():New( 050,010,"Status Sigex",oDlg2,{|| fMudaStat(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
	endif
	
	if  ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  )
		oBtn2  := TButton():New( 050,069,"Cancelar Peso",oDlg2,{|| MsAguarde( {|| fPesar(@oBrwAux,lCarrGranel,lSemPeso,2) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
	elseif lCarrGranel
		oBtn2  := TButton():New( 050,069,"Captura Peso",oDlg2,{|| MsAguarde( {|| fPesar(@oBrwAux,lCarrGranel, lSemPeso) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
	endif
EndIf

oBtn3      := TButton():New( 050,128,"Fechar",oDlg2,{|| oDlg2:End()},055,015,,,,.T.,,"",,,,.F. )
oGet1      := TGet():New( 017,043,{|u| If(PCount()>0,cPlacaCar:=u,cPlacaCar)},oDlg2,033,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPlacaCar",,)
oGet2      := TGet():New( 030,043,{|u| If(PCount()>0,cMotorCar:=u,cMotorCar)},oDlg2,116,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cMotorCar",,)
oGet3      := TGet():New( 004,043,{|u| If(PCount()>0,cHora:=u,cHora)},oDlg2,021,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHora",,)

oDlg2:Activate(,,,.T.)

Return

Static Function fPesar(_oBrwAux,p_lCarrGranel,p_lSemPeso,p_nOpcao)

Local nPesoAux := 0
Local aAreaAtu := GetArea()
local cStatus:= _oBrwAux:aArray[_oBrwAux:nAT,1]
local cOC	 := _oBrwAux:aArray[_oBrwAux:nAT,7]
local cPager := _oBrwAux:aArray[_oBrwAux:nAT,3]
local cpgLacre := 'LACRE02'
local lCancelPeso  := (p_nOpcao==2)

PRIVATE cColeta:="A"  //A-AUTOMATICA   M- MANUAL

valperg(cpgLacre)

dbSelectArea("SZE")
dbSetOrder(1)
dbSeek(xFilial("SZE")+cOC)

lSemPeso:= p_lSemPeso

lpesoOk:=.f.
While  !lpesoOK .and. !lSemPeso .and. !lcancelPeso
	
	nPesoAux :=0
	
	u_frmPesoBal(@nPesoAux,"ENTRADA",@cColeta)
	
	if !( lpesoOK:=( nPesoaux > 0 ) )
		lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
	endif
EndDo

if (nPesoAux==0) .and. !lSemPeso  .and. !lcancelPeso//saco
	Alert('Nao e permitido prosseguir sem peso!')
else
	if p_lCarrGranel   .and. empty(SZE->ZE_lacre)
		
		cLacre:=''
		while empty(cLacre)
			cLacre:= u_frmLacres()
		end
	endif
	
	nPEntAnt:= SZE->ZE_psent // grava o peso antes de altera-lo mais abaixo. para comparar se estava zerado
	
	If dbSeek(xFilial("SZE")+_oBrwAux:aArray[_oBrwAux:nAT,7])
		
		Begin Transaction
		//ROLLBACK TRANSACTION
		
		RecLock("SZE",.F.)
		SZE->ZE_PSENT   := nPesoAux
		SZE->ZE_HORPES  := iif( lcancelPeso, '', Substr(Time(),1,5) )
		SZE->ZE_STATUS  := iif( lcancelPeso, '2' , '3' )
		SZE->ZE_COLEENT := cColeta
		
		
		if p_lCarrGranel .and. empty(SZE->ZE_lacre)
			if !empty( Alltrim(cLacre) )
				SZE->ZE_lacre := Alltrim(cLacre)
			else
				SZE->ZE_lacre := 'Nao informado na entrada'
			endif
			
		endif
		
		SZE->(MsUnLock())
		
		setSC6(SZE->ZE_OC, SZE->ZE_LACRE,SZE->ZE_PSENT)
		setDA3(SZE->ZE_PLACA,SZE->ZE_OC,SZE->ZE_PSENT,SZE->ZE_HORPES,SZE->ZE_DATA,SZE->ZE_MOTOR,"E")
		
		//Grava no BANCO DE DADOS SIGEX
		lzEFound:=.t.
		u_setSigex(lzEFound, cStatus, nPEntAnt, nPesoAux, p_lCarrGranel, cOC, cPager, lcancelPeso)
		
		//Grava no BANCO DE DADOS SIGEX a mensagem na tabela de mensagens
		//****************************************************************
		//p_cTexto  := "FAVOR PROSSEGUIR"
		//p_cStatus :=  "3"
		u_setZZL(_oBrwAux:aArray[_oBrwAux:nAT,7] , _oBrwAux:aArray[_oBrwAux:nAT,4], lcancelPeso)
		
		End Transaction
		
	EndIf
	
endif

// Atualiza os grids
fConsulta()

RestArea(aAreaAtu)

oDlg2:End()

Return


Static Function fPesarSai(_oBrwAux,p_lCarrGranel)

Local nPesoAux := 0
Local aAreaAtu := GetArea()
local cStatus:= _oBrwAux:aArray[_oBrwAux:nAT,1]
private cColeta:= "A"

lpesoOk:=.f.
lyes:=.f.
While  !lpesoOK
	
	nPesoAux := 0
	u_frmPesoBal(@nPesoAux,"SAIDA",@cColeta)
	if !( lpesoOK:=( nPesoAux > 0 ) )
		lpesoOK:= MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
	endif
EndDo

if (nPesoAux==0)
	Alert('Nao e permitido prosseguir sem peso!')
	return
endif

lpesoOK:=.t.
if  SZE->ZE_tpoper == 'D'
	
	nPesLiq:=0
	nPesLiq:= SZE->ZE_psent - nPesoAux
	
	nDifPes:=0
	nDifPes:= SZE->ZE_nfpesen - nPesLiq
	
	if  nDifPes > getnewPar('MV_MXDIFPS',200)
		MsgBox("ATENCAO!   A diferença de Peso é maior que a permitida! ","Peso Errado!!! ", "ALERT")
		lpesoOK:= u_getConfirm()
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
	SZE->(MsUnLock())
	
	setDA3(SZE->ZE_PLACA,,,,,,"S",SZE->ZE_PSSAI,SZE->ZE_HSAIDA)
	
	_cPager:= SZE->ZE_pager
	
	//Grava no BANCO DE DADOS SIGEX a mensagem na tabela de mensagens
	TCConType("TCPIP")
	
	nCon1  := -1
	ltentar:= .t.
	
	TCCONTYPE("NPIPE")
	nCon1  := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
	
	while nCon1 <0 .and. ltentar
		nCon1  := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
		ltentar:= !MsgBox("Falha durante a tentativa de conectar-se ao banco de dados SIGEX. Tentar mais uma vez ?","Acesso SIGEX", "YESNO")
	end
	
	If nCon1 > 0
		cQuery := ""
		cQuery := " UPDATE "+RetSqlName("SZE")
		cQuery += " SET ZE_PSSAI = "+str(nPesoAux)
		cQuery += " ,ZE_DTSAIDA = '"+DTOS(dDataBase)+"'"
		cQuery += " ,ZE_HSAIDA = '"+ Substr(Time(),1,5) +"'"
		cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
		cQuery += " AND ZE_OC =  '"  +SZE->ZE_OC+ "'"
		
		TcSqlExec(cQuery)
		
		dbSelectArea("ZZL")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZL")+ _cPager ) // busca pelo pager
			RecLock("ZZL",.F.)
			zzl->(dbDelete())
			zzl->(msUnlock())
		endif
		
		TCUnLink(nCon1)
		TCSetConn(0)
		
		dbSelectArea("SZE")
		
		RecLock("SZE",.F.)
		SZE->ZE_STATUS  := '6'
		SZE->ZE_FATUR   := 'S'
		SZE->ZE_PAGER   := ''
		SZE->(MsUnLock())
		
	EndIf
	
	dbSelectArea("SZE")
	
	//imprime tickt de balança
	u_RTICKET(SZE->ZE_oc)
	
EndIf

// Atualiza os grids
fConsulta()

RestArea(aAreaAtu)

oDlg2:End()

Return


Static Function fChamar(_oBrwAux,p_nOpcao)

Local aAreaAtu  := GetArea()
Local cStAux	:= ""

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
	
	If ( p_nOpcao == 1 .and. SZE->ZE_STATUS <> '1' ) .or. ( p_nOpcao == 2 .and. SZE->ZE_STATUS <> '2' )
		MsgInfo("Houve alteração do status desse registro, possivelmente por outro usuário. O sistema irá atualizar a tela. Verifique!")
		fConsulta()
		
		RestArea(aAreaAtu)
		//Return(.f.)
	EndIf
	
	u_setZZL(_oBrwAux:aArray[_oBrwAux:nAT,7] , _oBrwAux:aArray[_oBrwAux:nAT,4])
	
	If SZE->ZE_STATUS <'3'
		SZE->(RecLock("SZE",.F.))
		SZE->ZE_STATUS := iif(p_nOpcao==1, "2", "1" )
		SZE->(MsUnLock())
	Endif
EndIf

fConsulta()

RestArea(aAreaAtu)

Return

Static Function fAtuStatus(p_nOpc)

Local cTipo := if(oFolder1:nOption=1,"C","D")

U_PXH044(,cTipo) // atualiza status de inicio de carga, fim e espera

fConsulta() // atualiza os grids

if p_nOpc== nil .or. p_nOpc>0
	u_SigexRegrava()
	MsgInfo("Status Atualizado as "+time())
endif

u_setZZL()

Return


Static Function fFaturar(_oBrwAux)

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

oDlg2:End()
fConsulta()

Return

Static Function setSx1(cperg)

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



Static Function fMudaStat(_oBrwAux)

Local aAreaAtu := GetArea()
Local wOC      := _oBrwAux:aArray[_oBrwAux:nAT,7]

dbSelectArea("SZE")
dbSetOrder(1)
If dbSeek(xFilial("SZE")+wOC)
	
	nCon1  := -1
	ltentar:= .t.
	
	TCCONTYPE("NPIPE")
	nCon1  := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
	
	while nCon1 <0 .and. ltentar
		nCon1  := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
		ltentar:= !MsgBox("Falha durante a tentativa de conectar-se ao banco de dados SIGEX. Tentar mais uma vez ?","Acesso SIGEX", "YESNO")
	end
	If nCon1 > 0
		
		TCSetConn(nCon1)
		
		p_cstatus:='6'
		
		cQuery := ""
		cQuery := "UPDATE "+RetSqlName("SZE")
		cQuery += " SET ZE_STATUS = '"+p_cstatus+"' , ZE_PESOFIN = 99, ZE_OBS = 'FINALIZADO VIA STATUS SIGEX' "
		cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
		cQuery += " AND ZE_OC = '"+WOC+"'"
		
		TcSqlExec(cQuery)
		
		RecLock("SZE",.F.)
		SZE->ZE_STATUS := "6"
		SZE->ZE_PESOFIN := 99
		SZE->(MsUnLock())
		
	EndIf
	
	TCUnLink(nCon1)
	TCSetConn(0)
	
	dbSelectArea("SZE")
	
EndIf

fConsulta()

RestArea(aAreaAtu)

oDlg2:End()

Return


User Function fPreNFE()

MATA140(xAutoCab,xAutoItens,nOpcAuto,lSimulaca,nTelaAuto)

Return



Static Function ValPerg(cperg)

cperg := padr(cperg,10)
aRegs := {}

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


static function setSC6(p_cOC, p_cLacre,p_nPSEnt)

local warea:= getarea()

DbSelectArea("SC6")
SC6->(dbSetOrderNickName("INDSC61"))
If SC6->(DbSeek(xFilial("SC6") + p_cOC))
	While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_YOC == p_cOC
		
		SC6->(Reclock('SC6',.f.))
		if !empty(p_cLacre)
			SC6->C6_YLACRE := p_cLacre
		endif
		SC6->C6_YPSENT := p_nPSEnt
		SC6->(Msunlock())
		SC6->(DbSkip())
	EndDo
	
	DbSelectArea("SZF")
	SZF->(dbSetOrder(8))
	If SZF->(DbSeek(xFilial("SZF") + p_cOC))
		While SZF->(!Eof()) .and. SZF->ZF_FILIAL == xFilial("SZF") .and. SZF->ZF_OC == p_cOC
			
			SZF->(Reclock('SZF',.f.))
			If !empty(p_cLacre)
				SZF->ZF_LACRE := p_cLacre
			Endif
			SZF->ZF_PSENT := p_nPSEnt
			SZF->(Msunlock())
			SZF->(DbSkip())
		EndDo
	Endif
Endif

RestArea(wArea)

Return


Static Function SetDA3(p_cPlaca,p_cOC,p_cPSEnt,p_cHora,p_dData,p_cMotor,p_cTipo,p_cPSSai,p_cHSaida)

Local	wArea		:= getArea()
Local	lExist

DA3->(dbSetOrder(3))
If DA3->(dbSeek(xFilial("SZ2")+p_cPlaca))
	
	_cPedido := ""
	SC6->(dbOrderNickName("INDSC61"))
	If SC6->(dbSeek(xFilial("SC6")+ p_cOC ))
		_cPedido := SC6->C6_NUM
	Endif
	
	DA3->(RecLock("DA3",.F.))
	If p_cTipo == "E"
		DA3->DA3_YPSENT	    := p_cPSEnt
		DA3->DA3_YHORPE	    := p_cHora
		DA3->DA3_YOC		:= p_cOC
		DA3->DA3_YDTOC	    := p_dData
		DA3->DA3_YPEDID   	:= _cPedido
		DA3->DA3_MOTOR	    := p_cMotor
	ElseIf p_cTipo == "S"
		DA3->DA3_YPSSAI	    := p_cPSSai
		DA3->DA3_YHSAID	    := p_cHSaida
	Endif
	DA3->(MsUnlock())
Endif

RestArea(wArea)

Return


User function getConfirm()

local warea:= getArea()
local lret:=.t.
local oDlgSenha

local _senha    := space(10)
DEFINE MSDIALOG oDlgSenha TITLE "Senha" FROM 40,50 TO 100,300 PIXEL
@ 08,10 say "Senha:"
@ 08,35 get _senha PassWord
@ 14,100 BmpButton Type 1 Action Close(oDlgSenha)

Activate MsDialog oDlgSenha Centered
If  alltrim(_senha) <> alltrim(getmv("MV_YSENHA"))
	help("",1,"Y_MIZ008")
	lret:=.f.
End

restArea(warea)
return lret



Static Function setDimens(cperg)

PutSX1(cperg,"01","Lin 1 ?","","","mv_ch1","N",04,0,1,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cperg,"02","Col 2 ?","","","mv_ch2","N",04,0,1,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cperg,"03","Lin 1 ?","","","mv_ch3","N",04,0,1,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cperg,"04","Col 2 ?","","","mv_ch4","N",04,0,1,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")

pergunte(cperg,.T.)

return

User Function mzNfetransm(p_cOpcao,cSerie,cNotaIni,cNotaFim)

local warea      := getarea()
local lret       := .t.
Local cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local cParNfeMnt := '000179_'+SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local aPerg      := {}
Local aParam     := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}

PRIVATE cCondicao := ""
PRIVATE bFiltraBrw:= {|| .t. }


if p_cOpcao $ 'TODAS/REM'
	
	spedNFeRe2(cSerie,cNotaIni,cNotaFim)
	
endif

if p_cOpcao $ 'TODAS/DAN'
	
	if p_cOpcao == 'TODAS'
		xPerg      := 'NFSIGW'
		aParametros:= {}
		aAdd( aParametros, cNotaIni ) //da nota
		aAdd( aParametros, cNotaFim ) //da nota
		aAdd( aParametros, cSerie ) //da nota
		aAdd( aParametros, '2' ) // 1-entrada ou 2-saida
		aAdd( aParametros, '2' )  //1-imprimir ou 2-visualizar
		aAdd( aParametros, '2' )  //imprimi no verso - 1-Sim  2-Nao
		
		u_smSetSX1(aParametros,xPerg)
	endif
	
	cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
	aFilBrw	  := {'SF2',cCondicao}
	
	SpedDanfe()
Endif

if p_cOpcao $ 'STA'
	
	SpedNFeStatus()
	
endif

restarea(warea)

return




User Function smSetSX1(aParametros,cPerg)

Local wArea:=GetArea()

Private p_name  := cEmpAnt + cUserName // variavel publica
Private p_prog  := iif( !empty(cPerg),cPerg,FunName())  // rotina do sistema
Private p_task  := "PERGUNTE" // padrao do sistema para parametros tipo SX1
Private p_type  := "MV_PAR"   //  ""     "" 			"" 				""
Private p_defs  := ""

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


Static Function chamadaBtns(p_cOpcao)

Local warea:= getArea()

do case
	case p_cOpcao =='PED' ; MATA410()
	case p_cOpcao =='CLI' ; MATA030()
	case p_cOpcao =='AGE' ; U_PXH045()
	case p_cOpcao =='MOT' ; OMSA040()
	case p_cOpcao =='TRA' ; MATA050()
	case p_cOpcao =='CAM' ; OMSA060()
	case p_cOpcao =='CAR' ; OMSA060()
	case p_cOpcao =='IOC' ; u_MIZ050GR('botaomiz999',wnumOC)
	case p_cOpcao =='NFE' ; SpedNFe() //u_frmPesoBal()
	case p_cOpcao =='CEN' ; u_miz030(wnumOC)
		
Endcase

RestArea(wArea)

Return


static function setOC(oBrwAux)

local warea:= getArea()

oBrwAux:Refresh()

wNumOC:=oBrwAux:aArray[oBrwAux:nAT,7]

if empty(oBrwAux:aArray[oBrwAux:nAT,7]) ; return; endif

dbSelectArea("SZE")
dbsetorder(1)
dbSeek(xFilial("SZE")+wNumOC) //Posiciona na OC para faturar

RestArea(wArea)

Return

User function setZZL(p_cOC,p_cPlaca, p_lcancelPeso)

local warea   := getArea()
local lautom  := .f.
local _cOC    := p_cOC
local _cPlaca := p_cPlaca
local lcancelPeso := iif( p_lcancelPeso==nil, .f., p_lcancelPeso )

aAreaATU := GetArea()
aAreaSZE := SZE->(GetArea())

dbSelectArea("SZE")

cQuery := ""
cQuery := "SELECT * FROM " + RetSqlName("SZE") + " "
cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' AND   ZE_FATUR <> 'S'"
if _cOC==nil
	cQuery += " AND ZE_PAGER <> '' "
	cQuery += " AND ZE_STATUS IN ('1','2','3','4','5','6')  "
else
	cQuery += " AND ZE_OC = '"+_cOC+"'"
	cQuery += " AND ZE_PLACA = '"+_cPlaca+"'"
endif

if select('sZE_pro')>0
	sZE_pro->(dbCloseArea())
endif

dbUseArea(.F., "TOPCONN", TCGenQry(,,cQuery), "SZE_PRO", .F., .T.)

DbSelectArea("SZE_PRO")

SZE_PRO->(DbGotop())

nCon1  := -1
ltentar:= .t.
nCon1  := TCLink("MSSQL/SIGEX","10.0.1.9",7897)

while nCon1 <0 .and. ltentar
	nCon1 := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
	ltentar:= !MsgBox("Falha durante a tentativa de conectar-se ao banco de dados SIGEX. Tentar mais uma vez ?","Acesso SIGEX", "YESNO")
EndDo

If nCon1 < 0
	caux:="Falha durante a tentativa de conectar-se ao banco de dados SIGEX."
	if !lautom
		Alert(caux)
	else
		conout( caux )
	endif
Else
	if lautom
		conout( "conectado banco SIGEX ..." )
	endif
	TCSetConn(nCon1)
	
	while !sZE_pro->(eof())
		_cTexto:=''
		do case
			case sZE_pro->ZE_status == '1' .and. _cOC <> nil
				_cTexto  := "CHAMADO PORTARIA"
			case sZE_pro->ZE_status == '2' .and. _cOC <> nil
				_cTexto  := "CANCELADO CHAMADO PORTARIA"
			case sZE_pro->ZE_status == '3'
				_cTexto  := "PROSSEGUIR CARRO"
			case sZE_pro->ZE_status  == '4'
				_cTexto  := "I-LONAMENTO OBRIGATORIO"
			case sZE_pro->ZE_status  == '5'
				_cTexto  := "F-LONAMENTO OBRIGATORIO"
			case sZE_pro->ZE_status  == '6'
				_cTexto  := "RETIRAR NOTA FISCAL"
		endcase
		
		if lcancelPeso
			_cTexto  := "CANCELAR PROSSEGUIR"
		endif
		
		if empty(_cTexto)
			sZE_pro->(dbskip())
			loop
		endif
		
		_cPager  := sZE_pro->ZE_pager
		_cPlaca  := sZE_pro->ZE_placa
		_cNome   := sZE_pro->ZE_nommot
		_cStatus := sZE_pro->ZE_status
		
		dbSelectArea("ZZL")
		dbSetOrder(1)
		lgrava:=.f.
		If dbSeek(xFilial("ZZL")+ _cPager ) // busca pelo pager
			if !(_cTexto $ zzl->zzl_texto)  // significa que nao mudou de status, logo nao precisa gravar a mesma mensagem
				lgrava:=.t.
				RecLock("ZZL",.F.)
			endif
		Else
			lgrava:=.t.
			RecLock("ZZL",.T.)
		EndIf
		
		if lgrava
			ZZL->ZZL_FILIAL := xFilial()
			ZZL->ZZL_PAGER  := _cPager
			ZZL->ZZL_PLACA  := _cPlaca
			ZZL->ZZL_NOME   := Substr( _cNome ,1,20)
			ZZL->ZZL_TEXTO  := _cTexto
			ZZL->ZZL_QTENVI := 0
			ZZL->ZZL_HRENVI := strzero(val(ZZL->ZZL_HRENVI ) +1 ,3)
			ZZL->(MsUnLock())
		endif
		
		dbselectArea('sZE_pro')
		sZE_pro->(dbskip())
	end
	
	TCUnLink(nCon1)
	TCSetConn(0)
	if lautom
		conout( "desconectado banco SIGEX ..." )
	endif
	
	dbSelectArea("SZE")
	
EndIf

RestArea(aAreaSZE)
RestArea(aAreaATU)

If lautom
	conout( "fim atualizacao banco SIGEX ..." )
Endif

RestArea(warea)

Return nCon1


Static Function ParamSave(cLoad,aParametros,cBloq)

local nx

Local cWrite := cBloq+"Arquivo de configuração - Parambox Protheus "+CRLF
Local cBarra := If(issrvunix(), "/", "\")

For nx := 1 to Len(aParametros)
	Do Case
		Case ValType(&("MV_PAR"+AllTrim(STRZERO(nx,2,0)))) == "C"
			cWrite += "C"+&("MV_PAR"+AllTrim(STRZERO(nx,2,0)))+CRLF
		Case ValType(&("MV_PAR"+AllTrim(STRZERO(nx,2,0)))) == "N"
			cWrite += "N"+Str(&("MV_PAR"+AllTrim(STRZERO(nx,2,0))))+CRLF
		Case ValType(&("MV_PAR"+AllTrim(STRZERO(nx,2,0)))) == "L"
			cWrite += "L"+If(&("MV_PAR"+AllTrim(STRZERO(nx,2,0))),"T","F")+CRLF
		Case ValType(&("MV_PAR"+AllTrim(STRZERO(nx,2,0)))) == "D"
			cWrite += "D"+DTOC(&("MV_PAR"+AllTrim(STRZERO(nx,2,0))))+CRLF
		OtherWise
			cWrite += "X"+CRLF
	EndCase
Next

MemoWrit(cBarra + "PROFILE" + cBarra +Alltrim(cLoad)+".PRB",cWrite)

Return


Static Function ParamLoad(cLoad,aParametros,nx,xDefault,lDefault)

local ny
Local cBarra     := If(issrvunix(), "/", "\")
DEFAULT lDefault := .F.

If File(cBarra + "PROFILE" + cBarra +Alltrim(cLoad)+".PRB")
	If FT_FUse(cBarra +"PROFILE"+cBarra+Alltrim(cLoad)+".PRB")<> -1
		FT_FGOTOP()
		If nx == 0
			cLinha := FT_FREADLN()
			FT_FUSE()
			Return Substr(cLinha,1,1)
		EndIf
		For ny := 1 to nx
			FT_FSKIP()
		Next
		cLinha := FT_FREADLN()
		If !lDefault
			Do case
				Case Substr(cLinha,1,1) == "L"
					xRet := If(Substr(cLinha,2,1)=="F",.F.,.T.)
				Case Substr(cLinha,1,1) == "D"
					xRet := CTOD(Substr(cLinha,2,10))
				Case Substr(cLinha,1,1) == "C"
					//**********************************************
					// Tratamento para aumentar o tamanha do campo *
					//**********************************************
					If VALTYPE(xDefault)=="C"
						xRet := Padr(Substr(cLinha,2,Len(cLinha)),Len(xDefault))
					Else
						xRet := Substr(cLinha,2,Len(cLinha))
					EndIf
				Case Substr(cLinha,1,1) == "N"
					xRet := Val(Substr(cLinha,2,Len(cLinha)))
				OtherWise
					xRet := xDefault
			EndCase
		Else
			xRet := xDefault
		Endif
		FT_FUSE()
	EndIf
Else
	xRet := xDefault
EndIf

Return xRet