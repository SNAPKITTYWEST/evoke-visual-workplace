.PHONY: build smoke verify clean help

help:
	@echo "targets: build | smoke | verify | clean"

# Assemble ColorForth + Dylan + BEAM into build/out/
build:
	./evoke

# Pure-Python DYLN encode/decode smoke (no Elixir needed)
smoke:
	python3 scripts/frame_smoke.py

# Full check: build + smoke + prove build/out is reproducible byte-for-byte
verify: build
	python3 scripts/frame_smoke.py
	cp -r build/out /tmp/evoke-out-first
	./evoke
	diff -r /tmp/evoke-out-first build/out && echo "verify: build/out reproducible byte-for-byte"
	rm -rf /tmp/evoke-out-first

clean:
	rm -rf __pycache__ scripts/__pycache__
	find . -name '*.pyc' -delete
