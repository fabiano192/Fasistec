#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PA0220   º Autor ³ Fabiano da Silva   º Data ³  21/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza a Data de Embarque                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaEEC                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºOBS:		 ³ Todos os processos que ja foram embarcados foram			  º±±
±±º      	 ³ preenchidos com a data: 18/09/11                			  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0220()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Atualiza Data de Embarque"
PRIVATE oPrn       	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont5     	:= NIL

_nOpc := 0

AtuSx1()

DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo Atualizar a  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "Data de Embarque do Processo conforme os  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "parametros informados pelo usuário.       " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "Programa PA0220.PRW                       " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 70,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0220"))	OF oDlg PIXEL
@ 70,090 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc:=1,oDlg:End()) 	OF oDlg PIXEL
@ 70,160 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If _nOpc == 1
	Proces()
Endif

Return


Static Function Proces()

Pergunte("PA0220",.F.)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA220A(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function PA220A(_lFim)

EEC->(dbSetOrder(1))
If EEC->(dbSeek(xFilial("EEC")+MV_PAR01))
	EEC->(RecLock("EEC",.f.))
	EEC->EEC_DTEMBA  := MV_PAR02
	EEC->EEC_FIM_PE  := MV_PAR02
	If !Empty(MV_PAR02)
		EEC->EEC_STATUS  := "6"
		EEC->EEC_STTDES  := "Embarcado"
	Else
		EEC->EEC_STATUS  := "4"
		EEC->EEC_STTDES  := "Aguardando Confeccao Documentos"
	Endif
	EEC->(MsUnlock())
	Msginfo("Data de Embarque inserida com sucesso!")
Else
	Alert("Processo nao encontrado!")
Endif

//ASN()

Return



Static Function AtuSX1()

cPerg := "PA0220"

///////////////////////////////////////
////   MV_PAR01  : Processo ?		///
////   MV_PAR02  : Data Embarque    ///
//////////////////////////// //////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid	/Var01      /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02			/Defspa2/defeng2/Cnt02/Var03/Def03		/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Processo		 		?",""       ,""      ,"mv_ch1","C" ,20     ,0      ,0     ,"G",""        ,"MV_PAR01",""	 	 	,""     ,""     ,""   ,""   ,""				,""     ,""     ,""   ,""   ,""  		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Embarque         ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return






Static Function ASN()

_c0152   := Space(8)

dbSelectArea("EE9")
dbSetOrder(2)
If dbSeek(xFilial("EE9")+MV_PAR01)
	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial("SF2")+EE9->EE9_NF + EE9->EE9_SERIE)
	_c0152   := SF2->F2_CLIENTE+SF2->F2_LOJA
	_lGo := .T.
	
	If _c0152 $ "00017115/00017118/00017126/00017128/00017109/00017135"
		//		Alert("Esse Cliente Não é Necessário Enviar!!")
		_lGo := .F.
	Endif
		
	If SF2->F2_CLIENTE != "000171"
		//		Alert("Cliente Não é Caterpillar!!")
		_lGo := .F.
	Endif
	
Else
	Alert("Processo Exportacao nao encontrado!!")
	_lGo := .F.
Endif

_lCont := .T.
EEC->(dbSetOrder(1))
If EEC->(dbSeek(xFilial("EEC")+EE9->EE9_PREEMB))
	
	If !Empty(EEC->EEC_DTASN)
		_lCont := .F.
	Endif
Else
	_lCont := .F.
	//	Alert("Processo Exportacao nao encontrado!!")
Endif

If _lCont
	If _lGo
		
		Private _nHdlV,_cEOL
		Private _lAchou := .F.
		Private _cLin, _cCpo, _cCGCPasy,_c0038,_cUM, _cIdenti,_cTpForn,_cIdent,_c0036
		Private _nTamLin    := 128
		Private _nItem, _cDescCFO,_cRev,_nContLiV, _nContLiR, _nSomaTot
		Private _cRev       := "0000"
		
		Private _nCont := 0
		
		dbSelectArea("EE9")
		dbSetOrder(2)
		dbSeek(xFilial("EE9")+MV_PAR01,.F.)
		
		ProcRegua(LastRec())
		
		While !Eof() .And. EE9->EE9_PREEMB == MV_PAR01
			
			IncProc()
			
			_cCgc2  := "60675048000121"
			_cData2 := GravaData(dDataBase,.f.,8)
			_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
			
			_cArqTxtV := "\\SERVER2\ERP\EDI\SINTEL\CAT\SAIDA\DESADV_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
			
			_nHdlV    := MSfCreate(_cArqTxtV)
			
			If _nHdlV == -1
				MsgAlert("O arquivo de nome "+_cArqTxtV+" 1 nao pode ser executado!","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
			
			_cEOL    := "CHR(13)+CHR(10)"
			
			If Empty(_cEOL)
				_cEOL := CHR(13)+CHR(10)
			Else
				_cEOL := Trim(_cEOL)
				_cEOL := &_cEOL
			Endif
			
			_cLin    := Space(128) + _cEOL
			
			_nContLiV := 0
			
			_cLin     := Space(128) + _cEOL
			_c0036    := GetMv("MV_NUMSIN")
			
			dbSelectArea("SX6")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := StrZero((Val(_c0036)+1),5)
			MsUnlock()
			
			_cData     := GravaData(dDataBase,.f.,4)
			_cHora     := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
			_c0035     := _cData + _cHora
			_c0037     := SM0->M0_CGC
			_c0243     := Substr(SM0->M0_NOMECOM,1,25)
			
			_c0151   := "DESADV"+Space(2)
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbseek(xFilial("SA1")+ _c0152)
				_c0038    := SA1->A1_CNPJEXP
				_c0244    := Substr(SA1->A1_NOME,1,25)
			Endif
			
			//                          (5)    (12)      (14)     (14)    (8)      (8)      (25)     (25)
			_cCpo    := "ITPAEG02" + _c0036 + _c0035 + _c0037 + _c0038 + _c0151+ _c0152 + _c0243 + _c0244 + space(9)
			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			_cLin     := Space(128)+_cEOL
			
			_lAchou    := .T.
			_cD060     := Substr(EE9->EE9_NF,2,8)                                // Numero da nota Fiscal        (8)
			_cN101     := EE9->EE9_SERIE + SPACE(1)                              // Serie                        (4)
			_cGM13     := "9  "                                                  // Funcao da Mensagem Original  (3)
			_cDataNf   := Space(8)
			_cHrNf     := Space(4)
			
			dbSelectArea("SF2")
			dbSetOrder(1)
			If dbSeek(xFilial("SF2")+EE9->EE9_NF + EE9->EE9_SERIE + EEC->EEC_IMPORT + EEC->EEC_IMLOJA )
				_cDataNf  := GravaData(SF2->F2_EMISSAO,.f.,8)                      // Data De Emissao da N.F.      (8) M
				_cHrNf    := Substr(SF2->F2_HORA,1,2)+Substr(SF2->F2_HORA,4,2)     // Hora da Nota Fiscal          (4)
			Endif
			
			_cGM14     := _cDataNf + _cHrNf                                        // Data + Hora Da N.F           (12) M
			_cDataEmb  := space(8)
			
			_cDataEmb := GravaData(EEC->EEC_DTPROC,.f.,8)
			
			_cGM15     := _cDataEmb + _cHrNf                                       // Data + Hora Do Embarque             (12) M
			_cGM04     := EE9->EE9_UNIDAD + Space(1)                               // Unidade de Medida            (3)
			
			_cNf2 	   := EE9->EE9_NF
			
			_nPesoBru  := EE9->EE9_PSBRTO
			_nPesoLiq  := EE9->EE9_PSLQTO
			
			_cGM01    := strZero(_nPesoBru,12)
			_cGM03    := strZero(_nPesoLiq,12)
			
			_cGM28    := Space(3)	              			// Unidade de medida da quantidade Embarcada    (3) Opcional
			_cGM31    := Repl("0",12)             			// Quantidade Total de Unidades Embarcadas      (12) Opcional
			_cGM16    := Space(3)                 			// Tipo de Ref do transportador                 (3) Opcional
			
			_nCont    ++
			
			_cProc    := Alltrim(EE9->EE9_PREEMB)
			_nPosM    := At("/",_cProc)
			_cProc1   := Substr(_cProc,1,_nPosM-1)+"_"+Substr(_cProc,_nPosM+1,2)
			_cGM30    := Substr(_cProc1+"_"+StrZero(_nCont,2)+SPACE(30),1,30)  // Numero Ref. do Transportador                 (30) Opcional
			//			_cGM30    := Substr(Alltrim(EE9->EE9_PREEMB)+"_"+StrZero(_nCont,2)+SPACE(30),1,30)  // Numero Ref. do Transportador                 (30) Opcional
			
			_cCpo    := "BGM" + _cD060 + _cN101 + _cGM13 + _cGM14 + _cGM15 + _cGM04 + _cGM01 + _cGM04  + ;
			_cGM03 + _cGM28 + _cGM31 + _cGM16 + _cGM30 + SPACE(8)
			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo BGM).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			//		_cPS01 := GravaData(EEC->EEC_DTPROC+1,.f.,8) + _cHrNf              // Data + Hora Estimada da Entrega   (12) M
			//			_cPS01 := GravaData(EEC->EEC_DTPROC+35,.f.,8) + _cHrNf              // Data + Hora Estimada da Entrega   (12) M
			_cPS01 := GravaData(EEC->EEC_DTPROC+45,.f.,8) + _cHrNf              // Data + Hora Estimada da Entrega   (12) M
			_cPS02 := Space(20)                                                 // Identificador do vendedor   (20) O
			_cPS03 := "X6773C0"+Space(10)                                                 // Codigo Interno da Empresa Vendedora Atribuida pelo cliente
			_cD061 := Space(14)                                                 // Codigo do Fornecedor        (14) O
			_c0355 := Space(14)                                                 // IDENT. LOCAL DO FATURAMENTO (14) O
			_c0356 := Space(14)                                                 // IDENT. LOCAL DE COBRANCA    (14) O
			_c0357 := Space(14)                                                 // IDENT. LOCAL DE ENTREGA     (14) O
			_c0406 := Space(15)                                                 // DESCR. DA NATUREZA OPERCACAO(15) O
			
			_cCpo  :=  "BG1"  + _cPS01 + _cPS02 + _cPS03 + _cD061 + _c0355 + _c0356 + _c0357 + _c0406  + Space(5)
			
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo BG1).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			_cGM17 := Space(12)                                                 // CODIGO DO EMISSOR DO PROGRAM(14) O
			_cPS12 := Space(20)                                                 // CODIGO DA FAB. DE ENTREGA   (20) O
			_cPS13 := Space(20)                                                 // CODIGO IDENTIF. FORNECEDOR  (20) O
			_cPS14 := Space(10)                                                 // DUNS LOCAL DE EMBARQUE      (10) O
			_cPS15 := Space(10)                                                 // CODIGO RESPONSAVEL SOLICIT  (10) O
			_cPS16 := Space(20)                                                 // DOCA PARA DESCARGA          (20) O
			_cGM23 := Space(03)                                                 // QUAL.DO ESTAGIO TRANSPORTE  (20) O
			
			_c0445 := "M"+Space(03)   //a definir                                // MODO DE TRANSPORTE          (04) O
			//		_cPS17 := "A389"+Space(6) //DHL                                                 // CODIGO DO TRANSPORTADOR     (10) O
			_cPS17 := "UNKNOWN"+Space(3)                                         // CODIGO DO TRANSPORTADOR     (10) O
			//			_cPS17 := _cProc                                         			// CODIGO DO TRANSPORTADOR     (10) O
			_cPS18 := Space(10)                                                 // NUM. AUTORIZACAO TRANSPORTE (10) O
			_c0530 := Space(03)                                                 // CODIGO FABRICA TRANSMISSORA (03) O
			
			_cCpo  :=  "DTL"  + _cGM17 + _cPS12 + _cPS13 + _cPS14 + _cPS15 + _cPS16 + _cGM23 + _c0445  + _cPS17 + ;
			_cPS18 + _c0530 + Space(3)
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo DTL).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			_cEQD02 := "CN "					//QUALIFICADOR DO EQUIPAMENTO
			_cEQD03 := "FCA"+Space(14)			//IDENTIFICADOR DO EQUIPAMENTO
			
			_cCpo  :=  "EQD" + _cEQD02 + _cEQD03 + Space(105)
			
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo EQD).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			//		dbSelectArea("EE9")
			
			//		While !Eof() .And. _cNf2 == EE9->EE9_NF
			
			_cPS04 := StrZero(Val(EE9->EE9_SEQUEN),4)                                       // QUAL.DO ESTAGIO TRANSPORTE  (20) O
			_cCpo  :=  "CPS"  + _cPS04  + Space(121)
			
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo CPS).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			_cPS05 := StrZero(EE9->EE9_QTDEM1,6)                             // Quantidade de Embalagem
			_cPS06 := "BOX71"+Space(12)                                      // Tipo de Embalagem
			_cPS07 := StrZero(EE9->EE9_QE,10)                                // Quantidade de Itens em Cada Embalagem
			_cPS08 := "BX "                                                  // UNIDADE DE MEDIDA DA EMBALAGEM
			_cPS27 := Space(08)
			_c0600 := Space(20)
			_c0593 := Repl("0",8)
			_c0594 := Repl("0",6)
			_c0101 := Space(4)
			_c0133 := Repl("0",6)
			_c0595 := Repl("0",9)
			
			_cCpo  :=  "PAC"  + _cPS05 + _cPS06 + _cPS07 + _cPS08 + _cPS27 + _c0600 + _c0593 + _c0594  + _c0101 + ;
			_c0133 + _c0595 + Space(28)
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo PAC).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			//7
/*
			_cPS20 := Space(10)+GETMV("MV_PALLCAT")    //                              // NUMERO DO PALLETE QUE ESTÃO AS EMBALAGENS
			
			_cPallCat  := "P"+StrZero(Val(_cPS20)+1,6)
			PUTMV("MV_PALLCAT",_cPallCat)
  */
  
			_cAno_At   := strzero(year(dDataBase),4)
			_cMvEt     := Alltrim(GETMV("MV_PALLCAT"))
			_cAno_MV   := Substr(_cMvEt,2,4)

			 If _cAno_At > _cAno_MV
				_cEtiqCat  := "P"+_cAno_At+"000001"
			Else
				_cEtiqCat  := "P"+_cAno_At+Strzero(Val(Right(_cMvEt,6))+1,6)							
			Endif

			PUTMV("MV_PALLCAT",_cEtiqCat)
			_cPS20     := Space(6)+_cEtiqCat    // NUMERO DO PALLETE QUE ESTÃO AS EMBALAGENS
			
			_cCpo  :=  "RFF"  + _cPS20 + Space(108)
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo RFF).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			_cPS09 := Space(09)
			_cPS10 := Space(17)
			
			For X:= 1 To EE9->EE9_QTDEM1
				
/*
				_cPS19     := Space(10)+GETMV("MV_ETIQCAT")    //                              // NUMERO DA Etiqueta de Cada Embalagem
				_cEtiqCat  := "E"+StrZero(Val(_cPS19)+1,6)
				PUTMV("MV_ETIQCAT",_cEtiqCat)
  */			                  
  				_cAno_At   := strzero(year(dDataBase),4)
  				_cMvEt     := Alltrim(GETMV("MV_ETIQCAT"))
  				_cAno_MV   := Substr(_cMvEt,2,4)

				If _cAno_At > _cAno_MV
					_cEtiqCat  := "E"+_cAno_At+"000001"
				Else
					_cEtiqCat  := "E"+_cAno_At+Strzero(Val(Right(_cMvEt,6))+1,6)							
				Endif

				PUTMV("MV_ETIQCAT",_cEtiqCat)
				_cPS19     := Space(6)+_cEtiqCat    // NUMERO DA Etiqueta de Cada Embalagem
  
				SZP->(RecLock("SZP",.T.))
				SZP->ZP_FILIAL	:= xFilial("SZP")
				SZP->ZP_CODIGO  := Alltrim(_cPS19)
				SZP->ZP_PALETE  := Alltrim(_cPS20)
				SZP->ZP_ASN 	:= _cGM30			
				SZP->ZP_PREEMB  := EE9->EE9_PREEMB
				SZP->ZP_SEQEMB	:= EE9->EE9_SEQEMB
				SZP->(MsUnlock())				
				
				_cCpo  :=  "GIR"  + _cPS19 + _cPS09 + _cPS10 + Space(82)
				_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
				_nContLiV++
				
				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo GIR).  Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif
			Next X
			
			_c0007 := EE9->EE9_PART_N+Space(10)                                 // CODIGO DO PRODUTO          (20) M
			_cGM05 := Repl("0",12)                                              // QTDE ACUMUL. EMBARCADA     (12) O
			_cGM06 := "PC "                                                     // UNIDADE DE MEDIDA ACUMUL.  (03) O
			//			_cGM27 := strZero(Int(EE9->EE9_SLDINI*100),12)                      // QTDE EMBARCADA             (12) M
			_cGM27 := strZero(EE9->EE9_SLDINI,12)		                        // QTDE EMBARCADA             (12) M
			_cGM28 := "PC "                                                     // UNIDADE DE MEDIDA EMBARCADA(03) M
			_cGM29 := EE9->EE9_REFCLI + SPACE(10)                               // PEDIDO DE COMPRA           (20) M
			_cGM35 := SPACE(04)                                                 // ANO / MODELO DO REGISTRO   (04) O
			_cPS11 := SPACE(02)                                                 // CODIGO PAIS DE ORIGEM      (02) O
			_c0074 := "E"                                                       // CODIGO TIPO FORNECIMENTO   (01) M
			//			_cD056 := StrZero(EEC->EEC_PESLIQ,12)                               // PESO LIQUIDO DO ITEM       (12) O
			_cD056 := StrZero(_nPesoLiq,12)                               		// PESO LIQUIDO DO ITEM       (12) O
			_cD057 := SPACE(03)                                                 // UNID.MEDIDA PESO LIQUIDO   (03) O
			
			_cCpo  :=  "LIN"  + _c0007  + _cGM05 + _cGM06 + _cGM27 + _cGM28 + _cGM29 + _cGM35 + _cPS11 + _c0074 + ;
			_cD056 + _cD057  + Space(13)
			
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo RFF).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			_cFA302 := 	Substr(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3)) + SPACE(30),1,30)  // Descrição do Item conforme pedido pela Sintel(26/10/09)
			_cFA303 := 	Repl("0",9) 											// QTDE ITEM U.M.
			_cFA304 := 	SPACE(02)   											// U.M. ESTOQUE
			_cFA305 := 	SPACE(30)   											// NR DESENHO ITEM
			_cFA306 := 	SPACE(08)   											// DT VALIDADE DESENHO
			//			_cFA307 := 	SPACE(04)   											// ALT. TÉCNICA DO ITEM
			_cFA307 := 	EE9->EE9_REVENG											// ALT. TÉCNICA DO ITEM
			_cFA308 := 	SPACE(13)   											// PEDIDO DA REVENDA
			_cFA309 := 	SPACE(17)   											// NR CHASSI DO VEICULO
			_cFA310 := 	SPACE(04)   											// IDENTIFICADOR DO MODULO
			_cFA311 := 	SPACE(01)   											// IDENTIFICADOR DA CHAMADA
			
			_cCpo  :=  "FA3" + _cFA302 + _cFA303 + _cFA304 + _cFA305 + _cFA306 + _cFA307 + _cFA308 + _cFA309 + _cFA310 + _cFA311 + SPACE(07)
			
			_cLin  := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FA3).  Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			_nContLiV++
			_c0039  := StrZero(_nContLiV,9)                            // Numero de Controle              (9)  M
			_c0245  := Repl("0",17)                                    // Soma Total das N.Fiscais        (17) O
			_c0201  := space(1)                                        // CATEGORIA DA OPERACAOcais       (01) O
			
			_cCpo := "FTP"+ _c0036 + _c0039 + _c0245 + _c0201 + SPace(93)
			
			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			
			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
			
			fClose(_nHdlV)
			
			Sleep(1000) // 1 segundo
			
			_cArqNew   := "\\SERVER2\ERP\EDI\SINTEL\CAT\SAIDA\BKP\BKP_DESADV_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
			
			If !File(_cArqTxtV)
				MSGSTOP("ARQUIVO NAO PODE SER ABERTO! "+Alltrim(_cArqTxtV))
			Endif
			
			__CopyFile(_cArqTxtV,_cArqNew)
			
			dbSelectArea("EE9")
			dbSkip()
			//		EndDo
		EndDo
		
		EEC->(RecLock("EEC",.f.))
		EEC->EEC_ENVASN := "S"
		EEC->EEC_DTASN  := dDataBase
		EEC->(MsUnlock())
		
	Else
		If !_c0152 $ "00017109"
			EEC->(RecLock("EEC",.f.))
			EEC->EEC_ENVASN := "N"
			EEC->EEC_DTASN  := dDataBase
			EEC->(MsUnlock())
		Endif
	Endif
Endif

Return
