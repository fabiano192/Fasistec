#Include "Protheus.ch"
#include "topconn.ch"
#Include "RWMAKE.CH"
#Include "Xmlxfun.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} ECO011
EXPORTA NF
@type function
@version 
@author Fabiano
@since 15/07/2020
@return return_type, return_description
/*/
User Function ECO011()

	ATUSX1()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Importa NF Entrada ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Importacao do Movimento de NF Entrada da Empresa    "     SIZE 160,7
	@ 18,18 SAY "                                                    "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "                                                    "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ECO011")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	Pergunte("ECO011",.F.)

	If _nOpc == 1

		Private _lFim      := .F.
		Private _cTitulo01 := 'Importando NF Entrada!!!'

		Processa( {|| ECO11_01() } , _cTitulo01, "Processando ...",.T.)
	Endif

Return (Nil)



Static Function ECO11_01()

	local AX

	Private _aKeySF4 := {Array(2)}

	Pergunte("ECO011",.F.)

	//Exclui daddos da tabela SF4
	_cUpd := " DELETE SF4010 FROM SF4010 WHERE F4_TIPO = 'E' "
	_cUpd += " AND F4_CODIGO NOT IN ('001','132') "

	TCSQLEXEC(_cUpd )


	_aEmp:= {{'A','0101','91'},{'A','0103','93'},{'B','0201','101'},{'B','0203','103'},{'B','0204','104'},{'C','0301','111'},{'C','0303','113'}}
	// _aEmp:= {{'B','0201','101'}}

	ProcRegua(Len(_aEmp))

	For AX:= 1 To Len(_aEmp)

		IncProc("Importando NF de Entrada")

		_cEmp   := Left(_aEmp[AX][2],2)
		_cFil   := Right(_aEmp[AX][2],2)
		_cFilRM := _aEmp[AX][3]

		ECO11_01C(_cEmp,_cFil,_cFilRM)

	Next AX

Return



Static Function ECO11_01C(_cEmp,_cFil,_cFilRM)  // MOVIMENTOS CONT?BEIS

	Local _aArea     := GetArea()
	Local _aAreaSA2  := SA2->( GetArea() )
	Local _aAreaSA1  := SA1->( GetArea() )
	Local _aAreaSB1  := SB1->( GetArea() )
	Local _aAreaSD1  := SD1->( GetArea() )
	Local _aAreaSF1  := SF1->( GetArea() )
	Local _aAreaSF4  := SF4->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _aAreaSE2  := SE2->( GetArea() )
	Local _cAliasSA2 := ''
	Local _cAliasSA1 := ''
	Local _cAliasSB1 := ''
	Local _cAliasSD1 := ''
	Local _cAliasSF1 := ''
	Local _cAliasSF4 := ''
	Local _cAliasZF6 := ''
	Local _cAliasSE2 := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSA2   := .F.
	Local _lOutSA1   := .F.
	Local _lOutSB1   := .F.
	Local _lOutSD1   := .F.
	Local _lOutSF1   := .F.
	Local _lOutSF4   := .F.
	Local _lOutZF6   := .F.
	Local _lOutSE2   := .F.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQry := " SELECT A.CODCOLIGADA,A.CODFILIAL,A.CODCFO,A.NUMEROMOV,A.SERIE,A.DATAEMISSAO,A.VALORLIQUIDO,A.VALORBRUTO,A.CHAVEACESSONFE,A.VALORFRETE,A.NUMEROMOV,A.HORARIOEMISSAO," + CRLF
	_cQry += " C.CODIGOPRD,D.CODUNDBASE,B.IDMOV,B.NSEQITMMOV,B.QUANTIDADE,B.PRECOUNITARIO,B.VALORLIQUIDO,B.CODLOC,E.VALORICMSDESONERADO,E.FATORREDUCAO," + CRLF
	_cQry += " E.CODTRB,E.BASEDECALCULO,E.ALIQUOTA,E.VALOR,E.SITTRIBUTARIA,E.MOTDESICMS,F.NOME,F.CODNAT, A.CODTDO ,A.CODTMV,G.CHAVEACESSO  " + CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.TMOV A " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TITMMOV B ON A.CODCOLIGADA = B.CODCOLIGADA AND A.IDMOV = B.IDMOV " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TPRD C ON B.IDPRD = C.IDPRD AND A.CODCOLIGADA = C.CODCOLIGADA " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TUND D ON B.CODUND = D.CODUND " + CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.TTRBMOV E ON B.IDMOV = E.IDMOV AND B.NSEQITMMOV = E.NSEQITMMOV AND B.CODCOLIGADA = E.CODCOLIGADA " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.DCFOP F ON B.IDNAT = F.IDNAT AND B.CODCOLIGADA = F.CODCOLIGADA " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TNFEESTADUAL G ON A.CODCOLIGADA = G.CODCOLIGADA AND A.IDMOV = G.IDMOV " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	// _cQry += " AND A.TIPO = 'A' " + CRLF
	_cQry += " AND A.CODCFO IS NOT NULL " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATAEMISSAO, 23),4) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),6,2) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),9,2) " +CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQry += " AND LEFT(CODTMV,1) = '1' " + CRLF // Movimentos de Compras
	_cQry += " ORDER BY A.CODCOLIGADA,A.CODFILIAL " + CRLF

	Memowrite("D:\_Temp\ECO011.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSF1:=  "SF1"+_cEmp+"0"
	_cTabSD1:=  "SD1"+_cEmp+"0"
	_cTabSE2:=  "SE2"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSF1 := "SF1"
		_cAliasSD1 := "SD1"
		_cAliasSB1 := "SB1"
		_cAliasSA2 := "SA2"
		_cAliasSA1 := "SA1"
		_cAliasZF6 := "ZF6"
		_cAliasSF4 := "SF4"
		_cAliasSE2 := "SE2"
	Else
		If EmpOpenFile("TSF1","SF1",1,.T., _cEmp,@_cModo)
			_cAliasSF1  := "TSF1"
			_lOutSF1 := .T.
		Endif
		If EmpOpenFile("TSD1","SD1",1,.T., _cEmp,@_cModo)
			_cAliasSD1  := "TSD1"
			_lOutSD1 := .T.
		Endif
		If EmpOpenFile("TSB1","SB1",1,.T., _cEmp,@_cModo)
			_cAliasSB1  := "TSB1"
			_lOutSB1 := .T.
		Endif
		If EmpOpenFile("TSA2","SA2",1,.T., _cEmp,@_cModo)
			_cAliasSA2  := "TSA2"
			_lOutSA2 := .T.
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
		If EmpOpenFile("TSE2","SE2",1,.T., _cEmp,@_cModo)
			_cAliasSE2  := "TSE2"
			_lOutSE2 := .T.
		Endif
	Endif

	If !Empty(_cAliasSF1) .And. !Empty(_cAliasSD1) .And. !Empty(_cAliasSB1) .And. !Empty(_cAliasSA2) .And. !Empty(_cAliasSA1) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSE2)

		//Exclui daddos da tabela SF1
		_cUpd := " DELETE "+_cTabSF1+ " FROM "+_cTabSF1+" WHERE F1_FILIAL = '"+_cFil+"' "
		_cUpd += " AND F1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

		TCSQLEXEC(_cUpd )


		//Exclui daddos da tabela SD1
		_cUpd := " DELETE "+_cTabSD1+ " FROM "+_cTabSD1+" WHERE D1_FILIAL = '"+_cFil+"' "
		_cUpd += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

		TCSQLEXEC(_cUpd )


		//Exclui daddos da tabela SE2
		_cUpd := " DELETE "+_cTabSE2+ " FROM "+_cTabSE2+" WHERE E2_FILIAL = '"+_cFil+"' "
		_cUpd += " AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		_cUpd += " AND E2_TIPO = 'NF' "

		TCSQLEXEC(_cUpd )


		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := Alltrim(cValToChar(TRB->CODCOLIGADA))
			While TRB->(!EOF())  .And. _cKey1 == Alltrim(cValToChar(TRB->CODCOLIGADA))

				If TRB->CODTMV = '1.2.12'
					_F1TIPO    := "D"

					//Verifica se o Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
					CheckZF6(3,_cFil,_cAliasZF6,_cAliasSA2,_cAliasSB1,_cAliasSA1)
				else
					_F1TIPO    := "N"
					//Verifica se o Fornecedor está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
					CheckZF6(1,_cFil,_cAliasZF6,_cAliasSA2,_cAliasSB1,_cAliasSA1)
				Endif

				_cNomFor   := ''
				_cUF	   := ''
				_cTpFor    := ''
				_cCodFor   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojFor   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)
				_F1VALBRUT := TRB->VALORLIQUIDO
				_F1VALMERC := TRB->VALORLIQUIDO
				_F1CHVNFE  := If(Empty(TRB->CHAVEACESSONFE),Alltrim(TRB->CHAVEACESSO),Alltrim(TRB->CHAVEACESSONFE))
				_F1FRETE   := TRB->VALORFRETE
				_F1HORA	   := TRB->HORARIOEMISSAO

				_F1BASEICM := _F1VALICM := 0
				_F1BASEIPI := _F1VALIPI := 0
				_F1BASIMP1 := _F1VALIMP1:= 0
				_F1BASIMP2 := _F1VALIMP2:= 0
				_F1BASIMP3 := _F1VALIMP3:= 0
				_F1BASIMP4 := _F1VALIMP4:= 0
				_F1BASIMP5 := _F1VALIMP5:= 0
				_F1BASIMP6 := _F1VALIMP6:= 0
				_F1DOC     := Alltrim(TRB->NUMEROMOV)
				_F1SERIE   := Alltrim(TRB->SERIE)
				_F1EMISSAO := TRB->DATAEMISSAO

				If _F1TIPO  = "D"
					(_cAliasSA1)->(dbSetOrder(1))
					If (_cAliasSA1)->(MsSeek(xFilial("SA1")+_cCodCli+_cLojCli))
						_cNomFor := (_cAliasSA1)->A1_NREDUZ
						_cUF	 := (_cAliasSA1)->A1_EST
						_cTpFor  := (_cAliasSA1)->A1_TIPO
					Endif
				Else
					(_cAliasSA2)->(dbSetOrder(1))
					If (_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCodCli+_cLojCli))
						_cNomFor := (_cAliasSA2)->A2_NREDUZ
						_cUF	 := (_cAliasSA2)->A2_EST
						_cTpFor  := (_cAliasSA2)->A2_TIPO
					Endif
				Endif

				_F1INSS    := 0
				_F1BASEINS := 0
				_F1ISS     := 0
				_F1IRRF    := 0
				_F1VALIRF  := 0

				_F1ESPECIE := "NF"
				If TRB->CODTDO = "01" //NF-e
					_F1ESPECIE := "SPED"
				ElseIf TRB->CODTDO = "39" // NFS
					_F1ESPECIE := "NFS"
				ElseIf TRB->CODTDO = "40" // CT-e
					_F1ESPECIE := "CTE"
				ElseIf TRB->CODTDO = "43" // NFS-e
					_F1ESPECIE := "NFDS"
				Endif


				_cIDMov  := Alltrim(cValToChar(TRB->IDMOV))
				_cKey2   := _cKey1 + Alltrim(cValToChar(TRB->IDMOV))

				_D1ITEM  := "0000"

				While TRB->(!EOF())  .And. _cKey2 == _cKey1 + Alltrim(cValToChar(TRB->IDMOV))

					_D1ITEM    := Soma1(_D1ITEM)
					_D1UM      := TRB->CODUNDBASE
					_D1QUANT   := TRB->QUANTIDADE
					_D1VUNIT  := TRB->PRECOUNITARIO
					_D1TOTAL   := TRB->VALORLIQUIDO
					_D1CF      := Left(StrTran(TRB->CODNAT,".",""),4)
					_D1COD     := Alltrim(StrTran(TRB->CODIGOPRD,".",""))
					_D1TES     := ''
					_D1DESC    := 0
					_D1VALIPI  := 0
					_D1BASEIPI := 0
					_D1IPI     := 0
					_D1VALICM  := 0
					_D1BASEICM := 0
					_D1PICM    := 0
					_D1CLASFIS := ''

					_D1VALCSL  := 0
					_D1PEDIDO  := ''
					_D1ITEMPV  := ''
					_D1LOCAL   := '01'
					_D1GRUPO   := ''
					_D1TP      := ''
					_D1PRUNIT  := 0
					_D1NUMSEQ  := ''
					_D1EST     := ''
					_D1QTDEDEV := 0
					_D1VALDEV  := 0
					_D1NFORI   := ''
					_D1SERIORI := ''
					_D1VALIMP1 := 0
					_D1BASIMP1 := 0
					_D1ALQIMP1 := 0
					_D1VALIMP2 := 0
					_D1BASIMP2 := 0
					_D1ALQIMP2 := 0
					_D1VALIMP3 := 0
					_D1BASIMP3 := 0
					_D1ALQIMP3 := 0
					_D1VALIMP4 := 0
					_D1BASIMP4 := 0
					_D1ALQIMP4 := 0
					_D1VALIMP5 := 0
					_D1BASIMP5 := 0
					_D1ALQIMP5 := 0
					_D1VALIMP6 := 0
					_D1BASIMP6 := 0
					_D1ALQIMP6 := 0
					_D1VALINS  := 0
					_D1BASEINS := 0
					_D1ALIQINS := 0
					_D1VALIRR  := 0
					_D1BASEIRR := 0
					_D1ALIQIRR  := 0
					_D1VALISS  := 0
					_D1BASEISS := 0
					_D1ALIQISS := 0

					_D1VALFRE  := 0
					_D1VALBRUT := 0
					_D1ALIQSOL := 0

					_D1ICMSRET := 0
					_D1DESCICM := 0

					_lICMS   := _lINSS   := _lIPI   := _lIRRF   := _lISS   := _lCOFINS   := _lPIS   := _lICMSST   := _lII   := .T.
					_cSTICMS := _cSTINSS := _cSTIPI := _cSTIRRF := _cSTISS := _cSTCOFINS := _cSTPIS := _cSTICMSST := _cSTII := ''
					_cKeyICMS:= _cKeyIPI := _cKeyCOFINS := _cKeyPIS := _cKeyINS := _cKeyIRRF := _cKeyISS := _cKeyICMSST := _cKeyII := ''

					_cMotDes   := ''
					_cNomeF4   := TRB->NOME
					_F4BASEICM := 0
					_F4AGREG   := "N"

					//Verifica se o Produto está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
					CheckZF6(2,_cFil,_cAliasZF6,_cAliasSA2,_cAliasSB1,_cAliasSA1)

					_cKey3   := _cKey2 + Alltrim(cValToChar(TRB->NSEQITMMOV))
					While TRB->(!EOF())  .And. _cKey3  == _cKey2 + Alltrim(cValToChar(TRB->NSEQITMMOV))

						If Alltrim(TRB->CODTRB) = 'ICMS'
							_D1BASEICM := TRB->BASEDECALCULO
							_D1PICM    := TRB->ALIQUOTA
							_D1VALICM  := TRB->VALOR
							_cSTICMS   := Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_D1CLASFIS := '0'+_cSTICMS
							_cMotDes   := Alltrim(cValToChar(TRB->MOTDESICMS))
							_D1DESCICM := TRB->VALORICMSDESONERADO
							_F4BASEICM := TRB->FATORREDUCAO
							_F4AGREG   := If(_D1DESCICM > 0 .And. _F4BASEICM > 0 .And. _cMotDes = "9","S","N")
							_cKeyICMS  := If(_D1VALICM > 0,"S","N")+'_'+_cSTICMS+'_'+_cMotDes+'_'+_F4AGREG
						ElseIf Alltrim(TRB->CODTRB) = 'IPI'
							_D1BASEIPI := TRB->BASEDECALCULO
							_D1IPI     := TRB->ALIQUOTA
							_D1VALIPI  := TRB->VALOR
							_cSTIPI    :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_cKeyIPI   := If(_D1VALIPI > 0,"S","N")+'_'+_cSTIPI
							// _cKeyIPI   := If(_D1BASEIPI > 0,"S","N")+'_'+If(_D1VALIPI > 0,"S","N")+'_'+_cSTIPI
						ElseIf Alltrim(TRB->CODTRB) = 'COFINS'
							_D1VALIMP5 := TRB->VALOR
							_D1BASIMP5 := TRB->BASEDECALCULO
							_D1ALQIMP5 := TRB->ALIQUOTA
							_cSTCOFINS :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_cKeyCOFINS:= If(_D1VALIMP5 > 0,"S","N")+'_'+_cSTCOFINS
						ElseIf Alltrim(TRB->CODTRB) = 'PIS'
							_D1VALIMP6 := TRB->VALOR
							_D1BASIMP6 := TRB->BASEDECALCULO
							_D1ALQIMP6 := TRB->ALIQUOTA
							_cSTPIS    :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_cKeyPIS:= If(_D1VALIMP6 > 0,"S","N")+'_'+_cSTPIS
						ElseIf Alltrim(TRB->CODTRB) = 'INSS'
							_D1VALINS  := TRB->VALOR
							_D1BASEINS := TRB->BASEDECALCULO
							_D1ALIQINS := TRB->ALIQUOTA
							_cKeyINS   := If(_D1VALINS > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'IRRF'
							_D1VALIRRF := TRB->VALOR
							_D1BASEIRR := TRB->BASEDECALCULO
							_D1ALIQIRR := TRB->ALIQUOTA
							_cKeyIRRF   := If(_D1VALIRR > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'ISS'
							_D1VALISS  := TRB->VALOR
							_D1BASEISS := TRB->BASEDECALCULO
							_D1ALIQISS := TRB->ALIQUOTA
							_cKeyISS   := If(_D1VALISS > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'ICMSST'
							_D1ICMSRET := TRB->VALOR
							_cKeyICMSST   := If(_D1ICMSRET > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) = 'II'

							// _cKeyII   := If(_D1VALISS > 0,"S","N")
						Endif

						TRB->(dbSkip())
					EndDo


					_cKeyF4 := _cKeyICMS + _cKeyIPI + _cKeyCOFINS + _cKeyPIS + _cKeyINS + _cKeyIRRF + _cKeyISS + _cKeyICMSST + _cKeyII
					_nPosF4 := aScan(_aKeySF4,{|x| x[1] = _cKeyF4})

					If _nPosF4 > 0
						_D1TES := _aKeySF4[_nPosF4][2]
					Else
						_D1TES := GetSF4(_cAliasSF4,_D1CF,_cNomeF4,_cSTICMS,_cSTIPI,_cSTCOFINS,_cSTPIS,_D1VALIMP5,_D1VALIMP6,_D1ICMSRET)
						AAdd(_aKeySF4,{_cKeyF4,_D1TES})
					Endif

					(_cAliasSD1)->(RecLock(_cAliasSD1,.T.))
					(_cAliasSD1)->D1_FILIAL  := _cFil
					(_cAliasSD1)->D1_DOC     := _F1DOC
					(_cAliasSD1)->D1_SERIE   := _F1SERIE
					(_cAliasSD1)->D1_FORNECE := _cCodFor
					(_cAliasSD1)->D1_LOJA    := _cLojFor
					(_cAliasSD1)->D1_EMISSAO := _F1EMISSAO
					(_cAliasSD1)->D1_ITEM    := _D1ITEM
					(_cAliasSD1)->D1_COD     := _D1COD
					(_cAliasSD1)->D1_UM      := _D1UM
					(_cAliasSD1)->D1_QUANT   := _D1QUANT
					(_cAliasSD1)->D1_VUNIT   := _D1VUNIT
					(_cAliasSD1)->D1_TOTAL   := _D1TOTAL
					(_cAliasSD1)->D1_TES     := _D1TES
					(_cAliasSD1)->D1_CF      := _D1CF
					(_cAliasSD1)->D1_VALIMP1 := _D1VALIMP1
					(_cAliasSD1)->D1_BASIMP1 := _D1BASIMP1
					(_cAliasSD1)->D1_ALQIMP1 := _D1ALQIMP1
					(_cAliasSD1)->D1_VALIMP2 := _D1VALIMP2
					(_cAliasSD1)->D1_BASIMP2 := _D1BASIMP2
					(_cAliasSD1)->D1_ALQIMP2 := _D1ALQIMP2
					(_cAliasSD1)->D1_VALIMP3 := _D1VALIMP3
					(_cAliasSD1)->D1_BASIMP3 := _D1BASIMP3
					(_cAliasSD1)->D1_ALQIMP3 := _D1ALQIMP3
					(_cAliasSD1)->D1_VALIMP4 := _D1VALIMP4
					(_cAliasSD1)->D1_BASIMP4 := _D1BASIMP4
					(_cAliasSD1)->D1_ALQIMP4 := _D1ALQIMP4
					(_cAliasSD1)->D1_VALIMP5 := _D1VALIMP5
					(_cAliasSD1)->D1_BASIMP5 := _D1BASIMP5
					(_cAliasSD1)->D1_ALQIMP5 := _D1ALQIMP5
					(_cAliasSD1)->D1_VALIMP6 := _D1VALIMP6
					(_cAliasSD1)->D1_BASIMP6 := _D1BASIMP6
					(_cAliasSD1)->D1_ALQIMP6 := _D1ALQIMP6
					(_cAliasSD1)->D1_VALIPI  := _D1VALIPI
					(_cAliasSD1)->D1_BASEIPI := _D1BASEIPI
					(_cAliasSD1)->D1_IPI     := _D1IPI
					(_cAliasSD1)->D1_VALICM  := _D1VALICM
					(_cAliasSD1)->D1_BASEICM := _D1BASEICM
					(_cAliasSD1)->D1_PICM    := _D1PICM
					(_cAliasSD1)->D1_CLASFIS := _D1CLASFIS
					(_cAliasSD1)->D1_VALINS  := _D1VALINS
					(_cAliasSD1)->D1_BASEINS := _D1BASEINS
					(_cAliasSD1)->D1_ALIQINS := _D1ALIQINS
					(_cAliasSD1)->D1_VALIRR  := _D1VALIRR
					(_cAliasSD1)->D1_BASEIRR := _D1BASEIRR
					(_cAliasSD1)->D1_ALIQIRR := _D1ALIQIRR
					(_cAliasSD1)->D1_VALISS  := _D1VALISS
					(_cAliasSD1)->D1_BASEISS := _D1BASEISS
					(_cAliasSD1)->D1_ALIQISS := _D1ALIQISS
					(_cAliasSD1)->D1_ICMSRET := _D1ICMSRET
					(_cAliasSD1)->D1_DESCICM := _D1DESCICM

					(_cAliasSD1)->D1_DESC    := _D1DESC
					(_cAliasSD1)->D1_VALCSL  := _D1VALCSL
					(_cAliasSD1)->D1_PEDIDO  := _D1PEDIDO
					(_cAliasSD1)->D1_ITEMPV  := _D1ITEMPV
					(_cAliasSD1)->D1_LOCAL   := _D1LOCAL
					(_cAliasSD1)->D1_GRUPO   := _D1GRUPO
					(_cAliasSD1)->D1_TP      := _D1TP
					// (_cAliasSD1)->D1_PRUNIT  := _D1PRUNIT
					(_cAliasSD1)->D1_NUMSEQ  := _D1NUMSEQ
					(_cAliasSD1)->D1_TIPO    := _F1TIPO
					(_cAliasSD1)->D1_QTDEDEV := _D1QTDEDEV
					(_cAliasSD1)->D1_VALDEV  := _D1VALDEV
					(_cAliasSD1)->D1_NFORI   := _D1NFORI
					(_cAliasSD1)->D1_SERIORI := _D1SERIORI
					(_cAliasSD1)->D1_ALIQISS := _D1ALIQISS
					(_cAliasSD1)->D1_BASEISS := _D1BASEISS
					(_cAliasSD1)->D1_VALISS  := _D1VALISS
					(_cAliasSD1)->D1_VALFRE  := _D1VALFRE
					// (_cAliasSD1)->D1_VALBRUT := _D1VALBRUT
					(_cAliasSD1)->D1_ALIQSOL := _D1ALIQSOL
					// (_cAliasSD1)->D1_CONTA   := ''
					// (_cAliasSD1)->D1_CC      := ''
					(_cAliasSD1)->(MsUnLock())

					_F1BASEICM += _D1BASEICM
					_F1VALICM  += _D1VALICM
					_F1BASEIPI += _D1BASEIPI
					_F1VALIPI  += _D1VALIPI
					_F1VALIMP1 += _D1VALIMP1
					_F1BASIMP1 += _D1BASIMP1
					_F1VALIMP2 += _D1VALIMP2
					_F1BASIMP2 += _D1BASIMP2
					_F1VALIMP3 += _D1VALIMP3
					_F1BASIMP3 += _D1BASIMP3
					_F1VALIMP4 += _D1VALIMP4
					_F1BASIMP4 += _D1BASIMP4
					_F1VALIMP5 += _D1VALIMP5
					_F1BASIMP5 += _D1BASIMP5
					_F1VALIMP6 += _D1VALIMP6
					_F1BASIMP6 += _D1BASIMP6

					_F1INSS    += _D1VALINS
					_F1BASEINS += _D1BASEINS
					_F1ISS     += _D1VALISS
					_F1VALIRF  += _D1VALIRR
					// _F1IRRF    += _D1VALIRR


				EndDo

				(_cAliasSF1)->(RecLock(_cAliasSF1,.T.))
				(_cAliasSF1)->F1_FILIAL  := _cFil
				(_cAliasSF1)->F1_DOC     := _F1DOC
				(_cAliasSF1)->F1_DUPL    := _F1DOC
				(_cAliasSF1)->F1_SERIE   := _F1SERIE
				(_cAliasSF1)->F1_FORNECE := _cCodFor
				(_cAliasSF1)->F1_LOJA    := _cLojFor
				(_cAliasSF1)->F1_EMISSAO := _F1EMISSAO
				(_cAliasSF1)->F1_DTDIGIT := _F1EMISSAO
				(_cAliasSF1)->F1_COND    := "000"
				(_cAliasSF1)->F1_EST     := _cUF
				(_cAliasSF1)->F1_ESPECIE := _F1ESPECIE
				(_cAliasSF1)->F1_VALBRUT := _F1VALBRUT
				(_cAliasSF1)->F1_VALMERC := _F1VALMERC
				(_cAliasSF1)->F1_PREFIXO := _F1SERIE
				(_cAliasSF1)->F1_CHVNFE  := _F1CHVNFE
				(_cAliasSF1)->F1_FRETE   := _F1FRETE
				(_cAliasSF1)->F1_VALICM  := _F1VALICM
				(_cAliasSF1)->F1_BASEICM := _F1BASEICM
				(_cAliasSF1)->F1_VALIPI  := _F1VALIPI
				(_cAliasSF1)->F1_BASEIPI := _F1BASEIPI
				(_cAliasSF1)->F1_BASIMP1 := _F1BASIMP1
				(_cAliasSF1)->F1_VALIMP1 := _F1VALIMP1
				(_cAliasSF1)->F1_BASIMP2 := _F1BASIMP2
				(_cAliasSF1)->F1_VALIMP2 := _F1VALIMP2
				(_cAliasSF1)->F1_BASIMP3 := _F1BASIMP3
				(_cAliasSF1)->F1_VALIMP3 := _F1VALIMP3
				(_cAliasSF1)->F1_BASIMP4 := _F1BASIMP4
				(_cAliasSF1)->F1_VALIMP4 := _F1VALIMP4
				(_cAliasSF1)->F1_BASIMP5 := _F1BASIMP5
				(_cAliasSF1)->F1_VALIMP5 := _F1VALIMP5
				(_cAliasSF1)->F1_BASIMP6 := _F1BASIMP6
				(_cAliasSF1)->F1_VALIMP6 := _F1VALIMP6
				(_cAliasSF1)->F1_TIPO    := "N"
				// (_cAliasSF1)->F1_HORA    := _F1HORA
				(_cAliasSF1)->F1_INSS    := _F1INSS
				(_cAliasSF1)->F1_BASEINS := _F1BASEINS
				(_cAliasSF1)->F1_ISS     := _F1ISS
				(_cAliasSF1)->F1_IRRF    := _F1IRRF
				(_cAliasSF1)->F1_VALIRF  := _F1VALIRF
				(_cAliasSF1)->(MsUnLock())

				GeraSE2(_cAliasSE2,_cKey1,_cIDMov,_cCodFor,_cLojFor,_cNomFor,_F1DOC,_F1SERIE)

			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSF1 )
		RestArea( _aAreaSD1 )
		RestArea( _aAreaSA2 )
		RestArea( _aAreaSA1 )
		RestArea( _aAreaSB1 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSF4 )
		RestArea( _aAreaSE2 )

		RestArea( _aArea )

	Endif

	If _lOutSF1
		TSF1->(dbCloseArea())
	ENDIF
	If _lOutSD1
		TSD1->(dbCloseArea())
	ENDIF
	If _lOutSB1
		TSB1->(dbCloseArea())
	ENDIF
	If _lOutSA2
		TSA2->(dbCloseArea())
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
	If _lOutSE2
		TSE2->(dbCloseArea())
	ENDIF

	TRB->(dbCloseArea())

Return()



Static Function ATUSX1()

	cPerg := "ECO011"
	aRegs := {}

//    	   Grupo/Ordem/Pergunta                /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01    /Def01            /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De?                ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data Ate ?              ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)



Static Function CheckZF6(_nOpc,_cFil,_cAliasZF6,_cAliasSA2,_cAliasSB1,_cAliasSA1)

	If _nOpc = 1
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA2"+PADR("A2_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))

			If Select("TFOR") > 0
				TFOR->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM [10.140.1.5].[CorporeRM].dbo.FCFO " + CRLF
			_cQry += " WHERE PAGREC <> 1 " + CRLF
			_cQry += " AND CODCFO = '"+Alltrim(TRB->CODCFO)+"' " + CRLF
			// _cQry += " ORDER BY CGCCFO,EMP " + CRLF

			TcQuery _cQry New Alias "TFOR"

			_nReg := Contar("TFOR","!EOF()")

			If _nReg > 0
				TFOR->(dbGoTop())

				_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
				_cCod  := ''
				_cLoja := ''

				(_cAliasSA2)->(dbSetOrder(3))
				If !(_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCNPJ))
					GeraFOR(_cFil,_cCNPJ,@_cCod,@_cLoja,_cAliasSA2)
				Else
					_cCod  := (_cAliasSA2)->A2_COD
					_cLoja := (_cAliasSA2)->A2_LOJA
				Endif

				(_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
				(_cAliasZF6)->ZF6_FILIAL := _cFil
				(_cAliasZF6)->ZF6_TABELA := "SA2"
				(_cAliasZF6)->ZF6_CAMPO  := "A2_COD"
				(_cAliasZF6)->ZF6_CODRM  := TFOR->CODCFO
				(_cAliasZF6)->ZF6_IDRM   := TFOR->IDCFO
				(_cAliasZF6)->ZF6_TOTVS  := _cCod+_cLoja
				(_cAliasZF6)->(MsUnLock())

			Endif

			TFOR->(dbCloseArea())
		Endif
	ElseIf _nOpc = 3
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA1"+PADR("A1_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))
			// ZF6_FILIAL, ZF6_TABELA, ZF6_CAMPO, ZF6_CODRM, R_E_C_N_O_, D_E_L_E_T_

			If Select("TCLI") > 0
				TCLI->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM [10.140.1.5].[CorporeRM].dbo.FCFO " + CRLF
			_cQry += " WHERE PAGREC <> 2 " + CRLF
			_cQry += " AND CODCFO = '"+Alltrim(TRB->CODCFO)+"' " + CRLF
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
				Else
					_cCod  := (_cAliasSA1)->A1_COD
					_cLoja := (_cAliasSA1)->A1_LOJA
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



Static Function GeraFOR(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA2)

	If TFOR->PESSOAFISOUJUR = "J"
		(_cAliasSA2)->(dbSetOrder(3))
		If (_cAliasSA2)->(MsSeek(xFilial("SA2")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA2)->A2_COD
		Endif
	Endif

	GetNxtA2(@_cCod,@_cLoja)


	(_cAlias)->(RecLock(_cAlias,.T.))
	(_cAlias)->A2_COD     := _cCod
	(_cAlias)->A2_LOJA    := _cLoja
	(_cAlias)->A2_NOME    := UPPER(U_RM_NoAcento(TFOR->NOME))
	(_cAlias)->A2_NREDUZ  := UPPER(U_RM_NoAcento(TFOR->NOMEFANTASIA))
	(_cAlias)->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
	(_cAlias)->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEMENTO)))
	(_cAlias)->A2_TIPO    := TFOR->PESSOAFISOUJUR
	(_cAlias)->A2_EST     := TFOR->CODETD
	(_cAlias)->A2_COD_MUN := TFOR->CODMUNICIPIO
	(_cAlias)->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TFOR->CIDADE)))
	(_cAlias)->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TFOR->BAIRRO)))
	// (_cAlias)->A2_NATUREZ := TFOR->
	(_cAlias)->A2_CEP     := TFOR->CEP
	// (_cAlias)->A2_DDD     := TFOR->
	(_cAlias)->A2_TEL     := TFOR->TELEFONE
	(_cAlias)->A2_PAIS    := "105"
	(_cAlias)->A2_CGC     := _cCNPJ
	(_cAlias)->A2_CONTATO := TFOR->CONTATO
	(_cAlias)->A2_INSCR   := TFOR->INSCRESTADUAL
	(_cAlias)->A2_CODPAIS := "01058"
	(_cAlias)->A2_EMAIL   := TFOR->EMAIL
	(_cAlias)->A2_MSBLQL  := If(TFOR->ATIVO=1,"2","1")
	// (_cAlias)->A2_LC      := TFOR->LIMITECREDITO
	(_cAlias)->A2_INSCRM  := TFOR->INSCRMUNICIPAL
	(_cAlias)->A2_CONTRIB  := If(TFOR->CONTRIBUINTE=1,"2","1")
	(_cAlias)->(MsUnLock())

RETURN(NIL)




Static Function GetNxtA2(_cCod,_cLoja)

	Local _cQrySA2 := ""

	If Empty(_cCod)

		_cQrySA2 := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName("SA2")+" A2 " +CRLF
		_cQrySA2 += " WHERE A2.D_E_L_E_T_ = '' AND A2_FILIAL = '"+xFilial("SA2")+"' " +CRLF

		TcQuery _cQrySA2 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cCod := "F"+SOMA1(RIGHT(TNEXT->COD,5))
		_cLoja := "01"

		TNEXT->(dbCloseArea())
	Else

		_cQrySA2 := " SELECT MAX(A2_LOJA) AS LOJA FROM "+RetSqlName("SA2")+" A2 " +CRLF
		_cQrySA2 += " WHERE A2.D_E_L_E_T_ = '' AND A2_FILIAL = '"+xFilial("SA2")+"' " +CRLF
		_cQrySA2 += " AND A2_COD = '"+_cCod+"' " +CRLF

		TcQuery _cQrySA2 New Alias "TNEXT"

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
	(_cAliasSB1)->B1_TIPO      := If(TPROD->TIPO = "S","SV","PA")
	(_cAliasSB1)->B1_EMIN      := TPROD->PONTODEPEDIDO1
	(_cAliasSB1)->B1_EMAX      := TPROD->ESTOQUEMAXIMO1
	(_cAliasSB1)->(MsUnLock())

Return(Nil)




Static Function GetSF4(_cAliasSF4,_D1CF,_cNomeF4,_cSTICMS,_cSTIPI,_cSTCOFINS,_cSTPIS,_D1VALIMP5,_D1VALIMP6,_D1ICMSRET)

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
		_cRetSF4 := '101'
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
		(_cAliasSF4)->F4_CF      := _D1CF
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
		If _D1VALIMP5 > 0 .And. _D1VALIMP6 > 0
			(_cAliasSF4)->F4_PISCOF  := "3"
		ElseIf _D1VALIMP5 > 0 .And. _D1VALIMP6 = 0
			(_cAliasSF4)->F4_PISCOF  := "2"
		ElseIf _D1VALIMP5 = 0 .And. _D1VALIMP6 > 0
			(_cAliasSF4)->F4_PISCOF  := "1"
		Else
			(_cAliasSF4)->F4_PISCOF  := "4"
		Endif
		(_cAliasSF4)->F4_PISCRED := "3"
		(_cAliasSF4)->F4_YTPVEND := "2"
		(_cAliasSF4)->F4_YPEDCOM := "2"
		(_cAliasSF4)->F4_BASEICM := _F4BASEICM
		(_cAliasSF4)->F4_AGREG   := _F4AGREG
		(_cAliasSF4)->(MsUnLock())
	Endif

Return(_cRetSF4)



Static Function GeraSE2(_cAliasSE2,_cKey1,_cIDMov,_cCodFor,_cLojFor,_cNomFor,_F1DOC,_F1SERIE)

	Local _nReg := 0

	If Select("TPAG") > 0
		TPAG->(dbCloseArea())
	Endif

	_cQry := " SELECT CODFILIAL AS FILIAL,DATAVENCIMENTO AS DTVENC, * FROM [10.140.1.5].[CorporeRM].dbo.FLAN A " + CRLF
	_cQry += " WHERE A.CODCOLIGADA = "+_cKey1+" " + CRLF
	_cQry += " AND A.IDMOV = "+_cIDMov+"  " + CRLF
	_cQry += " AND PAGREC = '2' " + CRLF

	TcQuery _cQry New Alias "TPAG"

	_nReg := Contar("TPAG","!EOF()")

	If _nReg > 0

		TPAG->(dbGoTop())

		While TPAG->(!EOF())

			(_cAliasSE2)->(RecLock(_cAliasSE2,.T.))
			(_cAliasSE2)->E2_FILIAL    := _cFil
			(_cAliasSE2)->E2_PREFIXO   := _F1SERIE
			(_cAliasSE2)->E2_NUM       := _F1DOC

			_cParcela := UPPER(Alltrim(TPAG->PARCELA))

			If Empty(_cParcela)
				_nAt := At("-",Alltrim(TPAG->NUMERODOCUMENTO))
				If _nAt > 0
					_cParcela := Substr(TPAG->NUMERODOCUMENTO,_nAt+1)
				Else
					If Len(TPAG->NUMERODOCUMENTO) > 9
						_cParcela := Substr(TPAG->NUMERODOCUMENTO,10)
					Endif
				Endif
			Endif

			(_cAliasSE2)->E2_PARCELA   := _cParcela
			(_cAliasSE2)->E2_TIPO      := "NF"
			// (_cAliasSE2)->E2_NATUREZ   := ??
			// (_cAliasSE2)->E2_PORTADO   := (TPAG->CNABBANCO)
			// (_cAliasSE2)->E2_AGEDEP    := ??

			(_cAliasSE2)->E2_FORNECE    := _cCodFor
			(_cAliasSE2)->E2_LOJA       := _cLojFor
			(_cAliasSE2)->E2_NOMFOR     := _cNomFor

			(_cAliasSE2)->E2_EMISSAO    := TPAG->DATAEMISSAO
			(_cAliasSE2)->E2_EMIS1      := TPAG->DATAEMISSAO

			(_cAliasSE2)->E2_VENCTO     := TPAG->DTVENC
			(_cAliasSE2)->E2_VENCREA    := TPAG->DTVENC
			(_cAliasSE2)->E2_VENCORI    := TPAG->DTVENC
			(_cAliasSE2)->E2_BAIXA      := TPAG->DATABAIXA

			(_cAliasSE2)->E2_VALOR      := TPAG->VALORORIGINAL
			(_cAliasSE2)->E2_VLCRUZ     := TPAG->VALORORIGINAL
			(_cAliasSE2)->E2_CODBAR     := TPAG->CODIGOBARRA
			(_cAliasSE2)->E2_BASEIRF    := TPAG->VALORBASEIRRF
			(_cAliasSE2)->E2_IRRF       := TPAG->VALORIRRF
			(_cAliasSE2)->E2_VALLIQ     := TPAG->VALORORIGINAL + TPAG->VALORJUROS + TPAG->VALORMULTA - TPAG->VALORDESCONTO
			(_cAliasSE2)->E2_JUROS      := TPAG->VALORJUROS
			(_cAliasSE2)->E2_MULTA      := TPAG->VALORMULTA
			(_cAliasSE2)->E2_DESCONT    := TPAG->VALORDESCONTO
			(_cAliasSE2)->E2_MOEDA      := 1

			(_cAliasSE2)->E2_HIST       := TPAG->HISTORICO
			(_cAliasSE2)->E2_SALDO      := If(TPAG->VALORBAIXADO >= TPAG->VALORORIGINAL, 0 , TPAG->VALORORIGINAL - TPAG->VALORBAIXADO)

			(_cAliasSE2)->E2_MODSPB     := "1"
			(_cAliasSE2)->E2_DESDOBR    := "2"
			(_cAliasSE2)->E2_PROJPMS    := "2"
			(_cAliasSE2)->E2_MULTNAT    := "2"

			(_cAliasSE2)->(MsUnLock())

			TPAG->(dbSkip())

		EndDo
	Endif

	TPAG->(dbCloseArea())

Return(Nil)




Static Function GeraCli(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA1)

	If TCLI->PESSOAFISOUJUR = "J"
		(_cAliasSA1)->(dbSetOrder(3))
		If (_cAliasSA1)->(MsSeek(xFilial("SA1")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA1)->A1_COD
		Endif
	Endif

	GetNxtA1(@_cCod,@_cLoja)

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




Static Function GetNxtA1(_cCod,_cLoja)

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


