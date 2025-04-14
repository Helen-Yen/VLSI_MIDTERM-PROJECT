***------------------------------------***
***          VLSI 2021 Lab1            ***
***         multiplexer w/ DFF         ***
***            student ID:             ***
***------------------------------------***

***-----------------------***
***        setting        ***
***-----------------------***
.lib "umc018.l" L18U18V_TT
.TEMP 25
.op
.options post

***-----------------------***
***      parameters       ***
***-----------------------***
.global VDD GND
.param supply=1.8v
.param load=10f


.param wp=0.6u
.param wn=0.24u

***-----------------------***
***       simulation      ***
***-----------------------***
.tran 0.1n 20n

***-----------------------***
***      measurements     ***
***-----------------------***
.meas tran AVG_Ckt_Pwr AVG power
.meas tran avg_power avg power from=0.1ns to=40ns
.meas tran Iavg avg I(Vd) from=0.1ns to=40ns
.meas Pavg param='Iavg*supply'
.meas tran Imax max I(Vd) from=0.1ns to=40ns
.meas Pmax param='abs(Imax)*supply'

.meas tran tp1 trig v(A) val='supply/2' rise=1
+targ v(y) val='supply/2' rise=1
.meas tran tp2 trig v(B) val='supply/2' fall=1
+targ v(y) val='supply/2' fall=1
.meas tran tp3 trig v(A) val='supply/2' rise=3
+targ v(y) val='supply/2' rise=2
.meas tran tp4 trig v(A) val='supply/2' fall=3
+targ v(y) val='supply/2' fall=2
.meas tran tp5 trig v(A) val='supply/2' rise=4
+targ v(y) val='supply/2' rise=3
.meas tran tp6 trig v(A) val='supply/2' fall=4
+targ v(y) val='supply/2' fall=3

.meas tran tr1 trig v(y) val='supply*0.1' rise=1
+targ v(y) val='supply*0.9' rise=1
.meas tran tr2 trig v(y) val='supply*0.1' rise=2
+targ v(y) val='supply*0.9' rise=2
.meas tran tr3 trig v(y) val='supply*0.1' rise=3
+targ v(y) val='supply*0.9' rise=3

.meas tran tf1 trig v(y) val='supply*0.9' fall=1
+targ v(y) val='supply*0.1' fall=1
.meas tran tf2 trig v(y) val='supply*0.9' fall=2
+targ v(y) val='supply*0.1' fall=2
.meas tran tf3 trig v(y) val='supply*0.9' fall=3
+targ v(y) val='supply*0.1' fall=3

***-----------------------***
***      power/input      ***
***-----------------------***
VDD VDD GND supply
VA A GND pulse(0 supply 1ns 0.1ns 0.1ns 0.9ns 2ns)
VB B GND pulse(0 supply 1ns 0.1ns 0.1ns 1.9ns 4ns)
VSEL SEL GND pulse(0 supply 1ns 0.1ns 0.1ns 3.9ns 8ns)
VEN EN GND pulse(0 supply 1ns 0.1ns 0.1ns 7.9ns 16ns)
Vclk clk GND pulse(0 supply 0ns 0.1ns 0.1ns 0.49ns 1ns)

***-----------------------***
***        circuit        ***
***-----------------------***
XMUX_SEQ A B SEL EN Q QB CLK CLKB MUX_SEQ
Cload Q GND load

***-----------------------***
***      sub-circuit      ***
***-----------------------***
.subckt INV IN1 OUT1
mp OUT1 IN1 VDD VDD P_18_G2 l=0.18u w=wp
mn OUT1 IN1 GND GND N_18_G2 l=0.18u w=wn
.ends

.subckt TRI IN2 SEL1 SELB OUT2
mp1 1  IN2 VDD VDD P_18_G2 l=0.18u w=wp
mp2 OUT2 SELB 1 VDD P_18_G2 l=0.18u w=wp
mn1 OUT2 SEL1 2 GND N_18_G2 l=0.18u w=wn
mn2 2 IN2 GND GND N_18_G2 l=0.18u w=wn
.ends

.subckt MUX A B SEL EN Y
XINV1 SEL SELB INV
XINV11 EN ENB INV
XTRI1 A SELB SEL OUT1 TRI
XTRI2 B SEL SELB OUT1 TRI
XINV2 OUT1 OUT2 INV
XINV3 OUT2 OUT3 INV
XTRI3 OUT3 EN ENB Y TRI
.ends

.subckt TRANSMISSION IN1 N P OUT1
mp OUT1 P IN1  VDD P_18_G2 l=0.18u w=wp
mn IN1  N OUT1 GND N_18_G2 l=0.18u w=wn
.ends

.subckt DFF D QB Q CLK CLKB
XINV1 CLK CLKB INV
XINV2 D OUT1 INV
XTRANS1 OUT1 CLKB CLK OUT2 TRANSMISSION
XINV22 OUT2 OUT3 INV
XTRI1 OUT3 CLK CLKB OUT2 TRI
XTRANS2 OUT3 CLK CLKB OUT4 TRANSMISSION
XINV3 OUT4 OUT5 INV
XINV4 OUT4 QB INV
XINV5 OUT5 Q INV
XTRI2 OUT5 CLKB CLK OUT4 TRI
.ends

.subckt MUX_SEQ A B SEL EN Q QB CLK CLKB
XMUX A B SEL EN Y MUX
XDFF Y QB Q CLK CLKB DFF
.ends

.alter
.param wp=1.2u
.param load=10f

.alter
.param wp=2.4u
.param load=10f

.alter
.param load=20f
.param wp=0.6u

.alter
.param load=20f
.param wp=1.2u

.alter
.param load=20f
.param wp=2.4u

.alter
.param load=30f
.param wp=0.6u

.alter
.param load=30f
.param wp=1.2u

.alter
.param load=30f
.param wp=2.4u


.end
