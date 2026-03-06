# hello-tusd

tusdの[gRPC Hooks](https://tus.github.io/tusd/advanced-topics/hooks/#grpc-hooks)を受け取り、アップロードファイルやイベント情報をコンソールに出力するスケルトンサーバー。

## 前提条件

- Python >= 3.12
- [uv](https://docs.astral.sh/uv/)
- Docker

## セットアップ

```bash
uv sync
make generate
```

## gRPC Hookサーバーの起動

```bash
make run
```

ポート8000でgRPCサーバーが起動する。

```
2026-03-06 23:07:12,083 [INFO] gRPC Hook server listening on port 8000
```

## tusd Dockerコンテナの起動

gRPC Hookサーバーを起動した状態で、別のターミナルからtusdコンテナを起動する。

```bash
docker run -d --init --rm -p 8080:8080 --name tusd-container docker.io/tusproject/tusd:latest -host=0.0.0.0 -port=8080 -hooks-grpc=host.docker.internal:8000
```

`-hooks-grpc=host.docker.internal:8000` により、コンテナからホストマシン上のgRPC Hookサーバーに接続する。

### コンテナの停止

```bash
docker stop tusd-container
```
