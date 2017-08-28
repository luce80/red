Red/System [
	Title:	"Cairo Draw dialect backend"
	Author: "Qingtian Xie"
	File: 	%draw.reds
	Tabs: 	4
	Rights: "Copyright (C) 2016 Qingtian Xie. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

#include %text-box.reds

set-source-color: func [
	cr			[handle!]
	color		[integer!]
	/local
		r		[float!]
		b		[float!]
		g		[float!]
		a		[float!]
][
	r: as-float color and FFh
	r: r / 255.0
	g: as-float color >> 8 and FFh
	g: g / 255.0
	b: as-float color >> 16 and FFh
	b: b / 255.0
	a: as-float 255 - (color >>> 24)
	a: a / 255.0
	cairo_set_source_rgba cr r g b a
]

draw-begin: func [
	ctx			[draw-ctx!]
	cr			[handle!]
	img			[red-image!]
	on-graphic?	[logic!]
	paint?		[logic!]
	return:		[draw-ctx!]
][
	ctx/raw:			cr
	ctx/pen-width:		1.0
	ctx/pen-style:		0
	ctx/pen-color:		0						;-- default: black
	ctx/pen-join:		miter
	ctx/pen-cap:		flat
	ctx/brush-color:	0
	ctx/font-color:		0
	ctx/pen?:			yes
	ctx/brush?:			no
	ctx/pattern:		null

	cairo_set_line_width cr 1.0
	set-source-color cr 0
	ctx
]

draw-end: func [
	dc			[draw-ctx!]
	hWnd		[handle!]
	on-graphic? [logic!]
	cache?		[logic!]
	paint?		[logic!]
][
	0
]

do-paint: func [dc [draw-ctx!] /local cr [handle!]][
	cr: dc/raw
	if dc/brush? [
		cairo_save cr
		either null? dc/pattern [
			set-source-color cr dc/brush-color
		][
			cairo_set_source cr dc/pattern
		]
		cairo_fill_preserve cr
		unless dc/pen? [
			set-source-color cr dc/pen-color 
			cairo_stroke cr
		]
		cairo_restore cr
	]
	if dc/pen? [
		cairo_stroke cr
	]
]

OS-draw-anti-alias: func [
	dc	[draw-ctx!]
	on? [logic!]
][
0
]

OS-draw-line: func [
	dc	   [draw-ctx!]
	point  [red-pair!]
	end	   [red-pair!]
	/local
		cr [handle!]
][
	cr: dc/raw
	while [point <= end][
		cairo_line_to cr as-float point/x as-float point/y
		point: point + 1
	]
	do-paint dc
]

OS-draw-pen: func [
	dc	   [draw-ctx!]
	color  [integer!]									;-- 00bbggrr format
	off?   [logic!]
	alpha? [logic!]
][
	dc/pen?: not off?
	if dc/pen-color <> color [
		dc/pen-color: color
		set-source-color dc/raw color
	]
]

OS-draw-fill-pen: func [
	dc	   [draw-ctx!]
	color  [integer!]									;-- 00bbggrr format
	off?   [logic!]
	alpha? [logic!]
][
	dc/brush?: not off?
	unless null? dc/pattern [
		cairo_pattern_destroy dc/pattern
		dc/pattern: null
	]
	if dc/brush-color <> color [
		dc/brush-color: color
	]
]

OS-draw-line-width: func [
	dc	  [draw-ctx!]
	width [red-value!]
	/local
		w [float!]
][
	w: get-float as red-integer! width
	if dc/pen-width <> w [
		dc/pen-width: w
		cairo_set_line_width dc/raw w
	]
]

OS-draw-box: func [
	dc	  [draw-ctx!]
	upper [red-pair!]
	lower [red-pair!]
	/local
		radius	[red-integer!]
		rad		[integer!]
		x		[float!]
		y		[float!]
		w		[float!]
		h		[float!]
][
	either TYPE_OF(lower) = TYPE_INTEGER [
		radius: as red-integer! lower
		lower:  lower - 1
		rad: radius/value * 2
		;;@@ TBD round box
	][
		x: as-float upper/x
		y: as-float upper/y
		w: as-float lower/x - upper/x
		h: as-float lower/y - upper/y
		cairo_rectangle dc/raw x y w h
		do-paint dc
	]
]

OS-draw-triangle: func [
	dc	  [draw-ctx!]
	start [red-pair!]
][
	loop 3 [
		cairo_line_to dc/raw as-float start/x as-float start/y
		start: start + 1
	]
	cairo_close_path dc/raw								;-- close the triangle
	do-paint dc
]

OS-draw-polygon: func [
	dc	  [draw-ctx!]
	start [red-pair!]
	end	  [red-pair!]
][
	until [
		cairo_line_to dc/raw as-float start/x as-float start/y
		start: start + 1
		start > end
	]
	cairo_close_path dc/raw
	do-paint dc
]

OS-draw-spline: func [
	dc		[draw-ctx!]
	start	[red-pair!]
	end		[red-pair!]
	closed? [logic!]
	/local
		ctx		[handle!]
		p		[red-pair!]
		p0		[red-pair!]
		p1		[red-pair!]
		p2		[red-pair!]
		p3		[red-pair!]
		x		[float32!]
		y		[float32!]
		delta	[float32!]
		t		[float32!]
		t2		[float32!]
		t3		[float32!]
		i		[integer!]
		n		[integer!]
		count	[integer!]
		num		[integer!]
][
	comment {
	; this is copy from macOS/draw.reds impl
	; seems not to work now..

	ctx: dc/raw

	count: (as-integer end - start) >> 4
	num: count + 1 + 2

	p: start

	cairo_move_to ctx as-float p/x as-float p/y

	i: 0
	delta: (as float32! 1.0) / (as float32! 25.0)

	while [i < count][						;-- CatmullRom Spline, tension = 0.5
		p0: p + (i % num)
		p1: p + (i + 1 % num)
		p2: p + (i + 2 % num)
		p3: p + (i + 3 % num)

		t: as float32! 0.0
		n: 0
		until [
			t: t + delta
			t2: t * t
			t3: t2 * t

			x: (as float32! 2.0) * p1/x + (p2/x - p0/x * t) +
			   (((as float32! 2.0) * p0/x - ((as float32! 5.0) * p1/x) + ((as float32! 4.0) * p2/x) - p3/x) * t2) +
			   ((as float32! 3.0) * (p1/x - p2/x) + p3/x - p0/x * t3) * 0.5
			y: (as float32! 2.0) * p1/y + (p2/y - p0/y * t) +
			   (((as float32! 2.0) * p0/y - ((as float32! 5.0) * p1/y) + ((as float32! 4.0) * p2/y) - p3/y) * t2) +
			   ((as float32! 3.0) * (p1/y - p2/y) + p3/y - p0/y * t3) * 0.5

			cairo_line_to ctx as-float x as-float y

			n: n + 1
			n = 25
		]
		i: i + 4 
	]
	if closed? [
		cairo_close_path dc/raw
	]
	do-paint dc

	} ; comment
]

OS-draw-circle: func [
	dc	   [draw-ctx!]
	center [red-pair!]
	radius [red-integer!]
	/local
		ctx   [handle!]
		rad-x [integer!]
		rad-y [integer!]
		w	  [float!]
		h	  [float!]
		f	  [red-float!]
][
	ctx: dc/raw

	either TYPE_OF(radius) = TYPE_INTEGER [
		either center + 1 = radius [					;-- center, radius
			rad-x: radius/value
			rad-y: rad-x
		][
			rad-y: radius/value							;-- center, radius-x, radius-y
			radius: radius - 1
			rad-x: radius/value
		]
		w: as float! rad-x * 2
		h: as float! rad-y * 2
	][
		f: as red-float! radius
		either center + 1 = radius [
			rad-x: as-integer f/value + 0.75
			rad-y: rad-x
			w: as float! f/value * 2.0
			h: w
		][
			rad-y: as-integer f/value + 0.75
			h: as float! f/value * 2.0
			f: f - 1
			rad-x: as-integer f/value + 0.75
			w: as float! f/value * 2.0
		]
	]

	cairo_save ctx
	cairo_translate ctx as-float center/x
						as-float center/y
	cairo_scale ctx as-float rad-x
					as-float rad-y
	cairo_arc ctx 0.0 0.0 1.0 0.0 2.0 * pi
	cairo_restore ctx
	do-paint dc
]

OS-draw-ellipse: func [
	dc		 [draw-ctx!]
	upper	 [red-pair!]
	diameter [red-pair!]
	/local
		ctx   [handle!]
		rad-x [integer!]
		rad-y [integer!]
][
	ctx: dc/raw
	rad-x: diameter/x / 2
	rad-y: diameter/y / 2

	cairo_save ctx
	cairo_translate ctx as-float upper/x + rad-x
						as-float upper/y + rad-y
	cairo_scale ctx as-float rad-x
					as-float rad-y
	cairo_arc ctx 0.0 0.0 1.0 0.0 2.0 * pi
	cairo_restore ctx
	do-paint dc
]

OS-draw-font: func [
	dc		[draw-ctx!]
	font	[red-object!]
	/local
		ctx   [handle!]
		len   [integer!]
		face  [handle!]
		; vals  [red-value!]
		; state [red-block!]
		; int   [red-integer!]
		; color [red-tuple!]
		; hFont [draw-ctx!]
][
	ctx: dc/raw
	len: -1
	face: cairo_toy_font_face_create 
		;unicode/to-utf8 font/name :len  ; family string
		"Impact"
		0								; slant  normal\italic
		0								; weight normal\bold
	cairo_set_font_face ctx face
	;cairo_set_font_size ctx as-float font/size
	cairo_set_font_size ctx as-float 15 
]

OS-draw-text: func [
	dc		[draw-ctx!]
	pos		[red-pair!]
	text	[red-string!]
	/local
		ctx		[handle!]
		len     [integer!]
		str		[c-string!]
][
	ctx: dc/raw
	len: -1
	str: unicode/to-utf8 text :len
	cairo_move_to ctx as-float pos/x
					  as-float pos/y
	cairo_show_text ctx str
	do-paint dc
]

OS-draw-arc: func [
	dc	   [draw-ctx!]
	center [red-pair!]
	end	   [red-value!]
	/local
		ctx			[handle!]
		radius		[red-pair!]
		angle		[red-integer!]
		begin		[red-integer!]
		cx			[float!]
		cy			[float!]
		rad-x		[float!]
		rad-y		[float!]
		angle-begin [float!]
		angle-end	[float!]
		rad			[float!]
		sweep		[integer!]
		i			[integer!]
		closed?		[logic!]
][
	ctx: dc/raw
	cx: as float! center/x
	cy: as float! center/y
	rad: PI / 180.0

	radius: center + 1
	rad-x: as float! radius/x
	rad-y: as float! radius/y
	begin: as red-integer! radius + 1
	angle-begin: rad * as float! begin/value
	angle: begin + 1
	sweep: angle/value
	i: begin/value + sweep
	angle-end: rad * as float! i

	closed?: angle < end

	cairo_save ctx
	cairo_translate ctx cx    cy
	cairo_scale     ctx rad-x rad-y
	cairo_arc ctx 0.0 0.0 1.0 angle-begin angle-end
	if closed? [
		cairo_close_path ctx
	]
	cairo_restore ctx
	do-paint dc
]

OS-draw-curve: func [
	dc	  [draw-ctx!]
	start [red-pair!]
	end	  [red-pair!]
	/local
		ctx   [handle!]
		p2	  [red-pair!]
		p3	  [red-pair!]
][
	ctx: dc/raw

	if (as-integer end - start) >> 4 = 3    ; four input points 
	[
		cairo_move_to ctx as-float start/x 
						  as-float start/y
		start: start + 1
	]

	p2: start + 1
	p3: start + 2
	cairo_curve_to ctx as-float start/x
					   as-float start/y
					   as-float p2/x
					   as-float p2/y
					   as-float p3/x
					   as-float p3/y
	do-paint dc
]

OS-draw-line-join: func [
	dc	  [draw-ctx!]
	style [integer!]
	/local
		mode [integer!]
][
	if dc/pen-join <> style [
		dc/pen-join: style
		cairo_set_line_join dc/raw 
			case [
				style = miter		[0]
				style = _round		[1]
				style = bevel		[2]
				style = miter-bevel	[0]
				true				[0]
			]
	]
]
	
OS-draw-line-cap: func [
	dc	  [draw-ctx!]
	style [integer!]
	/local
		mode [integer!]
][
	if dc/pen-cap <> style [
		dc/pen-cap: style
		cairo_set_line_cap dc/raw
			case [
				style = flat		[0]
				style = _round		[1]
				style = square		[2]
				true				[0]
			]
	]
]

OS-draw-image: func [
	dc			[draw-ctx!]
	image		[red-image!]
	start		[red-pair!]
	end			[red-pair!]
	key-color	[red-tuple!]
	border?		[logic!]
	crop1		[red-pair!]
	pattern		[red-word!]
	/local
		x		[integer!]
		y		[integer!]
		width	[integer!]
		height	[integer!]
][
0
]

OS-draw-grad-pen-old: func [
	dc			[draw-ctx!]
	type		[integer!]
	mode		[integer!]
	offset		[red-pair!]
	count		[integer!]					;-- number of the colors
	brush?		[logic!]
	/local
		x		[float!]
		y		[float!]
		start	[float!]
		stop	[float!]
		pattern	[handle!]
		int		[red-integer!]
		f		[red-float!]
		head	[red-value!]
		next	[red-value!]
		clr		[red-tuple!]
		n		[integer!]
		delta	[float!]
		p		[float!]
		scale?	[logic!]
][
	x: as-float offset/x
	y: as-float offset/y

	int: as red-integer! offset + 1
	start: as-float int/value
	int: int + 1
	stop: as-float int/value

	pattern: either type = linear [
		cairo_pattern_create_linear x + start y x + stop y
	][
		cairo_pattern_create_radial x y start x y stop
	]

	n: 0
	scale?: no
	y: 1.0
	while [
		int: int + 1
		n < 3
	][								;-- fetch angle, scale-x and scale-y (optional)
		switch TYPE_OF(int) [
			TYPE_INTEGER	[p: as-float int/value]
			TYPE_FLOAT		[f: as red-float! int p: f/value]
			default			[break]
		]
		switch n [
			0	[0]					;-- rotation
			1	[x:	p scale?: yes]
			2	[y:	p]
		]
		n: n + 1
	]

	if scale? [0]

	delta: 1.0 / as-float count - 1
	p: 0.0
	head: as red-value! int
	loop count [
		clr: as red-tuple! either TYPE_OF(head) = TYPE_WORD [_context/get as red-word! head][head]
		next: head + 1
		n: clr/array1
		x: as-float n and FFh
		x: x / 255.0
		y: as-float n >> 8 and FFh
		y: y / 255.0
		start: as-float n >> 16 and FFh
		start: start / 255.0
		stop: as-float 255 - (n >>> 24)
		stop: stop / 255.0
		if TYPE_OF(next) = TYPE_FLOAT [head: next f: as red-float! head p: f/value]
		cairo_pattern_add_color_stop_rgba pattern p x y start stop
		p: p + delta
		head: head + 1
	]

	if brush? [dc/brush?: yes]				;-- set brush, or set pen
	unless null? dc/pattern [cairo_pattern_destroy dc/pattern]
	dc/pattern: pattern
]

OS-draw-grad-pen: func [
	ctx			[draw-ctx!]
	type		[integer!]
	stops		[red-value!]
	count		[integer!]
	skip-pos?	[logic!]
	positions	[red-value!]
	focal?		[logic!]
	spread		[integer!]
	brush?		[logic!]
][
	
]

OS-matrix-rotate: func [
	dc		[draw-ctx!]
	pen		[integer!]
	angle	[red-integer!]
	center	[red-pair!]
	/local
		cr 	[handle!]
		rad [float!]
][
	cr: dc/raw
	rad: PI / 180.0 * get-float angle
	cairo_translate cr as float! center/x 
					   as float! center/y
	cairo_rotate cr rad
	cairo_translate cr as float! (0 - center/x) 
					   as float! (0 - center/y)
]

OS-matrix-scale: func [
	dc		[draw-ctx!]
	pen		[integer!]
	sx		[red-integer!]
	sy		[red-integer!]
	/local
		cr [handle!]
][
	cr: dc/raw
	cairo_scale cr as-float sx/value
				   as-float sy/value
]

OS-matrix-translate: func [
	dc	[draw-ctx!]
	pen	[integer!]
	x	[integer!]
	y	[integer!]
	/local
		cr [handle!]
][
	cr: dc/raw
	cairo_translate cr as-float x 
					   as-float y
]

OS-matrix-skew: func [
	dc		[draw-ctx!]
	pen		[integer!]
	sx		[red-integer!]
	sy		[red-integer!]
	/local
		m	[integer!]
		x	[float32!]
		y	[float32!]
		u	[float32!]
		z	[float32!]
][
	m: 0
	u: as float32! 1.0
	z: as float32! 0.0
	x: as float32! tan degree-to-radians get-float sx TYPE_TANGENT
	y: as float32! either sx = sy [0.0][tan degree-to-radians get-float sy TYPE_TANGENT]
]

OS-matrix-transform: func [
	dc			[draw-ctx!]
	pen			[integer!]
	center		[red-pair!]
	scale		[red-integer!]
	translate	[red-pair!]
	/local
		rotate	[red-integer!]
		center? [logic!]
][
	rotate: as red-integer! either center + 1 = scale [center][center + 1]
	center?: rotate <> center

	OS-matrix-rotate dc pen rotate center
	OS-matrix-scale dc pen scale scale + 1
	OS-matrix-translate dc pen translate/x translate/y
]

OS-matrix-push: func [dc [draw-ctx!] /local state [integer!]][
	state: 0
]

OS-matrix-pop: func [dc [draw-ctx!]][0]

OS-matrix-reset: func [
	dc [draw-ctx!]
	pen [integer!]
	/local
		cr [handle!]
][
	cr: dc/raw
	cairo_identity_matrix cr
]

OS-matrix-invert: func [
	dc	[draw-ctx!]
	pen	[integer!]
][]

OS-matrix-set: func [
	dc		[draw-ctx!]
	pen		[integer!]
	blk		[red-block!]
	/local
		m	[integer!]
		val [red-integer!]
][
	m: 0
	val: as red-integer! block/rs-head blk
]

OS-set-matrix-order: func [
	ctx		[draw-ctx!]
	order	[integer!]
][
	0
]

OS-set-clip: func [
	dc		[draw-ctx!]
	upper	[red-pair!]
	lower	[red-pair!]
][
]

;-- shape sub command --

OS-draw-shape-beginpath: func [
	dc			[draw-ctx!]
	/local
		path	[integer!]
][

]

OS-draw-shape-endpath: func [
	dc			[draw-ctx!]
	close?		[logic!]
	return:		[logic!]
	/local
		alpha	[byte!]
][
	true
]

OS-draw-shape-moveto: func [
	dc		[draw-ctx!]
	coord	[red-pair!]
	rel?	[logic!]
][
	
]

OS-draw-shape-line: func [
	dc			[draw-ctx!]
	start		[red-pair!]
	end			[red-pair!]
	rel?		[logic!]
][

]

OS-draw-shape-axis: func [
	dc			[draw-ctx!]
	start		[red-value!]
	end			[red-value!]
	rel?		[logic!]
	hline		[logic!]
][
	
]

OS-draw-shape-curve: func [
	dc		[draw-ctx!]
	start	[red-pair!]
	end		[red-pair!]
	rel?	[logic!]
][
]

OS-draw-shape-qcurve: func [
	dc		[draw-ctx!]
	start	[red-pair!]
	end		[red-pair!]
	rel?	[logic!]
][
	;draw-curves dc start end rel? 2
]

OS-draw-shape-curv: func [
	dc		[draw-ctx!]
	start	[red-pair!]
	end		[red-pair!]
	rel?	[logic!]
][
	;draw-short-curves dc start end rel? 2
]

OS-draw-shape-qcurv: func [
	dc		[draw-ctx!]
	start	[red-pair!]
	end		[red-pair!]
	rel?	[logic!]
][
	;draw-short-curves dc start end rel? 1
]

OS-draw-shape-arc: func [
	dc		[draw-ctx!]
	end		[red-pair!]
	sweep?	[logic!]
	large?	[logic!]
	rel?	[logic!]
][
	
]

OS-draw-shape-close: func [
	ctx		[draw-ctx!]
][]

OS-draw-brush-bitmap: func [
	ctx		[draw-ctx!]
	img		[red-image!]
	crop-1	[red-pair!]
	crop-2	[red-pair!]
	mode	[red-word!]
	brush?	[logic!]
][]

OS-draw-brush-pattern: func [
	dc		[draw-ctx!]
	size	[red-pair!]
	crop-1	[red-pair!]
	crop-2	[red-pair!]
	mode	[red-word!]
	block	[red-block!]
	brush?	[logic!]
][]
