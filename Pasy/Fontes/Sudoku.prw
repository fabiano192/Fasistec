#INCLUDE "PROTHEUS.CH"

#DEFINE SUDOKU_ELEM		02

#DEFINE SUDOKU_OBJ		01
#DEFINE SUDOKU_VAR		02

#IFNDEF SODUKO_NO_CHANGE

	Static lIniciante		:= .F.
	Static lIntermediario	:= .F.
	Static lAvancado		:= .F.

#ENDIF

/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  ЁSudoku	  ЁAutorЁMarinaldo de Jesus       Ё Data Ё27/10/2005Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁGame Sudoku                              					Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                    Ё
цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё            ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL           Ё
цддддддддддддбддддддддддбдддддддддддбддддддддддддддддддддддддддддддддддд╢
ЁProgramador ЁData      ЁNro. Ocorr.ЁMotivo da Alteracao                Ё
цддддддддддддеддддддддддедддддддддддеддддддддддддддддддддддддддддддддддд╢
Ё            Ё          Ё           Ё                                   Ё
юддддддддддддаддддддддддадддддддддддаддддддддддддддддддддддддддддддддддды/*/
/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁU_SudokuExec  ЁAutor ЁMarinaldo de Jesus   Ё Data Ё27/10/2005Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExecutar Funcoes Dentro de Sudoku                            Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_SudokuExec( cExecIn , aFormParam )						 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁuRet                                                 	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                      	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico 													 Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function SudokuExec( cExecIn , aFormParam )
         
Local uRet

DEFAULT cExecIn		:= ""
DEFAULT aFormParam	:= {}

IF !Empty( cExecIn )
	cExecIn	:= BldcExecInFun( cExecIn , aFormParam )
	uRet	:= __ExecMacro( cExecIn )
EndIF

Return( uRet )

/*/
зддддддддддбдддддддддддбддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁU_Sudoku   ЁAutor ЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддедддддддддддаддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁSudoku                    									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_Sudoku()													Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico 	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function Sudoku()

Local aSvKeys			:= GetKeys()
Local aSudokuGrps		:= Array( 9 )
Local aSudokuElem		:= Array( 9 )

Local aSudokuGetNum

Local lNewGame
Local bDialogInit

Local oDlg
Local oFont
Local oFontNum

CursorWait()

	Begin Sequence
	
		#IFNDEF SODUKO_NO_CHANGE
	
			IF !( SudokuNivel() )
				Break
			EndIF
	
		#ENDIF
	
		aEval( aSudokuElem , { |uElem,nElem| aSudokuElem[ nElem ] := aClone( Array( 9 , SUDOKU_ELEM ) ) } )
	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁDefine o tipo de fonte a ser utilizado no Objeto Dialog	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁDefine o tipo de fonte a ser utilizado nos Ojetos MSGET	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		DEFINE FONT oFontNum NAME "Courier New" SIZE 18,30 BOLD
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁDisponibiliza Dialog para a Escolha da Empresa				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Sudoku" ) From 0,0 TO 610,610 OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL
		
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁNao permite sair ao se pressionar a tecla ESC.				   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			oDlg:lEscClose := .F.
		
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁMonta os Grupos                                 		   	   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			@ 015 , 005 GROUP aSudokuGrps[1] TO 100,100 OF oDlg PIXEL ; @ 015 , 102 GROUP aSudokuGrps[2] TO 100,200 OF oDlg PIXEL ; @ 015 , 202 GROUP aSudokuGrps[3] TO 100,300 OF oDlg PIXEL
		
			@ 100 , 005 GROUP aSudokuGrps[4] TO 200,100 OF oDlg PIXEL ; @ 100 , 102 GROUP aSudokuGrps[5] TO 200,200 OF oDlg PIXEL ; @ 100 , 202 GROUP aSudokuGrps[6] TO 200,300 OF oDlg PIXEL
		
			@ 200 , 005 GROUP aSudokuGrps[7] TO 300,100 OF oDlg PIXEL ; @ 200 , 102 GROUP aSudokuGrps[8] TO 300,200 OF oDlg PIXEL ; @ 200 , 202 GROUP aSudokuGrps[9] TO 300,300 OF oDlg PIXEL
		
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁAtribui a Fonte dos Grupos                    				   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			aEval( aSudokuGrps , { |uElem,nElem| aSudokuGrps[ nElem ]:oFont := oFont } )
		
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁMonta os Gets para o Preenchimento dos Numeros				   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			#IFNDEF SODUKO_NO_CHANGE
				aSudokuGetNum	:= BuildSudoku( oDlg , oFontNum , @aSudokuElem , lIniciante , lIntermediario , lAvancado )
			#ELSE
				aSudokuGetNum	:= BuildSudoku( oDlg , oFontNum , @aSudokuElem )
			#ENDIF	
		
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁDefine o Bloco para a Inicializacao do Dialog.				   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			bDialogInit	:= { ||;
									ExeWhile(;
												NIL						,;	//Variavel de Retorno que sera incrementada pelo bloco
												{ || Sleep(5) }			,;	//Bloco com a Expressao de Retorno
												{ || !( GlbLock() ) }	,;	//Expressao ou Bloco para Condicao While
												NIL						,;	//Expressao ou Bloco para a Condicao Skip/Loop
												NIL						,;	//Expressao ou Bloco para Exit no While
												.F.						,;	//Se deve Mostrar o Erro nos Testes das Expressoes
												.F.		 				 ;	//Se devera Verificar Erro nas Expressoes passadas
				  							),;
									PutGlbValue( "bStartSudoku" , "1" ),;
									PutGlbValue( "cSudokuTime" , "00:00:00" ),;
									GlbUnlock(),;
									SdkBtnBar( oDlg , @lNewGame , aSvKeys , @aSudokuElem , aSudokuGetNum ),;
									StartJob( "U_SudokuExec" , GetEnvServer() , .F. , "SudokuTime" , { Time() , 1 } );
							}		

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval( bDialogInit )
		RestKeys( aSvKeys )

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁVerifica se Ira Iniciar Novo Jogo             				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( lNewGame )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁDefine o Bloco de Recursao Quando Novo Jogo   				   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			bNewGame		:= { ||;
										lNewGame := .F.,;
										CursorWait(),;
										PutGlbValue( "bStartSudoku" , "0" ),;
										U_Sudoku(),;
						   	    }
			Eval( bNewGame )
		EndIF

	End Sequence

	PutGlbValue( "bStartSudoku" , "0" )

CursorArrow()

Return( NIL )

/*/
зддддддддддбдддддддддддбддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSdkBtnBar  ЁAutor ЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддедддддддддддаддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁBarra de Botoes                								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku() 	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SdkBtnBar(;
								oDlg			,;
								lNewGame		,;
								aSvKeys			,;
								aSudokuElem		,;
								aSudokuGetNum	 ;
						  )

Local bButtonNewG	:= { || IF( MsgNoYes( "Deseja Iniciar Novo Jogo?" , "New Game" ) , ( oDlg:End() , RestKeys( aSvKeys ) , lNewGame := .T. ) , lNewGame := .F. ) }
Local bButtonAllN	:= { || IF( ( !( lChkAllNum ) .and. ( lChkAllNum := MsgNoYes( "Deseja Desistir do Jogo?" , "Aviso!" ) ) ) , (  AllSudoku( @oDlg , @aSudokuElem , aSudokuGetNum ) , Eval( bButtonChkG ) ) , .F. ) }
Local bButtonParM	:= { || IF( SudokuNivel( .T. ) , Eval( bButtonNewG ) , NIL ) }
Local bButtonChkG	:= { || ChkSudoku( @oDlg , @aSudokuElem , aSudokuGetNum , lChkAllNum ) }
Local bButtonEndG	:= { || IF( MsgNoYes( "Deseja Sair do Jogo?" , "Sair" ) , ( oDlg:End() , RestKeys( aSvKeys ) ) , NIL ) }
Local bButtonHelp	:= { || SudokuHelp() }

Local cSpace		:= Space( 50 )

Local oButtonBar

Local oButtonNewG
Local oButtonAllN
Local oButtonParM
Local oButtonChkG
Local oButtonEndG
Local oButtonHelp

Local oTimer
Local oElapTime

Local lChkAllNum	:= .F.

DEFINE BUTTONBAR oButtonBar	SIZE 025,025 3D TOP OF oDlg PIXEL

DEFINE BUTTON oButtonNewG	RESOURCE "PMSCOLOR"	OF oButtonBar GROUP	ACTION Eval( bButtonNewG )		TOOLTIP OemToAnsi( "Novo Jogo...<F2>" )
oButtonNewG:cTitle		:= OemToAnsi( "Novo" )
SetKey( VK_F2 , oButtonNewG:bAction )

DEFINE BUTTON oButtonAllN	RESOURCE "DESTINOS"	OF oButtonBar GROUP	ACTION Eval( bButtonAllN )		TOOLTIP OemToAnsi( 'Preencher NЗmeros...<F3>' )
oButtonAllN:cTitle		:= OemToAnsi( "NЗmeros" )
SetKey( VK_F3 , oButtonAllN:bAction )

DEFINE BUTTON oButtonParM	RESOURCE "BMPPARAM"	OF oButtonBar GROUP	ACTION Eval( bButtonParM )		TOOLTIP OemToAnsi( 'ParБmetros...<F4>' )
oButtonParM:cTitle		:= OemToAnsi( "Config." )
SetKey( VK_F4 , oButtonParM:bAction )  

DEFINE BUTTON oButtonChkG	RESOURCE "OK"   	OF oButtonBar GROUP	ACTION Eval( bButtonChkG )		TOOLTIP OemToAnsi( 'Ok...<Ctrl-O>' )
oButtonChkG:cTitle		:= OemToAnsi( "OK" )
oDlg:bSet15 			:= oButtonChkG:bAction
SetKey( 15 , oDlg:bSet15 )

DEFINE BUTTON oButtonEndG	RESOURCE "FINAL"	OF oButtonBar GROUP	ACTION Eval( bButtonEndG )		TOOLTIP OemToAnsi( 'Sair...<Ctrl-X>' )
oButtonEndG:cTitle		:= OemToAnsi( "Sair" )
oDlg:bSet24 			:= oButtonEndG:bAction
SetKey( 24 , oDlg:bSet24 )

DEFINE BUTTON oButtonHelp	RESOURCE "S4WB016N"	OF oButtonBar GROUP ACTION Eval( bButtonHelp )		TOOLTIP OemToAnsi( 'Ajuda...<F1>' )
oButtonHelp:cTitle		:= OemToAnsi( "Ajuda" )
SetKey( VK_F1 , oButtonHelp:bAction )

@ 000,015 MSGET oElapTime VAR ( cSpace + GetGlbValue( "cSudokuTime" ) )	SIZE 200,050 OF oButtonBar PIXEL WHEN .F. CENTERED

DEFINE TIMER oTimer INTERVAL ( 1 ) ACTION ( oElapTime:Refresh() ) OF oDlg
ACTIVATE TIMER oTimer

oButtonBar:bRClicked	:= { || AllwaysTrue() }

Return( NIL )

/*/
зддддддддддбдддддддддддбддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSudokuHelp ЁAutor ЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддедддддддддддаддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁRetorna o Help do Sudoku                           			Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SudokuHelp()

Local cDirectory	:= "Games\Sudoku_Help\"

Local aAllFiles

Local nAllFile
Local nAllFiles

CursorWait()
	IF !( RmtInSrv() )
		aAllFiles	:= Array( aDir( cDirectory + "*.*" ) )
		nAllFiles	:= aDir( cDirectory + "*.*" , @aAllFiles )
		For nAllFile := 1 To nAllFiles
			CpyS2Tmp( cDirectory + aAllFiles[ nAllFile ] )
		Next nAllFile
	EndIF
	ShowFile( cDirectory+"Sudoku.htm" )
CursorArrow()

Return( NIL )

/*/
зддддддддддбдддддддддддбддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁBuildSudokuЁAutor ЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддедддддддддддаддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁMonta os Get do Sudoku para a Digitacao dos Numeros			Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function BuildSudoku( oDlg , oFont , aSudokuElem , lIniciante , lIntermediario , lAvancado )

Local aSudokuGetNum		:= SudokuNumArray()

Local bGetSet			:= { || __ExecMacro( "{ |u| IF( PCount() == 0 , aSudokuElem[ "+ AllTrim( Str(nLoop) ) + " , " + AllTrim( Str(nItem) ) + " , " + AllTrim( Str(SUDOKU_VAR) ) + " ] , aSudokuElem[ "+ AllTrim( Str(nLoop) ) + " , " + AllTrim( Str(nItem) ) + " , " + AllTrim( Str(SUDOKU_VAR) ) + " ] := u ) }" ) }
Local bGetVar			:= { || "aSudokuElem[ "+ AllTrim( Str(nLoop) ) + " , " + AllTrim( Str(nItem) ) + " , " + AllTrim( Str(SUDOKU_VAR) ) + " ]" }

Local nRow				:= 20
Local cSudokuGetNum

Local lChange

Local nCol

Local nItem
Local nIntes
Local nLoop
Local nLoops
Local nCntRow
Local nCntCol
Local nColIndex

#IFNDEF SODUKO_NO_CHANGE
	
	Local bChange

	Local nChange1
	Local nChange2
	Local nChange3
	Local nChange4
	Local nChange5
	Local nChange6
	Local nChange7
	Local nChange8
	Local nChange9

	Local nSudokuGetNum

	IF ( lIniciante )
		bChange	:= { || (;
							( nSudokuGetNum == nChange1 );
							.or.;
							( nItem == nChange1 );
							.or.;
							( nLoop == nChange1 );
						);
					}		
	ElseIF ( lIntermediario )
		bChange	:= { || (;
							( nSudokuGetNum == nChange1 );
							.or.;
							( nSudokuGetNum == nChange2 );
							.or.;
							( nSudokuGetNum == nChange3 );
							.or.;
							( nItem == nChange1 );
							.or.;
							( nItem == nChange2 );
							.or.;
							( nItem == nChange3 );
							.or.;
							( nLoop == nChange1 );
							.or.;
							( nLoop == nChange2 );
							.or.;
							( nLoop == nChange3 );
						);
					}		
	ElseIF ( lAvancado )
		bChange	:= { || (;
							( nSudokuGetNum == nChange1 );
							.or.;
							( nSudokuGetNum == nChange2 );
							.or.;
							( nSudokuGetNum == nChange3 );
							.or.;
							( nSudokuGetNum == nChange4 );
							.or.;
							( nSudokuGetNum == nChange5 );
							.or.;
							( nSudokuGetNum == nChange6 );
							.or.;
							( nSudokuGetNum == nChange7 );
							.or.;
							( nSudokuGetNum == nChange8 );
							.or.;
							( nSudokuGetNum == nChange9 );
							.or.;
							( nItem == nChange1 );
							.or.;
							( nItem == nChange2 );
							.or.;
							( nItem == nChange3 );
							.or.;
							( nItem == nChange4 );
							.or.;
							( nItem == nChange5 );
							.or.;
							( nItem == nChange6 );
							.or.;
							( nItem == nChange7 );
							.or.;
							( nItem == nChange8 );
							.or.;
							( nItem == nChange9 );
							.or.;
							( nLoop == nChange1 );
							.or.;
							( nLoop == nChange2 );
							.or.;
							( nLoop == nChange3 );
							.or.;
							( nLoop == nChange4 );
							.or.;
							( nLoop == nChange5 );
							.or.;
							( nLoop == nChange6 );
							.or.;
							( nLoop == nChange7 );
							.or.;
							( nLoop == nChange8 );
							.or.;
							( nLoop == nChange9 );
						);
					}
	EndIF					
	
#ENDIF
	
nLoops 	:= Len( aSudokuElem )
nCntRow	:= 0
For nLoop := 1 To nLoops
	nItens	:= Len( aSudokuElem[ nLoop ] )
	nCol		:= 15
	nCntCol		:= 0
	nColIndex	:= 0
	For nItem := 1 To nItens

		cSudokuGetNum	:= aSudokuGetNum[ nLoop , ++nColIndex ]

		#IFNDEF SODUKO_NO_CHANGE

			nSudokuGetNum	:= Val( cSudokuGetNum )

			nChange1		:= SudokuCoord( Aleatorio( 9 , Seconds() - 15 ) , Aleatorio( 9 , Seconds() - 12 ) , 9 )
			nChange2		:= SudokuCoord( Aleatorio( 9 , Seconds() - 19 ) , Aleatorio( 9 , Seconds() - 70 ) , 9 )
			nChange3		:= SudokuCoord( Aleatorio( 9 , Seconds() - 03 ) , Aleatorio( 9 , Seconds() - 10 ) , 9 )

			nChange4		:= SudokuCoord( Aleatorio( 9 , Seconds() - 12 ) , Aleatorio( 9 , Seconds() - 15 ) , 9 )
			nChange5		:= SudokuCoord( Aleatorio( 9 , Seconds() - 70 ) , Aleatorio( 9 , Seconds() - 19 ) , 9 )
			nChange6		:= SudokuCoord( Aleatorio( 9 , Seconds() - 10 ) , Aleatorio( 9 , Seconds() - 03 ) , 9 )

			nChange7		:= SudokuCoord( Aleatorio( 9 , Seconds() + 15 ) , Aleatorio( 9 , Seconds() + 12 ) , 9 )
			nChange8		:= SudokuCoord( Aleatorio( 9 , Seconds() + 19 ) , Aleatorio( 9 , Seconds() + 70 ) , 9 )
			nChange9		:= SudokuCoord( Aleatorio( 9 , Seconds() + 03 ) , Aleatorio( 9 , Seconds() + 10 ) , 9 )

			IF ( lChange := Eval( bChange ) )

				cSudokuGetNum	:= " "

			EndIF
		
		#ELSE
		
			lChange				:= .F.
		
		#ENDIF
		
		aSudokuElem[ nLoop , nItem , SUDOKU_VAR ] := cSudokuGetNum
		aSudokuElem[ nLoop , nItem , SUDOKU_OBJ ] := TGet():New(;
																	nRow												,;	//01 -> <nRow>
																	nCol												,;	//02 -> <nCol>
																	Eval( bGetSet )										,;	//03 -> bSETGET(<uVar>)
				 													oDlg												,;	//04 -> [<oWnd>]
				 													22													,;	//05 -> <nWidth>
				 													22													,;	//06 -> <nHeight>
				 													"9"									   				,;	//07 -> <cPict>
				 													NIL													,;	//08 -> <{ValidFunc}>
				 													IF(lChange,NIL,CLR_WHITE)							,;	//09 -> <nClrFore>
				 													IF(lChange,NIL,CLR_BLUE)							,;	//10 -> <nClrBack>
				 													oFont												,;	//11 -> <oFont>
				 													.T.													,;	//12 -> <.design.>
				 													NIL													,;	//13 -> <oCursor>
				 													.T.													,;	//14 -> <.pixel.>
				 													NIL													,;	//15 -> <cMsg>
				 													.F. 												,;	//16 -> <.update.>
				 													__ExecMacro( "{ ||" + AllToChar( lChange ) + "}" )	,;	//17 -> <{uWhen}>
				 													.T.													,;	//18 -> <.lCenter.>
				 													.F.													,;	//19 -> <.lRight.>
				 													NIL													,;	//20 -> [\{|nKey, nFlags, Self| <uChange>\}]
				 													!( lChange )										,;	//21 -> <.readonly.>
				 													.F.													,;	//22 -> <.pass.>
				 													NIL													,;	//23 -> <cF3>
				 													Eval( bGetVar )										,;	//24 -> <(uVar)>
				 													NIL													,;	//25 -> ?
				 													NIL													,;	//26 -> [<.lNoBorder.>]
				 													NIL													,;	//27 -> [<nHelpId>]
				 													NIL		 		 									 ;	//28 -> [<.lHasButton.>]
				 												)
		++nCntCol
		IF (;
				( nCntCol == 3 );
				.or.;
				( nCntCol == 6 );
			)	
			IF ( nCntCol == 3 )
				nCol	+= 40
			Else
				nCol	+= 45
			EndIF	
		Else
			nCol	+= 28
		EndIF
	Next nItem
	++nCntRow
	IF (;
			( nCntRow == 3 );
			.or.;
			( nCntRow == 6 );
		)	
		IF ( nCntRow == 3 )
			nRow	+= 40
		Else
			nRow	+= 45
		EndIF
	Else
		nRow	+= 26
	EndIF	
Next nLoop

Return( aSudokuGetNum )

/*
зддддддддддбдддддддддддбддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁSudokuNivelЁAutor Ё Marinaldo de Jesus 	  Ё Data Ё30/03/2006Ё
цддддддддддедддддддддддаддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁDialogo com as Opcoes para Definir o Nivel do Jogo			Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁNIL															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁU_Sudoku()												    Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function SudokuNivel( lButtonParam )

Local aSvKeys		:= GetKeys()

Local bSet15		:= { || RestKeys( aSvKeys , .T. ) , oDlg:End() }

Local lContinue		:= .T.

Local oRadio
Local oDlg
Local oGroup
Local oFont
Local oCheckBox

Static lNoModify

Static nOpcSudoku	:= 1

Begin Sequence

	DEFAULT lButtonParam	:= .F.

	IF (;
			!( lButtonParam );
			.and.;	
			!Empty( lNoModify );
		)	
		Break
	EndIF

	DEFAULT lNoModify	:= .T.

	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	DEFINE MSDIALOG oDlg FROM  094,001 TO 250,350 TITLE OemToAnsi( "Sudoku" ) OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL
	
		@ 015,005	GROUP oGroup TO 075,172 LABEL OemToAnsi("Escolha o NМvel do Jogo") OF oDlg PIXEL
		oGroup:oFont:=oFont
		
		@ 025,010	RADIO oRadio VAR nOpcSudoku ITEMS	OemToAnsi("Iniciante")		,;
														OemToAnsi("IntermediАrio")	,;
														OemToAnsi("AvanГado")		 ;
					SIZE 115,010 OF oDlg PIXEL
	
		@ 060,010 CHECKBOX oCheckBox VAR lNoModify PROMPT OemToAnsi( "Utilizar a opГЦo acima atИ o final do Jogo." ) SIZE 160,010 OF oDlg PIXEL

		oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT SdkPrmBar( oDlg , aSvKeys , lButtonParam , @lContinue )
	RestKeys( aSvKeys , .T. )

	Do Case
		Case ( nOpcSudoku == 1 )
			lIniciante		:= .T.
			lIntermediario	:= .F.
			lAvancado		:= .F.
		Case ( nOpcSudoku == 2 )
			lIniciante		:= .F.
			lIntermediario	:= .T.
			lAvancado		:= .F.
		Case ( nOpcSudoku == 3 )
			lIniciante		:= .F.
			lIntermediario	:= .F.
			lAvancado		:= .T.
	End Case	

End Sequence
	
Return( lContinue )

/*/
зддддддддддбдддддддддддбддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSdkPrmBar  ЁAutor ЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддедддддддддддаддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁBarra de Botoes de Parametros do Sudoku						Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku() 	                                                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SdkPrmBar( oDlg , aSvKeys , lButtonParam , lContinue )

Local bButtonChkG	:= { || oDlg:End() , RestKeys( aSvKeys )  }
Local bButtonEndG	:= { || IF( ( ( lButtonParam ) .or. MsgNoYes( "Deseja Sair do Jogo?" , "Sair" ) ) , ( oDlg:End() , RestKeys( aSvKeys ) , lContinue := .F. ) , NIL ) }
Local bButtonHelp	:= { || SudokuHelp() }

Local oButtonBar

Local oButtonChkG
Local oButtonEndG
Local oButtonHelp

Local lChkAllNum	:= .F.

DEFINE BUTTONBAR oButtonBar	SIZE 025,025 3D TOP OF oDlg

DEFINE BUTTON oButtonChkG	RESOURCE "OK"   	OF oButtonBar GROUP	ACTION Eval( bButtonChkG )	TOOLTIP OemToAnsi( 'Ok...<Ctrl-O>' )
oButtonChkG:cTitle		:= OemToAnsi( "OK" )
oDlg:bSet15 			:= oButtonChkG:bAction
SetKey( 15 , oDlg:bSet15 )

DEFINE BUTTON oButtonEndG	RESOURCE "FINAL"	OF oButtonBar GROUP	ACTION Eval( bButtonEndG )	TOOLTIP OemToAnsi( 'Sair...<Ctrl-X>' )
oButtonEndG:cTitle		:= OemToAnsi( "Sair" )
oDlg:bSet24 			:= oButtonEndG:bAction
SetKey( 24 , oDlg:bSet24 )

DEFINE BUTTON oButtonHelp	RESOURCE "S4WB016N"	OF oButtonBar GROUP ACTION Eval( bButtonHelp )	TOOLTIP OemToAnsi( 'Ajuda...<F1>' )
oButtonHelp:cTitle		:= OemToAnsi( "Ajuda" )
SetKey( VK_F1 , oButtonHelp:bAction )

oButtonBar:bRClicked	:= { || AllwaysTrue() }

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSudokuNumArrayЁAutorЁMarinaldo de Jesus   Ё Data Ё27/10/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁMonta o Array com as Numeracoes Validas para o Sudoku       Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SudokuNumArray()

Local aSudokuIndex
Local aSudokuGetNum

Local nInitRow
Local nInitCol
Local nColIndex
Local nFinishRow
Local nFinishCol
Local nSaveInitCol
Local nSudokuIndex

Static aSudokuModel
Static nSudokuModel
Static nStcInitRow
Static nStcInitCol

DEFAULT nStcInitRow		:= SudokuCoord( Aleatorio( 9 , Seconds() * 15 ) , Aleatorio( 9 , Seconds() * 12 ) , 9 )
DEFAULT nStcInitCol		:= SudokuCoord( Aleatorio( 9 , Seconds() * 19 ) , Aleatorio( 9 , Seconds() * 70 ) , 9 )

SudokuModGet( @aSudokuModel , @nSudokuModel )

nInitRow				:= nStcInitRow
nInitCol				:= nStcInitCol

nInitCol				:= SudokuCoord( Aleatorio( 9 , Seconds() * 03 ) , Aleatorio( 9 , Seconds() * 10 ) , 9 )
nInitRow				:= SudokuCoord( Aleatorio( 9 , Seconds() * 19 ) , Aleatorio( 9 , Seconds() * 97 ) , 9 )
nSudokuIndex			:= SudokuCoord( Aleatorio( 9 , Seconds() + 15 ) , Aleatorio( 9 , Seconds() + 12 ) , nSudokuModel )

IF !( StrZero( nInitCol , 1 ) $ "1/4/7" )
	IF ( nStcInitCol == 4 )
		nInitCol := 7
	ElseIF ( nStcInitCol == 7 )
		nInitCol := 4
	Else
		nInitCol := 1
	EndIF
EndIF

nStcInitCol				:= nInitCol
nStcInitCol				:= nInitRow
nSaveInitCol			:= nInitCol

aSudokuIndex			:= aSudokuModel[ nSudokuIndex ] 
nFinishRow				:= Len( aSudokuIndex )

aSudokuGetNum			:= Array( 9 , 9 )
For nInitRow := 1 To nFinishRow
	nFinishCol	:= Len( aSudokuIndex[ nInitRow ] )
	nColIndex	:= 0
	For nInitCol := nSaveInitCol To nFinishCol
		aSudokuGetNum[ nInitRow , ++nColIndex ]		:= aSudokuIndex[ nInitRow , nInitCol ]
	Next nInitCol
	IF ( nSaveInitCol > 1 )
		nFinishCol := ( nSaveInitCol - 1 )
		For nInitCol := 1 To nFinishCol
			aSudokuGetNum[ nInitRow , ++nColIndex ]	:= aSudokuIndex[ nInitRow , nInitCol ]
		Next nInitCol
	EndIF
Next nInitRow

Return( aSudokuGetNum )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSudokuModGet  ЁAutorЁMarinaldo de Jesus   Ё Data Ё27/10/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁObtem modelos validos para a Montagem do Sudoku             Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SudokuModGet( aSudokuModel , nSudokuModel )

DEFAULT aSudokuModel	:= {;
								{;
									{ "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" },;
									{ "4" , "5" , "6" , "7" , "8" , "9" , "1" , "2" , "3" },;
									{ "7" , "8" , "9" , "1" , "2" , "3" , "4" , "5" , "6" },;
									{ "2" , "1" , "4" , "3" , "6" , "5" , "8" , "9" , "7" },;
									{ "3" , "6" , "5" , "8" , "9" , "7" , "2" , "1" , "4" },;
									{ "8" , "9" , "7" , "2" , "1" , "4" , "3" , "6" , "5" },;
									{ "5" , "3" , "1" , "6" , "4" , "2" , "9" , "7" , "8" },;
									{ "6" , "4" , "2" , "9" , "7" , "8" , "5" , "3" , "1" },;
									{ "9" , "7" , "8" , "5" , "3" , "1" , "6" , "4" , "2" };
								},;	
								{;
									{ "2" , "1" , "3" , "4" , "5" , "6" , "7" , "8" , "9" },;
									{ "4" , "5" , "6" , "7" , "8" , "9" , "1" , "2" , "3" },;
									{ "7" , "8" , "9" , "1" , "2" , "3" , "4" , "5" , "6" },;
									{ "1" , "2" , "4" , "3" , "6" , "5" , "8" , "9" , "7" },;
									{ "3" , "6" , "5" , "8" , "9" , "7" , "2" , "1" , "4" },;
									{ "8" , "9" , "7" , "2" , "1" , "4" , "3" , "6" , "5" },;
									{ "5" , "3" , "1" , "6" , "4" , "2" , "9" , "7" , "8" },;
									{ "6" , "4" , "2" , "9" , "7" , "8" , "5" , "3" , "1" },;
									{ "9" , "7" , "8" , "5" , "3" , "1" , "6" , "4" , "2" };
								},;
								{;
									{ "3" , "1" , "2" , "4" , "5" , "6" , "7" , "8" , "9" },;
									{ "4" , "5" , "6" , "7" , "8" , "9" , "1" , "2" , "3" },;
									{ "7" , "8" , "9" , "1" , "2" , "3" , "4" , "5" , "6" },;
									{ "1" , "2" , "3" , "5" , "4" , "7" , "6" , "9" , "8" },;
									{ "5" , "4" , "7" , "6" , "9" , "8" , "2" , "3" , "1" },;
									{ "6" , "9" , "8" , "2" , "3" , "1" , "5" , "4" , "7" },;
									{ "2" , "3" , "1" , "8" , "6" , "4" , "9" , "7" , "5" },;
									{ "8" , "6" , "4" , "9" , "7" , "5" , "3" , "1" , "2" },;
									{ "9" , "7" , "5" , "3" , "1" , "2" , "8" , "6" , "4" };
								},;
								{;
									{ "4" , "1" , "2" , "3" , "5" , "6" , "7" , "8" , "9" },;
									{ "3" , "5" , "6" , "7" , "8" , "9" , "1" , "2" , "4" },;
									{ "7" , "8" , "9" , "1" , "2" , "4" , "3" , "5" , "6" },;
									{ "1" , "2" , "3" , "4" , "6" , "5" , "8" , "9" , "7" },;
									{ "5" , "4" , "7" , "8" , "9" , "1" , "2" , "6" , "3" },;
									{ "6" , "9" , "8" , "2" , "3" , "7" , "4" , "1" , "5" },;
									{ "2" , "3" , "5" , "6" , "4" , "8" , "9" , "7" , "1" },;
									{ "8" , "6" , "1" , "9" , "7" , "3" , "5" , "4" , "2" },;
									{ "9" , "7" , "4" , "5" , "1" , "2" , "6" , "3" , "8" };
								},;
								{;
									{ "5" , "1" , "2" , "3" , "4" , "6" , "7" , "8" , "9" },;
									{ "3" , "4" , "6" , "7" , "8" , "9" , "1" , "2" , "5" },;
									{ "7" , "8" , "9" , "1" , "2" , "5" , "3" , "4" , "6" },;
									{ "1" , "2" , "3" , "4" , "5" , "7" , "6" , "9" , "8" },;
									{ "4" , "5" , "7" , "6" , "9" , "8" , "2" , "1" , "3" },;
									{ "6" , "9" , "8" , "2" , "1" , "3" , "4" , "5" , "7" },;
									{ "2" , "3" , "5" , "8" , "6" , "1" , "9" , "7" , "4" },;
									{ "8" , "6" , "1" , "9" , "7" , "4" , "5" , "3" , "2" },;
									{ "9" , "7" , "4" , "5" , "3" , "2" , "8" , "6" , "1" };
								},;
								{;
									{ "6" , "1" , "2" , "3" , "4" , "5" , "7" , "8" , "9" },;
									{ "3" , "4" , "5" , "7" , "8" , "9" , "1" , "2" , "6" },;
									{ "7" , "8" , "9" , "1" , "2" , "6" , "3" , "4" , "5" },;
									{ "1" , "2" , "3" , "4" , "5" , "7" , "6" , "9" , "8" },;
									{ "4" , "5" , "6" , "8" , "9" , "1" , "2" , "3" , "7" },;
									{ "8" , "9" , "7" , "2" , "6" , "3" , "4" , "5" , "1" },;
									{ "2" , "3" , "1" , "5" , "7" , "8" , "9" , "6" , "4" },;
									{ "5" , "6" , "4" , "9" , "1" , "2" , "8" , "7" , "3" },;
									{ "9" , "7" , "8" , "6" , "3" , "4" , "5" , "1" , "2" };
								},;
								{;
									{ "7" , "1" , "2" , "3" , "4" , "5" , "6" , "8" , "9" },;
									{ "3" , "4" , "5" , "6" , "8" , "9" , "1" , "2" , "7" },;
									{ "6" , "8" , "9" , "1" , "2" , "7" , "3" , "4" , "5" },;
									{ "1" , "2" , "3" , "4" , "5" , "6" , "7" , "9" , "8" },;
									{ "4" , "5" , "6" , "7" , "9" , "8" , "2" , "1" , "3" },;
									{ "8" , "9" , "7" , "2" , "1" , "3" , "4" , "5" , "6" },;
									{ "2" , "3" , "8" , "5" , "6" , "1" , "9" , "7" , "4" },;
									{ "5" , "6" , "1" , "9" , "7" , "4" , "8" , "3" , "2" },;
									{ "9" , "7" , "4" , "8" , "3" , "2" , "5" , "6" , "1" };
								},;
								{;
									{ "8" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "9" },;
									{ "3" , "4" , "5" , "6" , "7" , "9" , "1" , "2" , "8" },;
									{ "6" , "7" , "9" , "1" , "2" , "8" , "3" , "4" , "5" },;
									{ "1" , "2" , "3" , "4" , "5" , "6" , "8" , "9" , "7" },;
									{ "4" , "5" , "6" , "8" , "9" , "7" , "2" , "1" , "3" },;
									{ "7" , "9" , "8" , "2" , "1" , "3" , "4" , "5" , "6" },;
									{ "2" , "3" , "7" , "5" , "6" , "1" , "9" , "8" , "4" },;
									{ "5" , "6" , "1" , "9" , "8" , "4" , "7" , "3" , "2" },;
									{ "9" , "8" , "4" , "7" , "3" , "2" , "5" , "6" , "1" };
								},;
								{;
									{ "9" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" },;
									{ "3" , "4" , "5" , "6" , "7" , "8" , "1" , "2" , "9" },;
									{ "6" , "7" , "8" , "1" , "2" , "9" , "3" , "4" , "5" },;
									{ "1" , "2" , "3" , "4" , "5" , "6" , "8" , "9" , "7" },;
									{ "4" , "5" , "6" , "8" , "9" , "7" , "2" , "1" , "3" },;
									{ "7" , "8" , "9" , "2" , "1" , "3" , "4" , "5" , "6" },;
									{ "2" , "3" , "7" , "5" , "6" , "1" , "9" , "8" , "4" },;
									{ "5" , "6" , "1" , "9" , "8" , "4" , "7" , "3" , "2" },;
									{ "8" , "9" , "4" , "7" , "3" , "2" , "5" , "6" , "1" };
								},;
								{;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" };
								},;                                  	
								{;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" };
								},;                                  	
								{;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" },;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" };
								},;                                  	
								{;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" },;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" };
								},;
								{;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" };
								},;
								{;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" };
								},;                                  	
								{;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" };
								},;                                  	
								{;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" },;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" },;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" };
								},;                                  	
								{;
									{ "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" },;
									{ "4" , "5" , "6" , "7" , "8" , "9" , "1" , "2" , "3" },;
									{ "7" , "8" , "9" , "1" , "2" , "3" , "4" , "5" , "6" },;
									{ "9" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" },;
									{ "6" , "7" , "8" , "9" , "1" , "2" , "3" , "4" , "5" },;
									{ "3" , "4" , "5" , "6" , "7" , "8" , "9" , "1" , "2" },;
									{ "8" , "9" , "1" , "2" , "3" , "4" , "5" , "6" , "7" },;
									{ "5" , "6" , "7" , "8" , "9" , "1" , "2" , "3" , "4" },;
									{ "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" , "1" };
								},;
								{;
									{ "3" , "6" , "9" , "4" , "7" , "1" , "8" , "5" , "2" },;
									{ "4" , "7" , "1" , "5" , "8" , "2" , "9" , "6" , "3" },;
									{ "2" , "5" , "8" , "3" , "6" , "9" , "7" , "4" , "1" },;
									{ "7" , "1" , "4" , "8" , "2" , "5" , "3" , "9" , "6" },;
									{ "6" , "9" , "3" , "7" , "1" , "4" , "2" , "8" , "5" },;
									{ "5" , "8" , "2" , "6" , "9" , "3" , "1" , "7" , "4" },;
									{ "8" , "3" , "7" , "2" , "4" , "6" , "5" , "1" , "9" },;
									{ "9" , "2" , "6" , "1" , "5" , "7" , "4" , "3" , "8" },;
									{ "1" , "4" , "5" , "9" , "3" , "8" , "6" , "2" , "7" };
								},;	
								{;
									{ "3" , "8" , "4" , "6" , "9" , "2" , "7" , "1" , "5" },;
									{ "2" , "7" , "6" , "5" , "1" , "4" , "8" , "9" , "3" },;
									{ "1" , "9" , "5" , "7" , "8" , "3" , "6" , "2" , "4" },;
									{ "6" , "2" , "7" , "1" , "4" , "5" , "9" , "3" , "8" },;
									{ "4" , "3" , "8" , "9" , "2" , "6" , "1" , "5" , "7" },;
									{ "5" , "1" , "9" , "8" , "3" , "7" , "2" , "4" , "6" },;
									{ "9" , "5" , "1" , "3" , "7" , "8" , "4" , "6" , "2" },;
									{ "7" , "6" , "2" , "4" , "5" , "1" , "3" , "8" , "9" },;
									{ "8" , "4" , "3" , "2" , "6" , "9" , "5" , "7" , "1" };
								};                                  	
							}

DEFAULT nSudokuModel	:= Len( aSudokuModel )

Return( NIL )

/*/
зддддддддддбддддддддддддбдддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSudokuCoord ЁAutorЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁObtem as Coordenadas para a Inicializacao do Preenchimento  Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SudokuCoord( nAleat1 , nAleat2 , nMax )

Local nSudokuCoord	:= 0 

Local nSeed
Local nMaxPlus1

Static lPlus
Static nStart

DEFAULT lPlus		:= .T.
DEFAULT nStart		:= (;
							Seconds();
							+;
							19701512;
							+;
							DataHora2Val(;
											Ctod("15/12/1970","DDMMYYYY")	,;
											0,;
											Date(),;
											SecsToHMS(;
														Seconds(),;
														NIL,;
														NIL,;
														NIL,;
														"S";
													  ),;
											"D";
										 );
						)


DEFAULT nMax		:= 9
nMaxPlus1			:= ( nMax + 1 )

While (;
			( nSudokuCoord <= 0 );
			.or.;
			( nSudokuCoord >= nMaxPlus1 );
	   )
	IF ( lPlus )
		nSeed		:= ( nAleat1 + nAleat2 )
	Else
		nSeed		:= ( nAleat2 - nAleat1 )
	EndIF
	lPlus			:= !( lPlus )
	IF ( nSudokuCoord >= nMaxPlus1 )
		nSeed -= nSudokuCoord
	EndIF
	nSeed	   		:= Abs( nSeed )
	nSeed			/= 100
	nSudokuCoord	:= DataHora2Ale( Ctod("15/12/1970","DDMMYYYY") , nSeed , nMax , @nStart , "E" )
	nSudokuCoord	:= Hrs2Min( nSudokuCoord )
End While

Return( nSudokuCoord )

/*/
зддддддддддбддддддддддддбдддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁAllSudoku   ЁAutorЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁPreenche Todos os Numeros Faltantes                         Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function AllSudoku( oDlg , aSudokuElem , aSudokuGetNum )

Local lChkAllNum	:= !MsgNoYes( "Preencher apenas os nЗmeros Faltantes?" )

Local nLoop
Local nLoops
Local nChkNum
Local nNumChk

nLoops := Len( aSudokuGetNum )
For nLoop := 1 To nLoops
	nNumChk := Len( aSudokuGetNum[ nLoop ] )
	For nChkNum := 1 To nNumChk
		IF !( aSudokuElem[ nLoop , nChkNum , 1 ]:lReadOnly )
			IF ( lChkAllNum )
				IF !( aSudokuElem[ nLoop , nChkNum , 2 ] == aSudokuGetNum[ nLoop , nChkNum ] )
					aSudokuElem[ nLoop , nChkNum , 2 ]	:= aSudokuGetNum[ nLoop , nChkNum ]
				EndIF
			Else
				IF Empty( aSudokuElem[ nLoop , nChkNum , 2 ] )
					aSudokuElem[ nLoop , nChkNum , 2 ]	:= aSudokuGetNum[ nLoop , nChkNum ]
				EndIF
			EndIF
		EndIF
	Next nChkNum
Next nLoop

Return( oDlg:Refresh() )

/*/                     
зддддддддддбддддддддддддбдддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁChkSudoku	ЁAutorЁMarinaldo de Jesus     Ё Data Ё27/10/2005Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁVerifica se Esta Tudo OK                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function ChkSudoku( oDlg , aSudokuElem , aSudokuGetNum , lChkAllNum )

Local aChkOk	:= {}

Local cMsgInfo
Local cTitle 

Local nLoop
Local nLoops
Local nChkNum
Local nNumChk

nLoops := Len( aSudokuGetNum )
For nLoop := 1 To nLoops
	nNumChk := Len( aSudokuGetNum[ nLoop ] )
	For nChkNum := 1 To nNumChk
		IF !( aSudokuElem[ nLoop , nChkNum , 1 ]:lReadOnly )
			IF ( aSudokuElem[ nLoop , nChkNum , 2 ] == aSudokuGetNum[ nLoop , nChkNum ] )
				aSudokuElem[ nLoop , nChkNum , 1 ]:lReadOnly	:= .T.
				aSudokuElem[ nLoop , nChkNum , 1 ]:nClrPane	    := CLR_GREEN
				aSudokuElem[ nLoop , nChkNum , 1 ]:nClrText	    := CLR_WHITE
				aAdd( aChkOk , { .T. , nLoop , nChkNum } )
			Else
				aSudokuElem[ nLoop , nChkNum , 1 ]:nClrPane	    := CLR_RED
				aSudokuElem[ nLoop , nChkNum , 1 ]:nClrText	    := CLR_WHITE
				aAdd( aChkOk , { .F. , nLoop , nChkNum } )
			EndIF
		EndIF
	Next nChkNum
Next nLoop

IF !( lChkAllNum )

	IF ( ( nLoop := aScan( aChkOk , { |aOk| !( aOk[ 1 ] ) } ) ) > 0 )
		cMsgInfo := "Existem InformaГУes inconsistЙntes!"
		cMsgInfo += CRLF
		cMsgInfo += "Corrija os nЗmeros dos quadrados pintados de vermelho!"
		cTitle	:= "Inconsistйncia"
	Else
		cMsgInfo := "ParabИns, vocЙ conclui a partida com sucesso!"
		cTitle	:= "OK"
	EndIF

	MsgInfo( OemToAnsi( cMsgInfo ) , OemToAnsi( cTitle ) )

EndIF

Return( oDlg:Refresh() )

/*/                     
зддддддддддбддддддддддддбдддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁSudokuTime  ЁAutorЁMarinaldo de Jesus     Ё Data Ё31/03/2006Ё
цддддддддддеддддддддддддадддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁTimer do Sudoku                                             Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formaisa>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function SudokuTime( cTime , nCountTime )

Local bSudokuTime	:= { || SudokuTime() }

RstTimeRemaining()

While ( GetGlbValue( "bStartSudoku" ) == "1" )
	While !( GlbLock() )
		Sleep(5)
	End While
	PutGlbValue( "cSudokuTime" , TimeRemaining( cTime , nCountTime )[1] )
	GlbUnlock()
End While

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁRmtInSrv	  ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/06/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁVerifica se o Remote Esta na Mesma Maquina que o Server	    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function RmtInSrv()

Local cClientDir	:= GetClientDir()
Local cServerDir	:= StrTran( Lower( cClientDir ) , "remote" , "server" )

Return( lIsDir( cServerDir ) )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁShowFile      ЁAutorЁMarinaldo de Jesus   Ё Data Ё29/03/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁAbrir e Mostrar o Conteudo de um arquivo                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function ShowFile( cShowFile , cRootPath )

Local cDir
Local cDrive

Local cFileShow

Local lShowOk	:= .F.

Begin Sequence

	cShowFile := Upper( AllTrim( @cShowFile ) )

	IF (;
			Empty( @cShowFile );
			.or.;
			!File( @cShowFile );
		)	
		Break
	EndIF

	DEFAULT cRootPath := AllTrim( GetPvProfString( GetEnvServer() , "RootPath" , "ERROR" , GetADV97() ) )
	IF ( "ERROR" $ cRootPath )
		lShowOk := .F.
		Break
	EndIF
	IF ( SubStr( cRootPath , -1 ) <> "\" )
		cRootPath += "\"
	EndIF

	IF !( CpyS2Tmp( cShowFile , @cFileShow , cRootPath ) )
		Break
	EndIF

	IF (;
			( ".DOC" $ cShowFile );
			.or.;
			( ".SOL" $ cShowFile );
			.or.;
			( ".DOT" $ cShowFile );
		)	

		IF (;
				!Empty( __oShowWord );
				.and.;
				( __oShowWord <> "-1" );
			)	
			OLE_CloseFile( @__oShowWord )
			OLE_CloseLink( @__oShowWord )
			__oShowWord := NIL
		EndIF

		__oShowWord := OLE_CreateLink( @"TMsOleWord97" )

		OLE_SetProperty( @__oShowWord , @oleWdVisible	, @.F. )
		OLE_SetProperty( @__oShowWord , @oleWdPrintBack	, @.T. )
		OLE_SetProperty( @__oShowWord , @oleWdLeft		, @000 )
		OLE_SetProperty( @__oShowWord , @oleWdTop		, @090 )
		OLE_SetProperty( @__oShowWord , @oleWdWidth		, @480 )
		OLE_SetProperty( @__oShowWord , @oleWdHeight	, @250 )
		OLE_OpenFile( @__oShowWord , @cFileShow , @.F. , @"" , @"" )
		OLE_SetProperty( @__oShowWord , @oleWdVisible , @.T. )

		Break
	
	EndIF

	SplitPath( @cFileShow , @cDrive , @cDir )
	cDir	:= ( Alltrim( @cDrive ) + Alltrim( @cDir ) )
	lShowOk := ( ShellExecute( "open" , @cFileShow , "" , @cDir , 1 ) <> 2 )

End Sequence

Return( lShowOk )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCpyS2Tmp      ЁAutorЁMarinaldo de Jesus   Ё Data Ё29/03/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁCopiar um arquivo do Server para Diretorio Temporario no CliЁ
Ё          Ёente														Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CpyS2Tmp( cFileCpy , cCpyFile , cRootPath )

Local lCpyS2TTmp	:= .T.

Local cClientTmp

Begin Sequence

	IF !( RmtInSrv() )	//IsFileServer() ou IsFileClient()
		cCpyFile	:= cFileCpy
		cClientTmp	:= GetTempPath()
		IF ( ":" $ cCpyFile )
			cCpyFile := SubStr( cCpyFile , ( At( ":" , cCpyFile ) + 1 ) )
		EndIF
		IF ( SubStr( cCpyFile , 1 , 1 ) <> "\" )
			cCpyFile := ( "\" + cCpyFile )
		EndIF
		lCpyS2TTmp	:= CpyS2T( cCpyFile , cClientTmp , .T. )
		IF !( lCpyS2TTmp )
			Break
		EndIF
		cClientTmp	+= FileNoPath( @cCpyFile )
		cCpyFile	:= cClientTmp
	Else
		DEFAULT cRootPath := AllTrim( GetPvProfString( GetEnvServer() , "RootPath" , "ERROR" , GetADV97() ) )
		IF ( "ERROR" $ cRootPath )
			lCpyS2TTmp	:= .F.
			Break
		EndIF
		IF ( SubStr( cRootPath , -1 ) <> "\" )
			cRootPath += "\"
		EndIF
		cCpyFile := ( cRootPath + cFileCpy )
	EndIF

End Sequence

Return( lCpyS2TTmp )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁFileNoPath    ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/07/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁExtrai o arquivo             								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_Sudoku()  	                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function FileNoPath( cPathFile )

Local cFileNoPath := RetFileName( @cPathFile )

cFileNoPath += SubStr( cPathFile , rAt( "." , cPathFile ) )

Return( cFileNoPath )