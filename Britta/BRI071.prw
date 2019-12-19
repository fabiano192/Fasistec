#Include "DBTREE.CH"
#include "topconn.ch"
#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRI071   ºAutor  ³Alexandro da Silva  º Data ³  24/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacao de documentos                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gerencial                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BRI071()

/*
MZ202_A-fGrvLibBor
BRI71_B-FGRVREAV
BRI71_C-VISUALIZA
BRI71_D-VISUALIZA TODOS
BRI71_E-BLOQUEIO

*/

    Private cBmp5 := "FOLDER5"
    Private cBmp6 := "FOLDER6"

    Private cBmp9 := "FOLDER9"
    Private cBmp10:= "FOLDER10"
    Private _ctp
    Private _lOutEmp
    Private _cEmpresa, _CFILIAL

    ca097User := RetCodUsr()
    dbSelectArea("SAK")
    dbSetOrder(2)
    If !MsSeek(xFilial("SAK")+ca097User)
        Help(" ",1,"A097APROV")
        dbSelectArea("ZAH")
        dbSetOrder(1)
        Return
    Endif

    Private cPerg    := "BRI071"

    Private _cEmpOri1:= cEmpAnt

    ATUSX1()

    _cTpDoc := Alltrim(STRTRAN( SAK->AK_YTPLIB, "*", "" ))
    _cTp    := "('"

    If Len(_cTpDoc) == 2
        _cTp    := "('"+_cTpdoc+"')"
    Else
        For AZ:= 1 TO Len(_cTpDoc) step 2
            _cTp += Substr(_cTpDoc,AZ,2)+"','"
        Next AZ

        _cTp := Substr(_cTp,1,Len(_cTp)-2)
        _cTp := _cTp+")"
    Endif

    _cTp    := STRTRAN(_cTp,'01','PC')
    _cTp    := STRTRAN(_cTp,'09','NF')
    _cTpDoc := Alltrim(STRTRAN( SAK->AK_YTPLIB, "01", "PC" ))
    _cTpDoc := Alltrim(STRTRAN( _cTpDoc, "09", "NF" ))
    _cAprovador := SAK->AK_COD

    If !Pergunte(cPerg,.T.)
        Return
    Endif

    Static oDlg
    Static oDBTree2

    Private aBotoes := _aHdr := {}
    Private oGroup1
    Private oGroup3
    Private oGroup4
    Private oGroup5
    Private oSay10
    Private oSay11
    Private oSay12
    Private oSay13
    Private oSay2
    Private oSay7
    Private oSay8
    Private oSay9
    Private cPrompAnt
    Private cPrompAnt4
    Private cPrompt
    Private oOk     := LoadBitmap( GetResources(), "LBOK")
    Private oNo     := LoadBitmap( GetResources(), "LBNO")
    Private oVerde  := LoadBitmap( GetResources(), "BR_VERDE")
    Private oAzul 	:= LoadBitmap( GetResources(), "BR_AZUL")
    Private oCinza  := LoadBitmap( GetResources(), "BR_CINZA")
    Private oVerm   := LoadBitmap( GetResources(), "BR_VERMELHO")
    Private oWBrowse2
    Private aWBrowse2 := {}
    Private nTotGer := nQtd := 0

    _aEmpresas:= {"0201","0202","0203","0205","0206","0207","0208","0209","0210","0211","0212","0213","0214","0401",;
        "0402","0602","0902","1301","1302","1304","1306","1307","1601",;
        "5001","5002","5003","5004","5005","5006","5007","5008","5009","5010"}

    Private nPosFil := nPosDat := nPosBor := nPosPor := nPosAge := nPosCon := nPosTot := nPosMen := nPosMai := nPosQtd := nPosEmp := nPos1Lb := nPos2Lb := nPosRej := 0

// Prepara o titulo
    Private cTitulo := "Liberação de Documentos"

// Ler as coordenadas da janela principal
    oMainWnd:ReadClientCoords()

    DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO oMainWnd:nBottom-50, oMainWnd:nRight-30 COLORS 0, 16777215 PIXEL

//Linha,Coluna
    @ 005, 000 GROUP oGroup3 TO 275, 175 PROMPT "Empresa + Tipo de Liberacao" OF oDlg COLOR 0, 16777215 PIXEL //OK

    DEFINE DBTREE oDBTree2 FROM 020, 001 TO 265, 170 OF oGroup3

    cCodAnt := ""

    _aTpLib := {""}
    _aAliSM0:= SM0->(GetArea())

    _aEmp:= PswRet()[2][6]
    _cCargo := "EMPRESA"

    If _aEmp[1] != "@@@@"
        _aEmpresas := _aEmp
    Endif

    _aEmp2 := {}

    For AX:= 1 To Len(_aEmpresas)

        nAchou := Ascan(_aEmp2,Left(_aEmpresas[AX],4))
        If nAchou = 0
            Aadd(_aEmp2,Alltrim(Left(_aEmpresas[AX],4)))
        Else
            Loop
        EndIf

        _cEmp    := Left(_aEmpresas[AX],2)
        _cFilEmp := Substr(_aEmpresas[AX],3,2)

        SM0->(dbSetOrder(1))
        SM0->(dbSeek(Left(_aEmpresas[AX],4)))

        If Upper(Alltrim(GETENVSERVER())) $ "AS"
            _cQ := " DELETE ZAH"+_cEmp+"0 FROM ZAH"+_cEmp+"0 A LEFT JOIN SEA"+_cEmp+"0 B ON ZAH_FILIAL = EA_FILIAL AND ZAH_NUM = EA_NUMBOR "
            _cQ += " AND B.D_E_L_E_T_ = '' AND EA_CART = 'P' "
            _cQ += " WHERE A.D_E_L_E_T_ = '' AND ZAH_TIPO = '06' AND EA_NUM IS NULL "

            TCSqlExec(_cQ)

            _cQ := " DELETE SCR"+_cEmp+"0 FROM SCR"+_cEmp+"0 A LEFT JOIN SEA"+_cEmp+"0 B ON CR_FILIAL = EA_FILIAL AND CR_NUM = EA_NUMBOR "
            _cQ += " AND B.D_E_L_E_T_ = '' AND EA_CART = 'P' "
            _cQ += " WHERE A.D_E_L_E_T_ = '' AND CR_TIPO = '06' AND EA_NUM IS NULL "

            TCSqlExec(_cQ)
        Endif

        _cQ  := " SELECT COUNT(*) AS QTREG FROM ZAH"+_cEmp+"0 A WHERE A.D_E_L_E_T_ = '' "
        _cQ += " AND ZAH_USER = '"+ca097User+"' AND ZAH_TIPO IN "+_cTp+" "
        _cQ += " AND ZAH_FILIAL = '"+_cFilEmp+"' "

        If MV_PAR01 == 2
            _cQ += " AND ZAH_STATUS = '04' "
        Else
            _cQ += " AND ZAH_STATUS = '02' AND ZAH_DATALI = '' "
        Endif

        _cQ += " AND ZAH_EMISSA >= '"+DTOS(MV_PAR02)+"'"

        TCQUERY _cQ NEW ALIAS "ZZ"

        If ZZ->QTREG > 0
            cBmp09 := "FOLDER10"
            cBmp10 := "FOLDER10"
        Else
            cBmp09 := "FOLDER5"
            cBmp10 := "FOLDER6"
        Endif

        ZZ->(dbCloseArea())

        DBADDTREE oDBTree2 PROMPT SM0->M0_CODIGO+SM0->M0_CODFIL+"-"+SM0->M0_FILIAL+Space(25) CARGO SM0->M0_FILIAL  CARGO _cCargo RESOURCE cBmp09,cBmp10 // item
        Private &("aWBr"+SM0->M0_CODIGO+SM0->M0_CODFIL) := {}

        SX5->(dbSetOrder(1))
        If SX5->(dbSeek(xFilial("SX5")+"ZK" ))

            _cChavSX5 := SX5->X5_TABELA

            While SX5->(!Eof()) .And. _cChavSX5 == SX5->X5_TABELA

                _cAli := "_ALI"+SM0->M0_CODIGO+SM0->M0_CODFIL+Alltrim(SX5->X5_CHAVE)
                _cCargo := SM0->M0_CODIGO+SM0->M0_CODFIL+Alltrim(SX5->X5_CHAVE)

                If Alltrim(SX5->X5_CHAVE) = "01"
                    _cTp2 := "PC"
                ElseIf Alltrim(SX5->X5_CHAVE) = "09"
                    _cTp2 := "NF"
                Else
                    _cTp2 := Alltrim(SX5->X5_CHAVE)
                Endif

                If !_cTp2 $ _cTp
                    SX5->(dbSkip())
                    Loop
                Endif

                If Select(_cAli) > 0
                    dbSelectArea(_cAli)
                    dbCloseArea()
                Endif

                _cQ := " SELECT ZAH_NUM,ZAH_TIPO,ZAH_OBS,ZAH_EMISSA,ZAH_USER,ZAH_TOTAL,ZAH_DATALI,SPACE(1) AS LIBER,ZAH_MSFIL "
                _cQ += " FROM ZAH"+_cEmp+"0 A WHERE A.D_E_L_E_T_ = '' "
                _cQ += " AND ZAH_USER = '"+ca097User+"' AND ZAH_TIPO = '"+_cTp2+"' "
                If MV_PAR01 == 2
                    _cQ += " AND ZAH_STATUS = '04' "
                Else
                    _cQ += " AND ZAH_STATUS = '02' AND ZAH_DATALI = '' "
                Endif

                _cQ += " AND ZAH_FILIAL = '"+_cFilEmp+"' "

                _cQ += " AND ZAH_EMISSA >= '"+DTOS(MV_PAR02)+"'"
                _cQ += " ORDER BY ZAH_NUM "

                TCQUERY _cQ NEW ALIAS &(_cAli)

                TCSETFIELD(_cAli,"ZAH_EMISSA","D")
                TCSETFIELD(_cAli,"ZAH_DATALI","D")

                _cCampo := _cAli+"->ZAH_USER"

                If !Empty(&_cCampo)
                    cBmp09 := "FOLDER10"
                    cBmp10 := "FOLDER10"
                Else
                    cBmp09 := "FOLDER5"
                    cBmp10 := "FOLDER6"
                Endif

                DBADDTREE oDBTree2 PROMPT SM0->M0_CODIGO+SM0->M0_CODFIL+Alltrim(SX5->X5_CHAVE)+"-"+Alltrim(SX5->X5_DESCRI) CARGO _cCargo  RESOURCE cBmp09,cBmp10// item

                Private &("aWBr"+SM0->M0_CODIGO+SM0->M0_CODFIL+Alltrim(SX5->X5_CHAVE)) := {}

                DBENDTREE oDBTree2

                SX5->(dbSkip())
            EndDo

            DBENDTREE oDBTree2
        EndIf

    Next Ax

    RestArea(_aAliSM0)

    oDBTree2:bLDblClick := {|| If(IsDigit(Left(oDBTree2:GetPrompt(),4)),Processa({|lEnd| FAlteraDBTree(oDBTree2:GetPrompt())},"Selecionando Documentos...",,.T.),nil)}

    @ 005, 177 GROUP oGroup4 TO 275, 640 PROMPT "Marque os Documentos" OF oDlg COLOR 0, 16777215 PIXEL
// Linha, Coluna

    @ 25.2,050 BUTTON  "Pesquisar"          SIZE 50,10 ACTION Pesquisar(aWBrowse2)
    @ 25.2,065 BUTTON  "Visualizar"         SIZE 50,10 ACTION BRI71_C("V",oDBTree2:GetPrompt())
    @ 25.2,080 BUTTON  "Liberar"            SIZE 50,10 ACTION BRI71_C("L",oDBTree2:GetPrompt())
    @ 25.2,095 BUTTON  "DesMarcar Todos"    SIZE 50,10 ACTION MarkTd(aWBrowse2,.f.)
    @ 25.2,110 BUTTON  "Marcar Todos"       SIZE 50,10 ACTION MarkTd(aWBrowse2,.T.)
    @ 25.2,125 BUTTON  "Bloquear"           SIZE 50,10 ACTION BRI71_C("B",oDBTree2:GetPrompt())
    @ 25.2,140 BUTTON  "Fechar"             SIZE 50,10 ACTION odlg:End()
// Linha, Coluna

    fWBrowse2()

//oWBrowse2:Align := CONTROL_ALIGN_ALLCLIENT

    ACTIVATE MSDIALOG oDlg CENTERED


Return

//------------------------------------------------
Static Function fWBrowse2()
//------------------------------------------------

// Insert          1  2   3           4           5           6         7       8               9          10
//Aadd(aWBrowse2,{  ,.F.,"Documento","Tipo doc","Observacao","Emissao","Valor","Liberado","Data Liberacao,"Filial"})
    Aadd(aWBrowse2,  {"",.F.,""         ,""       ,""           ,""       ,""     ,""             ,""        ,""})
    oGroup4:ReadClientCoords()

//                                           1   2  3           4           5                     6          7         8               9           10    //@ 020, 180 LISTBOX oWBrowse2   Fields HEADER "","","Documento","Tipo Doc","Observação","Emissao" ,"Valor"  ,"Data Liberacao","Filial Original" SIZE 450,190 OF oGroup4 PIXEL ColSizes 50,50
    @ 020, 180 LISTBOX oWBrowse2   Fields HEADER "","","Documento","Tipo Doc","Observação"+Space(20),"Emissao" ,"Valor"  ,"Liberador","Data Liberacao","Filial Original" SIZE 450,230 OF oGroup4 PIXEL ColSizes 50,50
//linha Inferior,coluna Esquerda                                                                                                                                 coluna Direita,linha Inferior
    oWBrowse2:SetArray(aWBrowse2)

    oWBrowse2:bLine := {|| {If ( Empty(aWBrowse2[oWBrowse2:nAT,09]),oVerde,oVerm ),If(aWBrowse2[oWBrowse2:nAT,2],oOk,oNo),;
        aWBrowse2[oWBrowse2:nAt,3],;
        aWBrowse2[oWBrowse2:nAt,4],;
        aWBrowse2[oWBrowse2:nAt,5],;
        aWBrowse2[oWBrowse2:nAt,6],;
        aWBrowse2[oWBrowse2:nAt,7],;
        aWBrowse2[oWBrowse2:nAt,8],;
        aWBrowse2[oWBrowse2:nAt,9],;
        aWBrowse2[oWBrowse2:nAt,10]}}

    oWBrowse2:bHeaderClick := {|| Inverte(aWBrowse2,.T.) }

    oWBrowse2:bLDblClick := {|| aWBrowse2[oWBrowse2:nAt,2] := !aWBrowse2[oWBrowse2:nAt,2],;
        oWBrowse2:DrawSelect(),VldMarca()}
    oWBrowse2:Refresh()

Return


Static Function FAlteraDBTree(cPrompt)

    Default cPrompt := ""

    If Substring(cPrompt,5,1) = "-"
        Return
    Endif

    If cPrompAnt == Left(cPrompt,4) .and. Len(aWBrowse2) > 0 .And. Substring(cPrompt,5,1) = "-"
        Return
    Endif

    If cPrompAnt == Left(cPrompt,6) .and. Len(aWBrowse2) > 0 .And. Substring(cPrompt,5,1) != "-"
        Return
    Endif

    &("aWBr"+Substr(cPrompt,1,6)) := {}
    aWBrowse2 := {}

    If Substr(cPrompt,5,2) = "01"
        _cTp := "PC"
    ElseIf Substr(cPrompt,5,2) = "09"
        _cTp := "NF"
    Else
        _cTp := Substr(cPrompt,5,2)
    Endif

    _cAli := "_ALI"+Substr(cPrompt,1,4)+Substr(cPrompt,5,2)

    dbSelectArea(_cAli)

    ProcRegua((LastRec()))

    dbSelectArea(_cAli)
    dbGoTop()

    If !Empty(ZAH_USER)
        While !Eof()

            IncProc("Documento:"+ZAH_NUM)

            If Empty(ZAH_NUM)
                dbSelectArea(_cAli)
                dbSkip()
            Endif

            If ZAH_TIPO == "PC"
                _cObs := ZAH_OBS+Space(15)
            Else
                _cObs := ZAH_OBS
            Endif

            Aadd(aWBrowse2,{"",.F.,ZAH_NUM,ZAH_TIPO,_cObs,ZAH_EMISSA,Transform(ZAH_TOTAL,"@E 999,999,999.99"),ZAH_USER,ZAH_DATALI,ZAH_MSFIL})

            dbSelectArea(_cAli)
            dbSkip()
        Enddo
    Else
        cBmp09 := "FOLDER5"
        cBmp10 := "FOLDER6"
        oDBTree2:Refresh()
    Endif

    aCopy(aWBrowse2,&("aWBr"+Substr(cPrompt,1,6)) )

// guarda a array selecionada de acordo com a arvore
    If Len(aWBrowse2) > 0 .and. !Empty(aWBrowse2[1][3])
        &("aWBr"+Substr(cPrompt,1,6)) := {}
        &("aWBr"+Substr(cPrompt,1,6)) := aClone(aWBrowse2)

    Endif
// grava a seleção atual
    cPrompAnt := Left(cPrompt,4)
    cPrompAnt4 := Left(cPrompt,6)

    oWBrowse2:SetArray(aWBrowse2)

    oWBrowse2:bLine := {|| {If ( Empty(aWBrowse2[oWBrowse2:nAT,09]),oVerde,oVerm ),If(aWBrowse2[oWBrowse2:nAT,2],oOk,oNo),;
        aWBrowse2[oWBrowse2:nAt,3],;
        aWBrowse2[oWBrowse2:nAt,4],;
        aWBrowse2[oWBrowse2:nAt,5],;
        aWBrowse2[oWBrowse2:nAt,6],;
        aWBrowse2[oWBrowse2:nAt,7],;
        aWBrowse2[oWBrowse2:nAt,8],;
        aWBrowse2[oWBrowse2:nAt,9],;
        aWBrowse2[oWBrowse2:nAt,10],}}

// DoubleClick event
    oWBrowse2:bLDblClick := {|| aWBrowse2[oWBrowse2:nAt,2] := !aWBrowse2[oWBrowse2:nAt,2],;
        oWBrowse2:DrawSelect(),VldMarca()}

    oWBrowse2:Refresh()

Return


Static Function Pesquisar(aWBrowse2)

    Local nPosSeek

    ATUSX1B()

    If Pergunte("BRI071B",.T.)
        nPosSeek := aScan(aWBrowse2,{|x| x[3]==MV_PAR01	})
        If nPosSeek > 1
            oWBrowse2:nAt := nPosSeek
            oWBrowse2:Refresh()
        Endif
    Endif

Return


Static Function MarkTd(aWBrowse2,lFlag)

    For q := 1 To Len(aWBrowse2)
        If aWBrowse2[q][2] != lFlag

            If Empty(aWBrowse2[q,4])
                Return .f.
            Endif
            If !Empty(aWBrowse2[q,09])
                aWBrowse2[q,2] := .F.
                Loop
            EndIf

            aWBrowse2[q][2] := lFlag

            If  aWBrowse2[q,2]
                nTotGer += Val(aWBrowse2[q,7])
                nQtd++
            Else
                nTotGer -= Val(aWBrowse2[q,7])
                nQtd--
            Endif

        Endif
    Next

    oWBrowse2:Refresh()

Return

Static Function Inverte(aWBrowse2)

    For j := 1 To Len(aWBrowse2)

        If Empty(aWBrowse2[j,4])
            Return .f.
        Endif
        If !Empty(aWBrowse2[j,9])
            aWBrowse2[j,2] := .F.
            Loop
        EndIf

        aWBrowse2[j][2] := !aWBrowse2[j][2]

    Next

    oWBrowse2:Refresh()
Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
    If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
    ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
    Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
    EndIf

Return(nTam)

Static Function VldMarca(nPos)

Default nPos := oWBrowse2:nAt

    If Empty(aWBrowse2[nPos,4])
	Return .f.
    Endif
    If !Empty(aWBrowse2[nPos,09])
	Msgalert("Este Documento Foi liberado!")
	aWBrowse2[nPos,2] := .F.
	Return .f.
    EndIf

    If  aWBrowse2[nPos,2]
	nTotGer += Val(aWBrowse2[nPos,7])
	nQtd++
    Else
	nTotGer -= Val(aWBrowse2[nPos,7])
	nQtd--
    Endif

Return


Static Function BRI71_C(_cMod,_cPrompt)

_lGo := .T.

    If _cMod == 'B'
        If !MsgYesNo("Confirma o Bloqueio do(s) Documentos Marcado(s)?")
		_lGo := .F.
        Endif
    Endif

    If !_lGo
	Return()
    Endif

Private _cTipoZAH, _cNumZAH, _cUserZAH

    For AM := 1 To Len(aWBrowse2)

	_lPassou := .F.

        If  aWBrowse2[AM,2]
		_cTipoZAH := aWBrowse2[AM,4]
		_cNumZAH  := aWBrowse2[AM,3]
		_cUserZAH := aWBrowse2[AM,8]
		_cFilZAH  := aWBrowse2[AM,10]
		_cEmpresa := Substr(_cPrompt,1,2)
		_cFILIAL  := Substr(_cPrompt,3,2)

            If _cEmpOri1 != _cEmpresa// .And. !_lPassou
			_lPassou := .T.
            Endif

		BRI71_D(_cMod,_lPassou,AM)

        Endif
    Next AM

    If _cMod == "L"

	aWBrowBkp:= aClone(aWBrowse2)

	//aCopy(aWBrowse2,aWBrowBkp )

	aWBrowse2 := {}
	_lEncont  = .F.

        For AX := 1 To Len(aWBrowBkp)

            If Empty(aWBrowBkp[AX,9])
			_lEncont:= .T.
			_cNum2  := aWBrowBkp[AX,03]
			_cTipo2 := aWBrowBkp[AX,04]
			_cObs2  := aWBrowBkp[AX,05]
			_cEmis2 := aWBrowBkp[AX,06]
			_cTot2  := aWBrowBkp[AX,07]
			_cUser2 := aWBrowBkp[AX,08]
			_cDtLib2:= aWBrowBkp[AX,09]
			_cFil2  := aWBrowBkp[AX,10]

			//              1   2   3        4       5      6      7       8         9     10
			Aadd(aWBrowse2,{"",.F.,_cNum2,_cTipo2,_cObs2,_cEmis2,_cTot2,_cUser2,_cDtLib2,_cFil2})
            Endif

        Next AX

        If !_lEncont
		Aadd(aWBrowse2,  {"",.F.,""         ,""       ,""           ,""       ,""     ,""             ,""        ,""})
		cBmp09 := "FOLDER5"
		cBmp10 := "FOLDER6"
		oDBTree2:Refresh()
        Endif

	oWBrowse2:SetArray(aWBrowse2)
	oWBrowse2:bLine := {|| {If ( Empty(aWBrowse2[oWBrowse2:nAT,09]),oVerde,oVerm ),If(aWBrowse2[oWBrowse2:nAT,2],oOk,oNo),;
	aWBrowse2[oWBrowse2:nAt,3],;
	aWBrowse2[oWBrowse2:nAt,4],;
	aWBrowse2[oWBrowse2:nAt,5],;
	aWBrowse2[oWBrowse2:nAt,6],;
	aWBrowse2[oWBrowse2:nAt,7],;
	aWBrowse2[oWBrowse2:nAt,8],;
	aWBrowse2[oWBrowse2:nAt,9],;
	aWBrowse2[oWBrowse2:nAt,10],}}

	// DoubleClick event
	oWBrowse2:bLDblClick := {|| aWBrowse2[oWBrowse2:nAt,2] := !aWBrowse2[oWBrowse2:nAt,2],;
	oWBrowse2:DrawSelect(),VldMarca()}

	oWBrowse2:Refresh()

    Endif

Return


Static Function BRI71_D(_cMod,_lOutEmp,_nCont)

_aAliORI  := GetArea()
_aAliSM0  := SM0->(GetArea())
_aAliZAH  := ZAH->(GetArea())

PRIVATE aRotina	:= {{OemToAnsi("Pesquisar"),"Ma097Pesq",   0 , 1, 0, .F.},;
{OemToAnsi("Consulta Documento"),"U_MZ110_03",  0 , 2, 0, nil},;
{OemToAnsi("Liberar"),"U_MZ110_01",  0 , 4, 0, nil},;
{OemToAnsi("Legenda"),"U_MZ110_04",  0 , 2, 0, .F.}}

    If _cMod == "V"
	nOpcx := 1
    Else
	nOpcx := 3
    Endif

_lParar   := .T.
_nSdoLim  := 0
_nSdoTit  := 0

_cEmpOri := cEmpAnt
_cFilOri := cFilAnt

_aAliAIA := AIA->(GetArea())
_aAliAIB := AIB->(GetArea())
_aAliSC7 := SC7->(GetArea())
_aAliSCR := SCR->(GetArea())
_aAliSE2 := SE2->(GetArea())
_aAliSEA := SEA->(GetArea())
/*
_aAliSZ1 := SZ1->(GetArea())
_aAliSZI := SZI->(GetArea())
_aAliSZG := SZG->(GetArea())
_aAliZA2 := ZA2->(GetArea())
_aAliZA4 := ZA4->(GetArea())
_aAliZA5 := ZA5->(GetArea())
_aAliZA6 := ZA6->(GetArea())
*/
    If _lOutEmp

        //If _cEmpresa == "50"
        cModo := "E"  /// sc7, SCR
        //Else
        //	cModo := "C"  /// sc7, SCR
        //Endif

        EmpOpenFile("SCR","SCR",1,.T.,_cEmpresa,@cModo)

        If _cTipoZAH == "PC"
            EmpOpenFile("SC7","SC7",1,.T.,_cEmpresa,@cModo)
        ElseIf _cTipoZAH == "50"
            cModo := "E"
            EmpOpenFile("SZI","SZI",1,.T.,_cEmpresa,@cModo)
            cModo := "C"
            EmpOpenFile("ZA2","ZA2",1,.T.,_cEmpresa,@cModo)
            EmpOpenFile("ZA4","ZA4",1,.T.,_cEmpresa,@cModo)
        ElseIf _cTipoZAH == "03"
            cModo := "C"
            EmpOpenFile("ZA5","ZA5",1,.T.,_cEmpresa,@cModo)
            cModo := "E"
            EmpOpenFile("SZG","SZG",1,.T.,_cEmpresa,@cModo)
        ElseIf _cTipoZAH == "04"
            cModo := "E"
            EmpOpenFile("AIA","AIA",1,.T.,_cEmpresa,@cModo)
            EmpOpenFile("AIB","AIB",1,.T.,_cEmpresa,@cModo)
        ElseIf _cTipoZAH == "05"
            cModo := "C"
            EmpOpenFile("ZA6","ZA6",1,.T.,_cEmpresa,@cModo)
        ElseIf _cTipoZAH == "06"
            EmpOpenFile("SEA","SEA",1,.T.,_cEmpresa,@cModo)
            EmpOpenFile("SE2","SE2",1,.T.,_cEmpresa,@cModo)
        ElseIf _cTipoZAH == "07"
            cModo := "E"
            EmpOpenFile("SZI","SZI",1,.T.,_cEmpresa,@cModo)
            cModo := "C"
            EmpOpenFile("ZA6","ZA6",1,.T.,_cEmpresa,@cModo)
        Endif
    Endif

    SCR->(dbSetOrder(2))
//If _cEmpresa == "50"
    cFilAnt := _cFilZAH
    cEmpAnt := _cEmpresa
    SCR->(dbSeek(_cFilZAH + _cTipoZAH + _cNumZAH + _cUserZAH))
//Else
//	SCR->(dbSeek(xFilial("SCR")+_cTipoZAH + _cNumZAH + _cUserZAH))
//Endif

    If SCR->CR_TIPO == "PC"

        Private   Acols	:={}
        Private _nOpcX := 2

        Private VISUAL := (_nOpcX == 2)

        Private aHeader := {}
        Private _nOpcao := _nOpcX

        _nOpcE   := _nOpcX
        _nOpcG   := _nOpcX

        _aCampos := {"C7_ITEM","C7_PRODUTO","C7_DESCRI","C7_UM","C7_QUANT","C7_PRECO","C7_TOTAL","C7_TES","C7_DATPRF","C7_OBS"}

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                    x3_tamanho, x3_decimal,x3_valid,;
                    x3_usado, x3_tipo, x3_arquivo, x3_context } )
            Endif
        Next Ax

        Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "C7_ITEM"    } )
        Private _nPPRODUTO:= aScan( aHeader, { |x| Alltrim(x[2])== "C7_PRODUTO" } )
        Private _nPDESCRI := aScan( aHeader, { |x| Alltrim(x[2])== "C7_DESCRI"  } )
        Private _nPUM     := aScan( aHeader, { |x| Alltrim(x[2])== "C7_UM"      } )
        Private _nPQUANT  := aScan( aHeader, { |x| Alltrim(x[2])== "C7_QUANT"   } )
        Private _nPPRECO  := aScan( aHeader, { |x| Alltrim(x[2])== "C7_PRECO"   } )
        Private _nPTOTAL  := aScan( aHeader, { |x| Alltrim(x[2])== "C7_TOTAL"   } )
        Private _nPTES    := aScan( aHeader, { |x| Alltrim(x[2])== "C7_TES"     } )
        Private _nPENTREGA:= aScan( aHeader, { |x| Alltrim(x[2])== "C7_DATPRF"  } )
        Private _nPOBS    := aScan( aHeader, { |x| Alltrim(x[2])== "C7_OBS"     } )

        _cFORNECE := Space(06)
        _cLOJA    := Space(02)
        _dEMISSAO := CTOD("")
        _cNOMUSER := ""
        _cPEDIDO  := Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM))
        aCols     := {}

        _cNOMFOR  := ""
        _nTOTPED  := 0

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := xFilial("SC7")
        //Endif

        dbSelectArea("SC7")
        dbSetOrder(1)
        If MsSeek(_cFilNew + Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))

            _cFORNECE := SC7->C7_FORNECE
            _cLOJA    := SC7->C7_LOJA
            _dEMISSAO := SC7->C7_EMISSAO
            _cNOMUSER := UsrFullName(SC7->C7_USER)
            _cPEDIDO  := Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM))
            aCols     := {}

            SA2->(dbSetorder(1))
            SA2->(dbSeek(xFilial("SA2")+_cFORNECE + _cLOJA))

            _cNOMFOR := SA2->A2_NOME
            _nTOTPED := _nDESPESA := _nMERCAD := _nOUTROS := _NFRETE := 0

            _cChavSC7 := SC7->C7_NUM

            While SC7->(!Eof()) .And. _cChavSC7 == SC7->C7_NUM

                AADD(aCols,Array(Len(_aCampos)+1))

                aCols[Len(aCols),_NPITEM]    := SC7->C7_ITEM
                aCols[Len(aCols),_NPPRODUTO] := SC7->C7_PRODUTO
                aCols[Len(aCols),_NPDESCRI]  := SC7->C7_DESCRI
                aCols[Len(aCols),_NPUM]      := SC7->C7_UM
                aCols[Len(aCols),_NPQUANT]   := SC7->C7_QUANT
                aCols[Len(aCols),_NPPRECO]   := SC7->C7_PRECO
                aCols[Len(aCols),_NPTOTAL]   := SC7->C7_TOTAL
                aCols[Len(aCols),_NPTES]     := SC7->C7_TES
                aCols[Len(aCols),_NPENTREGA] := SC7->C7_DATPRF
                aCols[Len(aCols),_NPOBS]     := SC7->C7_OBS

                _NMERCAD  += SC7->C7_TOTAL
                _NDESPESA += SC7->C7_DESPESA
                _NFRETE   += SC7->C7_VALFRE

                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                SC7->(dbSkip())
            EndDo
        Endif

        _NOUTROS:= _NDESPESA + _NFRETE
        _nTOTPED:= _NMERCAD  + _NOUTROS

        _lEdit  := .F.

        cTitulo       := "PEDIDO DE COMPRA"
        cAliasGetD    := "SC7"
        cLinOk        := "AllwaysTrue()"
        cTudOk        := "AllwaysTrue()"
        cFieldOk      := "AllwaysTrue()"

        _lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRetMod2 .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew       ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4      5
                U_BRI072(_cEmpresa, _cFilNew,_cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif

    ElseIf SCR->CR_TIPO == "NF"
        Private   Acols	:={}
        Private _nOpcX := 2

        Private VISUAL := (_nOpcX == 2)

        Private aHeader := {}
        Private _nOpcao := _nOpcX

        _nOpcE   := _nOpcX
        _nOpcG   := _nOpcX

        _aCampos := {"D1_ITEM","D1_COD","D1_DESCRI","D1_UM","D1_QUANT","D1_VUNIT","D1_TOTAL","D1_TES","D1_DTDIGIT"}

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                    x3_tamanho, x3_decimal,x3_valid,;
                    x3_usado, x3_tipo, x3_arquivo, x3_context } )
            Endif
        Next Ax

        Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "D1_ITEM"    } )
        Private _nPPRODUTO:= aScan( aHeader, { |x| Alltrim(x[2])== "D1_COD"     } )
        Private _nPDESCRI := aScan( aHeader, { |x| Alltrim(x[2])== "D1_DESCRI"  } )
        Private _nPUM     := aScan( aHeader, { |x| Alltrim(x[2])== "D1_UM"      } )
        Private _nPQUANT  := aScan( aHeader, { |x| Alltrim(x[2])== "D1_QUANT"   } )
        Private _nPVUNIT  := aScan( aHeader, { |x| Alltrim(x[2])== "D1_VUNIT"   } )
        Private _nPTOTAL  := aScan( aHeader, { |x| Alltrim(x[2])== "D1_TOTAL"   } )
        Private _nPTES    := aScan( aHeader, { |x| Alltrim(x[2])== "D1_TES"     } )
        Private _nPDTDIGIT:= aScan( aHeader, { |x| Alltrim(x[2])== "D1_DTDIGIT" } )
        //Private _nPOBS    := aScan( aHeader, { |x| Alltrim(x[2])== "C7_OBS"     } )

        _cFORNECE := Space(06)
        _cLOJA    := Space(02)
        _dEMISSAO := CTOD("")
        _cNOMUSER := ""
        _cNOTA    := Substr(SCR->CR_NUM,1,Len(SD1->D1_DOC))
        aCols     := {}

        _cNOMFOR  := ""
        _nTOTPED  := 0

        dbSelectArea("SD1")
        dbSetOrder(1)
        If MsSeek(SCR->CR_FILIAL + Alltrim(SCR->CR_NUM) )

            _cFORNECE := SD1->D1_FORNECE
            _cLOJA    := SD1->D1_LOJA
            _dEMISSAO := SD1->D1_EMISSAO
            //_cNOMUSER := UsrFullName(SC7->C7_USER)
            //_cNOTA    := Substr(SCR->CR_NUM,1,Len(SD1->D1_DOC))
            aCols     := {}

            SA2->(dbSetorder(1))
            SA2->(dbSeek(xFilial("SA2")+_cFORNECE + _cLOJA))

            _cNOMFOR := SA2->A2_NOME
            _nTOTPED := 0

            _cChavSD1 := SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA

            While SC7->(!Eof()) .And. _cChavSD1 == SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA

                AADD(aCols,Array(Len(_aCampos)+1))

                aCols[Len(aCols),_NPITEM]    := SD1->D1_ITEM
                aCols[Len(aCols),_NPPRODUTO] := SD1->D1_COD
                aCols[Len(aCols),_NPDESCRI]  := SD1->D1_DESCRI
                aCols[Len(aCols),_NPUM]      := SD1->D1_UM
                aCols[Len(aCols),_NPQUANT]   := SD1->D1_QUANT
                aCols[Len(aCols),_NPVUNIT]   := SD1->D1_VUNIT
                aCols[Len(aCols),_NPTOTAL]   := SD1->D1_TOTAL
                aCols[Len(aCols),_NPTES]     := SD1->D1_TES
                aCols[Len(aCols),_NPDTDIGIT] := SD1->D1_DTDIGIT
                //aCols[Len(aCols),_NPOBS]     := SD1->C7_OBS

                _NTOTPED += SD1->D1_TOTAL

                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                SD1->(dbSkip())
            EndDo
        Endif

        _lEdit  := .F.

        cTitulo       := "NOTA FISCAL DE DEVOLUCAO"
        cAliasGetD    := "SD1"
        cLinOk        := "AllwaysTrue()"
        cTudOk        := "AllwaysTrue()"
        cFieldOk      := "AllwaysTrue()"

        _lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)

        If _cEmpresa == "50"
            _cFilNew := SCR->CR_FILIAL
        Else
            _cFilNew := "01"
        Endif

        If _lRetMod2 .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew,_cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif
    ElseIf SCR->CR_TIPO == "50" // TABELA DE PRECO CIMENTO
        Private _cGrAprov:= ""
        wOpcao      := 	"V"
        Do Case
        Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
        EndCase

        RegToMemory("SZH",(cOpcao=="INCLUIR"))
        //RegToMemory("SZ8",IIF(nOpc==3,.T.,.F.), .F., .T.)

        nUsado  := 0
        aHeader := {}

        If Empty(SCR->CR_YOBRA)
            If nOpcx == 2  // CONSULTA
                _aCampos := {"ZI_PRODUTO","ZI_DESC","ZI_PRECOF","ZA4_VLMCIF","ZI_PRECO","ZA4_VLMFOB","ZA4_VLMCID","ZI_PRECOD","ZI_PGER","ZA4_VLMGER"} //Juailson Semar incluir o campo Cif Descarga em 06/02/15
            Else           // LIBERA
                _aCampos := {"ZI_PRODUTO","ZI_DESC","ZI_PRECOF","ZI_PRECO","ZI_PRECOD","ZI_PGER"} //Juailson Semar incluir o campo Cif Descarga em 06/02/15
            Endif
        Else
            If nOpcx == 2  // CONSULTA
                _aCampos := {"ZA2_PRODUT","ZA2_DESPRO","ZA2_OBRA","ZA2_PRC01F","ZA4_VLMCIF","ZA2_PRC01","ZA2_PRC01D","ZA4_VLMFOB","ZA2_PRCGER","ZA4_VLMGER"} //Juailson Semar - Incluir campo Preco Cif Descarga OBRA - 11/05/15
            Else           // LIBERA
                _aCampos := {"ZA2_PRODUT","ZA2_DESPRO","ZA2_OBRA","ZA2_PRC01F","ZA2_PRC01","ZA2_PRC01D","ZA2_PRCGER"} //Juailson Semar - Incluir campo Preco Cif Descarga OBRA - 11/05/15
            Endif
        Endif

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
                    nUsado := nUsado + 1
                    aadd(aHeader,{ trim(SX3->X3_TITULO),SX3->X3_CAMPO   , ;
                        SX3->X3_PICTURE     ,SX3->X3_TAMANHO , ;
                        SX3->X3_DECIMAL     ,"AllwaysTrue()" , ;
                        SX3->X3_USADO       ,SX3->X3_TIPO    , ;
                        SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )
                Endif
            Endif
        Next AX

        If Empty(SCR->CR_YOBRA)
            Private _nPProd   := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRODUTO" } )
            Private _nPDesc   := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_DESC"    } )
            Private _nPVlCif  := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRECO"   } )
            Private _nPVlCiD  := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRECOD"   } )    //Juailson - Semar - Inclusao preco Cif Descarga - 06/02/15
            Private _nPVlFob  := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRECOF"  } )
            Private _nPVlGer  := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PGER"    } )
        Else
            Private _nPProd   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRODUT" } )
            Private _nPDesc   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_DESPRO" } )
            Private _nPOBRA   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_OBRA"   } )
            Private _nPVlCif  := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRC01"  } )
            Private _nPVlCiD  := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRC01D"  } ) //Juailson Semar - Incluir campo Preco Cif Descarga OBRA - 11/05/15
            Private _nPVlFob  := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRC01F" } )
            Private _nPVlGer  := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRCGER" } )
        Endif

        If nOpcx == 2
            Private _nPRefCif := aScan( aHeader, { |x| Alltrim(x[2])=="ZA4_VLMCIF"   } )
            Private _nPRefFob := aScan( aHeader, { |x| Alltrim(x[2])=="ZA4_VLMFOB"   } )
            Private _nPRefGer := aScan( aHeader, { |x| Alltrim(x[2])=="ZA4_VLMGER"   } )
        Endif

        aCols:={}

        SA1->(dbSetOrder(1))
        SA1->(dbSeek(xFilial("SA1")+SCR->CR_YCLIENT + SCR->CR_YLOJA))

        SZH->(dbSetorder(1))
        SZH->(dbSeek(SCR->CR_FILIAL+SCR->CR_YCLIENT + SCR->CR_YLOJA))

        If Empty(SCR->CR_YOBRA)
            SZI->(dbSetOrder(1))
            If SZI->(dbSeek(SCR->CR_FILIAL+SCR->CR_YCLIENT + SCR->CR_YLOJA+ SCR->CR_YPRODUT+ Space(01)))
                _cChavSZI := SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_PRODUTO + Space(01)

                While SZI->(!Eof()) .And. _cChavSZI == SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_PRODUTO + Space(01)

                    SB1->(dbSetOrder(1))
                    SB1->(dbSeek(xFilial("SB1")+SZI->ZI_PRODUTO))

                    If !Empty(SZI->ZI_LIBER)
                        SZI->(dbSkip())
                        Loop
                    Endif

                    aadd(aCols,array(nUsado+1))

                    ACOLS[Len(Acols),_NPPROD] := SZI->ZI_PRODUTO
                    ACOLS[Len(Acols),_NPDESC] := SZI->ZI_DESC
                    ACOLS[Len(Acols),_NPVLCIF]:= SZI->ZI_PRECO
                    ACOLS[Len(Acols),_NPVLCID]:= SZI->ZI_PRECOD // Juailson - Semar - Inclusao do campo Cif Descarga - 06/02/15
                    ACOLS[Len(Acols),_NPVLFOB]:= SZI->ZI_PRECOF
                    ACOLS[Len(Acols),_NPVLGER]:= SZI->ZI_PGER

                    If nOpcx == 2
                        _lEncont := .F.
                        ZA4->(dbSetOrder(2))

                        If _cEmpresa == "50"
                            _cFilNew := SCR->CR_FILIAL
                        Else
                            _cFilNew := xFilial("ZA4")
                        Endif

                        If ZA4->(!dbSeek( _cFilNew + SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA + SA1->A1_MUN))
                            If ZA4->(!dbSeek(_cFilNew + SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA ))
                                If ZA4->(dbSeek(_cFilNew + SA1->A1_EST  + SB1->B1_COD ))
                                    _lEncont :=.T.
                                Endif
                            Else
                                _lEncont :=.T.
                            Endif
                        Else
                            _lEncont :=.T.
                        Endif

                        If _lEncont
                            ACOLS[Len(Acols),_NPREFCIF]:= ZA4->ZA4_VLMCIF
                            ACOLS[Len(Acols),_NPREFFOB]:= ZA4->ZA4_VLMFOB
                            ACOLS[Len(Acols),_NPREFGER]:= ZA4->ZA4_VLMGER
                        Else
                            ACOLS[Len(Acols),_NPREFCIF]:= 0
                            ACOLS[Len(Acols),_NPREFFOB]:= 0
                            ACOLS[Len(Acols),_NPREFGER]:= 0
                        Endif
                    Endif

                    aCols[len(aCols),nUsado+1] := .F.
                    SZI->(dbSkip())
                EndDo
            Endif
        Else
            //If _cEmpresa == "50"
            _cFilNew := SCR->CR_FILIAL
            //Else
            //	_cFilNew := xFilial("ZA2")
            //Endif

            ZA2->(dbSetOrder(2))
            If ZA2->(dbSeek(_cFilNew + SCR->CR_YCLIENT + SCR->CR_YLOJA+ SCR->CR_YPRODUT+ SCR->CR_YOBRA+Space(01)))
                _cChavZA2 := ZA2->ZA2_CLIENT + ZA2->ZA2_LOJA + ZA2->ZA2_PRODUT + ZA2->ZA2_OBRA + Space(01)

                While ZA2->(!Eof()) .And. _cChavZA2 == ZA2->ZA2_CLIENT + ZA2->ZA2_LOJA + ZA2->ZA2_PRODUT + ZA2->ZA2_OBRA + Space(01)

                    SB1->(dbSetOrder(1))
                    SB1->(dbSeek(xFilial("SB1")+ZA2->ZA2_PRODUT))

                    If !Empty(ZA2->ZA2_LIBER)
                        ZA2->(dbSkip())
                        Loop
                    Endif

                    aadd(aCols,array(nUsado+1))

                    ACOLS[Len(Acols),_NPPROD] := ZA2->ZA2_PRODUT
                    ACOLS[Len(Acols),_NPDESC] := ZA2->ZA2_DESPRO
                    ACOLS[Len(Acols),_NPOBRA] := ZA2->ZA2_OBRA
                    ACOLS[Len(Acols),_NPVLCIF]:= ZA2->ZA2_PRC01
                    ACOLS[Len(Acols),_NPVLCID]:= ZA2->ZA2_PRC01D //Juailson Semar - Incluir campo Preco Cif Descarga OBRA - 11/05/15
                    ACOLS[Len(Acols),_NPVLFOB]:= ZA2->ZA2_PRC01F
                    ACOLS[Len(Acols),_NPVLGER]:= ZA2->ZA2_PRCGER

                    If nOpcx == 2
                        _lEncont := .F.

                        //If _cEmpresa == "50"
                        _cFilNew := SCR->CR_FILIAL
                        //Else
                        //	_cFilNew := xFilial("ZA4")
                        //Endif

                        ZA4->(dbSetOrder(2))
                        If ZA4->(!dbSeek(_cFilNew + ZA2->ZA2_ESTENT + SB1->B1_COD + SA1->A1_ATIVIDA + ZA2->ZA2_MUNENT))
                            If ZA4->(!dbSeek(_cFilNew + ZA2->ZA2_ESTENT + SB1->B1_COD + SA1->A1_ATIVIDA ))
                                If ZA4->(dbSeek(_cFilNew + ZA2->ZA2_ESTENT  + SB1->B1_COD ))
                                    _lEncont :=.T.
                                Endif
                            Else
                                _lEncont :=.T.
                            Endif
                        Else
                            _lEncont :=.T.
                        Endif

                        If _lEncont
                            ACOLS[Len(Acols),_NPREFCIF]:= ZA4->ZA4_VLMCIF
                            ACOLS[Len(Acols),_NPREFFOB]:= ZA4->ZA4_VLMFOB
                            ACOLS[Len(Acols),_NPREFGER]:= ZA4->ZA4_VLMGER
                        Else
                            ACOLS[Len(Acols),_NPREFCIF]:= 0
                            ACOLS[Len(Acols),_NPREFFOB]:= 0
                            ACOLS[Len(Acols),_NPREFGER]:= 0
                        Endif
                    Endif

                    aCols[len(aCols),nUsado+1] := .F.
                    ZA2->(dbSkip())
                EndDo
            Endif
        Endif
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Inicializa variaveis                                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cTitulo        := "Cadastro da Tabela de Precos"
        cAliasEnchoice := "SZH"
        cAliasGetD     := "SZI"
        cLinOk         := "AllwaysTrue()"
        cTudOk         := "AllwaysTrue()"
        cFieldOk       := "AllwaysTrue()"
        aCpoEnchoice   := {"ZH_CLIENTE","ZH_LOJA","ZH_NOME"}

        _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRet .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew,_cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif
    ElseIf SCR->CR_TIPO == "03" // TABELA DE PRECO FRETE
        Private _cGrAprov:= ""
        Private   Acols	 := {}
        Private _nOpcX   := 2
        Private VISUAL   := (_nOpcX == 2)
        Private aHeader  := {}
        Private _nOpcao  := _nOpcX

        _nOpcE := _nOpcX
        _nOpcG := _nOpcX

        If nOpcx == 2  // CONSULTA
            _aCampos := {"ZA5_MUN","ZG_FORN","ZG_LOJA","ZA5_DIST","ZG_VALOR","ZA5_VLMAXG","ZG_FRETE","ZA5_VLMAXE","ZG_FAGRTRA","ZA5_VLMAXA","ZG_FRETED","ZG_FAGRTRD"}
        Else           // LIBERA
            _aCampos := {"ZA5_MUN","ZG_FORN","ZG_LOJA","ZA5_DIST","ZG_VALOR","ZG_FRETE","ZG_FAGRTRA","ZG_FRETED", "ZG_FAGRTRD"}
        Endif

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                    x3_tamanho, x3_decimal,"AllwaysTrue()",;
                    x3_usado, x3_tipo, x3_arquivo, x3_context } )
            Endif
        Next Ax

        Private _NPITEM   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_ITEM"  } )
        Private _NPEST    := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_ESTADO"} )
        Private _NPMUN    := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_MUN"   } )
        Private _NPDIST   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_DIST"  } )
        Private _NPVALOR  := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_VALOR"  } )
        Private _NPFORN   := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FORN"   } )
        Private _NPLOJA   := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_LOJA"   } )
        Private _NPFRETE  := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FRETE"  } )
        Private _NPFAGRTRA:= aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FAGRTRA"} )
        //Frete Descarga -Juailson-Semar 13/02/15
        Private _NPFRETED := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FRETED"  } )
        Private _NPFAGRTRD:= aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FAGRTRD"} )
        //
        Private _NPVLMAXG := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_VLMAXG"} )
        Private _NPVLMAXE := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_VLMAXE"} )
        Private _NPVLMAXA := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_VLMAXA"} )

        aCols:={}
        _cEstado  := SCR->CR_YESTADO
        _cMun     := SCR->CR_YMUN

        SZ4->(dbSetOrder(1))
        SZ4->(dbSeek(SCR->CR_FILIAL + SCR->CR_YESTADO  + SCR->CR_YMUN))
        _cDist    := Alltrim(Str(SZ4->Z4_DIST))

        SZG->(dbSetOrder(1))
        If SZG->(dbSeek(SCR->CR_FILIAL + SCR->CR_YESTADO  + SCR->CR_YMUN + SCR->CR_YFORNEC  + SCR->CR_YLOJFOR +Space(01)))

            _cChavSZG := SZG->ZG_EST   + SZG->ZG_MUN  + SZG->ZG_FORN + SZG->ZG_LOJA + Space(01)

            While SZG->(!Eof()) .And. _cChavSZG == SZG->ZG_EST   + SZG->ZG_MUN  + SZG->ZG_FORN + SZG->ZG_LOJA + Space(01)

                If !Empty(SZG->ZG_LIBER)
                    SZG->(dbSkip())
                    Loop
                Endif

                AADD(aCols,Array(Len(_aCampos)+1))

                ACOLS[Len(Acols),_NPDIST]   := SZG->ZG_DIST
                ACOLS[Len(Acols),_NPMUN]    := SZG->ZG_MUN
                ACOLS[Len(Acols),_NPFORN]   := SZG->ZG_FORN
                ACOLS[Len(Acols),_NPLOJA]   := SZG->ZG_LOJA
                ACOLS[Len(Acols),_NPVALOR]  := SZG->ZG_VALOR
                ACOLS[Len(Acols),_NPFRETE]  := SZG->ZG_FRETE
                ACOLS[Len(Acols),_NPFAGRTRA]:= SZG->ZG_FAGRTRA
                //Frete Descarga
                ACOLS[Len(Acols),_NPFRETED]  := SZG->ZG_FRETED
                ACOLS[Len(Acols),_NPFAGRTRD]:= SZG->ZG_FAGRTRD


                If nOpcx == 2
                    //If _cEmpresa == "50"
                    _cFilNew := SCR->CR_FILIAL
                    //Else
                    //	_cFilNew := xFilial("ZA2")
                    //Endif

                    ZA5->(dbSetOrder(1))
                    If ZA5->(!dbSeek(_cFilNew + SZG->ZG_EST  + SZG->ZG_MUN))
                        If ZA5->(dbSeek(_cFilNew + SZG->ZG_EST  + Space(35)))
                            ZA5->(dbSeek(_cFilNew + SZG->ZG_EST  + Space(35) + SZG->ZG_DIST,.T.))
                            If ZA5->ZA5_ESTADO == SZG->ZG_EST
                                ACOLS[Len(Acols),_NPVLMAXG]:= ZA5->ZA5_VLMAXG
                                ACOLS[Len(Acols),_NPVLMAXE]:= ZA5->ZA5_VLMAXE
                                ACOLS[Len(Acols),_NPVLMAXA]:= ZA5->ZA5_VLMAXA
                            Endif
                        Endif
                    Endif
                Endif

                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                SZG->(dbSkip())
            EndDo
        Endif

        _lEdit        := .F.
        cTitulo       := "Cadastro da Tabela de Precos"
        cAliasGetD    := "SZG"
        cLinOk        := "AllwaysTrue()"
        cTudOk        := "AllwaysTrue()"
        cFieldOk      := "AllwaysTrue()"

        _lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRetMod2 .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew,_cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif

    ElseIf SCR->CR_TIPO == "04" // TABELA DE PRECO DE COMPRAS
        Private _cGrAprov:= ""
        wOpcao      := 	"V"
        Do Case
        Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
        EndCase

        RegToMemory("AIA",(cOpcao=="INCLUIR"))

        nUsado  := 0
        aHeader := {}

        _aCampos := {"AIB_ITEM","AIB_YLIBER","AIB_YDTBLQ","AIB_CODPRO","AIB_YDESC","AIB_PRCCOM","AIB_QTDLOT","AIB_MOEDA","AIB_DATVIG","AIB_FRETE","AIB_YLIB01","AIB_YLIB02"}

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
                    nUsado := nUsado + 1
                    aadd(aHeader,{ trim(SX3->X3_TITULO),SX3->X3_CAMPO   , ;
                        SX3->X3_PICTURE     ,SX3->X3_TAMANHO , ;
                        SX3->X3_DECIMAL     ,"AllwaysTrue()" , ;
                        SX3->X3_USADO       ,SX3->X3_TIPO    , ;
                        SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )
                Endif
            Endif
        Next AX

        Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_ITEM"   } )
        Private _nPSTATUS := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YLIBER" } )
        Private _nPDTBLQ  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YDTBLQ" } )
        Private _nPCODPRO := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_CODPRO" } )
        Private _nPDESC   := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YDESC"  } )
        Private _nPPRCCOM := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_PRCCOM" } )
        Private _nPQTDLOT := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_QTDLOT" } )
        Private _nPMOEDA  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_MOEDA"  } )
        Private _nPDATVIG := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_DATVIG" } )
        Private _nPFRETE  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_FRETE"  } )
        Private _nPLib01  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YLIB01" } )
        Private _nPLIb02  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YLIB02" } )

        aCols:={}

        AIA->(dbSetOrder(1))
        AIA->(dbSeek(SCR->CR_FILIAL + SCR->CR_YFORNEC + SCR->CR_YLOJFOR + SCR->CR_YCODTAB))

        _cFornece := AIA->AIA_CODFOR
        _cLoja    := AIA->AIA_LOJFOR
        _cTabPrc  := AIA->AIA_CODTAB
        _cDesPrc  := AIA->AIA_DESCRI
        _dVigDe   := AIA->AIA_DATDE
        _dVigAte  := AIA->AIA_DATATE

        aCols:= {}

        AIB->(dbOrderNickName("INDAIB3"))
        If AIB->(dbSeek(SCR->CR_FILIAL + _cFornece + _cLoja + _cTabPrc + Space(01)))

            _cChavAIB := AIB->AIB_CODFOR + AIB->AIB_LOJFOR + AIB->AIB_CODTAB + AIB->AIB_YLIBER + AIB->AIB_CODPRO

            While AIB->(!Eof()) .And. _cChavAIB == AIB->AIB_CODFOR + AIB->AIB_LOJFOR + AIB->AIB_CODTAB + AIB->AIB_YLIBER + AIB->AIB_CODPRO

                AADD(aCols,Array(Len(_aCampos)+1))

                aCols[Len(aCols),_NPITEM]    := AIB->AIB_ITEM
                aCols[Len(aCols),_NPSTATUS]  := AIB->AIB_YLIBER
                aCols[Len(aCols),_NPDTBLQ]   := AIB->AIB_YDTBLQ
                aCols[Len(aCols),_NPCODPRO]  := AIB->AIB_CODPRO
                aCols[Len(aCols),_NPDESC]    := AIB->AIB_YDESC
                aCols[Len(aCols),_NPPRCCOM]  := AIB->AIB_PRCCOM
                aCols[Len(aCols),_NPQTDLOT]  := AIB->AIB_QTDLOT
                //aCols[Len(aCols),_NPMOEDA]   := AIB->AIB_MOEDA
                aCols[Len(aCols),_NPDATVIG]  := AIB->AIB_DATVIG
                aCols[Len(aCols),_NPFRETE]   := AIB->AIB_FRETE
                //aCols[Len(aCols),_NPMOEDA]   := AIB->AIB_MOEDA
                aCols[Len(aCols),_NPLIB01]   := AIB->AIB_YLIB01
                aCols[Len(aCols),_NPLIB02]   := AIB->AIB_YLIB02
                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                AIB->(dbSkip())
            EndDo
        Endif

        _lEdit  := .F.

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Inicializa variaveis                                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cTitulo        := "Tabela de Preco de Compras"
        cAliasEnchoice := "AIA"
        cAliasGetD     := "AIB"
        cLinOk         := "AllwaysTrue()"
        cTudOk         := "AllwaysTrue()"
        cFieldOk       := "AllwaysTrue()"
        aCpoEnchoice   := {"AIA_CODFOR","AIA_LOJFOR","AIA_CODTAB","AIA_DESCRI"}

        _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRet .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew,_cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif
    ElseIf SCR->CR_TIPO == "05" // LIMITE DE CREDITO

        Private   Acols	:={}
        Private _nOpcX := 2

        Private VISUAL := (_nOpcX == 2)

        Private aHeader := {}
        Private _nOpcao := _nOpcX

        _nOpcE := _nOpcX
        _nOpcG := _nOpcX

        _aCampos := {"ZA6_ITEM","ZA6_DTBLOQ","ZA6_LIBER","ZA6_VALOR","ZA6_PRAZO","ZA6_DTSCI","ZA6_DTSINT","ZA6_RISCO","ZA6_TIPO","ZA6_TES","ZA6_TESF","ZA6_FICMS","ZA6_INFORM","ZA6_USER","ZA6_USRLIB","ZA6_DTVIG","ZA6_SDOLIM","ZA6_SDOTIT"}	 // Marcus Vinicius - 29/04/2016 - Removido os campos ZA6_CHEIA e ZA6_DIFALI

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                    x3_tamanho, x3_decimal,x3_valid,;
                    x3_usado, x3_tipo, x3_arquivo, x3_context } )
            Endif
        Next Ax

        Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_ITEM"   } )
        Private _nPSTATUS := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_LIBER"  } )
        Private _nPDTBLQ  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTBLOQ" } )
        Private _nPDTVIG  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTVIG"  } )
        Private _nPVALOR  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_VALOR"  } )
        Private _nPPRAZO  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_PRAZO"  } )
        Private _nPDATA   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DATA"   } )
        Private _nPDTSCI  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTSCI"  } )
        Private _nPDTSIN  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTSINT" } )
        Private _nPDTVIG  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTVIG"  } )
        Private _nPRISCO  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_RISCO"  } )
        Private _nPTIPO   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_TIPO"   } )
        Private _nPTES    := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_TES"    } )
        Private _nPTESF   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_TESF"   } )
        Private _nPFICMS  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_FICMS"  } )
        Private _nPINFORM := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_INFORM" } )
        Private _nPUSER   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_USER"   } )
        Private _nPUSRLIB := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_USRLIB" } )
        Private _nPSdoLim := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_SDOLIM" } )
        Private _nPSdoTit := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_SDOTIT" } )

        _cCliente := SCR->CR_YCLIENT
        _cLoja    := SCR->CR_YLOJA
        aCols     := {}

        SA1->(dbSetorder(1))
        SA1->(dbSeek(xFilial("SA1")+_cCliente + _cLoja))

        _cNomCli := SA1->A1_NOME

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := xFilial("ZA6")
        //Endif

        ZA6->(dbSetOrder(1))
        If ZA6->(dbSeek(_cFilNew  + _cCliente + _cLoja + Space(01)))

            _nSdoLim  := ZA6->ZA6_SDOLIM
            _nSdoTit  := ZA6->ZA6_SDOTIT

            _cChavZA6 := ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + ZA6->ZA6_LIBER

            While ZA6->(!Eof()) .And. _cChavZA6 == ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + ZA6->ZA6_LIBER

                AADD(aCols,Array(Len(_aCampos)+1))

                aCols[Len(aCols),_NPITEM]    := ZA6->ZA6_ITEM
                aCols[Len(aCols),_NPSTATUS]  := ZA6->ZA6_LIBER
                aCols[Len(aCols),_NPDTBLQ]   := ZA6->ZA6_DTBLOQ
                aCols[Len(aCols),_NPVALOR]   := ZA6->ZA6_VALOR
                aCols[Len(aCols),_NPPRAZO]   := ZA6->ZA6_PRAZO
                aCols[Len(aCols),_NPDTVIG]   := ZA6->ZA6_DTVIG
                aCols[Len(aCols),_NPTIPO]    := ZA6->ZA6_TIPO
                aCols[Len(aCols),_NPRISCO]   := ZA6->ZA6_RISCO
                aCols[Len(aCols),_NPFICMS]   := ZA6->ZA6_FICMS
                aCols[Len(aCols),_NPDTSCI]   := ZA6->ZA6_DTSCI
                aCols[Len(aCols),_NPDTSIN]   := ZA6->ZA6_DTSINT
                aCols[Len(aCols),_NPTES]     := ZA6->ZA6_TES
                aCols[Len(aCols),_NPTESF]    := ZA6->ZA6_TESF
                aCols[Len(aCols),_NPINFORM]  := ZA6->ZA6_INFORM
                aCols[Len(aCols),_NPDTVIG]   := ZA6->ZA6_DTVIG
                aCols[Len(aCols),_NPUSER]    := ZA6->ZA6_USER
                aCols[Len(aCols),_NPUSRLIB]  := ZA6->ZA6_USRLIB

                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                ZA6->(dbSkip())
            EndDo
        Endif

        _lEdit  := .F.

        cTitulo       := "LIMITE DE CREDITO"
        cAliasGetD    := "ZA6"
        cLinOk        := "AllwaysTrue()"
        cTudOk        := "AllwaysTrue()"//MZ2002()
        cFieldOk      := "AllwaysTrue()"

        _lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRetMod2 .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew, _cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif
    ElseIf SCR->CR_TIPO == "06" // BORDERO DE PAGAMENTO

        Private   Acols	:={}
        Private _nOpcX := 2

        Private VISUAL := (_nOpcX == 2)

        Private aHeader := {}
        Private _nOpcao := _nOpcX

        _nOpcE := _nOpcX
        _nOpcG := _nOpcX

        _aCampos := {"EA_PREFIXO","EA_NUM","EA_PARCELA","EA_TIPO","EA_FORNECE","EA_LOJA","E2_VENCREA","A2_NOME","E2_VALOR","E2_HIST"}

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                    x3_tamanho, x3_decimal,x3_valid,;
                    x3_usado, x3_tipo, x3_arquivo, x3_context } )
            Endif
        Next Ax

        Private _nPPREFIXO := aScan( aHeader, { |x| Alltrim(x[2])== "EA_PREFIXO" } )
        Private _nPNUM     := aScan( aHeader, { |x| Alltrim(x[2])== "EA_NUM"     } )
        Private _nPPARCELA := aScan( aHeader, { |x| Alltrim(x[2])== "EA_PARCELA" } )
        Private _nPTIPO    := aScan( aHeader, { |x| Alltrim(x[2])== "EA_TIPO"    } )
        Private _nPFORNECE := aScan( aHeader, { |x| Alltrim(x[2])== "EA_FORNECE" } )
        Private _nPLOJA    := aScan( aHeader, { |x| Alltrim(x[2])== "EA_LOJA"    } )
        Private _nPVENCREA := aScan( aHeader, { |x| Alltrim(x[2])== "E2_VENCREA" } )
        Private _nPNOME    := aScan( aHeader, { |x| Alltrim(x[2])== "A2_NOME"    } )
        Private _nPVALOR   := aScan( aHeader, { |x| Alltrim(x[2])== "E2_VALOR"   } )
        Private _nPHist    := aScan( aHeader, { |x| Alltrim(x[2])== "E2_HIST"    } )

        aCols     := {}
        _cBordero := Substr(SCR->CR_NUM,1,TAMSX3("EA_NUMBOR")[1])

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //	Else
        //	_cFilNew := xFilial("SEA")
        //Endif

        SEA->(dbSetOrder(1))
        If SEA->(dbSeek(_cFilNew + _cBordero))

            _cChavSEA := SEA->EA_NUMBOR

            While SEA->(!Eof()) .And. _cChavSEA == SEA->EA_NUMBOR

                AADD(aCols,Array(Len(_aCampos)+1))

                SA2->(dbSetorder(1))
                SA2->(dbSeek(xFilial("SA2")+ SEA->EA_FORNECE + SEA->EA_LOJA))

                SE2->(dbSetOrder(1))
                SE2->(dbSeek(_cFilNew + SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA +SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA))

                aCols[Len(aCols),_NPPREFIXO] := SEA->EA_PREFIXO
                aCols[Len(aCols),_NPNUM]     := SEA->EA_NUM
                aCols[Len(aCols),_NPPARCELA] := SEA->EA_PARCELA
                aCols[Len(aCols),_NPTIPO]    := SEA->EA_TIPO
                aCols[Len(aCols),_NPFORNECE] := SEA->EA_FORNECE
                aCols[Len(aCols),_NPLOJA]    := SEA->EA_LOJA
                aCols[Len(aCols),_NPVENCREA] := SE2->E2_VENCREA
                aCols[Len(aCols),_NPNOME]    := SA2->A2_NOME
                aCols[Len(aCols),_NPVALOR]   := SE2->E2_SALDO
                aCols[Len(aCols),_NPHIST]    := SE2->E2_HIST
                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                SEA->(dbSkip())
            EndDo
        Endif

        _lEdit  := .F.

        cTitulo       := "BORDERO DE PAGAMENTO"
        cAliasGetD    := "SEA"
        cLinOk        := "AllwaysTrue()"
        cTudOk        := "AllwaysTrue()"//MZ2002()
        cFieldOk      := "AllwaysTrue()"

        _lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRetMod2 .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew, _cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif

    ElseIf SCR->CR_TIPO == "07" // PEDIDO DE VENDA

        Private   Acols	:={}
        Private _nOpcX := 2

        Private VISUAL := (_nOpcX == 2)

        Private aHeader := {}
        Private _nOpcao := _nOpcX

        _nOpcE := _nOpcX
        _nOpcG := _nOpcX

        _aCampos := {"Z1_PRODUTO","B1_DESC","Z1_QUANT","Z1_PCOREF","Z1_FRETE","Z1_VLLISTA","Z1_TES","F4_TEXTO"}

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                If Alltrim(SX3->X3_CAMPO) == "Z1_VLLISTA"
                    AADD(aHeader,{ TRIM("Valor Total"), x3_campo, x3_picture,;
                        x3_tamanho, x3_decimal,x3_valid,;
                        x3_usado, x3_tipo, x3_arquivo, x3_context } )
                ElseIf Alltrim(SX3->X3_CAMPO) == "B1_DESC"
                    AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                        30, x3_decimal,x3_valid,;
                        x3_usado, x3_tipo, x3_arquivo, x3_context } )
                ElseIf Alltrim(SX3->X3_CAMPO) == "Z1_FRETE"
                    AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                        05, x3_decimal,x3_valid,;
                        x3_usado, x3_tipo, x3_arquivo, x3_context } )
                Else
                    AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                        x3_tamanho, x3_decimal,x3_valid,;
                        x3_usado, x3_tipo, x3_arquivo, x3_context } )
                Endif
            Endif
        Next Ax

        Private _nPPRODUTO := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_PRODUTO" } )
        Private _nPDESC    := aScan( aHeader, { |x| Alltrim(x[2])== "B1_DESC"    } )
        Private _nPQUANT   := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_QUANT"   } )
        Private _nPPCOREF  := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_PCOREF"  } )
        Private _nPTES     := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_TES"     } )
        Private _nPDESTES  := aScan( aHeader, { |x| Alltrim(x[2])== "F4_TEXTO"   } )
        Private _nPTOTAL   := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_VLLISTA" } )
        Private _nPTPFRET  := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_FRETE"   } )

        _cCliente := SCR->CR_YCLIENT
        _cLoja    := SCR->CR_YLOJA
        aCols     := {}
        _cPedido  := Substr(SCR->CR_NUM,1,TAMSX3("Z1_NUM")[1])

        SA1->(dbSetorder(1))
        SA1->(dbSeek(xFilial("SA1") + _cCliente + _cLoja))

        _cNomCli := SA1->A1_NOME
        _nLimite := 0
        _nSdoTit := 0

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := xFilial("ZA6")
        //Endif

        ZA6->(dbSetOrder(1))
        If ZA6->(dbSeek(_cFilNew + _cCliente + _cLoja + "L"))

            _nLimite  := ZA6->ZA6_VALOR
            _nSdoTit  := ZA6->ZA6_SDOTIT
            _nSdoLim  := ZA6->ZA6_SDOLIM
        Endif

        SZ1->(dbSetOrder(1))
        If SZ1->(dbSeek(SCR->CR_FILIAL + _cPedido))

            _cChavSZ1 := SZ1->Z1_NUM

            While SZ1->(!Eof()) .And. _cChavSZ1 == SZ1->Z1_NUM

                AADD(aCols,Array(Len(_aCampos)+1))

                SB1->(dbSetOrder(1))
                SB1->(dbSeek(xFilial("SB1")+ SZ1->Z1_PRODUTO))

                SF4->(dbSetOrder(1))
                SF4->(dbSeek(xFilial("SF4")+ SZ1->Z1_TES))

                aCols[Len(aCols),_NPPRODUTO] := SZ1->Z1_PRODUTO
                aCols[Len(aCols),_NPDESC]    := SB1->B1_DESC
                aCols[Len(aCols),_NPQUANT]   := SZ1->Z1_QUANT
                aCols[Len(aCols),_NPPCOREF]  := SZ1->Z1_PCOREF
                aCols[Len(aCols),_NPTPFRET]  := IIF (SZ1->Z1_FRETE = "C","C=CIF","F=FOB")
                aCols[Len(aCols),_NPTES]     := SZ1->Z1_TES
                aCols[Len(aCols),_NPDESTES]  := SF4->F4_TEXTO
                aCols[Len(aCols),_NPTOTAL]   := SZ1->Z1_QUANT * SZ1->Z1_PCOREF
                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                SZ1->(dbSkip())
            EndDo
        Endif

        _lEdit  := .F.

        cTitulo       := "PEDIDO DE VENDA"
        cAliasGetD    := "SZ1"
        cLinOk        := "AllwaysTrue()"
        cTudOk        := "AllwaysTrue()"//MZ2002()
        cFieldOk      := "AllwaysTrue()"

        _lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRetMod2 .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew , _cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()

        Endif
    ElseIf SCR->CR_TIPO == "08" // DESCONTO CONTAS A RECEBER

        Private   Acols	:={}
        Private	oDescric,oGetDados, oCodigo
        Private _lVlMan   := .F.
        _nOpcX := 2

        _nOpcE := _nOpcX
        _nOpcG := _nOpcX
        Private _nOpcao := _nOpcX

        Private VISUAL := (_nOpcX == 2)
        Private INCLUI := (_nOpcX == 3)
        Private ALTERA := (_nOpcX == 4)
        Private DELETA := (_nOpcX == 5)

        Private aHeader := {}

        _aCampos := {"ZAD_ITEM","ZAD_DESC","ZAD_HISTOR","ZAD_DTMOV","ZAD_LIBER"}

        For AX:= 1 TO Len(_aCampos)
            dbSelectArea("Sx3")
            dbSetOrder(2)
            If dbSeek(_aCampos[AX])
                AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                    x3_tamanho, x3_decimal,x3_valid,;
                    x3_usado, x3_tipo, x3_arquivo, x3_context } )
            Endif
        Next Ax

        Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_ITEM"   } )
        Private _nPDESC   := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_DESC"   } )
        Private _nPDTMOV  := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_DTMOV"  } )
        Private _nPHISTOR := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_HISTOR" } )
        Private _nPLIBER  := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_LIBER"  } )

        _cPrefixo := ZAD->ZAD_PREFIX
        _cNum     := ZAD->ZAD_NUM
        _cParcela := ZAD->ZAD_PARCEL
        _cTipo    := ZAD->ZAD_TIPO
        _cCliente := ZAD->ZAD_CLIENT
        _cLoja    := ZAD->ZAD_LOJA

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := xFilial("ZAD")
        //Endif

        ZAD->(dbSetOrder(1))
        If ZAD->(dbSeek(_cFilNew  + _cPrefixo + _cNum + _cParcela + _cTipo + _cCliente + _cLoja ))

            aCols     := {}

            _cChavZAD := ZAD->ZAD_PREFIX + ZAD->ZAD_NUM + ZAD->ZAD_PARCEL + ZAD->ZAD_TIPO + ZAD->ZAD_CLIENT + ZAD->ZAD_LOJA

            While ZAD->(!Eof()) .And. _cChavZAD == ZAD->ZAD_PREFIX + ZAD->ZAD_NUM + ZAD->ZAD_PARCEL + ZAD->ZAD_TIPO + ZAD->ZAD_CLIENT + ZAD->ZAD_LOJA

                AADD(aCols,Array(Len(_aCampos)+1))

                aCols[Len(aCols),_NPITEM]    := ZAD->ZAD_ITEM
                aCols[Len(aCols),_NPDESC]    := ZAD->ZAD_DESC
                aCols[Len(aCols),_NPDTMOV]   := ZAD->ZAD_DTMOV
                aCols[Len(aCols),_NPHISTOR]  := ZAD->ZAD_HISTOR
                aCols[Len(aCols),_NPLIBER]   := ZAD->ZAD_LIBER

                aCols[Len(aCols),Len(_aCampos)+1]:=.F.

                ZAD->(dbSkip())
            EndDo
        Endif

        cTitulo       := "DESCONTO FINANCEIRO"
        cAliasGetD    := "ZAD"
        cLinOk        := "AllwaysTrue()"
        cTudOk        := "AllwaysTrue()"
        cFieldOk      := "AllwaysTrue()"

        _lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)

        //If _cEmpresa == "50"
        _cFilNew := SCR->CR_FILIAL
        //Else
        //	_cFilNew := "01"
        //Endif

        If _lRetMod2 .And. nOpcx == 3
            If _lOutEmp                                  //  1             2               3          4          5        6       7
                StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmpresa     , _cFilNew     ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
            Else	       //   1        2       3       4    5
                U_BRI072(_cEmpresa, _cFilNew ,_cAprovador,_cMod,CA097USER )
            Endif

            aWBrowse2[_nCont][9] := dDataBase
            aWBrowse2[_nCont,2]  := .F.
            oWBrowse2:Refresh()
        Endif
    Endif

    cEmpAnt  := _cEmpOri
    cFilAnt  := _cFilOri

    RestArea(_aAliAIA)
    RestArea(_aAliAIB)
    RestArea(_aAliSC7)
    RestArea(_aAliSCR)
    RestArea(_aAliSE2)
    RestArea(_aAliSEA)
    RestArea(_aAliZAH)
/*
RestArea(_aAliSZ1)
RestArea(_aAliSZI)
RestArea(_aAliSZG)
RestArea(_aAliZA2)
RestArea(_aAliZA4)
RestArea(_aAliZA5)
RestArea(_aAliZA6)
*/
    If _lOutEmp

        cModo := "C"  /// sc7, SCR
        EmpOpenFile("SCR","SCR",1,.T.,_cEmpOri1,@cModo)

        If _cTipoZAH == "PC"
            EmpOpenFile("SC7","SC7",1,.T.,_cEmpOri1,@cModo)
        ElseIf _cTipoZAH == "50"
            cModo := "E"
            EmpOpenFile("SZI","SZI",1,.T.,_cEmpOri1,@cModo)
            cModo := "C"
            EmpOpenFile("ZA2","ZA2",1,.T.,_cEmpOri1,@cModo)
            EmpOpenFile("ZA4","ZA4",1,.T.,_cEmpOri1,@cModo)
        ElseIf _cTipoZAH == "03"
            cModo := "C"
            EmpOpenFile("ZA5","ZA5",1,.T.,_cEmpOri1,@cModo)
            cModo := "E"
            EmpOpenFile("SZG","SZG",1,.T.,_cEmpOri1,@cModo)
        ElseIf _cTipoZAH == "04"
            cModo := "E"
            EmpOpenFile("AIA","AIA",1,.T.,_cEmpOri1,@cModo)
            EmpOpenFile("AIB","AIB",1,.T.,_cEmpOri1,@cModo)
        ElseIf _cTipoZAH == "05"
            cModo := "C"
            EmpOpenFile("ZA6","ZA6",1,.T.,_cEmpOri1,@cModo)
        ElseIf _cTipoZAH == "06"
            EmpOpenFile("SEA","SEA",1,.T.,_cEmpOri1,@cModo)
            EmpOpenFile("SE2","SE2",1,.T.,_cEmpOri1,@cModo)
        ElseIf _cTipoZAH == "07"
            cModo := "E"
            EmpOpenFile("SZI","SZI",1,.T.,_cEmpOri1,@cModo)
            cModo := "C"
            EmpOpenFile("ZA6","ZA6",1,.T.,_cEmpOri1,@cModo)
        Endif
    Endif

    RestArea(_aAliSM0)
    RestArea(_aAliORI)


Return



Static Function MZ56_06(cTitulo,cAlias2   ,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk,_lOutEmp,_cMod,_nCont)


    Local _nOpca := 0,cSaveMenuh,oDlg,oEstado,oMun,oDist

    Private aSize	  := MsAdvSize()
    Private aObjects  := {}
    Private aPosObj   := {}
    Private aSizeAut  := MsAdvSize()
    Private aButtons  := {}

    AAdd( aObjects, { 0,    25, .T., .F. })
    AAdd( aObjects, { 100, 100, .T., .T. })
    AAdd( aObjects, { 0,    3, .T., .F. })

    aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
    aPosObj := MsObjSize( aInfo, aObjects,.T. )

    aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})

    Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
        bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
    Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

//DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
//                                                    linha inferior, coluna direita
    DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

    _nTop    := aPosObj[2,1]

    If SCR->CR_TIPO == "PC"
        @ 0.8,002 Say "Pedido: "
        @ 0.8,005 MSGET oPedido VAR _cPedido              When .F.     PICTURE "@!" SIZE 30,10

        @ 0.8,010 Say "Fornecedor: "
        @ 0.8,014 MSGET oFornece VAR _cFORNECE            When .F.     PICTURE "@!" SIZE 30,10

        @ 0.8,020 Say "Loja: "
        @ 0.8,023 MSGET oLoja    VAR _cLoja               When .F.     PICTURE "99" SIZE 20,10

        @ 0.8,027 Say "Nome Fornecedor: "
        @ 0.8,034 MSGET oNomFor  VAR _cNOMFOR             When .F.     SIZE 150,10

        @ 0.8,054 Say "Emissao: "
        @ 0.8,057 MSGET oEmissao VAR _dEmissao            When .F.     SIZE 30,10

        @ 2.0,002 Say "Nome do Usuario: "
        @ 2.0,010 MSGET oUsuario VAR Alltrim(_cNomUser)   When .F.     SIZE 70,10

        @ 2.0,020 Say "Mercadoria: "
        @ 2.0,025 MSGET oMercad  VAR _nMERCAD             When .F.     PICTURE "@E 999,999.99" SIZE 50,10

        @ 2.0,032 Say "Despesas/Frete: "
        @ 2.0,038 MSGET oDespesa VAR _nOUTROS             When .F.     PICTURE "@E 999,999.99" SIZE 50,10

        @ 2.0,045 Say "Total Pedido:"
        @ 2.0,050 MSGET oTotPed  VAR _nTOTPED             When .F.     PICTURE "@E 9,999,999.99" SIZE 50,10

        _nTop := aPosObj[2,1] + 7
    ElseIf SCR->CR_TIPO == "03" // TABELA DE FRETE
        @ 1.0,002 Say "Estado: "
        @ 1.0,005 MSGET oEstado  VAR _cEstado          When .F.     PICTURE "@!" SIZE 30,10

        @ 1.0,010 Say "Municipo: "
        @ 1.0,014 MSGET oMun     VAR _cMun             When .F.     PICTURE "@!" SIZE 50,10

        @ 1.0,025 Say "Distancia: "
        @ 1.0,030 MSGET oDist    VAR _cDist            When .F.     PICTURE "@!" SIZE 50,10

    ElseIf SCR->CR_TIPO == "05"
        @ 1.0,002 Say "Cliente: "
        @ 1.0,005 MSGET oCliente VAR _cCliente         When .F.     PICTURE "@!" SIZE 30,10

        @ 1.0,010 Say "Loja: "
        @ 1.0,014 MSGET oLoja    VAR _cLoja            When .F.     PICTURE "99" SIZE 30,10

        @ 1.0,020 Say "Nome Cliente: "
        @ 1.0,025 MSGET oNomCli  VAR _cNomCli          When .F.     SIZE 120,10

        @ 1.0,041 Say "Saldo Limite: "
        @ 1.0,045 MSGET oSdoLim  VAR _nSdoLim          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10

        @ 1.0,053 Say "Saldo Titulo: "
        @ 1.0,057 MSGET oSdoTit  VAR _nSdoTit          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
    ElseIf SCR->CR_TIPO == "06"
        @ 1.0,002 Say "Bordero: "
        @ 1.0,005 MSGET oBordero VAR _cBordero         When .F.     PICTURE "@!" SIZE 30,10
        @ 1.0,023 Say "Total do Bordero: "
        @ 1.0,030 MSGET oTotBor  VAR SCR->CR_TOTAL     When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
    ElseIf SCR->CR_TIPO == "07"
        @ 1.0,002 Say "Pedido: "
        @ 1.0,005 MSGET oPedido VAR _cPedido           When .F.     PICTURE "@!" SIZE 30,10

        @ 1.0,010 Say "Cliente: "
        @ 1.0,014 MSGET oCliente VAR _cCliente         When .F.     PICTURE "@!" SIZE 30,10

        @ 1.0,020 Say "Loja: "
        @ 1.0,023 MSGET oLoja    VAR _cLoja            When .F.     PICTURE "99" SIZE 30,10

        @ 1.0,027 Say "Nome Cliente: "
        @ 1.0,032 MSGET oNomCli  VAR _cNomCli          When .F.     SIZE 150,10

        @ 2.3,002 Say "Limite de Credito: "
        @ 2.3,010 MSGET oLimite  VAR _nLimite          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10

        @ 2.3,020 Say "Titulos Em Aberto: "
        @ 2.3,027 MSGET oTitFat  VAR _nSdoTit          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10

        @ 2.3,036 Say "Saldo do Limite: "
        @ 2.3,041 MSGET oSdoLim  VAR _nSdoLim          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10

        _nTop := aPosObj[2,1] + 7
    ElseIf SCR->CR_TIPO == "NF"
        @ 0.8,002 Say "N.Fiscal:
        @ 0.8,005 MSGET oPedido VAR _cNota             When .F.     PICTURE "@!" SIZE 30,10

        @ 0.8,010 Say "Fornecedor: "
        @ 0.8,014 MSGET oFornece VAR _cFORNECE         When .F.     PICTURE "@!" SIZE 30,10

        @ 0.8,020 Say "Loja: "
        @ 0.8,023 MSGET oLoja    VAR _cLoja            When .F.     PICTURE "99" SIZE 20,10

        @ 0.8,027 Say "Nome Fornecedor: "
        @ 0.8,034 MSGET oNomFor  VAR _cNOMFOR          When .F.     SIZE 150,10

        @ 0.8,054 Say "Emissao: "
        @ 0.8,057 MSGET oEmissao VAR _dEmissao         When .F.     SIZE 30,10

        @ 2.0,030 Say "TOTAL DA NOTA FISCAL --> "
        @ 2.0,038 MSGET oTotPed  VAR _nTOTPED          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10

        _nTop := aPosObj[2,1] + 7

    Else
        @ 1.0,001 Say "Prefixo: "
        @ 1.0,004 MSGET oPrefixo  VAR _cPrefixo   When .F.  PICTURE "@!"  SIZE 30,10

        @ 1.0,010 Say "Numero: "
        @ 1.0,013 MSGET oNumero   VAR _cNum       When .F.  PICTURE "@!"  SIZE 50,10

        @ 1.0,022 Say "Parcela: "
        @ 1.0,025 MSGET oParcela  VAR _cParcela   When .F.  PICTURE "@!"  SIZE 10,10

        @ 1.0,029 Say "Cliente: "
        @ 1.0,032 MSGET oCliente  VAR _cCliente   When .F.  PICTURE "@!"  SIZE 30,10

        @ 1.0,039 Say "Loja: "
        @ 1.0,041 MSGET oLoja     VAR _cLoja      When .F.  PICTURE "@!"  SIZE 10,10

    Endif

    _lRet := .F.

    nGetLin := aPosObj[3,1]
//  									43			3	        285       675
    oGetDados   := MsGetDados():New(_nTop,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_MZ61_05()","MZ61_04","+AIB_ITEM",.T.)

    ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

    _lRet := (_nOpca==1)

Return(_lRet)


Static Function ATUSX1()

    cPerg := "BRI071"

/*
//////////////////////////////////////
// MV_PAR01    Exibir Documentos    //
// MV_PAR02    Data A Partir De     //
//////////////////////////////////////
*/

//    	   Grupo/Ordem/Pergunta               /perg_spa/perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01          /defspa1/defeng1/Cnt01/Var02/Def02      /Defspa2/defeng2/Cnt02/Var03/Def03   /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
    U_CRIASX1(cPerg,"01","Exibir Documentos     ?",""       ,""      ,"mv_ch1","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR01","Nao Aprovados",""     ,""     ,""   ,""   ,"Bloqueado" ,""     ,""     ,""   ,""  ,""      ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
    U_CRIASX1(cPerg,"02","Data A Partir De      ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"C",""        ,"MV_PAR02",""             ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""      ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return

Static Function ATUSX1B()

    cPerg := "BRI071B"

/*
//////////////////////////////////////
// MV_PAR01    Exibir Documentos    //
// MV_PAR02    Data A Partir De     //
//////////////////////////////////////
*/

//    	   Grupo/Ordem/Pergunta                   /perg_spa/perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01/defspa1/defeng1/Cnt01/Var02/Def02      /Defspa2/defeng2/Cnt02/Var03/Def03   /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
    U_CRIASX1(cPerg,"01"   ,"Documento				    ?",""      ,""      ,"mv_ch1","C" ,50     ,0      ,0     ,"C",""        ,"MV_PAR01",""   ,""     ,""     ,""   ,""   ,"" ,""     ,""     ,""   ,""  ,""      ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return


Static Function VALIDEMP(cNome,cSenha)

    Local lRetSenha := .F.
    Local aUsuarios	:= {}
    Local lOkEmp 	:= .F.
    Local cTxtEmp	:= ""
    Local aEmpMaisF := {}
    Local nAchou := 0

    aUsuarios := AllUsers(.T.)

    For x:= 1 To Len(aUsuarios)
        If Lower(AllTrim(aUsuarios[x,01,02])) == Lower(AllTrim(cNome))
            PswOrder(2)
            PswSeek(aUsuarios[x,01,02],.T.)
            //If PswName(cSenha)
            nLinArray	:= x
            lRetSenha	:= .T.
            aEmpMaisF	:= aUsuarios[x,02,06]   // EMPRESAS QUE TEM ACESSO
            //EndIf
        EndIf
    Next x

    If aEmpMaisF[1] == "@@@@"
        aEmpMaisF := {}
        SM0->(DbGoTop())
        DbSelectArea("SM0")
        While !SM0->(Eof())
            nAchou := Ascan(aEmpMaisF,SM0->M0_CODIGO)
            If nAchou = 0
                Aadd(aEmpMaisF,Alltrim(SM0->M0_CODIGO))
            EndIf
            SM0->(DbSkip())
        End
        lConsolid := .T.
    EndIf

    If !lRetSenha
        AAdd(aEmpMaisF,"ERRO")
    EndIf

Return aEmpMaisF

User Function BRI71_B(_cEmp,_cFil,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)

    _cTpSCR  := _cTipoZAH
    _cNumSCR := _cNumZAH
    _cUserSCR:= _cUserZAH

    RpcSetType(3)
    RpcSetEnv(_cEmp, _cFil,'schedule','schedule','COM' ,,  {"SAL","SAK","SC7","SCR","SCS"})

//If _cEmp == "50"
    _cFilNew := _cFil
//Else
//   _cFilNew := xFilial("SCR")
//Endif

    SCR->(dbSetOrder(2))
    SCR->(dbSeek(_cFilNew + _cTpSCR + _cNumSCR + _cUserSCR))

    U_BRI072(_cEmp,_cFil,_cAprovador,_cMod,CA097USER)

    RpcClearEnv()

Return

User Function BRI71_E(_cEmp    ,_cFil,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_nCont,_cMod ,_lOutEmp,oDlg)

//If _cEmpresa == "50"
    _cFilNew := SCR->CR_FILIAL
//Else
//	_cFilNew := "01"
//Endif

    If _lOutEmp                                  //  1         2               3          4          5        6       7
        StartJob("U_BRI71_B", GetEnvServer(), .T., _cEmp     , _cFilNew       ,_cAprovador,_cTipoZAH,_cNumZAH,_cUserZAH,_cMod,CA097USER)
    Else       //   1        2       3       4    5
        U_BRI072(_cEmpresa, _cFilNew, _cAprovador, _cMod, CA097USER )
    Endif

    oDlg:End()

    aWBrowse2[_nCont][9] := dDataBase
    aWBrowse2[_nCont,2]  := .F.

    oWBrowse2:Refresh()

Return()


User Function BRI71A(l1Elem)

    Local cTitulo :=""
    Local MvParDef:=""
    Local oWnd

    Private aCat:={}

    l1Elem      := .f.
    oWnd        := GetWndDefault()
    cAlias      := Alias()

    _cCpos   	:= "M->AK_YTPLIB"
    _cVar2      := &(Alltrim(ReadVar()))

    IF _cVar2  != NIL
        If _cCpos == Alltrim(ReadVar())
            _cVarAtu := &(Alltrim(ReadVar()))
            MvPar    := _cVarAtu
            mvRet    := Alltrim(ReadVar())
        Else
            Return(.t.)
        Endif
    Else
        Return(.t.)
    EndIF

    _cVar1      := _cVarAtu

    lMultSelect := .T.
    lComboBox   := .F.
    cCampo      := ""
    lOrdena     := .T.
    lPesq       := .T.
    nTamElem    := 2

    dbSelectArea("SX5")
    If dbSeek(cFilial+"00ZK")
        cTitulo := Alltrim(Left(SX5->X5_Descri,20))
    Endif

    If dbSeek(xFilial()+"ZK")
        CursorWait()
        While !Eof() .And. SX5->X5_Tabela == "ZK"
            Aadd(aCat,Alltrim(SX5->X5_Descri))
            MvParDef+=Substr(SX5->X5_Chave,1,2)
            dbSkip()
        Enddo
        CursorArrow()
        If f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem,nTamElem,Len(aCat),lMultSelect,lComboBox,cCampo,lOrdena,lPesq)
            _cVar1 := MvPar
        Endif
    Endif

    &MvRet := _cVar1

    dbSelectArea(cAlias)

Return( .T. )