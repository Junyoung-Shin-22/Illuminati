import websockets
from dataclasses import dataclass

class User:
    def __init__(self, IP:str):
        self.IP = IP
        self.dumped_card: list = []

@dataclass
class StreetLamp:
    index: int
    applied_gates: list

def broadcast(game_session, message):
    websockets.broadcast(game_session.socket_connections, message)



async def _connect(game_session, socket, ip, *args):
    if game_session.user1 is None:
        game_session.user1 = User(IP=ip)
        game_session.socket_connections.append(socket)
        
        await socket.send('player 1')
        print(ip, 'is player 1')
    elif game_session.user2 is None:
        if ip == game_session.user1.IP: # user1 and user2 must be different
            return
        
        game_session.user2 = User(IP=ip)
        game_session.socket_connections.append(socket)
        
        await socket.send('player 2')
        print(ip, 'is player 2')
    else: # there are already two users
        print('room already full')
        return

    # if both user joined
    if game_session.user1 is not None and game_session.user2 is not None:
        broadcast(game_session, "game_start")



async def _disconnect(game_session, socket, ip, *args):
    if game_session.user1 is not None:
        if game_session.user1.IP == ip:
            game_session.user1 = None
            game_session.socket_connections.remove(socket)

        print('player 1', ip, 'left')
    
    if game_session.user2 is not None:
        if game_session.user2.IP == ip:
            game_session.user2 = None
            game_session.socket_connections.remove(socket)
        
        print('user 2', ip, 'left')



async def _end_turn(game_session, socket, ip, *args):
    if game_session.user1.IP == ip:
        broadcast(game_session, f'end_turn {game_session.current_turn} 1')
    
    elif game_session.user2.IP == ip:
        broadcast(game_session, f'end_turn {game_session.current_turn} 2')

        game_session.current_turn += 1
        broadcast(game_session, 'current_turn %d' % game_session.current_turn)



async def _buy_card(game_session, socket, ip, *args):
    if game_session.user1.IP == ip:
        pass
    elif game_session.user2.IP == ip:
        pass



async def _use_card(game_session, socket, ip, *args):
    if game_session.user1.IP == ip:
        pass
    elif game_session.user2.IP == ip:
        pass



COMMANDS = {
    "connect": _connect,
    "disconnect": _disconnect,
    "end_turn": _end_turn,
    "buy_card": _buy_card,
    "use_card": _use_card,
}