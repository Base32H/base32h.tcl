# `base32h.tcl`

## What is it?

It's the first reference implementation of an encoder and decoder for
Base32H, a new(-ish) base-32 number representation, written as a
package for Tcl 8.6.

## How do I install it?

Clone this repo into a folder listed in Tcl's `$auto_path` and/or
`$tcl_pkgPath`.

## How do I use it?

```tcl
package require base32h

# base32h <-> decimal encoding and decoding
puts [base32h decode howdy]
# -> 17854910
puts [base32h encode 17854910]
# -> H0WDY
puts [base32h encode 8675309]
# -> 88PZD
puts [base32h decode 88pzd]
# -> 8675309

# Universal base conversion including Base32H
puts [base32h baseconv 01011010 binary base32h]
# -> 2T
puts [base32h baseconv 1245670 octal base32h]
# -> AJXQ
puts [base32h baseconv cafebabe hexadecimal base32h]
# -> 35FXEMY
puts [base32h baseconv 3faufpf base32h hexadecimal]
# -> DEADBEEF
```

## Am I allowed to use it?

Yes, per the terms of the ISC License; see the `COPYING` file in this
repo.
