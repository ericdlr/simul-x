#tag Class
Protected Class Plane
Inherits Thread
	#tag Event
		Sub Run()
		  
		  // Starting the Plane
		  System.DebugLog CurrentMethodName + " --- Starting the plane ---"
		  // Self.UpdateCurrentTime
		  // Self.LastTime = Self.CurrentTime
		  
		  Do
		    
		    Select Case Self.CurrentMode
		      
		    Case Plane.Mode.Takeoff
		      
		      Self.ModuleTakeOff
		      
		    Case Plane.Mode.Cruising
		      
		      Self.ModuleCruise
		      
		    Case Plane.Mode.Landing
		      
		      Self.ModuleLanding
		      
		    Case Plane.Mode.Landed
		      
		      // The plane is landed, we can exit the loop
		      Exit Do
		      
		    End Select
		    
		  Loop
		  
		  // Here, we have finished the flight
		  
		  // Catching FlightAbortException
		Exception theException As FlightAbortException
		  
		  Select Case theException.AbortReason
		    
		  Case FlightAbortException.Reason.GearsUpWhileOnGround
		    Self.AbortedFlyMessage = "It's better for the aircraft to stand on its landing  gear."
		    
		  Case FlightAbortException.Reason.FullThrustWhileBrakesOn
		    Self.AbortedFlyMessage = "You must release the brakes before setting the thrust to FULL"
		    
		  Case FlightAbortException.Reason.RolledOfDecisionPoint
		    Self.AbortedFlyMessage = "You rolled off the decision point for takeoff without action."
		    
		  Case FlightAbortException.Reason.RanOutOfTheRunway
		    Dim theMessage() As String
		    theMessage.Append "You ran out of the runway"
		    
		    If Abs( Self.GroundX ) > 100.0 Then
		      
		      theMessage.Append Format( Self.GroundX, "##0.00" ) + " Feet from the center line"
		      
		    End If
		    
		    If Self.GroundY > 10500.0 Then
		      theMessage.Append " " + Format( Self.GroundY - 10500.0, "###,##0.00" ) + " Feet past end of the runway"
		      
		    ElseIf Self.GroundY < -9500.0 Then
		      theMessage.Append " " + Format( Abs( Self.GroundY ) - 9500, "###,##0.00" ) + " Feet past end of the runway"
		      
		    End If
		    
		    Self.AbortedFlyMessage = Join( theMessage, EndOfLine ) + "."
		    
		    
		  Case FlightAbortException.Reason.FailedInCrucialManeuvers
		    Self.AbortedFlyMessage = "You failed in crucial maneuvers:" + EndOfLine _
		    + "  1 - Landing gear raised below 400 Ft" + EndOfLine _
		    + "  2 - Flaps to be retracted below 240 Kts" + EndOfLine _
		    + "  3 - Flaps to be set bellow 200 Kts" + EndOfLine _
		    + "  4 - Thrust reduce above 1500 Fts" + EndOfLine _
		    + "  5 - Thrust reduce below 2000 Fts" + EndOfLine _
		    + "  6 - Speed must not exceed 950 Kts"
		    
		  Case FlightAbortException.Reason.Crash
		    Self.AbortedFlyMessage = "You flew into the ground..."
		    
		  Case FlightAbortException.Reason.TouchGroundBeforeRunway
		    Self.AbortedFlyMessage = "You touch the ground before the runway..."
		    
		  Case FlightAbortException.Reason.OutOfFuel
		    Self.AbortedFlyMessage = "You are out of fuel..."
		    
		  Case FlightAbortException.Reason.BrakesOnWhileGearsUp
		    Self.AbortedFlyMessage = " You try to set the brakes when gears are up..."
		    
		  Else
		    Self.AbortedFlyMessage = "Unknown reason !!!"
		    
		  End Select
		  
		  System.DebugLog CurrentMethodName + ": " + Self.AbortedFlyMessage.ReplaceAll( EndOfLine, " & " )
		  Self.CurrentMode = Plane.Mode.FlyAborted
		  
		  // End of the fly
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AbortLanding()
		  
		  // Sets the flag to inform the plane that the pilot is aborting the landing
		  
		  Self.FlagAbortLanding = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AutoSelectVOR()
		  
		  Self.FlagAutoSelectVOR = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  If Plane.KnownVOR.Ubound < 0 Then
		    
		    Plane.InitKnownVORs
		    
		  End If
		  
		  If Ubound( Plane.WindTable, 1 ) < 0 Then
		    
		    Plane.SetupWindTable
		    
		  End If
		  
		  Self.VORRange = "OUT "
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  
		  System.DebugLog CurrentMethodName + " BYE BYE !!!"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleCourseTracking()
		  
		  If Abs( Self.Compass - Self.Course ) < 0.5 Then // Goto 3540
		    
		    // There is less than a degree, so no more course tracking needed
		    Self.CourseTracking = False
		    Self.Compass = Self.Course
		    
		  Else
		    // We have to normalize the course
		    
		    Dim theNormalizedCourse As Double
		    theNormalizedCourse = Self.Course - Self.Compass
		    If theNormalizedCourse < 0 Then theNormalizedCourse = theNormalizedCourse + 360
		    
		    Dim theRotationDirection As Integer
		    Dim theCourseDiff As Double
		    
		    If theNormalizedCourse > 180.0 Then
		      
		      // Setting the rotation to left
		      theRotationDirection = -1
		      theCourseDiff = 360 - theNormalizedCourse
		      
		    Else
		      
		      // Setting the rotation to right
		      theRotationDirection = 1
		      theCourseDiff = theNormalizedCourse
		      
		    End If
		    
		    // Calculating the rotation rate
		    Dim theRotationRate As Double
		    
		    // Determining the rotation rate needed
		    // Original listing line 3500
		    If theCourseDiff > 20 Then
		      
		      theRotationRate = theRotationDirection * 10.0
		      
		    Elseif theCourseDiff > 10 Then
		      
		      theRotationRate = theRotationDirection * 5.0
		      
		    Elseif theCourseDiff > 5 Then
		      
		      theRotationRate = theRotationDirection * 2.5
		      
		    Elseif theCourseDiff > 2.5 Then
		      
		      theRotationRate = theRotationDirection * 1.0
		      
		    Else
		      
		      theRotationRate = theRotationDirection * 0.5
		      
		    End
		    
		    // Correcting the compass
		    // Original listing line 3530
		    Self.Compass = Self.Compass + theRotationRate * Self.TimeInterval
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub InitKnownVORs()
		  
		  // Paris Orly "OL "
		  Dim theVOR As New VORBeacon
		  
		  theVOR.Airport = "Orly"
		  theVOR.Indicatif = "OL"
		  theVOR.Latitude = 48.7166
		  theVOR.Longitude = 2.3833
		  theVOR.Frequency = 111.2
		  theVOR.Altitude = 285
		  theVOR.RunwayRadial = 281
		  
		  Plane.KnownVOR.Append theVOR
		  
		  // Lyon "LYO"
		  theVOR = New VORBeacon
		  
		  theVOR.Airport = "Lyon"
		  theVOR.Indicatif = "LYO"
		  theVOR.Latitude = 45.75
		  theVOR.Longitude = 4.95
		  theVOR.Frequency = 116.3
		  theVOR.Altitude = 636
		  theVOR.RunwayRadial = 168
		  
		  Plane.KnownVOR.Append theVOR
		  
		  // Marseille "MBO"
		  theVOR = New VORBeacon
		  
		  theVOR.Airport = "Marseille"
		  theVOR.Indicatif = "MBO"
		  theVOR.Latitude = 43.45
		  theVOR.Longitude = 5.2
		  theVOR.Frequency = 117.1
		  theVOR.Altitude = 66
		  theVOR.RunwayRadial = 138
		  
		  Plane.KnownVOR.Append theVOR
		  
		  // Milan "SRN"
		  theVOR = New VORBeacon
		  
		  theVOR.Airport = "Milano"
		  theVOR.Indicatif = "SRN"
		  theVOR.Latitude = 45.63301
		  theVOR.Longitude = 8.7
		  theVOR.Frequency = 113.7
		  theVOR.Altitude = 691
		  theVOR.RunwayRadial = 352
		  
		  Plane.KnownVOR.Append theVOR
		  
		  // Bruxelles "BUB"
		  theVOR = New VORBeacon
		  
		  theVOR.Airport = "Bruxelles"
		  theVOR.Indicatif = "BUB"
		  theVOR.Latitude = 50.9
		  theVOR.Longitude = 4.4833
		  theVOR.Frequency = 114.6
		  theVOR.Altitude = 164
		  theVOR.RunwayRadial = 76
		  
		  Plane.KnownVOR.Append theVOR
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ModuleCruise()
		  
		  System.DebugLog CurrentMethodName + " --- Entering cruise mode ---"
		  
		  // Clear runway on display ( Original listing line 3390 )
		  Self.VisualOnRunway = False
		  
		  // Cruise loop
		  Do
		    
		    // Display updated values
		    Self.UpdateFuelAirSpeedVertSpeed
		    
		    // This part is now handled by the situation routine
		    '// Handle the course tracking
		    'If Self.CourseTracking Then Self.HandleCourseTracking
		    
		    // Original listing line 3540
		    Dim theWindIndex As Integer = Self.Altitude \ 4000
		    
		    If theWindIndex >= 10 Then theWindIndex = 10
		    
		    Self.AirSpeed = Self.AirSpeed + Plane.WindTable( theWindIndex, 1 )
		    Self.Compass = Self.Compass + Plane.WindTable( theWindIndex, 0 )
		    
		    If Self.Compass > 360 Then Self.Compass = Self.Compass - 360
		    If Self.Compass <= 0 Then Self.Compass = 360 + Self.Compass
		    
		    // Original listing line 3600
		    Self.SituationRoutine
		    
		    theWindIndex = 0
		    If Self.VORFrequency = 0 Then Continue Do
		    
		    // Original listing line 3630
		    If Self.Latitude < Self.VORLatitude + 0.25 And Self.Latitude > Self.VORLatitude - 0.25 Then theWindIndex = theWindIndex + 1
		    If Self.Longitude < Self.VORLongitude + 0.25 And Self.Longitude > Self.VORLongitude - 0.25 Then theWindIndex = theWindIndex + 1
		    If Self.Altitude < 1900 And Self.Altitude > 1700 Then theWindIndex = theWindIndex + 1
		    
		    // Reset the abort landing state if needed
		    If FlagAbortLanding AND Self.Altitude > 1900 Then Self.FlagAbortLanding = False
		    
		    // Originally: 3670 PRINT FNP$(10,71);"  "
		    Self.ILSMarkerOn = False
		    
		    If theWindIndex <> 3 Then Continue Do
		    If Self.FlagAbortLanding Then Continue Do
		    If Self.VORAltitude = 0 Then Continue Do
		    
		    // Originally: 3710 PRINT FNP$(10,71);"##"
		    Self.ILSMarkerOn = True
		    
		    // Original listing line 3720
		    If Self.Compass = Self.VORRadialRunway And Self.VORRange = "FROM" Then
		      
		      // Goto to Landing Module
		      Self.CurrentMode = Plane.Mode.Landing
		      Exit Do
		      
		    End If
		    
		  Loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ModuleLanding()
		  
		  System.DebugLog CurrentMethodName + " --- Entering landing module ---"
		  
		  // Original listing line 4190
		  Self.PosXOnRunway = -1
		  Self.VORSelectedRadial = Self.VORRadialRunway
		  Self.GroundY = 34220.0
		  
		  // Switch on the ILS
		  Self.ILSOn = True
		  If Rnd < 0.5 Then
		    Self.GroundX = -100.0
		    
		  Else
		    Self.GroundX = 100.0
		    
		  End If
		  
		  Do
		    
		    Self.UpdateFuelAirSpeedVertSpeed
		    Self.SituationRoutine
		    
		    // Original Listing line 4260
		    Dim theIntervalDistance As Double = Self.AirSpeed * Self.TimeInterval
		    Dim theAngleRad As Double = ( Self.Compass - Self.VORRadialRunway ) / k1RadInDeg
		    
		    Self.GroundY = Self.GroundY - ( theIntervalDistance * Cos( theAngleRad ) * 1.58 )
		    Self.GroundX = Self.GroundX + ( theIntervalDistance * Sin( theAngleRad ) * 1.58 )
		    
		    Dim EX As Double = Self.GroundY * Sin( 1.0 / k1RadInDeg )
		    If EX < 100.0 Then EX = 100.0
		    
		    Self.ILSCrossX = 7 / EX * Self.GroundX
		    
		    // Normalizing the values
		    If Self.ILSCrossX < -7.0 Then Self.ILSCrossX = -7.0
		    If Self.ILSCrossX > 7.0 Then Self.ILSCrossX = 7.0
		    
		    Self.AltitudeRadar = Self.Altitude - Self.VORAltitude
		    
		    // Deleted: DR = Self.AltitudeRadar - ( Self.GroundY * Sin( 3 / k1RadInDeg ) )
		    
		    Dim ER As Double = Self.GroundY * Sin( 1 / k1RadInDeg )
		    If ER < 50 Then ER = 50
		    
		    // Originally: Self.ILSCrossY = 3 - Floor( 7 / ER * DR )
		    // The deleted DR calculating was incorporated inline
		    Self.ILSCrossY = 7.0 / ER * ( Self.AltitudeRadar - ( Self.GroundY * Sin( 3.0 / k1RadInDeg ) ) )
		    
		    // Normalizing the value
		    If Self.ILSCrossY < -3.0 Then Self.ILSCrossY = -3.0
		    If Self.ILSCrossY > 3.0 Then Self.ILSCrossY = 3.0
		    
		    // Here, there was a call to Set GlideSlope Chrosshair
		    // That is useless in this new code design
		    
		    If Self.GroundY < 3500.0 Then Self.FlagAbortLanding = False
		    
		    If Self.FlagAbortLanding Then
		      
		      Self.Thrust = 2
		      Self.Pitch = 5
		      Self.ILSCrossX = 0
		      Self.ILSCrossY = 0
		      Self.AltitudeRadar = 0
		      
		      // Go to Cruise Module
		      Self.CurrentMode = Plane.Mode.Cruising
		      Return
		      
		    End If
		    
		    // Original list line 4440
		    // Handling the ILS Marker
		    If Self.GroundY < 4500 AND Self.GroundY > 3500 Then
		      
		      Self.ILSMarkerOn = True
		      
		    Else
		      
		      Self.ILSMarkerOn = False
		      
		    End If
		    
		    // Original listing line 4460
		    If Self.AltitudeRadar < 60.0 And Self.Pitch = 0.0 Then Self.AltitudeRadar = 0.0
		    
		    If Self.GroundY < 4000.0 AND NOT Self.VisualOnRunway Then
		      
		      // Display Runway
		      Self.VisualOnRunway = True
		      
		    End If
		    
		    // Are we On the ground?
		    If Not ( Self.AltitudeRadar > 0.0 ) Then
		      
		      // Yes we are on the ground
		      
		      // We can switch the ILS OFF if needed
		      If Self.ILSOn Then ILSOn = False
		      
		      // Checking for errors
		      If Self.AltitudeRadar < 0.0 Then
		        
		        // This is a crash
		        Raise New FlightAbortException( FlightAbortException.Reason.Crash )
		        
		      End If
		      
		      If Self.GroundY < -9500.0 OR Abs( Self.GroundX ) > 100.0 Then
		        
		        // The plane's off the runway
		        Raise New FlightAbortException( FlightAbortException.Reason.RanOutOfTheRunway )
		        
		      End If
		      
		      // Computing the position on the runway
		      Self.PosXOnRunway = 40.0 + Round( Self.GroundX * 22.0 / 100.0 )
		      If Self.PosXOnRunway > 62.0 Then Self.PosXOnRunway = 62.0
		      If Self.PosXOnRunway < 18.0 Then Self.PosXOnRunway = 18.0
		      
		      // Checking for others errors
		      If Not Self.WheelsDown Then
		        
		        // The plane's on the ground an the gear is up
		        Raise New FlightAbortException( FlightAbortException.Reason.GearsUpWhileOnGround )
		        
		      End If
		      
		      If Self.GroundY > 1000.0 Then
		        
		        // Landing too short
		        Raise New FlightAbortException( FlightAbortException.Reason.TouchGroundBeforeRunway )
		        
		      End If
		      
		    End If
		    
		    // Looping the Loop
		  Loop Until Not ( Self.AirSpeed > 0 )
		  
		  // Fin normale du vol
		  Raise New FlightAbortException( FlightAbortException.Reason.Landed )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ModuleTakeOff()
		  
		  System.DebugLog CurrentMethodName + " --- Entering takeoff module ---"
		  
		  // Original listing line 2650
		  
		  // Display Cleared for takeoff message
		  
		  // original listing line 2680
		  // Display Runway
		  Self.VisualOnRunway = True
		  
		  //Original listing line 2690
		  // Self.UpdateCurrentTime
		  // Self.LastTime = Self.CurrentTime
		  
		  // Original listing line 2700
		  Do
		    
		    // Original listing line 2710
		    If Self.BrakesOn Then
		      
		      If Self.Thrust = -1 AND Self.AirSpeed = 0.0 Then
		        
		        // ERROR 4610
		        Raise New FlightAbortException( FlightAbortException.Reason.TakeoffAbortion )
		        
		      End If
		      
		      Self.UpdateFuelAirSpeedVertSpeed
		      Self.SituationRoutine
		      
		      // Loop the loop
		      Continue Do
		      
		    End If
		    
		    // Original listing line 2750
		    If Self.Altitude > 0 Then
		      
		      // Clear the runway's plane position line.
		      // PRINT FNP$(10,18);SPACE$(44)
		      Self.PosXOnRunway = -1
		      
		      // GOTO2850
		      
		    Else
		      
		      If Not Self.WheelsDown Then
		        
		        // ERROR 4660
		        Raise New FlightAbortException( FlightAbortException.Reason.GearsUpWhileOnGround )
		        
		      End If
		      
		      If Self.AirSpeed > 0 AND Self.BrakesOn Then
		        
		        // ERROR 4690
		        Raise New FlightAbortException( FlightAbortException.Reason.FullThrustWhileBrakesOn )
		        
		      End If
		      
		      If Self.GroundY > 6500 AND Self.Thrust = 5 Then
		        
		        // ERROR 4720
		        Raise New FlightAbortException( FlightAbortException.Reason.RolledOfDecisionPoint )
		        
		      End If
		      
		      If Self.GroundY > 10500 Or Abs( Self.GroundX ) > 100 Then
		        
		        // ERROR 4750
		        Raise New FlightAbortException( FlightAbortException.Reason.RanOutOfTheRunway )
		        
		      End If
		      
		      If Self.Airspeed < 150 AND Self.Pitch > 0 Then
		        
		        // ERROR 4720
		        // Raise New FlightAbortException( FlightAbortException.Reason.RolledOfDecisionPoint )
		        
		      End If
		      
		      Self.UpdateFuelAirSpeedVertSpeed
		      Self.SituationRoutine
		      
		      If Self.Airspeed > 150.0 AND Self.Pitch > 0.0 Then Self.Pitch = 5
		      Self.MotionOnRunway
		      
		      // Loop the loop
		      Continue Do
		      
		    End If
		    
		    // Original listing line 2850
		    If Self.Altitude < 1500 AND Self.Thrust < 5 Then
		      
		      // ERROR 4800
		      Raise New FlightAbortException( FlightAbortException.Reason.FailedInCrucialManeuvers )
		      
		    End If
		    
		    If Self.Altitude > 400 AND Self.WheelsDown Then
		      
		      // ERROR 4800
		      Raise New FlightAbortException( FlightAbortException.Reason.FailedInCrucialManeuvers )
		      
		    End If
		    
		    If Not Self.WheelsDown AND Not Self.FlapsDown Then
		      
		      // Goto to cruise module
		      Self.CurrentMode = Plane.Mode.Cruising
		      
		      // Exit the loop, then this module
		      Exit Do
		      
		    End If
		    
		    Self.UpdateFuelAirSpeedVertSpeed
		    Self.SituationRoutine
		    
		    // Original listing line 2900
		  Loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MotionOnRunway()
		  
		  // Source code line 3220
		  If Not ( Self.CurrentTime < TX + 10 ) Then
		    
		    TX = Self.CurrentTime
		    WB = RS * RND
		    Self.Compass = Self.Compass + WB
		    
		  End If
		  
		  // Source code line 3270
		  
		  DA = ( Self.Compass - 81 ) / k1RadInDeg
		  DY = Self.AirSpeed * Cos( DA ) * Self.TimeInterval * 1.58
		  DX = Self.AirSpeed * Sin( DA ) * Self.TimeInterval * 1.58
		  Self.GroundY = Self.GroundY + DY
		  Self.GroundX = Self.GroundX + DX
		  Self.PosXOnRunway = 40 + Floor( Self.GroundX * 22 / 100 )
		  If Self.PosXOnRunway > 62 Then Self.PosXOnRunway = 62
		  If Self.PosXOnRunway < 18 Then Self.PosXOnRunway = 18
		  
		  // Drawing the position of the plane on the screen
		  // Self.TextOutput.PrintAt 10, IA, " "
		  // Self.TextOutput.PrintAt 10, IX, "A"
		  
		  // Useless in this new code design
		  // IA = IX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PitchDown()
		  
		  //-- Going down
		  
		  Self.Pitch = Self.Pitch - 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PitchReset()
		  
		  //-- Violently reset the pitch to 0.
		  //   We need a more progressive way to reset the pitch.
		  
		  Self.Pitch = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PitchUp()
		  
		  //-- Going up
		  
		  Self.Pitch = Self.Pitch + 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCoordinatesDegDec(inLatitude As Double, inLongitude As Double)
		  
		  // To lock access to the properties
		  #pragma DisableBackgroundTasks
		  
		  #pragma Warning "This lacks of normalizing the values"
		  
		  Self.Latitude = inLatitude
		  Self.Longitude = inLongitude
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCoordinatesDegMin(inLatitudeDeg As Integer, inLatitudeMin As Double, inLongitudeDeg As Integer, inLongitudeMin As Double)
		  
		  // To lock access to the properties
		  #pragma DisableBackgroundTasks
		  
		  #pragma Warning "This lacks of normalizing the values"
		  
		  // Convert the values to degrees decimal and store them
		  Self.Latitude = inLatitudeDeg + ( inLatitudeMin / 60.0 )
		  Self.Longitude = inLongitudeDeg + ( inLongitudeMin / 60.0 )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetNewCourse(inNewCourse As Double)
		  
		  //-- Setting a new course
		  
		  // Normalizing the input
		  Dim theNewCourse As Double = inNewCourse Mod 360
		  
		  If theNewCourse < 0.0 Then
		    
		    theNewCourse = theNewCourse + 360
		    
		  End If
		  
		  // Storing the normalized value
		  Self.Course = theNewCourse
		  
		  // Activating the course tracker
		  Self.CourseTracking = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetupForCruiseTraining()
		  
		  #pragma DisableBackgroundTasks
		  
		  // Set the position in space
		  Self.SetCoordinatesDegMin( 50, 0.0, 4, 0.0 )
		  Self.GroundX = 0.0
		  Self.GroundY = 0.0
		  Self.PosXOnRunway = 40.0
		  Self.Altitude = 1800.0
		  
		  // Set the dynamic state
		  Self.AirSpeed = 250.0
		  Self.VerticalSpeed = 0.0
		  
		  // Set the Heading data
		  Self.Compass = 19.0
		  Self.Course = 0.0
		  Self.CourseTracking = False
		  
		  // Set the attitude
		  Self.Pitch = 0.0
		  
		  // Set the energy resource
		  Self.Fuel = 20000.0
		  Self.FuelPercent = 87.0
		  
		  // Setup the commands
		  Self.FlapsDown = False
		  Self.WheelsDown = False
		  Self.BrakesOn = False
		  Self.Thrust = 1
		  
		  // Set the radio navigation
		  Self.AltitudeRadar = 0.0
		  
		  Self.VORFrequency = 114.6
		  Self.VORLatitude = 0.0
		  Self.VORLongitude = 0.0
		  Self.VORAltitude = 0.0
		  Self.VORSelectedRadial = 19.0
		  Self.VORDeviation = 0.0
		  Self.VORRadialRunway = 0.0
		  Self.VORRange = "OUT "
		  
		  Self.ILSCrossX = 0.0
		  Self.ILSCrossY = 0.0
		  Self.ILSMarkerOn = False
		  Self.ILSOn = False
		  
		  // Set misc propeties
		  Self.FlagAbortLanding = False
		  Self.LastTime = 0.0
		  Self.TimeInterval = 0.0
		  Self.VisualOnRunway = True
		  
		  // Set the phase
		  Self.CurrentMode = Plane.Mode.Cruising
		  
		  // We are ready to go...
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetupForLandingTraining()
		  
		  #pragma DisableBackgroundTasks
		  
		  // Set the position in space
		  Self.SetCoordinatesDegMin( 50, 47.0, 4, 18.0 )
		  Self.GroundX = 0.0
		  Self.GroundY = 0.0
		  Self.PosXOnRunway = 40.0
		  Self.Altitude = 1800.0
		  
		  // Set the dynamic state
		  Self.AirSpeed = 250.0
		  Self.VerticalSpeed = 0.0
		  
		  // Set the Heading data
		  Self.Compass = 45.0
		  Self.Course = 0.0
		  Self.CourseTracking = False
		  
		  // Set the attitude
		  Self.Pitch = 0.0
		  
		  // Set the energy resource
		  Self.Fuel = 20000.0
		  Self.FuelPercent = 87.0
		  
		  // Setup the commands
		  Self.FlapsDown = False
		  Self.WheelsDown = False
		  Self.BrakesOn = False
		  Self.Thrust = 1
		  
		  // Set the radio navigation
		  Self.AltitudeRadar = 0.0
		  
		  Self.VORFrequency = 114.6
		  Self.VORLatitude = 0.0
		  Self.VORLongitude = 0.0
		  Self.VORAltitude = 0.0
		  Self.VORSelectedRadial = 45.0
		  Self.VORDeviation = 0.0
		  Self.VORRadialRunway = 0.0
		  Self.VORRange = "OUT "
		  
		  Self.ILSCrossX = 0.0
		  Self.ILSCrossY = 0.0
		  Self.ILSMarkerOn = False
		  Self.ILSOn = False
		  
		  // Set misc propeties
		  Self.FlagAbortLanding = False
		  Self.LastTime = 0.0
		  Self.TimeInterval = 0.0
		  Self.VisualOnRunway = True
		  
		  // Set the phase
		  Self.CurrentMode = Plane.Mode.Cruising
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetupForNormalOps()
		  
		  #pragma DisableBackgroundTasks
		  
		  // Set the position in space
		  Self.SetCoordinatesDegMin( 48, 43.0, 2, 23.0 )
		  Self.GroundX = 0.0
		  Self.GroundY = 0.0
		  Self.PosXOnRunway = 40.0
		  Self.Altitude = 0.0
		  
		  // Set the dynamic state
		  Self.AirSpeed = 0.0
		  Self.VerticalSpeed = 0.0
		  
		  // Set the Heading data
		  Self.Compass = 81.0
		  Self.Course = 0.0
		  Self.CourseTracking = False
		  
		  // Set the attitude
		  Self.Pitch = 0.0
		  
		  // Set the energy resource
		  Self.Fuel = 20000.0
		  Self.FuelPercent = 87.0
		  
		  // Setup the commands
		  Self.FlapsDown = True
		  Self.WheelsDown = True
		  Self.BrakesOn = True
		  Self.Thrust = 0
		  
		  // Set the radio navigation
		  Self.AltitudeRadar = 0.0
		  
		  Self.VORFrequency = 0.0
		  Self.VORLatitude = 0.0
		  Self.VORLongitude = 0.0
		  Self.VORAltitude = 0.0
		  Self.VORSelectedRadial = 0.0
		  Self.VORDeviation = 0.0
		  Self.VORRadialRunway = 0.0
		  Self.VORRange = "OUT "
		  
		  Self.ILSCrossX = 0.0
		  Self.ILSCrossY = 0.0
		  Self.ILSMarkerOn = False
		  Self.ILSOn = False
		  
		  // Set misc propeties
		  Self.FlagAbortLanding = False
		  Self.LastTime = 0.0
		  Self.TimeInterval = 0.0
		  Self.VisualOnRunway = True
		  
		  // Set the phase
		  Self.CurrentMode = Plane.Mode.Takeoff
		  
		  // We are ready to go...
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetupForTakeoffTraining()
		  
		  Self.SetupForNormalOps
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub SetupWindTable()
		  
		  Redim Plane.WindTable( 10, 1 )
		  
		  Dim theRND As New Random
		  theRND.Seed = Microseconds * Ticks
		  
		  If theRND.Number < 0.5 Then RS = -1
		  Dim i As Integer
		  
		  For i = 0 to 10
		    
		    Plane.WindTable( i, 0 ) = theRND.Number / 4
		    
		  Next
		  
		  For i = 4 to 6
		    
		    Plane.WindTable( i, 0 ) = Plane.WindTable( i, 0 ) * RS
		    
		  Next
		  
		  For i = 1 to 10
		    
		    Plane.WindTable( i, 1 ) = Floor( 10*theRND.Number )
		    
		  Next
		  
		  For i = 4 to 6
		    
		    Plane.WindTable( i, 1 ) = Plane.WindTable( i, 1 ) * RS
		    
		  Next
		  
		  Plane.WindTable( 0, 0 ) = 0.0
		  Plane.WindTable( 0, 1 ) = 0.0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetVORBeacon(inVORBeacon As VORBeacon, inRadial As Double)
		  
		  If inVORBeacon Is Nil Then
		    
		    Self.VORFrequency = 0.0
		    Self.VORSelectedRadial = 0.0
		    Self.VORRange = "OUT "
		    
		  Else
		    
		    Self.VORFrequency = inVORBeacon.Frequency
		    Self.VORSelectedRadial = inRadial
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SituationRoutine()
		  
		  Static theDME As Double
		  
		  // Added: Process the tracking if needed
		  // This was move in order to have it processed in all modules
		  If Self.CourseTracking Then
		    // Handle the course tracking
		    Self.HandleCourseTracking
		    
		  End
		  
		  // Original listing line 3750
		  ' Dim VV As Double = ( Self.AirSpeed * ( 1 + ( Self.Altitude / 40000.0 ) ) )
		  
		  // Calculating common intermediary values
		  Dim theDistance As Double = Self.TimeInterval * ( Self.AirSpeed * ( 1 + ( Self.Altitude / 40000.0 ) ) ) / 3600
		  Dim theCompassRad As Double = Self.Compass / k1RadInDeg
		  
		  // Calculating the variation in coordinates
		  Dim theDeltaLat As Double = theDistance * Cos( theCompassRad ) / 60
		  Dim theDeltaLong As Double = theDistance * Sin( theCompassRad ) / Cos( Self.Latitude / k1RadInDeg ) / 60
		  
		  // Originally 'DG'
		  ' Dim theDiffLong As Double = theDistanceDiff * Sin( theCompassRad ) / Cos( ( ( Self.LatMin / 60 ) + Self.LatDeg ) / k1RadInDeg ) / 60
		  
		  ' Self.Latitude = Self.LatDeg + ( Self.LatMin / 60 )
		  ' Self.Longitude = Self.LongDeg + ( Self.LongMin / 60 )
		  
		  // Calculating the new Values
		  Self.Latitude = Self.Latitude + theDeltaLat
		  Self.Longitude = Self.Longitude + theDeltaLong
		  
		  ' Self.LatDeg = Fix( Self.Latitude )
		  ' Self.LatMin = ( Self.Latitude - Fix( Self.Latitude ) ) * 60
		  ' Self.LongDeg = Fix( Self.Longitude )
		  ' Self.LongMin = ( Self.Longitude - Fix( Self.Longitude ) ) * 60
		  
		  If Not ( Self.VORFrequency <> 0 ) Then
		    
		    // Original listing line 3870
		    Self.VORRange = "OUT "
		    Self.DME = 0
		    Return
		    
		  End If
		  
		  // Original listing line 3880
		  // Search for the VOR beacon according to its frequency
		  Dim theFoundVORIndex As Integer = -1
		  For i As Integer = 0 to 4
		    
		    If Self.VORFrequency = Plane.KnownVOR( i ).Frequency Then
		      
		      // Do we have a match?
		      theFoundVORIndex = i
		      Exit
		      
		    End If
		    
		  Next
		  
		  If theFoundVORIndex < 0 Then
		    
		    // No VOR Beacon found
		    // Original listing line 3870
		    Self.VORRange = "OUT "
		    Self.DME = 0
		    Return
		    
		  End If
		  
		  // Original Listing line 3920
		  Dim theVOR As VORBeacon = Plane.KnownVOR( theFoundVORIndex )
		  Self.VORLatitude = theVOR.Latitude
		  Self.VORLongitude = theVOR.Longitude
		  Self.VORRadialRunway = theVOR.RunwayRadial
		  Self.VORAltitude = theVOR.Altitude
		  
		  Dim theDiffLat As Double = ( Self.VORLatitude - Self.Latitude ) * 60
		  Dim theDiffLong As Double = ( Self.VORLongitude - Self.Longitude ) * Cos( ( ( Self.Latitude + Self.VORLatitude ) / 2 ) / k1RadInDeg ) * 60
		  
		  // the DME is a defined as static.
		  theDME = Sqrt( ( theDiffLat * theDiffLat ) + ( theDiffLong * theDiffLong ) )
		  
		  If theDME > 300 Then
		    
		    // original listing line 3870
		    Self.VORRange = "OUT "
		    Self.DME = -1
		    Return
		    
		  Else
		    
		    // Comparing the last DME to the new one to determine VOR Range.
		    If theDME < Self.DME Then Self.VORRange = " TO "
		    If theDME > Self.DME Then Self.VORRange = "FROM"
		    
		  End If
		  
		  Self.DME = theDME
		  
		  // Original listing line 4040
		  // Calculating the actual VOR Radial
		  Dim theVORActualRadial As Double
		  If Self.VORLongitude = Self.Longitude AND Self.VORLatitude < Self.Latitude Then
		    
		    theVORActualRadial = 180
		    
		  ElseIf Self.VORLongitude = Self.Longitude AND Self.VORLatitude > Self.Latitude Then
		    
		    theVORActualRadial = 0
		    
		  Else
		    
		    theVORActualRadial = ATan( ( Self.VORLatitude - Self.Latitude ) / ( ( Self.VORLongitude - Self.Longitude ) * Cos( ( ( Self.Latitude + Self.VORLatitude ) / 2 ) / k1RadInDeg ) ) ) * k1RadInDeg
		    theVORActualRadial = Abs( Floor( theVORActualRadial ) )
		    
		  End If
		  
		  //Original listing line 4080
		  If Self.VORLatitude > Self.Latitude AND Self.Longitude < Self.VORLongitude Then
		    
		    theVORActualRadial = 90 - theVORActualRadial
		    
		  ElseIf Self.VORLatitude <= Self.Latitude AND Self.Longitude < Self.VORLongitude Then
		    
		    theVORActualRadial = 90 + theVORActualRadial
		    
		  ElseIf Self.VORLatitude < Self.Latitude AND Self.Longitude > Self.VORLongitude Then
		    
		    theVORActualRadial = 270 - theVORActualRadial
		    
		  ElseIF Self.VORLatitude > Self.Latitude AND Self.Longitude > Self.VORLongitude Then
		    
		    theVORActualRadial = 270 + theVORActualRadial
		    
		  End If
		  
		  // Original listing line 4120
		  If Self.FlagAutoSelectVOR Then
		    
		    Self.VORSelectedRadial = theVORActualRadial
		    Self.SetNewCourse theVORActualRadial
		    
		    Self.FlagAutoSelectVOR = False
		    
		  End If
		  
		  Self.VORDeviation = theDME * Sin( ( Self.VORSelectedRadial - theVORActualRadial ) / k1RadInDeg )
		  
		  If Self.VORDeviation > 5.0 Then Self.VORDeviation = 5.0
		  If Self.VORDeviation < -5.0 Then Self.VORDeviation = -5.0
		  
		  // Original listing line 4180
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ThrustDecrease()
		  
		  //-- Decrease the thrust if not IDLE
		  //   NB: This command can't engage the reverse
		  
		  // Can we decrease the thrust?
		  If Self.Thrust > 0 Then
		    
		    // Yes
		    Self.Thrust = Self.Thrust - 1
		    
		    Dim theLogging As String
		    
		    Select Case Self.Thrust
		      
		    Case 0
		      theLogging = "IDLE"
		      
		    Case 1, 2, 3, 4
		      theLogging = Str( Self.Thrust )
		      
		    Else
		      theLogging = "!!-?-!! UNKNOW STATE !!-?-!!"
		      
		    End Select
		    
		    System.DebugLog CurrentMethodName + ": Thrust set to " + theLogging
		    
		  Else
		    
		    // the previous value isn't allowing change
		    System.DebugLog CurrentMethodName + ": Thrust wasn't changed"
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ThrustIncrease()
		  
		  
		  // Can we increase the Thrust?
		  If Self.Thrust < 5 Then
		    
		    // Yes, so we increase it
		    Self.Thrust = Self.Thrust + 1
		    
		    // Logging the change
		    Dim theLogging As String
		    
		    Select Case Self.Thrust
		      
		    Case 0
		      theLogging = "IDLE"
		      
		    Case 1, 2, 3, 4
		      theLogging = "'" + Str( Self.Thrust ) + "'"
		      
		    Case 5
		      theLogging = "FULL"
		      
		    Else
		      theLogging = "!!-?-!! UNKNOW STATE !!-?-!!"
		      
		    End Select
		    
		    System.DebugLog CurrentMethodName + ": Thrust set to " + theLogging
		    
		  Else
		    
		    System.DebugLog CurrentMethodName + ": Thrust wasn't changed"
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ThrustToFull()
		  
		  //-- Sets the thrust to full
		  
		  // Set the value
		  Self.Thrust = 5
		  
		  // A bit of logging
		  System.DebugLog CurrentMethodName + ": Thrust set to FULL"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ThrustToReverse()
		  
		  Self.Thrust = -1
		  
		  System.DebugLog CurrentMethodName + ": Thrust set to REVERSE"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToggleBrakes()
		  
		  // Toogles the brakes
		  Self.BrakesOn = Not Self.BrakesOn
		  
		  // log the change
		  If Self.BrakesOn Then
		    
		    System.DebugLog CurrentMethodName + ": Brakes are ON"
		    
		  Else
		    
		    System.DebugLog CurrentMethodName + ": Brakes are OFF"
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToggleFlaps()
		  
		  Self.FlapsDown = Not Self.FlapsDown
		  
		  If Self.FlapsDown Then
		    
		    System.DebugLog CurrentMethodName + ": Flaps are DOWN"
		    
		  Else
		    
		    System.DebugLog CurrentMethodName + ": Flaps are UP"
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToggleWheels()
		  
		  Self.WheelsDown = Not Self.WheelsDown
		  
		  If Self.WheelsDown Then
		    
		    System.DebugLog CurrentMethodName + ": Wheels are DOWN"
		    
		  Else
		    
		    System.DebugLog CurrentMethodName + ": Wheels are UP"
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TurnLeft()
		  
		  #pragma DisableBackgroundTasks
		  
		  Dim theNewCourse As Double
		  
		  If Self.CourseTracking Then
		    
		    theNewCourse = Self.Course - 1.0
		    
		  Else
		    
		    theNewCourse = Self.Compass - 1.0
		    
		  End If
		  
		  Self.SetNewCourse theNewCourse
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TurnRight()
		  
		  #pragma DisableBackgroundTasks
		  
		  Dim theNewCourse As Double
		  
		  If Self.CourseTracking Then
		    
		    theNewCourse = Self.Course + 1.0
		    
		  Else
		    
		    theNewCourse = Self.Compass + 1.0
		    
		  End If
		  
		  Self.SetNewCourse theNewCourse
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateFuelAirSpeedVertSpeed()
		  
		  // Let's sleep for a while
		  Self.Sleep( 200 )
		  
		  // Get the current time
		  Self.UpdateIntervalTime
		  
		  Dim theTimeInterval As Double = Self.TimeInterval
		  
		  // --- Checking for aborting conditions ---
		  
		  If Self.AirSpeed > 240.0 AND Self.FlapsDown Then
		    
		    Raise New FlightAbortException( FlightAbortException.Reason.FailedInCrucialManeuvers )
		    
		  End If
		  
		  If Self.AirSpeed < 200.0 AND Not Self.FlapsDown Then
		    
		    Raise New FlightAbortException( FlightAbortException.Reason.FailedInCrucialManeuvers )
		    
		  End If
		  
		  If ( Self.Altitude - Self.VORAltitude ) > 50.0 AND Self.AirSpeed < 150 Then
		    Raise New FlightAbortException( FlightAbortException.Reason.FailedInCrucialManeuvers )
		    
		  End If
		  
		  If Not Self.WheelsDown AND Self.BrakesOn Then
		    
		    Raise New FlightAbortException( FlightAbortException.Reason.BrakesOnWhileGearsUp )
		    
		  End If
		  
		  If Self.AirSpeed > 950.0 Then
		    
		    // Flying too fast!
		    Raise New FlightAbortException( FlightAbortException.Reason.FailedInCrucialManeuvers )
		    
		  End If
		  
		  If Self.Altitude > 2100 AND Self.Thrust = 5 Then
		    
		    Raise New FlightAbortException( FlightAbortException.Reason.FailedInCrucialManeuvers )
		    
		  End If
		  
		  If Self.Fuel = 0.0 Then
		    
		    Raise New FlightAbortException( FlightAbortException.Reason.OutOfFuel )
		    
		  End If
		  
		  // --- Computing acceleration and fuel consuption --
		  
		  Dim theAcceleration As Double
		  Dim theFuelConsumption As Double
		  
		  Select Case Self.Thrust
		    
		  Case 5
		    
		    theFuelConsumption = 7.0
		    theAcceleration = 6.0
		    
		  Case 4
		    
		    theFuelConsumption = 5.0
		    theAcceleration = 4.0
		    
		  Case 3
		    
		    theFuelConsumption = 4.0
		    theAcceleration = 2.0
		    
		  Case 2
		    
		    theFuelConsumption = 3.0
		    theAcceleration = 1.0
		    
		  Case 1
		    
		    theFuelConsumption = 2.0
		    theAcceleration = 0.0
		    
		  Case 0
		    
		    theFuelConsumption = 1.0
		    theAcceleration = -3.0
		    
		  Case -1
		    
		    theFuelConsumption = 7.0
		    
		    If Self.BrakesOn Then
		      
		      theAcceleration = -7.0
		      
		    Else
		      
		      theAcceleration = -5.0
		      
		    End If
		    
		  End Select
		  
		  Self.Fuel = Self.Fuel - ( theFuelConsumption * theTimeInterval )
		  
		  If Self.Fuel < 0.0 Then Self.Fuel = 0.0
		  Self.FuelPercent = Self.Fuel / 230.0
		  
		  #pragma Warning "Line 3110"
		  Dim thePitchRadian As Double = Self.Pitch / k1RadInDeg
		  
		  #Pragma Warning "Maybe a '* TJ^2' is too much. See original listing at line 3120"
		  // Originally : Self.AirSpeed = V0 + ( ( theAcceleration * theTimeInterval * theTimeInterval ) / 2 )
		  // But V0 as been found to be useless
		  Self.AirSpeed = Self.AirSpeed + ( ( theAcceleration * theTimeInterval )) // * theTimeInterval ) / 2 )
		  
		  #pragma Warning "See original listing at line 3130-3140."
		  // This is supposed to handle the influence of the pitch on the speed
		  If Self.Pitch >= 0.0 Then
		    
		    Self.AirSpeed = Self.AirSpeed * Cos( thePitchRadian )
		    
		  End If
		  
		  If Self.AirSpeed <= 0.0 Then Self.AirSpeed = 0.0
		  //V0 = Self.AirSpeed
		  
		  Self.VerticalSpeed = Self.AirSpeed * Sin( thePitchRadian ) * 95
		  
		  If Self.Altitude = 0 AND Self.Pitch <= 0 Then Self.VerticalSpeed = 0
		  Self.Altitude = Self.Altitude + ( theTimeInterval * Self.VerticalSpeed / 60 )
		  If Self.Altitude < 0 Then Self.Altitude = 0
		  
		  // Original listing line 3210
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateIntervalTime()
		  
		  Static theLastCallTime As Double = Microseconds
		  
		  Dim theNewTime As Double = Microseconds
		  Dim theNewInterval As Double = theNewTime - theLastCallTime
		  theLastCallTime = theNewTime
		  
		  Self.TimeInterval = theNewInterval * 1e-6
		  
		  
		  
		  
		  
		  'Dim d As New Date
		  'Self.CurrentTime = d.TotalSeconds
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AbortedFlyMessage As String
	#tag EndProperty

	#tag Property, Flags = &h0
		AirSpeed As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Altitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		AltitudeRadar As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		BrakesOn As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Compass As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Course As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		CourseTracking As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentMode As Plane.Mode
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentTime As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		DME As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FlagAbortLanding As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FlagAutoSelectVOR As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		FlapsDown As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Fuel As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		FuelPercent As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		GroundX As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		GroundY As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ILSCrossX As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ILSCrossY As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ILSMarkerOn As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ILSOn As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared KnownVOR() As VORBeacon
	#tag EndProperty

	#tag Property, Flags = &h0
		LastTime As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		LatDeg As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Latitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		LatMin As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		LongDeg As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Longitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		LongMin As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Pitch As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		PosXOnRunway As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Thrust As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TimeInterval As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VerticalSpeed As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VisualOnRunway As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private VORAltitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VORDeviation As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VORFrequency As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VORLatitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VORLongitude As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VORRadialRunway As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		VORRange As String
	#tag EndProperty

	#tag Property, Flags = &h0
		VORSelectedRadial As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		WheelsDown As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared WindTable(-1,-1) As Double
	#tag EndProperty


	#tag Enum, Name = Mode, Type = Integer, Flags = &h0
		Takeoff
		  Cruising
		  Landing
		  Landed
		FlyAborted
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="AbortedFlyMessage"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AirSpeed"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Altitude"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AltitudeRadar"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BrakesOn"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compass"
			Group="Behavior"
			InitialValue="81"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Course"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CourseTracking"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentTime"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DME"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FlapsDown"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fuel"
			Group="Behavior"
			InitialValue="20000"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FuelPercent"
			Group="Behavior"
			InitialValue="87"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GroundX"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GroundY"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ILSCrossX"
			Group="Behavior"
			InitialValue="71"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ILSCrossY"
			Group="Behavior"
			InitialValue="3"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ILSMarkerOn"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ILSOn"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastTime"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LatDeg"
			Group="Behavior"
			InitialValue="48"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Latitude"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LatMin"
			Group="Behavior"
			InitialValue="43"
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
			Name="LongDeg"
			Group="Behavior"
			InitialValue="2"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Longitude"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LongMin"
			Group="Behavior"
			InitialValue="23"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Pitch"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PosXOnRunway"
			Group="Behavior"
			InitialValue="40"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Thrust"
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeInterval"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VerticalSpeed"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VisualOnRunway"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VORDeviation"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VORFrequency"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VORLatitude"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VORLongitude"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VORRadialRunway"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VORRange"
			Group="Behavior"
			InitialValue="OUT"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VORSelectedRadial"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WheelsDown"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
