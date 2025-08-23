extends Label

const msgs: Array[String] = ["This is your score -croak!", "Why did you leave me to die?", "Blub... blub...", "Well, good job.", "I like to dive\ninto a waterfall.", "Stop admiring and save me!", "I regret that jump the most.", "Relax. It only hurts forever.", "You killed one of the many me.", "'WASTED'", "That's ok.\nIt was cool.", "Game over? More like my life over.", "Pro tip: Don’t do what you just did.", "Wow, the snake swims underwa...", "Guess I forgot how to breathe.", "I should have read the tutorial.", "I'm alive!\nBut where am I?", "My legs\nbetrayed me.", "So much for frogging around.", "Do you hear my friends laughing?", "Turns out\nI can’t swim.", "Hop, drop, flop.", "Note: water is\nnot floor.", "My jump button\nis cursed.", "RIP-ibit.", "Who put water everywhere?!", "So slippery...\nso doomed.", "The water hugs too hard.", "Respawn?\nYes, please.", "I think you’ve got frog hands.", "Even tadpoles\njump better.", "Who taught you\nto jump?", "Even the flies\nmock you.", "Next time,\naim not water.", "Bravo, you\ninvented sinking.", "You don't like white?", "Humans are\nAMAZING species.", "Here’s the Snakehom River."]

func _ready() -> void:
	Data.add_listener(&"game_set", _set_rand_msg)

func _set_rand_msg() -> void:
	self.text = msgs.pick_random()
