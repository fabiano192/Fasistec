#include "rwmake.ch"
*---------------------------------------------------------------------------------
User function Mta410

	local _nVez,_vAmbAtu:=getarea(),_cAlias:=alias(),_lReturn:=.t.
	LOCAL _nVol:=0, _nPBruto:=0, _nPLiq:=0

	_cPermite:=posicione("SA1",1,xfilial("SA1")+m->c5_cliente+m->c5_lojacli,"a1_pdpermf")

	If _cPermite=='N'
		for _nVez:=1 to len(acols)
			if u__fValAcols(_nVez,"C6_VLRFRET")>0.and.!acols[_nVez][len(acols[1])]
				msgbox("Pedidos para este cliente nao podem conter frete")
				_lReturn:=.f.
				return _lReturn
			endif
		next
	endif

	_cTranSz1:=posicione("SZ1",1,xfilial("SZ1")+m->c5_placa,"left(z1_codtran,6)")

	//Private _nPPEDCLI := AScan( aHeader, { |x| Alltrim(x[2])== "C6_YPEDCLI" } )
	Private _nPLINCLI := AScan( aHeader, { |x| Alltrim(x[2])== "C6_YLINCLI" } )

	If !empty(m->c5_transp).and.;
	_cTranSz1<>m->c5_transp.and.;
	!msgyesno("A placa e a transportadora nao conferem, confirma ?")
		return .f.
	Endif

	For _nVez:=1 to len(aCols)

		_cFim := (Len(aHeader)+1)
		If !aCols[_nVez,_cFim]

			If cEmpAnt $ "11/31" .or. cEmpAnt $ "14/34"	.or. cEmpAnt $ "04/50"		//Incluso as empresas 31/34 - Alison // Incluso a empresa 04/50 - Bruno
				If M->C5_CLIENTE $ GETMV("BRI_CLIVAL")
					_cPedCli := M->C5_YPEDCLI
					_cLinCli := aCols[_nVez,_nPLINCLI]

					If Empty(_cPedCli) .Or. Empty(_cLinCli)
						MSGINFO("Cliente Companhia Vale do Rio Doce, Favor Informar o Numero Pedido Cliente e a Linha do Produto!!")
						Return(.F.)
					Endif
				Endif
			Endif
		Endif
		// INCLUIDO POR ALEXANDRO EM 05/11/12


		If u__fValAcols(_nVez,"C6_YBLQPRC")=="S"
			//Gera Processo de Liberação do Pedido
			U_BRI114(_nVez)
		Endif



		If u__fValAcols(_nVez,"c6_pdgeroc")=="S"
			sza->(reclock(alias(),.t.))

			sza->ZA_FILIAL :=xfilial("SZA")
			sza->ZA_NUM    :=GetSxeNum("SZA","ZA_NUM")
			sza->ZA_NUMPV  :=m->c5_num
			sza->ZA_ITEMPV :=u__fValAcols(_nVez,"C6_ITEM")
			sza->ZA_EMISSAO:=ddatabase
			sza->ZA_CLIENTE:=m->c5_cliente
			sza->ZA_LOJACLI:=m->c5_lojacli
			sza->ZA_LOJAENT:=m->c5_lojaent
			sza->ZA_NOMCLI :=posicione("SA1",1,xfilial("SA1")+m->(c5_cliente+c5_lojacli),"A1_NOME")
			sza->ZA_PLACA  :=m->c5_placa
			sza->ZA_PDTPVEI:=m->c5_pdtpvei
			sza->ZA_CODEE  :=m->c5_codee
			sza->ZA_DESCEE :=m->c5_descee
			sza->ZA_PDBAIE :=m->C5_PDBAIE
			sza->ZA_PDMUNE :=m->c5_PDMUNE
			sza->ZA_PDDIST :=m->c5_PDDIST
			sza->ZA_PDCEPE :=m->c5_PDCEPE
			sza->ZA_TPFRETE:=m->c5_TPFRETE
			sza->ZA_PRODUTO:=u__fValAcols(_nVez,"C6_produto")
			sza->za_tara:=m->c5_tara
			sza->ZA_UM     :=u__fValAcols(_nVez,"C6_um")
			sza->ZA_VLRFRET:=u__fValAcols(_nVez,"C6_VLRFRET")
			sza->ZA_TRANSP :=m->c5_transp
			sza->ZA_VEND1 :=m->c5_vend1
			If SZA->(FieldPos("ZA_HORA01")) > 0
				SZA->ZA_HORA01	:= Time()
			Endif
			sza->(msunlock())
			sza->(ConfirmSx8())
		Endif

		If u__fValAcols(_nVez,"C6_QTDLIB")   <> 0 .AND. ;
		.NOT. ("0SERV"$UPPER(u__fValACols(_nVez,"C6_PRODUTO")))
			_nVol += u__fValAcols(_nVez,"C6_QTDLIB")
			_nPLiq += u__fVAlAcols(_nVez,"C6_QTDLIB")
			_nPBruto += u__fVAlAcols(_nVez,"C6_QLBRUT")
		endif
	next

	dbselectarea(_cAlias)
	Restarea(_vAmbAtu)

	IF _nPliq <> 0
		M->C5_VOLUME1:=_nVol
		M->C5_PBRUTO:=_nPBruto
		M->C5_PESOL:=_nPLiq
	ENDIF

	u_GATFAT02()

	if sm0->m0_codigo='04'
		// Quando MSP, apagar a quantidade liquida a liberar (peso)
		_nPosic:=ascan(aHeader,{|_vLinha|alltrim(_vLinha[2])=='C6_QLLIQ'})
		for _nVez:=1 to len(acols)
			aCols[_nVez,_nPosic]:=0
		next
	endif

Return _lReturn