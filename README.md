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

```bash
docker run -d --init --rm -p 8080:8080 --name tusd-container docker.io/tusproject/tusd:latest -host=0.0.0.0 -port=8080 -hooks-grpc=host.docker.internal:8000
```

## Starting the development server with Docker

If you develop inside a Docker container, run the following commands and read the documentation at the top of the Dockerfile to set up your development environment.

```console
% curl -L -O https://raw.githubusercontent.com/uraitakahito/hello_python_uv/refs/tags/1.0.0/Dockerfile
% curl -L -O https://raw.githubusercontent.com/uraitakahito/hello_python_uv/refs/tags/1.0.0/docker-entrypoint.sh
% chmod 755 docker-entrypoint.sh
```

ただし、gRPCサーバーのポートを公開する必要があるので、コンテナの起動コマンドは次のようになります。

```console
% PROJECT=$(basename `pwd`) && docker image build -t $PROJECT-image . --build-arg user_id=`id -u` --build-arg group_id=`id -g`
% docker container run -d --rm --init -p 8000:8000 -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock -e GH_TOKEN=$(gh auth token) --mount type=bind,src=`pwd`,dst=/app --mount type=volume,source=$PROJECT-zsh-history,target=/zsh-volume --name $PROJECT-container $PROJECT-image
```
