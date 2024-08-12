import time
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
	if file_name != 'saves/' {
		if !os.exists(file_name) {
			os.write_file(file_name + 'seed', '') or { panic(err) }
			os.write_file(file_name + 'map', '${'${u8(255).ascii_str():10r}\n':10r}') or {
				panic(err)
			}
			mut a := []u8{len: 256 * 4, init: 0}
			a[254 * 4] = 2
			a[1 * 4] = 2 // TODO: give/descendance system
			os.write_file(file_name + 'inv', a.bytestr()) or { panic(err) }
		}
		mut seeds := os.read_lines(file_name + 'seed') or { panic(err) }
		// send data from the save
		mut map_ := os.read_file(file_name + 'map') or { panic(err) }
		ses.write_string(map_) or { panic(err) }
		mut inv_ := os.read_file(file_name + 'inv') or { panic(err) }
		ses.write_string(inv_ + '\n') or { panic(err) }
		mut inv := []int{len: 256}
		for i in 0 .. 256 {
			inv[i] = conv(inv_[i * 4..(i + 1) * 4].bytes())
		}

		// wait for requests if needed
		ses.set_read_timeout(time.second)
		for {
			ses.wait_for_read() or { println("timed out");break }
			a := ses.read_line()#[..-1]
			if a == 'ping' {
				mut send := ""
				for s in seeds {
					mut time_remaining := s.int() - time.now().unix()
					if time_remaining < 0 {
						time_remaining = 0
					}
					send = send + time_remaining.str() + ','
				}
				ses.write_string('${send}\n') or { panic(err) }
			} else if a#[..5] == 'place' { // place[char for x][char for y][char for type]
				data := a[5..]
				if inv[data[2]] > 0 {
					i := data[0] + data[1] * 10
					if data[2] >= 1 && data[2] <= 78 {
						if map_[i+10] == 254 {
							growth_time := 100 * 60 * math.factorial(data[2] / 10 + 1)
							seeds << (growth_time + time.now().unix()).str()
							// TODO write seed to file
						} else {
							ses.write_string('nodirt\n') or { panic(err) }
							continue
						}
					}
					inv[data[2]] -= 1
					// update client inv
					ses.write_string('${data[2].ascii_str()}${cback(inv[data[2]])}\n') or {
						panic(err)
					}
					if map_[i] != 255 {
						inv[map_[i]] += 1
						ses.write_string('${map_[i].ascii_str()}${cback(inv[map_[i]])}\n') or {
							panic(err)
						}
					}
					// update serv map
					map_ = map_[..i] + data[2].ascii_str() + map_[i + 1..]
					// update client map
					ses.write_string(data + '\n') or { panic(err) }
					// TODO write to map file
				} else {
					ses.write_string('notenough\n') or { panic(err) }
				}
			}
			time.sleep(10 * time.millisecond)
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
