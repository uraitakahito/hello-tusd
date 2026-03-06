.PHONY: generate run clean lint format

# grpclib の protoc プラグインは絶対インポート (import hook_pb2) を生成し、
# この挙動を設定で変更する手段はない。
# サブパッケージ内に生成すると絶対インポートが解決できないため、
# src/ 直下にトップレベルモジュールとして生成することで、
# sed による後処理なしにインポートを正しく解決させる。
generate:
	uv run python -m grpc_tools.protoc \
		--proto_path=proto/ \
		--python_out=src/ \
		--mypy_out=src/ \
		--grpclib_python_out=src/ \
		hook.proto

run: generate
	uv run hello-tusd

clean:
	rm -f src/hook_pb2.py src/hook_pb2.pyi src/hook_grpc.py

lint:
	uv run ruff check
	uv run ruff format --check --diff
	uv run pyright

format:
	uv run ruff check --fix
	uv run ruff format
