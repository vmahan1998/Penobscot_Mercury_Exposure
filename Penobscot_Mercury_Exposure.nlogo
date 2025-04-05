extensions [csv gis]
;;NOTE; Counter taken from Canvas and provided by Todd Swannack

__includes[
  "nls/calendar.nls"
  "nls/VariableNames.nls"
  "nls/Create-map.nls"
  "nls/prototypesetup.nls"
  "nls/Create-velocity.nls"
  "nls/Update-velocity.nls"
  "nls/Create-depth.nls"
  "nls/Update-depth.nls"
  ;"nls/Create-salinity.nls"
  ;"nls/Update-salinity.nls"
  ;"nls/Create-SSC.nls"
  ;"nls/Update-SSC.nls"
  "nls/Create-Hg.nls"
  "nls/Create-MeHg.nls"
  "nls/Fill-Missing-Data.nls"
  "nls/Identify-Missing-Patches.nls"
  "nls/Velocity-Color.nls"
  "nls/Schooling.nls"
  "nls/Find-Schoolmates.nls"
  "nls/Find-nearest-neighbor.nls"
  "nls/Align.nls"
  "nls/Cohere.nls"
  "nls/Separate.nls"
  "nls/Setup-Alewives.nls"
  "nls/Setup-StripedBass.nls"
  "nls/Setup-ShortnoseSturgeon.nls"
  "nls/Setup-AtlanticSturgeon.nls"
  "nls/Adjust-Alewife-speed.nls"
  "nls/Adjust-StripedBass-speed.nls"
  "nls/Adjust-ShortnoseSturgeon-speed.nls"
  "nls/Adjust-AtlanticSturgeon-speed.nls"
  "nls/Reporters.nls"
  "nls/Landward-Migration.nls"
  "nls/Seaward-Migration.nls"
  "nls/Selective-Tidal-Stream-Transport.nls"
  "nls/Swim.nls"
  "nls/flee-stripedbass.nls"
  "nls/Eat.nls"
  "nls/Chase-nearest-alewife.nls"
  "nls/Scare-down.nls"
  "nls/Scare-left.nls"
  "nls/Scare-right.nls"
  "nls/Scare-prey.nls"
  "nls/Wander.nls"
  "nls/Count-prey-eaten.nls"
  "nls/Prey-on-Alewives.nls"
  "nls/Mercury-Contamination.nls"
  "nls/Methylmercury-Contamination.nls"
  "nls/Osmoregulation.nls"
  "nls/Staging.nls"
]

to setup
  clear-all ;; reset variables

  ;; Initialize time variables
  set minute 0
  set hour 0
  set day starting-date
  set month "September"
  set monthnum 9

  ;; Initialize the model environment
  if model-type = "penobscot" [setup-GIS]
  if model-type = "prototype" [prototype-setup]

  ;; Set environment parameters based on model type
  if model-type = "penobscot" [penobscot-parameters]
  if model-type = "prototype" [prototype-parameters]

  ;; Agent setup
  set-default-shape turtles "fish"

  ;; Create fish agents randomly in the prototype model
  if model-type = "prototype" [setup-migration]

  ;; Initialize species-specific fish
  if model-type = "penobscot" [
    setup-alewives
    setup-stripedbass
    setup-shortnose
    setup-atlantic
  ]

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
56
385
89
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
188
146
386
179
starting-date
starting-date
0
266
254.0
1
1
day of the year
HORIZONTAL

SLIDER
210
279
382
312
initial-stripedbass
initial-stripedbass
0
1000
10.0
1
1
fish
HORIZONTAL

SLIDER
211
232
383
265
initial-alewives
initial-alewives
0
10000
10.0
1
1
fish
HORIZONTAL

SLIDER
211
327
383
360
initial-shortnose
initial-shortnose
0
1000
10.0
1
1
fish
HORIZONTAL

TEXTBOX
260
196
410
225
Species
24
0.0
1

TEXTBOX
236
422
386
451
Rest Time
24
0.0
1

SLIDER
117
459
384
492
alewife-rest-time
alewife-rest-time
0
1000
52.0
1
1
tick (1 tick = 5 minutes)
HORIZONTAL

SLIDER
94
509
384
542
stripedbass-rest-time
stripedbass-rest-time
0
1000
157.0
1
1
tick (1 tick = 5 minutes)
HORIZONTAL

SLIDER
105
559
386
592
shortnose-rest-time
shortnose-rest-time
0
1000
57.0
1
1
tick (1 tick = 5 minutes)
HORIZONTAL

TEXTBOX
185
19
442
48
Initialize Simulation
24
0.0
1

SLIDER
212
373
384
406
initial-atlantic
initial-atlantic
0
1000
11.0
1
1
NIL
HORIZONTAL

SLIDER
114
611
387
644
atlantic-rest-time
atlantic-rest-time
0
1000
60.0
1
1
tick (1 tick = 5 minutes)
HORIZONTAL

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
<<<<<<< HEAD
1614
872
1830
1028
=======
1471
437
1687
593
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
"Agent Energy" 1.0 0 -13840069 true "" "plot mean [energy] of alewives"

PLOT
<<<<<<< HEAD
1580
275
1792
425
=======
1474
277
1686
427
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
<<<<<<< HEAD
1804
274
2004
424
=======
1697
277
1897
427
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
<<<<<<< HEAD
1578
12
2002
267
=======
1472
15
1896
270
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
"Salinity (psu0" 1.0 0 -16777216 true "" "plot mean [salinity] of patches"
"Acclimated-Salinity" 1.0 0 -817084 true "" "plot mean [acclimated-salinity] of turtles"

PLOT
<<<<<<< HEAD
1800
432
1999
588
=======
1700
439
1899
595
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
Osmoregulation Energy
ticks
Energy Consumed
0.0
1.0
0.0
0.005
true
false
"" ""
PENS
"Osmo_Energy" 1.0 0 -16777216 true "" "plot mean [E-osmo] of turtles"

PLOT
<<<<<<< HEAD
1616
444
2044
694
=======
1030
14
1458
264
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
Velocities
ticks
velocity
0.0
10.0
0.0
1.5
true
true
"" ""
PENS
"Swimming Speed" 1.0 0 -955883 true "" "plot mean [speed] of turtles"
"velocity" 1.0 0 -16777216 true "" "plot mean [velocity] of patches"
"Zero-0" 1.0 0 -7500403 true "" "plot 0"

PLOT
<<<<<<< HEAD
1616
703
1833
853
=======
1030
273
1247
423
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
Swimming Energy
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
"Energy" 1.0 0 -5825686 true "" "plot mean [E-swim] of turtles"

PLOT
<<<<<<< HEAD
1843
703
2045
853
=======
1255
273
1457
423
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
<<<<<<< HEAD
1844
875
2059
1031
=======
1243
431
1458
587
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
"STST" 1.0 0 -13791810 true "" "plot (count turtles with [selective-tidal-transport?]) / count turtles"
"Staging" 1.0 0 -5825686 true "" "plot (count turtles with [staging?]) / count turtles"

PLOT
<<<<<<< HEAD
1034
13
1476
265
=======
1027
607
1469
859
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
"mercury" 1.0 0 -10141563 true "" "plot mean [mehg-exposure-total-normalized] of turtles"
"methylmercury" 1.0 0 -13840069 true "" "plot mean [hg-exposure-total-normalized] of turtles"

PLOT
<<<<<<< HEAD
1034
272
1478
523
=======
2020
280
2464
531
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
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
<<<<<<< HEAD
1035
529
1480
807
=======
1477
604
1922
882
>>>>>>> c23e214161e140da65d32faadb4c0d3d5ec22f8f
Contamination Uptake Risk
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
"mercury" 1.0 0 -8630108 true "" "plot mean [hg-uptake-risk] of turtles"
"methylmercury" 1.0 0 -13840069 true "" "plot mean [mehg-uptake-risk] of turtles"

SLIDER
216
669
389
702
align-coefficient
align-coefficient
0
100
53.0
1
1
%
HORIZONTAL

SLIDER
216
715
389
748
cohere-coefficient
cohere-coefficient
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
218
759
391
792
separate-coefficient
separate-coefficient
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
190
802
395
835
minimum-separation
minimum-separation
0
1
0.01
.01
1
patches
HORIZONTAL

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
