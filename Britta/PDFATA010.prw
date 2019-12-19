#include "rwmake.ch"

*------------------------------------------------------------------------------------
User function PdFatA10()

    * Controle das Ordens de Carregamento (SZA)
    * Procedimento para implantacao:
    * - Implementacao deste, Mta410, Mta440c9
    * - Atualizacao de Ms520Vld (para tratar exclusao de nf's)
    * - Criacao de SZA (Sx2,Sx3,Six)
    * - Inclusao dos campos C6_PDGEROC, C9_PDOC e D2_PDOC (C 6)
    * - Inclusao desta rotina no projeto e menus (faturamento)
    * - Inclusao do novo indice (8) de SC9 (_filial+_pdOc)
    *------------------------------------------------------------------------------------

    Private cCadastro := "Ordens de carregamento"
    u_CriaMv("","N","MV_PDQTDPA","20","Expecifico Polimix. Quantidade padrao para a liberacao do pedido - analise de credito")

    Private aRotina :={ {"Pesquisar","AxPesqui"		,0,1} ,;
        {"Visualizar","AxVisual"	     ,0,2} ,;
        {"Lib Credito","u_PdFat10e()"    ,0,6} ,;
        {"Baixar","u_PdFat10c()"	 	 ,0,3} ,;
        {"Imprimir","u_PdFat10b()"		 ,0,2} ,;
        {"Relacao de OC's","u_PdFat10d()",0,2} ,;
        {"Excluir","AxDeleta",0,5},;
        {'Legenda'       ,'BrwLegenda("Situacao da ordem de carregamento"  ,"Legenda",_vLegenda)', 0 ,3}}

    Private cDelFunc := "u_PdFat10a()" // Validacao para a exclusao
    Private cString := "SZA"

    _vLegenda:={{"BR_AZUL"    ,'Bloqueado por credito'},;
        {"BR_VERDE"   ,'Aguardando carregamento'},;
        {"BR_AMARELO","Aguardando faturamento"},;
        {"BR_VERMELHO"   ,"Ordem de carregamento faturada"}}

    aCores := {{'SZA->ZA_PBRUTO==0.and.!empty(sza->za_blcred)','BR_AZUL'   },;   // Bloqueado por credito
    { 'SZA->ZA_PBRUTO==0.and.sza->za_nota=="         "','BR_VERDE'   },;   // Em Aberto
    { 'SZA->ZA_PBRUTO>0.and.sza->za_nota=="         "' ,'BR_AMARELO' },; // Aguardando faturamento
    { 'SZA->ZA_PBRUTO>0.and.sza->za_nota>"         "'  ,'BR_VERMELHO'}}  // Ordem de carregamento faturada

    dbSelectArea("SZA")
    dbSetOrder(1)
    mBrowse(,,,,cString,,,,,,aCores)

Return

    *-----------------------------------------------------
user function PdFat10a
    *-----------------------------------------------------
    local _lReturn:=.t.
    if !empty(sza->za_nota)
        sf2->(dbsetorder(1))
        if sf2->(dbseek(xfilial()+sza->(za_nota+za_serie),.f.))
            msgbox("Esta ordem de carregamento nao podera ser excluida pois gerou nota fiscal")
            _lReturn:=.f.
        endif
    endif

return _lReturn

    *-----------------------------------------------------
User Function PDFAT10B()

    If !Empty(sza->za_blcred)
        msgbox("O pedido foi bloqueado por credito, impressao nao permitida")
        Return
    Endif

    if !_fCanhoto(sza->za_placa)
        // Ricardo - 11/02/2019 - Com ou sem o retorno, deve fazer a impressðo - Solicit Tiago
    endif


    nLastKey  :=0
    limite    :=80
    wnrel     :=nomeprog:="PdFat10b"
    cDesc1    :="Impressao da Ordem de Carregamento"
    cDesc2    :=" "
    cDesc3    :=" "
    cString   :="SZA"
    tamanho   := "P"
    titulo    := "Ordem de carregamento"
    aReturn := { "Zebrado",;  // Tipo do formulario
    1,;  // Numero de vias
    "Administracao",;  // Destinatario
    1,;  // Formato 1-Comprimido  2-Normal
    2,;  // Midia  1-Disco  2-Impressora
    2,;  // Porta ou arquivo (1-LPT1...)
    "",;  // Expressao do filtro
    1 }  // Ordem (Numero do indice)

    m_pag     :=1
    Li        :=0
    Cabec1:=""
    Cabec2:=""
    _vBkImp:=aclone(__aImpress)

    __aImpress[1]:=2 // Forca impressao padrao 1=Em disco;2=Via Spool;3=Direta na porta;4=E-mail

    wnrel:=SetPrint(cString,wnrel,_cPerg:=nil,Titulo,cDesc1,cDesc2,cDesc3,.T.)

    __aImpress[1]:=_vBkImp[1]
    __aImpress[2]:=_vBkImp[2]
    __aImpress[3]:=_vBkImp[3]
    __aImpress[4]:=_vBkImp[4]

    if nLastkey==27
        set filter to
        return
    endif

    RptStatus({|| RptDetail() })


Static function rptdetail

    Local _nVezL,_nVez
    setdefault(aReturn,cString)
    setprc(0,0)
    _nLin:=1

    limite:=45

    do while sza->(!reclock(alias(),.f.))
    enddo
    sza->za_hruimp:=left(time(),5)
    sza->(msunlock())

    _vImp:={repl("=",limite)}
    aadd(_vImp,padc(AllTrim(SM0->M0_NOME)+" / "+Alltrim(SM0->M0_FILIAL),limite))
    aadd(_vImp,padc(dtoc(sza->za_emissao)+" - "+sza->za_hruimp+" h",limite))
    aadd(_vImp,repl(" ",limite))
    aadd(_vImp,padc("Ordem de Carregamento No.: "+sza->za_num,limite))
    aadd(_vImp,repl("-",limite))
    aadd(_vImp,"")
    aadd(_vImp,"Cliente: "+sza->za_nomcli)
    aadd(_vImp,"")
    aadd(_vImp,"Destino: "+sza->za_descee)
    sza->(aadd(_vImp,alltrim(za_pdbaie)+" - "+alltrim(za_pdmune)))
    aadd(_vImp,"")
    aadd(_vImp,"Produto: "+alltrim(sza->za_produto)+" - "+posicione("SB1",1,xfilial("SB1")+sza->za_produto,"alltrim(b1_desc)"))
    aadd(_vImp,"")
    aadd(_vImp,"Placa: "+left(sza->za_placa,3)+"-"+substr(sza->za_placa,4)+"  -  Pedido: "+sza->za_numpv)
    aadd(_vImp,"")
    sza->(aadd(_vImp,"Transp..: "+za_transp+" - "+posicione("SA4",1,xfilial("SA4")+za_transp,"left(a4_nome,25)")))
    sza->(aadd(_vImp,"Vendedor: "+za_vend1+" - "+posicione("SA3",1,xfilial("SA3")+za_vend1,"left(a3_nome,25)")))

// Ricardo 29/09/2019
/*
_cCpfMot:=posicione("SA3",1,xfilial("SA3")+za_vend1,"a3_cgc")
    if len(alltrim(_cCpfMot))>12
   _cCpfMot:='CNPJ....: '+tran(_cCpfMot,'@R 99.999.999/9999-99')
    else
   _cCpfMot:='CPF.....: '+tran(_cCpfMot,'@R 999.999.999-99')
    endif*/
                                          
aadd(_vImp,'Motorista: '+posicione('DA4',1,xfilial('DA4')+sza->za_xmotori,'da4_nome'))
aadd(_vImp,'CPF......: '+posicione('DA4',1,xfilial('DA4')+sza->za_xmotori,"tran(da4_cgc,'@R 999.999.999-99')"))
aadd(_vImp,"Prezado motorista, verifique seu nome e CPF neste documento")

aadd(_vImp,repl("-",limite))
_cArq:="c:\Bema.txt"
_cConteudo:=""
_nLin:=0
setregua(len(_vImp))
    for _nVez:=1 to len(_vImp)
	incregua()
	_cTexto:=(_vImp[_nVez])
	_nLinhas:=mlcount(_cTexto,limite)
        for _nVezL:=1 to _nLinhas
		@ _nLin++,0 PSAY memoline(_cTexto,limite,_nVezL)
		_cConteudo+=memoline(_cTexto,limite,_nVezL)+chr(13)+chr(10)
        next
    next

@ _nLin+9,0 psay " "

    If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
    Endif

ms_fLUSH()

Return


User function PdFat10c()

LOCAL lDigPeso:=.F.
LOCAL bPeso
private _oDlg,_cOC:=space(6),_cPlaca:=space(len(sza->za_placa)),_cMotorista:=_cEndEnt:=_cCliNome:="",;
_cPictPeso:=pesqpict("SZA","ZA_PBRUTO"),_cNomeMot,_lReturn:=.f.,;
_nTara:=_nPliq:=0
PRIVATE _nPrUnit :=0
PRIVATe _nVlrTot :=0
public _nPBruto  :=0
PRIVATE _xNumCC  := ""
_cLacre          := space(7)

//       {"X6_FIL","X6_VAR"    ,"X6_TIPO","X6_DESCRIC                                        ","X6_CONTEUD"
U_CRIASX6("  "    ,"BRI_CLILAC","C"      ,"Cliente Que Utiliza Lacre de Carregamento         ","00490301"    )

_cCliLacre       := GETMV("BRI_CLILAC")

bPeso:="iif(cEmpAnt=='01'.and.cFilant=='04',u_LeBjMro(),u_LeBjBritta()),iif(Type('_oPBruto')=='O',_oPBruto:Refresh(),'')"
bTara:="u_BALS(@_nPBruto,@_nTara,@_nPLiq,@_nPrUnit,@_nVlTot)"

setkey(123,{|| &bPeso} )
setkey(122,{|| &bTara})

lDigPeso:=u_ChkAcesso("DIGITAPESO",6,.F.)
    IF .not. lDigPeso
	Eval({|| &bPeso })
    ENDIF

@ 0,0 to 240,550 dialog _oDlg title "Baixa da ordem de carregamento"

@ 025,005 say "Placa do veiculo: "
@ 025,065 get _cPlaca picture '@!' size 40,10 valid vazio().or.(_fVldOc('Placa').and._fFocus())

@ 010,005 say "Numero: "
@ 010,065 get _cOC valid vazio().or._fVldOc('Numero')
@ 006,100 button "Imprime Ticket" size 50,12 action u_fTicket(_cPlaca,_nPBruto,'Peso Bruto') object _oImpTicket
_oImpTicket:BWhen:={||_nPBruto>0.and.!empty(_cPlaca)}
@ 006,217 button "F11 - Captura peso" size 50,12 action Eval({|| &bTara })
@ 025,110 say "Motorista:"
@ 025,135 get _cNomeMot size 130,10 when .f.
@ 040,005 say "Endereco de entrega: "
@ 040,065 get _cEndent size 200,10 when .f.

// Ricardo 17/10/2019                
@ 055,005 say "Nome do cliente: "
@ 055,065 get _cCliNome size 200,10 when .f.

@ 070,005 say "Peso bruto: "
@ 070,065 get _nPBruto picture _cPictPeso size 45,10 WHEN lDigPeso VALID u_fVldPBruto() object _oPBruto
@ 070,120 say "Tara: "
@ 070,137 get _nTara when .f. size 45,10 picture _cPictPeso
@ 070,187 say "Peso liquido: "
@ 070,222 get _nPLiq when .f. size 45,10 picture _cPictPeso
_cProduto:=space(15)
_nPrUnit:=_nVlTot:=0
@ 085,005 say "Produto"
@ 085,065 get _cProduto size 040,15 when .f.
@ 085,120 say "Vl Unit"
_cPictVal:="@er 9,999.99"
@ 085,137 get _nPrUnit when .f. size 45,10 picture _cPictVal
@ 085,187 say "Valor total:  "
@ 085,222 get _nVlTot when .f. size 45,10 picture _cPictVal

@ 100,005 Say "Lacre"
@ 100,065 get _cLacre   Size 040,15 When SZA->ZA_CLIENTE + SZA->ZA_LOJACLI $ _cCliLacre   VALID !Vazio()

@ 100,190 bmpbutton type 1 action (_lReturn:=_fBaixaOc(_xNumCC,_lReturn)) object _oBut1
@ 100,240 bmpbutton type 2 action close(_oDlg)

activate dialog _oDlg centered

setkey(123,{||nil})

return _lReturn

*---------------------------------------------------------------------------------------
static function _fFocus()
*---------------------------------------------------------------------------------------
_oBut1:Setfocus()
return .t.

*---------------------------------------------------------------------------------------
static function _fVldOc(_cNumPlaca)
*---------------------------------------------------------------------------------------
local _lReturn:=_lAchou:=.f.

cursorwait()

    if _cNumPlaca==nil
	_cNumPlaca:='Numero'
    endif

    if _cNumPlaca=='Numero'
	sza->(dbsetorder(1))
        if sza->(dbseek(xfilial()+_cOc,.f.))
		_lAchou:=.t.
        endif
    elseif _cNumPlaca=='Placa'
	sza->(dbsetorder(5))  // ZA_FILIAL+ZA_PLACA+ZA_NOTA+DTOS(ZA_EMISSAO)+ZA_NUM
	sza->(dbseek(xfilial()+_cPlaca+space(len(za_nota)),.f.))
        do while sza->(!eof().and.za_filial+za_placa+za_nota==xfilial()+_cPlaca+space(len(za_nota)))
            if SZA->ZA_PBRUTO==0
			_cOc:=sza->za_num
            endif
		sza->(dbskip(1))
        enddo
	sza->(dbsetorder(1))
        if sza->(dbseek(xfilial()+_cOc,.f.))
		_lAchou:=.t.
        endif
    endif

    If _lAchou
        if !empty(SZA->ZA_NOTA)
		msgbox("Esta ordem de carregamento ja gerou nota fiscal")
        elseif !empty(sza->za_blcred)
		msgbox("Esta ordem de carregamento foi bloqueada por credito")
        else
		// Ricardo 22/01/2019
		//if !_fCanhoto(_cPlaca) // Ricardo 31/01/2019 - Tiago solicitou que fosse avisado somente na gravaçðo da OC (confirmaçðo do pedido de vendas)
		
		//else
            if sza->za_pbruto==0.or.(sza->za_pbruto<>0.and.msgyesno("Esta ordem de carregamento ja foi apontada (Peso bruto = "+tran(sza->za_pbruto,_cPictPeso)+"), deseja apontar novamente ?"))
			_nTara  :=sza->za_tara
			_cPlaca :=sza->za_placa
			_cNomeMot:=posicione("SZ1",1,xfilial("SZ1")+_cPlaca,"z1_nomemot")
			_cEndent:=sza->(alltrim(za_descee)+" - "+alltrim(za_pdbaie)+" - "+alltrim(za_pdmune))
			
			// Ricardo 17/10/2019
			_cCliNome:=Posicione("SA1",1,xfilial('SA1')+sza->(za_cliente+za_lojacli),'a1_nome')
			
			_nPBruto:=IIF(SZA->ZA_PBRUTO<>0,sza->za_pbruto,_nPBruto)
			_nPLiq  :=_nPBruto-_nTara
			sc6->(dbsetorder(1))
			sc6->(dbseek(xfilial()+sza->(za_numpv+za_itempv),.f.))
			_cProduto:=sza->za_produto
			_nPrUnit:=sc6->c6_prcven
			_nVlTot:=round(_nPliq*_nPrunit,2)
			
			_lReturn:=.t.
            endif
        endif
    Else
	msgbox("Ordem de carregamento nao encontrada")
    Endif

cursorarrow()

    IF Type("_oPBruto") =="O"
	_oPBruto:Refresh()
    ENDIF

return _lReturn

*---------------------------------------------------------------------------------------
static function _fBaixaOc(_xNumCC,_lReturn)
*---------------------------------------------------------------------------------------
local _lReturn:=.f.,_vAmbSc9:=sc9->(getarea())

    if empty(_cOc)
	return _lReturn
    Endif

    If SZA->ZA_CLIENTE + SZA->ZA_LOJACLI $ _cCliLacre
        If Empty(_cLacre)
		MsgInfo("Favor Informar o Lacre!!")
		Return .f.
        Endif
    Endif

    if _nPBruto==0
	alert("Problemas na leitura do peso")
	Return .f.
    endif
    if _nPLiq <=0 .or. _nPBruto <= _nTara
	Alert("Peso Invalido. Verifique a Placa/OC, Peso Bruto e Tara")
	RETURN .f.
    endif

SC9->(dbOrderNickname("INDSC91"))
//_cNewFil:="z"+substr(cFilAnt,2,1) // ALTERADO EM 18/07/19
_cNewFil:= xFilial("SC9") 			// ALTERADO EM 18/07/19
//if !sc9->(dbseek(sza->(_cNewFil+za_num),.f.))
//If !SC9->(MsSeek(_cNewFil + SZA->ZA_NUM))
    If !SC9->(MsSeek(SZA->ZA_FILIAL  + SZA->ZA_NUM))
	msgbox("O registro correspondente em SC9 nao foi localizado, a OC devera ser refeita")
	return .f.
    endif

    if !empty(_cOC).and._nPBruto<>0.and.sza->za_num==_cOC
	
	/*
	Chama a rotina de cartðo de Crédito caso a condiçðo de Pagamento for = "000 - A Vista"
	*/
        _lReturn := .T.
        SC5->(DBSETORDER(1))
        SC5->(DBSEEK(XFILIAL()+SZA->ZA_NUMPV))
        IF SC5->C5_CONDPAG = "000"
            U_MCCREDITO(@_xNumCC,@_lReturn)
        ENDIF

        IF _lReturn = .T.

            if sza->(reclock(alias(),.f.))
                sza->za_pbruto:=_nPBruto
                sza->za_pliq  :=_nPLiq
                If SZA->(FieldPos("ZA_LACRE")) > 0
                    SZA->ZA_LACRE := _cLacre
                Endif
                If SZA->(FieldPos("ZA_HORA02")) > 0
                    SZA->ZA_HORA02	:= Time()
                Endif
                SZA->(MsUnlock())

                // Localiza SC9, atualiza a quantidade e libera o estoque
                sc9->(dbsetorder(9))
                //if sc9->(dbseek(xfilial()+sza->za_num,.f.).and.empty(c9_nfiscal).and.empty(c9_blcred).and.c9_blest<>'10'.and.c9_qtdlib==getmv("MV_PDQTDPA").and.reclock(alias(),.f.))
                if sc9->(empty(c9_nfiscal).and.reclock(alias(),.f.))

                    // verifica se a sequencia de liberacao esta em ordem, prevenindo chave duplicada
                    _cSequen:=sc9->c9_sequen
                    _vAmbSc9:=sc9->(getarea())
                    sc9->(dbsetorder(1))
                    do while sc9->(dbseek(sc9->(xfilial()+c9_pedido+c9_item+_cSequen+c9_produto),.f.))
                        _cSequen:=soma1(_cSequen)
                    enddo
                    sc9->(restarea(_vAmbSc9))

                    //sc9->c9_filial := xfilial("SC9") -- ALTERADO EM 18/07/19
                    sc9->c9_sequen := _cSequen
                    sc9->c9_blest  := ""
                    _nQtdLib       := sc9->c9_qtdlib
                    _nQtdLIb2      := sc9->c9_qtdlib2/_nQtdLib*sza->za_pliq
                    sc9->c9_qtdlib := sza->za_pliq
                    sc9->c9_qtdlib2:= round(_nQtdLib2,2)
                    sc9->c9_blcred := sza->za_blcred
                    SC9->C9_BLOQUEI:= "" // ALTERADO EM 25/07/19
                    SC9->(MsUnLock())

                    // Atualiza dados no cabecalho do pedido

                    //sc5->(dbsetorder(1))
                    //if sc5->(dbseek(xfilial()+sza->za_numpv,.f.).and.reclock(alias(),.f.))

                    //	While sz9->(!reclock(alias(),.f.))
                    //	EndDo

                    SC5->(dbsetorder(1))
                    If SC5->(dbSeek(xfilial()+SZA->ZA_NUMPV))

                        While SC5->(!RecLock("SC5",.f.))
                        EndDo

                        SC5->C5_FRETE   := SZA->(ZA_PLIQ * ZA_VLRFRET)
                        SC5->C5_TRANSP  := SZA->ZA_TRANSP
                        SC5->C5_VEND1   := SZA->ZA_VEND1
                        SC5->C5_PLACA   := SZA->ZA_PLACA
                        SC5->C5_NOMEMOT := posicione("SA3",1,xfilial("SA3")+sc5->c5_vend1,"A3_NREDUZ")
                        SC5->C5_NOMETRA := posicione("SA4",1,XFILIAL("SA4")+sc5->C5_TRANSP,"A4_NREDUZ")
                        SC5->C5_VOLUME1 := ROUND(_nPLiq,0)
                        SC5->C5_PBRUTO  := _nPBruto
                        SC5->C5_PESOL   := _nPLiq

                        SC5->(MsUnlock())
                    Endif

                    _lReturn:=.t.
                endif
            ENDIF
        endif
    endif

    If _lReturn = .T.
        _xNumDoc := SF2->F2_DOC+SF2->F2_SERIE

        _dDatBkp := dDataBase
        _dEmissao:= dDataBase
        _cHora   := Left(time(),5)
        _cMin    := Right(_cHora,2)

        If SM0->M0_ESTCOB $ "AC/AM/MT/MS/RO/RR"
            If _cHora   == "00"
                _dEmissao--
                _cHora  := "23:" + _cMin
            Else
                _cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
            Endif
        Endif

        If GETMV("MV_HVERAO")  /// SE VERDADEIRO ENTAO TEM HORARIO DE VERðO
            If !SM0->M0_ESTCOB $ "DF/GO/ES/MT/MS/MG/PR/RJ/RS/SP/SC"   // ESTADOS QUE NAO TEM HORARIO DE VERAO
                If _cHora   == "00"
                    _dEmissao--
                    _cHora    := "23:" + _cMin
                Else
                    _cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
                Endif
            Endif
        Endif

        dDataBase := _dEmissao

        u_CriaMv(cFilAnt,_cTipo:="L","MV_XGNFC9",_cDefault:=".F.",_cDescri:="Geração automática da NF com base no SC9 posicionado")
        if existblock("GERNFC9").and.getmv("MV_XGNFC9")
            _vRecSc9:={sc9->(recno())}
            MsAguarde( {|| u_GerNFC9(_vRecSc9,_pSerie:=GetMv("MV_XSERNF")) }, "Geração da Nota Fiscal")
        else
            MATA460A() // Faturamento padrao do sistema
        endif







        dDataBase := _dDatBkp

        If !Empty(_xNumCC)
            If _xNumDoc <> SF2->F2_DOC+SF2->F2_SERIE
                RECLOCK("SF2",.F.)
                SF2->F2_XNCCRED := PADL(Alltrim(_xNumCC),12,"0")
                MSUNLOCK()

                RECLOCK("SE1",.F.)
                SE1->E1_XNCCRED := PADL(Alltrim(_xNumCC),12,"0")
                MSUNLOCK()
            Endif
        Endif
    ENDIF

    if !_lReturn
        msgbox("A ordem de carregamento nao foi baixada ZA_NUM: ("+sza->za_num+") _cOC: ("+_cOc+") _nPBruto: "+alltrim(str(_nPBruto)))
    endif

    close(_oDlg)
return _lReturn

    *---------------------------------------------------------------------------------------
user function fVldPBruto()
    *---------------------------------------------------------------------------------------
    local _lReturn:=(_nPBruto>0)

    if _lReturn
        _nPLiq:=_nPBruto-_nTara
        _nVlTot:=round(_nPLiq*_nPrUnit,2)
    endif

return _lReturn

    *----------------------------------------------------------------------------------------
user function PdFat10d
    * Relacao de OC's
    *----------------------------------------------------------------------------------------

    nLastKey  :=0
    limite    :=132
    wnrel     :=nomeprog:="PdFat10d"
    cDesc1    :="Relacao de ordens de Carregamento"
    cDesc2    :=" "
    cDesc3    :=" "
    cString   :="SZA"
    tamanho   := "M"
    titulo    := cDesc1
    aReturn := { "Zebrado",;  // Tipo do formulario
    1,;  // Numero de vias
    "Administracao",;  // Destinatario
    2,;  // Formato 1-Comprimido  2-Normal
    2,;  // Midia  1-Disco  2-Impressora
    2,;  // Porta ou arquivo (1-LPT1...)
    "",;  // Expressao do filtro
    1 }  // Ordem (Numero do indice)
    _cPergD:="FAt10d"
    validperg(_cPergD)

    m_pag     :=1
    Li        :=99
    Cabec1:="Numero  Emissao  Impressao Placa     Motorista                     Pedido  Produto         Peso Liq  NF     Serie Situacao"
    Cabec2:=""
//wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
    wnrel:=SetPrint(cString,wnrel,_cPergD,Titulo,cDesc1,cDesc2,cDesc3,.T.)
    if nLastkey==27
        set filter to
        return
    endif

    RptStatus({|| Rpt10d() })

    *-------------------------------------------
Static function rpt10d
    *-------------------------------------------
    pergunte(_cPergD,.f.)
    _dDataIni :=mv_par01
    _dDataFim :=mv_par02
    _nSituacao:=mv_par03 // 1=Aguard carregamento,2=Aguard faturamento,3=Faturadas,4=Todas

    _cFiltro:="dtos(za_emissao)>='"+dtos(_dDataIni)+"'.and.dtos(za_emissao)<='"+dtos(_dDataFim)+"'"
    if _nSituacao==1
        _cFiltro+=".and.za_pbruto==0"
    elseif _nSituacao==2
        _cFiltro+=".and.za_pbruto>0.and.empty(za_nota)"
    elseif _nSituacao==3
        _cFiltro+=".and.!empty(za_nota)"
    endif
    sza->(dbsetorder(1))
    sza->(indregua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))

    setdefault(aReturn,cString)


    setregua(sza->(lastrec()))
    sza->(dbgotop())

    do while sza->(!eof())
        _cSit:=""

        if sza->(za_pbruto==0)
            _cSit:="Aguardando carregamento"
        elseif sza->(za_pbruto>0.and.empty(za_nota))
            _cSit:="Aguardando faturamento"
        elseif sza->(!empty(za_nota))
            _cSit:="Faturada"
        endif

        @ _fIncrLin(),0 psay sza->(za_num+"  "+dtoc(za_emissao)+"  "+sza->za_hruimp+" h  "+left(za_placa,3)+"-"+substr(za_placa,4)+"  "+posicione("SZ1",1,xfilial("SZ1")+za_placa,"left(z1_nomemot,30)")+;
            za_numpv+"  "+za_produto+" "+tran(za_pliq,pesqpict("SC6","C6_QTDVEN"))+" "+za_nota+" "+za_serie)+"   "+_cSit
        sza->(dbskip(1))
    enddo

    roda(0,"",tamanho)

    If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel)
    Endif
    MS_FLUSH()
Return

    *--------------------------------------------------------------------------
user function PdFat10e
    * Liberacao de credito
    *--------------------------------------------------------------------------
//if msgyesno("Confirma a liberacao de credito ?").and.sza->(reclock(alias(),.f.))
//	sza->za_blcred:=""
//	sza->(msunlock())
//endif

return

    *--------------------------------------------------------------------------
Static function _fIncrLin(_nIncr)
    *--------------------------------------------------------------------------
    if _nIncr==nil
        _nIncr:=1
    endif
    li+=_nIncr
    if Li > 61
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
    endif
return li

    *------------------------------------------------------------------------------------
user function LeBjBritta()

    local _cDir:="c:\",_cEscopo:="peso.txt"
    Local _nLePeso:=0,_nVez:=0

    IF cEmpAnt='08'
        _cDir:="c:\balanca\"
    ENDIF

    If cEmpAnt $ "02/12" .Or. (cEmpAnt == "50" .And. cFilAnt == "04")
        _cEscopo:= "peso1.txt"
    Endif

    If funname()=='PDFATA11'
        _vDir:=directory(_cDir+_cEscopo)
        // Colhe o nome do arquivo mais recente

        asort(_vDir,,,{|_vAux1,_vAux2|dtos(_vAux1[3])+_vAux1[4]>=dtos(_vAux2[3])+_vAux2[4]})

        _vPeso:={}
        cursorwait()
        do while len(_vDir)>0.and._nVez<10 //200 // quantidade de leituras a fazer para obter a leitura mais frequente
            _cPeso:=memoread(_cDir+_vDir[1][1])
            _cPeso:=strtran(_cPeso,chr(13),'')
            _cPeso:=strtran(_cPeso,chr(10),'')
            _cPeso:=right(_cPeso,6)
            if len(_vPeso)<2000
                aadd(_vPeso,_cPeso)
            endif
            _nVez++
        enddo
        _nLePeso:=0
        if len(_vPeso)>0
            _vPeso2:={}
            // classifica por peso lido
            asort(_vPeso)
            _nOcor:=0
            _cPeso:=_vPeso[1]
            for _nVez:=1 to len(_vPeso)
                _nOcor++
                if _vPeso[_nVez]<>_cPeso.or._nVez==len(_vPeso)
                    aadd(_vPeso2,strzero(_nOcor,6)+_cPeso)
                    _nOcor:=0
                endif
            next
            asort(_vPeso2)
            _nLePeso:=val(substr(_vPeso2[len(_vPeso2)],7))
        endif
        cursorarrow()
    else
        setkey(123,{||nil})
    endif

    _nPBruto:=round(_nLePeso/1000,2)

//_oPBruto:Refresh()
    u_fVldPBruto()

return .t.

    *------------------------------------------------------------------------------------
user function LeBjMro()
    *------------------------------------------------------------------------------------
    local _cDir:="c:\",_cEscopo:="peso.txt",_nLePeso:=0,_nVez:=0

    If cEmpAnt == "12" .Or. (cEmpAnt == "50" .And. cFilAnt == "04")
        _cEscopo:= "peso1.txt"
    Endif

    If funname()=='PDFATA11'
        _vDir:=directory(_cDir+_cEscopo)
        // Colhe o nome do arquivo mais recente

        asort(_vDir,,,{|_vAux1,_vAux2|dtos(_vAux1[3])+_vAux1[4]>=dtos(_vAux2[3])+_vAux2[4]})

        _vPeso:={}
        cursorwait()
        do while len(_vDir)>0.and._nVez<=10 //200 // quantidade de leituras a fazer para obter a leitura mais frequente
            _cPeso:=memoread(_cDir+_vDir[1][1])
            _cPeso:=strtran(_cPeso,chr(13),'')
            _cPeso:=strtran(_cPeso,chr(10),'')
            _cPeso:=right(_cPeso,6)
            if len(_vPeso)<2000
                aadd(_vPeso,_cPeso)
            endif
            _nVez++
        enddo
        _nLePeso:=0
        if len(_vPeso)>0
            _vPeso2:={}
            // classifica por peso lido
            asort(_vPeso)
            _nOcor:=0
            _cPeso:=_vPeso[1]
            for _nVez:=1 to len(_vPeso)
                _nOcor++
                if _vPeso[_nVez]<>_cPeso.or._nVez==len(_vPeso)
                    aadd(_vPeso2,strzero(_nOcor,6)+_cPeso)
                    _nOcor:=0
                endif
            next
            asort(_vPeso2)
            _nLePeso:=val(substr(_vPeso2[len(_vPeso2)],7))
        endif
        cursorarrow()
    else
        setkey(123,{||nil})
    endif

    _nPBruto:=round(_nLePeso/1000,2)

    u_fVldPBruto()
// Eliminado, abortando quando o arquivo estava indisponível //ferase("c:\peso.txt")
return .t.

    *-----------------------------------------------------
user function fTicket(_cPPlaca,_nPPeso,_cPTipo)
    * Impressao do ticket da balança
    *-----------------------------------------------------

    nLastKey  :=0
    limite    :=80
    wnrel     :=nomeprog:="fTicket"
    cDesc1    :="Impressao do ticket da balança"
    cDesc2    :=" "
    cDesc3    :=" "
    cString   :="SZA"
    tamanho   := "P"
    titulo    := "Ticket - comprovante de pesagem"
    aReturn := { "Zebrado",;  // Tipo do formulario
    1,;  // Numero de vias
    "Administracao",;  // Destinatario
    1,;  // Formato 1-Comprimido  2-Normal
    3,;  // Midia  1-Disco  2-Impressora
    2,;  // Porta ou arquivo (1-LPT1...)
    "",;  // Expressao do filtro
    1 }  // Ordem (Numero do indice)

    m_pag     :=1
    Li        :=0
    Cabec1:=""
    Cabec2:=""
    _vBkImp:=aclone(__aImpress)
    if "guiche"$lower(getcomputername())
        aReturn[6]:=1 // Se for guiche, força padrðo LPT1
    endif
    __aImpress[1]:=3 // Forca impressao padrao 1=Em disco;2=Via Spool;3=Direta na porta;4=E-mail
    __aImpress[2]:=1
    __aImpress[3]:=2 // Forca impressao padrao 1=Cliente;2=Servidor
    __aImpress[4]:=1

//wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.t.,tamanho)
    wnrel:=SetPrint(cString,wnrel,_cPerg:=nil,Titulo,cDesc1,cDesc2,cDesc3,.T.)

    __aImpress[1]:=_vBkImp[1]
    __aImpress[2]:=_vBkImp[2]
    __aImpress[3]:=_vBkImp[3]
    __aImpress[4]:=_vBkImp[4]

    if nLastkey==27
        set filter to
        return
    endif

    RptStatus({|| RptTicket(_cPPlaca,_nPPeso,_cPTipo)})

    *-------------------------------------------------------
Static function rptTicket(_cPPlaca,_nPPeso,_cPTipo)
    *-------------------------------------------------------

    Local _nVezL,_nVez
    cPictPeso:=pesqpict("SZA","ZA_PBRUTO")

    setdefault(aReturn,cString)
    setprc(0,0)
    _nLin:=1

    limite:=45

    _vImp:={repl("=",limite)}
    aadd(_vImp,left(sm0->m0_nomecom,limite))
    aadd(_vImp,left('CNPJ: '+tran(sm0->m0_cgc,'@R 99.999.999/9999-99'),limite))
    aadd(_vImp,repl(" ",limite))
    aadd(_vImp,padc("Emissao: "+dtoc(ddatabase)+" - "+time()+" h",limite))
    aadd(_vImp,repl(" ",limite))
    aadd(_vImp,"Placa: "+_cPPlaca+"   "+_cPTipo+": "+tran(_nPPeso,_cPictPeso)+' Ton')
    aadd(_vImp,"")
    aadd(_vImp,repl("-",limite))
    _cArq:="c:\Bema.txt"
    _cConteudo:=""
    _nLin:=0
    setregua(len(_vImp))
    for _nVez:=1 to len(_vImp)
        incregua()
        _cTexto:=(_vImp[_nVez])
        _nLinhas:=mlcount(_cTexto,limite)
        for _nVezL:=1 to _nLinhas
            @ _nLin++,0 PSAY memoline(_cTexto,limite,_nVezL)
            //@ _nLin++,0 PSAY left(strzero(_nLin,3)+memoline(_cTexto,limite,_nVezL),limite)
            _cConteudo+=memoline(_cTexto,limite,_nVezL)+chr(13)+chr(10)
        next
    next

// Alimentacao para o corte
    @ _nLin+9,0 psay " "

    If aReturn[5] == 1
        Set Printer To
        Commit
        ourspool(wnrel)
    Endif

    ms_fLUSH()

Return

    *-----------------------------------------------------------------------------------------------------
Static Function _fCanhoto(_Placa)
    * Validaçðo quanto à existência de canhotos pendentes de recebimento
    *-----------------------------------------------------------------------------------------------------

    Local _nVez
    local _lReturn:=.t.,_vAmbSf2:=sf2->(getarea()),_cParMail:='MV_XMACANH',_cEmailDest:='',;
        _cParDtCor:="MV_XDATACA",_cSql,_cAliasAtu:=alias(),_cNotas:='',_cQuebraL:=chr(13)+chr(10),_nCanhotos:=0
    u_CriaMv(_cFilial:=cFilAnt,_cTipo:="C",_cNomPar:=_cParMail,_cDefault:="expedicao1.iro@britta.com.br",_cDescri:="Endereço de e-mail destinatário dos avisos de pendências de canhoto na Ordem de Carregamento")
    u_CriaMv(_cFilial:=cFilAnt,_cTipo:="D",_cNomPar:=_cParDtCor,_cDefault:="20190501",_cDescri:="Data à partir da qual serðo verificadas pendências de canhotos na ordem de carregamento")

    _cEmailDest:=getmv(_cParMail)
    _dDtCorte:=getmv(_cParDtCor)
    if !empty(_cEmailDest).and.sf2->(fieldpos("F2_XCAREC"))>0
        // Se o e-mail está configurado, comunica ao usuário sobre eventuais pendências de canhotos no
        // momento da digitaçðo da placa do veículo na ordem de carregamento
        _cSql:="Select * from "+RetSqlName("SF2")+" SF2 where F2_FILIAL='"+xfilial('SF2')+;
            "' and F2_EMISSAO>='"+dtos(_dDtCorte)+"' and F2_PLACA='"+_Placa+"' and F2_XCAREC='' and D_E_L_E_T_<>'*' order by F2_SERIE,F2_DOC"

        DbUseArea(.T.,"TOPCONN",TCGenQry(,,_cSql),"_Sf2",.F.,.T.)
        _cAlias:=alias()
        sx3->(dbsetorder(2))
        for _nVez:=1 to (_cAlias)->(fcount())
            _cCampo:=(_cAlias)->(fieldname(_nVez))
            if sx3->(dbseek(_cCampo))
                if alltrim(upper(sx3->x3_tipo))$"DNL"
                    sx3->(tcsetfield(_cAlias,_cCampo,x3_tipo,x3_tamanho,x3_decimal))
                endif
            endif
        next
        sx3->(dbsetorder(1))

        do while _Sf2->(!eof())
            _cNotas+=_Sf2->(f2_doc+' / '+f2_serie+'  de  '+dtoc(f2_emissao))+_cQuebraL
            _nCanhotos++
            _Sf2->(dbskip(1))
        enddo
        _Sf2->(dbclosearea())

        if !empty(_cAliasAtu)
            dbselectarea(_cAliasAtu)
        endif
        if !empty(_cNotas)
            u_fMMens(alltrim(str(_nCanhotos))+(_cAssunto:=' Canhotos pendentes para '+_Placa+' Empresa: '+cEmpAnt+' Filial: '+cFilAnt),_cNotas)

            // SZA está posicionado, entðo flaga o envio pendente
            if sza->(fieldpos("ZA_XENVPEN")>0.and.reclock(alias(),.f.))
                sza->za_xenvpen:="S"
                sza->(msunlock())
            endif

            // Comunica aos responsáveis

            _cServ:=GetMV("MV_RELSERV")
            _cContLog  :=GetMv("MV_RELACNT")
            _cSenha    :=GetMv("MV_RELPSW")

            _cFrom:=_cContLog
            _cCCopiaP:=''
            _cDestina:=_cEmailDest

            //_cDestina:="pedrosojr@hotmail.com,ricardo@abadore.com"

            _cBody:='Boa tarde, seguem as notas fiscais cuja recepçðo do canhoto encontra-se pendente:<br><br>'+Strtran(_cNotas,chr(13)+chr(10),'<br>')
		/* Omitir o envio por aqui, executar via job
		_lMandouOk:=u_fSendMail(_cFrom,_cDestina,_cCCopiaP,_cBCC:="pedrosojr@hotmail.com",_cAssunto,_cBody,_cAttach:='',;
		_cMensOk:="",;
		_cMensErro:="Falha ao enviar o comunicado ao responsável: Erro de conexao com o servidor SMTP",;
		_cServ,_cContLog,_cSenha,_lRemAttach:=.t.)
		*/

            _lReturn:=.f.
        endif
    endif

    _lReturn:=.t.
Return _lReturn

    *----------------------------------------------------------------------------------------------
user function fSc5Da4()
    * Cadastra motoristas via pedido de vendas
    * Ricardo Luiz da Rocha - 29/09/2019 GNSJC
    *----------------------------------------------------------------------------------------------
    local _lReturn:=.t.,_cReadVar:=readvar()
    da4->(dbsetorder(3)) // A4_FILIAL+A4_CGC
    if !empty(m->c5_xcgcmot)
        if da4->(dbseek(xfilial()+m->c5_xcgcMot,.f.))
            _lReturn:=.t.
            m->c5_xmotori:=da4->da4_cod
        else
            if !empty(m->c5_xnomemo)
                da4->(dbsetorder(1))
                reclock("DA4",.t.)
                da4->da4_filial:=xfilial('DA4')
                da4->da4_cod:=GetSxeNum("DA4","DA4_COD")
                da4->da4_nreduz:=da4->da4_nome:=m->c5_xnomemo
                da4->da4_cgc:=m->c5_xcgcmot
                da4->(msunlock())
                da4->(confirmsx8())
                m->c5_xmotori:=da4->da4_cod
                _lReturn:=.t.
            endif
        endif
    endif
    if empty(m->c5_xcgcmot).and.!empty(m->c5_xnomemo)
        alert("Para cadastrar o motorista, nome e CPF deverão ser informados")
        _lReturn:=.t.
    endif

Return _lReturn

/*
*------------------------------------------------------------------------------------
user function LeBjMro()
* Ricardo Luiz da Rocha 07/07/2010 GNSJC
*------------------------------------------------------------------------------------
local _cDir:="c:\",_cEscopo:="peso.txt",_nPeso:=_nVez:=0

    if funname()=='PDFATA11'
_vDir:=directory(_cDir+_cEscopo)
// Colhe o nome do arquivo mais recente

asort(_vDir,,,{|_vAux1,_vAux2|dtos(_vAux1[3])+_vAux1[4]>=dtos(_vAux2[3])+_vAux2[4]})

_vPeso:={}
cursorwait()
        do while len(_vDir)>0.and._nVez<50 // quantidade de leituras a fazer para obter a leitura mais frequente
_cPeso:=memoread(_cDir+_vDir[1][1])
_cPeso:=strtran(_cPeso,chr(13),'')
_cPeso:=strtran(_cPeso,chr(10),'')
_cPeso:=right(_cPeso,6)
            if len(_vPeso)<2000
aadd(_vPeso,_cPeso)
            endif
_nVez++
        enddo
_nPeso:=0
        if len(_vPeso)>0
_vPeso2:={}
// classifica por peso lido
asort(_vPeso)
_nOcor:=0
_cPeso:=_vPeso[1]
            for _nVez:=1 to len(_vPeso)
_nOcor++
                if _vPeso[_nVez]<>_cPeso.or._nVez==len(_vPeso)
aadd(_vPeso2,strzero(_nOcor,6)+_cPeso)
_nOcor:=0
                endif
            next
asort(_vPeso2)
_nPeso:=val(substr(_vPeso2[len(_vPeso2)],7))
        endif
cursorarrow()
    else
setkey(123,{||nil})
    endif

_nPBruto:=round(_nPeso/1000,2)
_oPBruto:Refresh()
u_fVldPBruto()
// Eliminado, abortando quando o arquivo estava indisponível //ferase("c:\peso.txt")
return .t.
*/
    *-----------------------------------------------------------------------------
Static Function VALIDPERG(_cPergD)
    *-----------------------------------------------------------------------------
    _cPergD    := PADR(_cPergD,len(sx1->x1_grupo))
    aRegs := {}
    *   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
    *+---------------------------------------------------------------------------------------------------------------------------------+
    *¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
    *¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
    *¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
    *¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
    *¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
    AADD(aRegs,{_cPergD,"01","Emissao de         :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
    AADD(aRegs,{_cPergD,"02","Emissao ate        :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
    AADD(aRegs,{_cPergD,"03","Situacao           :","mv_ch3","N",01,0,0,"C","","mv_par03","Aguard carregamento" ,"","","Aguard faturamento"   ,"","","Faturadas","","","Todas","","","","",""})

    u__fAtuSx1(padr(_cPergD,len(sx1->x1_grupo)),aRegs)