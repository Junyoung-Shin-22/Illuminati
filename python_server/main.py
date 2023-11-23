import websockets
import asyncio

import socket
import sys

from illuminati.game_session import GameSession

if len(sys.argv) > 1:
    PORT = int(sys.argv[1])
else:
    PORT = 8000

def get_host_ip():
    return socket.gethostbyname(socket.gethostname())

async def handler(websocket):
    try:
        while True:
            data = await websocket.recv()
            print('log:', data)
            await game_session.process(websocket, data)
    except websockets.exceptions.ConnectionClosed:
        await websocket.close()
     

print("Illuminati game server is ready.")
print()
print("IP:", get_host_ip())
print("Port:", PORT)
print("========== log ==========")

socket_server = websockets.serve(handler, "0.0.0.0", PORT)
game_session = GameSession(socket_server)
asyncio.get_event_loop().run_until_complete(socket_server)
asyncio.get_event_loop().run_forever()