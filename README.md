Address Decoding Circuits
=========================

```text
6502 pin 25 (a15) tied to 6532 pin 37 (/cs2)
             also tied to 6522 pin 24 (cs1)

6502 pin 24 (a14) tied to 7404 pin 7 (in)
                          7404 pin 8 (out) tied to 2716 pin 20 (/OE) and pin 18 (/CE)
                          7404 pin 8 (out) tied to 6532 pin 38 (CS1)

6502 pin 23 (a13) tied to 6522 pin 23 (/cs2)
             also tied to 6850 pin 10 (cs1)

6502 pin 19 (a10) tied to 6532 pin 36 (/rs)


6850 cs0 hardwired high

6850 /cs2 tied to 6502 pin 24 (a14)
6850 cs1 tied to 6502 pin 23 (a13)
6850 E tied to 6502 pin 39 (phi2)
```

Address Decoding
================

```text
Selected   A15  A14  A13  A12  A11  A10   Base    Mirror Used by Firmware
---------- ---  ---  ---  ---  ---  ---   -----   -----------------------
6532 RAM    0    0    X    X    X    0    $0000   $0000
6532 I/O    0    0    X    X    X    1    $0400   $0400
6522 VIA    1    X    0    X    X    X    $8000   $8000
6850 ACIA   X    0    1    X    X    X    $2000   $A000
2716 EPROM  X    1    X    X    X    X    $4000   $F000
```

Interrupt Connections
=====================

```text
6850 /IRQ is pulled up to Vcc but not otherwise connected
6532 /IRQ is no-connect
```

I/O Connections
===============

```text
6522 VIA pin 17 (pb7) -> 6850 pin 4     OUTPUT
6522 VIA pin 16 (pb6) <- 7417 pin 10    INPUT
6522 VIA pin 15 (pb5) <- 7417 pin 12    INPUT
6522 VIA pin 14 (pb4) -> 7417 pin 4     OUTPUT??
6522 VIA pin 13 (pb3) <- 7417 pin 11    INPUT
6222 VIA pin 12 (pb2) <- R5 <- U11 3446 pin 6 INPUT
  U11 pin 6 -> Upper Leg of R5 Pull-up
  U11 pin 5 -> Left Leg of R6, DIN pin 1 SRQ
6522 VIA pin 11 (pb1) -> 7417 pin 9     OUTPUT (LED)
6522 VIA pin 10 (pb0) <- R12 -> U11 3446 pin 16   INPUT

6522 VIA pin  3 (pa1) <- U9 3446 pin 13  INPUT
6522 VIA pin  4 (pa2) <- U9 3446 pin 11  INPUT
6522 VIA pin  6 (pa4) <- U9 3446 pin 5   INPUT
6522 VIA pin  7 (pa5) <- U9 3446 pin 3   INPUT
```

RS-232
======

I believe that the RS-232 port is transmit only because I could find no
reference to the ACIA’s Receive Data Register (RDR) in the firmware. This
makes sense on one hand because it was probably intended to be used with a
printer. There is a 1489 Quad Line Receiver on the board, so I hope that the
hardware will support it even if I am correct and the firmware does not.


ROM Expansion
=============

If you need to burn the original firmware but don’t have a 2716 (2Kx8) handy,
you may substitute a 2732 (4Kx8). Burning the firmware into the upper half (or
both halves). The Interpod has pin 21 (Vpp on 2716, A11 on 2732) hardwired to
Vcc.

The Interpod firmware leaves only about 15 bytes free of its 2K EPROM. More
space is needed to add any new functionality. You can replace the EPROM with a
2732 and double the amount of ROM space to 4K by making a small modification
to the Interpod.

Cut the trace on the top side of the board from U3 pin 24 (Vcc) to U3 pin 21.
On the 2716, pin 21 is Vpp. On the 2732, pin 21 is A11. Add a jumper wire from
U3 pin 21 to U1 pin 20.

C64 Power Supply
================

The Interpod requires an external power supply that plugs into a 7-pin female
DIN socket on the side of the unit, next to the RS-232C port. This is the same
DIN connector that is used by the Commodore 64 but the pin configuration is
different.

I do not have the original Interpod power supply. Ruud Baltissen does and he
reported it uses only two pins on the DIN socket. I confirmed on the Interpod
circuit board that all other pins on the DIN socket are unconnected. If the
female DIN socket is compared to a compass, only the pins at West and
North-West (left of the key) are used. Ruud measured his Interpod power supply
on these pins at 8.7VAC, unloaded.

The Commodore 64 power supply produces both 5VDC and 9VAC. Luckily, one of its
9VAC legs is the same pin as the Interpod. I added a jumper wire for the other
pin that makes the Interpod compatible with the C64 power supply.
