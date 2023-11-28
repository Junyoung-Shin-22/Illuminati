from typing import Any
from dataclasses import dataclass

from illuminati.logics import User, StreetLamp, COMMANDS

class GameSession:
    user1: Any
    user2: Any
    street_lamps: list

    def __init__(self, socket_server):
        self.socket_server = socket_server
        self.socket_connections = []

        self.user1 = None
        self.user2 = None

        self.street_lamps = [StreetLamp(index=i, applied_gates=[]) for i in range(9)]

        self.current_turn = 1

    async def process(self, socket, data):
        ip, command, *args = data.split()
        await COMMANDS[command](self, socket, ip, *args)