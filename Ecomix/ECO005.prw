#Include "Protheus.ch"
#include "topconn.ch"
#Include "RWMAKE.CH"
#Include "Xmlxfun.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} ECO005
EXPORTA NF
@type function
@version 
@author Fabiano
@since 15/07/2020
@return return_type, return_description
/*/
User Function ECO005()

	ATUSX1()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Importa NF Saida ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Importacao do Movimento de NF Saida da Empresa         "     SIZE 160,7
	@ 18,18 SAY "                                                    "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "                                                    "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ECO005")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	Pergunte("ECO005",.F.)

	If _nOpc == 1

		Private _lFim      := .F.
		Private _cTitulo01 := 'Importando NF Saida!!!'

		Processa( {|| ECO05_01() } , _cTitulo01, "Processando ...",.T.)
	Endif

Return (Nil)



Static Function ECO05_01()

	local AX

	Private _aKeySF4 := {Array(2)}

	Pergunte("ECO005",.F.)

	//Exclui daddos da tabela SF4
	_cUpd := " DELETE SF4010 FROM SF4010 WHERE F4_TIPO = 'S' "
	_cUpd += " AND F4_CODIGO <> '501' "

	TCSQLEXEC(_cUpd )


	// _aEmp:= {{'A','0101','91'},{'A','0103','93'},{'B','0201','101'},{'B','0203','103'},{'B','0204','104'},{'C','0301','111'},{'C','0303','113'}}
	_aEmp:= {{'B','0201','101'}}

	ProcRegua(Len(_aEmp))

	For AX:= 1 To Len(_aEmp)

		IncProc("Importando Saldos")

		_cEmp   := Left(_aEmp[AX][2],2)
		_cFil   := Right(_aEmp[AX][2],2)
		_cFilRM := _aEmp[AX][3]

		ECO05_01C(_cEmp,_cFil,_cFilRM)

	Next AX

Return



Static Function ECO05_01C(_cEmp,_cFil,_cFilRM)  // MOVIMENTOS CONT?BEIS

	Local _aArea     := GetArea()
	Local _aAreaSA1  := SA1->( GetArea() )
	Local _aAreaSB1  := SB1->( GetArea() )
	Local _aAreaSD2  := SD2->( GetArea() )
	Local _aAreaSF2  := SF2->( GetArea() )
	Local _aAreaSF4  := SF4->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _cAliasSA1 := ''
	Local _cAliasSB1 := ''
	Local _cAliasSD2 := ''
	Local _cAliasSF2 := ''
	Local _cAliasSF4 := ''
	Local _cAliasZF6 := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSA1   := .F.
	Local _lOutSB1   := .F.
	Local _lOutSD2   := .F.
	Local _lOutSF2   := .F.
	Local _lOutSF4   := .F.
	Local _lOutZF6   := .F.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQry := " SELECT A.CODCOLIGADA,A.CODFILIAL,A.CODCFO,A.NUMEROMOV,A.SERIE,A.DATAEMISSAO,A.VALORLIQUIDO,A.VALORBRUTO,A.CHAVEACESSONFE,A.VALORFRETE,A.NUMEROMOV,A.HORARIOEMISSAO," + CRLF
	_cQry += " C.CODIGOPRD,D.CODUNDBASE,B.IDMOV,B.NSEQITMMOV,B.QUANTIDADE,B.PRECOUNITARIO,B.VALORLIQUIDO,B.CODLOC, " + CRLF
	_cQry += " E.CODTRB,E.BASEDECALCULO,E.ALIQUOTA,E.VALOR,E.SITTRIBUTARIA,E.MOTDESICMS,F.NOME,F.CODNAT " + CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.TMOV A " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TITMMOV B ON A.CODCOLIGADA = B.CODCOLIGADA AND A.IDMOV = B.IDMOV " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TPRD C ON B.IDPRD = C.IDPRD AND A.CODCOLIGADA = C.CODCOLIGADA " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TUND D ON B.CODUND = D.CODUND " + CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.TTRBMOV E ON B.IDMOV = E.IDMOV AND B.NSEQITMMOV = E.NSEQITMMOV AND B.CODCOLIGADA = E.CODCOLIGADA " + CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.DCFOP F ON B.IDNAT = F.IDNAT AND B.CODCOLIGADA = F.CODCOLIGADA " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND A.TIPO = 'P' " + CRLF
	_cQry += " AND A.CODCFO IS NOT NULL " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATAEMISSAO, 23),4) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),6,2) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),9,2) " +CRLF
	_cQry += " BETWEEN '20200101' AND '20200110' " + CRLF
	_cQry += " ORDER BY A.CODCOLIGADA,A.CODFILIAL " + CRLF

	Memowrite("D:\_Temp\ECO005.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSF2:=  "SF2"+_cEmp+"0"
	_cTabSD2:=  "SD2"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSF2 := "SF2"
		_cAliasSD2 := "SD2"
		_cAliasSB1 := "SB1"
		_cAliasSA1 := "SA1"
		_cAliasZF6 := "ZF6"
		_cAliasSF4 := "SF4"
	Else
		If EmpOpenFile("TSF2","SF2",1,.T., _cEmp,@_cModo)
			_cAliasSF2  := "TSF2"
			_lOutSF2 := .T.
		Endif
		If EmpOpenFile("TSD2","SD2",1,.T., _cEmp,@_cModo)
			_cAliasSD2  := "TSD2"
			_lOutSD2 := .T.
		Endif
		If EmpOpenFile("TSB1","SB1",1,.T., _cEmp,@_cModo)
			_cAliasSB1  := "TSB1"
			_lOutSB1 := .T.
		Endif
		If EmpOpenFile("TSA1","SA1",1,.T., _cEmp,@_cModo)
			_cAliasSA1  := "TSA1"
			_lOutSA1 := .T.
		Endif
		If EmpOpenFile("TZF6","ZF6",1,.T., _cEmp,@_cModo)
			_cAliasZF6  := "TZF6"
			_lOutZF6 := .T.
		Endif
		If EmpOpenFile("TSF4","SF4",1,.T., _cEmp,@_cModo)
			_cAliasSF4  := "TSF4"
			_lOutSF4 := .T.
		Endif
	Endif

	If !Empty(_cAliasSF2) .And. !Empty(_cAliasSD2) .And. !Empty(_cAliasSB1) .And. !Empty(_cAliasSA1) .And. !Empty(_cAliasZF6)


		//Exclui daddos da tabela SF2
		_cUpd := " DELETE "+_cTabSF2+ " FROM "+_cTabSF2+" WHERE F2_FILIAL = '"+_cFil+"' "
		_cUpd += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

		TCSQLEXEC(_cUpd )


		//Exclui daddos da tabela SD2
		_cUpd := " DELETE "+_cTabSD2+ " FROM "+_cTabSD2+" WHERE D2_FILIAL = '"+_cFil+"' "
		_cUpd += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

		TCSQLEXEC(_cUpd )


		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := Alltrim(cValToChar(TRB->CODCOLIGADA))
			While TRB->(!EOF())  .And. _cKey1 == Alltrim(cValToChar(TRB->CODCOLIGADA))

				//Verifica se o Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
				CheckZF6(1,_cFil,_cAliasZF6,_cAliasSA1,_cAliasSB1)

				_cNomCli   := ''
				_cUF	   := ''
				_cTpCli    := ''
				_cCodCli   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojCli   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)
				_F2VALBRUT := TRB->VALORLIQUIDO
				_F2VALMERC := TRB->VALORLIQUIDO
				_F2CHVNFE  := Alltrim(TRB->CHAVEACESSONFE)
				_F2FRETE   := TRB->VALORFRETE
				_F2HORA	   := TRB->HORARIOEMISSAO

				_F2BASEICM := _F2VALICM := 0
				_F2BASEIPI := _F2VALIPI := 0
				_F2BASIMP1 := _F2VALIMP1:= 0
				_F2BASIMP2 := _F2VALIMP2:= 0
				_F2BASIMP3 := _F2VALIMP3:= 0
				_F2BASIMP4 := _F2VALIMP4:= 0
				_F2BASIMP5 := _F2VALIMP5:= 0
				_F2BASIMP6 := _F2VALIMP6:= 0

				(_cAliasSA1)->(dbSetOrder(1))
				If (_cAliasSA1)->(MsSeek(xFilial("SA1")+_cCodCli+_cLojCli))
					_cNomCli := (_cAliasSA1)->A1_NREDUZ
					_cUF	 := (_cAliasSA1)->A1_EST
					_cTpCli  := (_cAliasSA1)->A1_TIPO
				Endif

				_cKey2   := _cKey1 + Alltrim(cValToChar(TRB->IDMOV))

				While TRB->(!EOF())  .And. _cKey2 == _cKey1 + Alltrim(cValToChar(TRB->IDMOV))

					_D2DOC     := Alltrim(TRB->NUMEROMOV)
					_D2SERIE   := Alltrim(TRB->SERIE)
					_D2EMISSAO := TRB->DATAEMISSAO
					_D2ITEM    := PadL(Alltrim(STR(TRB->NSEQITMMOV)),TAMSX3("D2_ITEM")[1],"0")
					_D2UM      := TRB->CODUNDBASE
					_D2QUANT   := TRB->QUANTIDADE
					_D2PRCVEN  := TRB->PRECOUNITARIO
					_D2TOTAL   := TRB->VALORLIQUIDO
					_D2CF      := Left(StrTran(TRB->CODNAT,".",""),4)
					_D2COD     := Alltrim(StrTran(TRB->CODIGOPRD,".",""))
					_D2TES     := ''
					_D2DESC    := 0
					_D2VALIPI  := 0
					_D2BASEIPI := 0
					_D2IPI     := 0
					_D2VALICM  := 0
					_D2BASEICM := 0
					_D2PICM    := 0
					_D2CLASFIS := ''

					_D2VALCSL  := 0
					_D2PEDIDO  := ''
					_D2ITEMPV  := ''
					_D2LOCAL   := ''
					_D2GRUPO   := ''
					_D2TP      := ''
					_D2PRUNIT  := 0
					_D2NUMSEQ  := ''
					_D2EST     := ''
					_D2TIPO    := ''
					_D2QTDEDEV := 0
					_D2VALDEV  := 0
					_D2NFORI   := ''
					_D2SERIORI := ''
					_D2VALIMP1 := 0
					_D2BASIMP1 := 0
					_D2ALQIMP1 := 0
					_D2VALIMP2 := 0
					_D2BASIMP2 := 0
					_D2ALQIMP2 := 0
					_D2VALIMP3 := 0
					_D2BASIMP3 := 0
					_D2ALQIMP3 := 0
					_D2VALIMP4 := 0
					_D2BASIMP4 := 0
					_D2ALQIMP4 := 0
					_D2VALIMP5 := 0
					_D2BASIMP5 := 0
					_D2ALQIMP5 := 0
					_D2VALIMP6 := 0
					_D2BASIMP6 := 0
					_D2ALQIMP6 := 0
					_D2VALINS  := 0
					_D2BASEINS := 0
					_D2ALIQINS := 0
					_D2VALIRRF := 0
					_D2BASEIRR := 0
					_D2ALQIRRF := 0
					_D2VALISS  := 0
					_D2BASEISS := 0
					_D2ALIQISS := 0

					_D2VALFRE  := 0
					_D2VALBRUT := 0
					_D2ALIQSOL := 0

					_lICMS   := _lINSS   := _lIPI   := _lIRRF   := _lISS   := _lCOFINS   := _lPIS   := _lICMSST   := _lII   := .T.
					_cSTICMS := _cSTINSS := _cSTIPI := _cSTIRRF := _cSTISS := _cSTCOFINS := _cSTPIS := _cSTICMSST := _cSTII := ''
					_cKeyICMS:= _cKeyIPI := _cKeyCOFINS := _cKeyPIS := _cKeyINS := _cKeyIRRF := _cKeyISS := _cKeyICMSST := _cKeyII := ''

					_cMotDes   := ''
					_cNomeF4   := TRB->NOME

					//Verifica se o Produto está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
					CheckZF6(2,_cFil,_cAliasZF6,_cAliasSA1,_cAliasSB1)

					_cKey3   := _cKey2 + Alltrim(cValToChar(TRB->NSEQITMMOV))
					While TRB->(!EOF())  .And. _cKey3  == _cKey2 + Alltrim(cValToChar(TRB->NSEQITMMOV))

						If Alltrim(TRB->CODTRB) = 'ICMS'
							_D2BASEICM := TRB->BASEDECALCULO
							_D2PICM    := TRB->ALIQUOTA
							_D2VALICM  := TRB->VALOR
							_cSTICMS   := Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_D2CLASFIS := '0'+_cSTICMS
							_cMotDes   := Alltrim(cValToChar(TRB->MOTDESICMS))
							_cKeyICMS   := If(_D2VALICM > 0,"S","N")+'_'+_cSTICMS+'_'+_cMotDes
							// _cKeyICMS   := If(_D2BASEICM > 0,"S","N")+'_'+If(_D2VALICM > 0,"S","N")+'_'+_cSTICMS+'_'+_cMotDes
						ElseIf Alltrim(TRB->CODTRB) = 'IPI'
							_D2BASEIPI := TRB->BASEDECALCULO
							_D2IPI     := TRB->ALIQUOTA
							_D2VALIPI  := TRB->VALOR
							_cSTIPI    :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_cKeyIPI   := If(_D2VALIPI > 0,"S","N")+'_'+_cSTIPI
							// _cKeyIPI   := If(_D2BASEIPI > 0,"S","N")+'_'+If(_D2VALIPI > 0,"S","N")+'_'+_cSTIPI
						ElseIf Alltrim(TRB->CODTRB) = 'COFINS'
							_D2VALIMP5 := TRB->VALOR
							_D2BASIMP5 := TRB->BASEDECALCULO
							_D2ALQIMP5 := TRB->ALIQUOTA
							_cSTCOFINS :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_cKeyCOFINS:= If(_D2VALIMP5 > 0,"S","N")+'_'+_cSTCOFINS
						ElseIf Alltrim(TRB->CODTRB) = 'PIS'
							_D2VALIMP6 := TRB->VALOR
							_D2BASIMP6 := TRB->BASEDECALCULO
							_D2ALQIMP6 := TRB->ALIQUOTA
							_cSTPIS    :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_cKeyPIS:= If(_D2VALIMP6 > 0,"S","N")+'_'+_cSTPIS
						ElseIf Alltrim(TRB->CODTRB) = 'INSS'
							_D2VALINS  := TRB->VALOR
							_D2BASEINS := TRB->BASEDECALCULO
							_D2ALIQINS := TRB->ALIQUOTA
							_cKeyINS   := If(_D2VALINS > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'IRRF'
							_D2VALIRRF := TRB->VALOR
							_D2BASEIRR := TRB->BASEDECALCULO
							_D2ALQIRRF := TRB->ALIQUOTA
							_cKeyIRRF   := If(_D2VALIRRF > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'ISS'
							_D2VALISS  := TRB->VALOR
							_D2BASEISS := TRB->BASEDECALCULO
							_D2ALIQISS := TRB->ALIQUOTA
							_cKeyISS   := If(_D2VALISS > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'ICMSST'

							// _cKeyICMSST   := If(_D2VALISS > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'II'

							// _cKeyII   := If(_D2VALISS > 0,"S","N")
						Endif

						TRB->(dbSkip())
					EndDo

					_cKeyF4 := _cKeyICMS + _cKeyIPI + _cKeyCOFINS + _cKeyPIS + _cKeyINS + _cKeyIRRF + _cKeyISS + _cKeyICMSST + _cKeyII
					_nPosF4 := aScan(_aKeySF4,{|x| x[1] = _cKeyF4})

					If _nPosF4 > 0
						_cTes := _aKeySF4[_nPosF4][2]
					Else
						_cTes := GetSF4(_cAliasSF4,_D2CF,_cNomeF4,_cSTICMS,_cSTIPI,_cSTCOFINS,_cSTPIS,_D2VALIMP5,_D2VALIMP6)
						AAdd(_aKeySF4,{_cKeyF4,_cTes})
					Endif

					If _cCodCli = 'C00256'
						_lPare := .T.
					Endif

					(_cAliasSD2)->(RecLock(_cAliasSD2,.T.))
					// (_cAliasSD2)->D2_YID     := TRB->IDMOV
					(_cAliasSD2)->D2_FILIAL  := _cFil
					(_cAliasSD2)->D2_DOC     := _D2DOC
					(_cAliasSD2)->D2_SERIE   := _D2SERIE
					(_cAliasSD2)->D2_CLIENTE := _cCodCli
					(_cAliasSD2)->D2_LOJA    := _cLojCli
					(_cAliasSD2)->D2_EMISSAO := _D2EMISSAO
					(_cAliasSD2)->D2_ITEM    := _D2ITEM
					(_cAliasSD2)->D2_COD     := _D2COD
					(_cAliasSD2)->D2_UM      := _D2UM
					(_cAliasSD2)->D2_QUANT   := _D2QUANT
					(_cAliasSD2)->D2_PRCVEN  := _D2PRCVEN
					(_cAliasSD2)->D2_TOTAL   := _D2TOTAL
					(_cAliasSD2)->D2_TES     := _D2TES
					(_cAliasSD2)->D2_CF      := _D2CF
					(_cAliasSD2)->D2_VALIMP1 := _D2VALIMP1
					(_cAliasSD2)->D2_BASIMP1 := _D2BASIMP1
					(_cAliasSD2)->D2_ALQIMP1 := _D2ALQIMP1
					(_cAliasSD2)->D2_VALIMP2 := _D2VALIMP2
					(_cAliasSD2)->D2_BASIMP2 := _D2BASIMP2
					(_cAliasSD2)->D2_ALQIMP2 := _D2ALQIMP2
					(_cAliasSD2)->D2_VALIMP3 := _D2VALIMP3
					(_cAliasSD2)->D2_BASIMP3 := _D2BASIMP3
					(_cAliasSD2)->D2_ALQIMP3 := _D2ALQIMP3
					(_cAliasSD2)->D2_VALIMP4 := _D2VALIMP4
					(_cAliasSD2)->D2_BASIMP4 := _D2BASIMP4
					(_cAliasSD2)->D2_ALQIMP4 := _D2ALQIMP4
					(_cAliasSD2)->D2_VALIMP5 := _D2VALIMP5
					(_cAliasSD2)->D2_BASIMP5 := _D2BASIMP5
					(_cAliasSD2)->D2_ALQIMP5 := _D2ALQIMP5
					(_cAliasSD2)->D2_VALIMP6 := _D2VALIMP6
					(_cAliasSD2)->D2_BASIMP6 := _D2BASIMP6
					(_cAliasSD2)->D2_ALQIMP6 := _D2ALQIMP6
					(_cAliasSD2)->D2_VALIPI  := _D2VALIPI
					(_cAliasSD2)->D2_BASEIPI := _D2BASEIPI
					(_cAliasSD2)->D2_IPI     := _D2IPI
					(_cAliasSD2)->D2_VALICM  := _D2VALICM
					(_cAliasSD2)->D2_BASEICM := _D2BASEICM
					(_cAliasSD2)->D2_PICM    := _D2PICM
					(_cAliasSD2)->D2_CLASFIS := _D2CLASFIS
					(_cAliasSD2)->D2_VALINS  := _D2VALINS
					(_cAliasSD2)->D2_BASEINS := _D2BASEINS
					(_cAliasSD2)->D2_ALIQINS := _D2ALIQINS
					(_cAliasSD2)->D2_VALIRRF := _D2VALIRRF
					(_cAliasSD2)->D2_BASEIRR := _D2BASEIRR
					(_cAliasSD2)->D2_ALQIRRF := _D2ALQIRRF
					(_cAliasSD2)->D2_VALISS  := _D2VALISS
					(_cAliasSD2)->D2_BASEISS := _D2BASEISS
					(_cAliasSD2)->D2_ALIQISS := _D2ALIQISS


					(_cAliasSD2)->D2_DESC    := _D2DESC
					(_cAliasSD2)->D2_VALCSL  := _D2VALCSL
					(_cAliasSD2)->D2_PEDIDO  := _D2PEDIDO
					(_cAliasSD2)->D2_ITEMPV  := _D2ITEMPV
					(_cAliasSD2)->D2_LOCAL   := _D2LOCAL
					(_cAliasSD2)->D2_GRUPO   := _D2GRUPO
					(_cAliasSD2)->D2_TP      := _D2TP
					(_cAliasSD2)->D2_PRUNIT  := _D2PRUNIT
					(_cAliasSD2)->D2_NUMSEQ  := _D2NUMSEQ
					(_cAliasSD2)->D2_EST     := _D2EST
					(_cAliasSD2)->D2_TIPO    := _D2TIPO
					(_cAliasSD2)->D2_QTDEDEV := _D2QTDEDEV
					(_cAliasSD2)->D2_VALDEV  := _D2VALDEV
					(_cAliasSD2)->D2_NFORI   := _D2NFORI
					(_cAliasSD2)->D2_SERIORI := _D2SERIORI
					(_cAliasSD2)->D2_ALIQISS := _D2ALIQISS
					(_cAliasSD2)->D2_BASEISS := _D2BASEISS
					(_cAliasSD2)->D2_VALISS  := _D2VALISS
					(_cAliasSD2)->D2_VALFRE  := _D2VALFRE
					// (_cAliasSD2)->D2_VALBRUT := _D2VALBRUT
					(_cAliasSD2)->D2_ALIQSOL := _D2ALIQSOL
					(_cAliasSD2)->(MsUnLock())

					_F2BASEICM += _D2BASEICM
					_F2VALICM  += _D2VALICM
					_F2BASEIPI += _D2BASEIPI
					_F2VALIPI  += _D2VALIPI
					_F2VALIMP1 += _D2VALIMP1
					_F2BASIMP1 += _D2BASIMP1
					_F2VALIMP2 += _D2VALIMP2
					_F2BASIMP2 += _D2BASIMP2
					_F2VALIMP3 += _D2VALIMP3
					_F2BASIMP3 += _D2BASIMP3
					_F2VALIMP4 += _D2VALIMP4
					_F2BASIMP4 += _D2BASIMP4
					_F2VALIMP5 += _D2VALIMP5
					_F2BASIMP5 += _D2BASIMP5
					_F2VALIMP6 += _D2VALIMP6
					_F2BASIMP6 += _D2BASIMP6

				EndDo

				(_cAliasSF2)->(RecLock(_cAliasSF2,.T.))
				// (_cAliasSF2)->F2_YID     := TRB->IDMOV
				(_cAliasSF2)->F2_FILIAL  := _cFil
				// (_cAliasSF2)->F2_FILIAL  := PadL(Alltrim(cValtoChar(TRB->CODFILIAL)),2,"0")
				(_cAliasSF2)->F2_DOC     := _D2DOC
				(_cAliasSF2)->F2_SERIE   := _D2SERIE
				(_cAliasSF2)->F2_CLIENTE := _cCodCli
				(_cAliasSF2)->F2_LOJA    := _cLojCli
				(_cAliasSF2)->F2_EMISSAO := _D2EMISSAO
				(_cAliasSF2)->F2_EST     := _cUF
				(_cAliasSF2)->F2_VALBRUT := _F2VALBRUT
				(_cAliasSF2)->F2_VALMERC := _F2VALMERC
				(_cAliasSF2)->F2_PREFIXO := _D2SERIE
				(_cAliasSF2)->F2_CLIENT  := _cCodCli
				(_cAliasSF2)->F2_LOJENT  := _cLojCli
				(_cAliasSF2)->F2_CHVNFE  := _F2CHVNFE
				(_cAliasSF2)->F2_FRETE   := _F2FRETE
				(_cAliasSF2)->F2_COND    := "000"
				(_cAliasSF2)->F2_VALICM  := _F2VALICM
				(_cAliasSF2)->F2_BASEICM := _F2BASEICM
				(_cAliasSF2)->F2_VALIPI  := _F2VALIPI
				(_cAliasSF2)->F2_BASEIPI := _F2BASEIPI
				(_cAliasSF2)->F2_BASIMP1 := _F2BASIMP1
				(_cAliasSF2)->F2_VALIMP1 := _F2VALIMP1
				(_cAliasSF2)->F2_BASIMP2 := _F2BASIMP2
				(_cAliasSF2)->F2_VALIMP2 := _F2VALIMP2
				(_cAliasSF2)->F2_BASIMP3 := _F2BASIMP3
				(_cAliasSF2)->F2_VALIMP3 := _F2VALIMP3
				(_cAliasSF2)->F2_BASIMP4 := _F2BASIMP4
				(_cAliasSF2)->F2_VALIMP4 := _F2VALIMP4
				(_cAliasSF2)->F2_BASIMP5 := _F2BASIMP5
				(_cAliasSF2)->F2_VALIMP5 := _F2VALIMP5
				(_cAliasSF2)->F2_BASIMP6 := _F2BASIMP6
				(_cAliasSF2)->F2_VALIMP6 := _F2VALIMP6
				(_cAliasSF2)->F2_ESPECIE := "SPED"
				(_cAliasSF2)->F2_TIPO    := "N"
				(_cAliasSF2)->F2_TIPOCLI := _cTpCli
				// (_cAliasSF2)->F2_HORA    := _F2HORA
				(_cAliasSF2)->(MsUnLock())

			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSF2 )
		RestArea( _aAreaSD2 )
		RestArea( _aAreaSA1 )
		RestArea( _aAreaSB1 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSF4 )

		RestArea( _aArea )

	Endif

	If _lOutSF2
		TSF2->(dbCloseArea())
	ENDIF
	If _lOutSD2
		TSD2->(dbCloseArea())
	ENDIF
	If _lOutSB1
		TSB1->(dbCloseArea())
	ENDIF
	If _lOutSA1
		TSA1->(dbCloseArea())
	ENDIF
	If _lOutSF4
		TSF4->(dbCloseArea())
	ENDIF
	If _lOutZF6
		TZF6->(dbCloseArea())
	ENDIF

	TRB->(dbCloseArea())

Return()



Static Function ATUSX1()

	cPerg := "ECO005"
	aRegs := {}

//    	   Grupo/Ordem/Pergunta                /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01    /Def01            /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De?                ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data Ate ?              ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)



Static Function CheckZF6(_nOpc,_cFil,_cAliasZF6,_cAliasSA1,_cAliasSB1)

	If _nOpc = 1
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA1"+PADR("A1_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))
			// ZF6_FILIAL, ZF6_TABELA, ZF6_CAMPO, ZF6_CODRM, R_E_C_N_O_, D_E_L_E_T_

			If Select("TCLI") > 0
				TCLI->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM [10.140.1.5].[CorporeRM].dbo.FCFO " + CRLF
			_cQry += " WHERE PAGREC <> 2 " + CRLF
			_cQry += " AND CODCFO = '"+TRB->CODCFO+"' " + CRLF
			// _cQry += " ORDER BY CGCCFO,EMP " + CRLF

			TcQuery _cQry New Alias "TCLI"

			_nReg := Contar("TCLI","!EOF()")

			If _nReg > 0
				TCLI->(dbGoTop())

				_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""))
				_cCod  := ''
				_cLoja := ''

				(_cAliasSA1)->(dbSetOrder(3))
				If !(_cAliasSA1)->(MsSeek(xFilial("SA1")+_cCNPJ))
					GeraCli(_cFil,_cCNPJ,@_cCod,@_cLoja,_cAliasSA1)
				Endif

				(_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
				(_cAliasZF6)->ZF6_FILIAL := _cFil
				(_cAliasZF6)->ZF6_TABELA := "SA1"
				(_cAliasZF6)->ZF6_CAMPO  := "A1_COD"
				(_cAliasZF6)->ZF6_CODRM  := TCLI->CODCFO
				(_cAliasZF6)->ZF6_IDRM   := TCLI->IDCFO
				(_cAliasZF6)->ZF6_TOTVS  := _cCod+_cLoja
				(_cAliasZF6)->(MsUnLock())

			Endif

			TCLI->(dbCloseArea())
		Endif
	ElseIf _nOpc = 2
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SB1"+PADR("B1_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODIGOPRD)))
			// ZF6_FILIAL, ZF6_TABELA, ZF6_CAMPO, ZF6_CODRM, R_E_C_N_O_, D_E_L_E_T_

			If Select("TPROD") > 0
				TPROD->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM [10.140.1.5].[CorporeRM].dbo.TPRODUTO A " +CRLF
			_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TPRODUTODEF B ON A.CODCOLPRD = B.CODCOLIGADA  AND A.IDPRD = B.IDPRD " +CRLF
			_cQry += " WHERE RTRIM(CODCOLPRD) = "+Alltrim(cValToChar(TRB->CODCOLIGADA))+" " +CRLF
			// _cQry += " WHERE RTRIM(CODCOLPRD) IN  ('0','9','10','11') " +CRLF
			_cQry += " AND CODIGOPRD = '"+TRB->CODIGOPRD+"' " + CRLF

			TcQuery _cQry New Alias "TPROD"

			_nReg := Contar("TPROD","!EOF()")

			If _nReg > 0
				TPROD->(dbGoTop())

				_cProd := Alltrim(StrTran(TPROD->CODIGOPRD,".",""))

				(_cAliasSB1)->(dbSetOrder(1))
				If !(_cAliasSB1)->(MsSeek(_cFil+_cProd))
					GeraProd(_cFil,_cProd,_cAliasSB1)
				Endif

				(_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
				(_cAliasZF6)->ZF6_FILIAL := _cFil
				(_cAliasZF6)->ZF6_TABELA := "SB1"
				(_cAliasZF6)->ZF6_CAMPO  := "B1_COD"
				(_cAliasZF6)->ZF6_CODRM  := TPROD->CODIGOPRD
				(_cAliasZF6)->ZF6_IDRM   := TPROD->IDPRD
				(_cAliasZF6)->ZF6_TOTVS  := _cProd
				(_cAliasZF6)->(MsUnLock())
			Endif

			TPROD->(dbCloseArea())
		Endif
	Endif

Return(Nil)



Static Function GeraCli(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA1)

	If TCLI->PESSOAFISOUJUR = "J"
		(_cAliasSA1)->(dbSetOrder(3))
		If (_cAliasSA1)->(MsSeek(xFilial("SA1")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA1)->A1_COD
		Endif
	Endif

	GetNxtCod(@_cCod,@_cLoja)

	(_cAliasSA1)->(RecLock(_cAliasSA1,.T.))
	// (_cAliasSA1)->A1_YID     := TCLI->IDCFO
	// (_cAliasSA1)->A1_FILIAL     := xFilial("SA1")
	// (_cAliasSA1)->A1_YCODRM  := TCLI->CODCFO
	(_cAliasSA1)->A1_COD        := _cCod
	(_cAliasSA1)->A1_LOJA       := _cLoja
	(_cAliasSA1)->A1_PESSOA     := TCLI->PESSOAFISOUJUR
	(_cAliasSA1)->A1_NOME       := UPPER(U_RM_NoAcento(TCLI->NOME))
	(_cAliasSA1)->A1_NREDUZ     := UPPER(U_RM_NoAcento(TCLI->NOMEFANTASIA))
	(_cAliasSA1)->A1_END        := UPPER(U_RM_NoAcento(Alltrim(TCLI->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCLI->NUMERO)))
	(_cAliasSA1)->A1_COMPLEM    := UPPER(U_RM_NoAcento(Alltrim(TCLI->COMPLEMENTO)))
	// (_cAliasSA1)->A1_TIPO    := TCLI-> ????
	(_cAliasSA1)->A1_EST        := TCLI->CODETD
	(_cAliasSA1)->A1_COD_MUN    := TCLI->CODMUNICIPIO
	(_cAliasSA1)->A1_MUN        := UPPER(U_RM_NoAcento(Alltrim(TCLI->CIDADE)))
	(_cAliasSA1)->A1_BAIRRO     := UPPER(U_RM_NoAcento(Alltrim(TCLI->BAIRRO)))
	// (_cAliasSA1)->A1_NATUREZ := TCLI->
	(_cAliasSA1)->A1_CEP        := TCLI->CEP
	// (_cAliasSA1)->A1_DDD     := TCLI->
	(_cAliasSA1)->A1_TEL        := TCLI->TELEFONE
	(_cAliasSA1)->A1_PAIS       := "105"
	(_cAliasSA1)->A1_CGC        := _cCNPJ
	(_cAliasSA1)->A1_CONTATO    := TCLI->CONTATO
	(_cAliasSA1)->A1_INSCR      := TCLI->INSCRESTADUAL
	(_cAliasSA1)->A1_CODPAIS    := "01058"
	(_cAliasSA1)->A1_SATIV1     := "1"
	(_cAliasSA1)->A1_SATIV2     := "1"
	(_cAliasSA1)->A1_SATIV3     := "1"
	(_cAliasSA1)->A1_SATIV4     := "1"
	(_cAliasSA1)->A1_SATIV5     := "1"
	(_cAliasSA1)->A1_SATIV6     := "1"
	(_cAliasSA1)->A1_SATIV7     := "1"
	(_cAliasSA1)->A1_SATIV8     := "1"
	(_cAliasSA1)->A1_EMAIL      := TCLI->EMAIL
	(_cAliasSA1)->A1_MSBLQL     := If(TCLI->ATIVO=1,"2","1")
	(_cAliasSA1)->A1_LC         := TCLI->LIMITECREDITO
	(_cAliasSA1)->A1_INSCRM     := TCLI->INSCRMUNICIPAL
	(_cAliasSA1)->A1_CONTRIB    := If(TCLI->CONTRIBUINTE=1,"2","1")
	(_cAliasSA1)->(MsUnLock())

RETURN(NIL)




Static Function GetNxtCod(_cCod,_cLoja)

	Local _cQrySA1 := ""

	If Empty(_cCod)

		_cQrySA1 := " SELECT MAX(A1_COD) AS COD FROM "+RetSqlName("SA1")+" A1 " +CRLF
		_cQrySA1 += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF

		TcQuery _cQrySA1 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cCod := "C"+SOMA1(RIGHT(TNEXT->COD,5))
		_cLoja := "01"

		TNEXT->(dbCloseArea())
	Else

		_cQrySA1 := " SELECT MAX(A1_LOJA) AS LOJA FROM "+RetSqlName("SA1")+" A1 " +CRLF
		_cQrySA1 += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF
		_cQrySA1 += " AND A1_COD = '"+_cCod+"' " +CRLF

		TcQuery _cQrySA1 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cLoja := SOMA1(TNEXT->LOJA)

		TNEXT->(dbCloseArea())
	Endif

Return(Nil)




Static Function GeraProd(_cFil,_cProd,_cAliasSB1)

	(_cAliasSB1)->(RecLock(_cAliasSB1,.T.))
	// (_cAliasSB1)->B1_YID    := TPROD->IDPRD
	(_cAliasSB1)->B1_FILIAL    := _cFil
	(_cAliasSB1)->B1_COD       := _cProd
	(_cAliasSB1)->B1_DESC      := U_RM_NoAcento(UPPER(Alltrim(TPROD->DESCRICAO)))
	(_cAliasSB1)->B1_MSBLQL    := (TPROD->INATIVO=1,"1","2")
	(_cAliasSB1)->B1_PESO      := TPROD->PESOLIQUIDO
	(_cAliasSB1)->B1_PESBRU    := TPROD->PESOBRUTO
	(_cAliasSB1)->B1_ORIGEM    := Alltrim(cValToChar(TPROD->REFERENCIACP))
	(_cAliasSB1)->B1_UPRC      := TPROD->PRECO1
	(_cAliasSB1)->B1_PRV1      := TPROD->PRECO2
	(_cAliasSB1)->B1_CUSTD     := TPROD->CUSTOUNITARIO
	(_cAliasSB1)->B1_UCALSTD   := TPROD->DATABASEPRECO1
	(_cAliasSB1)->B1_POSIPI    := TPROD->NUMEROCCF
	(_cAliasSB1)->B1_UM        := TPROD->CODUNDCONTROLE
	(_cAliasSB1)->B1_LOCPAD    := "01"
	// (_cAliasSB1)->B1_GRUPO
	(_cAliasSB1)->B1_EMIN      := TPROD->PONTODEPEDIDO1
	(_cAliasSB1)->B1_EMAX      := TPROD->ESTOQUEMAXIMO1
	(_cAliasSB1)->(MsUnLock())

Return(Nil)




Static Function GetSF4(_cAliasSF4,_D2CF,_cNomeF4,_cSTICMS,_cSTIPI,_cSTCOFINS,_cSTPIS,_D2VALIMP5,_D2VALIMP6)

	Local _cRetSF4 := ""
	Local _cQryF4  := ''

	If Select("TRBF4") > 0
		TRBF4->(dbCloseArea())
	Endif

	_cQryF4 := " SELECT MAX(F4_CODIGO) AS MAXCOD FROM SF4010 F4 " + CRLF
	_cQryF4 += " WHERE F4.D_E_L_E_T_ = '' AND F4_TIPO = 'S' " + CRLF

	TcQuery _cQryF4 New Alias "TRBF4"

	If Contar("TRBF4","!EOF()") > 0
		TRBF4->(dbGoTop())

		_cRetSF4 := Soma1(TRBF4->MAXCOD)
	Else
		_cRetSF4 := '501'
	Endif

	TRBF4->(dbCloseArea())

	If !Empty(_cRetSF4)

		(_cAliasSF4)->(RecLock(_cAliasSF4,.T.))
		(_cAliasSF4)->F4_CODIGO  := _cRetSF4
		(_cAliasSF4)->F4_TIPO    := "S"
		(_cAliasSF4)->F4_ICM     := "S"
		(_cAliasSF4)->F4_IPI     := "S"
		(_cAliasSF4)->F4_CREDICM := "S"
		(_cAliasSF4)->F4_CREDIPI := "S"
		(_cAliasSF4)->F4_DUPLIC  := "S"
		(_cAliasSF4)->F4_ESTOQUE := "N"
		(_cAliasSF4)->F4_CF      := _D2CF
		(_cAliasSF4)->F4_TEXTO   := _cNomeF4
		(_cAliasSF4)->F4_PODER3  := "N"
		(_cAliasSF4)->F4_LFICM   := "T"
		(_cAliasSF4)->F4_LFIPI   := "N"
		(_cAliasSF4)->F4_DESTACA := "N"
		(_cAliasSF4)->F4_INCIDE  := "N"
		(_cAliasSF4)->F4_COMPL   := "N"
		(_cAliasSF4)->F4_ISS     := "N"
		(_cAliasSF4)->F4_LFISS   := "N"
		(_cAliasSF4)->F4_SITTRIB := _cSTICMS
		(_cAliasSF4)->F4_CTIPI   := _cSTIPI
		(_cAliasSF4)->F4_CSTCOF  := _cSTCOFINS
		(_cAliasSF4)->F4_CSTPIS  := _cSTPIS
		(_cAliasSF4)->F4_TPREG   := "1"
		(_cAliasSF4)->F4_CINSS   := "N"
		If _D2VALIMP5 > 0 .And. _D2VALIMP6 > 0
			(_cAliasSF4)->F4_PISCOF  := "3"
		ElseIf _D2VALIMP5 > 0 .And. _D2VALIMP6 = 0
			(_cAliasSF4)->F4_PISCOF  := "2"
		ElseIf _D2VALIMP5 = 0 .And. _D2VALIMP6 > 0
			(_cAliasSF4)->F4_PISCOF  := "1"
		Else
			(_cAliasSF4)->F4_PISCOF  := "4"
		Endif
		(_cAliasSF4)->F4_PISCRED := "3"
		(_cAliasSF4)->F4_YTPVEND := "2"
		(_cAliasSF4)->F4_YPEDCOM := "2"
		(_cAliasSF4)->(MsUnLock())
	Endif

Return(_cRetSF4)
