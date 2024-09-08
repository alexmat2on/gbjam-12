class_name Logger

static func log(messages: Array):
	var str_messages = []
	for m in messages:
		str_messages.push_back(str(m))
	print(" ".join(messages))
