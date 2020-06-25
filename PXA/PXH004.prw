#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXH004   ³ Autor ³ Alexandro da Silva    ³ Data ³ 09/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio SYS                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Exportar para o Sistema SYS                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH004()

ATUSX1()

_nOpc := 0
DEFINE MSDIALOG oDlg TITLE "Rotina Gerar Rel. Sys"  From 10,0 TO 250,400 of oMainWnd PIXEL

@ 0.5,0.5 TO 08.25,025

@ 02,02 SAY "Rotina para exportar a Movimentacao Bancaria para o  "   SIZE 160,7
@ 03,02 SAY "Sistema SYS, conforme Layout Pre-Definido e Parame-  "     SIZE 160,7
@ 04,02 SAY "tros Informados Pelo Usuario.                        "     SIZE 160,7
@ 05,02 SAY "Programa PXH004.PRW                                  "     SIZE 160,7

@ 100,100  BMPBUTTON TYPE 5 ACTION Pergunte("PXH004")
@ 100,130  BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 100,160  BMPBUTTON TYPE 2 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	
	_cDir:= "C:\RELSYS\PXHOL"
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf
	
	Pergunte("PXH004",.F.)
	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PX004_01(@_lFim) }
	Private _cTitulo01 := 'Gerando Movimentacao !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return

Static Function PX004_01(_lFim)


Private cArqTxt := "\DOCS\"+DTOS(DDATABASE)+".CSV"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

Private nTamLin, cLin, cCpo

_cQ := " SELECT * FROM "+RetSqlName("SE5")+" A INNER JOIN "+RetSqlName("SA6")+ " B ON E5_BANCO=A6_COD AND E5_AGENCIA=A6_AGENCIA AND E5_CONTA=A6_NUMCON " 
//_cQ := " SELECT * FROM "+RetSqlName("SE5")+" A INNER JOIN "+RetSqlName("SA6")+ " B ON E5_FILIAL=A6_FILIAL AND E5_BANCO=A6_COD AND E5_AGENCIA=A6_AGENCIA AND E5_CONTA=A6_NUMCON "
_cQ += " INNER JOIN "+RetSqlName("SED")+" C ON E5_NATUREZ=ED_CODIGO"
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND A6_YCXACOD <> '' AND E5_NATUREZ <> '' AND E5_BANCO <> ''"
_cQ += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND E5_SITUACA = '' "
_cQ += " AND E5_TIPODOC NOT IN ('JR','MT','DC','CH') AND E5_MOTBX NOT IN ('CMP') AND E5_RECONC <> '' "
_cQ += " ORDER BY E5_DTDISPO "

//_cQ := " SELECT * FROM "+RetSqlName("SE5")+" A INNER JOIN "+RetSqlName("SA6")+ " B ON E5_BANCO=A6_COD AND E5_AGENCIA=A6_AGENCIA AND E5_CONTA=A6_NUMCON "
//_cQ += " INNER JOIN "+RetSqlName("SED")+" C ON E5_NATUREZ=ED_CODIGO"
//_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND A6_YCXACOD <> '' AND E5_NATUREZ <> '' AND E5_BANCO <> ''"
//_cQ += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND E5_SITUACA = '' "
//_cQ += " AND E5_TIPODOC NOT IN ('JR','MT','DC','CH') AND E5_MOTBX NOT IN ('CMP') AND E5_RECONC <> '' "
//_cQ += " ORDER BY E5_DTDISPO "


TCQUERY _cq NEW ALIAS "ZZ"

TCSETFIELD("ZZ","E5_DTDISPO","D")

_lPrim := .T.
_nCont := 0

ZZ->(dbGoTop())

ProcRegua(ZZ->(U_CONTREG()))

While ZZ->(!EOF())
	
	IncProc()
	
	nTamLin := 234
	cLin    := Space(nTamLin)+cEOL
	_nCont  := 0
	
	_cChavZZ := ZZ->E5_DTDISPO
	
	While ZZ->(!Eof()) .And. 	_cChavZZ == ZZ->E5_DTDISPO
		If _lPrim
			_lPrim := .F.
			
			cCpo := PADR("Documento",11)+";"
			cLin := Stuff(cLin,01,12,cCpo)
			/*
			cCpo := PADR("Caixa;",05)+";"
			cLin := Stuff(cLin,13,06,cCpo)
			
			cCpo := PADR("Custo",05)+";"
			cLin := Stuff(cLin,19,06,cCpo)
			*/

			cCpo := PADR("Custo;",05)+";"
			cLin := Stuff(cLin,13,06,cCpo)
			
			cCpo := PADR("Caixa",05)+";"
			cLin := Stuff(cLin,19,06,cCpo)

			cCpo := PADR("Origem",10)+";"
			cLin := Stuff(cLin,25,11,cCpo)
			
			cCpo := PADR("Data",10)+";"
			cLin := Stuff(cLin,36,11,cCpo)
			
			cCpo := PADR("Tipo",04)+";"
			cLin := Stuff(cLin,47,05,cCpo)
			
			cCpo := PADR("Classificação",13)+";"
			cLin := Stuff(cLin,52,14,cCpo)
			
			cCpo := PADR("Valor",17)+";"
			cLin := Stuff(cLin,66,18,cCpo)
			
			cCpo := PADR("Histórico",40)+";"
			cLin := Stuff(cLin,84,41,cCpo)
			
			cCpo := PADR("Doc Baixa",09)+";"
			cLin := Stuff(cLin,125,10,cCpo)
			
			cCpo := PADR("Transf Caixa",12)+";"
			cLin := Stuff(cLin,135,13,cCpo)
			
			cCpo := PADR("Transf Custo",12)+";"
			cLin := Stuff(cLin,148,13,cCpo)
			
			cCpo := PADR("Transf Origem",13)+";"
			cLin := Stuff(cLin,161,14,cCpo)
			
			cCpo := PADR("Status",06)+";"
			cLin := Stuff(cLin,175,07,cCpo)
			
			cCpo := PADR("Gravação",10)+";"
			cLin := Stuff(cLin,182,11,cCpo)

			cCpo := PADR("Conta Contabil",40)+";"
			cLin := Stuff(cLin,193,41,cCpo)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
		Endif
		
		If ZZ->E5_MOEDA == "TB" .And. ZZ->E5_RECPAG == "R"
			ZZ->(dbSkip())
			Loop
		Endif
		
		_nCont++
		
		_cDoc     := Left(Dtos(ZZ->E5_DTDISPO),6)+StrZero(_nCont,5)
		_cCaixa   := Alltrim(ZZ->A6_YCXACOD)
		_cCusto   := Alltrim(ZZ->A6_YCUDCOD) 
		_cConta   := Space(40)
		
		SZ1->(dbSetOrder(2))
		If SZ1->(dbSeek(xFilial("SZ1")+ ZZ->E5_NATUREZ + cEmpAnt + Left(cFilAnt,3)))
			If !Empty(SZ1->Z1_NATSYS)
				_cOrigem  := Alltrim(SZ1->Z1_NATSYS)  
			Else                             
				_cOrigem  := Alltrim(ZZ->ED_YCOD)
			Endif
			
			CT1->(dbSetOrder(1))
			If CT1->(dbSeek(xFilial("CT1")+SZ1->Z1_CONTA))
				_cConta   := CT1->CT1_DESC01
			Endif		
		Else
			_cOrigem  := Alltrim(ZZ->ED_YCOD)
		Endif
		
		_cData    := DTOC(ZZ->E5_DTDISPO)
		_cTrCaixa := ""
		_cTrCusto := ""
		_cTrOrigem:= ""
		
		If ZZ->E5_MOEDA = "TB"
			_cTipo    := "TRF"
			_nValor   := ZZ->E5_VALOR * - 1
			
			SE5->(dbOrderNickName("INDSE51"))
			If SE5->(dbSeek(ZZ->E5_FILIAL+"TR"+"R"+DTOS(ZZ->E5_DTDISPO)+ZZ->E5_NUMCHEQ))
				SA6->(dbSetOrder(1))
				//If SA6->(dbSeek(SE5->E5_FILIAL + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA)) 
				If SA6->(dbSeek(xFilial("SA6") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA))
					_cTrCaixa := Alltrim(SA6->A6_YCXACOD)
					_cTrCusto := Alltrim(SA6->A6_YCUDCOD)
				Endif
				
				SZ1->(dbSetOrder(2))
				If SZ1->(dbSeek(xFilial("SZ1")+ ZZ->E5_NATUREZ + cEmpAnt + Left(cFilAnt,3)))
					_cTrOrigem := Alltrim(SZ1->Z1_NATSYS)
				Else
					SED->(dbSetorder(1))
					If SED->(dbSeek(xFilial("SED")+SE5->E5_NATUREZ))
						_cTrOrigem := Alltrim(SED->ED_YCOD)
					Endif
				Endif
			Endif			
		ElseIf ZZ->E5_RECPAG == "R"
			_cTipo  := "REC"
			_nValor := ZZ->E5_VALOR
		ElseIf ZZ->E5_RECPAG == "P"
			_cTipo  := "DES"
			_nValor := ZZ->E5_VALOR * - 1
		Endif
				
		_cClas  := "OF"
		_cValor := Str(_nValor,17,02)
		_cValor := StrTran(_cValor, ".",",")
		
		_cHist  := ""
		If Empty(ZZ->E5_PARCELA)
			_cParc := "-"
		Else
			_cParc := "-"+ZZ->E5_PARCELA+"-"
		Endif
		
		If Empty(ZZ->E5_TIPO) .And. !Empty(ZZ->E5_MOEDA)
			_cHist  := Lower(Alltrim(ZZ->E5_HISTOR))
		ElseIf !Empty(ZZ->E5_CLIENTE)
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1")+ZZ->E5_CLIENTE + ZZ->E5_LOJA))
				If ZZ->E5_TIPODOC = "ES"
					_cHist := Lower("CANCELAMENTO BAIXA-"+ALLTRIM(SA1->A1_NREDUZ))
				Else 
					If Empty(ZZ->E5_PREFIXO)
						_cHist := Lower(Alltrim(ZZ->E5_NUMERO)+_cParc+ALLTRIM(SA1->A1_NREDUZ))
					Else 
						_cHist := Lower(ZZ->E5_PREFIXO+"-"+Alltrim(ZZ->E5_NUMERO)+_cParc+ALLTRIM(SA1->A1_NREDUZ))
					Endif
				Endif
			Endif
		ElseIf !Empty(ZZ->E5_FORNECE)
			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(xFilial("SA2")+ZZ->E5_FORNECE + ZZ->E5_LOJA))
				If ZZ->E5_TIPODOC = "ES"
					_cHist := Lower("CANCELAMENTO BAIXA-"+ALLTRIM(SA2->A2_NREDUZ))
				Else
					If Empty(ZZ->E5_PREFIXO)
						_cHist := Lower(Alltrim(ZZ->E5_NUMERO)+_cParc+ALLTRIM(SA2->A2_NREDUZ))
					Else 
						_cHist := Lower(ZZ->E5_PREFIXO+"-"+Alltrim(ZZ->E5_NUMERO)+_cParc+ALLTRIM(SA2->A2_NREDUZ))
					Endif
				Endif
			Endif
		Endif
		
		_lAchou := .F.
		If !Empty(ZZ->E5_FORNECE)
			SEV->(dbSetOrder(2))
			If SEV->(dbSeek(ZZ->E5_FILIAL + ZZ->E5_PREFIXO + ZZ->E5_NUMERO + ZZ->E5_PARCELA + ZZ->E5_TIPO + ZZ->E5_FORNECE + ZZ->E5_LOJA + "2"+ ZZ->E5_SEQ ))
				
				_lAchou   := .T.
				_cChavSEV := SEV->EV_FILIAL + SEV->EV_PREFIXO + SEV->EV_NUM + SEV->EV_PARCELA + SEV->EV_TIPO + SEV->EV_CLIFOR + SEV->EV_LOJA + SEV->EV_IDENT + SEV->EV_SEQ
				_nTot     := 0
				
				While SEV->(!Eof()) .And. _cChavSEV == SEV->EV_FILIAL + SEV->EV_PREFIXO + SEV->EV_NUM + SEV->EV_PARCELA + SEV->EV_TIPO + SEV->EV_CLIFOR + SEV->EV_LOJA + SEV->EV_IDENT + SEV->EV_SEQ
					
					_cValor := Str(SEV->EV_VALOR * -1,17,02)
					_cValor := StrTran(_cValor, ".",",")
					
					SZ1->(dbSetOrder(2))
					If SZ1->(dbSeek(xFilial("SZ1")+ ZZ->E5_NATUREZ + cEmpAnt + Left(cFilAnt,3)))
						_cOrigem := Alltrim(SZ1->Z1_NATSYS)
						
						CT1->(dbSetOrder(1))
						If CT1->(dbSeek(xFilial("CT1")+SZ1->Z1_CONTA))
							_cConta   := CT1->CT1_DESC01
						Endif								
					Else						
						SED->(dbSetorder(1))
						If SED->(dbSeek(xFilial("SED")+SEV->EV_NATUREZ))
							_cOrigem := Alltrim(SED->ED_YCOD)
						Endif
					Endif
					
					_cDocBx:= Space(09)
					_cStat := Space(06)
					_cGrav := DTOC(dDataBase)
					
					cCpo := PADR(_cDoc,11)+";"
					cLin := Stuff(cLin,01,12,cCpo)
					/*
					cCpo := PADR(_cCusto,05)+";"
					cLin := Stuff(cLin,13,06,cCpo)
									
					cCpo := PADR(_cCaixa,05)+";"
					cLin := Stuff(cLin,19,06,cCpo)
					*/

					cCpo := PADR(_cCaixa,05)+";"
					cLin := Stuff(cLin,13,06,cCpo)

					cCpo := PADR(_cCusto,05)+";"
					cLin := Stuff(cLin,19,06,cCpo)
									
					cCpo := PADR(_cOrigem,10)+";"
					cLin := Stuff(cLin,25,11,cCpo)
					
					cCpo := PADR(_cData,10)+";"
					cLin := Stuff(cLin,36,11,cCpo)
					
					cCpo := PADR(_cTipo,04)+";"
					cLin := Stuff(cLin,47,05,cCpo)
					
					cCpo := PADR(_cClas,13)+";"
					cLin := Stuff(cLin,52,14,cCpo)
					
					cCpo := PADR(_cValor,17)+";"
					cLin := Stuff(cLin,66,18,cCpo)
					
					cCpo := PADR(_cHist,40)+";"
					cLin := Stuff(cLin,84,41,cCpo)
					
					cCpo := PADR(_cDocBx,09)+";"
					cLin := Stuff(cLin,125,10,cCpo)
					
					cCpo := PADR(_cTrCaixa,12)+";"
					cLin := Stuff(cLin,135,13,cCpo)
					
					cCpo := PADR(_cTrCusto,12)+";"
					cLin := Stuff(cLin,148,13,cCpo)
					
					cCpo := PADR(_cTrOrigem,13)+";"
					cLin := Stuff(cLin,161,14,cCpo)
					
					cCpo := PADR(_cStat,06)+";"
					cLin := Stuff(cLin,175,07,cCpo)
					
					cCpo := PADR(_cGrav,10)+";"
					cLin := Stuff(cLin,182,11,cCpo)

					cCpo := PADR(_cConta,40)+";"
					cLin := Stuff(cLin,193,41,cCpo)
					
					If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
						If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
							Exit
						Endif
					Endif
					
					SEV->(dbSkip())
				EndDo
			Endif
		Endif
		
		If !_lAchou
			_cDocBx:= Space(09)
			_cStat := Space(06)
			_cGrav := DTOC(dDataBase)
			
			cCpo := PADR(_cDoc,11)+";"
			cLin := Stuff(cLin,01,12,cCpo)
			
			cCpo := PADR(_cCusto,05)+";"
			cLin := Stuff(cLin,13,06,cCpo)
			
			cCpo := PADR(_cCaixa,05)+";"
			cLin := Stuff(cLin,19,06,cCpo)
			
            /*
			cCpo := PADR(_cCaixa,05)+";"
			cLin := Stuff(cLin,13,06,cCpo)

			cCpo := PADR(_cCusto,05)+";"
			cLin := Stuff(cLin,19,06,cCpo)
			*/
			cCpo := PADR(_cOrigem,10)+";"
			cLin := Stuff(cLin,25,11,cCpo)
			
			cCpo := PADR(_cData,10)+";"
			cLin := Stuff(cLin,36,11,cCpo)
			
			cCpo := PADR(_cTipo,04)+";"
			cLin := Stuff(cLin,47,05,cCpo)
			
			cCpo := PADR(_cClas,13)+";"
			cLin := Stuff(cLin,52,14,cCpo)
			
			cCpo := PADR(_cValor,17)+";"
			cLin := Stuff(cLin,66,18,cCpo)
			
			cCpo := PADR(_cHist,40)+";"
			cLin := Stuff(cLin,84,41,cCpo)
			
			cCpo := PADR(_cDocBx,09)+";"
			cLin := Stuff(cLin,125,10,cCpo)
			
			cCpo := PADR(_cTrCaixa,12)+";"
			cLin := Stuff(cLin,135,13,cCpo)
			
			cCpo := PADR(_cTrCusto,12)+";"
			cLin := Stuff(cLin,148,13,cCpo)
			
			cCpo := PADR(_cTrOrigem,13)+";"
			cLin := Stuff(cLin,161,14,cCpo)
			
			cCpo := PADR(_cStat,06)+";"
			cLin := Stuff(cLin,175,07,cCpo)
			
			cCpo := PADR(_cGrav,10)+";"
			cLin := Stuff(cLin,182,11,cCpo)

			cCpo := PADR(_cConta,40)+";"
			cLin := Stuff(cLin,193,41,cCpo)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
		Endif
		
		ZZ->(dbSkip())
	EndDo
EndDo

ZZ->(dbcloseArea())

fClose(nHdl)

_cData   := DTOS(dDataBase)
_cNomArq := "\DOCS\"+_cData +".CSV"

If !__CopyFile(_cNomArq, "C:\RELSYS\PXHOL\"+_cData +".CSV" )
	MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
Endif

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "C:\RELSYS\PXHOL\"+_cData +".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Endif

Return


Static Function ATUSX1()

cPerg := "PXH004"

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02               /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De              	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"02","Data Ate             	   ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return