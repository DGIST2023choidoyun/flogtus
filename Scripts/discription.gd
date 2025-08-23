extends Label

const msgs: Array[String] = ["This is your score -croak!", "Why did you leave me to die?", "Blub... blub...", "Well, good job.", "I like to dive into a waterfall.", "Stop admiring and save me!", "I regret that jump the most.", "Relax. It only hurts forever.", "You killed one of the many me.", "'WASTED'", "That's ok.\nIt was cool.", "Game over? More like my life over.", "Pro tip: Don’t do what you just did.", "Wow, the snake swims underwa...", "Guess I forgot how to breathe.", "I should have read the tutorial.", "I'm alive! But where am I?", "My legs\nbetrayed me.", "So much for frogging around.", "Do you hear my friends laughing?", "Turns out\nI can’t swim.", "Hop, drop, flop.", "Note: water is\nnot floor.", "My jump button is cursed.", "RIP-ibit.", "Who put water everywhere?!", "So slippery...\nso doomed.", "The water hugs too hard.", "Respawn?\nYes, please.", "I think you’ve got frog hands.", "Even tadpoles jump better.", "Who taught you\nto jump?", "Even the flies mock you.", "Next time,\naim not water.", "Bravo, you invented sinking.", "You don't like white?", "Humans are AMAZING species.", "Here’s the Snakehom River."]

func _ready() -> void:
	Data.add_listener(&"game_set", _set_rand_msg)

func _set_rand_msg() -> void:
	self.text = msgs.pick_random()
