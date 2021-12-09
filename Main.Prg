#include <hmg.ch>


#include <set.ch>
#include <fileio.ch>
#include "directry.ch"

Function Main

        Private cServer := 'LocalHost'
        Private cUserDb := 'root'


        
        
	      SET LANGUAGE TO PORTUGUESE
	      SET CODEPAGE TO PORTUGUESE   
   			
       	SET(_SET_DATEFORMAT , "dd/mm/yyyy" )





        
      	HB_SetCodePage( "PT850" )
      	hb_langSelect( "PT" )


        
        Private cPassDb := '123321'
        Private cBanco := 'sisDb'

        Private cArqT1  := ''

        Private cArqCsv := ''


        Load Window Main
        Main.Center





        Main.BtnRun.Enabled := .f.




        Main.Activate
        
        
        
        
        
        

        

Return


Function Impx()

   Local oServer := GetConexao()
 
    msginfo('Conectado')



   aTexto1 := MemoRead( "Clientes.Csv" )

   aMatriz := TextToArray( aTexto1 )


   For n1 := 1 To Len(aMatriz) - 1

       cLine := aMatriz[n1]


       aZ1 := hb_ATokens(  cLine , ";" )


   Next 



   msginfo('ok')
 

      msgBox( "Processo completo!" )
 
  


Return



Function xGetRt1()

  //Local cArq := 

  Local cARq1 := GetFile ( { {"Mapeamentos ", "*.TY1"} }, NIL, GetCurrentFolder() )

  Local aMatriz := {}

  Local n1


  If !Empty(Alltrim(cArq1))
     cArqT1 := cArq1

     Main.LblArq1.Value := cArqT1

     Main.LstMap1.DeleteAllItems()

     
     aMatriz := TextToArray( MemoRead(    cArqt1 ) )


     //Main.LstMap1.Item := aMatriz 

     For n1 := 1 To Len(aMatriz)
         If !Empty(Alltrim(  aMatriz[n1] ))
            Main.LstMap1.AddItem(  aMatriz[n1]  )
         End If 
     Next

     
      Main.LblQtCampos.Value := Alltrim(Str(Len(  aMatriz   ))) + ' Campos '

     SetProperty("Main" , "LstMap1" , "Enabled" , .f.)

     Do Events

     Main.BtnRun.Enabled := (Len(cArqt1) > 0 ) .And. (  Len(cArqCsv) > 0  )

  End If 


REturn 



Function xGetCSV()




  //Local cArq := 

  Local cARq1 := GetFile ( { {"Arquivos CSV", "*.Csv"} }, NIL, GetCurrentFolder() )
  Local aMatriz 
  Local aSub1 := {}


  If !Empty(Alltrim(cArq1))
     cArqCsv := cArq1

     Main.LblArqCSV.Value := cArqCsv
     
     aMatriz := TextToArray( MemoRead(    cArqCsv ) )

     aSub1 := hb_ATokens( aMatriz[1] , ';' )



     Main.LblQtLinhas.Value := Alltrim( Transform(Len(  aMatriz   )   , "999,999,999"  )) + ' Linhas , ' + Alltrim(Str(   Len(aSub1)   )) + ' Colunas '

     Do Events

     Main.BtnRun.Enabled := (Len(cArqt1) > 0 ) .And. (  Len(cArqCsv) > 0  )

  End If 

REturn 


Function xRode()


   HB_SETCODPAGE("PT850")

   If !MsgYesNo( Hb_AnsiToOem("Confirma Execução da Importação do CSV?"))
      Return
   End If 

   Main.Cursor := 'Hourglass.Cur'




Return 


FUNCTION GetConexao()

   LOCAL oServer
   LOCAL lRet
   LOCAL oQuery

   oServer := TMySQLServer():New( cServer, cUserDb, cPassDb )

   IF oServer:NetErr()
      MsGInfo( "Error ao Conectar SQL Server: " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   ENDIF

   oServer:SelectDB( cBanco )

   IF oServer:NetErr()
      MsGInfo( "Error ao Conectar Banco " + cBanco + " : " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   ENDIF

RETURN ( oServer )


STATIC FUNCTION TextToArray( cString )
RETURN hb_ATokens( StrTran( cString, Chr( 13 ) ), Chr( 10 ) )



FUNCTION fTiraChar( wCampo )

   // // Remover Caracteres Especiais (/,*)

   LOCAL lRet  := .T.
   LOCAL cStr1 := ''
   LOCAL i     := 1 //'

   FOR i := 1 TO Len( wCampo )
      IF SubStr( wCampo, i, 1 ) == "'" .OR. SubStr( wCampo, i, 1 ) == ")" .OR. SubStr( wCampo, i, 1 ) == "(" .OR. SubStr( wCampo, i, 1 ) == "*" .OR. SubStr( wCampo, i, 1 ) == "/"  .OR. SubStr( wCampo, i, 1 ) == "\"  .OR. SubStr( wCampo, i, 1 ) == '%' .OR. SubStr( wCampo, i, 1 ) == "-"

      ELSE
         cStr1 += SubStr( wCampo, i, 1 )
      ENDIF
   NEXT i

   RETURN cStr1

