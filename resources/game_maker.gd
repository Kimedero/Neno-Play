extends Resource

var games: Dictionary = {
	0:{ # english
		0:{"letters":"AND", "words_to_find":["AN", "and"], "columns":1},
		1:{"letters":"WHO", "words_to_find":["WHO", "HOW"], "columns":1},
		2:{"letters":"THERE", "words_to_find":["HER", "TEE", "HERE", "THERE"], "columns":2},
		},
	1:{ # swahili
		0:{"letters":"Saa", "words_to_find":["SaA"], "columns":1},
		1:{"letters":"SANAA", "words_to_find":["SAA", "SANA", "NASA", "ANASA", "SANAA"], "columns":1},
		2:{"letters":"HABARI", "words_to_find":["BIA", "BARA", "HABA", "raha", "HABARI", "BAHARI"], "columns":2},
	},
}
