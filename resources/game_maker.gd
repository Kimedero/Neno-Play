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
		3:{"letters":"Chungwa", "words_to_find":["Chuna", "wangu", "chunga", "Chungwa"], "columns":1},
		4:{"letters":"Ndizi", "words_to_find":["nzi", "ndizi"], "columns":1},
		5:{"letters":"Nanasi", "words_to_find":["niA", "aina", "nani", "sana", "nanasi"], "columns":1},
		6:{"letters":"Embe", "words_to_find":["embe"], "columns":1},
		7:{"letters":"Ndazi", "words_to_find":["nia", "nzi","nazi", "ndazi"], "columns":1},
		8:{"letters":"Pilau", "words_to_find":["pia", "pua", "lia", "lipa", "pilau"], "columns":1},
		9:{"letters":"Chapati", "words_to_find":["chapati"], "columns":1},
		10:{"letters":"Kaimati", "words_to_find":["mia", "tai", "kati", "mita", "kamati", "kaimati"], "columns":2},
		11:{"letters":"Mahindi", "words_to_find":["hii", "ini", "dini", "hadi", "ahidi", "hindi", "imani", "mahindi"], "columns":2},
		12:{"letters":"Maharagwe", "words_to_find":["gawa", "hawa", "hema", "mega", "raha", "wema", "gharama", "maharagwe"], "columns":2},
		13:{"letters":"Viazi", "words_to_find":["iva", "vazi", "viazi"], "columns":1},

		14:{"letters":"Karai", "words_to_find":["kaa", "karai"], "columns":1},
		15:{"letters":"Ndoto", "words_to_find":["ndoo", "ndoto"], "columns":1},
		16:{"letters":"Mtungi", "words_to_find":["mti", "mtu", "mui", "tui", "mtungi"], "columns":1},

		17:{"letters":"Bakuli", "words_to_find":["kali", "kila", "ukali", "bakuli", "kubali"], "columns":1},
		18:{"letters":"Sahani", "words_to_find":["nia", "hasa", "nasa", "sahani"], "columns":1},
		19:{"letters":"Kijiko", "words_to_find":["jiko", "kiko", "kijiko"], "columns":1},
		20:{"letters":"Kikombe", "words_to_find":["kimo", "kikombe"], "columns":1},
		21:{"letters":"Sinia", "words_to_find":["nia", "sinia"], "columns":1},

		22:{"letters":"Mtoto", "words_to_find":["moto", "mtoto"], "columns":1},

		23:{"letters":"Dereva", "words_to_find":["dera", "dereva"], "columns":1},
		24:{"letters":"Makanga", "words_to_find":["kaa", "kama", "manga", "makaa", "makanga"], "columns":1},

		25:{"letters":"Saumu", "words_to_find":["au", "Sumu", "saumu"], "columns":1},
		26:{"letters":"Kitunguu", "words_to_find":["kuu", "kuni", "kutu", "tui", "kitu", "tunu", "nukuu", "kitunguu"], "columns":2},

		27:{"letters":"Batamzinga", "words_to_find":["nta", "tai", "zaa", "bata", "bima", "giza", "zama", "azima", "batamzinga"], "columns":2},

		28:{"letters":"Mzinga", "words_to_find":["gani", "giza", "zima", "mzinga"], "columns":1},
		29:{"letters":"Kifaru", "words_to_find":["kiu", "fika", "fura", "kura", "kifaru"], "columns":1},

		30:{"letters":"Simba", "words_to_find":["mia", "basi", "bima", "sima", "SIMBA"], "columns":1},
		31:{"letters":"Ndovu", "words_to_find":["vundo", "ndovu"], "columns":1},
		32:{"letters":"Tausi", "words_to_find":["uta", "sita", "suta", "tauSi"], "columns":1},

		33:{"letters":"Tauni", "words_to_find":["nta", "tani", "tauni"], "columns":1},
		34:{"letters":"Kifaduro", "words_to_find":["fika", "kifaduro"], "columns":1},
		35:{"letters":"Kifua kikuu", "words_to_find":["fua", "kifua", "kikuu", "kifuakikuu"], "columns":1},
		36:{"letters":"Saratani", "words_to_find":["nata", "tani", "tasa", "tania", "SarAtani"], "columns":1},
		37:{"letters":"Kichaa", "words_to_find":["chaki", "kichaA"], "columns":1},

		38:{"letters":"Mdomo", "words_to_find":["omo", "domo", "mdomo"], "columns":1},
		39:{"letters":"MaSikio", "words_to_find":["sio", "sima", "maSikio"], "columns":1},
		40:{"letters":"MaPua", "words_to_find":["mua", "mapuA"], "columns":1},
		41:{"letters":"Kichwa", "words_to_find":["kichwA"], "columns":1},
		42:{"letters":"Miguu", "words_to_find":["miguu"], "columns":1},
		43:{"letters":"Mikono", "words_to_find":["mikono"], "columns":1},
		44:{"letters":"MaPafu", "words_to_find":["mapAfu"], "columns":1},

		45:{"letters":"Mifupa", "words_to_find":["mifupA"], "columns":1},

		46:{"letters":"Sidiria", "words_to_find":["SidiriA"], "columns":1},
		47:{"letters":"Rinda", "words_to_find":["rindA"], "columns":1},

		48:{"letters":"Manjano", "words_to_find":["jana", "mana", "njaa", "mAnjano"], "columns":1},
		49:{"letters":"Samawati", "words_to_find":["misa", "sawa", "tama", "tamaa", "SamAwati"], "columns":1},
		50:{"letters":"Nyekundu", "words_to_find":["nyekundu"], "columns":1},
		51:{"letters":"Hudhurungi", "words_to_find":["hudhurungi"], "columns":1},
	},
}
