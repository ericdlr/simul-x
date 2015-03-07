#tag Class
Protected Class FlightAbortException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Function AbortReason() As FlightAbortException.Reason
		  
		  Return Self.pAbortReason
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(inReason As FlightAbortException.Reason)
		  
		  Self.pAbortReason = inReason
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		pAbortReason As FlightAbortException.Reason
	#tag EndProperty


	#tag Enum, Name = Reason, Type = Integer, Flags = &h0
		Landed
		  GearsUpWhileOnGround
		  FullThrustWhileBrakesOn
		  RolledOfDecisionPoint
		  RanOutOfTheRunway
		  Crash
		  TouchGroundBeforeRunway
		  OutOfFuel
		  BrakesOnWhileGearsUp
		  FailedInCrucialManeuvers
		TakeoffAbortion
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="pAbortReason"
			Group="Behavior"
			Type="FlightAbortException.Reason"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Reason"
			Group="Behavior"
			Type="Text"
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
