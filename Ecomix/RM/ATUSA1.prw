#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA1
Autor 		: Fabiano da Silva	-	25/03/20
Descri��o 	: Exportar tabelas SA1
*/

USER FUNCTION ATUSA1()

	Local a

	// _aCli := {'00461701000128','00708765000180','00819188000102','02469319000196','03021088000116','03770348000156','03987379839','03990917000179','06063958000108','07115909000134','07316777000109','07574029000126','08028693000132','09008774000133','09665334000159','10577006000180','10593241000145','10983957000159','11210691000174','11384603000150','11504843000141','11601748000247','12059189000177','12211679000147','12285916000114','12462279000104','12462976000165','12839578000115','12998645000144','13373367000100','13380428000159','13820661000105','13976806000161','14082839000120','14141266000169','14310577000104','14366123000155','14476833000138','14782350000161','14857546000178','15133147000127','16682412000199','16723733000194','16979912000197','17116376000169','17216514000181','17677940000112','18013106000195','18083366000137','18323975000116','18325830000154','18469311000160','18951300000111','18952490000191','19479309000134','19497776000197','19591966000179','19879330000127','19989502000115','20465234000111','20588988000169','21162033000108','21549964000163','22014978000145','22110741000168','22699619000179','22799816000160','23047037000170','23085454000108','23140416000100','23155713000120','23167564000119','23729405000160','23949238000163','24070874000183','24267763000161','24472064000153','24595818000162','24606810000154','24681945000184','24895299000158','25041076000196','25056245000161','25098582000111','25178824000187','26300748000284','26463292000192','26577111000159','26581170000109','26642206000109','26717592000150','26789499000151','26869463000188','27105225000169','27325131000103','27353590000192','27522420857','28185229864','28574940000103','28842948000103','28866702000171','29797415000110','30479155000113','30626748000165','31542552000155','32922084833','33614927000170','33888375000199','35995337000160','36906576879','37257251000166','37717107000165','39302579808','44046945800','45154417879','45655578000114','50597129000105','53524625000119','65410458000164','65733248000107','65896573000190','66766346000103','69126357000117','97172529553'}

	_aCli := {'00.461.701/0001-28','00.708.765/0001-80','00.819.188/0001-02','02.469.319/0001-96','03.021.088/0001-16','03.770.348/0001-56','03.987.379/839-','03.990.917/0001-79','06.063.958/0001-08','07.115.909/0001-34','07.316.777/0001-09','07.574.029/0001-26','08.028.693/0001-32','09.008.774/0001-33','09.665.334/0001-59','10.577.006/0001-80','10.593.241/0001-45','10.983.957/0001-59','11.210.691/0001-74','11.384.603/0001-50','11.504.843/0001-41','11.601.748/0002-47','12.059.189/0001-77','12.211.679/0001-47','12.285.916/0001-14','12.462.279/0001-04','12.462.976/0001-65','12.839.578/0001-15','12.998.645/0001-44','13.373.367/0001-00','13.380.428/0001-59','13.820.661/0001-05','13.976.806/0001-61','14.082.839/0001-20','14.141.266/0001-69','14.310.577/0001-04','14.366.123/0001-55','14.476.833/0001-38','14.782.350/0001-61','14.857.546/0001-78','15.133.147/0001-27','16.682.412/0001-99','16.723.733/0001-94','16.979.912/0001-97','17.116.376/0001-69','17.216.514/0001-81','17.677.940/0001-12','18.013.106/0001-95','18.083.366/0001-37','18.323.975/0001-16','18.325.830/0001-54','18.469.311/0001-60','18.951.300/0001-11','18.952.490/0001-91','19.479.309/0001-34','19.497.776/0001-97','19.591.966/0001-79','19.879.330/0001-27','19.989.502/0001-15','20.465.234/0001-11','20.588.988/0001-69','21.162.033/0001-08','21.549.964/0001-63','22.014.978/0001-45','22.110.741/0001-68','22.699.619/0001-79','22.799.816/0001-60','23.047.037/0001-70','23.085.454/0001-08','23.140.416/0001-00','23.155.713/0001-20','23.167.564/0001-19','23.729.405/0001-60','23.949.238/0001-63','24.070.874/0001-83','24.267.763/0001-61','24.472.064/0001-53','24.595.818/0001-62','24.606.810/0001-54','24.681.945/0001-84','24.895.299/0001-58','25.041.076/0001-96','25.056.245/0001-61','25.098.582/0001-11','25.178.824/0001-87','26.300.748/0002-84','26.463.292/0001-92','26.577.111/0001-59','26.581.170/0001-09','26.642.206/0001-09','26.717.592/0001-50','26.789.499/0001-51','26.869.463/0001-88','27.105.225/0001-69','27.325.131/0001-03','27.353.590/0001-92','27522420857','28.185.229/864-','28.574.940/0001-03','28.842.948/0001-03','28.866.702/0001-71','29.797.415/0001-10','30.479.155/0001-13','30.626.748/0001-65','31.542.552/0001-55','329.220.84833','33.614.927/0001-70','33.888.375/0001-99','35.995.337/0001-60','36906576879','37.257.251/0001-66','37.717.107/0001-65','39.302.579/808-','44046945800','45.154.417/879-','45.655.578/0001-14','50.597.129/0001-05','53.524.625/0001-19','65.410.458/0001-64','65.733.248/0001-07','65.896.573/0001-90','66.766.346/0001-03','69.126.357/0001-17','971.725.295-53'}

	For a := 1 to Len(_aCli)
		If Select("TCLI") > 0
			TCLI->(dbCloseArea())
		Endif

		_cQry := " SELECT TOP 1 CODCOLIGADA AS 'EMP',* FROM [10.140.1.5].[CorporeRM].dbo.FCFO " + CRLF
		// _cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " + CRLF
		_cQry += " WHERE RTRIM(CGCCFO) = '"+_aCli[a]+"' " + CRLF
		_cQry += " ORDER BY CGCCFO,EMP " + CRLF

		TcQuery _cQry New Alias "TCLI"

		_nReg := Contar("TCLI","!EOF()")

		If _nReg > 0

			TCLI->(dbGoTop())

			While TCLI->(!EOF())

				_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""))
				_cCod  := ''
				_cLoja := ''

				SA1->(dbSetOrder(3))
				If !SA1->(MsSeek(xFilial("SA1")+_cCNPJ))

					If TCLI->PESSOAFISOUJUR = "J"
						SA1->(dbSetOrder(3))
						If SA1->(MsSeek(xFilial("SA1")+Left(_cCNPJ,8)))
							_cCod := SA1->A1_COD
						Endif
					Endif

					GetNxtA1(@_cCod,@_cLoja)

					SA1->(RecLock("SA1",.T.))
					// SA1->A1_YID        := TCLI->IDCFO
					// SA1->A1_FILIAL     := _cFil
					// SA1->A1_YCODRM     := TCLI->CODCFO
					SA1->A1_COD        := _cCod
					SA1->A1_LOJA       := _cLoja
					SA1->A1_PESSOA     := TCLI->PESSOAFISOUJUR
					SA1->A1_NOME       := UPPER(U_RM_NoAcento(TCLI->NOME))
					SA1->A1_NREDUZ     := UPPER(U_RM_NoAcento(TCLI->NOMEFANTASIA))
					SA1->A1_END        := UPPER(U_RM_NoAcento(Alltrim(TCLI->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCLI->NUMERO)))
					SA1->A1_COMPLEM    := UPPER(U_RM_NoAcento(Alltrim(TCLI->COMPLEMENTO)))
					SA1->A1_EST        := TCLI->CODETD
					SA1->A1_COD_MUN    := TCLI->CODMUNICIPIO
					SA1->A1_MUN        := UPPER(U_RM_NoAcento(Alltrim(TCLI->CIDADE)))
					SA1->A1_BAIRRO     := UPPER(U_RM_NoAcento(Alltrim(TCLI->BAIRRO)))
					SA1->A1_NATUREZ    := "N1001"
					SA1->A1_CEP        := StrTran(TCLI->CEP,".","")
					SA1->A1_TEL        := TCLI->TELEFONE
					SA1->A1_PAIS       := "105"
					SA1->A1_CGC        := _cCNPJ
					SA1->A1_CONTATO    := TCLI->CONTATO
					SA1->A1_INSCR      := IIF (Empty(TCLI->INSCRESTADUAL),"ISENTO",TCLI->INSCRESTADUAL)
					SA1->A1_CODPAIS    := "01058"
					SA1->A1_SATIV1     := "1"
					SA1->A1_SATIV2     := "1"
					SA1->A1_SATIV3     := "1"
					SA1->A1_SATIV4     := "1"
					SA1->A1_SATIV5     := "1"
					SA1->A1_SATIV6     := "1"
					SA1->A1_SATIV7     := "1"
					SA1->A1_SATIV8     := "1"
					SA1->A1_EMAIL      := TCLI->EMAIL
					SA1->A1_EMAILNF    := TCLI->EMAIL
					SA1->A1_MSBLQL     := If(TCLI->ATIVO=1,"2","1")
					SA1->A1_LC         := TCLI->LIMITECREDITO
					SA1->A1_INSCRM     := TCLI->INSCRMUNICIPAL
					SA1->A1_CONTRIB    := If(TCLI->CONTRIBUINTE=1,"2","1")
					SA1->A1_XNOMV      := "."
					SA1->A1_CONTA      := "10102020000001"
					SA1->A1_YTPCLI     := "1"
					SA1->A1_YCTARA     := "20101150000002"
					SA1->A1_COND       := "001"
					SA1->(MsUnLock())
				Endif

				TCLI->(dbSkip())
			EndDo

		Endif

		TCLI->(dbCloseArea())
	Next a

Return(Nil)



Static Function GetNxtA1(_cCod,_cLoja)

	Local _cQrySA1 := ""

	If Empty(_cCod)

		_cQrySA1 := " SELECT MAX(A1_COD) AS COD FROM "+RetSqlName("SA1")+" A1 " +CRLF
		_cQrySA1 += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF

		TcQuery _cQrySA1 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cCod := "C"+SOMA1(RIGHT(TNEXT->COD,5))
		_cLoja := "01"

		TNEXT->(dbCloseArea())
	Else

		_cQrySA1 := " SELECT MAX(A1_LOJA) AS LOJA FROM "+RetSqlName("SA1")+" A1 " +CRLF
		_cQrySA1 += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF
		_cQrySA1 += " AND A1_COD = '"+_cCod+"' " +CRLF

		TcQuery _cQrySA1 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cLoja := SOMA1(TNEXT->LOJA)

		TNEXT->(dbCloseArea())
	Endif

Return(Nil)
