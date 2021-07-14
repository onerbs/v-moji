module moji

import strings

// emojify will translate the emoji names into
// the actual Unicode character.
// e.g.
//   emojify(':sparkles:') --> '✨'
pub fn emojify(base string) string {
	mut pairs := []string{}
	mut buf := strings.new_builder(0x20)
	mut active := false
	for c in base {
		if c == `:` {
			if !active {
				active = true
				buf << c
			} else if buf.len > 1 {
				active = false
				buf << c
				name := buf.str()
				emoji := moji.db[name] or { continue }
				pairs << name
				pairs << string(emoji)
			}
		} else if active {
			if c.is_space() {
				active = false
				buf.trim(0)
			} else {
				buf << c
			}
		}
	}
	return base.replace_each(pairs)
}
