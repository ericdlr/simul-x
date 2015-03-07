#tag Window
Begin Window WinMain
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   True
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   488
   ImplicitInstance=   True
   LiveResize      =   False
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   1782166146
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   False
   Title           =   "SIMUL-X"
   Visible         =   True
   Width           =   520
   Begin TextScreen.Display TextOutput
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      DoubleBuffer    =   True
      Enabled         =   True
      EraseBackground =   False
      Height          =   240
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   14
      Transparent     =   False
      UseFocusRing    =   False
      Visible         =   True
      Width           =   480
   End
   Begin Timer FlightUpdater
      Height          =   32
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   -44
      LockedInPosition=   False
      Mode            =   0
      Period          =   1000
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   0
      Width           =   32
   End
   Begin Timer StartingTimer
      Height          =   32
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   -44
      LockedInPosition=   False
      Mode            =   0
      Period          =   1000
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   44
      Width           =   32
   End
   Begin TextArea HelpViewerOld
      AcceptTabs      =   False
      Alignment       =   1
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &cE0E0E000
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   False
      Format          =   ""
      Height          =   202
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   1185
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   False
      Styled          =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "\r	F	Full thrust		Down		Pitch down\r	R	Reverse thrust		Up		Pich up\r	I	Increase thrust		Left		Rudder left\r	D	Decrease thrust		Right		Rudder right\r\r	L	Flaps\r	W	Wheels ( Gear up/down)\r	B	Brakes\r	A	VOR auto select\r	C	Set a new course\r	V	Set VOR Fq and Radial\r	M	Abort Landing"
      TextColor       =   &c00000000
      TextFont        =   "SmallSystem"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   23
      Underline       =   False
      UseFocusRing    =   False
      Visible         =   True
      Width           =   480
   End
   Begin HTMLViewer HelpViewer
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   202
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Renderer        =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   266
      Visible         =   True
      Width           =   480
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Function KeyDown(Key As String) As Boolean
		  
		  System.DebugLog CurrentMethodName + " --- '" + Key + "'"
		  
		  Self.TextOutput.PrintAt 23, 1, FormatUsing( Asc( Key ), "###" )
		  
		  If Self.MainMenuOnScreen Then
		    
		    Return Self.HandleMainMenuChoice( Key )
		    
		  End If
		  
		  If Self.myPlane Is Nil Then
		    
		    Return False
		    
		  End If
		  
		  // We have a plane to fly !!!
		  Select Case Key
		    
		  Case Chr( 3 ) // Ctrl-C
		    Break
		    
		  Case "B"
		    Self.myplane.ToggleBrakes
		    
		  Case "W"
		    Self.myPlane.ToggleWheels
		    
		  Case "L"
		    Self.myPlane.ToggleFlaps
		    
		  Case "I"
		    Self.myPlane.ThrustIncrease
		    
		  Case "D"
		    Self.myPlane.ThrustDecrease
		    
		  Case "F"
		    Self.myPlane.ThrustToFull
		    
		  Case "R"
		    Self.myPlane.ThrustToReverse
		    
		  Case "0", "-"
		    Self.myPlane.PitchReset
		    
		  Case Chr( 30 )
		    Self.myPlane.PitchUp
		    
		  Case Chr( 31 )
		    Self.myPlane.PitchDown
		    
		  Case Chr( 28 )
		    Self.myPlane.TurnLeft
		    
		  Case Chr( 29 )
		    Self.myPlane.TurnRight
		    
		  Case "C"
		    Self.InputNewCourse
		    
		  Case "M"
		    Self.myPlane.AbortLanding
		    
		  Case "A"
		    Self.myPlane.AutoSelectVOR
		    
		  Case "V"
		    Self.SelectVORBeacon
		    
		  Else
		    
		    // Unknown command
		    Return False
		    
		  End Select
		  
		  // We handled the key
		  Return True
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  
		  Self.DisplayMainMenu
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub BuildPanel()
		  
		  #pragma DisableBackgroundTasks
		  
		  TextOutput.ClearScreen
		  TextOutput.PrintAt 0, 5, "VOR"
		  TextOutput.PrintAt 0, 15, "RANGE"
		  TextOutput.PrintAt 1, 10, "MHZ"
		  TextOutput.PrintAt 3, 3, "RADIAL"
		  TextOutput.PrintAt 6, 1, ".....Y....."
		  TextOutput.PrintAt 7, 69, "ILS"
		  TextOutput.PrintAt 8, 5, "DME"
		  TextOutput.PrintAt 9, 69, "MARKER"
		  TextOutput.PrintAt 10, 5, "NM"
		  TextOutput.PrintAt 10, 70, ">  <"
		  TextOutput.PrintAt 14, 7, "OMEGA"
		  TextOutput.PrintAt 14, 23, "CLOCK"
		  TextOutput.PrintAt 14, 36, "COMPASS"
		  TextOutput.PrintAt 14, 50, "PITCH"
		  TextOutput.PrintAt 14, 57, "THRUST"
		  TextOutput.PrintAt 14, 67, "FUEL  %"
		  TextOutput.PrintAt 15, 4, "N"
		  TextOutput.PrintAt 15, 14, "LAT"
		  TextOutput.PrintAt 15, 59, "MAX"
		  TextOutput.PrintAt 16, 4, "E"
		  TextOutput.PrintAt 16, 14, "LONG"
		  TextOutput.PrintAt 16, 36, "<     >"
		  TextOutput.PrintAt 16, 51, "DEG"
		  TextOutput.PrintAt 16, 68, "KG"
		  TextOutput.PrintAt 17, 21, "ALTITUDE"
		  TextOutput.PrintAt 17, 37, "COURSE"
		  TextOutput.PrintAt 18, 5, "VERT SPEED"
		  TextOutput.PrintAt 18, 28, "FEET"
		  TextOutput.PrintAt 18, 51, "FLAPS"
		  TextOutput.PrintAt 18, 64, "WHEELS"
		  TextOutput.PrintAt 18, 71, "BRAKES"
		  TextOutput.PrintAt 19, 53, "UP"
		  TextOutput.PrintAt 19, 66, "UP"
		  TextOutput.PrintAt 19, 73, "SET"
		  TextOutput.PrintAt 20, 20, "RADAR ALT"
		  TextOutput.PrintAt 20, 36, "AIRSPEED"
		  TextOutput.PrintAt 20, 59, "IDLE"
		  TextOutput.PrintAt 21, 28, "FEET"
		  TextOutput.PrintAt 21, 42, "KTS"
		  TextOutput.PrintAt 21, 53, "DWN"
		  TextOutput.PrintAt 21, 59, "REV"
		  TextOutput.PrintAt 21, 66, "DWN"
		  TextOutput.PrintAt 21, 73, "REL"
		  
		  For Y As Integer = 15 To 21
		    
		    TextOutput.PrintAt Y, 58, "."
		    
		  Next
		  
		  If Not( Self.myPlane Is Nil ) Then
		    
		    // TextOutput.PrintAt Self.myPlane.Flaps, 52, ">"
		    TextOutput.PrintAt Self.myPlane.Thrust, 57, ">"
		    // TextOutput.PrintAt Self.myPlane.Wheels, 65, ">"
		    TextOutput.PrintAt 19, 72, ">"
		    
		  End If
		  
		  // Self.DrawGlideslopeCrosshairs
		  
		  TextOutput.PrintAt 12, 0, "--------------------------------------------------------------------------------"
		  TextOutput.PrintAt 0, 24, "================================"
		  
		  Dim A As Integer = 22
		  Dim B As Integer = 57
		  
		  For Y As Integer = 1 to 11
		    
		    TextOutput.PrintAt Y, A, "!"
		    TextOutput.PrintAt Y, B, "!"
		    
		    A = A -1
		    B = B + 1
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisplayCommandStatus()
		  
		  // Initializing the needed static values
		  // their first values are set to force a printing the first time this method is called
		  Static theLastBrakesState As Boolean = Not Self.myPlane.BrakesOn
		  Static theLastWheelsState As Boolean = Not Self.myPlane.WheelsDown
		  Static theLastFlapsState As Boolean = Not Self.myPlane.FlapsDown
		  Static theLastThrustValue As Integer = -2
		  
		  #pragma Warning "Need a better solution for the first call to force drawing"
		  
		  
		  // --- Display the brakes status ---
		  
		  If theLastBrakesState <> Self.myPlane.BrakesOn Then
		    
		    If theLastBrakesState Then
		      
		      TextOutput.PrintAt 19, 72, " "
		      TextOutput.PrintAt 21, 72, "*"
		      
		    Else
		      
		      TextOutput.PrintAt 21, 72, " "
		      TextOutput.PrintAt 19, 72, "*"
		      
		    End If
		    
		    theLastBrakesState = Self.myPlane.BrakesOn
		    
		  End If
		  
		  
		  // --- Display the wheels status ---
		  
		  If theLastWheelsState <> Self.myPlane.WheelsDown Then
		    
		    If theLastWheelsState Then
		      
		      TextOutput.PrintAt 21, 65, " "
		      TextOutput.PrintAt 19, 65, "*"
		      
		    Else
		      
		      TextOutput.PrintAt 19, 65, " "
		      TextOutput.PrintAt 21, 65, "*"
		      
		    End If
		    
		    theLastWheelsState = Self.myPlane.WheelsDown
		    
		  End If
		  
		  
		  // --- Display the flaps status ---
		  
		  // Do we need to refresh?
		  If theLastFlapsState <> Self.myPlane.FlapsDown Then
		    
		    If theLastFlapsState Then
		      
		      TextOutput.PrintAt 21, 52, " "
		      TextOutput.PrintAt 19, 52, "*"
		      
		    Else
		      
		      TextOutput.PrintAt 19, 52, " "
		      TextOutput.PrintAt 21, 52, "*"
		      
		    End If
		    
		    // storing the new value
		    theLastFlapsState = Self.myPlane.FlapsDown
		    
		  End If
		  
		  
		  // --- Display the thrust command ---
		  
		  // Retrieving the thrust value
		  Dim theThrustValue As Integer = Self.myPlane.Thrust
		  
		  // Do we need to refresh?
		  If theLastThrustValue <> theThrustValue Then
		    
		    // Erasing the old cursor position
		    TextOutput.PrintAt 20 - theLastThrustValue, 57, " "
		    
		    // Printing the new cursor position
		    TextOutput.PrintAt 20 - theThrustValue, 57, "*"
		    
		    // Storing the new value
		    theLastThrustValue = theThrustValue
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisplayILS()
		  
		  #pragma DisableBackgroundTasks
		  Static theLastILSCrossX As Integer = 71
		  Static theLastILSCrossY As Integer = 3
		  Static theLastILSState As Boolean
		  
		  Dim thePlane As Plane = Self.myPlane
		  
		  If thePlane Is Nil Then Return
		  
		  // Normalize the values for display
		  Dim theX As Integer = 71 + Round( theplane.ILSCrossX )
		  Dim theY As Integer = 3 - Round( thePlane.ILSCrossY )
		  
		  // Is there a change here?
		  If theX <> theLastILSCrossX OR theY <> theLastILSCrossY Then
		    
		    // --- Erase the previous cross
		    For Y As Integer = 0 To 6
		      
		      Self.TextOutput.PrintAt Y, theLastILSCrossX, " "
		      
		    Next
		    
		    Self.TextOutput.PrintAt theLastILSCrossY, 64, "               " // 15 spaces
		    
		    
		    // then Draw theNew one if the ILS is ON
		    If thePlane.ILSOn Then
		      
		      For Y As Integer = 0 To 6
		        
		        Self.TextOutput.PrintAt Y, theX, "I"
		        
		      Next
		      
		      Self.TextOutput.PrintAt theY, 64, "---------------"
		      
		      // Draw the fixed center
		      Self.TextOutput.PrintAt 3, 71, "O"
		      
		      // Draw thecross common point
		      Self.TextOutput.PrintAt theY, theX, "+"
		      
		    End If
		    
		    // Stor the new values for the next call
		    theLastILSCrossX = theX
		    theLastILSCrossY = theY
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisplayInstrumentValues()
		  
		  #pragma DisableBackgroundTasks
		  
		  Static theLastPosXOnRunway As Double
		  Static theLastBrakesState As Double
		  Static theLastILSMarkerState As Boolean
		  
		  // Retrieving the date object reference
		  Dim theDate As New Date
		  ' theDate.TotalSeconds = Self.myPlane.CurrentTime
		  
		  If Not ( theDate Is Nil ) Then
		    
		    // We have a date to display
		    TextOutput.PrintAt 15, 21, FormatUsing( theDate.Hour, "00" )
		    TextOutput.PrintAt 15, 24, FormatUsing( theDate.Minute, "00" )
		    TextOutput.PrintAt 15, 27, FormatUsing( theDate.Second, "00" )
		    
		  Else
		    
		    // No date to display
		    TextOutput.PrintAt 15, 21, "--"
		    TextOutput.PrintAt 15, 24, "--"
		    TextOutput.PrintAt 15, 27, "--"
		    
		  End If
		  
		  // Retrieving thePlane reference
		  Dim thePlane As Plane = Self.myPlane
		  
		  If Not ( thePlane Is Nil ) Then
		    
		    // Displaying the Fuel, Heading and speed data
		    TextOutput.PrintAt 15, 65, FormatUsing( thePlane.Fuel, "##,##0" )
		    TextOutput.PrintAt 15, 72, FormatUsing( thePlane.FuelPercent, "#0" )
		    TextOutput.PrintAt 15, 38, FormatUsing( thePlane.Compass, "###" )
		    
		    If thePlane.CourseTracking Then
		      
		      TextOutput.PrintAt 16, 38, FormatUsing( thePlane.Course, "###" )
		      
		    Else
		      
		      TextOutput.PrintAt 16, 38, "---"
		      
		    End If
		    
		    TextOutput.PrintAt 21, 38, FormatUsing( thePlane.AirSpeed, "##0" )
		    
		    // The Z dimension data
		    TextOutput.PrintAt 18, 21, FormatUsing( thePlane.Altitude, "##,##0" )
		    TextOutput.PrintAt 21, 21, FormatUsing( thePlane.AltitudeRadar, "##,##0" )
		    
		    // The Vertical speed
		    Dim theVertSpeed As Double = thePlane.VerticalSpeed
		    
		    If theVertSpeed < 0 Then
		      
		      TextOutput.PrintAt 19, 6, Chr( 126 )
		      
		    Elseif theVertSpeed > 0 Then
		      
		      TextOutput.PrintAt 19, 6, Chr( 125 )
		      
		    Else
		      
		      TextOutput.PrintAt 19, 6, " "
		      
		    End If
		    
		    TextOutput.PrintAt 19, 7, FormatUsing( theVertSpeed, "##,##0" )
		    
		    // The pitch...
		    TextOutput.PrintAt 15, 52, FormatUsing( thePlane.Pitch, "#0" )
		    
		    // ...And the its sign
		    Select Case Sign( thePlane.Pitch )
		      
		    Case 1
		      TextOutput.PrintAt 15, 51, "+"
		      
		    Case -1
		      TextOutput.PrintAt 15, 51, "-"
		      
		    Else
		      TextOutput.PrintAt 15, 51, " "
		      
		    End Select
		    
		    // Latitude & longitude
		    // Calculating the values
		    Dim theLatDeg As Integer = CType( thePlane.Latitude, Integer )
		    Dim theLatMin As Double = ( thePlane.Latitude - theLatDeg ) * 60
		    Dim theLongDeg As Integer = CType( thePlane.Longitude, Integer )
		    Dim theLongMin As Double = ( thePlane.Longitude - theLongDeg ) * 60
		    
		    TextOutput.PrintAt 15, 6, FormatUsing( theLatDeg, "#0" )
		    TextOutput.PrintAt 15, 9, FormatUsing( theLatMin, "#0.0" )
		    TextOutput.PrintAt 16, 6, FormatUsing( theLongDeg, "#0" )
		    TextOutput.PrintAt 16, 9, FormatUsing( theLongMin, "#0.0" )
		    
		    // Radio navigation data
		    TextOutput.PrintAt 1, 4, FormatUsing( thePlane.VORFrequency, "##0.0" )
		    TextOutput.PrintAt 4, 5, FormatUsing( thePlane.VORSelectedRadial, "##0" )
		    
		    TextOutput.PrintAt 1, 15, thePlane.VORRange
		    Self.DisplayVORData
		    
		    
		    // --- ILS Marker ---
		    
		    // Does its state change since last time?
		    If theLastILSMarkerState <> thePlane.ILSMarkerOn Then
		      
		      // Yes.
		      If thePlane.ILSMarkerOn Then
		        
		        // It's ON
		        Self.TextOutput.PrintAt 10, 71, "##"
		        
		      Else
		        
		        // It's OFF
		        Self.TextOutput.PrintAt 10, 71, "  "
		        
		      End If
		      
		      // Signal the change
		      Beep
		      
		      // Store the new Value
		      theLastILSMarkerState = thePlane.ILSMarkerOn
		      
		    End If
		    
		    // --- ILS Cross ---
		    
		    Self.DisplayILS
		    
		    
		    // --- The plane on the runway ---
		    
		    // The runway must be drawn to display the plane's position
		    If Self.RunwayDisplayed Then
		      
		      // Is it a new position?
		      If Self.myPlane.PosXOnRunway <> theLastPosXOnRunway Then
		        
		        // We erase the previous position
		        TextOutput.PrintAt 10, theLastPosXOnRunway, " "
		        
		        // Is the plane still on the runway?
		        If Self.myPlane.PosXOnRunway > -1 Then
		          
		          // Yes, we display its position
		          TextOutput.PrintAt 10, Self.myPlane.PosXOnRunway, "A"
		          
		        End If
		        
		        // Storing the new value
		        theLastPosXOnRunway = Self.myPlane.PosXOnRunway
		        
		      End If
		      
		    End If
		    
		  Else
		    
		    // -- No Plane Data to display --
		    TextOutput.PrintAt 15, 65, "--,---"
		    TextOutput.PrintAt 15, 72, "--"
		    TextOutput.PrintAt 15, 38, "---"
		    TextOutput.PrintAt 16, 38, "---"
		    TextOutput.PrintAt 21, 38, "---"
		    TextOutput.PrintAt 19, 7, "--,---"
		    TextOutput.PrintAt 18, 21, "--,---"
		    TextOutput.PrintAt 21, 21, "--,---"
		    TextOutput.PrintAt 15, 51, " --"
		    TextOutput.PrintAt 15, 6, "-- --.-"
		    TextOutput.PrintAt 16, 6, "-- --.-"
		    TextOutput.PrintAt 1, 4, "---.-"
		    TextOutput.PrintAt 4, 5, "---"
		    TextOutput.PrintAt 9, 4, "---.-"
		    TextOutput.PrintAt 1, 15, "OFF "
		    TextOutput.PrintAt 7, 1, "#############"
		    Self.TextOutput.PrintAt 10, 71, "--"
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisplayMainMenu()
		  
		  // Display the Menu
		  
		  TextOutput.ClearScreen
		  TextOutput.PrintAt 4, 37, "SIMUL-X"
		  TextOutput.PrintAt 5, 30, "IFR FLIGHT SIMULATOR"
		  TextOutput.PrintAt 10, 27, "1...NORMAL CRUISE OPERATION"
		  TextOutput.PrintAt 11, 27, "2...TAKEOFF TRAINING"
		  TextOutput.PrintAt 12, 27, "3...CRUISE TRAINING"
		  TextOutput.PrintAt 13, 27, "4...LANDING TRAINING"
		  TextOutput.PrintAt 14, 27, "ESC...END"
		  TextOutput.PrintAt 17, 27, "CHOOSE AN OPERATION TO CONTINUE..."
		  
		  Self.MainMenuOnScreen = True
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisplayVORData()
		  
		  Static theLastVORDeviation As Integer = 100
		  Static theLastVORRange As String
		  
		  Dim theVORDeviation As Integer = Round( Self.myPlane.VORDeviation )
		  
		  If theLastVORDeviation <>  theVORDeviation Then
		    
		    TextOutput.PrintAt 7, theLastVORDeviation + 6, " "
		    TextOutput.PrintAt 7, theVORDeviation + 6, Chr( 125 )
		    theLastVORDeviation = theVORDeviation
		    
		  End If
		  
		  If theLastVORRange <> Self.myPlane.VORRange Then
		    
		    TextOutput.PrintAt 1, 15, Self.myPlane.VORRange
		    theLastVORRange = Self.myPlane.VORRange
		    
		  End If
		  
		  // The DME
		  If Self.myPlane.VORRange <> "OUT " Then
		    
		    TextOutput.PrintAt 9, 4, FormatUsing( Self.myPlane.DME, "###.0" )
		    
		  Else
		    
		    TextOutput.PrintAt 9, 4, "---.-   "
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRunway()
		  
		  Dim X0 As Integer = 11
		  Dim X1 As Integer = 67
		  
		  For Y0 As Integer = 12 DownTo 3
		    
		    TextOutput.PrintAt Y0, X0, "#"
		    TextOutput.PrintAt Y0, X1, "#"
		    
		    X0 = X0 + 3
		    X1 = X1 - 3
		    
		  Next
		  
		  Self.RunwayDisplayed = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HandleMainMenuChoice(Key As String) As Boolean
		  
		  Dim theChoice As String
		  
		  Select Case Key
		    
		  Case "1"
		    Self.NormalOps
		    theChoice = "NORMAL OPERATIONS"
		    
		  Case "2"
		    Self.TrainingTakeoff
		    theChoice = "TAKEOFF TRAINING"
		    
		  Case "3"
		    Self.TrainingCruise
		    theChoice = "CRUISE TRAINING"
		    
		  Case "4"
		    Self.TrainingLanding
		    theChoice = "LANDING TRAINING"
		    
		  Case Chr( 27 )
		    Self.myPlane = Nil
		    
		  Else
		    Return False
		    
		  End Select
		  
		  If Self.myPlane Is Nil Then
		    
		    TextOutput.PrintAt 18, 27, "AU REVOIR"
		    
		  Else
		    
		    TextOutput.PrintAt 18, 27, ">>> INITIALIZING " + theChoice + "..."
		    
		  End If
		  
		  TextOutput.Refresh
		  
		  // Initializing the starting timer
		  Self.StartingTimer.Period = 2000
		  Self.StartingTimer.Mode = Timer.ModeSingle
		  
		  Self.MainMenuOnScreen = False
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideRunway()
		  
		  //-- Erase the runway drawing
		  
		  Dim X0 As Integer = 38
		  Dim X1 As Integer = 40
		  
		  For Y0 As Integer = 3 to 12
		    
		    If Y0 < 12 Then
		      TextOutput.PrintAt Y0, X0, " "
		      TextOutput.PrintAt Y0, X1, " "
		      
		    Else
		      
		      TextOutput.PrintAt Y0, X0, "-"
		      TextOutput.PrintAt Y0, X1, "-"
		      
		    End If
		    
		    X0 = X0 - 3
		    X1 = X1 + 3
		    
		  Next
		  
		  Self.RunwayDisplayed = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InputNewCourse()
		  
		  // We need a valid plane set in cruising phase to input a new course
		  If Not ( Self.myPlane Is Nil ) AND Self.myPlane.CurrentMode = Plane.Mode.Cruising Then
		    
		    Dim theInputWindow As New WinInput
		    
		    theInputWindow.Text.Text = "Enter a new course:"
		    theInputWindow.InputField.Text = ""
		    theInputWindow.InputField.SetFocus
		    
		    theInputWindow.ShowModalWithin( Self )
		    
		    If Not theInputWindow.UserCancelled Then
		      
		      Dim theNewCourse As Integer = Val( theInputWindow.InputField.Text )
		      
		      Self.myPlane.SetNewCourse( theNewCourse )
		      
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NormalOps()
		  
		  Dim thePlane As New Plane
		  thePlane.SetupForNormalOps
		  
		  Self.myPlane = thePlane
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SelectVORBeacon()
		  
		  Dim theSelectWindow As New WinVORSelect
		  
		  theSelectWindow.ShowModalWithin Self
		  
		  If Not theSelectWindow.UserCancelled Then
		    
		    Self.myPlane.SetVORBeacon( theSelectWindow.SelectedVOR, theSelectWindow.SelectedRadial )
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartFlight()
		  
		  Self.FlightUpdater.Mode = Timer.ModeMultiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TrainingCruise()
		  
		  Dim thePlane As New Plane
		  thePlane.SetupForCruiseTraining
		  
		  Self.myPlane = thePlane
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TrainingLanding()
		  
		  Dim thePlane As New Plane
		  thePlane.SetupForLandingTraining
		  
		  Self.myPlane = thePlane
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TrainingTakeoff()
		  
		  Dim thePlane As New Plane
		  thePlane.SetupForTakeoffTraining
		  
		  Self.myPlane = thePlane
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CurrentTime As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		MainMenuOnScreen As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		myPlane As Plane
	#tag EndProperty

	#tag Property, Flags = &h0
		RunwayDisplayed As Boolean
	#tag EndProperty


	#tag Constant, Name = kHelpKeyboard, Type = String, Dynamic = False, Default = \"<html>\r\t<body>\r<pre>\r    F  Full thrust        Down   Pitch down\r    R  Reverse thrust     Up     Pich up\r    I  Increase thrust    Left   Rudder left\r    D  Decrease thrust    Right  Rudder right\r\r    L  Flaps\r    W  Wheels ( Gear up/down)\r    B  Brakes\r    A  VOR auto select\r    C  Set a new course\r    V  Set VOR Fq and Radial\r    M  Abort Landing\r</pre> \r\t</body>\r</html>\r", Scope = Public
	#tag EndConstant


#tag EndWindowCode

#tag Events TextOutput
	#tag Event
		Function KeyDown(Key As String) As Boolean
		  
		  Break
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events FlightUpdater
	#tag Event
		Sub Action()
		  
		  Self.DisplayInstrumentValues
		  Self.DisplayCommandStatus
		  
		  // Do we need to draw the Runway?
		  If Self.myPlane.VisualOnRunway Xor Self.RunwayDisplayed Then
		    
		    If Self.myplane.VisualOnRunway Then
		      
		      Self.DrawRunway
		      
		    Else
		      
		      Self.HideRunway
		      
		    End If
		    
		  End If
		  
		  If Self.myPlane.CurrentMode = Plane.Mode.FlyAborted Then
		    
		    Me.Mode = Timer.ModeOff
		    
		    Beep
		    MsgBox "Your flight has been aborted." + EndOfLine + EndOfLine + Self.myPlane.AbortedFlyMessage
		    
		    Self.myPlane = Nil
		    Self.DisplayMainMenu
		    
		  Elseif Self.myPlane.CurrentMode = Plane.Mode.Landed Then
		    
		    Me.Mode = Timer.ModeOff
		    
		    Beep
		    MsgBox "Congratulations!!!" + EndOfLine + EndOfLine + "You successfully complete this flight"
		    
		    Self.myPlane = Nil
		    Self.DisplayMainMenu
		    
		  End If
		  
		  Self.TextOutput.Refresh
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events StartingTimer
	#tag Event
		Sub Action()
		  
		  If Self.myPlane Is Nil Then
		    
		    Quit
		    
		  Else
		    
		    Self.BuildPanel
		    Self.DisplayInstrumentValues
		    Self.myPlane.Run
		    Self.FlightUpdater.Mode = timer.ModeMultiple
		    
		  End If
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events HelpViewer
	#tag Event
		Sub Open()
		  
		  Me.LoadPage( Self.kHelpKeyboard, Nil )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"10 - Drawer Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MainMenuOnScreen"
		Group="Behavior"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="RunwayDisplayed"
		Group="Behavior"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
