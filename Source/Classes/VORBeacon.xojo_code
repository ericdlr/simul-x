#tag Class
Protected Class VORBeacon
	#tag Property, Flags = &h0
		Airport As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Altitude As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Frequency As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Indicatif As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Latitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Longitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		RunwayRadial As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Airport"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Altitude"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Frequency"
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
			Name="Indicatif"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Latitude"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Longitude"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunwayRadial"
			Group="Behavior"
			Type="Integer"
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
End Class
#tag EndClass
