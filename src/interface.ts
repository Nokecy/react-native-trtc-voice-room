export interface VoiceRoomSeatInfo {
  status: number;
  mute: boolean;
  userId: string;
}

export interface VoiceRoomParam {
  roomName: string;
  coverUrl?: string;
  needRequest?: boolean;
  seatCount: number;
  seatInfoList?: VoiceRoomSeatInfo[];
}

export interface VoiceRoomInfo {
  roomID: number;
  roomName: string;
  coverUrl: string;
  ownerId: string;
  ownerName: string;
  memberCount: number;
  needRequest: boolean;
}

export interface VoiceRoomUserInfo {
  userId: string;
  userName: string;
  userAvatar: string;
}
