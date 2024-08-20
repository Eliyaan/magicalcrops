import time
import rand
import math
import os
import net

// 255: air
// 254: dirt
// 253: compost
// 252: piece of dirt
// 1 -> 8 green seed // !!!!! do not use 10 it is the \n char
// 11 18 orange
// 21 28 red
// 31 38 pink
// 41 48 turquoise
// 51 58 dark blue
// 61 68 black
// 71 78 violet
// 81 -> 88 green growth pulser
// 91 98 orange
// 101 108 red
// 111 118 pink
// 121 128 turquoise
// 131 138 dark blue
// 141 148 black
// 151 158 violet
// 161 -> 168 green essense
// 171 178 orange
// 181 188 red
// 191 198 pink
// 201 208 turquoise
// 211 218 dark blue
// 221 228 black
// 231 238 violet

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

union Conv {
	a int
	b [4]u8
}

fn conv(a []u8) int {
	a_ := [a[0], a[1], a[2], a[3]]!
	return unsafe {
		Conv{
			b: a_
		}.a
	}
}

fn cback(a int) string {
	return unsafe {
		Conv{
			a: a
		}.b[..].bytestr()
	}
}

fn server_handle(mut ses net.TcpConn) {
	println('new session opened')
	defer {
		println(time.now())
		println('closing a session')
		ses.close() or { panic(err) }
	}
	// auth
	file_name := 'saves/${ses.read_line()#[..-1]}'
	ses.set_read_timeout(time.second)
	if file_name != 'saves/' {
		if !os.exists(file_name) {
			os.write_file(file_name + 'seed', '') or { panic(err) }
			os.write_file(file_name + 'map', '${u8(255).ascii_str():100r}') or { panic(err) }
			mut a := []u8{len: 256 * 4, init: 0}
			a[254 * 4] = 10
			a[255 * 4] = 1 // air
			a[1 * 4] = 20 // TODO: give/descendance system
			os.write_file(file_name + 'inv', a.bytestr()) or { panic(err) }
		}
		mut seeds := os.read_lines(file_name + 'seed') or { panic(err) }
		// send data from the save
		mut map_ := os.read_file(file_name + 'map') or { panic(err) }
		ses.write_string(map_ + '\n') or { panic(err) }
		mut inv_ := os.read_file(file_name + 'inv') or { panic(err) }
		ses.write(inv_.bytes()) or { panic(err) }
		mut inv := []int{len: 256}
		for i in 0 .. 256 {
			inv[i] = conv(inv_[i * 4..(i + 1) * 4].bytes())
		}

		// wait for requests if needed
		for {
			ses.wait_for_read() or {
				println(err)
				break
			}
			a := ses.read_line()#[..-1]
			if a == 'ping' {
				mut send := ''
				for s in seeds {
					mut time_remaining := s.int() - time.now().unix()
					if time_remaining < 0 {
						time_remaining = 0
					}
					send = send + time_remaining.str() + ','
				}
				if send == '' {
					ses.write_string('no\n') or { panic(err) }
				} else {
					ses.write_string('${send}\n') or { panic(err) }
				}
			} else if a#[..5] == 'place' { // place[char for x][char for y][char for type]
				data := a[5..]
				if inv[data[2]] > 0 {
					i := data[0] + data[1] * 10
					if !(i >= 10 && map_[i - 10] >= 1 && map_[i - 10] <= 78) {
						// for seed planting
						if data[2] >= 1 && data[2] <= 78 {
							if i + 10 < 100 && map_[i + 10] == 254 {
								mut gp_reduc := 1.0
								mut c := i
								for c < 100 {
									m := map_[c]
									if m >= 81 && m <= 158 {
										gp_reduc *= 1.0 - f32(m/10-8)*0.1 - f32(m%10)*0.01
									}
									c += 10
								}
								growth_time := (100 * 60 * math.factorial(data[2] / 10 + 1))*gp_reduc
								mut count := 0
								for j in 0 .. i {
									if map_[j] >= 1 && map_[j] <= 78 {
										count += 1
									}
								}
								seeds.insert(count, int(growth_time + time.now().unix()).str())
								// TODO check growth pulser
								// TODO write seed to file
							} else {
								ses.write_string('nodirt\n') or { panic(err) }
								continue
							}
						}
						if data[2] != 255 {
							inv[data[2]] -= 1
						}
						// update client inv
						ses.write_string('${data[2].ascii_str()}${inv[data[2]]}\n') or {
							panic(err)
						}
						// for replacing
						if map_[i] != 255 {
							inv[map_[i]] += 1
							mut count := u8(0)
							if map_[i] >= 1 && map_[i] <= 78 {
								for j in 0 .. i {
									if map_[j] >= 1 && map_[j] <= 78 {
										count += 1
									}
								}
								if data[2] >= 1 && data[2] <= 78 {
									seeds.delete(count + 1) // because inserted one
								} else {
									seeds.delete(count)
								}
							}
							ses.write_string('${count.ascii_str()}${map_[i].ascii_str()}${inv[map_[i]]}\n') or {
								panic(err)
							}
							// TODO write to file
						}
						// update serv map
						map_ = map_[..i] + data[2].ascii_str() + map_[i + 1..]
						// TODO write to map file
					} else {
						ses.write_string('planted!\n') or { panic(err) }
					}
				} else {
					ses.write_string('notenough\n') or { panic(err) }
				}
			} else if a#[..4] == 'harv' {
				if seeds[a[4]].int() - time.now().unix() <= 0 {
					mut count := u8(0)
					for i in 0 .. 100 {
						if map_[i] >= 1 && map_[i] <= 78 {
							count += 1
							if count == a[4] + 1 {
								mut gp_reduc := 1.0
								mut c := i
								for c < 100 {
									m := map_[c]
									if m >= 81 && m <= 158 {
										gp_reduc *= 1.0 - f32(m/10-8)*0.1 - f32(m%10)*0.01
									}
									c += 10
								}
								seeds[a[4]] = ((100 * 60 * int(math.factorial(map_[i] / 10 + 1)))*gp_reduc +
									time.now().unix()).str()
								ess := 161 + map_[i] / 10 * 10
								inv[ess] += int(math.factorial(map_[i] % 10))
								mut seed := u8(0)
								if rand.int_in_range(0, 10) or { panic(err) } == 0 {
									seed = map_[i]
								}
								ses.write_string('${seed.ascii_str()}${u8(ess).ascii_str()}${inv[ess]}\n') or {
									panic(err)
								}
								break
							}
						}
					}
				}
			} else if a#[..5] == 'craft' {
				recipe := crafts[a[5]][a[6]] // the right item w/ the right recipe
				mut r := ''
				if recipe[0] is ItemQt {
					for item in recipe {
						if inv[item.i] < item.q {
							ses.write_string('notenough') or { panic(err) }
							continue
						}
					}
					for item in recipe {
						inv[item.i] -= item.q
						r = r + '${item.i.ascii_str()}${inv[item.i]},'
					}
					inv[a[5]] += 1
					r = r + '${a[5].ascii_str()}${inv[a[5]]}'
				} else {
					if inv[recipe[0].i] == 0 {
						ses.write_string('notenough') or { panic(err) }
						continue
					}
					inv[recipe[0].i] -= 1
					inv[a[5]] += recipe[0].q
					r = '${recipe[0].i.ascii_str()}${inv[recipe[0].i]},'
					r = r + '${a[5].ascii_str()}${inv[a[5]]}'
				}
				ses.write_string(r+'\n') or { panic(err) }
			} else if a == '' {
				println('client gone')
				break
			}
			time.sleep(20 * time.millisecond)
		}
	}
}

fn main() {
	mut server := net.listen_tcp(.ip, ':40001')!
	for {
		println('Waiting for a new session')
		mut session := server.accept()!
		spawn server_handle(mut session)
	}
}

fn remaining(t int) int {
	mut time_remaining := t - time.now().unix()
	if time_remaining < 0 {
		time_remaining = 0
	}
	return int(time_remaining)
}
