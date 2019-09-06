#INCLUDE 'TOTVS.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWIZARD.CH"

/*/{Protheus.doc} CR0115
//Rotina para ajuste de estoque - Quantidade ou Valor
@author Fabiano
@since 25/07/2018
@type function
/*/
User Function CR0115()

	Local _oBmpA := Nil
	Local _aWiz := {{.F., ""}}
	Local _lWiz := .F.
	Local _lCheck := .F.

	Private _oWizard
	Private _nPainel

	Private _cArq	:= Space(200)
	Private _cFile	:= Space(200)
	Private _oArq	:= Nil
	Private _cDir	:= '\Ajuste_Estoque\'+cEmpAnt+'\'

	Private _dDtFec	:= cTod('')
	Private _oDtFec	:= Nil
	Private _dDtUlM	:= GetMv("MV_ULMES")

	Private _oTpAj	:= Nil
	Private _aTpAj	:= {'Quantidade','Valor'}
	Private _cTpAj	:= 'Quantidade'


	DEFINE WIZARD _oWizard TITLE "Fechamento Estoque" HEADER "Ajuste Fechamento Estoque" MESSAGE " ";
	TEXT "Esta rotina tem a finalidade de realizar ajuste antes do fechamento de estoque, conforme o arquivo .csv que será importado."+CRLF+CRLF+;
	"Veja a seguir como o arquivo deve ser configurado.";
	PANEL;
	NEXT {|| .T.};
	FINISH {|| .T.}


	// PANEL 2
	CREATE PANEL _oWizard HEADER "Configuração do arquivo" MESSAGE ;
	"O arquivo deve ser gerado no Excel conforme as colunas abaixo.";
	PANEL;
	BACK {|| .T.};
	NEXT {|| .T.};
	FINISH {|| .T.};
	EXEC {|| .T.}

	_oBmpA := TBitmap():New( 005,050,210,110,,"\Ajuste_Estoque\Images\Excel_01.png",.T.,_oWizard:oMPanel[2],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oBmpA:lAutoSize:= .T.

	// PANEL 3
	//cria um novo passo (janela) para o wizard
	CREATE PANEL _oWizard HEADER "Formato arquivo" MESSAGE "O arquivo deve ser saldo no formato .csv, conforme abaixo." PANEL;
	BACK {|| _oWizard:nPanel := 3, .T.};
	NEXT {|| .T.};
	FINISH {|| .T.}

	_oBmpA := TBitmap():New( 000,060,080,130,,"\Ajuste_Estoque\Images\Excel_03.png",.T.,_oWizard:oMPanel[3],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oBmpA:lAutoSize:= .T.



	// PANEL 4
	//cria um novo passo (janela) para o wizard
	CREATE PANEL _oWizard HEADER "Arquivo CSV" MESSAGE "Após salvar o arquivo, o mesmo deverá ficar conforme a imagem abaixo, sendo separado cada coluna pelo ';'." PANEL;
	BACK {|| _oWizard:nPanel := 4, .T.};
	NEXT {|| .T.};
	EXEC {|| .T.}

	_oBmpA := TBitmap():New( 000,060,146,130,,"\Ajuste_Estoque\Images\Excel_02.png",.T.,_oWizard:oMPanel[4],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oBmpA:lAutoSize:= .T.


	// PANEL 5
	//cria um novo passo (janela) para o wizard
	CREATE PANEL _oWizard HEADER "Informações Adicionais" MESSAGE "Veja abaixo os detalhes adicionais que devem ser considerados." PANEL;
	BACK {|| _oWizard:nPanel := 5, .T.};
	NEXT {|| .T.};
	EXEC {|| .T.}

	@ 005, 005 TO 130,290 OF _oWizard:oMPanel[5] PIXEL

	@ 010, 010 SAY "Observações Gerais:" 																	OF _oWizard:oMPanel[5] PIXEL COLOR CLR_HBLUE
	@ 025, 010 SAY "1) O arquivo deve conter exatamente as colunas descritas anteriormente;" 				OF _oWizard:oMPanel[5] PIXEL
	@ 035, 010 SAY "2) O código do produto deve ser exatamente conforme cadastrado no sistema, inclusive com os 'zeros' à esquerda"		OF _oWizard:oMPanel[5] PIXEL
	@ 045, 010 SAY "3) Nas colunas do tipo 'numérico' não precisa conter separador de milhares;" 			OF _oWizard:oMPanel[5] PIXEL
	@ 055, 010 SAY "4) A ordem das colunas não pode ser ser alterada;" 										OF _oWizard:oMPanel[5] PIXEL
	@ 065, 010 SAY "5) A coluna 'TIPO' define o tipo de ajuste, sendo 'V' = Valor e 'Q' = Quantidade;"		OF _oWizard:oMPanel[5] PIXEL
	@ 075, 010 SAY "6) No arquivo é necessário que contenha somente os itens com diferença, seja de Quantidade ou Valor;" 		OF _oWizard:oMPanel[5] PIXEL
	@ 085, 010 SAY "6) Após finalizar o ajuste, rodar a rotina 'Refaz Saldo' para ajustar o saldo atual;"	OF _oWizard:oMPanel[5] PIXEL COLOR CLR_GREEN
	@ 095, 010 SAY "7) Caso seja necessário realizar ajuste de Quantidade e Valor, obrigatoriamente deverá 1º realizar o Ajuste de"		OF _oWizard:oMPanel[5] PIXEL COLOR CLR_HRED
	@ 105, 010 SAY "   Quantidade, depois fazer a análise do custo para enfim ajustar o valor final."		OF _oWizard:oMPanel[5] PIXEL COLOR CLR_HRED

	_nPainel := 6


	// PANEL 6
	CREATE PANEL _oWizard HEADER "Parâmetros" MESSAGE '' PANEL;
	BACK {|| _oWizard:nPanel := _nPainel, .T.};
	NEXT {|| .T.};
	FINISH {|| If(!Empty(_cArq) .And. !Empty(_dDtFec),(_lWiz := .T.,.T.),(ShowHelpDlg("CR0115A", {'Parâmetros não preenchidos.'},1,{'Preencha todos os parâmetros da tela.'},1),.F.)) };
	EXEC {|| .T.}

	@ 005, 005 TO 130,290 OF _oWizard:oMPanel[_nPainel] PIXEL

	@ 020, 010 SAY "Selecione abaixo o arquivo à ser importado:" OF _oWizard:oMPanel[_nPainel] PIXEL

	_oTButton	:= TButton():New( 040, 010, "Arquivo"	,_oWizard:oMPanel[_nPainel],{||CR115Arq(@_cArq,@_cFile)}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	@ 040, 080 GET _oArq VAR _cArq When .F. OF _oWizard:oMPanel[_nPainel] SIZE 200,009 PIXEL

	@ 060, 010 SAY "Data Fechamento:" OF _oWizard:oMPanel[_nPainel] PIXEL
	@ 060, 080 GET _oDtFec VAR _dDtFec Valid CR115VALID() OF _oWizard:oMPanel[_nPainel] SIZE 80,009 PIXEL

	@ 080, 010 SAY "Tipo Ajuste:" OF _oWizard:oMPanel[_nPainel] PIXEL
	@ 080, 080 MsCOMBOBOX _oTpAj 	VAR _cTpAj ITEMS _aTpAj Size 80,04  PIXEL OF _oWizard:oMPanel[_nPainel]

	ACTIVATE WIZARD _oWizard CENTERED

	If _lWiz
		MsgRun("Processando arquivo, aguarde...",'Ajuste Fechamento de Estoque',{||  CR115Proc(_cArq,_cFile) })
	EndIf

Return(Nil)



/*/{Protheus.doc} CR115Arq
seleção do arquivo .csv
/*/
Static Function CR115Arq(_cArq,_cFile)

	_cArq := cGetFile('Arquivo CSV|*.csv','Selecione arquivo',0,'C:\',.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD,.F.)

	If !Empty(_cArq)

		_aName := StrTokArr( _cArq , "\" )
		_cFile := dtos(dDataBase)+'_'+StrTran(Time(),':','')+'_'+_aName[Len(_aName)]
	Endif

Return()


Static Function CR115VALID()

	Local _lRet := .T.

	_nMesUl := Month(_dDtUlM)+1
	_nAnoUl := Year(_dDtUlM)
	If Month(_dDtUlM)+1 = 13
		_nMesUl := 1
		_nAnoUl ++
	Endif

	If _nMesUl <> Month(_dDtFec) .Or. _nAnoUl <> Year(_dDtFec) .Or. (LastDay(_dDtFec) <> _dDtFec)
		ShowHelpDlg("CR0115B", {'Data digitada é diferente do Fechamento à ser realizado.'},1,{'Não se aplica.'},1)
		_dDtFec := ctod('')
		_oDtFec:Refresh()
	Endif

Return(_lRet)



Static Function CR115Proc(_cArq,_cFile)

	Local _cBuffer	:= ""
	Local _aLin		:= {}
	Local _aLinBkp	:= {}
	Local _nLin		:= 0
	Local _lQtde	:= .F.
	Local _lValor	:= .F.

	Private _aCab1	:= {}
	Private _aIt1	:= {}
	Private _aCab2	:= {}
	Private _aIt2	:= {}
	Private _aCab3	:= {}
	Private _aIt3	:= {}
	Private _aCab4	:= {}
	Private _aIt4	:= {}
	Private _aSB1	:= {}
	Private _cTp	:= ''
	Private _nFor	:= 0

	If !__CopyFile(_cArq, _cDir+_cFile )
		MsgInfo('Não foi possível copiar o arquivo para o servidor: '+_cArq)
		Return(Nil)
	Endif

	If !OpenFile( _cDir, _cFile )
		MsgStop("Não foi possível a abrir o arquivo " + _cFile)
	Else

		// Abre o arquivo
		FT_FUSE( _cDir+_cFile )
		FT_FGOTOP()

		Begin Transaction

			Do While !FT_FEOF()

				_nLin++

				_cBuffer := FT_FREADLN()

				_aLinBKP := _aLin
				_aLin    := StrTokArr2( _cBuffer , ";" ,.T.)

				If Len(_aLin) < 7
					MsgAlert('Quantidade de colunas na linha '+cValToChar(_nLin)+' menor de 7. Está faltando alguma coluna no arquivo.')
					DisarmTransaction()
					Return()
				Endif

				If _nLin > 1

					/*
					_aLin[1] = Produto
					_aLin[2] = Tipo
					_aLin[3] = Grupo
					_aLin[4]  = UM
					_aLin[5] = Armazém
					_aLin[6] = Diferença
					_aLin[7] = Tipo Ajuste
					*/

					_cProd		:= Padr(_aLin[1],TamSX3('B1_COD')[1])
					_cTipo		:= Padr(_aLin[2],TamSX3('B1_TIPO')[1])
					_cGrup		:= Padr(_aLin[3],TamSX3('B1_GRUPO')[1])
					_cUM		:= Padr(_aLin[4],TamSX3('B1_UM')[1])
					_cArm		:= Padr(_aLin[5],TamSX3('B1_LOCPAD')[1])
					_cAjuste	:= Padr(_aLin[7],1)

					SB1->(dbSetOrder(1))
					If !SB1->(msSeek(xFilial("SB1")+_cProd))
						MsgAlert('Não encontrado o Produto '+Alltrim(_cProd)+' na linha '+cValToChar(_nLin)+'.')
						DisarmTransaction()
						Return()
					Endif

					If SB1->B1_MSBLQL = "1"
						SB1->(RecLock("SB1",.F.))
						SB1->B1_MSBLQL := "2"
						SB1->(MsUnLock())

						AADD(_aSB1,SB1->B1_COD)
					Endif

					If _cTpAj = "Quantidade"

						If _cAjuste = "V"
							FT_FSKIP()
							Loop
						Endif

						_cQtde		:= STRTRAN(_aLin[6],'.','')
						_nQtde		:= Val(STRTRAN(_cQtde,',','.'))

						If _nQtde > 0
							_cTp	:= "1"
							_cTm	:= '501'//Requisição Qtde
						ElseIf _nQtde < 0
							_cTp	:= "2"
							_cTm	:= '100'//Devolução Qtde
						Endif

						If Empty(&("_aCab"+_cTp))
							AAdd(&("_aCab"+_cTp),{"D3_DOC" 		, "Q"+Right(DTOS(_dDtFec),6)+'_'+_cTp	,NIL})
							AAdd(&("_aCab"+_cTp),{"D3_TM" 		, _cTM								,NIL})
							AAdd(&("_aCab"+_cTp),{"D3_EMISSAO"	, _dDtFec							,NIL})
						Endif

						AAdd(&("_aIt"+_cTp),{;
						{"D3_COD"	, _cProd		,NIL},;
						{"D3_QUANT"	, ABS(_nQtde)	,NIL},;
						{"D3_LOCAL"	, _cArm			,Nil},;
						{"D3_GRUPO"	, _cGrup		,Nil}})


					ElseIf _cTpAj = "Valor"

						If _cAjuste = "Q"
							FT_FSKIP()
							Loop
						Endif

						_cValor		:= STRTRAN(_aLin[6],'.','')
						_nValor		:= Val(STRTRAN(_cValor,',','.'))

						If _nValor > 0
							_cTp	:= "3"
							_cTm	:= '502'//Requisição Valor
						ElseIf _nValor < 0
							_cTp	:= "4"
							If cEmpAnt = "01"
								_cTm	:= '102' //Devolução Valor
							Else
								_cTm	:= '103' //Devolução Valor
							Endif
						Endif

						If Empty(&("_aCab"+_cTp))
							AAdd(&("_aCab"+_cTp),{"D3_DOC" 		, "V"+Right(DTOS(_dDtFec),6)+'_'+_cTp	,NIL})
							AAdd(&("_aCab"+_cTp),{"D3_TM" 		, _cTM								,NIL})
							AAdd(&("_aCab"+_cTp),{"D3_EMISSAO"  , _dDtFec							,NIL})
						Endif

						AAdd(&("_aIt"+_cTp),{;
						{"D3_COD"	, _cProd		,NIL},;
						{"D3_QUANT"	, 0				,NIL},;
						{"D3_CUSTO1", ABS(_nValor)	,NIL},;
						{"D3_LOCAL" , _cArm			,Nil},;
						{"D3_GRUPO" , _cGrup		,Nil}})

					Endif
				Endif

				FT_FSKIP()
			EndDo

			For _nFor := 1 to 4

				_aCabD3		:= &('_aCab'+Strzero(_nFor,1))
				_aIteD3		:= &('_aIt'+Strzero(_nFor,1))

				If Len(_aIteD3) > 0

					lMSHelpAuto := .T.
					lMsErroAuto := .F.

					MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCabD3,_aIteD3,3)

					If lMsErroAuto
						MostraErro()
						DisarmTransaction()
						Return(Nil)
					EndIf
				Endif

			Next _nFor

			For _nFor := 1 To Len(_aSB1)
				SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+_aSB1[_nFor]))
					SB1->(RecLock("SB1",.F.))
					SB1->B1_MSBLQL := "1"
					SB1->(MsUnLock())
				Endif
			Next _nFor

		End Transaction

		FT_FUSE()

		MsgInfo('Arquivo Processado com sucesso!')

	Endif

Return()



/*
Desc:		Abre o arquivo para importacao.
Parametros 	cDir   	 - Diretorio em que os arquivos sao gravados.
cFile     - Nome do arquivo.
*/
Static Function OpenFile( _cDir, _cFile )

	Local _nHdl := -1
	Local _lRet := .T.

	_nHdl := fOpen( _cDir + _cFile, 0 )

	If _nHdl < 0
		_lRet := .F.
	Else
		fClose( _nHdl )
	EndIf

Return _lRet
