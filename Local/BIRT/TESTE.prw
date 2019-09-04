#INCLUDE 'TOTVS.CH'
#INCLUDE 'TDSBIRT.CH'
#INCLUDE 'BIRTDATASET.CH'


USER Function Teste()

	Local _oReport

	Define User_Report _oReport Name TESTE01 Title "Teste Birt" ASKPAR EXCLUSIVE

	Activate REPORT _oReport LAYOUT TESTE01 Format HTML

Return(Nil)