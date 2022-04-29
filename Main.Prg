#include <hmg.ch>
#include "hbthread.ch"

#define QUEBRA Chr(13)+Chr(10)


#include <set.ch>
#include <fileio.ch>
#include "directry.ch"


#include "dll.ch"

#include <hbdyn.ch>





#define WM_DESTROY          0x0002
#define SC_CLOSE            61536



Static aThread := Nil

Static oServerDb := Nil


STATIC nQreg := 0

STATIC nRecno := 0


STATIC lTermino := .f.



STATIC nPercent := 0
STATIC nTotal   := 0


STATIC cArqT1  := ''

STATIC cArqCsv := ''



DECLARE Window fprogress
DECLARE Window FormSplash

FUNCTION Main

   PRIVATE cServer := 'LocalHost'
   PRIVATE cUserDb := 'root'

   Private cDataBase := 'SisDb'




   Private aBt1
   Private aBt2
   Private aBt3
   Private aBt4
   Private aBt5
   Private aBt6
   Private aBt7
   Private aBt8
   Private aBt9
   Private aBt10
   Private aBt11
   Private aBt12




   Private aThread  := 0
   Private aThread1 := 0

   Private lEfeito := .f.

   Private hBitMap := Nil

   Public nContador := 0

   SET LANGUAGE TO PORTUGUESE
   SET CODEPAGE TO PORTUGUESE


   Set( _SET_DATEFORMAT, "dd/mm/yyyy" )

   HB_SetCodePage( "PT850" )
   hb_langSelect( "PT" )



   PRIVATE cPassDb := '123321'
   PRIVATE cBanco := 'sisDb'





   Load Window Main

   
   
   SET WINDOW MAIN OFF
 
   Private nHandle1 := CrieSplash()
   SET WINDOW MAIN ON


   Main.Center

   Main .BtnRun. Enabled := .F.


   Main.Activate

RETURN

Function xLoadBmp()

   aBt1  :=  BT_BitmapLoadFile ( 'Animacao\a1.png' )
   aBt2  :=  BT_BitmapLoadFile ( 'Animacao\a2.png' )
   aBt3  :=  BT_BitmapLoadFile ( 'Animacao\a3.png' )
   aBt4  :=  BT_BitmapLoadFile ( 'Animacao\a4.png' )
   aBt5  :=  BT_BitmapLoadFile ( 'Animacao\a5.png' )
   aBt6  :=  BT_BitmapLoadFile ( 'Animacao\a6.png' )
   aBt7  :=  BT_BitmapLoadFile ( 'Animacao\a7.png' )
   aBt8  :=  BT_BitmapLoadFile ( 'Animacao\a8.png' )
   aBt9  :=  BT_BitmapLoadFile ( 'Animacao\a9.png' )
   aBt10 :=  BT_BitmapLoadFile ( 'Animacao\a19.png' )
   aBt11 :=  BT_BitmapLoadFile ( 'Animacao\a11.png' )
   aBt12 :=  BT_BitmapLoadFile ( 'Animacao\a12.png' )

Return


Function xLimpa()

   aThread := NIL

   Main .LblArq1. Value := ""

   Main .LblArqCsv. Value := ""

   Main .LblQtCampos. Value := ""

   Main .LstMap1. DeleteAllItems()

   Main .LblAndamento. Value := "   "

   Main .LblQtLinhas. Value := "       "

   // Main.BtnRun.Visible := .f.

   SetProperty( "Main",  "BtnRun", "Enabled", .f. )

   //DoMethod( "fProgress", "Hide" )

Return


Function xDoPaint(  cJan, lEffect )

   LOCAL hDc

   LOCAL nRow := 0
   LOCAL nCol := 0


   LOCAL Width  := BT_ClientAreaWidth  ( cJan )
   LOCAL Height := BT_ClientAreaHeight ( cJan )

   LOCAL nW

   LOCAL BTstruct

   hDC    = BT_CreateDC ( cJan, BT_HDC_INVALIDCLIENTAREA, @BTstruct )


   If lEffect


      BT_DrawGradientFillVertical ( hDC,  0, 0,  Width,  Height, BLACK, BLACK )              //

      BT_DrawBitmapAlphaBlend ( hDC, 0,  0, nil, nil, 120, BT_COPY, hBitmap )
      BT_DeleteDC ( BTstruct )

   Else



   End If

Return



Function D1Black( cJan, nP1, nTot )

   LOCAL hDc

   LOCAL nRow := 0
   LOCAL nCol := 0

   Local hBit10


   LOCAL Width  := BT_ClientAreaWidth  ( cJan )
   LOCAL Height := BT_ClientAreaHeight ( cJan )

   LOCAL nW

   LOCAL BTstruct

   // Local nTot

   DEFAULT nP1  := 0
   DEFAULT nTot := 0




   hDC    = BT_CreateDC ( cJan, BT_HDC_INVALIDCLIENTAREA, @BTstruct )

   //hBit10 := BT_BitmapLoadFile ( 'Animacao\a' + Alltrim( Str(  nP1 ) ) + '.png' )

    hBit10 := BT_BitmapLoadFile ( 'L' +  Alltrim( Str(  nP1 ) )   )

   // hBit10 := BT_BitmapLoadFile ( 'Animacao\a1.png' )


   If ( nP1 > 0 )

      nW := Int( ( np1 / nTot ) * Width )



      // BT_DrawGradientFillVertical ( hDC,  nRow,  nCol,  Width,  Height, WHITE, WHITE )
      BT_DrawBitmap ( hDC,   0,  0, Width, Height, BT_STRETCH, hBit10 )



      // BT_DrawGradientFillVertical ( hDC,  nRow,  nCol,  nW,  Height, WHITE, BLACK )

   Else
      BT_DrawGradientFillVertical ( hDC,  nRow,  nCol,  Width,  Height, { 192, 192, 192 }, { 192, 192, 192 } )
   End If

   BT_BitmapRelease ( hBit10 )




   BT_DeleteDC ( BTstruct )

RETURN




FUNCTION xInit()

   oServerDb := GetConexao()

   //HMG_ChangeWindowStyle(  fProgress.Handle, NIL, WS_BORDER   , .F., .f. )
//   HMG_ChangeWindowStyle(  fProgress.Handle, WS_EX_STATICEDGE, NIL, .T., .T. )




   fProgress.Height := 200

   fProgress.width := 200


   // fProgress.Show()



   //SetProperty( "fProgress",  "Visible", .f. )

   DoMethod( "fProgress", "Hide" )


   //SET WINDOW fProgress TRANSPARENT TO COLOR { 255, 255, 255 }




   // BT_ClientAreaInvalidateAll( 'fProgress' )



RETURN


FUNCTION Impx()

   LOCAL oServer := GetConexao()

   MsgInfo( 'Conectado' )

   aTexto1 := MemoRead( "Clientes.Csv" )

   aMatriz := TextToArray( aTexto1 )


   For n1 := 1 TO Len( aMatriz ) - 1

      cLine := aMatriz[ n1 ]


      aZ1 := hb_ATokens(  cLine, ";" )


   Next



   msginfo( 'ok' )


   msgBox( "Processo completo!" )

RETURN



FUNCTION xGetRt1()

   // Local cArq :=

   LOCAL cARq1 := GetFile ( { { "Mapeamentos ", "*.TY1" } }, NIL, GetCurrentFolder() )

   LOCAL aMatriz := {}

   LOCAL n1


   If !Empty( AllTrim( cArq1 ) )
      cArqT1 := cArq1

      Main .LblArq1. Value := cArqT1

      Main .LstMap1. DeleteAllItems()




      aMatriz := TextToArray( MemoRead(    cArqt1 ) )




      // Main.LstMap1.Item := aMatriz

      For n1 := 1 TO Len( aMatriz )
         If !Empty( AllTrim(  aMatriz[ n1 ] ) )
            Main .LstMap1. AddItem(  aMatriz[ n1 ]  )
         End If
      Next


      Main .LblQtCampos. Value := AllTrim( Str( Len(  aMatriz   ) ) ) + ' Campos '

      SetProperty( "Main", "LstMap1", "Enabled", .F. )

      DO Events




      Main .BtnRun. Enabled := ( Len( cArqt1 ) > 0 ) .AND. (  Len( cArqCsv ) > 0  )

   End If

RETURN



FUNCTION xGetCSV()

   // Local cArq :=

   LOCAL cARq1 := GetFile ( { { "Arquivos CSV", "*.Csv" } }, NIL, GetCurrentFolder() )
   LOCAL aMatriz
   LOCAL aSub1 := {}


   If !Empty( AllTrim( cArq1 ) )
      cArqCsv := cArq1

      Main .LblArqCSV. Value := cArqCsv

      aMatriz := TextToArray( MemoRead(    cArqCsv ) )

      aSub1 := hb_ATokens( aMatriz[ 1 ], ';' )



      Main .LblQtLinhas. Value := AllTrim( Transform( Len(  aMatriz   ), "999,999,999"  ) ) + ' Linhas , ' + AllTrim( Str(   Len( aSub1 )   ) ) + ' Colunas '

      DO Events

      Main .BtnRun. Enabled := ( Len( cArqt1 ) > 0 ) .AND. (  Len( cArqCsv ) > 0  )

   End If

RETURN


Function CrieSplash()

   Local nRow := GetProperty("Main" , "Row")
   Local nCol := GetProperty("Main" , "Col")

  //AT nRow + 150 , nCol + 250 ;  


   DEFINE WINDOW FormSplash;                  
         AT nRow + 150 , nCol + 250 ;  
         WIDTH 200;
         HEIGHT 200;
         TITLE 'Titl1' ;
         BACKCOLOR WHITE ; 
         NOSYSMENU;
         NOSIZE;         
         NOMINIMIZE;
         NOMAXIMIZE; 
         NOCAPTION;
         NOAUTORELEASE ;
         TOPMOST;
         CHILD  ;
         ON PAINT D1Black(ThisWindow.name , nContador , nTotal )
         
         SET WINDOW FormSplash TRANSPARENT TO COLOR WHITE 
       
   END WINDOW  

   
//   CENTER WINDOW FormSplash
   //ANIMATE WINDOW FormSplash INTERVAL (nAnimateSeconds * 1000) MODE AW_HOR_POSITIVE
  // ACTIVATE WINDOW FormSplash
         


Return GetFormHandle( 'FormSplash' )

Function xStartProc()

   Local aM1 := {}
   Local nHandle1


   If !MsgYesNo( hb_ANSIToOEM( "Confirma Execução da Importação do CSV?" ) )
      Return
   End If

   
	IF !hb_mtvm()
		MSGSTOP("There is no support for multi-threading")
		QUIT
	ENDIF




   Main .StatusBar. Item( 2 ) :=  Hb_AnsiToOem(' Aguarde... Importando Informações.')

   hBitMap := BT_BitmapCaptureWindow ( 'Main', 31, 5, Main.Width, Main.Height  )

   Main.Cursor := 'HAND1'
   
   //RESOURCECURSOR('HAND1')

   Do Events







   DoMethod("FormSplash"  , "Show")

   BT_BitmapSaveFile ( hBitMap, "hBit2.bmp" )

   lEfeito := .t.

   aM1 :=  SetWindowControlsVisible( 'Main', .f.   )

   BT_ClientAreaInvalidateAll( 'Main' )
   aThread  := hb_threadStart(  HB_THREAD_INHERIT_PUBLIC, @xRode(), cArqT1, cArqCSV )

   // msginfo('obj Lançado')

   nContador := 0




   // Main.LblAndamento.Visible := .t.

   While !lTermino

      Do Events

   Enddo




   hb_threadDetach( aThread )   // close thread handle
   hb_threadQuitRequest( aThread )   //


   nTotal   := 0
   nPerCent := 0

   nContador := 0



   //BT_ClientAreaInvalidateAll( 'fProgress' )



   xLimpa()

   Do Events

   If nQreg > 0 
      MsgInfo( 'Processo Concluido! ' + QUEBRA + Alltrim(Str(nQreg)) + ' Registros Não Importados.' )
   Else 

      MsgInfo( 'Processo Concluido!' )
   End If    

   // Main .StatusBar. Item( 2 ) :=  ''

   lEfeito := .f.


    nQreg := 0
    nRecno := 0  




   //_ReleaseWindow('FormSplash')

   //FormSplash.Hide()

   //CloseWindow(   nHandle1   ) 

    nHandle1  := DoFindWin("Titl1")

    If nHandle1 > 0
       
      //HMG_CallDLL( "User32.dll", DLL_OSAPI, "SetForegroundWindow", nHandle1 )


       SendMessage( nHandle1, WM_SYSCOMMAND, SC_CLOSE , 0 )

       Do Events 
       Do Events 

       SendMessage( nHandle1, WM_SYSCOMMAND, WM_DESTROY , 0 )

       Do Events 


       //SendMessage( nHandle1, WM_DESTROY,0,0)

      

       //msginfo('ok')

       /*
	      cBuffer := Space(512)

	      nCopyCharacters := HMG_CallDLL ("USER32.DLL", HB_DYN_CTYPE_INT, "GetWindowText", nHandle1 , @cBuffer, 512)

         msginfo( cBuffer)
         */

   End If     

   
   BT_ClientAreaInvalidateAll( 'Main' )
   
   SetWindowControlsVisible( 'Main', .t., aM1, .t.  )

   
   Main.Cursor := 'IDC_ARROW'
   

   Main .StatusBar. Item( 2 ) :=  '    ' 






REturn



Function DoMinize()
    Local nHandle1  := DoFindWin("Titl1")

    If nHandle1 > 0
         If  isWindowVisible(nHandle1)
            msginfo('pl2')
         End If    
    End If 


Return 


PROCEDURE DoFindWin(cTitle)
LOCAL nWin := HMG_CallDLL( "User32.dll", DLL_OSAPI, "FindWindow", 0, cTitle)

/*
   If !EMPTY(nWin)
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "SetForegroundWindow", nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "BringWindowToTop", nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "ShowWindow", nWin, 1 )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "UpdateWindow", nWin )
	  msginfo('ok')
   End If 
   */

RETURN nWin 



FUNCTION xRode( cArqT12, cFileCSV  )

   // HB_SETCODPAGE("PT850")
//


   LOCAL aMap := {}
   LOCAL a1
   LOCAL cCampo
   LOCAL cTipo
   LOCAL nPos
   LOCAL c1
   LOCAL aZ1  := {}
   Local oQuery
   LOCAL cData
   
   LOCAL nSeq  := 0

   Local cTabela := 'Clientes'

   Local nMaxCol := 0



   LOCAL zk

   LOCAL aMap1 := {}
   LOCAL aValores := {}


    //Main.Cursor := 'Hourglass.Cur'

   // fProgress.CURSOR := 'Hourglass.Cur'

   aMap := TextToArray( MemoRead(    cArqt12 ) )

   c1 := ''




   For n1 := 1 TO Len( aMap )

      If !Empty( AllTrim(    aMap[ n1 ]  ) )

         a1 := hb_ATokens( aMap[ n1 ], ',' )


         If Len( a1 ) > 0

            cCampo := a1[ 1 ]

            nPos   := Val( a1[ 2 ] )

            If (nMaxCol < nPos)
               nMaxCol := nPos
            End If 

            cTipo  := a1[ 3 ]

            c1 += ( AllTrim( cCampo ) + "," ) + QUEBRA

            AAdd( aMap1, { nPos, cTipo, cCampo }  )

         End If

      End If

   Next

   //msginfo(Str(   nMaxCol ))


   cVal := ''


   aCsv := TextToArray( MemoRead(    cFileCSV  ) )



   For n1 := 1 TO Len( aCsv )

      If (!Empty( AllTrim(  aCsv[ n1 ] ) ))

         If At(";" ,  AllTrim(  aCsv[ n1 ] )) > 0
                   
         End If 

         aZ1  := hb_ATokens( aCsv[ n1 ]  ,  ';' )      


         If (Len(aZ1) == nMaxCol)          
 
            cVal := ''         


            FOR zK := 1 TO Len( aMap1 )

               cTipo := aMap1[ zk ][ 2 ]

               If At( '"', az1[ aMap1[ zk ][ 1 ]   ] ) == 0

                  If cTipo = 'D'
                     cData        := Left( AllTrim( az1[ aMap1[ zk ][ 1 ]   ] ), 4 ) + "-" + ;
                        SubStr(  AllTrim( az1[ aMap1[ zk ][ 1 ]   ] ), 5, 2  ) + "-" + ;
                        Right( AllTrim( az1[ aMap1[ zk ][ 1 ]   ] ), 2 )


                     cVal += '"'  +  cData +  '"'  +  ","

                  End If


                  If cTipo = 'N'

                  End If


                  If cTipo = 'C'
                     cVal += '"'  + AllTrim( az1[ aMap1[ zk ][ 1 ]   ]    ) +  '"'  +  "," + QUEBRA
                  End If

               Else
                  cVal += (  '"'   +  AllTrim( xRemoveAs( az1[ aMap1[ zk ][ 1 ]   ]  ) ) +   '"'  +  ","  + QUEBRA )
               End If

            Next


         // AAdd( aValores, Left( cVal, Len( cVal ) - 2  )    )
            // Do Events


            nSeq++

            cSql := "Insert Into " + AllTrim(  cTabela ) +  "(codigo," + Left( c1, Len( c1 ) - 3 )  + ") Values (" + QuotedStr( StrZero( nSeq, 6 ) ) + "," + ;
               Left( cVal, Len( cVal ) - 3 )  + ")"


            oQuery := oServerDb:Query( cSql )   

            Hb_memoWrit( 'csql.txt', Hb_memoRead('csql.txt') + Chr(13)+chr(10)  + cSql + Chr(13)+chr(10)  )

            
            nRecno++
            If oQuery:NetErr()						      
               Hb_memoWrit( 'sqlError.txt', Hb_memoRead('sqlError.txt') + Chr(13)+chr(10)  + cSql + Chr(13)+chr(10) +  oQuery:Error() )
               MsgInfo( Hb_AnsiToOem('Erro ao Executar Atualização -> ') + Chr( 13 ) + Chr( 10 ) + oQuery:Error()  + Chr(13)+chr(10) )		               
               Return 
            End If    

            oQuery:Destroy()
            oQuery := NIL

         Else 
            nQReg++
         End If 

      End If




      nTotal   := Len( aCsv )
      nPerCent := n1

      *//Atualiza Andamento a Cada  100 registros importados.


      If (nRecno = 10)

         nContador++

         If nContador > 12
            nContador := 1
         End If

         nRecno := 0

         BT_ClientAreaInvalidateAll('FormSplash')

      End If 

      
      
      Do Events

      //hb_idleSleep( 0.05 )



   Next

   lTermino := .t.






   // SetWindowCursor( GetFormHandle( 'Main' ), IDC_ARROW )
   // SetWindowCursor( GetFormHandle( 'fProgress' ), IDC_ARROW )

RETURN


FUNCTION xRemoveAs(   cCar   )

   LOCAL cStr1 :=  AllTrim( Right( cCar, Len( cCar ) - 1 ) )
   LOCAL cStr2 := Left( cStr1, Len( cStr1 ) - 1 )

RETURN cStr2



Function GetConexao()

   LOCAL oServer
   LOCAL lRet
   LOCAL oQuery

   oServer := TMySQLServer():New( cServer, cUserDb, cPassDb )

   If oServer:NetErr()
      MsGInfo( "Error ao Conectar SQL Server: " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   End If

   oServer:SelectDB( cDataBase )

   If oServer:NetErr()
      MsGInfo( "Error ao Conectar Banco " + cBanco + " : " + QUEBRA + oServer:Error() )
      RELEASE Window ALL
      QUIT
   End If

   Main .StatusBar. Item( 1 ) := 'Conectado em ' + cServer +  "|" + Alltrim( cDataBase )

Return ( oServer )


STATIC FUNCTION TextToArray( cString )

  

RETURN hb_ATokens( StrTran( cString, Chr( 13 ) ), Chr( 10 ) )





FUNCTION fTiraChar( wCampo )

   // // Remover Caracteres Especiais (/,*)

   LOCAL lRet  := .T.
   LOCAL cStr1 := ''
   LOCAL i     := 1 // '

   For i := 1 TO Len( wCampo )
      If  SubStr( wCampo, i, 1 ) == "'" .OR. SubStr( wCampo, i, 1 ) == '"'  .OR. SubStr( wCampo, i, 1 ) == ")" .OR. SubStr( wCampo, i, 1 ) == "(" .OR. SubStr( wCampo, i, 1 ) == "*" .OR. SubStr( wCampo, i, 1 ) == "/"  .OR. SubStr( wCampo, i, 1 ) == "\"  .OR. SubStr( wCampo, i, 1 ) == '%' .OR. SubStr( wCampo, i, 1 ) == "-" .or. ;
          SubStr( wCampo, i, 1 ) == ";" .OR. SubStr( wCampo, i, 1 ) == ',' 

      Else
         cStr1 += SubStr( wCampo, i, 1 )
      End If
   Next i

Return cStr1



FUNCTION QuotedStr( cVar )
Return '"' + cVar + '"'

function SetWindowControlsVisible( cForm, lVisible, aMVisible, lShow  )

   Local aControlList := {}
   Local i        := 0
   Local cCompo   := ''
   Local aM1      := {}
   Local lVisi2 := .f.
   Local nIndice := 0

   Default aMVisible := {}
   Default lShow     := .f.


// sysWait(.1)


   For i := 1 to Len( _HMG_SYSDATA[ 4 ] )
      If _HMG_SYSDATA[ 4, i ] == GetFormHandle( cForm )
         If len( alltrim( _HMG_SYSDATA[  2,i ] ) ) > 0

            lVisi2 := GetProperty( cForm, _HMG_SYSDATA[  2, i ], "Visible"  )

            If lVisible

               nIndice := Ascan( aMVisible, {| a, b | ( a[ 1 ] == cForm ) .And. ( a[ 2 ] == _HMG_SYSDATA[  2,i ] )  }  )

               If ( Len( aMVisible ) > 0 ) .And. ( nIndice > 0 )
                  Setproperty( cForm, _HMG_SYSDATA[  2, i ], "Visible", aMVisible[ nIndice ][ 3 ] )

                  If ( lShow ) .And. ( aMVisible[ nIndice ][ 3 ] )
                     DoMethod( cForm,   _HMG_SYSDATA[  2, i ], "Show" )
                  End If

               End If

            Else
               Aadd( aM1, {   cForm, _HMG_SYSDATA[  2, i ],  lVisi2 } )
               Setproperty( cForm, _HMG_SYSDATA[  2, i ], "Visible", lVisible )
            End If

            cCompo += ( cForm + ' ' +  _HMG_SYSDATA[  2, i ] )  + QUEBRA

         End If
      End If
   Next i

   hb_memowrit( 'compo1.txt', cCompo )

Return aM1



