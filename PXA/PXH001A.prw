#INCLUDE "TOTVS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

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


User Function PXH001A(p_cNumero, p_cwAlCab,p_cItem)
	
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := ""
	Local cPict         := ""
	Local Cabec1        := ""
	Local Cabec2        := ""
	Local imprime       := .F.
	Local aOrd          := {}
	Private cFileMizu 	:= FisxLogo("1") //"lgrl"+cempant+".bmp"
	Private titulo      := " "
	Private nCol        := 0
	Private cNumero     := p_cNumero
	Private cItem       := p_cItem
	Private _cTime      := ""
	Private nLin2	    :=  0
	Private nLin        := 0
	Private oPrn    	:= NIL
	Private oFont1  	:= NIL
	Private oFont2  	:= NIL
	Private oFont3  	:= NIL
	Private oFont4  	:= NIL
	Private oFont5  	:= NIL
	Private oFont6  	:= NIL
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 220
	Private tamanho     := "P"
	Private nomeprog    := "PXH001A"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private cPerg 	    := "PXH001A"
	Private wnrel       := "PXH001A" // Coloque aqui o nome do arquivo usado para impressao em disco
	
	Private cNumero:= iif( p_cNumero<>nil, p_cNumero,'')
	Private cItem:= iif( p_cItem<>nil, p_cItem,If(p_cwAlCab == 'SC5', U_CheckItem('2','C','RELATORIO'),'01'))
	
	If Empty(cItem)
		Return .T.
	Endif
	
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
	
	
	if !empty(cNumero)
		pergunte(cPerg,.f.)
		mv_par01:=cNumero
	else
		If !pergunte(cPerg,.T.)
			Return .T.
		EndIf
		cNumero:= mv_par01
	endif
	
	oPrn:= FWMsPrinter():New(Titulo+'_'+Alltrim(mv_par01),6,.T., ,.T., , , , ,.F., , .T., )

	oPrn:SetPortrait()
	oPrn:StartPage()
	
	Processa({||Imprimir(cNumero, p_cwAlCab,cItem) },"Processando...")
	
	oPrn:Preview()
	oPrn:EndPage()
	
Return .T.


Static Function Imprimir(p_cNumero, p_cwAlCab,p_cItem)
	
	RELGRAF2(p_cNumero, p_cwAlCab,p_cItem)
	Ms_Flush()
Return


Static Function RELGRAF2(p_cNumero,p_cwAlCab,p_cItem)
	
	LOCAL wAlCab  := p_cwAlCab
	local cTpOper := iif( p_cwAlCab=='SC5' ,'C','D')
	
	_cItem  := p_cItem
	
	nLin:= 0
	nCol:= 0
	I   := 0
	
	(wAlCab)->(dbsetorder(1))
	(wAlCab)->(dbseek( xfilial(wAlCab)+p_cNumero  ))
	
	do case
	case p_cwAlCab == 'SC5'
								
		If Empty(_cItem)
			Return		
		Endif
				
		sc6->(dbsetorder(1))
		sc6->(dbseek( xfilial('SC6')+p_cNumero+_cItem  ))
			
		wCodTran  := sc5->c5_transp
		wnomMotor := sc5->c5_ynommot
		wplaca    := sc5->c5_yplaca
		wtickEnt  := ''
		wclifor   := sc5->c5_cliente
		wljclifor := sc5->c5_lojaent
		wnomclifor:= left(Posicione('SA1',1,xFilial("SA1")+wclifor+wljclifor,"A1_NOME"),25)
		wnota     := sc5->c5_nota
		wserie    := sc5->c5_serie
		wproduto  := alltrim(sc6->c6_descri)
		nPesIni   := sc6->c6_ypesini
		nPesFin   := sc6->c6_ypesfin
		nPesLiq   := sc6->c6_ypesliq
		nPesNFEnt := 0
		wData     := Alltrim(DtoC(dDataBase))
		_cHrIni	  := _cHrFin := ''

	case p_cwAlCab == 'SZH'
		
		wnomMotor := ''
		DA4->(dbSetOrder(1))
		If DA4->(msSeek(xFilial("DA4")+SZH->ZH_CODMOT))
			wnomMotor := DA4->DA4_NOME
		Endif
		
		wCodTran  := szH->zH_codtran
		wplaca    := szH->zH_placa
		wtickEnt  := szH->zH_tickent
		wclifor   := szH->zH_fornec
		wljclifor := szH->zH_lojfor
		wnomclifor:= left(Posicione('SA2',1,xFilial("SA2")+wclifor+wljclifor,"A2_NOME"),25)
		wnota     := szH->zH_nota
		wserie    := szH->zH_serie
		wproduto  := Posicione('SB1',1,xFilial("SB1")+szH->zH_produto,"B1_DESC")
		nPesIni   := szH->zH_pesini
		nPesFin   := szH->zH_pesfin
		nPesLiq   := szH->zH_pesliq
		nPesNFEnt := szH->zH_pesnfe
		wData     := Alltrim(DtoC(szH->zH_emissao))
		_cHrIni	  := Left(SZH->ZH_HORINI,5)
		_cHrFin   := Left(SZH->ZH_HORFIN,5)
		
	endcase
	
	nColFin:= 2350
	wncolA := 430
	
	FOR I:=1 TO 2
		
		nCols := 00
		nLin+=0030
		
		oPrn:SayBitmap(nLin ,0035, cFileMizu, 450,130)
		
		nLin+=50
		
		oPrn:Say(nLin ,0900,Iif( cTpOper == 'D',"D E S C A R R E G A M E N T O","C A R R E G A M E N T O"),oFont14N)
		nLin+=50
//		nLin+=105
		
		oPrn:Say( nLin+60 ,1600,"TICKET Balan็a ",oFont14N)
		nlin-=10
		
		oPrn:Box(nLin ,2000,nLin + 100 ,nColFin) //quadro do nr. ticket
		nLin+=25
		
		oPrn:Say(nLin+45 ,2150, cNumero	,oFont16N)
		nLin+=80
		
		oPrn:Box(nLin ,0030, nLin + 0400,nColFin) //quadro do cabe็alho
		
		wnomtransp:= Posicione('SA4',1,xFilial("SA4")+ wCodTran  ,"A4_NOME")
		
		nLin+=80
//		nLin+=20
		oPrn:Say(nLin,0050,"Transportador:  " ,oFont14N) //300
		oPrn:Say(nLin,wncolA,Alltrim(wCodTran)+" - "+wnomtransp ,oFont10 ) //300
		
		If p_cwAlCab == 'SZH'
			oPrn:Say(nLin  ,1550, "Data:" ,oFont14N)
			oPrn:Say(nLin  ,1856, wData,oFont10)
		//Else
		//	oPrn:Say(nLin  ,1550, "Data/Hora:" ,oFont14N)
		//	oPrn:Say(nLin  ,1856, wData+' - '+left( Alltrim(time()) , 5),oFont10)
		Endif
		
		nLin+=70
		
		oPrn:Say(nLin ,0050,"Placa: ",oFont14N)
		oPrn:Say(nLin ,wncolA, wPlaca ,oFont10 )
		
		If p_cwAlCab == 'SZH'
			oPrn:Say(nLin  ,1550, "Hora Entrada:" ,oFont14N)
			oPrn:Say(nLin  ,1856, _cHrIni,oFont10)
		Endif

		nLin+=70
		
		oPrn:Say(nLin  ,0050,"Motorista: " ,oFont14N)
		oPrn:Say(nLin  ,wncolA, wnomMotor ,oFont10 )
		
		If p_cwAlCab == 'SZH'
			oPrn:Say(nLin  ,1550, "Hora Saํda:" ,oFont14N)
			oPrn:Say(nLin  ,1856, _cHrFin,oFont10)
		Endif
		
		nLin+=70
		
		oPrn:Say(nLin ,0050, iif(cTpOper=='C',"Cliente: ","Fornecedor: "),oFont14N)//510
		oPrn:Say(nLin ,wncolA, wCliFor+" - "+wNomCliFor ,oFont10 )
				
		oPrn:Say(nLin ,1550,"Ticket Ent: ",oFont14N)
		oPrn:Say(nLin ,1856, wTickEnt ,oFont10 )

		nLin+=70
		
		oPrn:Say(nLin ,0050,"Material: ",oFont14N)//510
		oPrn:Say(nLin ,wncolA,   wproduto ,oFont10 )
		
		oPrn:Say(nLin   ,1550,"Nota/Serie: ",oFont14N) //510
		oPrn:Say(nLin   ,1856,wnota+"/"+wserie,oFont10 ) //510

		nLin+=92
		
		oPrn:Box(nLin-60 ,0030, nLin+ 340,nColFin)     //quadro de pesagem
		
		oPrn:Box(nLin-60 ,1150, nLin+ 340,1150)     //divisoria do quadro de pessagem
		
		nLin+=10
		
		oPrn:Say(nLin,0050,"Pesagem  ",oFont14N)
		
		
		nLin+= 90
		
		
		oPrn:Say(nLin ,0050,"Peso Entrada" 							,oFont14)
		oPrn:Say(nLin ,0300,transform( nPesIni , "@E 999,999.99")	,oFont14)
		oPrn:Say(nLin ,1400,"Peso Nota"								,oFont14)
		oPrn:Say(nLin ,1650,transform( nPesNFEnt ,"@E 999,999.99")	,oFont14)
		nLin+= 80
		
		oPrn:Say(nLin ,0050,"Peso Saida"							,oFont14)
		oPrn:Say(nLin ,0300,transform( npesfin , "@E 999,999.99")	,oFont14)
		oPrn:Say(nLin ,1400,"Peso Lํquido"							,oFont14)
		oPrn:Say(nLin ,1650,transform( nPesLiq ,"@E 999,999.99")	,oFont14)
		nLin+= 50
		
		oPrn:Say(nLin ,0300,Replicate("_",10),oFont14N)
		oPrn:Say(nLin ,1650,Replicate("_",10),oFont14N)
		nLin+= 70
		
		oPrn:Say(nLin ,0050,"Peso Lํquido"							,oFont14N)
		oPrn:Say(nLin ,0300,transform( nPesLiq ,"@E 999,999.99")	,oFont14N)
		ndifpes:= iif( cTpOper=='C'   ,0, nPesNFEnt - nPesLiq )
		oPrn:Say(nLin ,1400,"Dif. de Peso"							,oFont14N)
		oPrn:Say(nLin ,1650,transform( ndifpes ,"@E 999,999.99")	,oFont14N)
		
		nLin+= 55
		
		oPrn:Say(nLin+10 ,1180,"Obs.: Dif. de Peso POSITIVA = material retido na carreta  ",oFont08)
		
		nLin+= 50
//		nLin+= 100
		
		oPrn:Box(nLin ,0030,nLin + 200,nColFin) //quadro de observa็๕es
		
		nLin+=40
		
		oPrn:Say(nLin ,0040,"Observa็ใo:  ",oFont14N)
				
		nLin+=90
		
		oPrn:Say(nLin , 0040,"Lacre(s): ",oFont12N)
		nLin+=130
		
		oPrn:Say(nLin  ,0140,	Replicate("_",35),oFont14)
		oPrn:Say(nLin  ,1400,	Replicate("_",35),oFont14)
		nLin+=50
		
		oPrn:Say(nLin  ,0220,"Assinatura da Expedi็ใo",oFont14N)
		oPrn:Say(nLin  ,1560,"Assinatura do Motorista",oFont14N)
		nLin+=60
		
		oPrn:Line(nLin, 0030,  nLin  , nColFin)//(linha, coluna, linha, coluna)

	NEXT
	
Return


Static Function AcertaSX1(cPerg)
	
	If !SX1->(dbSeek(cPerg+"01"))
		PutSx1(cPerg,"01","Num.Ordem.  ?","Ord.Carreg ?","Ord.Carreg ?", "mv_ch1", "C", 6, 0, 0,"G", "", "SC6", "", "","mv_par01","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")
	ENDIF
	
RETURN .T.
