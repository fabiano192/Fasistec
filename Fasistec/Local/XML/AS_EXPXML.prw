#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "APWIZARD.CH"


User Function AS_EXPXML()

	Local _aWiz := {{.F., ""}}
	Local _lWiz := .F.

	Local _oGrupo_	:= Nil
	Local _oSay1_	:= Nil
	Local _oSay2_	:= Nil
	Local _oSay3_	:= Nil
	Local _oSay4_	:= Nil
	Local _oSay5_	:= Nil
	Local _oSay6_	:= Nil
	Local _oSay7_	:= Nil
	Local _oSay8_	:= Nil
	Local _oSay9_	:= Nil
	Local _oGet1_	:= Nil
	Local _oGet2_	:= Nil
	Local _oGet3_	:= Nil
	Local _oGet4_	:= Nil
	Local _oGet5_	:= Nil
	Local _oGet6_	:= Nil
	Local _oGet7_	:= Nil
	Local _oGet8_	:= Nil
	Local _oGet9_	:= Nil
	Local _oBtn1_	:= Nil
	Local _oBtn2_	:= Nil
	Local _oBtn3_	:= Nil
	Local _lOk		:= .F.
	Local _nTam		:= 14
	Local _nLin		:= 9

	Private _oAno	:= Nil
	Private _oMes	:= Nil
	Private _oDia	:= Nil
	Private _oCNPJ	:= Nil
	Private _lAno	:= .F.
	Private _lMes	:= .F.
	Private _lDia	:= .F.
	Private _lCNPJ	:= .F.
	Private _lWMes	:= .T.
	Private _lWAno	:= .T.

	Private _dDtIn	:= cTod('')
	Private _dDtFi	:= cTod('')
	Private _cNFIn	:= Space(TAMSX3("F1_DOC")[1])
	Private _cNFFi	:= PadR("",(TAMSX3("F1_DOC")[1]),"Z")
	Private _cFoIn	:= Space(TAMSX3("A1_COD")[1])
	Private _cFoFi	:= PadR("",(TAMSX3("A1_COD")[1]),"Z")
	Private _cCNPJIn:= Space(TAMSX3("A1_CGC")[1])
	Private _cCNPJFi:= PadR("",(TAMSX3("A1_CGC")[1]),"9")

	Private _cTitulo:= 'Processando'
	Private _cMsgTit:= 'Aguarde, exportando XML...'
	Private _oPar_	:= Nil
	Private _cLocOr:= Space(100)

	Private _oWizard
	Private _nPainel

	DEFINE WIZARD _oWizard TITLE "Exportação XML" HEADER "" MESSAGE " ";
	TEXT "Esta rotina tem a finalidade de exportar o XML conforme os parâmetros informados nas próximas telas.";
	PANEL;
	NEXT {|| .T.};
	FINISH {|| .T.}


	// PANEL 2
	CREATE PANEL _oWizard HEADER "Parâmetros" MESSAGE ;
	"Informe abaixo os parâmetros para filtros dos XMLs";
	PANEL;
	BACK {|| .T.};
	NEXT {|| If(Empty(_cLocOr) , (ShowHelpDlg("AS_EXPXML_1", {"Informe o conteúdo para o campo 'Local'."},2,{'Revise os parâmetros.'},2), .F.),.T.)};
	EXEC {|| .T.}

	_oGrupo_ := TGroup():New( 03,03,138,296,"",_oWizard:oMPanel[2],CLR_HRED,CLR_WHITE,.T.,.F. )

	_oSay1_	:= TSay():New( _nLin,010,{||"Local:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet1_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_cLocOr:=u,_cLocOr)},_oGrupo_,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cLocOr",,)
	_oGet1_:Disable()
	_oBtn1_	:= TBtnBmp2():New( 018,230,23,23,'PMSPESQ',,,, {||_cLocOr := cGetFile('Arquivo *|*.*','Selecione arquivo',0,'C:\',.T.,GETF_RETDIRECTORY +GETF_LOCALHARD,.F.)},_oGrupo_,'Local para gravação do XML',,.F.,.F. )

	_nLin += _nTam
	_oSay2_	:= TSay():New( _nLin,010,{||"Data de:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet2_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_dDtIn:=u,_dDtIn)},_oGrupo_,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_dDtIn",,)

	_nLin += _nTam
	_oSay3_	:= TSay():New( _nLin,010,{||"Data até:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet3_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_dDtFi:=u,_dDtFi)},_oGrupo_,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_dDtFi",,)

	_nLin += _nTam
	_oSay4_	:= TSay():New( _nLin,010,{||"Nota Fiscal de:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet4_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_cNFIn:=u,_cNFIn)},_oGrupo_,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cNFIn",,)

	_nLin += _nTam
	_oSay5_	:= TSay():New( _nLin,010,{||"Nota Fiscal Até:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet5_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_cNFFi:=u,_cNFFi)},_oGrupo_,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cNFFi",,)

	_nLin += _nTam
	_oSay6_	:= TSay():New( _nLin,010,{||"Fornecedor de:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet6_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_cFoIn:=u,_cFoIn)},_oGrupo_,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","_cFoIn",,)

	_nLin += _nTam
	_oSay7_	:= TSay():New( _nLin,010,{||"Fornecedor Até:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet7_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_cFoFi:=u,_cFoFi)},_oGrupo_,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","_cFoFi",,)

	_nLin += _nTam
	_oSay8_	:= TSay():New( _nLin,010,{||"CNPJ de:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet8_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_cCNPJIn:=u,_cCNPJIn)},_oGrupo_,060,008,'@R 99.999.999/9999-99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cCNPJIn",,)

	_nLin += _nTam
	_oSay9_	:= TSay():New( _nLin,010,{||"CNPJ Até:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet9_	:= TGet():New( _nLin,055,{|u| If(PCount()>0,_cCNPJFi:=u,_cCNPJFi)},_oGrupo_,060,008,'@R 99.999.999/9999-99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cCNPJFi",,)




	// PANEL 3
	CREATE PANEL _oWizard HEADER "Agrupamento" MESSAGE '' PANEL;
	BACK {|| .T.};
	FINISH {|| _lOk := .T.};
	EXEC {|| .T.}

	_oGrupo_ := TGroup():New( 03,03,138,296,"",_oWizard:oMPanel[3],CLR_HRED,CLR_WHITE,.T.,.F. )

	_oSay9_	:= TSay():New( 010,010,{||"Selecione abaixo como os arquivos serão agrupados::"},_oWizard:oMPanel[3],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)

	_nLin := 30
	_oAno := TCheckBox():New(_nLin,10,'Agrupar por Ano',bSETGET(_lAno)/*	{||_lAno}*/,_oWizard:oMPanel[3],100,210,,,,,,,,.T.,,,{||_lWAno})
	_nLin += _nTam
	_oMes := TCheckBox():New(_nLin,10,'Agrupar por Mês',bSETGET(_lMes),_oWizard:oMPanel[3],100,210,,{||CheckBox("M")},,,,,,.T.,,,{||_lWMes})
	_nLin += _nTam
	_oDia := TCheckBox():New(_nLin,10,'Agrupar por Dia',bSETGET(_lDia),_oWizard:oMPanel[3],100,210,,{||CheckBox("D")},,,,,,.T.,,,)
	_nLin += _nTam
	_oCNPJ:= TCheckBox():New(_nLin,10,'Agrupar por CNPJ',bSETGET(_lCNPJ),_oWizard:oMPanel[3],100,210,,,,,,,,.T.,,,/*18*/)

//	_oWizard:oDlg:lEscClose := .F.

	ACTIVATE WIZARD _oWizard CENTERED

	If _lOk
		FWMsgRun(, {|_oMsg| ExportaXML(_oMsg) }, _cTitulo, _cMsgTit )
	Endif

Return(Nil)




Static Function CheckBox(_cOpc)

	If _cOpc = "M"
		If _lMes
			_lWAno := .F.
			_lAno  := .T.
		Else
			_lWAno := .T.
		Endif
	ElseIf _cOpc = "D"
		If _lDia
			_lWMes := .F.
			_lMes  := .T.
			_lWAno := .F.
			_lAno  := .T.
		Else
			_lWMes := .T.
		Endif
	Endif

	_oAno:Refresh()
	_oMes:Refresh()
	_oDia:Refresh()

	_oAno:SetFocus()

Return(Nil)



Static Function ExportaXML(_oMsg)

	Local _cQry_	:= ""
	Local _AreaZA1	:= ZA1->(GetArea())
	Local _cAno		:= ""
	Local _cMes		:= ""
	Local _cDia		:= ""
	Local _cCNPJ	:= ""
	Local _cLocAtu	:= ""
	Local _cPath	:= ""
	Local _nTZA1A	:= 0


	If Select("TZA1A") > 0
		TZA1A->(dbCloseArea())
	Endif

	_cQry_ := " SELECT ZA1.R_E_C_N_O_ AS RECNO,ZA1_EMISSA,ZA1_CNPJ FROM "+RetSqlName("ZA1")+" ZA1 " +CRLF
	_cQry_ += " WHERE ZA1.D_E_L_E_T_ = '' " +CRLF
	_cQry_ += " AND ZA1_FILIAL = '"+xFilial("ZA1")+"' " +CRLF
	_cQry_ += " AND ZA1_EMISSA	BETWEEN '"+dTos(_dDtIn)+"' AND '"+dTos(_dDtFi)+"' " +CRLF
	_cQry_ += " AND ZA1_DOC		BETWEEN '"+_cNFIn+"' AND '"+_cNFFi+"' " +CRLF
	_cQry_ += " AND ZA1_FORNEC	BETWEEN '"+_cFoIn+"' AND '"+_cFoFi+"' " +CRLF
	_cQry_ += " AND ZA1_CNPJ	BETWEEN '"+_cCNPJIn+"' AND '"+_cCNPJFi+"' " +CRLF
	_cQry_ += " ORDER BY ZA1_EMISSA,ZA1_CNPJ " +CRLF

	TcQuery _cQry_ New Alias "TZA1A"

	TcSetField("TZA1A","ZA1_EMISSA","D")

	Count to _nTZA1A

	If _nTZA1A > 0
		TZA1A->(dbGoTop())

		While !TZA1A->(EOF())

			_cLocAtu := _cLocOr+"\"
			_cPath	 := _cLocAtu

			_cAno	:= Alltrim(Str(Year(TZA1A->ZA1_EMISSA)))
			If _lAno
				_cPath	:= _cLocAtu+_cAno+"\"

				If !ExistDir(_cPath)
					If MakeDir(_cPath) <> 0
						MsgAlert("Nao foi possível criar o diretório "+_cPath)
						Return(Nil)
					Endif
				Endif
			Endif

			While !TZA1A->(EOF()) .And. _cAno == Alltrim(Str(Year(TZA1A->ZA1_EMISSA)))

				_cMes	:= MesExtenso(Month(TZA1A->ZA1_EMISSA))
				If _lMes
					_cPath	:= _cLocAtu
					If _lAno
						_cPath	+= _cAno+"\"
					Endif

					_cPath	+= _cMes+"\"

					If !ExistDir(_cPath)
						If MakeDir(_cPath) <> 0
							MsgAlert("Nao foi possível criar o diretório "+_cPath)
							Return(Nil)
						Endif
					Endif
				Endif

				While !TZA1A->(EOF()) .And. _cAno == Alltrim(Str(Year(TZA1A->ZA1_EMISSA))) .And. _cMes == MesExtenso(Month(TZA1A->ZA1_EMISSA))

					_cDia	:= Strzero(Day(TZA1A->ZA1_EMISSA),2)
					If _lDia
						_cPath	:= _cLocAtu
						If _lAno
							_cPath	+= _cAno+"\"
						Endif

						If _lMes
							_cPath	+= _cMes+"\"
						Endif

						_cPath	+= _cDia+"\"

						If !ExistDir(_cPath)
							If MakeDir(_cPath) <> 0
								MsgAlert("Nao foi possível criar o diretório "+_cPath)
								Return(Nil)
							Endif
						Endif
					Endif

					While !TZA1A->(EOF()) .And. _cAno == Alltrim(Str(Year(TZA1A->ZA1_EMISSA))) .And._cMes == MesExtenso(Month(TZA1A->ZA1_EMISSA)) .And. _cDia == Strzero(Day(TZA1A->ZA1_EMISSA),2)

						_cCNPJ	:= TZA1A->ZA1_CNPJ
						If _lCNPJ

							_cPath	:= _cLocAtu
							If _lAno
								_cPath	+= _cAno+"\"
							Endif

							If _lMes
								_cPath	+= _cMes+"\"
							Endif

							If _ldia
								_cPath	+= _cDia+"\"
							Endif

							_cPath	+= _cCNPJ+"\"

							If !ExistDir(_cPath)
								If MakeDir(_cPath) <> 0
									MsgAlert("Nao foi possível criar o diretório "+_cPath)
									Return(Nil)
								Endif
							Endif
						Endif

						While !TZA1A->(EOF()) .And. _cAno == Alltrim(Str(Year(TZA1A->ZA1_EMISSA))) .And._cMes == MesExtenso(Month(TZA1A->ZA1_EMISSA)) .And.;
						_cDia == Strzero(Day(TZA1A->ZA1_EMISSA),2) .And. _cCNPJ == TZA1A->ZA1_CNPJ

							ZA1->(dbgoTo(TZA1A->RECNO))

							GravaXML(_oMsg,_cPath)

							TZA1A->(dbSkip())
						EndDo
					EndDo
				EndDo
			EndDo

		EndDo

		MsgInfo("Exportação Concluída!")
	Else
		ShowHelpDlg("AS_EXPXML_2", {'Não foram encontrados dados de acordo com os parâmetros informados.'},2,{'Revise os parâmetros.'},2)
	Endif

	TZA1A->(dbCloseArea())

	RestArea(_AreaZA1)

Return(Nil)



Static Function GravaXML(_oMsg,_cPath)

	_oMsg:cCaption := ('Exportando XML '+Alltrim(ZA1->ZA1_CHAVE))
	ProcessMessages()

	_cArquivo := Alltrim(ZA1->ZA1_CHAVE)+".xml"

	_nHandle := FCreate(_cPath + "\" + _cArquivo)

	If _nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
		RESTINTER()
	Endif

	_cBuffer := ZA1->ZA1_XML

	FWrite(_nHandle, _cBuffer)

	FClose(_nHandle)

Return(Nil)

/*
DEFINE MsDIALOG _oPar_ TITLE "Exportar XML" FROM 0,0 TO 250,300 Of _oPar_ PIXEL

_oGrupo_ := TGroup():New( 05,05,120,140,"Parâmetros",_oPar_,CLR_HRED,CLR_WHITE,.T.,.F. )

_oSay1_	:= TSay():New( 015,010,{||"Data de:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
_oGet1_	:= TGet():New( 015,055,{|u| If(PCount()>0,_dDtIn:=u,_dDtIn)},_oGrupo_,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_dDtIn",,)

_oSay2_	:= TSay():New( 030,010,{||"Data até:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
_oGet2_	:= TGet():New( 030,055,{|u| If(PCount()>0,_dDtFi:=u,_dDtFi)},_oGrupo_,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_dDtFi",,)

_oSay3_	:= TSay():New( 045,010,{||"Nota Fiscal de:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
_oGet3_	:= TGet():New( 045,055,{|u| If(PCount()>0,_cNFIn:=u,_cNFIn)},_oGrupo_,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cNFIn",,)

_oSay4_	:= TSay():New( 060,010,{||"Nota Fiscal Até:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
_oGet4_	:= TGet():New( 060,055,{|u| If(PCount()>0,_cNFFi:=u,_cNFFi)},_oGrupo_,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cNFFi",,)

_oSay5_	:= TSay():New( 075,010,{||"Local:"},_oGrupo_,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
_oGet5_	:= TGet():New( 075,055,{|u| If(PCount()>0,_cLocOr:=u,_cLocOr)},_oGrupo_,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cLocOr",,)
_oGet5_:Disable()
//	_oBtn3_	:= TButton():New( 075,115,"Procurar",_oGrupo_	, &(_bLocal),050,012,,,,.T.,,"",,,,.F. )
_oBtn3_	:= TBtnBmp2():New( 150,213,23,23,'PMSPESQ',,,, {||_cLocOr := cGetFile('Arquivo *|*.*','Selecione arquivo',0,'C:\',.T.,GETF_RETDIRECTORY +GETF_LOCALHARD,.F.)},_oGrupo_,'Local para gravação do XML',,.F.,.F. )


_oBtn1_	:= TButton():New( 100,010,"Fechar"	,_oGrupo_	, &(_bClose),050,012,,,,.T.,,"",,,,.F. )
_oBtn2_	:= TButton():New( 100,070,"OK"		,_oGrupo_	, &(_bOK)	,050,012,,,,.T.,,"",,,,.F. )

ACTIVATE MSDIALOG _oPar_ CENTERED
*/
