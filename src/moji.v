module moji

import strings

// emojify will translate the emoji names into the actual Unicode character.
pub fn emojify(text string) string {
	mut buf := strings.new_builder(text.len)
	mut toklen := 0
	for byt in text {
		if byt == `:` {
			if toklen == 0 {
				toklen = 1
			} else if toklen > 1 {
				key := buf.last_n(toklen - 1)
				if key in moji.db {
					val := moji.db[key]
					buf.go_back(toklen)
					buf.write_string(val)
				} else {
					buf << byt
				}
				toklen = 0
				continue
			}
		} else if toklen > 0 {
			match byt {
				`+`, `-`, `0`...`9`, `a`...`z`, `_` {
					toklen++
				}
				else {
					toklen = 0
				}
			}
		}
		buf << byt
	}
	return buf.str()
}
