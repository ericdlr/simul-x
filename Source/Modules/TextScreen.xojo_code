#tag Module
Protected Module TextScreen
	#tag Method, Flags = &h1
		Protected Sub DrawChar(Character As String, g As Graphics, x As Integer, y As Integer)
		  
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  Dim TheCharCode As Integer = Asc( Character ) - 32
		  
		  // Draw the character
		  If TheCharCode > -1 AND theCharCode <= TextScreen.CharsCache.Ubound Then
		    
		    // Draw the Character
		    g.DrawPicture CharsCache( TheCharCode ), x, y
		    
		  Else
		    
		    // Draw a space
		    g.DrawPicture TextScreen.CharsCache( 0 ), x, y
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStringPicture(Text As String, Ink As Color = &c000000) As Picture
		  
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  Dim theCharCount As Integer = Len( Text )
		  Dim thePicture As New Picture( TextScreen.kCharWidth * theCharCount, TextScreen.kCharHeight, 32 )
		  
		  // Precondition test
		  If thePicture Is Nil Then
		    
		    Return Nil
		    
		  End If
		  
		  If theCharCount = 0 Then
		    
		    Return thePicture
		    
		  End If
		  
		  Dim g As Graphics = thePicture.Graphics
		  
		  g = thePicture.Graphics
		  g.ForeColor = Ink
		  g.FillRect 0, 0, g.width, g.height
		  
		  g = thePicture.Mask.Graphics
		  
		  // Draw the characters
		  For CharNumber As Integer = 1 to theCharCount
		    
		    TextScreen.DrawChar Text.Mid( CharNumber, 1 ), g, ( CharNumber - 1 ) * TextScreen.kCharWidth, 0
		    
		  Next
		  
		  Return thePicture
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub InitCache()
		  
		  // Getting the memory block
		  Dim theMemoryBlock As MemoryBlock = DecodeBase64( TextScreen.kCharMatrix )
		  Dim theCharCount As Integer = theMemoryBlock.Size \ TextScreen.kCharHeight
		  
		  Redim TextScreen.CharsCache( theCharCount )
		  
		  For Offset As Integer = 0 To theMemoryBlock.Size - 1 Step TextScreen.kCharHeight
		    
		    // Creating the Char picture
		    Dim theCharPicture As New Picture( TextScreen.kCharWidth, TextScreen.kCharHeight, 1 )
		    
		    If Not ( theCharPicture Is Nil ) Then
		      
		      Dim theGraphics As Graphics = theCharPicture.Graphics
		      
		      For Line As Integer = 0 To TextScreen.kCharHeight - 1
		        
		        Dim LineBlock As Byte = theMemoryBlock.Byte( Offset + Line )
		        
		        For Bit As Integer = 0 To 5
		          
		          // Determinig the color
		          Dim theColor As Color
		          
		          If Bitwise.BitAnd( LineBlock, 2^Bit ) > 0 Then
		            
		            theColor = &c000000
		            
		          Else
		            
		            theColor = &cFFFFFF
		            
		          End If
		          
		          // Draw the pixel
		          #If Not TargetCocoa Then
		            
		            // Set the pixel to the selected color
		            theGraphics.Pixel( 5 - Bit, Line ) = theColor
		            
		          #Else
		            
		            // This is a workaround as Graphics.Pixel doesn't work on Cocoa.
		            theGraphics.ForeColor = theColor
		            theGraphics.FillRect 5 - Bit, Line, 1, 1
		            
		          #EndIf
		          
		        Next
		        
		        TextScreen.CharsCache( Offset \ TextScreen.kCharHeight ) = theCharPicture
		        
		      Next
		      
		    Else
		      
		      #pragma warning "Needs to Handle 'theCharPicture Is Nil' error"
		      
		    End If
		    
		  Next
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected CharsCache() As Picture
	#tag EndProperty


	#tag Constant, Name = kCharHeight, Type = Double, Dynamic = False, Default = \"10", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCharMatrix, Type = String, Dynamic = False, Default = \"AAAAAAAAAAAAAAAICAgICAAIAAAACgoAAAAAAAAAAAoKHwofCgoAAAAEDhQOBRUOBAAAABgZAgQI\rEwMAAAgUFAgVEg0AAAAMBAgAAAAAAAAAAgQEBAQEAgAAABAICAgICBAAAAAAAAoEHwQKAAAAAAAE\rBB8EBAAAAAAAAAAAGAgQAAAAAAAAHwAAAAAAAAAAAAAMDAAAAAABAgQIEAAAAAAOERMVGREOAAAA\rBAwEBAQEDgAAAA4RAQ4QEB8AAAAOEQEGAREOAAAAEBASEh8CAgAAAB8QHgEBEQ4AAAAGCBAeEREO\rAAAAHwECBAgICAAAAA4REQ4REQ4AAAAOEREPAQIMAAAAAAAYGAAYGAAAAAAAGBgAGAgQAAAAAAQI\rEAgEAAAAAAAAHgAeAAAAAAAAEAgECBAAAAAOEQEGBAAEAAAADhMVFRYQDgAAAAQKEREfEREAAAAe\rER4REREeAAAADhEQEBARDgAAABwSERERER4AAAAfEB4QEBAfAAAAHxAeEBAQEAAAAA4REBcREQ8A\rAAARER8RERERAAAADgQEBAQEDgAAAA8CAgICEgwAAAAREhQYFBIRAAAAEBAQEBAQHwAAABEbFRER\rEREAAAARGRUTERERAAAADhERERERDgAAAB4RER4QEBAAAAAOERERFRINAAAAHhERHhQSEQAAAA4R\rEA4BEQ4AAAAfBAQEBAQEAAAAERERERETDQAAABERERERCgQAAAARERERFRsRAAAAEREKBAoREQAA\rABERCgQEBAQAAAAfAQIECBAfAAAADggICAgIDgAAAAAQCAQCAQAAAAAcBAQEBAQcAAAAAwQJCgoJ\rBAMAAAAAAAAAAD8AAAAGCQgeCAgPAAAAAAANExERDwAAABAQFhkRER4AAAAAAA4REBEOAAAAAQEN\rExERDwAAAAAADhEfEA4AAAAABgkIHggIAAAAAAANExERDwEOABAQFhkREREAAAAABAAEBAQEAAAA\rAAIAAgICAhIMABASFBgUEhEAAAAICAgICAgGAAAAAAAaFRUVFQAAAAAAFhkREREAAAAAAA4REREO\rAAAAAAAWGRERHhAQAAAADRMREQ8BAQAAABYZEBAQAAAAAAAOEA4BDgAAAAAIHwgICQYAAAAAABER\rERMNAAAAAAAREREKBAAAAAAAEREVGxEAAAAAABEKBAoRAAAAAAARERERDwEOAAAAHwIECB8AAAAA\rAAQCHwIEAAAAAAAECB8IBAAAAAAABA4VBAQAAAAAAAQEFQ4EAAAAMAgkBAQkCDAAAAAAAAAAAAAA\rADg4ODg4AAAAAAAHBwcHBwAAAAAAPz8/Pz8AAAAAAAAAAAAAODg4ODg4ODg4ODg4ODg4BwcHBwc4\rODg4OD8/Pz8/ODg4ODgAAAAAAAcHBwcHODg4ODgHBwcHBwcHBwcHBwcHBwc/Pz8/PwcHBwcHAAAA\rAAA/Pz8/Pzg4ODg4Pz8/Pz8HBwcHBz8/Pz8/Pz8/Pz8/Pz8/PyoqKioqKioqKio/AD8APwA/AD8A\rKhUqFSoVKhUqFR4ICAgICAgfAAA7EQoEBCQkLgAAOAwKCQgICBwAAD8SERAwERIXAAAcCBAgIBAI\rHAAAAxsYADc3BwcAAAAAGBgAAAAAAAA\x3D", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCharWidth, Type = Double, Dynamic = False, Default = \"6", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
