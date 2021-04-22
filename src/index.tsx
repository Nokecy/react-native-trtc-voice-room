import { NativeModules } from 'react-native';

type TrtcVoiceRoomType = {
  multiply(a: number, b: number): Promise<number>;
};

const { TrtcVoiceRoom } = NativeModules;

export default TrtcVoiceRoom as TrtcVoiceRoomType;
