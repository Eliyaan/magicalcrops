import time
import net
import os
import gg

const crafts = {
	u8(1): [[Craft(ItemQt{161, 8})]]
	2:     [[Craft(ItemQt{161, 8}), ItemQt{1, 1}]]
	3:     [[Craft(ItemQt{162, 8}), ItemQt{2, 1}]]
	4:     [[Craft(ItemQt{163, 8}), ItemQt{3, 1}]]
	5:     [[Craft(ItemQt{164, 8}), ItemQt{4, 1}]]
	6:     [[Craft(ItemQt{165, 8}), ItemQt{5, 1}]]
	7:     [[Craft(ItemQt{166, 8}), ItemQt{6, 1}]]
	8:     [[Craft(ItemQt{167, 8}), ItemQt{7, 1}]]
	11:    [[Craft(ItemQt{168, 8}), ItemQt{8, 1}]]
	12:    [[Craft(ItemQt{171, 8}), ItemQt{11, 1}]]
	13:    [[Craft(ItemQt{172, 8}), ItemQt{12, 1}]]
	14:    [[Craft(ItemQt{173, 8}), ItemQt{13, 1}]]
	15:    [[Craft(ItemQt{174, 8}), ItemQt{14, 1}]]
	16:    [[Craft(ItemQt{175, 8}), ItemQt{15, 1}]]
	17:    [[Craft(ItemQt{176, 8}), ItemQt{16, 1}]]
	18:    [[Craft(ItemQt{177, 8}), ItemQt{17, 1}]]
	21:    [[Craft(ItemQt{178, 8}), ItemQt{18, 1}]]
	22:    [[Craft(ItemQt{181, 8}), ItemQt{21, 1}]]
	23:    [[Craft(ItemQt{182, 8}), ItemQt{22, 1}]]
	24:    [[Craft(ItemQt{183, 8}), ItemQt{23, 1}]]
	25:    [[Craft(ItemQt{184, 8}), ItemQt{24, 1}]]
	26:    [[Craft(ItemQt{185, 8}), ItemQt{25, 1}]]
	27:    [[Craft(ItemQt{186, 8}), ItemQt{26, 1}]]
	28:    [[Craft(ItemQt{187, 8}), ItemQt{27, 1}]]
	31:    [[Craft(ItemQt{188, 8}), ItemQt{28, 1}]]
	32:    [[Craft(ItemQt{191, 8}), ItemQt{31, 1}]]
	33:    [[Craft(ItemQt{192, 8}), ItemQt{32, 1}]]
	34:    [[Craft(ItemQt{193, 8}), ItemQt{33, 1}]]
	35:    [[Craft(ItemQt{194, 8}), ItemQt{34, 1}]]
	36:    [[Craft(ItemQt{195, 8}), ItemQt{35, 1}]]
	37:    [[Craft(ItemQt{196, 8}), ItemQt{36, 1}]]
	38:    [[Craft(ItemQt{197, 8}), ItemQt{37, 1}]]
	41:    [[Craft(ItemQt{198, 8}), ItemQt{38, 1}]]
	42:    [[Craft(ItemQt{201, 8}), ItemQt{41, 1}]]
	43:    [[Craft(ItemQt{202, 8}), ItemQt{42, 1}]]
	44:    [[Craft(ItemQt{203, 8}), ItemQt{43, 1}]]
	45:    [[Craft(ItemQt{204, 8}), ItemQt{44, 1}]]
	46:    [[Craft(ItemQt{205, 8}), ItemQt{45, 1}]]
	47:    [[Craft(ItemQt{206, 8}), ItemQt{46, 1}]]
	48:    [[Craft(ItemQt{207, 8}), ItemQt{47, 1}]]
	51:    [[Craft(ItemQt{208, 8}), ItemQt{48, 1}]]
	52:    [[Craft(ItemQt{211, 8}), ItemQt{51, 1}]]
	53:    [[Craft(ItemQt{212, 8}), ItemQt{52, 1}]]
	54:    [[Craft(ItemQt{213, 8}), ItemQt{53, 1}]]
	55:    [[Craft(ItemQt{214, 8}), ItemQt{54, 1}]]
	56:    [[Craft(ItemQt{215, 8}), ItemQt{55, 1}]]
	57:    [[Craft(ItemQt{216, 8}), ItemQt{56, 1}]]
	58:    [[Craft(ItemQt{217, 8}), ItemQt{57, 1}]]
	61:    [[Craft(ItemQt{218, 8}), ItemQt{58, 1}]]
	62:    [[Craft(ItemQt{221, 8}), ItemQt{61, 1}]]
	63:    [[Craft(ItemQt{222, 8}), ItemQt{62, 1}]]
	64:    [[Craft(ItemQt{223, 8}), ItemQt{63, 1}]]
	65:    [[Craft(ItemQt{224, 8}), ItemQt{64, 1}]]
	66:    [[Craft(ItemQt{225, 8}), ItemQt{65, 1}]]
	67:    [[Craft(ItemQt{226, 8}), ItemQt{66, 1}]]
	68:    [[Craft(ItemQt{227, 8}), ItemQt{67, 1}]]
	71:    [[Craft(ItemQt{228, 8}), ItemQt{68, 1}]]
	72:    [[Craft(ItemQt{231, 8}), ItemQt{71, 1}]]
	73:    [[Craft(ItemQt{232, 8}), ItemQt{72, 1}]]
	74:    [[Craft(ItemQt{233, 8}), ItemQt{73, 1}]]
	75:    [[Craft(ItemQt{234, 8}), ItemQt{74, 1}]]
	76:    [[Craft(ItemQt{235, 8}), ItemQt{75, 1}]]
	77:    [[Craft(ItemQt{236, 8}), ItemQt{76, 1}]]
	78:    [[Craft(ItemQt{237, 8}), ItemQt{77, 1}]]
	81:    [[Craft(ItemQt{1, 4}), ItemQt{161, 5}]]
	82:    [[Craft(ItemQt{2, 4}), ItemQt{162, 5}]]
	83:    [[Craft(ItemQt{3, 4}), ItemQt{163, 5}]]
	84:    [[Craft(ItemQt{4, 4}), ItemQt{164, 5}]]
	85:    [[Craft(ItemQt{5, 4}), ItemQt{165, 5}]]
	86:    [[Craft(ItemQt{6, 4}), ItemQt{166, 5}]]
	87:    [[Craft(ItemQt{7, 4}), ItemQt{167, 5}]]
	88:    [[Craft(ItemQt{8, 4}), ItemQt{168, 5}]]
	91:    [[Craft(ItemQt{11, 4}), ItemQt{171, 5}]]
	92:    [[Craft(ItemQt{12, 4}), ItemQt{172, 5}]]
	93:    [[Craft(ItemQt{13, 4}), ItemQt{173, 5}]]
	94:    [[Craft(ItemQt{14, 4}), ItemQt{174, 5}]]
	95:    [[Craft(ItemQt{15, 4}), ItemQt{175, 5}]]
	96:    [[Craft(ItemQt{16, 4}), ItemQt{176, 5}]]
	97:    [[Craft(ItemQt{17, 4}), ItemQt{177, 5}]]
	98:    [[Craft(ItemQt{18, 4}), ItemQt{178, 5}]]
	101:   [[Craft(ItemQt{21, 4}), ItemQt{181, 5}]]
	102:   [[Craft(ItemQt{22, 4}), ItemQt{182, 5}]]
	103:   [[Craft(ItemQt{23, 4}), ItemQt{183, 5}]]
	104:   [[Craft(ItemQt{24, 4}), ItemQt{184, 5}]]
	105:   [[Craft(ItemQt{25, 4}), ItemQt{185, 5}]]
	106:   [[Craft(ItemQt{26, 4}), ItemQt{186, 5}]]
	107:   [[Craft(ItemQt{27, 4}), ItemQt{187, 5}]]
	108:   [[Craft(ItemQt{28, 4}), ItemQt{188, 5}]]
	111:   [[Craft(ItemQt{31, 4}), ItemQt{191, 5}]]
	112:   [[Craft(ItemQt{32, 4}), ItemQt{192, 5}]]
	113:   [[Craft(ItemQt{33, 4}), ItemQt{193, 5}]]
	114:   [[Craft(ItemQt{34, 4}), ItemQt{194, 5}]]
	115:   [[Craft(ItemQt{35, 4}), ItemQt{195, 5}]]
	116:   [[Craft(ItemQt{36, 4}), ItemQt{196, 5}]]
	117:   [[Craft(ItemQt{37, 4}), ItemQt{197, 5}]]
	118:   [[Craft(ItemQt{38, 4}), ItemQt{198, 5}]]
	121:   [[Craft(ItemQt{41, 4}), ItemQt{201, 5}]]
	122:   [[Craft(ItemQt{42, 4}), ItemQt{202, 5}]]
	123:   [[Craft(ItemQt{43, 4}), ItemQt{203, 5}]]
	124:   [[Craft(ItemQt{44, 4}), ItemQt{204, 5}]]
	125:   [[Craft(ItemQt{45, 4}), ItemQt{205, 5}]]
	126:   [[Craft(ItemQt{46, 4}), ItemQt{206, 5}]]
	127:   [[Craft(ItemQt{47, 4}), ItemQt{207, 5}]]
	128:   [[Craft(ItemQt{48, 4}), ItemQt{208, 5}]]
	131:   [[Craft(ItemQt{51, 4}), ItemQt{211, 5}]]
	132:   [[Craft(ItemQt{52, 4}), ItemQt{212, 5}]]
	133:   [[Craft(ItemQt{53, 4}), ItemQt{213, 5}]]
	134:   [[Craft(ItemQt{54, 4}), ItemQt{214, 5}]]
	135:   [[Craft(ItemQt{55, 4}), ItemQt{215, 5}]]
	136:   [[Craft(ItemQt{56, 4}), ItemQt{216, 5}]]
	137:   [[Craft(ItemQt{57, 4}), ItemQt{217, 5}]]
	138:   [[Craft(ItemQt{58, 4}), ItemQt{218, 5}]]
	141:   [[Craft(ItemQt{61, 4}), ItemQt{221, 5}]]
	142:   [[Craft(ItemQt{62, 4}), ItemQt{222, 5}]]
	143:   [[Craft(ItemQt{63, 4}), ItemQt{223, 5}]]
	144:   [[Craft(ItemQt{64, 4}), ItemQt{224, 5}]]
	145:   [[Craft(ItemQt{65, 4}), ItemQt{225, 5}]]
	146:   [[Craft(ItemQt{66, 4}), ItemQt{226, 5}]]
	147:   [[Craft(ItemQt{67, 4}), ItemQt{227, 5}]]
	148:   [[Craft(ItemQt{68, 4}), ItemQt{228, 5}]]
	151:   [[Craft(ItemQt{71, 4}), ItemQt{231, 5}]]
	152:   [[Craft(ItemQt{72, 4}), ItemQt{232, 5}]]
	153:   [[Craft(ItemQt{73, 4}), ItemQt{233, 5}]]
	154:   [[Craft(ItemQt{74, 4}), ItemQt{234, 5}]]
	155:   [[Craft(ItemQt{75, 4}), ItemQt{235, 5}]]
	156:   [[Craft(ItemQt{76, 4}), ItemQt{236, 5}]]
	157:   [[Craft(ItemQt{77, 4}), ItemQt{237, 5}]]
	158:   [[Craft(ItemQt{78, 4}), ItemQt{238, 5}]]
	161:   [[Craft(ItemRes{1, 2})], [Craft(ItemRes{2, 8})], [Craft(ItemRes{3, 32})],
		[Craft(ItemRes{4, 128})], [Craft(ItemRes{5, 512})], [Craft(ItemRes{6, 2048})],
		[Craft(ItemRes{7, 8192})], [Craft(ItemRes{8, 32768})],
		[Craft(ItemRes{162, 9})]]
	162:   [[Craft(ItemQt{161, 9})], [ItemRes{163, 9}]]
	163:   [[Craft(ItemQt{162, 9})], [ItemRes{164, 9}]]
	164:   [[Craft(ItemQt{163, 9})], [ItemRes{165, 9}]]
	165:   [[Craft(ItemQt{164, 9})], [ItemRes{166, 9}]]
	166:   [[Craft(ItemQt{165, 9})], [ItemRes{167, 9}]]
	167:   [[Craft(ItemQt{166, 9})], [ItemRes{168, 9}]]
	168:   [[Craft(ItemQt{167, 9})], [ItemRes{171, 9}]]
	171:   [[Craft(ItemQt{168, 9})], [Craft(ItemRes{11, 2})],
		[Craft(ItemRes{12, 8})], [Craft(ItemRes{13, 32})], [Craft(ItemRes{14, 128})],
		[Craft(ItemRes{15, 512})], [Craft(ItemRes{16, 2048})],
		[Craft(ItemRes{17, 8192})], [Craft(ItemRes{18, 32768})],
		[Craft(ItemRes{172, 9})]]
	172:   [[Craft(ItemQt{171, 9})], [ItemRes{173, 9}]]
	173:   [[Craft(ItemQt{172, 9})], [ItemRes{174, 9}]]
	174:   [[Craft(ItemQt{173, 9})], [ItemRes{175, 9}]]
	175:   [[Craft(ItemQt{174, 9})], [ItemRes{176, 9}]]
	176:   [[Craft(ItemQt{175, 9})], [ItemRes{177, 9}]]
	177:   [[Craft(ItemQt{176, 9})], [ItemRes{178, 9}]]
	178:   [[Craft(ItemQt{177, 9})], [ItemRes{181, 9}]]
	181:   [[Craft(ItemQt{178, 9})], [Craft(ItemRes{21, 2})],
		[Craft(ItemRes{22, 8})], [Craft(ItemRes{23, 32})], [Craft(ItemRes{24, 128})],
		[Craft(ItemRes{25, 512})], [Craft(ItemRes{26, 2048})],
		[Craft(ItemRes{27, 8192})], [Craft(ItemRes{28, 32768})],
		[Craft(ItemRes{182, 9})]]
	182:   [[Craft(ItemQt{181, 9})], [ItemRes{183, 9}]]
	183:   [[Craft(ItemQt{182, 9})], [ItemRes{184, 9}]]
	184:   [[Craft(ItemQt{183, 9})], [ItemRes{185, 9}]]
	185:   [[Craft(ItemQt{184, 9})], [ItemRes{186, 9}]]
	186:   [[Craft(ItemQt{185, 9})], [ItemRes{187, 9}]]
	187:   [[Craft(ItemQt{186, 9})], [ItemRes{188, 9}]]
	188:   [[Craft(ItemQt{187, 9})], [ItemRes{191, 9}]]
	191:   [[Craft(ItemQt{188, 9})], [Craft(ItemRes{31, 2})],
		[Craft(ItemRes{32, 8})], [Craft(ItemRes{33, 32})], [Craft(ItemRes{34, 128})],
		[Craft(ItemRes{35, 512})], [Craft(ItemRes{36, 2048})],
		[Craft(ItemRes{37, 8192})], [Craft(ItemRes{38, 32768})],
		[Craft(ItemRes{192, 9})]]
	192:   [[Craft(ItemQt{191, 9})], [ItemRes{193, 9}]]
	193:   [[Craft(ItemQt{192, 9})], [ItemRes{194, 9}]]
	194:   [[Craft(ItemQt{193, 9})], [ItemRes{195, 9}]]
	195:   [[Craft(ItemQt{194, 9})], [ItemRes{196, 9}]]
	196:   [[Craft(ItemQt{195, 9})], [ItemRes{197, 9}]]
	197:   [[Craft(ItemQt{196, 9})], [ItemRes{198, 9}]]
	198:   [[Craft(ItemQt{197, 9})], [ItemRes{201, 9}]]
	201:   [[Craft(ItemQt{198, 9})], [Craft(ItemRes{41, 2})],
		[Craft(ItemRes{42, 8})], [Craft(ItemRes{43, 32})], [Craft(ItemRes{44, 128})],
		[Craft(ItemRes{45, 512})], [Craft(ItemRes{46, 2048})],
		[Craft(ItemRes{47, 8192})], [Craft(ItemRes{48, 32768})],
		[Craft(ItemRes{202, 9})]]
	202:   [[Craft(ItemQt{201, 9})], [ItemRes{203, 9}]]
	203:   [[Craft(ItemQt{202, 9})], [ItemRes{204, 9}]]
	204:   [[Craft(ItemQt{203, 9})], [ItemRes{205, 9}]]
	205:   [[Craft(ItemQt{204, 9})], [ItemRes{206, 9}]]
	206:   [[Craft(ItemQt{205, 9})], [ItemRes{207, 9}]]
	207:   [[Craft(ItemQt{206, 9})], [ItemRes{208, 9}]]
	208:   [[Craft(ItemQt{207, 9})], [ItemRes{211, 9}]]
	211:   [[Craft(ItemQt{208, 9})], [Craft(ItemRes{51, 2})],
		[Craft(ItemRes{52, 8})], [Craft(ItemRes{53, 32})], [Craft(ItemRes{54, 128})],
		[Craft(ItemRes{55, 512})], [Craft(ItemRes{56, 2048})],
		[Craft(ItemRes{57, 8192})], [Craft(ItemRes{58, 32768})],
		[Craft(ItemRes{212, 9})]]
	212:   [[Craft(ItemQt{211, 9})], [ItemRes{213, 9}]]
	213:   [[Craft(ItemQt{212, 9})], [ItemRes{214, 9}]]
	214:   [[Craft(ItemQt{213, 9})], [ItemRes{215, 9}]]
	215:   [[Craft(ItemQt{214, 9})], [ItemRes{216, 9}]]
	216:   [[Craft(ItemQt{215, 9})], [ItemRes{217, 9}]]
	217:   [[Craft(ItemQt{216, 9})], [ItemRes{218, 9}]]
	218:   [[Craft(ItemQt{217, 9})], [ItemRes{221, 9}]]
	221:   [[Craft(ItemQt{218, 9})], [Craft(ItemRes{61, 2})],
		[Craft(ItemRes{62, 8})], [Craft(ItemRes{63, 32})], [Craft(ItemRes{64, 128})],
		[Craft(ItemRes{65, 512})], [Craft(ItemRes{66, 2048})],
		[Craft(ItemRes{67, 8192})], [Craft(ItemRes{68, 32768})],
		[Craft(ItemRes{222, 9})]]
	222:   [[Craft(ItemQt{221, 9})], [ItemRes{223, 9}]]
	223:   [[Craft(ItemQt{222, 9})], [ItemRes{224, 9}]]
	224:   [[Craft(ItemQt{223, 9})], [ItemRes{225, 9}]]
	225:   [[Craft(ItemQt{224, 9})], [ItemRes{226, 9}]]
	226:   [[Craft(ItemQt{225, 9})], [ItemRes{227, 9}]]
	227:   [[Craft(ItemQt{226, 9})], [ItemRes{228, 9}]]
	228:   [[Craft(ItemQt{227, 9})], [ItemRes{231, 9}]]
	231:   [[Craft(ItemQt{228, 9})], [Craft(ItemRes{71, 2})],
		[Craft(ItemRes{72, 8})], [Craft(ItemRes{73, 32})], [Craft(ItemRes{74, 128})],
		[Craft(ItemRes{75, 512})], [Craft(ItemRes{76, 2048})],
		[Craft(ItemRes{77, 8192})], [Craft(ItemRes{78, 32768})],
		[Craft(ItemRes{232, 9})]]
	232:   [[Craft(ItemQt{231, 9})], [ItemRes{233, 9}]]
	233:   [[Craft(ItemQt{232, 9})], [ItemRes{234, 9}]]
	234:   [[Craft(ItemQt{233, 9})], [ItemRes{235, 9}]]
	235:   [[Craft(ItemQt{234, 9})], [ItemRes{236, 9}]]
	236:   [[Craft(ItemQt{235, 9})], [ItemRes{237, 9}]]
	237:   [[Craft(ItemQt{236, 9})], [ItemRes{238, 9}]]
	238:   [[Craft(ItemQt{237, 9})]]
	253:   [[Craft(ItemQt{161, 4})]]
	254:   [[Craft(ItemQt{252, 9})]]
}

type Craft = ItemQt | ItemRes

struct ItemRes {
	i u8
	q u32
}

struct ItemQt {
	i u8
	q u32
}

const tile = 40
const item = 24
const item_spacing = 45
const place_color = gg.Color{100, 100, 100, 255}

union Conv {
	a int
	b [4]u8
}

struct App {
mut:
	ctx        &gg.Context = unsafe { nil }
	con        net.TcpConn
	ping       int
	seeds      []int
	seed_tx    [][]gg.Image
	compost_tx gg.Image
	dirt_tx    gg.Image
	dirtbit_tx gg.Image
	ess_tx     [][]gg.Image
	map        [][]u8 = [][]u8{len: 10, init: []u8{len: 10}}
	inv        []int  = []int{len: 256}
	inv_lvl    int
	place      u8
	craft	   u8
	mouse_x    f32
	mouse_y    f32
}

fn conv(a []u8) int {
	a_ := [a[0], a[1], a[2], a[3]]!
	return unsafe {
		Conv{
			b: a_
		}.a
	}
}

fn load_seed_tx(mut ctx gg.Context) [][]gg.Image {
	mut r := [][]gg.Image{len: 8, init: []gg.Image{cap: 8}}
	for i, mut lvl in r {
		for j in 0 .. 8 {
			lvl << ctx.create_image('sprites/seed${i + 1}${j + 1}.png') or { panic(err) }
		}
	}
	return r
}

fn load_ess_tx(mut ctx gg.Context) [][]gg.Image {
	mut r := [][]gg.Image{len: 8, init: []gg.Image{cap: 8}}
	for i, mut lvl in r {
		for j in 0 .. 8 {
			lvl << ctx.create_image('sprites/ess${i + 1}${j + 1}.png') or { panic(err) }
		}
	}
	return r
}

fn main() {
	file_name := os.input('enter you passcode:')
	mut app := &App{
		con: net.dial_tcp('127.0.0.0:40001')!
	}
	defer {
		println(time.now())
		println('closing the session')
		app.con.close() or { panic(err) }
	}
	app.ctx = gg.new_context(
		width: 600
		height: 600
		create_window: true
		window_title: '- Application -'
		bg_color: gg.Color{200, 200, 200, 255}
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		sample_count: 2
	)
	app.seed_tx = load_seed_tx(mut app.ctx)
	app.ess_tx = load_ess_tx(mut app.ctx)
	app.compost_tx = app.ctx.create_image('sprites/compost.png')!
	app.dirt_tx = app.ctx.create_image('sprites/dirt.png')!
	app.dirtbit_tx = app.ctx.create_image('sprites/dirtbit.png')!
	app.con.write_string('${file_name}\n')!
	map_ := app.con.read_line()[0..100]
	for i in 0 .. 10 {
		for j, ch in map_[i * 10..(i + 1) * 10] {
			app.map[i][j] = ch
		}
	}
	mut inv_ := []u8{len:256*4}
	app.con.read(mut inv_)!
	for i in 0 .. 256 {
		app.inv[i] = conv(inv_[i * 4..(i + 1) * 4])
	}
	app.con.write_string('processing done\n')!
	app.ctx.run()
}

fn on_frame(mut app App) {
	if app.ping % 10 == 0 {
		app.con.write_string('ping\n') or { panic(err) }
		r := app.con.read_line()#[..-1]
		if r != 'no' {
			app.seeds = r.split(',')#[..-1].map(it.int())
		}
	}
	app.ping++
	app.ctx.begin()
	app.ctx.draw_square_filled(0, 0, tile * 10, gg.Color{255, 255, 255, 255})
	mut seed_nb := 0
	for i in 0 .. 10 {
		for j in 0 .. 10 {
			elem := app.map[i][j]
			if elem >= 1 && elem <= 78 {
				app.ctx.draw_image(j * tile, i * tile, tile, tile, app.seed_tx[elem / 10][elem % 10 - 1])
				if app.seeds.len > 0 {
					app.ctx.draw_text_def(j * tile, i * tile, app.seeds[seed_nb].str())
					seed_nb++
				}
			} else if elem >= 161 && elem <= 238 {
				app.ctx.draw_image(j * tile, i * tile, tile, tile, app.ess_tx[elem / 10 - 16][elem % 10 - 1])
			} else if elem != 255 {
				tx := match elem {
					254 { app.dirt_tx }
					253 { app.compost_tx }
					252 { app.dirtbit_tx }
					else { panic('texture not supported') }
				}
				app.ctx.draw_image(j * tile, i * tile, tile, tile, tx)
			}
		}
	}
	app.ctx.draw_text_def(13 * tile, 5, app.inv[254].str())
	app.ctx.draw_image(12 * tile, 5, item, item, app.dirt_tx)

	app.ctx.draw_text_def(17 * tile, 5, app.inv[253].str())
	app.ctx.draw_image(16 * tile, 5, item, item, app.compost_tx)

	app.ctx.draw_text_def(21 * tile, 5, app.inv[252].str())
	app.ctx.draw_image(20 * tile, 5, item, item, app.dirtbit_tx)

	// remove elem
	app.ctx.draw_square_filled(24 * tile, 5, item, place_color)
	for i in 0 .. 8 {
		app.ctx.draw_text_def(13 * tile, 5 + item_spacing * (i + 1), app.inv[1 + i +
			app.inv_lvl * 10].str())
		app.ctx.draw_image(12 * tile, 5 + item_spacing * (i + 1), item, item, app.seed_tx[app.inv_lvl][i])

		app.ctx.draw_text_def(17 * tile, 5 + item_spacing * (i + 1), app.inv[161 + i +
			app.inv_lvl * 10].str())
		app.ctx.draw_image(16 * tile, 5 + item_spacing * (i + 1), item, item, app.ess_tx[app.inv_lvl][i])

		app.ctx.draw_text_def(21 * tile, 5 + item_spacing * (i + 1), app.inv[81 + i +
			app.inv_lvl * 10].str())
		// TODO texture GP		app.ctx.draw_image(12 * tile, 35 + 30 * i, item, item, app.)
		app.ctx.draw_square_filled(20 * tile, 5 + item_spacing * (i + 1), item, place_color)
	}
	if app.place != 0 {
		app.draw_item(app.mouse_x, app.mouse_y, app.place)
		if app.inv[app.place] == 0 {
			app.place = 0
		}
	}
	if app.craft != 0 {
		recipes := crafts[app.craft]
		for i, r in recipes {
			app.draw_item(5 + i*item*5, 11*tile, app.craft)
			app.ctx.draw_rect_filled(5 + i*item*5 + 1.5*f32(item), 11*tile, item*r.len, item, place_color)
			if r[0] is ItemRes {
				app.ctx.draw_text_def(5 + i*item*5, 11*tile, r[0].q.str())
			}
			for j, item_ in r {
				if item_ is ItemQt {
					app.draw_item(5 + i*item*5 + (f32(j)+1.5)*item, 11*tile, item_.i)
					app.ctx.draw_text_def(int(5 + i*item*5 + (f32(j)+1.5)*item), 11*tile, item_.q.str())
				} else if item_ is ItemRes {
					app.draw_item(5 + i*item*5 + (f32(j)+1.5)*item, 11*tile, item_.i)
				}
			}
		}
	}
	app.ctx.end()
}

fn (mut app App) draw_item(x f32, y f32, elem u8) {
	if elem >= 1 && elem <= 78 {
		app.ctx.draw_image(x, y, item, item, app.seed_tx[elem / 10][elem % 10 - 1])
	} else if elem >= 161 && elem <= 238 {
		app.ctx.draw_image(x, y, item, item, app.ess_tx[elem / 10 - 16][elem % 10 - 1])
	} else if elem != 255 {
		tx := match elem {
			254 { app.dirt_tx }
			253 { app.compost_tx }
			252 { app.dirtbit_tx }
			else { panic('texture not supported') }
		}
		app.ctx.draw_image(x, y, item, item, tx)
	}
}

fn on_event(e &gg.Event, mut app App) {
	if e.char_code != 0 {
	}
	app.mouse_x = e.mouse_x
	app.mouse_y = e.mouse_y
	match e.typ {
		.key_down {
			match e.key_code {
				.escape {
					app.ctx.quit()
				}
				.left {
					app.inv_lvl -= 1
					if app.inv_lvl < 0 {
						app.inv_lvl = 7
					}
				}
				.right {
					app.inv_lvl = (app.inv_lvl + 1) % 8
				}
				else {}
			}
		}
		.mouse_up {
			for i in 0 .. 10 {
				if e.mouse_y < (i + 1) * tile {
					for j in 0 .. 10 {
						if e.mouse_x < (j + 1) * tile {
							if app.place > 0 && app.inv[app.place] > 0 {
								app.con.write_string('place${u8(j).ascii_str()}${u8(i).ascii_str()}${u8(app.place).ascii_str()}\n') or {
									panic(err)
								}
								inv := app.con.read_line()#[..-1]
								if inv != 'notenough' && inv != 'nodirt' && inv != 'planted!' {
									app.inv[inv[0]] = inv[1..].int()
									if app.map[i][j] != 255 {
										replaced := app.con.read_line()#[..-1]
										app.inv[replaced[1]] = replaced[2..].int()
										if app.map[i][j] >= 1 && app.map[i][j] <= 78 {
											app.seeds.delete(replaced[0])
										}
									}
									app.map[i][j] = app.place
									if app.place >= 1 && app.place <= 78 {
										app.ping = 0
									}
									if app.inv[inv[0]] == 0 {
										app.place = 0
									}
								}
							} else if app.map[i][j] >= 1 && app.map[i][j] <= 78 {
								// Harvest
								mut count := u8(0)
								for k in 0 .. i {
									for l in 0 .. 10 {
										if app.map[k][l] >= 1 && app.map[k][l] <= 78 {
											count += 1
										}
									}
								}
								for k in 0 .. j {
									if app.map[i][k] >= 1 && app.map[i][k] <= 78 {
										count += 1
									}
								}
								if app.seeds[count] == 0 {
									app.con.write_string('harv${count.ascii_str()}\n') or {
										panic(err)
									}
									a := app.con.read_line()#[..-1]
									app.inv[a[1]] = a[2..].int()
									if a[0] != 0 {
										app.inv[a[0]] += 1
									}
									app.ping = 0
								}
							}
							return
						}
					}
				}
			}
			if square_click(12 * tile, 5, item, e.mouse_x, e.mouse_y) {
				if e.mouse_button == .left {
					app.place = 254
				} else {
					app.craft = 254
				}
				return
			}
			if square_click(16 * tile, 5, item, e.mouse_x, e.mouse_y) {
				if e.mouse_button == .left {
					app.place = 253
				} else {
					app.craft = 253
				}
				return
			}
			if square_click(20 * tile, 5, item, e.mouse_x, e.mouse_y) {
				if e.mouse_button == .left {
					app.place = 252
				} else {
					app.craft = 252
				}
				return
			}
			if square_click(24 * tile, 5, item, e.mouse_x, e.mouse_y) {
				app.place = 255
				return
			}
			for i in 0 .. 8 {
				if square_click(12 * tile, 5 + item_spacing * (i + 1), item, e.mouse_x,
					e.mouse_y)
				{
					if e.mouse_button == .left {
						app.place = u8(1 + i + app.inv_lvl * 10)
					} else {
						app.craft = u8(1 + i + app.inv_lvl * 10)
					}
					return
				}
				if square_click(16 * tile, 5 + item_spacing * (i + 1), item, e.mouse_x,
					e.mouse_y)
				{
					if e.mouse_button == .left {
						app.place = u8(161 + i + app.inv_lvl * 10)
					} else {
						app.craft = u8(161 + i + app.inv_lvl * 10)
					}
					return
				}
				if square_click(20 * tile, 5 + item_spacing * (i + 1), item, e.mouse_x,
					e.mouse_y)
				{
					if e.mouse_button == .left {
						app.place = u8(81 + i + app.inv_lvl * 10)
					} else {
						app.craft = u8(81 + i + app.inv_lvl * 10)
					}
					return
				}
			}
			if app.craft != 0 {
				recipes := crafts[app.craft]
				for i, r in recipes {
					if square_click(5 + i*item*5, 11*tile, item, e.mouse_x, e.mouse_y) {
						if r[0] is ItemRes {
							if app.inv[r[0].i] < 1 {
								return
							}
						} else {
							for item_ in r {
								if app.inv[item_.i] < item_.q {
									return
								}
							}	
						}
						app.con.write_string('craft${app.craft.ascii_str()}${u8(i).ascii_str()}\n') or {panic(err)}
						up := app.con.read_line()#[..-1].split(',')
						if up[0] != 'notenough' {
							for u in up {
								app.inv[u[0]] = u[1..].int() 
							}
						}
						return
					}
					for j, item_ in r {
						if item_ is ItemQt {
							if square_click(int(5 + i*item*5 + (f32(j)+1.5)*item), 11*tile, item, e.mouse_x, e.mouse_y) {
									app.craft = item_.i
									return
							}
						} else if item_ is ItemRes {
							if square_click(int(5 + i*item*5 + (f32(j)+1.5)*item), 11*tile, item, e.mouse_x, e.mouse_y) {
									app.craft = item_.i
									return
							}
						}
					}
				}
			}
			// because if placed early return
			app.place = 0
		}
		else {}
	}
}

fn square_click(sx int, sy int, sw int, x f32, y f32) bool {
	return x >= sx && y >= sy && x < sx + sw && y < sy + sw
}
