#include 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE "APPEXCEL.CH"

/*/{Protheus.doc} CR0112
//Workflow de Avaliação de Ferramental
@author Fabiano
@since 22/10/2018
@version 1.0
@return ${return}, ${return_description}
@param _aParam, , descricao
@type function
/*/
User Function CR0112(_aParam)

	Local _cQry		:= ''
	Local _nTotReg	:= 0
	Local _nLin		:= 5
	Local _cDest	:= 'D:\ERP\Totvs12\protheus_data\Workflow\Relatorios\'
	Local _cName	:= ''
	Local _cAnexo	:= ''
	Local _lJob		:= .F.

	Private _oExcel	:= Nil

	If ValType(_aParam) <> 'U'
		PREPARE ENVIRONMENT EMPRESA _aParam[1] FILIAL _aParam[2]
		_lJob := .T.
	Endif

	_cName	:= 'Ferramental_'+dtos(dDataBase)+'_'+StrTran(Time(),':','')+'.xls'
	_cAnexo	:= '\Workflow\Relatorios\' + _cName

	If Select("TSZL") > 0
		TSZL->(dbClseArea())
	Endif

	BeginSql Alias 'TSZL'

		Column ZL_DATA as Date

		SELECT
		SZL.ZL_MOLDE,
		SZL.ZL_VDUTIL,
		SZL.ZL_QTPRENS,
		SZL.ZL_DIF,
		SZL.ZL_DATA
		FROM
		%Table:SZL% SZL
		WHERE
		SZL.ZL_FILIAL= %xFilial:SZL% AND
		SZL.%NotDel% AND
		SZL.ZL_DIF < 0
		ORDER BY
		%Order:SZL,1%
	EndSql

	_nTotReg := Contar("TSZL","!Eof()")

	If _nTotReg > 0

		TSZL->(dbGotop())

		_oExcel := AppExcel():New('Ferramental',_cDest)

		//Configuração das fontes

		_oFont10 := AppExcFont():New("Arial","10","#363636")

		_oFont10Np := AppExcFont():New("Arial","10","#363636")
		_oFont10Np:SetBold(.T.)

		_oFont14Np := AppExcFont():New("Arial","14","#363636")
		_oFont14Np:SetBold(.T.)

		_oForm10A	:= AppExcCell():New()
		_oForm10B	:= AppExcCell():New()
		_oForm10C	:= AppExcCell():New()
		_oForm14A	:= AppExcCell():New()

		Fontes()

		LoadHeader()

		While !TSZL->(EOF())

			_oExcel:AddCell(_nLin,1,""				,_oForm10B)
			_oExcel:AddCell(_nLin,2,TSZL->ZL_MOLDE	,_oForm10B)
			_oExcel:AddCell(_nLin,3,""				,_oForm10B)
			_oExcel:AddCell(_nLin,4,""				,_oForm10B)
			_oExcel:AddCell(_nLin,5,""				,_oForm10B)
			_oExcel:AddCell(_nLin,6,""				,_oForm10B)
			_oExcel:AddCell(_nLin,7,""				,_oForm10B)

			_nLin ++

			TSZL->(dbskip())
		EndDo

		_oExcel:SetDestPath(_cDest)
		_oExcel:SetFileName(_cName)
		_oExcel:Make(_lJob)

		If !_lJob
			_oExcel:OpenXML()
		Endif

		CR112MAIL(_cAnexo)

	Endif

	TSZL->(dbCloseArea())

Return(Nil)



Static Function Fontes()

	_oForm14A:SetHorzAlign( HORIZONTAL_ALIGN_CENTER )
	_oForm14A:SetVertAlign( VERTICAL_ALIGN_CENTER )
	_oForm14A:SetABorders(.F.,,BORDER_LINE_DOUBLE)
	_oForm14A:SetFont( _oFont14Np )

	_oForm10A:SetHorzAlign( HORIZONTAL_ALIGN_CENTER )
	_oForm10A:SetVertAlign( VERTICAL_ALIGN_CENTER )
	_oForm10A:SetABorders(.T.,,BORDER_LINE_DOUBLE)
	_oForm10A:SetFont( _oFont10Np )
	_oForm10A:SetCellColor("#D9E1F2")

	_oForm10B:SetHorzAlign( HORIZONTAL_ALIGN_CENTER )
	_oForm10B:SetVertAlign( VERTICAL_ALIGN_CENTER )
	_oForm10B:SetABorders(.T.,,BORDER_LINE_DOUBLE)
	_oForm10B:SetFont( _oFont10 )

	_oForm10C:SetHorzAlign( HORIZONTAL_ALIGN_CENTER )
	_oForm10C:SetVertAlign( VERTICAL_ALIGN_CENTER )
	_oForm10C:SetABorders(.T.,,BORDER_LINE_DOUBLE)
	_oForm10C:SetFont( _oFont10Np )

Return(Nil)



Static Function LoadHeader()

	_oExcel:Merge( 1, 1, 6, 0,'AVALIAÇÃO DE FERRAMENTAL',_oForm14A)

	_oExcel:Merge( 3, 1, 1, 0,'',_oForm10C)
	_oExcel:Merge( 3, 3, 2, 0,'VERIFICAÇÃO OK (S) - NÃO OK (N)',_oForm10A)
	_oExcel:Merge( 3, 6, 1, 0,'',_oForm10C)

	_oExcel:AddCell(4,1,"DATA"			,_oForm10C)
	_oExcel:AddCell(4,2,"MOLDE"			,_oForm10C)
	_oExcel:AddCell(4,3,"JATEAR"		,_oForm10C)
	_oExcel:AddCell(4,4,"PINOS"			,_oForm10C)
	_oExcel:AddCell(4,5,"FECHAMENTO"	,_oForm10C)
	_oExcel:AddCell(4,6,"OBSERVAÇÃO"	,_oForm10C)
	_oExcel:AddCell(4,7,"RESPONSÁVEL"	,_oForm10C)

	_oExcel:SetHorzFrozen(4)

Return(Nil)



Static Function CR112MAIL(_cAnexo)

	Local _oProcess := Nil

	CONOUT("Enviando E-Mail Ferramental")

	CONOUT('{'+ _cAnexo+'}')

	_oProcess := TWFProcess():New( "Ferramental", "Ferramental" )

	_oProcess:NewTask( "Ferramental", "\WORKFLOW\CR0112.HTM" )
	_oProcess:bReturn  := ""
	_oProcess:bTimeOut := ""
	_oHTML := _oProcess:oHTML

	_oProcess:cSubject := "Ferramental - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	_oProcess:fDesc := "Ferramental"

	Private _cTo := _cCC := ""

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'T1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'T2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

	_oProcess:AttachFile(_cAnexo)

	_oProcess:cTo := _cTo
	_oProcess:cCC := _cCC

	_oProcess:Start()

	_oProcess:Finish()

Return(Nil)
