#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "protheus.ch"
#INCLUDE "font.CH"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma   EICPGTPENDบ Autor ณ  Denilson Ferreira บ Data ณ  10/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ "Relatorio Ticket Balan็a		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


*---------------------------------*
User Function PXH060(p_cOc)
*---------------------------------*
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""


Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .F.
Local aOrd         := {}
Private cFilePX    := FisxLogo("1") //"lgrl"+cempant+".bmp"
Private titulo     := " "
Private nCol       := 0
Private cOrdCarr   :=""
Private _cTime     := ""
Private nLin2	   :=  0
Private nLin       := 0
Private oPrn       := NIL
Private oFont1     := NIL
Private oFont2     := NIL
Private oFont3     := NIL
Private oFont4     := NIL
Private oFont5     := NIL
Private oFont6     := NIL
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "P"
Private nomeprog   := "PXH060"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private cPerg 	   := "PXH060"
Private wnrel      := "PXH060" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cOc:= iif( p_cOc<>nil, p_cOc,'')

AcertaSX1(cPerg)


oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11  := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)


if !empty(cOc)
	pergunte(cPerg,.f.)
	mv_par01:=cOc
else
	If !pergunte(cPerg,.T.)
		Return .T.
	EndIf
endif
oPrn := TMSPrinter():New(Titulo)
oPrn:Setup()
oPrn:SetPortrait()
oPrn:StartPage()

Processa({||Imprimir(cOc) },"Processando...")

oPrn:Preview()
oPrn:EndPage()
oPrn:End()

Return .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ 																    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function Imprimir(p_cOc)



RELGRAF2(p_cOc)
Ms_Flush()
Return


*------------------------------------*
Static Function RELGRAF2(p_cOc)
*------------------------------------*

nLin:= 0
nCol:= 0
I:=0

cQuery:= "SELECT ZE_FILIAL,ZE_NMTRANS,ZE_NFCOMP,ZE_SERNF,ZE_OC,ZE_TRANSP ,ZE_PRODUTO,ZE_PSENT,ZE_PSSAI, ZE_COLEENT, ZE_COLESAI, "
cQuery+= "ZE_TICKENT,ZE_LACRE,ZE_TPOPER,ZE_PLACA,ZE_MOTOR,ZE_NOMMOT,ZE_FORNECE,ZE_LOJAFOR,ZE_NFPESEN FROM "+RETSQLNAME("SZE")+" ZE "
cQuery+= "WHERE ZE_OC = '"+iif(!empty(p_cOc),p_cOc,MV_PAR01)+"' AND ZE.D_E_L_E_T_ = '' AND ZE.ZE_FILIAL = '"+xfilial('SZE')+"'"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"_TRB", .F., .T.)
_trb->(dbgotop())

cOrdCarr := _TRB->ZE_OC
lCarregamto  := ( _TRB->ZE_TPOPER =='C')


ccoleent:='AUTOM.'
ccoleent:= iif( _TRB->ZE_coleent<>'M',' AUTOM.', ' MANUAL' )
ccolesai:='AUTOM.'
ccolesai:= iif( _TRB->ZE_colesai<>'M',' AUTOM.', ' MANUAL' )


nqtdPag:= iif( lCarregamto, 1, 2 )

SC6->(dbOrderNickName("INDSC61"))
SC6->(dbSeek(xFilial("SC6")+_trb->ZE_oc ))

nColFin:= 2350
wncolA := 430

FOR I:=1 TO nqtdPag
	
	nCols := 00
	nLin+=0030
	
	oPrn:SayBitmap(nLin ,0035, cFilePX, 450,280)
	
	
	nLin+=50
	
	oPrn:Say(nLin ,0900,Iif( lCarregamto ,"C A R R E G A M E N T O",  "D E S C A R R E G A M E N T O"  ),oFont14N)
	nLin+=60
	
	oPrn:Say(nLin ,0900, "COLETA:   Entrada -  "+ccoleent+"  Saida - "+ccolesai ,oFont10)
	
	nLin+=105
	
	oPrn:Say( nLin ,1600,"TICKET Balanca ",oFont14N)
	nlin-=10
	
	
	
	oPrn:Box(nLin ,2000,nLin + 100 ,nColFin) //quadro do nr. ticket
	nLin+=25
	
	oPrn:Say(nLin ,2150,_TRB->ZE_OC	,oFont16N)
	nLin+=80
	
	oPrn:Box(nLin ,0030, nLin + 0400,nColFin) //quadro do cabe็alho
	
	//oPrn:Say(nLin,0050,"Transportador:  "+Alltrim(_TRB->ZE_TRANSP)+" - "+Alltrim( Posicione('SA2',1,xFilial("SA2")+_TRB->ZE_TRANSP,"A2_NOME")),oFont14N) //300
	wnomtransp:= _trb->ZE_nmtrans
	if empty(wnomtransp)
		wnomtransp:= Posicione('SA2',1,xFilial("SA2")+_TRB->ZE_TRANSP,"A2_NOME")
	endif
	
	
	wnomMotor:=_trb->ZE_NOMMOT
	if empty(wnomMotor)
		wnomMotor:= Alltrim(Posicione('SZ3',1,xFilial("SZ3")+_TRB->ZE_MOTOR,"Z3_NOME"))
	endif
	
	nLin+=20
	oPrn:Say(nLin,0050,"Transportador:  " ,oFont14N) //300
	oPrn:Say(nLin,wncolA,Alltrim(_TRB->ZE_TRANSP)+" - "+wnomtransp ,oFont10 ) //300
	
	oPrn:Say(nLin  ,1550, "Data/Hora:" ,oFont14N)
	oPrn:Say(nLin  ,1856, Alltrim(DtoC(dDataBase))+' - '+left( Alltrim(time()) , 5),oFont10)
	//oPrn:Say(nLin  ,1992,      	,oFont10)
	
	nLin+=70
	
	oPrn:Say(nLin ,0050,"Placa: ",oFont14N)
	oPrn:Say(nLin ,wncolA,_TRB->ZE_PLACA,oFont10 )
	
	nLin+=70
	
	oPrn:Say(nLin  ,0050,"Motorista: " ,oFont14N)
	oPrn:Say(nLin  ,wncolA,Alltrim(_TRB->ZE_MOTOR)+" - " + wnomMotor ,oFont10 )
	
	oPrn:Say(nLin ,1550,"Ticket Ent: ",oFont14N)
	if lcarregamto
	else
		oPrn:Say(nLin ,1950,_TRB->ZE_TICKENT,oFont10 )
	endif
	
	nLin+=70
	
	if lcarregamto
		oPrn:Say(nLin ,0050,"Cliente: ",oFont14N)//510
		oPrn:Say(nLin ,wncolA,SC6->C6_CLI+" - "+Left( SC6->C6_YNOMCLI,25)  ,oFont10 )
	else
		oPrn:Say(nLin ,0050,"Fornecedor: ",oFont14N)//510
		oPrn:Say(nLin ,wncolA,_TRB->ZE_FORNECE+" - "+left(Posicione('SA2',1,xFilial("SA2")+_TRB->ZE_FORNECE+_TRB->ZE_LOJAFOR,"A2_NOME"),25)  ,oFont10 )
	endif
	
	oPrn:Say(nLin   ,1550,"Nota/Serie: ",oFont14N) //510
	if lcarregamto
		oPrn:Say(nLin   ,1950,SC6->C6_NOTA+"/"+SC6->C6_SERIE,oFont10 ) //510
	else
		oPrn:Say(nLin   ,1950,_TRB->ZE_NFCOMP+"/"+_TRB->ZE_SERNF,oFont10 ) //510
	endif
	
	nLin+=70
	
	oPrn:Say(nLin ,0050,"Material: ",oFont14N)//510
	oPrn:Say(nLin ,wncolA,   alltrim(_TRB->ZE_PRODUTO) ,oFont10 )
	
	nLin+=92
	
	oPrn:Box(nLin ,0030, nLin+ 400,nColFin)     //quadro de pesagem
	
	oPrn:Box(nLin ,1150, nLin+ 400,1150)     //divisoria do quadro de pessagem
	
	nLin+=10
	
	oPrn:Say(nLin,0050,"Pesagem POLIMIX AMBIENTAL",oFont14N)
	
	
	nLin+= 90
	
	nlin2 := nlin
	
	nPesLiq:= _TRB->ZE_PSENT - _TRB->ZE_PSSAI
	nPesLiq := iif( lcarregamto , nPesLiq*-1 , nPesLiq )
	
	oPrn:Say(nLin ,0050,"Peso Entrada   "+transform(_TRB->ZE_PSENT,"@E 999,999.99"),oFont14)
	//oPrn:Say(nLin ,1440,"Peso Nota       "+transform(_TRB->ZE_NFPESEN,"@E 999,999.99"),oFont14)
	nLin+= 80
	
	oPrn:Say(nLin ,0050,"Peso Saida     "+transform(_TRB->ZE_PSSAI,"@E 999,999.99"),oFont14)
	
	//oPrn:Say(nLin ,1440,"Peso Liquido   "+transform( nPesLiq ,"@E 999,999.99"),oFont14)
	nLin+= 50
	
	oPrn:Say(nLin ,0330,Replicate("_",10),oFont14N)
	//oPrn:Say(nLin ,1720,Replicate("_",10),oFont14N)
	nLin+= 70
	
	oPrn:Say(nLin ,0050,"Peso Liquido   "+transform( nPesLiq ,"@E 999,999.99"),oFont14N)
	//oPrn:Say(nLin ,1440,"Dif. de Peso   "+transform(_TRB->ZE_NFPESEN - nPesLiq ,"@E 999,999.99"),oFont14N)
	nLin+= 55
	
	//oPrn:Say(nLin ,1180,"Obs.: Dif. de Peso POSITIVA = material retido na carreta  ",oFont08)
	
	
	nLin+= 100
	
	
	if !lcarregamto
		
		oPrn:Say(nLin2 ,1440,"Peso Liquido   "+transform(nPesLiq,"@E 999,999.99"),oFont14)
		nLin2+= 80
		
		oPrn:Say(nLin2 ,1440,"Peso Nota       "+transform( _TRB->ZE_NFPESEN ,"@E 999,999.99"),oFont14)
		nLin2+= 50
		
		oPrn:Say(nLin2 ,1720,Replicate("_",10),oFont14N)
		nLin2+= 70
		
		oPrn:Say(nLin2 ,1440,"Dif. de Peso   "+transform(nPesLiq - _TRB->ZE_NFPESEN ,"@E 999,999.99"),oFont14N)
		nLin2+= 55
		
		oPrn:Say(nLin2 ,1180,"Obs.: Dif. de Peso POSITIVA = material retido na carreta  ",oFont08)
		nLin2+= 100
		
		
	endif
	
	
	
	oPrn:Box(nLin ,0030,nLin + 300,nColFin) //quadro de observa็๕es
	
	nLin+=40
	
	oPrn:Say(nLin ,0040,"Observa็ใo:  ",oFont14N)
	
	
	//oPrn:Say(nLin ,0260,	Replicate(".",165),oFont14)
	nLin+=50
	//oPrn:Say(nLin ,0040,	Replicate(".",190),oFont14)
	nLin+=50
	//oPrn:Say(nLin ,0040,	Replicate(".",190),oFont14)
	nLin+=70
	
	//oPrn:Say(nLin , 0040,"Lacre(s): "+_TRB->ZE_LACRE,oFont12N)
	nLin+=150
	
	oPrn:Say(nLin  ,0040,	Replicate("_",35),oFont14)
	oPrn:Say(nLin  ,1400,	Replicate("_",35),oFont14)
	nLin+=70
	
	oPrn:Say(nLin  ,0040,"Assinatura da Expedi็ใo",oFont14N)
	oPrn:Say(nLin  ,1400,"Assinatura da Motorista",oFont14N)
	nLin+=30
	
	
	//1630     3460		nLin+=80
	
	oPrn:Say(nLin ,0030,Replicate(".",232),oFont10)
	nLin+=50
	
	
	If nLin > 1900
		nLin:=0
		nCol:=0
		If nLin < 3400
			oPrn:EndPage()
		endif
		oPrn:StartPage()
	Endif
	
	
	
	
NEXT


DbSelectArea("_TRB")
DbCloseArea()


Return



*-------------------------------*
Static Function AcertaSX1(cPerg)
*-------------------------------*

If !SX1->(dbSeek(cPerg+"01"))
	PutSx1(cPerg,"01","Num.Descarregamto.  ?","Ord.Carreg ?","Ord.Carreg ?", "mv_ch1", "C", 6, 0, 0,"G", "", "SZE", "", "","mv_par01","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")
ENDIF

RETURN .T.