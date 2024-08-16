import time
import net
import os
import gg

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
		elem := app.place
		if elem >= 1 && elem <= 78 {
			app.ctx.draw_image(app.mouse_x, app.mouse_y, item, item, app.seed_tx[elem / 10][elem % 10 - 1])
		} else if elem >= 161 && elem <= 238 {
			app.ctx.draw_image(app.mouse_x, app.mouse_y, item, item, app.ess_tx[elem / 10 - 16][elem % 10 - 1])
		} else if elem != 255 {
			tx := match elem {
				254 { app.dirt_tx }
				253 { app.compost_tx }
				252 { app.dirtbit_tx }
				else { panic('texture not supported') }
			}
			app.ctx.draw_image(app.mouse_x, app.mouse_y, item, item, tx)
		}
		if app.inv[app.place] == 0 {
			app.place = 0
		}
	}
	app.ctx.end()
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
				app.place = 254
				return
			}
			if square_click(16 * tile, 5, item, e.mouse_x, e.mouse_y) {
				app.place = 253
				return
			}
			if square_click(20 * tile, 5, item, e.mouse_x, e.mouse_y) {
				app.place = 252
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
					app.place = u8(1 + i + app.inv_lvl * 10)
					return
				}
				if square_click(16 * tile, 5 + item_spacing * (i + 1), item, e.mouse_x,
					e.mouse_y)
				{
					app.place = u8(161 + i + app.inv_lvl * 10)
					return
				}
				if square_click(20 * tile, 5 + item_spacing * (i + 1), item, e.mouse_x,
					e.mouse_y)
				{
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
