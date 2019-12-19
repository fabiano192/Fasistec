#include "rwmake.ch"
#INCLUDE "TOPCONN.ch"

User Function BRI110()

//Private _lEmpFil := cEmpAnt+cFilAnt $ "1307|5001|1306|5002"  
    Private _lEmpFil := cEmpAnt+cFilAnt $ "1307|5001|1306|5002|5006|5007"

    Private _nQry3   := 0

    cPerg   := "BRI110"
    aLinha  := {}
    aOrd    := {}
    cbcont  := 0
    cbtxt   := space(10)

    cabec1  := "Nota      Emissao  Hora  Placa    Cliente                               Toneladas       Litros   Qt.ABast    Vl unit  Total Abastec"
/*
Nota      Emissao  Hora  Placa    Cliente                               Toneladas       Litros   Qt.ABast    Vl unit  Total Abastec
999999999 99999999 99999 99999999 999999/99 - 99999999999999999999 99999999999999 999999999999 9999999999 9999999999 99999999999999
0         10       19    25       34                               67             82           95         106        117
*/

    cabec2  := ""
    cabec3  := ""
    li      := 99
    m_pag   := 1
    cString := "SF2"
    cDesc1  := OemToAnsi("Relatorio Abastecimento filial")
    cDesc2  := ''
    cDesc3  := OemToAnsi("Especifico"+trim(sm0->m0_nome)+".")
    tamanho := "M"
    limite  := 132
    aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
    nomeprog:= wnrel :="BRI110"
    nLastKey:= 0
    titulo  := "Abastecimento Filial"
    cCancel := "*** CANCELADO PELO OPERADOR ***"
    lAbortPrint := .F.

    validperg(cPerg)

    SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,tamanho)

    If nLastKey == 27
        Set Filter To
        Return
    Endif

    SetDefault(aReturn,cString)

    If nLastKey == 27
        Set Filter To
        Return
    Endif

    RptStatus({|lAbortPrint|_ImpRel()},titulo)

    sd2->(retindex())
    sf2->(retindex())



Static Function _ImpRel()

    pergunte(cPerg,.f.)

    _dDataIni:= mv_par01
    _dDataFim:= mv_par02
    _cMotoIni:= mv_par03
    _cMotoFim:= mv_par04
    _lQuebra := (mv_par05==1)

    Titulo:=alltrim(titulo)+" - Periodo de "+DTOC(_dDataIni)+" a "+DTOC(_dDataFim)

    _cPictVUnit:="@Er 99,999.99"
    _cPictVTot :="@Er 999,999.99"
    _cPictQuant:="@Er 9,999,999.99"

    sf4->(dbsetorder(1))

    _cFiltroSf2:= " f2_filial=='"+xfilial("SF2")+"'"
    _cFiltroSf2+= " .and. dtos(f2_emissao)>='"+dtos(_dDataIni)+"'.and.dtos(f2_emissao)<='"+dtos(_dDataFim)+"'"
    _cFiltroSf2+= " .and. F2_TRANSP >='"+_cMotoIni+"' .and. F2_TRANSP <= '"+_cMotoFim+"'"
    _cFiltroSf2+= " .and. f2_frete==0 .and. F2_PDLITQT <>0 "
    _cOrdemSf2 := " F2_FILIAL + F2_TRANSP + dtos(f2_EMISSAO)"

    SF2->(indregua(alias(),criatrab(,.f.),_cOrdemSf2,,_cFiltroSf2))

    Setregua(4000)
    SF2->(dbgotop())

    _nTotGQt := 0
    _nTotGLt := 0
    _nTotGAB := 0
    _nTotGVl := 0

    _nTotSVl := 0

    SD2->(dbsetorder(3))

    While SF2->(!eof())

        _cFilial   := sf2->f2_filial
        _cTransp   := sf2->f2_transp
        _cLitMot   := _cTransp+" - "+posicione("SA4",1,xfilial("SA4")+_cTransp,"A4_NOME")

        If _lquebra.and._nTotSVl>0
            roda(0,"",tamanho)
        Endif

        _nTotSQt := 0
        _nTotSLt := 0
        _nTotSAB := 0
        _nTotSVl := 0

        incregua()

        If _lQuebra
            li:=99
            m_pag:=1
        Endif

        If li>61
            Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        Else
            li++
        Endif

        @ Li,0 psay "Transportadora: "+_cLitMot

        Li+=2

        _aPlaca:= {}

        While SF2->(!Eof() .And. F2_filial + F2_TRANSP == _cFilial + _cTransp)

            If li>61
                Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
                LI := 8
                @ Li,0 psay "Transportadora: "+_cLitMot
                Li+=2
            Endif

            _nQtNota:=0

            sd2->(dbseek(xfilial()+sf2->(f2_doc+f2_serie),.f.))
            do while sd2->(!eof().and.d2_filial+d2_doc+d2_serie==xfilial()+sf2->(f2_doc+f2_serie))
                _nQtNota+=sd2->d2_quant
                sd2->(dbskip(1))
            enddo

            _nQtSdo   := _nQtLit := _nQtAbast := _nTotParc := 0

            _nValLT   := MV_PAR06

            If cEmpAnt+cFilAnt $ "1307/5001/1306/5002/5006/5007"
                //If cEmpAnt+cFilAnt $ "1307/5001"

            Else
                _nQtLit   := SF2->F2_PDLITQT
                _nQtAbast := 0
                _nTotParc := SF2->F2_PDLITTO
            Endif

            SA1->(dbSetOrder(1))
            SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA))

            @ Li,000  PSAY SF2->F2_DOC
            @ Li,010  PSAY SF2->F2_EMISSAO
            @ Li,019  PSAY SF2->F2_HORA
            @ Li,025  PSAY SF2->F2_PLACA
            @ Li,034  PSAY SF2->F2_CLIENTE +"/" + SF2->F2_LOJA+" - "+Left(SA1->A1_NREDUZ,20)
            @ Li,067  PSAY _nQtNota     PICTURE TM(_nQtNota ,14,2)
            @ Li,082  PSAY _nQtLit      PICTURE TM(_nQtLit  ,12,2)
            @ Li,095  PSAY _nQtAbast    PICTURE TM(_nQtAbast,10,2)
            @ Li,106  PSAY _nValLT      PICTURE TM(_nValLT  ,10,2)
            @ Li,117  PSAY _nTotParc    PICTURE TM(_nTotParc,14,2)

            Li++

            _nTotSQt += _nQtNota
            _nTotSLt += _nQtLit
            _nTotSAB += _nQtAbast
            _nTotSVl += _nTotParc

            _nTotGQt += _nQtNota
            _nTotGLt += _nQtLit
            _nTotGAB += _nQtAbast
            _nTotGVl += _nTotParc

            If aScan(_aPlaca,SF2->F2_PLACA) = 0
                AAdd(_aPlaca,SF2->F2_PLACA)
            Endif

            SF2->(dbskip(1))
        EndDo

        If _lEmpFil

            GeraQRY3(_aPlaca,_cTransp)

            If _nQry3 > 0

                QRY3->(dbgoTop())

                Li++

                While !QRY3->(EOF())

                    If Li > 60
                        Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
                    Endif

                    If QRY3->ORDEM = 'C'
                        //Li++
                        _cNF := "Saldo"
                    Else
                        //_cNF := ""
                        _cNf := QRY3->NUM
                    Endif

                    _nValAba := Round(QRY3->QTABAST * mv_par06,2)

                    @ Li,000 Psay _cNF
                    @ Li,010 Psay QRY3->DTABAST
                    @ Li,019 Psay Left(QRY3->HRABAST,5)
                    @ Li,025 Psay QRY3->PLACA
                    @ Li,095 Psay QRY3->QTABAST			PICTURE TM(QRY3->QTABAST ,10,2)
                    @ Li,106 Psay MV_PAR06				PICTURE TM(MV_PAR05,10,2)
                    @ Li,117 Psay _nValAba				PICTURE TM(_nValAba,14,2)

                    Li++

                    _nTotSAB += QRY3->QTABAST
                    _nTotSVl += _nValAba

                    _nTotGAB += QRY3->QTABAST
                    _nTotGVl += _nValAba

                    QRY3->(dbSkip())
                EndDo
            Endif
            QRY3->(dbCloseArea())
        Endif

        Li++

        @ LI,000  PSAY "   Sub-total Transportadora: "
        @ Li,067  PSAY _nTotSQt     PICTURE TM(_nTotSQt ,14,2)
        @ Li,082  PSAY _nTotSLt     PICTURE TM(_nTotSLt ,12,2)
        @ Li,095  PSAY _nTotSAB     PICTURE TM(_nTotSAB ,10,2)
        @ Li,117  PSAY _nTotSVl     PICTURE TM(_nTotSVl ,14,2)

        LI++

        @ LI,0 psay repl("-",limite)

        LI++

    Enddo

    if _nTotGVl>0

        if _lquebra
            roda(0,"",tamanho)
            li:=99
        endif

        If li>61
            Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            LI := 8
        Endif

        @ LI,000  psay "Total geral: "
        @ Li,067  PSAY _nTotGQt     PICTURE TM(_nTotGQt ,14,2)
        @ Li,082  PSAY _nTotGLt     PICTURE TM(_nTotGLt ,12,2)
        @ Li,095  PSAY _nTotGAB     PICTURE TM(_nTotGAB ,10,2)
        @ Li,117  PSAY _nTotGVl     PICTURE TM(_nTotGVl ,14,2)

        Roda(0,"",tamanho)
    Endif

    SD2->(retindex())

    If ( aReturn[5]==1 )
        Set Print to
        dbCommitall()
        ourspool(wnrel)
    EndIf

    MS_Flush()

Return(.t.)


Static Function _fIncrLin(_nIncrementa)

    if _nIncrementa=nil
        _nIncrementa:=1
    endif
    if li>61
        Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
    else
        li+=_nIncrementa
    endif
return li


Static Function GeraQRY3(_aPlaca,_cTransp)

    _cPlaca := "('"
    For _n_ := 1 To Len(_aPlaca)
        _cPlaca += If(Len(_cPlaca) = 2,_aPlaca[_n_],"','"+_aPlaca[_n_])
    Next _n_
    _cPlaca += "')"

    If Select("QRY3") > 0
        QRY3->(dbCloseArea())
    Endif

    _cQ := " SELECT ORDEM = 'A',A.ZB_NUMERO AS NUM,A.ZB_CARTAO AS CARTAO,A.ZB_TIPO AS TIPO,A.ZB_PLACA AS PLACA,A.ZB_DTABAST AS DTABAST,"
    _cQ += " A.ZB_QTABAST AS QTABAST,A.ZB_QUANT AS QUANT,A.ZB_HRABAST AS HRABAST,A.ZB_NFISCAL AS NFISCAL FROM "+ RetSqlName("SZB")+ " A "
    _cQ += " WHERE A.D_E_L_E_T_ = '' "
    _cQ += " AND A.ZB_CODEMP = '"+cEmpAnt+"' "
    _cQ += " AND A.ZB_CODFIL = '"+cFilAnt+"' "
    _cQ += " AND A.ZB_DTABAST BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
    _cQ += " AND A.ZB_TIPO = 'S' "
    _cQ += " AND A.ZB_PLACA IN "+_cPlaca+" "

    If !Empty(Alltrim(_cTransp))
        _cQ += " AND A.ZB_TRANSP = '"+_cTransp+"' "
    Endif

    _cQ += " AND A.ZB_NFISCAL <> '' "
    _cQ += " AND A.ZB_NFISCAL <> 'SALDO'"
    _cQ += " UNION ALL "
    _cQ += " SELECT ORDEM = 'B',B.ZB_NUMERO AS NUM,B.ZB_CARTAO AS CARTAO,B.ZB_TIPO AS TIPO,B.ZB_PLACA AS PLACA,B.ZB_DTABAST AS DTABAST,"
    _cQ += " B.ZB_QTABAST AS QTABAST,B.ZB_QUANT AS QUANT,B.ZB_HRABAST AS HRABAST,B.ZB_NFISCAL AS NFISCAL FROM "+ RetSqlName("SZB")+ " B "
    _cQ += " WHERE B.D_E_L_E_T_ = '' "
    _cQ += " AND B.ZB_CODEMP = '"+cEmpAnt+"' "
    _cQ += " AND B.ZB_CODFIL = '"+cFilAnt+"' "
    _cQ += " AND B.ZB_DTABAST BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
    _cQ += " AND B.ZB_TIPO = 'E' "
    _cQ += " AND B.ZB_PLACA IN "+_cPlaca+" "

    If !Empty(Alltrim(_cTransp))
        _cQ += " AND B.ZB_TRANSP = '"+_cTransp+"' "
    Endif

    _cQ += " AND B.ZB_NFISCAL = '' "

    _cQ += " UNION ALL "
    _cQ += " SELECT ORDEM = 'C',C.ZB_NUMERO AS NUM,C.ZB_CARTAO AS CARTAO,C.ZB_TIPO AS TIPO,C.ZB_PLACA AS PLACA,C.ZB_DTABAST AS DTABAST,"
    _cQ += " C.ZB_QTABAST AS QTABAST,C.ZB_QUANT AS QUANT,C.ZB_HRABAST AS HRABAST,C.ZB_NFISCAL AS NFISCAL FROM "+ RetSqlName("SZB")+ " C "
    _cQ += " WHERE C.D_E_L_E_T_ = '' "
    _cQ += " AND C.ZB_CODEMP = '"+cEmpAnt+"' "
    _cQ += " AND C.ZB_CODFIL = '"+cFilAnt+"' "
    _cQ += " AND C.ZB_DTABAST BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
    _cQ += " AND C.ZB_TIPO = 'S' "
    _cQ += " AND C.ZB_PLACA IN "+_cPlaca+" "
    _cQ += " AND C.ZB_NFISCAL = 'SALDO' "

    _cQ += " ORDER BY ORDEM,DTABAST,HRABAST "

    Memowrit("C:\TEMP\BRI110.sql",_cQ)

    TCQUERY _cQ  NEW ALIAS "QRY3"

    TcSetField("QRY3","DTABAST","D")

    Count To _nQry3

Return(Nil)

Static Function VALIDPERG(_cPerg1)

    ssAlias  := Alias()
    aRegs   := {}
    dbSelectArea("SX1")
    dbSetOrder(1)
    *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
    *+---------------------------------------------------------------------------------------------------------------------------------+
    *¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
    *¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
    *¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
    *¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
    *¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
    AADD(aRegs,{cPerg,"01","Data Inicial       :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
    AADD(aRegs,{cPerg,"02","Data Final         :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
    AADD(aRegs,{cPerg,"03","Transportadora De  ?","mv_ch3","C",06,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","","SA4"})
    AADD(aRegs,{cPerg,"04","Transportadora Ate ?","mv_ch4","C",06,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","","SA4"})
    AADD(aRegs,{cPerg,"05","Quebra pag p/ mot  ?","mv_ch5","N",01,0,0,"C","","mv_par05","Sim" ,"","","Nao"      ,"","","","","","","","","","",""})
    AADD(aRegs,{cPerg,"06","Preco Combustivel?  ","mv_ch6","N",14,2,0,"G","","mv_par06",""    ,"","",""         ,"","","","","","","","","","",""})

    u__fAtuSx1(padr(_cPerg1,len(sx1->x1_grupo)),aRegs)

Return(.T.)