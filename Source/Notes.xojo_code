#tag Module
Protected Module Notes
	#tag Note, Name = Read Me
		
		
	#tag EndNote

	#tag Note, Name = ToDoList
		
		- Implement the VOR Range as an enumeration.
		- Redesign the wind influence mechanism to induce a translation ( wind has a speed and a heading ) rather than modifying the airspeed and compass.
		- Implement a mechabism similar to flight recorder and a way to play it back.
	#tag EndNote


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
