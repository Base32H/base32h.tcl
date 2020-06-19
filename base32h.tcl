package provide base32h 0.1

namespace eval base32h {
    namespace export encode decode baseconv fit
    namespace ensemble create

    variable digits \
	[list 0oO 1iI 2 3 4 5sS 6 7 8 9 \
	     Aa Bb Cc Dd Ee Ff Gg Hh Jj Kk Ll Mm Nn Pp Qq Rr Tt VvUu Ww Xx Yy Zz]

    proc encode {int} {
        baseconv $int decimal base32h
    }

    proc decode {int} {
        baseconv $int base32h decimal
    }

    proc baseconv {num from to} {
	set binary \
	    [list 0 1]
	# It's a bit inefficient to deal with octal and decimal
	# integers manually like this when Tcl already understands
	# both, but I'd much rather be explicit here in order to
	# allow decimal numbers with leading zeroes to still be
	# treated correctly.
	set octal \
	    [list 0 1 2 3 4 5 6 7]
	set decimal \
	    [list 0 1 2 3 4 5 6 7 8 9]
	set hexadecimal \
	    [list 0 1 2 3 4 5 6 7 8 9 Aa Bb Cc Dd Ee Ff]

	switch $from {
	    binary      {set from $binary}
	    octal       {set from $octal}
	    decimal     {set from $decimal}
	    hexadecimal {set from $hexadecimal}
	    base32h     {set from $::base32h::digits}
	    default     {}
	}

	switch $to {
	    binary      {set to $binary}
	    octal       {set to $octal}
	    decimal     {set to $decimal}
	    hexadecimal {set to $hexadecimal}
	    base32h     {set to $::base32h::digits}
	    default     {}
	}

	set frombase [llength $from]
	set tobase   [llength $to]
	set inter    0
	set res      {}

	# Convert to decimal first
	set exp 0
	while {[string length $num] > 0} {
	    set digit [string index $num end]
	    set value [lsearch $from *${digit}*]

	    if {$value == -1} {
		error "Digit not in specified digit set: $digit"
	    }

	    set inter [expr {$inter + $value * $frombase**$exp}]
	    set num [string range $num 0 end-1]
	    incr exp
	}

	# Now convert to the target base
	set exp 0
	set rem 0
	while {$inter > 0} {
	    set rem [expr {$inter % $tobase}]
	    if {$tobase == 1} {

	    } else {
		set inter [expr {$inter / $tobase}]
	    }
	    set digit [string index [lindex $to $rem] 0]
	    set res $digit$res
	}

	return $res
    }

    proc fit {int size} {
	set len [string length $int]
	if {$len < $size} {
	    set diff [expr {$size - $len}]
	    while {$diff > 0} {
		set int 0$int
		incr diff -1
	    }
	} else {
	    set start [expr {$size - 1}]
	    set int [string range $int end-$start end]
	}

	return $int
    }
}
