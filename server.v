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
	u8(1): [[ItemQt{161, 8}]]
	u8(2): [[ItemQt{161, 8}, ItemQt{1, 1}]]
	u8(3): [[ItemQt{162, 8}, ItemQt{2, 1}]]
	u8(4): [[ItemQt{163, 8}, ItemQt{3, 1}]]
	u8(5): [[ItemQt{164, 8}, ItemQt{4, 1}]]
	u8(6): [[ItemQt{165, 8}, ItemQt{5, 1}]]
	u8(7): [[ItemQt{166, 8}, ItemQt{6, 1}]]
	u8(8): [[ItemQt{167, 8}, ItemQt{7, 1}]]
	u8(11): [[ItemQt{168, 8}, ItemQt{8, 1}]]
	u8(12): [[ItemQt{171, 8}, ItemQt{11, 1}]]
	u8(13): [[ItemQt{172, 8}, ItemQt{12, 1}]]
	u8(14): [[ItemQt{173, 8}, ItemQt{13, 1}]]
	u8(15): [[ItemQt{174, 8}, ItemQt{14, 1}]]
	u8(16): [[ItemQt{175, 8}, ItemQt{15, 1}]]
	u8(17): [[ItemQt{176, 8}, ItemQt{16, 1}]]
	u8(18): [[ItemQt{177, 8}, ItemQt{17, 1}]]
	u8(21): [[ItemQt{178, 8}, ItemQt{18, 1}]]
	u8(22): [[ItemQt{181, 8}, ItemQt{21, 1}]]
	u8(23): [[ItemQt{182, 8}, ItemQt{22, 1}]]
	u8(24): [[ItemQt{183, 8}, ItemQt{23, 1}]]
	u8(25): [[ItemQt{184, 8}, ItemQt{24, 1}]]
	u8(26): [[ItemQt{185, 8}, ItemQt{25, 1}]]
	u8(27): [[ItemQt{186, 8}, ItemQt{26, 1}]]
	u8(28): [[ItemQt{187, 8}, ItemQt{27, 1}]]
	u8(31): [[ItemQt{188, 8}, ItemQt{28, 1}]]
	u8(32): [[ItemQt{191, 8}, ItemQt{31, 1}]]
	u8(33): [[ItemQt{192, 8}, ItemQt{32, 1}]]
	u8(34): [[ItemQt{193, 8}, ItemQt{33, 1}]]
	u8(35): [[ItemQt{194, 8}, ItemQt{34, 1}]]
	u8(36): [[ItemQt{195, 8}, ItemQt{35, 1}]]
	u8(37): [[ItemQt{196, 8}, ItemQt{36, 1}]]
	u8(38): [[ItemQt{197, 8}, ItemQt{37, 1}]]
	u8(41): [[ItemQt{198, 8}, ItemQt{38, 1}]]
	u8(42): [[ItemQt{201, 8}, ItemQt{41, 1}]]
	u8(43): [[ItemQt{202, 8}, ItemQt{42, 1}]]
	u8(44): [[ItemQt{203, 8}, ItemQt{43, 1}]]
	u8(45): [[ItemQt{204, 8}, ItemQt{44, 1}]]
	u8(46): [[ItemQt{205, 8}, ItemQt{45, 1}]]
	u8(47): [[ItemQt{206, 8}, ItemQt{46, 1}]]
	u8(48): [[ItemQt{207, 8}, ItemQt{47, 1}]]
	u8(51): [[ItemQt{208, 8}, ItemQt{48, 1}]]
	u8(52): [[ItemQt{211, 8}, ItemQt{51, 1}]]
	u8(53): [[ItemQt{212, 8}, ItemQt{52, 1}]]
	u8(54): [[ItemQt{213, 8}, ItemQt{53, 1}]]
	u8(55): [[ItemQt{214, 8}, ItemQt{54, 1}]]
	u8(56): [[ItemQt{215, 8}, ItemQt{55, 1}]]
	u8(57): [[ItemQt{216, 8}, ItemQt{56, 1}]]
	u8(58): [[ItemQt{217, 8}, ItemQt{57, 1}]]
	u8(61): [[ItemQt{218, 8}, ItemQt{58, 1}]]
	u8(62): [[ItemQt{221, 8}, ItemQt{61, 1}]]
	u8(63): [[ItemQt{222, 8}, ItemQt{62, 1}]]
	u8(64): [[ItemQt{223, 8}, ItemQt{63, 1}]]
	u8(65): [[ItemQt{224, 8}, ItemQt{64, 1}]]
	u8(66): [[ItemQt{225, 8}, ItemQt{65, 1}]]
	u8(67): [[ItemQt{226, 8}, ItemQt{66, 1}]]
	u8(68): [[ItemQt{227, 8}, ItemQt{67, 1}]]
	u8(71): [[ItemQt{228, 8}, ItemQt{68, 1}]]
	u8(72): [[ItemQt{231, 8}, ItemQt{71, 1}]]
	u8(73): [[ItemQt{232, 8}, ItemQt{72, 1}]]
	u8(74): [[ItemQt{233, 8}, ItemQt{73, 1}]]
	u8(75): [[ItemQt{234, 8}, ItemQt{74, 1}]]
	u8(76): [[ItemQt{235, 8}, ItemQt{75, 1}]]
	u8(77): [[ItemQt{236, 8}, ItemQt{76, 1}]]
	u8(78): [[ItemQt{237, 8}, ItemQt{77, 1}]]
}

struct ItemQt {
	i u8
	q u8
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
			a[254 * 4] = 20
			a[255*4] = 1 // air
			a[1 * 4] = 20 // TODO: give/descendance system
			os.write_file(file_name + 'inv', a.bytestr()) or { panic(err) }
		}
		mut seeds := os.read_lines(file_name + 'seed') or { panic(err) }
		// send data from the save
		mut map_ := os.read_file(file_name + 'map') or { panic(err) }
		ses.write_string(map_ + '\n') or { panic(err) }
		mut inv_ := os.read_file(file_name + 'inv') or { panic(err) }
		ses.write_string(inv_ + '\n') or { panic(err) }
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
					if !(i >= 10 && map_[i-10] >= 1 && map_[i-10] <= 78) {
					// for seed planting
					if data[2] >= 1 && data[2] <= 78 {
						if i + 10 < 100 && map_[i + 10] == 254 {
							growth_time := 2 // 100 * 60 * math.factorial(data[2] / 10 + 1)
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
								seeds.delete(count+1) // because inserted one
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
								seeds[a[4]] = (100 * 60 * int(math.factorial(map_[i] / 10 + 1)) +
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
