#INCLUDE "Protheus.ch"
#INCLUDE "SCROLLBX.CH"
#include "JPEG.CH"

//Consulta Customizada do Cadastro de Peso e Dimensões para Caminhões

Static _nXCONRet := ""

User Function BRI145CON()

	local _nP,_nA,_nV
	Local _oPanel
	Local _wAreaATU		:= GetArea()
	Local _cTitulo		:= 'Tipo Veiculo'
	Local _nVeicsPL		:= 4	//Quantidade de veiculos por linha

	Local _nLinhas
	Local _nVeic		:= 1

	//Variaveis de posicionamento
	Local _nTop			:= 2
	Local _nLeft		:= 2
	// Local nBottom
	Local _nRight		:= 0
	Local _nLine		:= 0
	// Local _nLineSize

	//Variaveis de imagem
	Local _lRep			:= .F.								//Define se as imagens serão buscadas do Repositorio(.T.) ou pasta(.F)
	Local _cLocImgs		:= "\Imagens\TipoVeiculo\"			//Caso use imagens por pasta, elas devem estar dentro da pasta definida nesse parametro.
	Local _cExtensao	:= ".JPG"							//Extensão das imagens

	Private _oDlg
	Private _aVeics	:= {}

	_nXCONRet := ''

	//Busca os tipos de veiculo de acordo com os parametros

	ZF5->(DbGoTop())

	While ZF5->(!EOF())

		_nPosAux := aScan(_aVeics,{|x| ZF5->ZF5_CODIGO == x[1]})

		if _nPosAux == 0
			AAdd(_aVeics,{ZF5->ZF5_CODIGO,;		// 1 - Código
			ZF5->ZF5_VEICUL,;					// 2 - Descrição
			ZF5->ZF5_BITMAP})					// 3 - Imagem
		endif
		ZF5->(DbSkip())
	EndDo

	//Tabela está zerada
	If Len(_aVeics) == 0
		Alert("Não há tipos de veiculos cadastrados, favor cadastre-os!!")
		Return .F.
	endif

	//Cria o Dialog e Painel para receber os tipos de veiculo
	_oDlg 	:= TDialog():New(0,0,550,1210,_cTitulo,,,,,,,,,.T.)
	_oPanel	:= TScrollBox():New(_oDlg,1,1,274,604,.T.,.F.,.T.)
	//Divide a area inicial em 4 partes para captura dos tamanhos
	_aAreaTotal1 	:= {0,0,604,274,2,2}
	_nDivisoes1		:= 4
	_aProp1			:= {{0,25},{0,25},{0,25},{0,25}}
	_oArea1 		:= redimensiona():New(_aAreaTotal1,_nDivisoes1,_aProp1,.F.)
	_aArea1			:= _oArea1:RetArea()
	//
	_nLinhas 	:= LEN(_aVeics)/_nVeicsPL 		//Define o numero de linhas
	_nLine		:= _aArea1[1,3] - _aArea1[1,1] 	//Define o tamanho da linha
	_nLeft 		:= _aArea1[1,2]
	_nRight		:= _aArea1[1,4] - 10
	//
	for _nV := 1 to _nLinhas
		if _nV > 1
			_nTop += _nLine
		endif

		_aAreaTotalV 	:= {_nLeft,_nTop,_nRight,_nTop+_nLine,5,1}
		_nDivisoesV		:= _nVeicsPL
		_aPropV			:= {}
		for _nP := 1 to _nVeicsPL
			AAdd(_aPropV,{100,0})
		next _nP
		_oAreaV 			:= redimensiona():New(_aAreaTotalV,_nDivisoesV,_aPropV,.T.)
		_aAreaV			:= _oAreaV:RetArea()

		for _nA := 1 to _nVeicsPL
			_aAreaTotalO 	:= {_aAreaV[_nA,2],_aAreaV[_nA,1],_aAreaV[_nA,4],_aAreaV[_nA,3],0,1}
			_nDivisoesO		:= 2
			_aPropO			:= {{0,80},{0,20}}
			_oAreaO 		:= redimensiona():New(_aAreaTotalO,_nDivisoesO,_aPropO,.F.)
			_aAreaO			:= _oAreaO:RetArea()

			if _nVeic <= LEN(_aVeics)
				//_bBitmap := "{|| IF(MsgYesNo('Deseja selecionar o tipo de veiculo:'+CHR(10)+CHR(13)+ "
				//_bBitmap += "_aVeics["+cValToChar(_nVeic)+",1] + ' - ' + _aVeics["+cValToChar(_nVeic)+",2],'Atenção'), "
				//_bBitmap += "(_nXCONRet := _aVeics["+cValtoChar(_nVeic)+",1], _oDlg:End()),)}"
				//_bBitmap := "{|| Alert('Clique no caminhão [' + _aVeics["+cValToChar(_nVeic)+",1] + ']') }"
				_bBitmap := "{|| BRI145SEL("+cValToChar(_nVeic)+") }"
				if _lRep // Usa imagem por repositorio
					TBitmap():New(_aAreaO[1,1],_aAreaO[1,2],_aAreaO[1,4]-_aAreaO[1,2],_aAreaO[1,3]-_aAreaO[1,1],_aVeics[_nVeic,3],,;
						.T.,_oPanel,&(_bBitmap),,.F.,.F.,,,,{||},.T.)

				else
					TBitmap():New(_aAreaO[1,1],_aAreaO[1,2],_aAreaO[1,4]-_aAreaO[1,2],_aAreaO[1,3]-_aAreaO[1,1],_aVeics[_nVeic,3],;
						_cLocImgs+Alltrim(_aVeics[_nVeic,3])+_cExtensao,.F.,_oPanel,&(_bBitmap),,.F.,.F.,,,,{||},.T.)
				endif
				bSay := "{|| _aVeics["+cValToChar(_nVeic)+",1] + ' - ' + _aVeics["+cValToChar(_nVeic)+",2] }"
				TSay():New(_aAreaO[2,1],_aAreaO[2,2],&(bSay),_oPanel,"@!",/*oFont*/,,,,.T.,/*nClrText*/,,;
					_aAreaO[2,4]-_aAreaO[2,2],_aAreaO[2,3]-_aAreaO[2,1])
				_nVeic += 1
			endif
		next _nA

		_nTop  += 2
	next _nV

	_oDlg:Activate(,,,.T.)

	restArea(_wAreaATU)

Return .T.



Static function BRI145SEL(p_nPos)

	Local __nPos := p_nPos

	If MsgYesNo('Deseja selecionar o tipo de veiculo: '+CHR(10)+CHR(13)+_aVeics[__nPos,1]+' - '+_aVeics[__nPos,2],'Atenção')
		_nXCONRet := _aVeics[__nPos,1]
		_oDlg:End()
	endif

Return



User Function BRI145RET()

Return(_nXCONRet)



User Function BRI145CAD()

	Local _cVldAlt := ".T." // Operacao: ALTERACAO
	Local _cVldExc := ".T." // Operacao: EXCLUSAO

	ZF5->(dbSetOrder(1))

	AxCadastro("ZF5","Cadastro de Veículos (Peso)", _cVldExc, _cVldAlt)
	// AxCadastro("ZF5","Cadastro de Veículos (Peso)", _cVldExc, _cVldAlt,,{||VldCad()})

Return(Nil)



Static Function VldCad()

	Local _lRet := .T.

	lUser := u_ChkAcesso("BRI092MJ",6,.F.)

Return(_lRet)