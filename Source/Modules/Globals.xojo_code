#tag Module
Protected Module Globals
	#tag Method, Flags = &h0
		Function Fix(Value As Double) As Double
		  
		  Return Sign( Value ) * Floor( Abs( Value ) )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Using(inValue As Double, inFormat As String) As String
		  
		  Const kSpaces = "          " // 10 Spaces
		  
		  #If RBVersion >= 2011 Then
		    
		    Return Right( kSpaces + Str( inValue, inFormat ), inFormat.Len )
		    
		  #Else
		    
		    Return Right( kSpaces + Format( inValue, inFormat ), inFormat.Len )
		    
		  #EndIf
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		DA As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		DD As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		DX As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		DY As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		RS As Double = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		TX As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		V0 As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		WB As Double
	#tag EndProperty


	#tag Constant, Name = k1RadInDeg, Type = Double, Dynamic = False, Default = \"57.2957795", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="DA"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DD"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DX"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DY"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
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
			Name="RS"
			Group="Behavior"
			InitialValue="1"
			Type="Double"
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
		#tag ViewProperty
			Name="TX"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="V0"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WB"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
