extends Node

func is_debug():
	return false
	
func is_mobile():
	return OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile")
