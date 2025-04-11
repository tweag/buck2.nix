load("//:flake.bzl", _flake = "flake")

_rules = {"flake.{}".format(name): getattr(_flake, name) for name in dir(_flake)}

load_symbols(_rules)
