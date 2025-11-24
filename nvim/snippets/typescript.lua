---@diagnostic disable: undefined-global

return {
		s({ trig = "cl (.*)", regTrig = true },
		fmta([[console.log(<>, <>)]], {
			i(1),
			f(function(_, s) return s.captures[1] end)
		})
	),
	s({
		trig = "effectservice",
		dscr = "Effect.Service boilerplate",
		snippetType = "autosnippet"
	}, {
		t("class "),
		i(1, "ServiceName"),
		t(" extends Effect.Service<"),
		rep(1),
		t(">()(\""),
		rep(1),
		t({ "\", {", "" }),
		t({ "\teffect: Effect.gen(function* () {", "" }),
		t("\t\t"),
		i(0),
		t({ "", "\t\treturn {} as const;" }),
		t({ "", "\t})," }),
		t({ "", "}) {}" })
	})
}
