#INCLUDE 'TOTVS.CH'

/*
Programa	:	VN0001
Data		:	07/10/15
Descrição 	:	Alterar dados contábeis da tabela SD3
*/

User Function VN0001()

Local _oDlg
Local _bOk
Local _bCancel 	:= "{ || lSave:=.f. , _oDlg:End() }"

Private _cProduto 	:= SD3->D3_COD
Private _cDesc 		:= Left(POSICIONE("SB1",1,xFilial('SB1')+SD3->D3_COD,"B1_DESC"),40)
Private _cDoc 		:= SD3->D3_DOC
Private _cDConta 	:= SD3->D3_CONTA
Private _cDDesCta 	:= Left(POSICIONE("CT1",1,xFilial('CT1')+SD3->D3_CONTA,"CT1_DESC01"),40)
Private _cDItem 		:= SD3->D3_ITEMCTA
Private _cDDesIt 	:= Left(POSICIONE("CTD",1,xFilial('CTT')+SD3->D3_ITEMCTA,"CTD_DESC01"),40)
Private _cDClasse 	:= SD3->D3_CLVL
Private _cDDesCla 	:= Left(POSICIONE("CTH",1,xFilial('CTH')+SD3->D3_CLVL,"CTH_DESC01"),40)
Private _cDCC 		:= SD3->D3_CC
Private _cDDesCC 	:= Left(POSICIONE("CTT",1,xFilial('CTT')+SD3->D3_CC,"CTT_DESC01"),40)
Private _cPConta 	:= SD3->D3_CONTA
Private _cPDesCta 	:= Left(POSICIONE("CT1",1,xFilial('CT1')+SD3->D3_CONTA,"CT1_DESC01"),40)
Private _cPItem 	:= SD3->D3_ITEMCTA
Private _cPDesIt 	:= Left(POSICIONE("CTD",1,xFilial('CTT')+SD3->D3_ITEMCTA,"CTD_DESC01"),40)
Private _cPClasse 	:= SD3->D3_CLVL
Private _cPDesCla 	:= Left(POSICIONE("CTH",1,xFilial('CTH')+SD3->D3_CLVL,"CTH_DESC01"),40)
Private _cPCC 		:= SD3->D3_CC
Private _cPDesCC 	:= Left(POSICIONE("CTT",1,xFilial('CTT')+SD3->D3_CC,"CTT_DESC01"),40)
Private _lSave		:= .f.			// Variavel controla se tem ou nao que salvar.

_bOk := "{ || (_lSave:=.t.,_oDlg:End()) }"
//	_bOk := "{ || If(!Empty(_cProduto) .and. nPrecoCro > 0 .and. nDNP > 0.and. nLote > 0 .and. !Empty(dBase) .and. nTxDollar > 0 .and. !Empty(Alltrim(cPortu)) ,(_lSave:=.t.,_oDlg:End()),Alert('Existe algum campo sem preenchimento!')) }"
_nHight := 250

_lGo := .F.
SF5->(dbsetOrder(1))
IF SF5->(msSeek(xFilial('SF5')+SD3->D3_TM))
	If !SF5->F5_CODIGO $ '499|999' .And. SF5->F5_TIPO $ 'D|R'
		_lGo := .T.
	Endif
Endif

If _lGo
	
	DEFINE MSDIALOG _oDlg TITLE "Dados Contábeis" FROM 000, 000  TO _nHight,1170  PIXEL
	
	_nTLin := 18
	_nLin  := 10
	
	@ 5,5   TO 28,290 OF _oDlg PIXEL
	@ 5,290 TO 28,575 OF _oDlg PIXEL
	
	@ _nLin, 015 SAY "Produto "		 					SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 060 MSGET _cProduto 			When .F. 	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 130 MSGET _cDesc 				When .F.	SIZE 150, 010 OF _oDlg PIXEL
	
	@ _nLin, 300 SAY "Documento"	 					SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 345 MSGET _cDoc 				When .F. 	SIZE 060, 010 OF _oDlg PIXEL
	
	@ 30,5   TO 110,290 LABEL "DE" OF _oDlg PIXEL
	@ 30,290 TO 110,575 LABEL "PARA" OF _oDlg PIXEL
	
	
	_nLin += (_nTLin+10)
	@ _nLin, 015 SAY "Conta Contábil" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 060 MSGET _cDConta	 				When .F.	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 130 MSGET _cDDesCta				When .F. 	SIZE 150, 010 OF _oDlg PIXEL
	
	@ _nLin, 300 SAY "Conta Contábil" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 345 MSGET _cPConta	 	F3 "CT1" 	VALID CTA()	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 415 MSGET _cPDesCta				When .F. 	SIZE 150, 010 OF _oDlg PIXEL
	
	_nLin += _nTLin
	@ _nLin, 015 SAY "Item Contábil" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 060 MSGET _cDItem					When .F.	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 130 MSGET _cDDesIt					When .F.	SIZE 150, 010 OF _oDlg PIXEL
	
	@ _nLin, 300 SAY "Item Contábil" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 345 MSGET _cPItem		F3 "CTD"	VALID It()	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 415 MSGET _cPDesIt					When .F.	SIZE 150, 010 OF _oDlg PIXEL
	
	_nLin += _nTLin
	@ _nLin, 015 SAY "Classe Valor" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 060 MSGET _cDClasse				When .F.	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 130 MSGET _cDDesCla				When .F.	SIZE 150, 010 OF _oDlg PIXEL
	
	@ _nLin, 300 SAY "Classe Valor" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 345 MSGET _cPClasse	F3 "CTH" 	VALID CVA()	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 415 MSGET _cPDesCla				When .F.	SIZE 150, 010 OF _oDlg PIXEL
	
	_nLin += _nTLin
	@ _nLin, 015 SAY "Centro de Custo" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 060 MSGET _cDCC					When .F.	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 130 MSGET _cDDesCC					When .F.  	SIZE 150, 010 OF _oDlg PIXEL
	
	@ _nLin, 300 SAY "Centro de Custo" 						SIZE 040, 007 OF _oDlg PIXEL
	@ _nLin, 345 MSGET _cPCC		F3 "CTT"	VALID CC() 	SIZE 060, 010 OF _oDlg PIXEL
	@ _nLin, 415 MSGET _cPDesCC					When .F.  	SIZE 150, 010 OF _oDlg PIXEL
	
	ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,&(_bOk),&(_bCancel))
	
	If _lSave
		
		SD3->(RecLock("SD3",.F.))
		SD3->D3_CONTA	:= _cPConta
		SD3->D3_ITEMCTA	:= _cPItem
		SD3->D3_CLVL	:= _cPClasse
		SD3->D3_CC		:= _cPCC
		SD3->(MsUnlock())
		
	Endif
	
Else
	
	MsgAlert('Cadastro não pode ser alterado!')
	
Endif

Return

Static Function CTA()

Local _lRet := .T.

CT1->(dbSetOrder(1))
If CT1->(dbSeek(xFilial('CT1')+_cPConta))
	_cPDesCta := CT1->CT1_DESC01
	If FieldPos("CT1_MSBLQL") > 0
		If CT1->CT1_MSBLQL = '1'
			_lRet := .F.
			Alert('Conta Bloqueada!')
			_cPConta := Space(TAMSX3("CT1_CONTA")[1])
			_cPDesCta := Space(TAMSX3("CT1_DESC01")[1])
		Endif
	Endif
Else
	_cPConta 	:= Space(TAMSX3("CT1_CONTA")[1])
	_cPDesCta 	:= Space(TAMSX3("CT1_DESC01")[1])
	If !Empty(_cPConta)
		Alert('Conta não encontrada!')
		_lRet := .F.
	Endif
Endif

_lRet := Ctb105Cta()

Return (_lRet)




Static Function IT()

Local _lRet := .T.

CTD->(dbSetOrder(1))
If CTD->(dbSeek(xFilial('CTD')+_cPItem))
	_cPDesIt := CTD->CTD_DESC01
	If FieldPos("CTD_MSBLQL") > 0
		If CTD->CTD_MSBLQL = '1'
			_lRet := .F.
			Alert('Item Bloqueado!')
			_cPItem    	:= Space(TAMSX3("CTD_ITEM")[1])
			_cPDesIt 	:= Space(TAMSX3("CTD_DESC01")[1])
		Endif
	Endif
	
Else
	_cPItem 	:= Space(TAMSX3("CTD_ITEM")[1])
	_cPDesIt 	:= Space(TAMSX3("CTD_DESC01")[1])
	If !Empty(_cPItem)
		Alert('Item não encontrado!')
		_lRet 	:= .F.
	Endif
Endif

_lRet := Ctb105Item()

Return (_lRet)


Static Function CVA()

Local _lRet := .T.

CTH->(dbSetOrder(1))
If CTH->(dbSeek(xFilial('CTH')+_cPClasse))
	_cPDesCla := CTH->CTH_DESC01
	If FieldPos("CTH_MSBLQL") > 0
		If CTH->CTH_MSBLQL = '1'
			_lRet := .F.
			Alert('Classe Bloqueado!')
			_cPClasse   := Space(TAMSX3("CTH_CLVL")[1])
			_cPDesCla 	:= Space(TAMSX3("CTH_DESC01")[1])
		Endif
	Endif
	
Else
	_cPClasse   	:= Space(TAMSX3("CTH_CLVL")[1])
	_cPDesCla 	:= Space(TAMSX3("CTH_DESC01")[1])
	If !Empty(_cPClasse)
		Alert('Classe não encontrado!')
		_lRet 	:= .F.
	Endif
Endif              

_lRet := Ctb105Clvl()

Return (_lRet)



Static Function CC()

Local _lRet := .T.

CTT->(dbSetOrder(1))
If CTT->(dbSeek(xFilial('CTT')+_cPCC))
	_cPDesCC := CTT->CTT_DESC01
	If FieldPos("CTT_MSBLQL") > 0
		If CTT->CTT_MSBLQL = '1'
			_lRet := .F.
			Alert('CC Bloqueado!')
			_cPCC    := Space(TAMSX3("CTT_CUSTO")[1])
			_cPDesCC := Space(TAMSX3("CTT_DESC01")[1])
		Endif
	Endif
	
Else
	_cPCC 		:= Space(TAMSX3("CTT_CUSTO")[1])
	_cPDesCC 	:= Space(TAMSX3("CTT_DESC01")[1])
	If !Empty(_cPCC)
		Alert('CC não encontrado!')
		_lRet 		:= .F.
	Endif
Endif

_lRet := Ctb105CC()

Return (_lRet)
