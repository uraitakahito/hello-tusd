.PHONY: generate run clean

generate:
	mkdir -p src/hello_tusd/generated
	touch src/hello_tusd/generated/__init__.py
	uv run python -m grpc_tools.protoc \
		--proto_path=proto/ \
		--python_out=src/hello_tusd/generated/ \
		--grpclib_python_out=src/hello_tusd/generated/ \
		hook.proto
	sed -i '' 's/^import hook_pb2/from . import hook_pb2/' src/hello_tusd/generated/hook_grpc.py

run: generate
	uv run hello-tusd

clean:
	rm -f src/hello_tusd/generated/hook_pb2.py src/hello_tusd/generated/hook_grpc.py
