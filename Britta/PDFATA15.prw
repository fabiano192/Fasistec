#include "rwmake.ch"


user function PdFatA15
    //Pesagem da tara
    //Ricardo Luiz da Rocha 06/04/2010 GNSJC

    private _oDlg,_cOC:=space(6),_cPlaca:=space(len(sza->za_placa)),;
        _cPictPeso:=pesqpict("SZA","ZA_PBRUTO")
    _nPeso:=LeTara()
    PRIVATE _nPliq:=_nPeso
    PRIVATE _nTara:= 0
    PRIVATE _nPrUnit:=0
    PRIVATe _nVlrTot:=0
    PRIVATe _nVlTot:=0
    PRIVATE bTara := ""
    public _nPBruto:=0

    bTara:="u_BALS(@_nPBruto,@_nTara,@_nPLiq,@_nPrUnit,@_nVlTot)" //Semar - Juailson 30/07/2014
    setkey(122,{|| &bTara}) // Quando tecla F11 executa a funcao
    @ 0,0 to 195,550 dialog _oDlg title "Pesagem da tara"

    @ 025,005 say "Placa do veiculo: "
    @ 025,065 get _cPlaca picture '@!R AAA-9X99' size 40,10 F3 'SZ1'
    // @ 025,065 get _cPlaca picture '@r AAA-9999' size 40,10 F3 'SZ1'

    @ 025,120 say "Peso: "
//@ 025,137 get _nPeso WHEN u_ChkAcesso("DIGITAPESO",6,.F.)  picture _cPictPeso  size 45,10
    @ 025,137 get _nPLiq WHEN u_ChkAcesso("DIGITAPESO",6,.F.)  picture _cPictPeso  size 45,10
    @ 080,100 button "F11 - Captura peso" size 50,12 action Eval({|| &bTara }) // Semar - Juailson 30/07/2014
//@ 080,100 button "Leitura" size 50,12 action _nPeso:=LeTara()
//@ 080,100 button "Leitura" size 50,12 action _nPLiq:=LeTara()
//@ 080,170 button "Imprime Ticket" size 50,12 action u_fTicket(_cPlaca,_nPeso,'Tara') object _oImpTicket
    @ 080,170 button "Imprime Ticket" size 50,12 action u_fTicket(_cPlaca,_nPLiq,'Tara') object _oImpTicket
    _oImpTicket:BWhen:={||_nPLiq>0.and.!empty(_cPlaca)}

    @ 080,240 bmpbutton type 2 action close(_oDlg)

    activate dialog _oDlg centered

Return




static function LeTara()
    //Ricardo Luiz da Rocha 06/04/2010 GNSJC

    local _cDir:="c:\",_cEscopo:="peso.txt",_nPeso:=_nVez:=0

    _vDir:=directory(_cDir+_cEscopo)
// Colhe o nome do arquivo mais recente

    asort(_vDir,,,{|_vAux1,_vAux2|dtos(_vAux1[3])+_vAux1[4]>=dtos(_vAux2[3])+_vAux2[4]})

    _vPeso:={}
    cursorwait()
    do while len(_vDir)>0.and._nVez<10 // quantidade de leituras a fazer para obter a leitura mais frequente
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

    _nPeso:=round(_nPeso/1000,2)

return _nPeso
