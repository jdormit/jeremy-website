.PHONY: prod

prod:
	clojure -m figwheel.main -O advanced -bo dev
	obelix build
