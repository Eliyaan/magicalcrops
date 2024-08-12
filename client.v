import time
import net
import os
import gg

const tile = 40
const place_color = gg.Color{100, 100, 100, 255}

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

struct App {
mut:
	ctx     &gg.Context = unsafe { nil }
	con     net.TcpConn
	ping    int
	seeds   []int
	map     [][]u8 = [][]u8{len: 10, init: []u8{len: 10}}
	inv     []int  = []int{len: 256}
	inv_lvl int
	place   u8
}

fn main() {
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
	file_name := os.input('enter you passcode:')
	app.con.write_string('${file_name}\n')!
	for i in 0 .. 10 {
		map_line := app.con.read_line()[0..10]
		for j, ch in map_line {
			app.map[i][j] = ch
		}
	}
	inv_ := app.con.read_line()[0..256 * 4]
	for i in 0 .. 256 {
		app.inv[i] = conv(inv_[i * 4..(i + 1) * 4].bytes())
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
			color := match app.map[i][j] {
				255 { gg.Color{0, 0, 0, 0} }
				254 { gg.Color{79, 30, 16, 255} }
				1 { gg.Color{0, 255, 0, 255} }
// TODO: add the other & sprites
				else { gg.Color{255, 0, 0, 255} }
			}
			app.ctx.draw_square_filled(j * tile, i * tile, tile, color)
			if app.map[i][j] >= 1 && app.map[i][j] <= 78 && app.seeds.len > 0 {
				app.ctx.draw_text_def(j*tile, i*tile, app.seeds[seed_nb].str())
				seed_nb++
			}
		}
	}
	app.ctx.draw_text_def(13 * tile, 5, app.inv[254].str())
	app.ctx.draw_square_filled(12 * tile, 5, 10, place_color)
	app.ctx.draw_text_def(17 * tile, 5, app.inv[253].str())
	app.ctx.draw_square_filled(16 * tile, 5, 10, place_color)
	app.ctx.draw_text_def(21 * tile, 5, app.inv[252].str())
	app.ctx.draw_square_filled(20 * tile, 5, 10, place_color)
	for i in 0 .. 8 {
		app.ctx.draw_text_def(13 * tile, 35 + 30 * i, app.inv[1 + i + app.inv_lvl * 10].str())
		app.ctx.draw_square_filled(12 * tile, 35 + 30 * i, 10, place_color)
		app.ctx.draw_text_def(17 * tile, 35 + 30 * i, app.inv[161 + i + app.inv_lvl * 10].str())
		app.ctx.draw_square_filled(16 * tile, 35 + 30 * i, 10, place_color)
		app.ctx.draw_text_def(21 * tile, 35 + 30 * i, app.inv[81 + i + app.inv_lvl * 10].str())
		app.ctx.draw_square_filled(20 * tile, 35 + 30 * i, 10, place_color)
	}
	app.ctx.end()
}

fn on_event(e &gg.Event, mut app App) {
	if e.char_code != 0 {
		println(e.char_code)
	}
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
							if app.place > 0 {
								println(app.place)
								app.con.write_string('place${u8(j).ascii_str()}${u8(i).ascii_str()}${u8(app.place).ascii_str()}\n') or {
									panic(err)
								}
								inv := app.con.read_line()#[..-1]
								if inv != 'notenough' && inv != 'nodirt' {
									app.inv[inv[0]] = conv(inv[1..5].bytes())
									if app.map[i][j] != 255 {
										println(app.map[i][j])
										replaced := app.con.read_line()#[..-1]
										app.inv[replaced[0]] = conv(replaced[1..5].bytes())
									}
									app.map[i][j] = app.place
									if app.place >= 1 && app.place <= 78 {
										app.ping = 0
									}
								}
							}
							return
						}
					}
				}
			}
			if square_click(12 * tile, 5, 10, e.mouse_x, e.mouse_y) {
				app.place = 254
				return
			}
			if square_click(16 * tile, 5, 10, e.mouse_x, e.mouse_y) {
				app.place = 253
				return
			}
			if square_click(20 * tile, 5, 10, e.mouse_x, e.mouse_y) {
				app.place = 252
				return
			}
			for i in 0 .. 8 {
				if square_click(12 * tile, 35 + 30 * i, 10, e.mouse_x, e.mouse_y) {
					app.place = u8(1 + i + app.inv_lvl * 10)
					return
				}
				if square_click(16 * tile, 35 + 30 * i, 10, e.mouse_x, e.mouse_y) {
					app.place = u8(161 + i + app.inv_lvl * 10)
					return
				}
				if square_click(20 * tile, 35 + 30 * i, 10, e.mouse_x, e.mouse_y) {
					app.place = u8(81 + i + app.inv_lvl * 10)
					return
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
