import asyncio
import logging

from grpclib.server import Server
from hello_tusd.generated.hook_pb2 import HookResponse
from hello_tusd.generated.hook_grpc import HookHandlerBase

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)


class HookHandler(HookHandlerBase):
    async def InvokeHook(self, stream) -> None:
        request = await stream.recv_message()

        upload = request.event.upload
        http_req = request.event.httpRequest

        logger.info(
            "Hook: %s | Upload: %s | Size: %d | Offset: %d | Method: %s %s | Remote: %s | MetaData: %s | Storage: %s",
            request.type,
            upload.id,
            upload.size,
            upload.offset,
            http_req.method,
            http_req.uri,
            http_req.remoteAddr,
            dict(upload.metaData),
            dict(upload.storage),
        )

        await stream.send_message(HookResponse())


async def _serve():
    server = Server([HookHandler()])
    await server.start("0.0.0.0", 8000)
    logger.info("gRPC Hook server listening on port 8000")
    await server.wait_closed()


def main():
    asyncio.run(_serve())


if __name__ == "__main__":
    main()
