import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({ cors: true, namespace: '/chat' })
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  handleConnection(client: Socket) {
    const userId = client.handshake.query.userId as string;
    if (userId) {
      void client.join(userId);
      console.log(`[Chat] User ${userId} connected (joined room ${userId})`);
    }
  }

  handleDisconnect(client: Socket) {
    const userId = client.handshake.query.userId as string;
    const userName = (client.handshake.query.userName as string) || 'Someone';
    if (userId) {
      console.log(`[Chat] User ${userId} disconnected`);
      // Broadcast disconnect to lobby (parity with Python)
      this.server.emit('global_message', {
        userName: 'System',
        message: `${userName} left the lobby`,
        timestamp: new Date().toISOString(),
      });
    }
  }

  @SubscribeMessage('global_message')
  handleGlobalMessage(
    @MessageBody() data: { userName: string; message: string },
  ) {
    // Broadcast to all connected clients
    this.server.emit('global_message', {
      userName: data.userName,
      message: data.message,
      timestamp: new Date().toISOString(),
    });
  }

  @SubscribeMessage('private_message')
  handlePrivateMessage(
    @MessageBody() data: { targetUserId: string; message: string },
    @ConnectedSocket() client: Socket,
  ) {
    const senderId = client.handshake.query.userId as string;
    this.server.to(data.targetUserId).emit('private_message', {
      senderId,
      message: data.message,
      timestamp: new Date().toISOString(),
    });
  }

  @SubscribeMessage('webrtc_signal')
  handleWebRTCSignal(
    @MessageBody() data: { targetUserId: string; signal: unknown },
    @ConnectedSocket() client: Socket,
  ) {
    const senderId = client.handshake.query.userId as string;
    this.server.to(data.targetUserId).emit('webrtc_signal', {
      senderId,
      signal: data.signal,
    });
  }
}
