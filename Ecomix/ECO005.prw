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
	@ 10,18 SAY "Importacao do Movimento de NF Saida da Empresa      "     SIZE 160,7
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

	local AX,a

	Private _aKeySF4 := LoadSF4()
	// Private _aKeySF4 := {Array(2)}

	Private _aItem  := {}

	For a := 1 to 200
		AAdd(_aItem,{a,soma1(PadL(Alltrim(Str(a-1)),2,"0"))})
	Next a

	Pergunte("ECO005",.F.)

	_cQry2 := " SELECT RIGHT('00'+RTRIM(CAST(CODCOLIGADA AS CHAR(02))),2) AS CODEMP,CAST(CODCFO AS CHAR(07)) AS CODCFO, NOMEFANTASIA AS NREDUZ,NOME,CGCCFO,INSCRESTADUAL AS INSCR,"+ CRLF
	_cQry2 += " CAST(PAGREC AS CHAR(01)) AS PAGREC, RUA,NUMERO,COMPLEMENTO AS COMPLEM,PESSOAFISOUJUR AS PESSOA,CODMUNICIPIO AS COD_MUN,CODETD,CIDADE,"+ CRLF
	_cQry2 += " BAIRRO,CEP,TELEFONE,CONTATO,EMAIL,ATIVO,LIMITECREDITO AS LC,CONTRIBUINTE AS CONTRIB,INSCRMUNICIPAL AS INSCRM, "+ CRLF
	_cQry2 += " IDCFO FROM [10.140.1.5].[CorporeRM].dbo.FCFO "+ CRLF
	_cQry2 += " ORDER BY CODCFO,CODEMP,PAGREC " + CRLF

	TcQuery _cQry2 New Alias "TCLI"

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TCLI",.T.)
	_cInd := "CODCFO + CODEMP + PAGREC"
	IndRegua("TCLI",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

	Private _aEmp:= {{'A','0101','91'},{'A','0102','92'},{'A','0103','93'},{'B','0201','101'},{'B','0203','103'},{'B','0204','104'},{'C','0301','111'},{'C','0303','113'}}
	// Private _aEmp:= {{'A','0103','93'}}

	ProcRegua(Len(_aEmp))

	For AX:= 1 To Len(_aEmp)

		IncProc("Importando NF de Saída")

		_cEmp   := Left(_aEmp[AX][2],2)
		_cFil   := Right(_aEmp[AX][2],2)
		_cFilRM := _aEmp[AX][3]

		ECO05_01C(_cEmp,_cFil,_cFilRM)

	Next AX

	TCLI->(dbCloseArea())

Return



Static Function ECO05_01C(_cEmp,_cFil,_cFilRM)  // MOVIMENTOS CONT?BEIS

	Local _aArea     := GetArea()
	Local _aAreaSA1  := SA1->( GetArea() )
	Local _aAreaSA2  := SA2->( GetArea() )
	Local _aAreaSB1  := SB1->( GetArea() )
	Local _aAreaSD2  := SD2->( GetArea() )
	Local _aAreaSF2  := SF2->( GetArea() )
	Local _aAreaSF4  := SF4->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _aAreaSE1  := SE1->( GetArea() )
	Local _cAliasSA1 := ''
	Local _cAliasSA2 := ''
	Local _cAliasSB1 := ''
	Local _cAliasSD2 := ''
	Local _cAliasSF2 := ''
	Local _cAliasSF4 := ''
	Local _cAliasZF6 := ''
	Local _cAliasSE1 := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSA1   := .F.
	Local _lOutSA2   := .F.
	Local _lOutSB1   := .F.
	Local _lOutSD2   := .F.
	Local _lOutSF2   := .F.
	Local _lOutSF4   := .F.
	Local _lOutZF6   := .F.
	Local _lOutSE1   := .F.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	// _cQry := " SELECT A.CODCOLIGADA,A.CODFILIAL,CAST(A.CODCFO AS CHAR(07)) AS CODCFO,A.NUMEROMOV,A.SERIE,A.DATAEMISSAO,A.VALORLIQUIDO,A.VALORBRUTO,A.CHAVEACESSONFE,A.VALORFRETE,A.HORARIOEMISSAO, " + CRLF
	// _cQry += " C.CODIGOPRD,D.CODUNDBASE,B.IDMOV,B.NSEQITMMOV,B.QUANTIDADE,B.PRECOUNITARIO,B.VALORLIQUIDO AS VALITEM,B.CODLOC,E.VALORICMSDESONERADO,E.FATORREDUCAO, " + CRLF
	// _cQry += " E.CODTRB,E.BASEDECALCULO,E.ALIQUOTA,E.VALOR,E.SITTRIBUTARIA,E.MOTDESICMS,F.NOME,F.CODNAT,A.CODTMV,G.CHAVEACESSO " + CRLF
	// _cQry += " FROM [10.140.1.5].[CorporeRM].dbo.TMOV A (NOLOCK) " + CRLF
	// _cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TITMMOV B (NOLOCK) ON A.CODCOLIGADA = B.CODCOLIGADA AND A.IDMOV = B.IDMOV " + CRLF
	// _cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TPRD C (NOLOCK) ON B.IDPRD = C.IDPRD AND A.CODCOLIGADA = C.CODCOLIGADA " + CRLF
	// _cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TUND D (NOLOCK) ON B.CODUND = D.CODUND " + CRLF
	// _cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.TTRBMOV E (NOLOCK) ON B.IDMOV = E.IDMOV AND B.NSEQITMMOV = E.NSEQITMMOV AND B.CODCOLIGADA = E.CODCOLIGADA " + CRLF
	// _cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.DCFOP F (NOLOCK) ON B.IDNAT = F.IDNAT AND B.CODCOLIGADA = F.CODCOLIGADA " + CRLF
	// _cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.TNFEESTADUAL G (NOLOCK) ON A.CODCOLIGADA = G.CODCOLIGADA AND A.IDMOV = G.IDMOV " + CRLF
	_cQry := " SELECT A.CODCOLIGADA,A.CODFILIAL,CAST(A.CODCFO AS CHAR(07)) AS CODCFO,A.NUMEROMOV,A.SERIE,A.DATAEMISSAO,A.VALORLIQUIDO,A.VALORBRUTO,A.CHAVEACESSONFE,A.VALORFRETE,A.NUMEROMOV,A.HORARIOEMISSAO, " + CRLF
	_cQry += " C.CODIGOPRD,D.CODUNDBASE,B.IDMOV,B.NSEQITMMOV,B.QUANTIDADE,B.PRECOUNITARIO,B.VALORLIQUIDO AS VALITEM,B.CODLOC,E.VALORICMSDESONERADO,E.FATORREDUCAO, " + CRLF
	_cQry += " E.CODTRB,E.BASEDECALCULO,E.ALIQUOTA,E.VALOR,E.SITTRIBUTARIA,E.MOTDESICMS,F.NOME,F.CODNAT,A.CODTMV,G.CHAVEACESSO,O.CODCOLORIGEM AS COLORIG,O.CODFILIALORIGEM AS FILORIG " + CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.TMOV A (NOLOCK) " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TITMMOV		B (NOLOCK) ON A.CODCOLIGADA = B.CODCOLIGADA  AND A.IDMOV       = B.IDMOV  " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TPRD			C (NOLOCK) ON B.IDPRD       = C.IDPRD        AND A.CODCOLIGADA = C.CODCOLIGADA  " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TUND			D (NOLOCK) ON B.CODUND      = D.CODUND " + CRLF
	_cQry += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.TTRBMOV		E (NOLOCK) ON B.IDMOV       = E.IDMOV        AND B.NSEQITMMOV  = E.NSEQITMMOV    AND B.CODCOLIGADA = E.CODCOLIGADA  " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.DCFOP		F (NOLOCK) ON B.IDNAT       = F.IDNAT        AND B.CODCOLIGADA = F.CODCOLIGADA  " + CRLF
	_cQry += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.TNFEESTADUAL G (NOLOCK) ON A.CODCOLIGADA = G.CODCOLIGADA  AND A.IDMOV       = G.IDMOV  " + CRLF
	_cQry += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.ZTMOVRELAC	O (NOLOCK) on A.IDMOV       = O.IDMOVDESTINO AND A.CODCOLIGADA = O.CODCOLDESTINO AND O.TIPO = 'O' " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND A.CODCFO IS NOT NULL " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATAEMISSAO, 23),4) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),6,2) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),9,2) " +CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQry += " AND LEFT(CODTMV,1) = '2' " + CRLF // Movimentos de Vendas
	_cQry += " AND A.STATUS <> 'C' " + CRLF
	//_cQry += " AND NUMEROMOV = '000055742' "
	_cQry += " ORDER BY A.CODCOLIGADA,A.CODFILIAL,B.IDMOV,A.NUMEROMOV,A.SERIE,B.NSEQITMMOV,E.CODTRB  " + CRLF

	Memowrite("D:\_Temp\ECO005.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSF2:=  "SF2"+_cEmp+"0"
	_cTabSD2:=  "SD2"+_cEmp+"0"
	_cTabSE1:=  "SE1"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSF2 := "SF2"
		_cAliasSD2 := "SD2"
		_cAliasSB1 := "SB1"
		_cAliasSA1 := "SA1"
		_cAliasSA2 := "SA2"
		_cAliasZF6 := "ZF6"
		_cAliasSF4 := "SF4"
		_cAliasSE1 := "SE1"
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
		If EmpOpenFile("TSA2","SA2",1,.T., _cEmp,@_cModo)
			_cAliasSA2  := "TSA2"
			_lOutSA2 := .T.
		Endif
		If EmpOpenFile("TZF6","ZF6",1,.T., _cEmp,@_cModo)
			_cAliasZF6  := "TZF6"
			_lOutZF6 := .T.
		Endif
		If EmpOpenFile("TSF4","SF4",1,.T., _cEmp,@_cModo)
			_cAliasSF4  := "TSF4"
			_lOutSF4 := .T.
		Endif
		If EmpOpenFile("TSE1","SE1",1,.T., _cEmp,@_cModo)
			_cAliasSE1  := "TSE1"
			_lOutSE1 := .T.
		Endif
	Endif

	If !Empty(_cAliasSF2) .And. !Empty(_cAliasSD2) .And. !Empty(_cAliasSB1) .And. !Empty(_cAliasSA1) .And. !Empty(_cAliasSA2) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSE1)

		//Exclui daddos da tabela SF2
		_cUpd := " DELETE "+_cTabSF2+ " FROM "+_cTabSF2+" WHERE F2_FILIAL = '"+_cFil+"' "
		_cUpd += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

		TCSQLEXEC(_cUpd )

		//Exclui daddos da tabela SD2
		_cUpd := " DELETE "+_cTabSD2+ " FROM "+_cTabSD2+" WHERE D2_FILIAL = '"+_cFil+"' "
		_cUpd += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

		TCSQLEXEC(_cUpd )

		//Exclui daddos da tabela SE1
		// _cUpd := " DELETE "+_cTabSE1+ " FROM "+_cTabSE1+" WHERE E1_FILIAL = '"+_cFil+"' "
		// _cUpd += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		// _cUpd += " AND E1_TIPO = 'NF' "

		// TCSQLEXEC(_cUpd )

		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := Alltrim(cValToChar(TRB->CODCOLIGADA))
			While TRB->(!EOF())  .And. _cKey1 == Alltrim(cValToChar(TRB->CODCOLIGADA))

				If TRB->CODTMV = '2.2.12'
					_F2TIPO    := "D"
					//Verifica se o Fornecedor está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
					_lRet := CheckZF6(3,_cFil,_cAliasZF6,_cAliasSA2,_cAliasSB1,_cAliasSA2)

					If !_lRet
						return
					Endif

				Else
					_F2TIPO    := "N"
					//Verifica se o Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
					_lRet := CheckZF6(1,_cFil,_cAliasZF6,_cAliasSA1,_cAliasSB1,_cAliasSA2)

					If !_lRet
						return
					Endif
				Endif

				_cNomCli   := ''
				_cUF	   := ''
				_cTpCli    := ''
				_cCodCli   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojCli   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)
				_F2VALBRUT := TRB->VALORLIQUIDO
				_F2VALMERC := TRB->VALORLIQUIDO
				_F2CHVNFE  := If(Empty(TRB->CHAVEACESSO),Alltrim(TRB->CHAVEACESSONFE),Alltrim(TRB->CHAVEACESSO))
				// _F2CHVNFE  := Alltrim(TRB->CHAVEACESSO)
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
				_F2DOC     := Alltrim(TRB->NUMEROMOV)
				_F2SERIE   := Alltrim(TRB->SERIE)
				_F2EMISSAO := TRB->DATAEMISSAO
				_F2YEMPFIL := CheckOrig(_cEmp,_cFil)

				If _F2TIPO  = "D"
					(_cAliasSA2)->(dbSetOrder(1))
					If (_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCodCli+_cLojCli))
						_cNomCli := (_cAliasSA2)->A2_NREDUZ
						_cUF	 := (_cAliasSA2)->A2_EST
						_cTpCli  := (_cAliasSA2)->A2_TIPO
					Endif
				Else
					(_cAliasSA1)->(dbSetOrder(1))
					If (_cAliasSA1)->(MsSeek(xFilial("SA1")+_cCodCli+_cLojCli))
						_cNomCli := (_cAliasSA1)->A1_NREDUZ
						_cUF	 := (_cAliasSA1)->A1_EST
						_cTpCli  := (_cAliasSA1)->A1_TIPO
					Endif
				Endif

				_cIDMov  := Alltrim(cValToChar(TRB->IDMOV))
				_cKey2   := Alltrim(cValToChar(TRB->CODCOLIGADA)) + Alltrim(cValToChar(TRB->IDMOV))

				_D2ITEM  := "00"

				While TRB->(!EOF())  .And. _cKey2 == Alltrim(cValToChar(TRB->CODCOLIGADA)) + Alltrim(cValToChar(TRB->IDMOV))

					_D2NFORI   := ''
					_D2SERIORI := ''
					_D2ITEMORI := ''

					If _F2TIPO = 'D'

						If Select("TNFORI") > 0
							TNFORI->(dbCloseArea())
						Endif

						_cQryNForig := " SELECT A.NUMEROMOV,A.SERIE,B.NSEQITMMOV FROM [10.140.1.5].[CorporeRM].dbo.TMOV A " + CRLF
						_cQryNForig += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TITMMOV B ON A.CODCOLIGADA = B.CODCOLIGADA AND A.IDMOV = B.IDMOV " + CRLF
						_cQryNForig += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TITMMOVRELAC C ON B.CODCOLIGADA = C.CODCOLORIGEM AND  B.IDMOV = C.IDMOVORIGEM  AND  B.NSEQITMMOV = C.NSEQITMMOVORIGEM " + CRLF
						_cQryNForig += " WHERE B.IDMOV = "+Alltrim(STR(TRB->IDMOV))+" AND B.NSEQITMMOV = "+Alltrim(STR(TRB->NSEQITMMOV))+" " + CRLF
						_cQryNForig += " AND A.CODCOLIGADA = "+Alltrim(STR(TRB->CODCOLIGADA))+" " + CRLF

						TcQuery _cQryNForig New Alias "TNFORI"

						If Contar("TNFORI","!EOF()") > 0

							TNFORI->(dbGoTop())

							_D2NFORI   := Alltrim(TNFORI->NUMEROMOV)
							_D2SERIORI := Alltrim(TNFORI->SERIE)
							_D2ITEMORI := PadL(Alltrim(STR(TNFORI->NSEQITMMOV)),4,"0")
						Endif

						TNFORI->(dbCloseArea())
					Endif

					// _D2ITEM    := PadL(Alltrim(STR(TRB->NSEQITMMOV)),TAMSX3("D2_ITEM")[1],"0")
					_D2ITEM    := Soma1(_D2ITEM)
					_D2UM      := TRB->CODUNDBASE
					_D2QUANT   := TRB->QUANTIDADE
					_D2PRCVEN  := TRB->PRECOUNITARIO
					_D2TOTAL   := TRB->VALITEM
					_D2CF      := Left(StrTran(TRB->CODNAT,".",""),4)
					// _D2COD     := Alltrim(StrTran(TRB->CODIGOPRD,".",""))
					_D2COD     := ''
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
					_D2LOCAL   := '01'
					_D2GRUPO   := ''
					_D2TP      := ''
					_D2PRUNIT  := 0
					_D2NUMSEQ  := ''
					_D2EST     := ''
					_D2QTDEDEV := 0
					_D2VALDEV  := 0
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

					_F2BRICMS  := 0
					_F2ICMSRET := 0
					_D2BRICMS  := 0
					_D2ICMSRET := 0
					_D2DESCICM := 0

					_lICMS   := _lINSS   := _lIPI   := _lIRRF   := _lISS   := _lCOFINS   := _lPIS   := _lICMSST   := _lII   := .T.
					_cSTICMS := _cSTINSS := _cSTIPI := _cSTIRRF := _cSTISS := _cSTCOFINS := _cSTPIS := _cSTICMSST := _cSTII := ''
					_cKeyICMS:= _cKeyIPI := _cKeyCOFINS := _cKeyPIS := _cKeyINS := _cKeyIRRF := _cKeyISS := _cKeyICMSST := _cKeyII := ''

					_F4MOTICMS   := ''
					_cNomeF4   := TRB->NOME
					_F4BASEICM := 0
					_F4AGREG   := "N"
					_F4ICM     := "N"

					//Verifica se o Produto está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
					_lRet := CheckZF6(2,_cFil,_cAliasZF6,_cAliasSA1,_cAliasSB1,_cAliasSA2)

					_cKey3   := Alltrim(cValToChar(TRB->CODCOLIGADA)) + Alltrim(cValToChar(TRB->IDMOV)) + Alltrim(cValToChar(TRB->NSEQITMMOV))
					While TRB->(!EOF())  .And. _cKey3  == Alltrim(cValToChar(TRB->CODCOLIGADA)) + Alltrim(cValToChar(TRB->IDMOV)) + Alltrim(cValToChar(TRB->NSEQITMMOV))

						If Alltrim(TRB->CODTRB) == 'ICMS'
							_D2BASEICM := TRB->BASEDECALCULO
							_D2PICM    := TRB->ALIQUOTA
							_D2VALICM  := TRB->VALOR
							_cSTICMS   := Alltrim(cValToChar(TRB->SITTRIBUTARIA))
							_D2CLASFIS := '0'+_cSTICMS
							_F4MOTICMS := Alltrim(cValToChar(TRB->MOTDESICMS))
							_D2DESCICM := TRB->VALORICMSDESONERADO
							_F4BASEICM := TRB->FATORREDUCAO
							_F4AGREG   := If(_D2DESCICM > 0 .And. _F4BASEICM > 0 .And. _F4MOTICMS = "9","S","N")
							_F4ICM     := If(_D2VALICM > 0,"S","N")
						ElseIf Alltrim(TRB->CODTRB) == 'IPI'
							_D2BASEIPI := TRB->BASEDECALCULO
							_D2IPI     := TRB->ALIQUOTA
							_D2VALIPI  := TRB->VALOR
							_cSTIPI    :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
						ElseIf Alltrim(TRB->CODTRB) == 'COFINS'
							_D2VALIMP5 := TRB->VALOR
							_D2BASIMP5 := TRB->BASEDECALCULO
							_D2ALQIMP5 := TRB->ALIQUOTA
							_cSTCOFINS :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
						ElseIf Alltrim(TRB->CODTRB) == 'PIS'
							_D2VALIMP6 := TRB->VALOR
							_D2BASIMP6 := TRB->BASEDECALCULO
							_D2ALQIMP6 := TRB->ALIQUOTA
							_cSTPIS    :=Alltrim(cValToChar(TRB->SITTRIBUTARIA))
						ElseIf Alltrim(TRB->CODTRB) == 'INSS'
							_D2VALINS  := TRB->VALOR
							_D2BASEINS := TRB->BASEDECALCULO
							_D2ALIQINS := TRB->ALIQUOTA
						ElseIf Alltrim(TRB->CODTRB) == 'IRRF'
							_D2VALIRRF := TRB->VALOR
							_D2BASEIRR := TRB->BASEDECALCULO
							_D2ALQIRRF := TRB->ALIQUOTA
						ElseIf Alltrim(TRB->CODTRB) == 'ISS'
							_D2VALISS  := TRB->VALOR
							_D2BASEISS := TRB->BASEDECALCULO
							_D2ALIQISS := TRB->ALIQUOTA
						ElseIf Alltrim(TRB->CODTRB) == 'ICMSST'
							_D2ICMSRET := TRB->VALOR - _D2VALICM
							_D2BRICMS  := TRB->BASEDECALCULO
						ElseIf Alltrim(TRB->CODTRB) == 'II'

						Endif

						TRB->(dbSkip())
					EndDo

					_cKeyICMS   := _F4ICM+'_'+_cSTICMS+'_'+_F4MOTICMS+'_'+_F4AGREG
					_cKeyIPI    := If(_D2VALIPI  > 0,"S","N")+'_'+_cSTIPI
					_cKeyCOFINS := If(_D2VALIMP5 > 0,"S","N")+'_'+_cSTCOFINS
					_cKeyPIS    := If(_D2VALIMP6 > 0,"S","N")+'_'+_cSTPIS
					_cKeyINS    := If(_D2VALINS  > 0,"S","N")
					_cKeyIRRF   := If(_D2VALIRRF > 0,"S","N")
					_cKeyISS    := If(_D2VALISS  > 0,"S","N")
					_cKeyICMSST := If(_D2ICMSRET > 0,"S","N")
					// _cKeyII   := If(xxxx > 0,"S","N")

					_cGeraFin := VldGeraFin(_D2CF,_F2TIPO)

					_cKeyF4 := _cGeraFin + _cKeyICMS + _cKeyIPI + _cKeyCOFINS + _cKeyPIS + _cKeyINS + _cKeyIRRF + _cKeyISS + _cKeyICMSST + _cKeyII
					_nPosF4 := aScan(_aKeySF4,{|x| x[1] = Alltrim(_cKeyF4)})

					If _nPosF4 > 0
						_D2TES := _aKeySF4[_nPosF4][2]
					Else
						_D2TES := GetSF4(_cKeyF4,_cAliasSF4,_D2CF,_cNomeF4,_cSTICMS,_cSTIPI,_cSTCOFINS,_cSTPIS,_D2VALIMP5,_D2VALIMP6,_D2ICMSRET,_cGeraFin)
						AAdd(_aKeySF4,{_cKeyF4,_D2TES})
					Endif

					(_cAliasSD2)->(RecLock(_cAliasSD2,.T.))
					// (_cAliasSD2)->D2_YID     := TRB->IDMOV
					(_cAliasSD2)->D2_FILIAL  := _cFil
					(_cAliasSD2)->D2_DOC     := _F2DOC
					(_cAliasSD2)->D2_SERIE   := _F2SERIE
					(_cAliasSD2)->D2_CLIENTE := _cCodCli
					(_cAliasSD2)->D2_LOJA    := _cLojCli
					(_cAliasSD2)->D2_EMISSAO := _F2EMISSAO
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
					(_cAliasSD2)->D2_BRICMS :=  _D2BRICMS
					(_cAliasSD2)->D2_ICMSRET := _D2ICMSRET
					(_cAliasSD2)->D2_DESCICM := _D2DESCICM
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
					(_cAliasSD2)->D2_TIPO    := _F2TIPO
					(_cAliasSD2)->D2_QTDEDEV := _D2QTDEDEV
					(_cAliasSD2)->D2_VALDEV  := _D2VALDEV
					(_cAliasSD2)->D2_NFORI   := _D2NFORI
					(_cAliasSD2)->D2_SERIORI := _D2SERIORI
					(_cAliasSD2)->D2_ITEMORI := _D2ITEMORI
					(_cAliasSD2)->D2_ALIQISS := _D2ALIQISS
					(_cAliasSD2)->D2_BASEISS := _D2BASEISS
					(_cAliasSD2)->D2_VALISS  := _D2VALISS
					(_cAliasSD2)->D2_VALFRE  := _D2VALFRE
					(_cAliasSD2)->D2_VALBRUT := _D2TOTAL + _D2VALFRE + _D2ICMSRET + _D2IPI
					(_cAliasSD2)->D2_ALIQSOL := _D2ALIQSOL
					(_cAliasSD2)->D2_YEMPFIL := _F2YEMPFIL
					(_cAliasSD2)->(MsUnLock())

					_F2BASEICM += _D2BASEICM
					_F2VALICM  += _D2VALICM
					_F2BRICMS  += _D2BRICMS
					_F2ICMSRET += _D2ICMSRET
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
				(_cAliasSF2)->F2_DOC     := _F2DOC
				(_cAliasSF2)->F2_SERIE   := _F2SERIE
				(_cAliasSF2)->F2_CLIENTE := _cCodCli
				(_cAliasSF2)->F2_LOJA    := _cLojCli
				(_cAliasSF2)->F2_EMISSAO := _F2EMISSAO
				(_cAliasSF2)->F2_EST     := _cUF
				(_cAliasSF2)->F2_VALBRUT := _F2VALBRUT
				(_cAliasSF2)->F2_VALMERC := _F2VALMERC
				(_cAliasSF2)->F2_PREFIXO := _F2SERIE
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
				(_cAliasSF2)->F2_BRICMS  := _F2BRICMS
				(_cAliasSF2)->F2_ICMSRET := _F2ICMSRET
				(_cAliasSF2)->F2_ESPECIE := "SPED"
				(_cAliasSF2)->F2_TIPO    := _F2TIPO
				(_cAliasSF2)->F2_TIPOCLI := _cTpCli
				(_cAliasSF2)->F2_DUPL    := _F2DOC
				// (_cAliasSF2)->F2_HORA    := _F2HORA
				(_cAliasSF2)->F2_YEMPFIL := _F2YEMPFIL
				(_cAliasSF2)->(MsUnLock())

				// GeraSE1(_cAliasSE1,_cKey1,_cIDMov,_cCodCli,_cLojCli,_cNomCli,_F2DOC,_F2SERIE)

			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSF2 )
		RestArea( _aAreaSD2 )
		RestArea( _aAreaSA1 )
		RestArea( _aAreaSA2 )
		RestArea( _aAreaSB1 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSF4 )
		RestArea( _aAreaSE1 )

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
	If _lOutSA2
		TSA2->(dbCloseArea())
	ENDIF
	If _lOutSF4
		TSF4->(dbCloseArea())
	ENDIF
	If _lOutZF6
		TZF6->(dbCloseArea())
	ENDIF
	If _lOutSE1
		TSE1->(dbCloseArea())
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



Static Function CheckZF6(_nOpc,_cFil,_cAliasZF6,_cAliasSA1,_cAliasSB1,_cAliasSA2)

	Local _lGrava
	Local _lRet2 := .T.

	If _nOpc = 1
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA1"+PADR("A1_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))
			// ZF6_FILIAL, ZF6_TABELA, ZF6_CAMPO, ZF6_CODRM, R_E_C_N_O_, D_E_L_E_T_

			_lGrava := .F.
			If TCLI->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)+ "2"))
				_lGrava := .T.
			Else
				If TCLI->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)) )
					_lGrava := .T.
				Else
					If TCLI->(MsSeek(TRB->CODCFO + "00" ))
						_lGrava := .T.
					Endif
				Endif
			Endif

			If _lGrava
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

			Else
				MSGINFO("Cliente Nao Cadastrado!! "+TRB->CODCFO+" NF: "+Alltrim(TRB->NUMEROMOV))
				TCLI->(dbCloseArea())
				Return(.F.)
			Endif
		Endif
	ElseIf _nOpc = 3
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA2"+PADR("A2_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))

			_lGrava := .F.
			If TCLI->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)+ "2"))
				_lGrava := .T.
			Else
				If TCLI->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)) )
					_lGrava := .T.
				Else
					If TCLI->(MsSeek(TRB->CODCFO + "0" ))
						_lGrava := .T.
					Endif
				Endif
			Endif

			If _lGrava
				_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""))
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
				(_cAliasZF6)->ZF6_CODRM  := TCLI->CODCFO
				(_cAliasZF6)->ZF6_IDRM   := TCLI->IDCFO
				(_cAliasZF6)->ZF6_TOTVS  := _cCod+_cLoja
				(_cAliasZF6)->(MsUnLock())

			Endif
		Endif

	ElseIf _nOpc = 2

		_D2COD := ''
		_lGeraZF6 := .T.

		If Select("TPROD") > 0
			TPROD->(dbCloseArea())
		Endif

		_cQry := " SELECT * FROM [10.140.1.5].[CorporeRM].dbo.TPRODUTO A " +CRLF
		_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.TPRODUTODEF B ON A.CODCOLPRD = B.CODCOLIGADA AND A.IDPRD = B.IDPRD " +CRLF
		_cQry += " WHERE RTRIM(CODCOLPRD) = "+Alltrim(cValToChar(TRB->CODCOLIGADA))+" " +CRLF
		_cQry += " AND CODIGOPRD = '"+TRB->CODIGOPRD+"' " + CRLF

		TcQuery _cQry New Alias "TPROD"

		_nReg := Contar("TPROD","!EOF()")

		If _nReg > 0

			TPROD->(dbGoTop())

			_cDesc := U_RM_NoAcento(UPPER(Alltrim(TPROD->DESCRICAO)))

			If Select("TTSB1") > 0
				TTSB1->(dbCloseArea())
			Endif

			_cQryB1 := " SELECT DADOS.* FROM " + CRLF
			_cQryB1 += "	( " + CRLF
			_cQryB1 += " 		SELECT ZF6_CODRM,ZF6_TOTVS,ZF6_DESC,EMP = '01', ZF6_FILIAL from ZF6010 A " + CRLF
			_cQryB1 += " 		WHERE A.ZF6_CAMPO = 'B1_COD' AND A.D_E_L_E_T_ = '' " + CRLF
			_cQryB1 += " 	UNION  " + CRLF
			_cQryB1 += " 		SELECT ZF6_CODRM,ZF6_TOTVS,ZF6_DESC,EMP = '02', ZF6_FILIAL from ZF6020 B " + CRLF
			_cQryB1 += " 		WHERE B.ZF6_CAMPO = 'B1_COD' AND B.D_E_L_E_T_ = '' " + CRLF
			_cQryB1 += " 	UNION  " + CRLF
			_cQryB1 += " 		SELECT ZF6_CODRM,ZF6_TOTVS,ZF6_DESC,EMP = '03', ZF6_FILIAL from ZF6030 C " + CRLF
			_cQryB1 += " 		WHERE C.ZF6_CAMPO = 'B1_COD' AND C.D_E_L_E_T_ = ''
			_cQryB1 += " 	) AS DADOS " + CRLF
			_cQryB1 += " WHERE DADOS.ZF6_CODRM = '"+Alltrim(TRB->CODIGOPRD)+"' " + CRLF

			TcQuery _cQryB1 New Alias "TTSB1"

			If Contar("TTSB1","!EOF()") > 0

				TTSB1->(dbGoTop())

				While TTSB1->(!EOF()) .And. _lGeraZF6

					If Alltrim(TTSB1->ZF6_DESC) = _cDesc
						_D2COD := TTSB1->ZF6_TOTVS
						If TTSB1->EMP = _cEmp .And. TTSB1->ZF6_FILIAL = _cFil
							_lGeraZF6 := .F.
						Endif
					Endif

					TTSB1->(dbSkip())
				EndDo
			Endif

			TTSB1->(dbCloseArea())

			If Empty(_D2COD)

				_D2COD := GetNxtProd()

				// (_cAliasSB1)->(dbSetOrder(1))
				// If !(_cAliasSB1)->(MsSeek(_cFil+_cProd))
				GeraProd(_cFil,_D2COD,_cAliasSB1)
				// Endif

				(_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
				(_cAliasZF6)->ZF6_FILIAL := _cFil
				(_cAliasZF6)->ZF6_TABELA := "SB1"
				(_cAliasZF6)->ZF6_CAMPO  := "B1_COD"
				(_cAliasZF6)->ZF6_CODRM  := TPROD->CODIGOPRD
				(_cAliasZF6)->ZF6_IDRM   := TPROD->IDPRD
				(_cAliasZF6)->ZF6_TOTVS  := _D2COD
				(_cAliasZF6)->ZF6_DESC   := _cDesc
				(_cAliasZF6)->(MsUnLock())

			ElseIf _lGeraZF6

				(_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
				(_cAliasZF6)->ZF6_FILIAL := _cFil
				(_cAliasZF6)->ZF6_TABELA := "SB1"
				(_cAliasZF6)->ZF6_CAMPO  := "B1_COD"
				(_cAliasZF6)->ZF6_CODRM  := TPROD->CODIGOPRD
				(_cAliasZF6)->ZF6_IDRM   := TPROD->IDPRD
				(_cAliasZF6)->ZF6_TOTVS  := _D2COD
				(_cAliasZF6)->ZF6_DESC   := _cDesc
				(_cAliasZF6)->(MsUnLock())
			Endif
		Endif

		TPROD->(dbCloseArea())
	Endif

Return(_lRet2)



Static Function GeraCli(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA1)

	If TCLI->PESSOA = "J"
		(_cAliasSA1)->(dbSetOrder(3))
		If (_cAliasSA1)->(MsSeek(xFilial("SA1")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA1)->A1_COD
		Endif
	Endif

	GetNxtA1(@_cCod,@_cLoja)

	_cCfop:= Left(StrTran(TRB->CODNAT,".",""),4)


	(_cAliasSA1)->(RecLock(_cAliasSA1,.T.))
	// (_cAliasSA1)->A1_YID     := TCLI->IDCFO
	// (_cAliasSA1)->A1_FILIAL     := xFilial("SA1")
	// (_cAliasSA1)->A1_YCODRM  := TCLI->CODCFO
	(_cAliasSA1)->A1_COD        := _cCod
	(_cAliasSA1)->A1_LOJA       := _cLoja
	(_cAliasSA1)->A1_PESSOA     := TCLI->PESSOA
	(_cAliasSA1)->A1_NOME       := UPPER(U_RM_NoAcento(TCLI->NOME))
	(_cAliasSA1)->A1_NREDUZ     := UPPER(U_RM_NoAcento(TCLI->NREDUZ))
	(_cAliasSA1)->A1_END        := UPPER(U_RM_NoAcento(Alltrim(TCLI->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCLI->NUMERO)))
	(_cAliasSA1)->A1_COMPLEM    := UPPER(U_RM_NoAcento(Alltrim(TCLI->COMPLEM)))
	If Alltrim(_cCFOP ) $ "5401/5403"
		(_cAliasSA1)->A1_TIPO       := "S"
	Else
		(_cAliasSA1)->A1_TIPO       := "R"
	Endif

	(_cAliasSA1)->A1_EST        := TCLI->CODETD
	(_cAliasSA1)->A1_COD_MUN    := TCLI->COD_MUN
	(_cAliasSA1)->A1_MUN        := UPPER(U_RM_NoAcento(Alltrim(TCLI->CIDADE)))
	(_cAliasSA1)->A1_BAIRRO     := UPPER(U_RM_NoAcento(Alltrim(TCLI->BAIRRO)))
	(_cAliasSA1)->A1_NATUREZ    := "N1001"
	(_cAliasSA1)->A1_CEP        := StrTran(TCLI->CEP,".","")
	(_cAliasSA1)->A1_TEL        := TCLI->TELEFONE
	(_cAliasSA1)->A1_PAIS       := "105"
	(_cAliasSA1)->A1_CGC        := _cCNPJ
	(_cAliasSA1)->A1_CONTATO    := TCLI->CONTATO
	(_cAliasSA1)->A1_INSCR      := IIF (Empty(TCLI->INSCR),"ISENTO",TCLI->INSCR)
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
	(_cAliasSA1)->A1_EMAILNF    := TCLI->EMAIL
	(_cAliasSA1)->A1_MSBLQL     := If(TCLI->ATIVO=1,"2","1")
	(_cAliasSA1)->A1_LC         := TCLI->LC
	(_cAliasSA1)->A1_INSCRM     := TCLI->INSCRM
	(_cAliasSA1)->A1_CONTRIB    := If(TCLI->CONTRIB=1,"2","1")
	(_cAliasSA1)->A1_XNOMV      := "."
	(_cAliasSA1)->A1_CONTA      := "10102020000001"
	(_cAliasSA1)->A1_YTPCLI     := "1"
	(_cAliasSA1)->A1_YCTARA     := "20101150000002"
	(_cAliasSA1)->A1_COND       := "001"
	(_cAliasSA1)->(MsUnLock())


RETURN(NIL)




Static Function GetNxtProd()

	Local _cNxtProd := ''
	Local _cPrefixo := ''

	If _F2TIPO = 'N'
		_cPrefixo := "VEN"
	Else
		_cPrefixo := "M00"
	Endif

	_cQrySA1 := " SELECT MAX(B1_COD) AS COD FROM "+RetSqlName("SB1")+" B1 " +CRLF
	_cQrySA1 += " WHERE B1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' " +CRLF
	_cQrySA1 += " AND LEFT(B1_COD,3) = '"+_cPrefixo+"' " +CRLF

	TcQuery _cQrySA1 New Alias "TNEXT"

	TNEXT->(dbGoTop())

	If !Empty(TNEXT->COD)
		_cNxtProd := _cPrefixo+Padl(Val(Right(Alltrim(TNEXT->COD),5))+1,5,"0")
		// _cNxtProd := SOMA1(Alltrim(TNEXT->COD))
	Else
		_cNxtProd := _cPrefixo+"00001"
	Endif

	TNEXT->(dbCloseArea())

Return(_cNxtProd)



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




Static Function GeraProd(_cFil,_cProd,_cAliasSB1)

	(_cAliasSB1)->(RecLock(_cAliasSB1,.T.))
	// (_cAliasSB1)->B1_YID    := TPROD->IDPRD
	// (_cAliasSB1)->B1_FILIAL    := _cFil
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




Static Function GetSF4(_cKeyF4,_cAliasSF4,_D2CF,_cNomeF4,_cSTICMS,_cSTIPI,_cSTCOFINS,_cSTPIS,_D2VALIMP5,_D2VALIMP6,_D2ICMSRET,_cGeraFin)

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
		(_cAliasSF4)->F4_ICM     := _F4ICM
		(_cAliasSF4)->F4_IPI     := "S"
		(_cAliasSF4)->F4_CREDICM := _F4ICM
		(_cAliasSF4)->F4_CREDIPI := "S"
		(_cAliasSF4)->F4_DUPLIC  := _cGeraFin
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
		(_cAliasSF4)->F4_BASEICM := _F4BASEICM
		(_cAliasSF4)->F4_AGREG   := _F4AGREG
		(_cAliasSF4)->F4_MOTICMS := _F4MOTICMS
		(_cAliasSF4)->F4_YCHAVRM := Alltrim(_cKeyF4)
		(_cAliasSF4)->(MsUnLock())
	Endif

Return(_cRetSF4)



Static Function GeraSE1(_cAliasSE1,_cKey1,_cIDMov,_cCodCli,_cLojCli,_cNomCli,_F2DOC,_F2SERIE)

	Local _nReg := 0

	If Select("TREC") > 0
		TREC->(dbCloseArea())
	Endif

	If _cIDMov = '236278'
		_lPare := .T.
	Endif

	// _cQry := " SELECT CODFILIAL AS FILIAL,DATAVENCIMENTO AS DTVENC, * FROM [10.140.1.5].[CorporeRM].dbo.FLAN A " + CRLF
	_cQry := " SELECT CODFILIAL AS FILIAL,DATAVENCIMENTO AS DTVENC,VALORORIGINAL AS VALOR,VALORJUROS AS JUROS,VALORMULTA AS MULTA,VALORDESCONTO AS DESCONTO, VALORBAIXADO AS VLBAIXA,* " + CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.FLAN A " + CRLF
	_cQry += " WHERE A.CODCOLIGADA = "+_cKey1+" " + CRLF
	_cQry += " AND A.IDMOV = "+_cIDMov+"  " + CRLF
	_cQry += " AND PAGREC = '1' " + CRLF

	TcQuery _cQry New Alias "TREC"

	_nReg := Contar("TREC","!EOF()")

	If _nReg > 0

		TREC->(dbGoTop())

		While TREC->(!EOF())

			(_cAliasSE1)->(RecLock(_cAliasSE1,.T.))
			(_cAliasSE1)->E1_FILIAL    := _cFil
			(_cAliasSE1)->E1_PREFIXO   := _F2SERIE
			(_cAliasSE1)->E1_NUM       :=_F2DOC

			_cParcela := UPPER(Alltrim(TREC->PARCELA))

			If Empty(_cParcela)
				_nAt := At("-",Alltrim(TREC->NUMERODOCUMENTO))
				If _nAt > 0
					_cParcela := Substr(TREC->NUMERODOCUMENTO,_nAt+1)
				Else
					If Len(TREC->NUMERODOCUMENTO) > 9
						_cParcela := Substr(TREC->NUMERODOCUMENTO,10)
					Endif
				Endif
			Endif

			(_cAliasSE1)->E1_PARCELA   := _cParcela
			(_cAliasSE1)->E1_TIPO      := "NF"
			(_cAliasSE1)->E1_NATUREZ   := 'N1001'
			// (_cAliasSE1)->E1_PORTADO   := (TREC->CNABBANCO)
			// (_cAliasSE1)->E1_AGEDEP    := ??

			(_cAliasSE1)->E1_CLIENTE    := _cCodCli
			(_cAliasSE1)->E1_LOJA       := _cLojCli
			(_cAliasSE1)->E1_NOMCLI     := _cNomCli

			(_cAliasSE1)->E1_EMISSAO    := TREC->DATAEMISSAO
			(_cAliasSE1)->E1_EMIS1      := TREC->DATAEMISSAO

			(_cAliasSE1)->E1_VENCTO     := TREC->DTVENC
			(_cAliasSE1)->E1_VENCREA    := TREC->DTVENC
			(_cAliasSE1)->E1_VENCORI    := TREC->DTVENC
			(_cAliasSE1)->E1_BAIXA      := TREC->DATABAIXA

			(_cAliasSE1)->E1_VALOR      := TREC->VALOR
			(_cAliasSE1)->E1_VLCRUZ     := TREC->VALOR
			(_cAliasSE1)->E1_CODBAR     := TREC->CODIGOBARRA
			(_cAliasSE1)->E1_BASEIRF    := TREC->VALORBASEIRRF
			(_cAliasSE1)->E1_IRRF       := TREC->VALORIRRF
			(_cAliasSE1)->E1_VALLIQ     := TREC->VALOR + TREC->JUROS + TREC->MULTA - TREC->DESCONTO
			(_cAliasSE1)->E1_JUROS      := TREC->JUROS
			(_cAliasSE1)->E1_MULTA      := TREC->MULTA
			(_cAliasSE1)->E1_DESCONT    := TREC->DESCONTO
			(_cAliasSE1)->E1_MOEDA      := 1

			(_cAliasSE1)->E1_HIST       := TREC->HISTORICO
			(_cAliasSE1)->E1_SALDO      := If(TREC->VLBAIXA >= TREC->VALOR, 0 , TREC->VALOR - TREC->VLBAIXA)

			(_cAliasSE1)->E1_MODSPB     := "1"
			(_cAliasSE1)->E1_DESDOBR    := "2"
			(_cAliasSE1)->E1_PROJPMS    := "2"
			(_cAliasSE1)->E1_MULTNAT    := "2"

			// (_cAliasSE1)->E1_ISS :=
			// (_cAliasSE1)->E1_NUMBCO :=
			// (_cAliasSE1)->E1_INDICE :=
			// (_cAliasSE1)->E1_NUMBOR :=
			// (_cAliasSE1)->E1_DATABOR :=

			// (_cAliasSE1)->E1_LA :=
			// (_cAliasSE1)->E1_LOTE :=
			// (_cAliasSE1)->E1_MOTIVO :=
			// (_cAliasSE1)->E1_MOVIMEN :=
			// (_cAliasSE1)->E1_OP :=
			// (_cAliasSE1)->E1_SITUACA :=
			// (_cAliasSE1)->E1_CONTRAT :=
			// (_cAliasSE1)->E1_SUPERVI :=
			// (_cAliasSE1)->E1_VEND1 :=
			// (_cAliasSE1)->E1_VEND2 :=
			// (_cAliasSE1)->E1_VEND3 :=
			// (_cAliasSE1)->E1_VEND4 :=
			// (_cAliasSE1)->E1_VEND5 :=
			// (_cAliasSE1)->E1_COMIS1 :=
			// (_cAliasSE1)->E1_COMIS2 :=
			// (_cAliasSE1)->E1_COMIS3 :=
			// (_cAliasSE1)->E1_COMIS4 :=
			// (_cAliasSE1)->E1_COMIS5 :=

			// (_cAliasSE1)->E1_CORREC :=
			// (_cAliasSE1)->E1_CONTA :=
			// (_cAliasSE1)->E1_VALJUR :=
			// (_cAliasSE1)->E1_PORCJUR :=
			// (_cAliasSE1)->E1_BASCOM1 :=
			// (_cAliasSE1)->E1_BASCOM2 :=
			// (_cAliasSE1)->E1_BASCOM3 :=
			// (_cAliasSE1)->E1_BASCOM4 :=
			// (_cAliasSE1)->E1_BASCOM5 :=
			// (_cAliasSE1)->E1_FATPREF :=
			// (_cAliasSE1)->E1_FATURA :=
			// (_cAliasSE1)->E1_OK :=
			// (_cAliasSE1)->E1_PROJETO :=
			// (_cAliasSE1)->E1_CLASCON :=
			// (_cAliasSE1)->E1_VALCOM1 :=
			// (_cAliasSE1)->E1_VALCOM2 :=
			// (_cAliasSE1)->E1_VALCOM3 :=
			// (_cAliasSE1)->E1_VALCOM4 :=
			// (_cAliasSE1)->E1_VALCOM5 :=
			// (_cAliasSE1)->E1_OCORREN :=
			// (_cAliasSE1)->E1_INSTR1 :=
			// (_cAliasSE1)->E1_INSTR2 :=
			// (_cAliasSE1)->E1_PEDIDO :=
			// (_cAliasSE1)->E1_DTVARIA :=
			// (_cAliasSE1)->E1_VARURV :=
			// (_cAliasSE1)->E1_DTFATUR :=
			// (_cAliasSE1)->E1_NUMNOTA :=
			// (_cAliasSE1)->E1_SERIE :=
			// (_cAliasSE1)->E1_STATUS :=
			// (_cAliasSE1)->E1_ORIGEM :=
			// (_cAliasSE1)->E1_IDENTEE :=
			// (_cAliasSE1)->E1_NUMCART :=
			// (_cAliasSE1)->E1_FLUXO :=
			// (_cAliasSE1)->E1_DESCFIN :=
			// (_cAliasSE1)->E1_DIADESC :=
			// (_cAliasSE1)->E1_TIPODES :=
			// (_cAliasSE1)->E1_CARTAO :=
			// (_cAliasSE1)->E1_CARTVAL :=
			// (_cAliasSE1)->E1_CARTAUT :=
			// (_cAliasSE1)->E1_ADM :=
			// (_cAliasSE1)->E1_VLRREAL :=
			// (_cAliasSE1)->E1_TRANSF :=
			// (_cAliasSE1)->E1_BCOCHQ :=
			// (_cAliasSE1)->E1_AGECHQ :=
			// (_cAliasSE1)->E1_CTACHQ :=
			// (_cAliasSE1)->E1_NUMLIQ :=
			// (_cAliasSE1)->E1_RECIBO :=
			// (_cAliasSE1)->E1_ORDPAGO :=
			// (_cAliasSE1)->E1_INSS :=
			// (_cAliasSE1)->E1_FILORIG :=
			// (_cAliasSE1)->E1_DTACRED :=
			// (_cAliasSE1)->E1_TIPOFAT :=
			// (_cAliasSE1)->E1_TIPOLIQ :=
			// (_cAliasSE1)->E1_CSLL :=
			// (_cAliasSE1)->E1_COFINS :=
			// (_cAliasSE1)->E1_PIS :=
			// (_cAliasSE1)->E1_FLAGFAT :=
			(_cAliasSE1)->(MsUnLock())

			TREC->(dbSkip())
		EndDo
	Endif

	TREC->(dbCloseArea())

Return(Nil)



Static Function GeraFOR(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA2)

	If TCLI->PESSOA = "J"
		(_cAliasSA2)->(dbSetOrder(3))
		If (_cAliasSA2)->(MsSeek(xFilial("SA2")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA2)->A2_COD
		Endif
	Endif

	GetNxtA2(@_cCod,@_cLoja)

	(_cAliasSA2)->(RecLock(_cAliasSA2,.T.))
	(_cAliasSA2)->A2_COD     := _cCod
	(_cAliasSA2)->A2_LOJA    := _cLoja
	(_cAliasSA2)->A2_NOME    := UPPER(U_RM_NoAcento(TCLI->NOME))
	(_cAliasSA2)->A2_NREDUZ  := UPPER(U_RM_NoAcento(TCLI->NREDUZ))
	(_cAliasSA2)->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TCLI->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCLI->NUMERO)))
	(_cAliasSA2)->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TCLI->COMPLEM)))
	(_cAliasSA2)->A2_TIPO    := TCLI->PESSOA
	(_cAliasSA2)->A2_EST     := TCLI->CODETD
	(_cAliasSA2)->A2_COD_MUN := TCLI->COD_MUN
	(_cAliasSA2)->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TCLI->CIDADE)))
	(_cAliasSA2)->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TCLI->BAIRRO)))
	(_cAliasSA2)->A2_NATUREZ := "N3002"
	(_cAliasSA2)->A2_CEP     := StrTran(TCLI->CEP,".","")
	(_cAliasSA2)->A2_TEL     := TCLI->TELEFONE
	(_cAliasSA2)->A2_PAIS    := "105"
	(_cAliasSA2)->A2_CGC     := _cCNPJ
	(_cAliasSA2)->A2_CONTATO := TCLI->CONTATO
	(_cAliasSA2)->A2_INSCR   := IIF (EMPTY(TCLI->INSCR),"ISENTO","")
	(_cAliasSA2)->A2_CODPAIS := "01058"
	(_cAliasSA2)->A2_EMAIL   := TCLI->EMAIL
	(_cAliasSA2)->A2_MSBLQL  := If(TCLI->ATIVO=1,"2","1")
	(_cAliasSA2)->A2_INSCRM  := TCLI->INSCRM
	(_cAliasSA2)->A2_CONTRIB  := If(TCLI->CONTRIB = 1,"2","1")
	(_cAliasSA2)->(MsUnLock())

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



Static Function VldGeraFin(_D2CF,_F2TIPO)

	Local _cRetFin := 'S'
	Local _aCFOPRem:= {'5116','5151','5152','5901','5902','5903','5908','5909','5910','5915','5949','6901','6902','6910','6915','6949','5201','5413','5556','5921','5949','6202','6413','6556'}
	Local _lRem    := (aScan(_aCFOPRem,_D2CF) > 0)

	If _F2TIPO = 'D' .Or. _lRem
		_cRetFin := 'N'
	Endif

Return(_cRetFin)



Static Function LoadSF4()

	Local _aRetSF4 := {}

	SF4->(dbSetOrder(1))

	SF4->(dbGoTop())

	While SF4->(!EOF())

		AAdd(_aRetSF4,{Alltrim(SF4->F4_YCHAVRM),SF4->F4_CODIGO})

		SF4->(dbSkip())
	EndDo

Return(_aRetSF4)



Static Function CheckOrig(_cEmp,_cFil)

	Local _cRet		:= ''
	Local _cOrigRM	:= Alltrim(Str(TRB->COLORIG))+Alltrim(Str(TRB->FILORIG))
	Local _nPOrig	:= aScan(_aEmp,{|x| x[3] == _cOrigRM })
	Local _cOrig	:= If(_nPOrig > 0,_aEmp[_nPOrig][2],'')

	If !Empty(_cOrig)
		_cRet := _cOrig
	Else
		_cRet := _cEmp+_cFil
	Endif

Return(_cRet)
