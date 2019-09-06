#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"


/*
Ponto de Entrada: M410LIOK
Autor			: Fabiano da Silva
Data Criação	: 29/06/15
Descrição 		: VALIDAÇÃO DE LINHA DO PEDIDO VENDA. Validação de linha no pedido de venda.
TDN				: http://tdn.totvs.com/pages/releaseview.action?pageId=6784149
*/
User Function M410LIOK()

	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	_aAliSA1 := SA1->(GetArea())

	_nPPedCli  := Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PEDCLI" 	} )
	_nPPOLine  := Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_POLINE" 	} )
	_nPItem    := Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM" 	} )

	_lRet := .T.

	If M->C5_CLIENTE $ GETMV('CR_LINEPO')

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1')+M->C5_CLIENTE+M->C5_LOJACLI))

		If SA1->A1_EST <> 'EX'
			If Empty(aCols[n][_nPPedCli])
				MsgAlert('Preencher o campo "Ped Cliente" para o Item: '+aCols[n][_nPItem])
				_lRet := .F.
			ElseIf Empty(aCols[n][_nPPOLine])
				MsgAlert('Preencher o campo "Linha Pedido" para o Item: '+aCols[n][_nPItem])
				_lRet := .F.
			Endif
		Endif
	Endif

	RestArea(_aAliSA1)
	RestArea(_aAliSC6)
	RestArea(_aAliSC5)
	RestArea(_aAliOri)

Return(_lRet)



/*
Programa  :	M460FIM
Descrição :	PONTO DE ENTRADA EXECUTADO APOS A GERACAO E GRAVACAO DO DOCUMENTO DE SAIDA (NF)
*/
User Function M460Fim()

	Local _aAliOri	:= GetArea()
	Local _aAliSF2	:= SF2->(GetArea())
	Local _aAliSA1	:= SA1->(GetArea())
	Local _oDlg		:= Nil
	Local _oGroup	:= Nil
	Local _oTButOk	:= Nil
	Local _oTBar	:= Nil
	Local _oTBtnBmp	:= Nil
	Local _nOpc		:= 0
	Local _oVol1	:= _oPLi1 := _oPBr1 := Nil
	Local _oVol2	:= _oPLi2 := _oPBr2 := Nil

	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA))

	//	If SF2->F2_TIPO = 'N' .And. !SF2->F2_CLIENTE $ '000017|000018' .And. SA1->A1_TIPOCLI <> 'X'
	If SF2->F2_TIPO = 'N'

		_cKey := SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA

		SD2->(dbSetOrder(3))
		If SD2->(msSeek(xFilial("SD2")+_cKey))

			_nPeso:= 0

			While !SD2->(EOF()) .And. _cKey == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

				If SA1->A1_TIPOCLI <> 'X' .And. !SF2->F2_CLIENTE $ '000017'
					SB1->(dbsetOrder(1))
					If SB1->(msSeek(xFilial("SB1")+SD2->D2_COD))
						_nPeso += (SD2->D2_QUANT * SB1->B1_PESO)
					Endif
				Endif

				_aMolde := {}
				nEstru	:= 0
				_aStru	:= u_Estrut(SD2->D2_COD,1,.F.,.F.)

				For E:= 1 To Len(_aStru)
					SB1->(dbSetOrder(1))
					If SB1->(msSeek(xFilial("SB1")+_aStru[E,3]))
						If SB1->B1_GRUPO $ "FRVC/FRVI/FRVT/FRFG/FRES/FRPU"   // Molde de Vulcanização / Ferramenta
							If aScan(_aMolde,{|x| x[1] = SB1->B1_COD}) = 0
								AAdd(_aMolde, {SB1->B1_COD,(SB1->B1_CAVMOO - SB1->B1_CAVMOR)})
							Endif
						Endif
					Endif
				Next E

				For N:= 1 to Len(_aMolde)

					_nQtPrens := INT(SD2->D2_QUANT/_aMolde[N][2])

					SZL->(dbSetOrder(1))
					If !SZL->(msSeek(xFilial("SZL")+_aMolde[N][1]))
						SZL->(Reclock("SZL",.T.))
						SZL->ZL_FILIAL	:= xFilial("SZL")
						SZL->ZL_MOLDE	:= _aMolde[N][1]
						SZL->ZL_VDUTIL	:= 3000
						SZL->ZL_QTPRENS	:= _nQtPrens
						SZL->ZL_DIF		:= 3000 - _nQtPrens
						SZL->ZL_DATA	:= dDatabase
						SZL->(MsUnLock())
					Else

						SZL->(Reclock("SZL",.F.))
						SZL->ZL_QTPRENS	+= _nQtPrens
						SZL->ZL_DIF		:= SZL->ZL_VDUTIL - SZL->ZL_QTPRENS
						SZL->(MsUnLock())
					Endif

					SZM->(Reclock("SZM",.T.))
					SZM->ZM_FILIAL	:= xFilial("SZM")
					SZM->ZM_MOLDE	:= _aMolde[N][1]
					SZM->ZM_DATA	:= SD2->D2_EMISSAO
					SZM->ZM_PRODUTO	:= SD2->D2_COD
					SZM->ZM_SERIE	:= SD2->D2_SERIE
					SZM->ZM_DOC		:= SD2->D2_DOC
					SZM->ZM_ITEMNF	:= SD2->D2_ITEM
					SZM->ZM_QTNF	:= SD2->D2_QUANT
					SZM->ZM_QTPRENS	:= _nQtPrens
					SZM->ZM_CAV		:= _aMolde[N][2]
					SZM->ZM_TIPO	:= 'S'
					SZM->ZM_USUARIO	:= Capital(UsrFullName(RetCodUsr()))
					SZM->(MsUnLock())

				Next N

				SD2->(dbSkip())
			EndDo

			If SA1->A1_TIPOCLI <> 'X' .And. !SF2->F2_CLIENTE $ '000017'
				Private _nVol1	:= SF2->F2_VOLUME1
				Private _nPLi1	:= SF2->F2_PLIQUI
				Private _nPBr1	:= SF2->F2_PBRUTO
				Private _nVol2	:= SF2->F2_VOLUME1
				Private _nPLi2	:= _nPeso
				Private _nPBr2	:= _nPeso
				Private _bOk	:= "{ || If(_nVol2  = 0 .Or. _nPLi2 = 0 .or. _nPBr2 = 0,MsgAlert('É obrigatório o preenchimento de todos os campos!') ,If(_nPBr2 < _nPLi2 , MsgAlert('Peso Líquido não pode ser maior que o Peso Bruto!'),(_nOpc:=1,_oDlg:End()))) }"

				Define MsDialog _oDlg  FROM 0,0 TO 215,380 TITLE ("NF: "+Alltrim(SF2->F2_DOC)) OF _oDlg PIXEL STYLE DS_MODALFRAME

				_oTBar := TBar():New( _oDlg,25,32,.T.,,,,.F. )

				_oTBtnBmp := TBtnBmp2():New( 00, 00, 35, 25, 'OK'	,,,,&(_bOk), _oTBar, 'OK',,.F.,.F.)

				_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

				_oGrup1	:= TGroup():New( 015,005,035,185,"Introdução",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

				@ 23,10 SAY "Informe abaixo o Volume e o Peso da NF."	OF _oGrup1 PIXEL

				_oGrup2	:= TGroup():New( 037,005,067,185,"Dados Atuais",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

				@ 45,010  SAY "Volume:"			OF _oGrup2 PIXEL
				@ 45,065  SAY "Peso Líquido:"	OF _oGrup2 PIXEL
				@ 45,135  SAY "Peso Bruto:"		OF _oGrup2 PIXEL

				@ 52,010  MsGet _oVol1 VAR _nVol1 Picture "@e 9,999"		When .F. OF _oGrup2 PIXEL Size 030, 010
				@ 52,065  MsGet _oPLi1 VAR _nPLi1 Picture "@e 9,999.999"	When .F. OF _oGrup2 PIXEL Size 030, 010
				@ 52,135  MsGet _oPBr1 VAR _nPBr1 Picture "@e 9,999.999"	When .F. OF _oGrup2 PIXEL Size 030, 010

				_oGrup3	:= TGroup():New( 069,005,099,185,"Novos Dados",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

				@ 77,010  SAY "Volume:"			OF _oGrup2 PIXEL
				@ 77,065  SAY "Peso Líquido:"	OF _oGrup2 PIXEL
				@ 77,135  SAY "Peso Bruto:"		OF _oGrup2 PIXEL

				@ 84,010  MsGet _oVol2 VAR _nVol2 Picture "@e 9,999"		When .T. OF _oGrup3 PIXEL Size 030, 010
				@ 84,065  MsGet _oPLi2 VAR _nPLi2 Picture "@e 9,999.999"	When .T. OF _oGrup3 PIXEL Size 030, 010
				@ 84,135  MsGet _oPBr2 VAR _nPBr2 Picture "@e 9,999.999"	When .T. OF _oGrup3 PIXEL Size 030, 010

				ACTIVATE MSDIALOG _oDlg CENTERED

				If _nOpc == 1

					SF2->(RecLock("SF2",.F.))
					SF2->F2_VOLUME1 := _nVol2
					SF2->F2_PLIQUI  := _nPLi2
					SF2->F2_PBRUTO  := _nPBr2
					SF2->(MsUnLock())

				Endif
			Endif

		Endif
	Endif

	RestArea(_aAliSA1)
	RestArea(_aAliSF2)
	RestArea(_aAliOri)

Return(Nil)




/*/{Protheus.doc} M460MARK
//Descricao : Ponto de entrada na rotina de Documento de Saída (MATA460)
no momento em que é pressionado o botão Prepara Docs
ThisMark() retorna a chave C9_OK para descobrir os itens
que foram marcados pelo usuário.
@author Fabiano
@since 15/08/2017
@version 1.0
@type function
/*/
User Function M460MARK()

	Local _AreaOri	:= GetArea()
	Local _AreaSC9	:= SC9->(GetArea())
	Local _AreaSB1	:= SB1->(GetArea())
	Local _lRet		:= .T.
	Local _cQuery
	Local _cAlias	:= CriaTrab(Nil,.F.)

	If Alltrim(FunName()) = 'MATA460A'

		_cQuery := " SELECT * FROM "+RETSQLNAME("SC9")+" C9 " +CRLF
		_cQuery += " WHERE C9_FILIAL = '"+xFilial("SC9")+"' " +CRLF
		_cQuery += " AND C9.D_E_L_E_T_ = '' " +CRLF
		_cQuery += " AND C9_NFISCAL = '' " +CRLF
		_cQuery += " AND C9_OK = '"+ThisMark()+"' " +CRLF

		TcQuery _cQuery NEW ALIAS (_cAlias)

		(_cAlias)->(dbGoTop())

		While !(_cAlias)->(Eof())

			_aMolde := {}
			nEstru	:= 0
			_aStru	:= u_Estrut((_cAlias)->C9_PRODUTO,1,.F.,.F.)

			For E:= 1 To Len(_aStru)
				SB1->(dbSetOrder(1))
				If SB1->(msSeek(xFilial("SB1")+_aStru[E,3]))
					If SB1->B1_GRUPO $ "FRVC/FRVI/FRVT/FRFG/FRES/FRPU"   // Molde de Vulcanização / Ferramenta
						If aScan(_aMolde,{|x| x[1] = SB1->B1_COD}) = 0
							AAdd(_aMolde, {SB1->B1_COD,(SB1->B1_CAVMOO - SB1->B1_CAVMOR)})
						Endif
					Endif
				Endif
			Next E

			For N:= 1 to Len(_aMolde)

				SZL->(dbSetOrder(1))
				If !SZL->(msSeek(xFilial("SZL")+_aMolde[N][1]))
					_lRet := .F.
					ShowHelpDlg("M460MARK_1", {'Molde não cadastrado no controle de ferramental:','',;
					'Produto: '+Alltrim((_cAlias)->C9_PRODUTO),'Molde: '+_aMolde[N][1]},4,;
					{'Solicite o ajuste do cadastro de ferramental ao setor de Engenharia.'},2)
				Else
					If SZL->ZL_DIF	< 0
						_lRet := .F.
						ShowHelpDlg("M460MARK_2", {'Não é permitido a geração de NF para:','',;
						'Produto: '+Alltrim((_cAlias)->C9_PRODUTO),'Molde: '+_aMolde[N][1]},4,;
						{'Solicite o ajuste do cadastro de ferramental ao setor de Engenharia.'},2)
					Endif
				Endif

			Next N

			SB1->(dbSetOrder(1))
			If SB1->(msSeek(xFilial("SB1")+(_cAlias)->C9_PRODUTO))
				If SB1->B1_TIPO = 'PA'
					If SB1->B1_PESO <= 0 .Or. SB1->B1_PESO > 100
						_lRet := .F.
						ShowHelpDlg("M460MARK_3", {'Não é permitido a geração de NF para o item '+Alltrim((_cAlias)->C9_PRODUTO)+;
						', pois está com o peso incorreto no cadastro de Produto'},1,;
						{'Solicite o ajuste do peso do Produto.'},1)
					Endif
				ELSE
					If SB1->B1_PESO > 10000
						_lRet := .F.
						ShowHelpDlg("M460MARK_4", {'Não é permitido a geração de NF para o item '+Alltrim((_cAlias)->C9_PRODUTO)+;
						', pois está com o peso incorreto no cadastro de Produto'},1,;
						{'Solicite o ajuste do peso do Produto.'},1)
					Endif
				Endif
			Endif

			(_cAlias)->(dbSkip())

		EndDo

		(_cAlias)->(dbCloseArea())

	Endif

	RestArea(_AreaSC9)
	RestArea(_AreaSB1)
	RestArea(_AreaOri)

Return(_lRet)
