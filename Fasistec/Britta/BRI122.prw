#INCLUDE "TOTVS.CH"
#INCLUDE "SIGAWIN.CH"
#INCLUDE "JPEG.CH"

/*/{Protheus.doc} BRI122
//Fonte para gravação do controle de Visitantes
@author Fabiano
@since 06/03/2019
@version 1.0
/*/
User Function BRI122( cRotina, bBlock, nOper, aAuto, nOpc )

	Local aSavARot := If(Type("aRotina")!="U",aRotina,{})
	Local cSavcCad := If(Type("cCadastro")!="U",cCadastro,"")
	Local nSavN    := If(Type("N")!="U",N,Nil)
	Local nScan    := 0                
	Local cFiltra					//	Variavel para filtro
	Local aIndex		:= {}	 	//	Variavel para filtro

	Private lVisitante	:= .F.
	Private aRotAuto    := aClone(aAuto)
	Private aAcho		 := {}

	Begin Sequence

		SetRepName("IMGVIST")    

		Private cMemoHist  	:= ''	

		Default nOper  		:= 0 

		Private aAlter

		Private aRotina :=  MenuDef() // ajuste para versao 9.12 - chamada da funcao MenuDef() que contem aRotina

		//³ Define o cabecalho da tela de atualizacoes                   ³
		Private cCadastro := OemToAnsi( "Cadastro de Visitantes" )  //
		Private bFiltraBrw 	:= {|| Nil}				//Variavel para Filtro	

		//³ Inicializa o filtro utilizando a funcao FilBrowse                      ³
		cFiltra 	:= CHKRH("BRI122","ZPW","1")
		bFiltraBrw 	:= {|| FilBrowse("ZPW",@aIndex,@cFiltra) }
		Eval(bFiltraBrw)

		If ValType( cRotina ) == "C"
			//³ Faz tratamento para chamada por outra rotina             ³
			If !Empty( nScan := AScan( aRotina, { |x| Upper( x[2] ) == Upper( cRotina ) .And. x[4] == nOper } ) ) 
				cRoda := cRotina + "( 'ZPW', ZPW->( Recno() ), " + Str(nScan,2) + " )" 
				xRet  := Eval( { || &( cRoda ) } ) 
			EndIf 
		Else  

			//³ Endereca a funcao de BROWSE                                  ³
			dbSelectArea( "ZPW" )
			dbGoTop()

			mBrowse( 6, 1,22,75,"ZPW") 

			//³ Deleta o filtro utilizando a funcao FilBrowse                     	   ³
			EndFilBrw("ZPW",aIndex)

		Endif

		//³Restaura os dados de entrada para Chamada por SXB             ³
		aRotina   := aSavARot
		cCadastro := cSavcCad                    

		If ValType( nSavN ) == "N"
			N := nSavN 
		EndIf 	

	End Sequence

	//³ Libera Locks						                         ³

	If lVisitante
		FreeLocks( 'ZPW', Nil, .T. ) 
	Endif

	RetPadEpoch()
	FechaReposit()
	SetRepName("SIGAADV")

Return



//Rotina para Manutencao de Visitantes
User Function BR122Rot(cAlias,nReg,nOpc)

	Local aBotoes     	:= {}
	Local aAcessos		:= {}
	Local aAdvSize		:= {} 
	Local aInfoAdvSize	:= {}
	Local aObjSize		:= {}
	Local aObjCoords	:= {}
	Local aZPWHeader	:= {}
	Local aZPWCols		:= {}
	Local aZPWFields	:= {}
	Local aZPWAltera	:= {}
	Local aZPWNaoAlt	:= {}
	Local aZPWVirtEn	:= {}
	Local aZPWNotFields	:= {}
	Local aZPWRecnos	:= {}
	Local aZPWVisuEn	:= {}
	Local aZPWMemoEn	:= {}

	Local aSvKeys		:= GetKeys()
	Local aSYPRecnos	:= {}

	Local bSet15		:= { || NIL }
	Local bSet24		:= { || NIL }

	Local cCadastro 	:= OemToAnsi( "Cadastro de Visitantes" )  //"Cadastro de Visitantes"
	Local cZPWKeySeek	:= ""
	Local cFilZPW		:= ""
	Local cVisZPW		:= ""
	Local lLocks		:= .F.
	Local nOpcAlt		:= 0.00
	Local nZPWUsado		:= 0.00
	Local nLoop			:= 0.00
	Local nLoops		:= 0.00
	Local oDlg			:= NIL
	Local oEnchoice		:= NIL	                                  
	Local bGrava
	Local _cCPF			:= ""

	Private aFotos		:= {}		//Variavel para Fotos Capturadas
	Private lGravouFoto	:= .F.		//Variavel Se Gravou a Foto
	Private bGetFoto	:= {|| lGravouFoto:= BR122GetFoto(Alltrim(cEmpAnt+xFilial("ZPW")+M->ZPW_VISITA), @aFotos, @oEnchoice),SetKey( VK_F4,bGetFoto) }

	Private nOpx		:= nOpc
	Private nRegx		:= nReg
	Private nSaveSX8   	:= GetSX8Len() 

	Begin Sequence

//		³ Quando For Inclusao Posiciona o ZPW No Final do Arquivo	
		IF ( nOpc == 3  ) //Inclusao
//			³ Garante que na Inclusao o Ponteiro do ZPW estara em Eof()
			PutFileInEof( "ZPW" , @nReg )  
		Endif

		//		³ Monta os Dados para a Enchoice
		aZPWNotFields	:= { "ZPW_FILIAL"}

		aZPWCols		:= ZPW->(GdMontaCols(@aZPWHeader,@nZPWUsado,@aZPWVirtEn,@aZPWVisuEn,NIL,aZPWNotFields,@aZPWRecnos, NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,.F.))
		cFilZPW			:= ZPW->ZPW_FILIAL
		cVisZPW			:= ZPW->ZPW_VISITA

//		³ Cria as Variaveis de Memoria e Carrega os Dados Conforme o arquivo
		For nLoop := 1 To nZPWUsado
			aAdd( aZPWFields , aZPWHeader[ nLoop , 02 ] )
			Private &( "M->"+aZPWHeader[ nLoop , 02 ] ) := aZPWCols[ 01 , nLoop ]
		Next nLoop

		//		³Define os Campos Editaveis na Enchoice.
		IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )


//			³ Define os Campos Editaveis
			nLoops := Len( aZPWVisuEn )

			For nLoop := 1 To nLoops
				aAdd( aZPWNaoAlt , aZPWVisuEn[ nLoop ] )
			Next nLoop

			IF ( nOpc == 4 ) 
				aAdd( aZPWNaoAlt , "ZPW_VISITA" )
			EndIF

			nLoops := Len( aZPWFields )
			For nLoop := 1 To nLoops
				IF ( aScan( aZPWNaoAlt , { |cNaoA| cNaoA == aZPWFields[ nLoop ] } ) == 0.00 )
					aAdd( aZPWAltera , aZPWFields[ nLoop ] )
				EndIF
			Next nLoop
		EndIF


//		³ Monta as Dimensoes dos Objetos
		aAdvSize		:= MsAdvSize()
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }

		aAdd( aObjCoords , { 000 , 300 , .T. , .T. } ) 

		aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )


//		³ Define o Bloco para a Tecla <CTRL-O>
		bSet15		:= { || IF(; 
		( ( nOpc == 3 ) .or. ( nOpc == 4 )) .and. ; 
		(RstEnchoVlds(),.T.) .and. ;
		Obrigatorio( oEnchoice:aGets , oEnchoice:aTela ) 	.and.;	//Verifica os Campos Obrigatoris na Enchoice
		U_BR122EncTOk(@_cCPF,Nil, Nil, oEnchoice)					.and.; 
		EnchoTudOk( oEnchoice )				 				.and.;	//Valida Todos os Campos da Enchoice
		BR122Homonimo(_cCPF)										; 
		,;
		(;
		nOpcAlt := 1.00 ,;
		oDlg:End();
		),;
		IF(; 
		( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) ,;				//Inclusao ou Visualizacao
		(;
		nOpcAlt := 0.00 ,;
		.F.;
		),;	
		(;
		nOpcAlt := IF( nOpc == 2 , 0 , 1.00 ) ,;		//Visualizacao ou Exclusao
		oDlg:End();
		);
		);
		);
		}

		//		 Define o Bloco para a Teclas <CTRL-X>
		bSet24		:= { || ( nOpcAlt := 0.00 , oDlg:End() ) }


//		³ Define o Bloco de Definicao de Botoes
		If ( nOpc == 3 ) .or. ( nOpc == 4 )

			aAdd(; 
			aBotoes	,;
			{;
			"MAQFOTO"			 ,;	
			bGetFoto 			 ,;
			OemToAnsi( "Obtem Foto <F4>..." ) ,;	//"Obtem Foto <F4>..."
			OemToAnsi( "Foto (F4)" ) ;	//"Foto"
			};
			)	    

			SetKEY(VK_F4,bGetFoto)
		Endif	   

//		³ Monta o Dialogo Principal para a Manutencao
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Cadastro de Visitantes" ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL

//		³ Monta o Objeto Enchoice para o ZPW
		oEnchoice	:= MsmGet():New(	"ZPW"		,;
		nReg		,;
		nOpc		,;
		NIL			,;
		NIL			,;
		NIL			,;
		aZPWFields	,;
		aObjSize[1] ,;
		aZPWAltera	,;
		NIL			,;
		NIL			,;
		"U_BR122EncTOk",;
		oDlg		,;
		NIL			,;
		.F.			 ;
		)
		oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 ,, aBotoes ) CENTERED	

		//Restaura as Teclas de Atalho
		RestKeys( aSvKeys, .T.  )

//		³Quando Confirmada a Opcao e Nao for Visualizacao Grava ou   Exclui as Informacoes do ZPW
		IF( nOpcAlt == 1 )

//			³ Apenas se nao For Visualizacao 
			IF ( nOpc != 2 ) .OR. ( nOpc != 5 )

//				³ Gravando/Incluido ou Excluindo Informacoes
				bGrava := { ||;
				BR122Grava(		nOpc		,;	//Opcao de Acordo com aRotina
				nReg		,;	//Numero do Registro do Arquivo Pai ( ZPW )
				aZPWHeader	,;	//Campos do Arquivo Pai ( ZPW )
				aZPWVirtEn	,;	//Campos Virtuais do Arquivo Pai ( ZPW )												 
				lGravouFoto ;   //Se Capturou a Foto
				);
				}

				MsAguarde(bGrava)

			EndIF
		ElseIF ( nOpc == 3 )

			//RollBack da Numeracao Automatica
			While (GetSx8Len() > nSaveSx8)
				RollBackSx8()
			EndDo              

		EndIF

	End Sequence

	//-- Apaga BMP Foto do Diretorio
	nLoops	:=	Len(aFotos)

	For nLoop:=1 to nLoops

		IF File(aFotos[nLoop, 1])
			// Apaga o arquivo da máquina CLIENTE
			FERASE( aFotos[nLoop, 1])
		Endif

		IF File(aFotos[nLoop, 2])
			// Apaga o arquivo da máquina SERVIDOR
			FERASE( aFotos[nLoop, 2])
		Endif	

	Next nX

	//Libera os Locks             								   ³
	PonFreeLocks(Nil,Nil,.T.)
	//Libera as Chaves Exclusivas 								   ³
	FreeUsedCode()

Return( nOpcAlt )



Static Function BR122Grava(		nOpc		,;	//Opcao de Acordo com aRotina
	nReg		,;	//Numero do Registro do Arquivo Pai ( ZPW )
	aZPWHeader	,;	//Campos do Arquivo Pai ( ZPW )
	aZPWVirtEn	,;	//Campos Virtuais do Arquivo Pai ( ZPW )
	lGravouFoto  ;  //Se Capturou a Foto
	)

	Local lLock			:= .F.
	Local lRet			:= .T.
	Local nCpoMemo		:= 0.00
	Local nChoice		:= 0.00
	Local nChoices		:= 0.00

	Default nOpc		:= 0.00
	Default nReg		:= 0.00
	Default aZPWHeader	:= {}
	Default aZPWVirtEn	:= {}

	nChoices			:= Len(	aZPWHeader	)

//	Se for Inclusao/Alteracao ( nOpc == 3 .or. nOpc == 4 )

	IF ( nOpc == 3 .or. nOpc == 4 )
		Begin Transaction
			IF !Empty( nReg )
				ZPW->( MsGoto( nReg ) )
				lLock := RecLock( "ZPW" , .F. , .F. )
			Else
				lLock := RecLock( "ZPW" , .T. , .F. )
			EndIF 

			IF !( lLock )
				Break
			EndIF
			ZPW->ZPW_FILIAL := xFilial('ZPW')              	

			//-- Inclui a Foto no Repositorio 	
			If lGravouFoto
				//-- Atualiza identifcador do BMP  
				M->ZPW_BITMAP:=Alltrim(cEmpAnt+xFilial('ZPW')+M->ZPW_VISITA)
			Endif

			For nChoice := 1 To nChoices
				IF ( aScan( aZPWVirtEn , { |cCpo| ( cCpo == aZPWHeader[ nChoice , 02 ] ) } ) == 0.00 )

					ZPW->( &( aZPWHeader[ nChoice , 02 ] ) ) :=&( "M->"+aZPWHeader[ nChoice , 02 ] ) 
				Endif
			Next nChoice

			ZPW->( MsUnLock() )

//			³ Confirmando a Numeracao Automatica
			IF ( nOpc == 3 .and. ( __lSX8 ) )
				ConfirmSX8()
			EndIF
		End Transaction
	EndIF

Return( NIL )



//Programa de exclusao de Visitantes
User Function BR122dele(cAlias,nReg,nOpc,aAcho)

	Local nOpcA,j,lRet:=.T.,cNivant
	Local aAC       := { "Abandona","Confirma" }  //###
	Local aAux		:= {}
	Local lAchou    := .F.
	Local aArquivos := {}
	Local nElem     := 0
	Local cArquivo  := SPACE(06)
	Local cNome     := SPACE(30)
	Local nX
	Local cMsgErr 

	Local aAdvSize				:= {}
	Local aInfoAdvSize			:= {}
	Local aObjSize				:= {}
	Local aObjCoords			:= {}

	Local aPosEnch		:={}  
	Default aAcho	:={}

	//³ Monta a entrada de dados do arquivo                          ³
	Private aTELA[0][0],aGETS[0]

	Aeval(aAcho,{|x| AADD(aAux, x)}) 
	aAcho:=aClone(aAux)


	nOpcA:=0
	dbSelectArea( cAlias )
	dbSetOrder( 1 )

	//³ Verifica se existe movimentacao nos arquivos                 ³
	aArquivos:={{"SPY",1}}                                              

// Monta as Dimensoes dos Objetos         					   ³
	aAdvSize		:= MsAdvSize()
	aAdvSize[5] := (aAdvSize[5]/100)*100
	aAdvSize[6] :=  (aAdvSize[6]/100)*100
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
	aObjSize[1,2] := 5


	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL

	aPosEnch := {aObjSize[1,1] + 14, aObjSize[1,2], aObjSize[1,4]*0.46, aObjSize[1,4]*0.995}  // ocupa todo o  espaço da janela

	If len(aAcho) == 0   
		nOpcA:=EnChoice( cAlias, nReg, nOpc, aAC,"AC","Quanto à exclusäo?",,aPosEnch )  //"Quanto … exclus„o?"
	Else
		nOpcA:=EnChoice( cAlias, nReg, nOpc, aAC,"AC","Quanto à exclusäo?",aAcho,aPosEnch )  //"Quanto … exclus„o?"
	EndIf	
	nElem := Len( aArquivos )
	For nX := 1 to nElem
		dbSelectArea( "SX2" )
		dbSeek( aArquivos[nX,1] )
		cArquivo := ALLTRIM( SX2->X2_ARQUIVO )
		cNome    := ALLTRIM( SX2->X2_NOME )
		dbSelectArea( aArquivos[nX,1] )
		dbSetOrder( aArquivos[nX,2] )
		dbSeek( ZPW->ZPW_FILIAL + ZPW->ZPW_VISITA )
		If Found()
			lAchou := .T.
			Exit
		Endif
	Next 

	nOpca := 1
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 2,oDlg:End()},{|| nOpca := 1,oDlg:End()}) CENTERED

	dbSelectArea( cAlias )
	dbSetOrder( 1 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao Achou pode Deletar                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Begin Transaction

		If nOpcA == 2
			If lAchou == .F.
				dbSelectArea( cAlias )
				IF RecLock(cAlias,.F.,.T.)
					IF !( cAlias )->( FkDelete( @cMsgErr ) )
						( cAlias )->( RollBackDelTran( cMsgErr ) )
					EndIF
					( cAlias )->( MsUnlock() )
					WRITESX2(cAlias,1)
				EndIF
				dbSkip()
			Else
				HELP(" ",1,"EXISTVIS",,cArquivo+" : "+cNome,5,2)
			Endif
		EndIF
	End Transaction

Return( NIL )



//Cria uma janela contendo a legenda da mBrowse
Static Function Pnlegend()

	IF Type( "cCadastro" ) == "U"
		Private cCadastro := "Legenda"							//
	EndIF

	BrwLegenda(	OemToAnsi(cCadastro)						,;	//Titulo do Cadastro
	OemToAnsi( "Legenda" )						,;	//"
	{;
	{"ENABLE"		,OemToAnsi("Situaçäo Normal")	}	,;	//"Situa‡„o Normal"
	{"BR_VERMELHO"	,OemToAnsi("Com Restricao")	}	;	//"Com Restricao"
	};
	)

Return( .T. )



//Funcao p/ Validacao de Enchoice
User Function BR122EncTOk(_cCPF)

	Local lRet:= .T. 

	_cCPF := M->ZPW_CPF

Return(lRet)



//Funcao p/ Validar Homonimos.
Static Function BR122Homonimo(_cCPF)
	Local aArea		:= GetArea()
	Local aZPWArea	:= ZPW->(GetArea())
	Local cFilZPW	:= xFilial('ZPW')
	Local cChave	:= ''
	Local lRet		:= .T.
	Local nRecno	:= If(INCLUI,0,ZPW->(Recno()))

	//-- Verfica Homonimos
	ZPW->(DBSETORDER(RetOrdem( 'ZPW', 'ZPW_FILIAL+ZPW_CPF' )))
	cChave	:= cFilZPW + _cCPF
	If ZPW->(Dbseek(cChave))
		If ( ZPW->(Recno()) <> nRecno)   
			//Outro Visitante Com Mesmo Nome. Confirma Informacoes?"
			lRet := MsgNoYes( OemToAnsi( "Encontrado Outro Visitante Com Mesmo CPF. Confirma Informaçöes?" ) , cCadastro ) 
		Endif
	Endif

	RestArea(aZPWArea) 
	RestArea(aArea)
Return(lRet)



//Funcao p/ Captura de Foto
Static function BR122GetFoto(cIdFile, aFotos, oEnchoice)

	Local lRet		:= .F.

	Local cFileJpg	:= '' 
	Local cPathSrv	:= ''
	Local cDestFile := ''

	Local nHDImgDll	:= 0  
	Local nRet		:= 0 
	Local nx		:= 0  

	Private  cPathFile	:= ''                              

	cPathSrv	:= Upper(GetTempPath()) //Upper(GetPvProfString( GetEnvServer() , "SourcePath" , "" , GetADV97() ) )
	cFileJpg	:=	Alltrim(cIdFile)+'.BMP'
	cPathFile	:= UPPER(cPathSrv+cFileJpg)

	Begin Sequence

		nHandle := ExecInDLLOpen("imageload2.DLL")  
		If nHandle == -1
			Alert("Falha ao Carregar DLL <ImageLoad2.dll>")
			Return
		EndIf     

		// Obtem lista de cameras
		lstDisp := ""
		nRet:=ExeDLLRun2( nHandle, 1, @lstDisp) 

		// Define dimenção de captura
		cTam:= "0360|0270"
		nRet:=ExeDLLRun2( nHandle, 3, @cTam) // Largura|Altura (com 4 caracteres)

		// Altera Titulo da janela de captura
		cTitle := OemToAnsi("TOTVS - F2 Captura")
		nRet:=ExeDLLRun2( nHandle, 4, @cTitle) 

		DEFINE MSDIALOG oDlg TITLE OemToAnsi("CAPTURA IMAGEM") FROM 000, 000  TO 450, 450 COLORS 0, 16777215 PIXEL
		cComboBo1 := 1
		lstDisp := alltrim(lstDisp)+alltrim(lstDisp)
		aItems := StrTokArr(lstDisp, "|")
		@ 015, 004 MSCOMBOBOX oComboBo1 VAR cComboBo1 ITEMS aItems SIZE 131, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 005, 004 SAY oSay1 PROMPT OemToAnsi("Escolha o dispositivo") SIZE 067, 007 OF oDlg COLORS 0, 16777215 PIXEL

		DEFINE SBUTTON oSButton1 FROM 027, 018 TYPE 14 OF oDlg ENABLE ACTION {|| Captura(oComboBo1:nAt) }
		DEFINE SBUTTON oSButton2 FROM 027, 058 TYPE 02 OF oDlg ENABLE ACTION {|| lRet:=.F.,oDlg:End() }
		DEFINE SBUTTON oSButton3 FROM 027, 098 TYPE 13 OF oDlg ENABLE ACTION {|| lRet:= fDlgIncFoto(cIdFile),oDlg:End()}
		@ 057, 023 BITMAP oBitmap1 SIZE 350, 250 OF oDlg NOBORDER PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED

		If !lRet
			Break
		Endif

		For nx:= 1 to len(oEnchoice:aEntryCtrls)
			If  oEnchoice:aEntryCtrls[nx]:ClassName() == 'FWIMAGEFIELD'
				oEnchoice:aEntryCtrls[nx]:oImagem:ReLoad(cIdFile)
			Endif
		Next

		oEnchoice:Refresh()
		//-- Armazena Fotos para Posterior Eliminacao
		aadd(aFotos,{cPathFile, cDestFile } )

		//-- Verifica se Gravou em um dos Locais
		lRet:= ( File(cPathFile) .OR. File(cDestFile) )

		If !lRet
			cFileJpg	:=	Alltrim(cEmpAnt+xFilial("ZPW")+M->ZPW_VISITA)+'.BMP'
			cPathFile	:= UPPER(cPathSrv+cFileJpg)
			lRet:= File(cPathFile)
		Endif	
	End 

	ExecInDLLClose(nHandle)

Return lRet



//Funcao p/ Captura de Foto
Static Function Captura(nAt)

	// Define dispositivo
	nRet:=ExeDLLRun2( nHandle, 2, @cValToChar(nAt-1)) 

	FERASE(cPathFile)
	// Abre tela de captura e define arquivo de imagem de saida
	tmpImgPadrao := cPathFile
	nRet := ExeDLLRun2( nHandle, 5, @tmpImgPadrao )

	// A aplicaçao continuara ao fechar a janela de captura
	// agora exibimos a imagem capturada

	// Necessario para "troca de imagem"
	oBitmap1:Load(,"ok.png")
	ProcessMessages()

	// Exibe imagem capturada
	oBitmap1:Load(,cPathFile)
	ProcessMessages()

Return




//Coloca a Foto no Repositorio
//cIdFile - Identificador da Foto (M->ZPW_VISITA)
//lFile - Logico de Retorno de Sucesso da Inclusao da Foto
Static Function fDlgIncFoto(cIdFile)

	Local cDirAtu	:= ""

	Local lFile		:= .T.
	Local oDlg8
	Local oBmp

	DEFINE MSDIALOG oDlg8   FROM -1000,400 TO 1600,800  PIXEL 

	@ 000, 000 REPOSITORY oBmp SIZE 60, 73 OF oDlg8    

	lFile	:= fPutFoto(@oBmp, cIdFile )

	ACTIVATE MSDIALOG oDlg8 ON INIT (oBmp:lStretch := .T.,oDlg8:End()) 

Return lFile



//Insere  a Foto no Repositorio
//Retorno   ³ lFile - Logico representado que Incluiu a Foto
Static Function fPutFoto(oBmp,cIdFile)
	Local lFile 	:= .T. 
	Local cFileJpg	:= '' 

	cFileJpg		:=	Alltrim(cIdFile)+'.BMP'
	cPathPict   	:= Upper(GetTempPath()+cFileJpg) 

	IF !Empty( cPathPict)
		IF ( lFile	:= File( cPathPict) )
			oBmp:DeleteBmp (Alltrim(cIdFile))
			oBmp:InsertBmp(cPathPict,,.T.)
			oBmp:LoadBmp("ok.png")
			oBmp:Refresh()
			oBmp:LoadBmp(cPathPict)
			oBmp:Refresh()
		EndIF
	EndIF

	M->ZPW_BITMAP:=Alltrim(cEmpAnt+xFilial('ZPW')+M->ZPW_VISITA)

Return (.T.)



//Funcao p/ Inicializar Codigo do Visitante
Static Function BR122RVis()

	Local xRet:= ''

	xRet:=IIF(INCLUI,GetSx8Num("ZPW","ZPW_VISITA"),"")

Return (xRet)



//Funcao p/ Validar se campos existem e estao vazios
Static Function BR122ExistCpo(cCampo)
	Local lRet := .T.

	If !( Type("&cCampo") == "U" )
		lRet := Empty(&cCampo)
	EndIf

Return(lRet)



//Funcao p/ Validar conteudo dos campos
Static Function BR122ValidCpo(cCampo)

	If !( Type("&cCampo") == "U" )
		cCampo := &cCampo
	Else
		cCampo := ""
	EndIf

Return(cCampo)


//Isola opcoes de menu para que as opcoes da rotina possam ser lidas pelas bibliotecas Framework da Versao 9.12 .
Static Function MenuDef()

	Local aRotina :=     { 		{ "Pesquisar" ,"PesqBrw"		, 0 , 1, ,.F.}	,; 	//"Pesquisar"   
	{ "Visualizar","U_BR122Rot"	, 0 , 2}	,; 	//"Visualizar"
	{ "Incluir","U_BR122Rot" 	, 0 , 3}	,; 	//"Incluir"
	{ "Alterar","U_BR122Rot"	, 0 , 4}	,; 	//"Alterar"
	{ "Excluir" ,"U_BR122Dele"	, 0 , 5}	,; 	//"Excluir" 
	{ "Legenda","PnLegend"	, 0 , 5, 7 ,.F.} }	//"Legenda"

Return aRotina
