extensions [csv gis palette table]
;;NOTE; Counter taken from Canvas and provided by Todd Swannack

;; ==============================================================
;;                   NEXT STEPS
;; ==============================================================

;; 1. Striped Bass Population Statistics
;; 2. Striped Bass Predation Movement
;; 4. Update migration start temperature striped bass
;; 5. Biomagnification Equations
;; 6. Sediment Data
;; 7. Metabolism & Energetics check
;; 8. Contamination Tracking
;Is it relevant to track exposure to mercury at all or just methylmercury
;; 10. Milford fish lifts validation data

__includes[
  "nls/calendar.nls"
  "nls/VariableNames.nls"
  "nls/Create-map.nls"
  "nls/prototypesetup.nls"
  "nls/penobscotsetup.nls"
  ;"nls/Create-velocity.nls"
  ;"nls/Update-velocity.nls"
  ;"nls/Create-depth.nls"
  ;"nls/Update-depth.nls"
  ;"nls/Create-salinity.nls"
  ;"nls/Update-salinity.nls"
  ;"nls/Create-SSC.nls"
  ;"nls/Update-SSC.nls"
  ;"nls/Create-Temperature.nls"
  ;"nls/Update-Temperature.nls"
  "nls/Update-hydro-data.nls"
  "nls/Create-Hg.nls"
  "nls/Create-MeHg.nls"
  "nls/Fill-Missing-Data.nls"
  "nls/Identify-Missing-Patches.nls"
  "nls/Velocity-Color.nls"
  "nls/Schooling.nls"
  "nls/Find-Schoolmates.nls" ; should I have multiple schools or 1?
  "nls/Find-nearest-neighbor.nls"
  "nls/Align.nls"
  "nls/Cohere.nls"
  "nls/Separate.nls"
  "nls/Setup-Alewives.nls"
  "nls/Setup-StripedBass.nls"
  "nls/Adjust-Alewife-speed.nls"
  "nls/Adjust-StripedBass-speed.nls"
  "nls/Reporters.nls"
  "nls/Landward-Migration.nls" ; no foraging for alewives during migration here, will lose lipids
  "nls/Seaward-Migration.nls"
  "nls/Selective-Tidal-Stream-Transport.nls"
  "nls/Swim.nls"
  "nls/flee-stripedbass.nls"
  "nls/Eat.nls"
  "nls/Chase-nearest-alewife.nls"
  "nls/Scare-down.nls"
  "nls/Scare-up.nls"
  "nls/Scare-left.nls"
  "nls/Scare-right.nls"
  "nls/Scare-prey.nls"
  "nls/Wander.nls"
  "nls/Count-prey-eaten.nls"
  ;"nls/Prey-on-Alewives.nls"
  "nls/Mercury-Contamination.nls"
  "nls/Methylmercury-Contamination.nls"
  "nls/Osmoregulation.nls" ; update to salinity exposure
  ;"nls/Staging.nls" ;Remove post workshop
  ;"nls/Foraging.nls" ;Remove post workshop
  "nls/Foraging_postworkshop_update.nls" ; define from turbidity or sediment, also need opportunistic foragig
  "nls/Calculate-metabolism.nls" ; metabolic caluclation
  "nls/Calculate-photoperiod.nls" ; photoperiod
  "nls/Migration-cue.nls" ;; migration
  "nls/dam_counts_validation.nls"
  "nls/Calculate-visual-distance.nls"
  "nls/digestion.nls"
]

to setup
  clear-all ;; reset variables

  ;; Initialize time variables
;; set simulation to start at chosen month
  set monthnum start-month

  let months ["January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December"]
  let monthstarts [1 32 60 91 121 152 182 213 244 274 305 335]

  set month item (monthnum - 1) months
  set current-month month
  set day item (monthnum - 1) monthstarts
  set hour 0
  set minute 0

  ;; Initialize the model environment
  if model-type = "penobscot" [setup-GIS]
  if model-type = "prototype" [prototype-setup]

  ;; Set environment parameters based on model type
  if model-type = "penobscot" [penobscot-parameters]
  if model-type = "prototype" [prototype-parameters]

  ;update-SPM-mean

  ;; Agent setup
  set-default-shape turtles "fish"

  ;; Create fish agents randomly in the prototype model
  if model-type = "prototype" [setup-migration]

  ;; Initialize species-specific fish
  if model-type = "penobscot" [setup-penobscot-migration]

  reset-ticks ;; Reset the tick counter
end

to go
  calendar ;; Call the calendar procedure to update hour, day, and month

  if model-type = "penobscot" [penobscot-go]
  if model-type = "prototype" [prototype-go]

  tick ;; Increment the tick counter
end
@#$#@#$#@
GRAPHICS-WINDOW
408
10
1019
1072
-1
-1
3.0
1
10
1
1
1
0
1
1
1
0
200
0
350
0
0
1
ticks
60.0

BUTTON
214
56
311
89
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
322
55
385
88
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
323
99
386
132
Step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
208
380
380
413
initial-stripedbass
initial-stripedbass
0
1000
2.0
2
1
fish
HORIZONTAL

SLIDER
209
334
381
367
initial-alewives
initial-alewives
2
10000
100.0
1
1
fish
HORIZONTAL

TEXTBOX
297
300
394
330
Species
24
0.0
1

TEXTBOX
276
424
379
482
Digestion
24
0.0
1

SLIDER
52
486
378
519
alewife-digestion-efficiency
alewife-digestion-efficiency
0
1
0.2
0.1
1
portion of food > energy
HORIZONTAL

SLIDER
14
526
378
559
stripedbass-digestion-efficiency
stripedbass-digestion-efficiency
0
1
0.2
0.1
1
portion of food > > energy
HORIZONTAL

TEXTBOX
181
19
438
48
Initialize Simulation
24
0.0
1

CHOOSER
27
23
165
68
model-type
model-type
"penobscot" "prototype"
0

PLOT
1032
282
1456
540
Energy Dynamics
ticks
values
1.0
100.0
0.0
100.0
true
false
"clear-all-plots\n" ""
PENS
"Alewife" 1.0 0 -13840069 true "" "plot mean [energy] of alewives"
"Striped Bass" 1.0 0 -2674135 true "" "plot mean [energy] of stripedbass"

PLOT
1938
282
2364
540
Chloride Cells
ticks
Chloride Cell Percentage
0.0
10.0
0.0
100.0
true
false
"clear-all-plots" ""
PENS
"default" 1.0 0 -8630108 true "" "plot mean [chloride-cell-density] of alewives"

PLOT
1941
548
2363
804
Stress Dynamics
ticks
stress
0.0
10.0
0.0
10.0
true
false
"clear-all-plots" ""
PENS
"Ion-Regulatory Stress" 1.0 0 -13840069 true "" "plot mean [ionregulatory-stress] of alewives"

PLOT
1940
20
2364
275
Salinity
ticks
Salinity
0.0
10.0
0.0
35.0
true
true
"" ""
PENS
"Salinity (psu)" 1.0 0 -16777216 true "" "plot mean [salinity] of patches with [any? turtles-here]"
"Acclimated-Salinity" 1.0 0 -817084 true "" "plot mean [acclimated-salinity] of turtles"

PLOT
1944
808
2364
1064
Metabolic Rate
ticks
Energy Consumed
0.0
1.0
0.0
7.0E-4
true
false
"" ""
PENS
"Osmo_Energy" 1.0 0 -16777216 true "" "plot mean [metabolism-rate] of turtles"

PLOT
1032
22
1460
272
Velocities
ticks
velocity (m/s)
0.0
10.0
0.0
1.5
true
true
"" ""
PENS
"Swimming Speed" 1.0 0 -955883 true "" "plot mean [speed] of turtles / 300"
"velocity" 1.0 0 -16777216 true "" "plot mean [velocity] of patches"
"Zero-0" 1.0 0 -7500403 true "" ";plot 0"

PLOT
1032
810
1468
1064
Swimming Energy: Alewives
ticks
Energy
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"Energy" 1.0 0 -5825686 true "" "plot mean [E-swim] of alewives"

PLOT
1030
548
1464
804
Swimming Difficulty
ticks
difficulty
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [difficulty-factor] of turtles"

PLOT
1478
808
1927
1066
Behaviors
ticks
behavior type
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"STST" 1.0 0 -13791810 true "" "plot (count turtles with [selective-tidal-transport? = true]) / count turtles"
"Foraging" 1.0 0 -15302303 true "" "plot (count turtles with [breed != stripedbass and foraging? = true]) / count turtles with [breed != stripedbass]"
"Filter-Feeding" 1.0 0 -7500403 true "" "plot (count turtles with [breed != stripedbass and filter-feed? = true]) / count turtles with [breed != stripedbass]"
"Lipid-Loss" 1.0 0 -2674135 true "" "plot (count turtles with [breed != stripedbass and lipid-loss? = true]) / count turtles with [breed != stripedbass]"
"Home Patch" 1.0 0 -955883 true "" "plot (count turtles with [breed != stripedbass and at-destination? = true]) / count turtles with [breed != stripedbass]"
"Prey-Mig" 1.0 0 -6459832 true "" "plot (count turtles with [breed != stripedbass and start-migration? = true]) / count turtles with [breed != stripedbass]"
"Landward" 1.0 0 -1184463 true "" "plot (count turtles with [breed != stripedbass and landward-migration? = true]) / count turtles with [breed != stripedbass]"
"Seaward" 1.0 0 -10899396 true "" "plot (count turtles with [breed != stripedbass and seaward-migration? = true]) / count turtles with [breed != stripedbass]"
"Hunting?" 1.0 0 -13840069 true "" "plot (count turtles with [breed = stripedbass and hunting? = true]) / count turtles with [breed = stripedbass]"
"Pred-Mig" 1.0 0 -14835848 true "" "plot (count turtles with [breed = stripedbass and start-migration? = true]) / count turtles with [breed = stripedbass]"

PLOT
1474
279
1916
539
Level of Net Contamination Exposure 
ticks
mercury
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Hg-prey" 1.0 0 -10141563 true "" "plot mean [hg-exposure-total-normalized] of alewives"
"MeHg-prey" 1.0 0 -13840069 true "" "plot mean [mehg-exposure-total-normalized] of alewives"
"Hg-pred" 1.0 0 -955883 true "" "plot mean [hg-exposure-total-normalized] of stripedbass"
"MeHg-pred" 1.0 0 -2674135 true "" "plot mean [mehg-exposure-total-normalized] of stripedbass"

PLOT
1476
20
1920
271
Duration of Exposure to Harmful Contamination Levels
ticks
duration (ticks)
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"mercury" 1.0 0 -8630108 true "" "plot mean [hg-exposure-duration] of turtles"
"methylmercury" 1.0 0 -13840069 true "" "plot mean [mehg-exposure-duration] of turtles"

PLOT
529
1342
994
1661
Alewife Contamination Dynamics
ticks
uptake risk
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Hg-Ex" 1.0 0 -8630108 true "" "plot mean [hg-uptake-risk] of alewives"
"MeHg-Ex" 1.0 0 -13840069 true "" "plot mean [mehg-uptake-risk] of alewives"
"Hg total" 1.0 0 -11033397 true "" "plot mean [hg-total] of alewives"
"MeHg total" 1.0 0 -5298144 true "" "plot mean [mehg-total] of alewives"
"Hg Foraging" 1.0 0 -7500403 true "" "plot mean [hg-foraging] of alewives"
"MeHg Foraging" 1.0 0 -5825686 true "" "plot mean [mehg-foraging] of alewives"

PLOT
1030
1070
1469
1327
Length Distribution (m)
Length (mm)
Number of Alewives
0.0
10.0
0.0
10.0
true
false
"set-plot-x-range 200 310\n" ""
PENS
"default" 1.0 0 -16777216 true "" "histogram [length-size] of alewives"

PLOT
1477
1069
1926
1328
Weight Distribution (g)
Weight (g)
Number of Alewives
0.0
10.0
0.0
10.0
true
false
"set-plot-x-range 100 310\n" ""
PENS
"default" 1.0 0 -16777216 true "" "histogram [weight] of alewives"

PLOT
1938
1069
2368
1329
Adult Age Distribution (years)
Age (years)
Number of Alewives
-3.0
20.0
0.0
10.0
true
false
"set-plot-x-range 2 6\n" ""
PENS
"Age" 1.0 0 -5298144 true "" "histogram [age-num] of alewives"
"Days at Large" 1.0 0 -14439633 true "" "histogram [days-at-large] of alewives"
"Photoperiod" 1.0 0 -13345367 true "" "histogram [migration-photo] of alewives"

PLOT
642
1078
1020
1330
Weight over Time (g)
time
mean weight (g)
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Prey" 1.0 0 -13840069 true "" "plot sum [weight] of alewives"
"pred" 1.0 0 -5298144 true "" "plot sum [weight] of stripedbass"

PLOT
296
1079
631
1332
Wait Time
ticks
Wait Time (ticks)
0.0
20.0
0.0
20.0
true
false
"" ""
PENS
"alewives wait" 1.0 0 -5825686 true "" "plot mean [wait-ticks] of alewives"
"bass wait" 1.0 0 -14439633 true "" "plot mean [wait-ticks] of stripedbass"

MONITOR
189
245
246
290
Month
month
17
1
11

MONITOR
258
245
315
290
Day
day
17
1
11

MONITOR
327
245
384
290
Hour
hour
17
1
11

TEXTBOX
26
152
309
210
Simulation Year: 2023
24
0.0
1

MONITOR
24
189
120
234
Dataset Month
current-month
17
1
11

MONITOR
24
242
112
287
Dataset Hour
current-hour
17
1
11

MONITOR
25
294
150
339
Dataset Total Hours
total-hours
17
1
11

SLIDER
139
99
311
132
start-month
start-month
4
10
4.0
1
1
Month (#)
HORIZONTAL

PLOT
20
1080
292
1332
Migration Cue
day
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"cue" 1.0 0 -2674135 true "" "plot (ifelse-value cue-active? [1] [0])"

MONITOR
304
143
386
188
Photoperiod
daylength
2
1
11

MONITOR
305
196
388
241
trigger
migration-trigger?
2
1
11

MONITOR
240
196
298
241
cue
cue-active?
17
1
11

PLOT
1475
548
1931
803
Milford Fish Lift Validation
Ticks
Alewives (Scaled)
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Dam Enter" 1.0 0 -15040220 true "" " if ticks mod 288 = 0 [ plot alewives-on-line-daily-total-landward ]"
"Dam Exit" 1.0 0 -955883 true "" " if ticks mod 288 = 0 [ plot alewives-on-line-daily-total-seaward ]"
"m-prob prey" 1.0 0 -13345367 true "" " if ticks mod 288 = 0 [ plot mean [migration-probability] of alewives ]"
"Estuary Enter" 1.0 0 -5825686 true "" "if ticks mod 288 = 0 [ plot alewives-entering-estuary-daily-total ]"
"Estuary Exit" 1.0 0 -5204280 true "" " if ticks mod 288 = 0 [ plot alewives-exiting-estuary-daily-total ]"
"m-prob pred" 1.0 0 -8990512 true "" ";if ticks mod 288 = 0 [ plot mean [migration-probability] of stripedbass ]"

TEXTBOX
84
458
410
518
How much food becomes usable energy?
16
0.0
1

PLOT
18
1340
523
1660
Striped Bass Contamination Dynamics
ticks
contaminant
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Hg-Exp" 1.0 0 -10141563 true "" "plot mean [hg-uptake-risk] of stripedbass"
"MeHg-Exp" 1.0 0 -13840069 true "" "plot mean [mehg-uptake-risk] of stripedbass"
"Hg Total" 1.0 0 -13791810 true "" "plot mean [hg-total] of stripedbass"
"MeHg Total" 1.0 0 -5298144 true "" "plot mean [hg-total] of stripedbass"
"Hg Forage" 1.0 0 -7500403 true "" "plot mean [hg-foraging] of stripedbass"
"MeHg Forage" 1.0 0 -5825686 true "" "plot mean [mehg-foraging] of stripedbass"

PLOT
1005
1340
1417
1662
Predation Dynamics
ticks
consumption
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Consumed" 1.0 0 -13791810 true "" "plot mean [numAlewivesEaten] of stripedbass"
"Prey Pop" 1.0 0 -7858858 true "" "plot count alewives"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
