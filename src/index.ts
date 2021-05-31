import { NativeModules, NativeEventEmitter } from 'react-native';
import type {
  VoiceRoomParam,
  VoiceRoomInfo,
  VoiceRoomUserInfo,
} from './interface';

const { TrtcVoiceRoomModule } = NativeModules;
const TRTCVoiceRoomEventEmitter = new NativeEventEmitter(TrtcVoiceRoomModule);

export default class TRTCVoiceRoomNative {
  static login(
    sdkAppId: number,
    userId: string,
    userSig: string
  ): Promise<any> {
    return TrtcVoiceRoomModule?.login(sdkAppId, userId, userSig);
  }
  /**
   * 创建房间（主播调用）
   *
   * 主播正常的调用流程是：
   * 1. 主播调用`createRoom`创建新的语音聊天室，此时传入房间 ID、上麦是否需要房主确认、麦位数等房间属性信息。
   * 2. 主播创建房间成功后，调用`enterSeat`进入座位。
   * 3. 主播收到组件的`onSeatListChange`麦位表变化事件通知，此时可以将麦位表变化刷新到 UI 界面上。
   * 4. 主播还会收到麦位表有成员进入的`onAnchorEnterSeat`的事件通知，此时会自动打开麦克风采集。
   *
   * - parameter roomID       房间标识，需要由您分配并进行统一管理。
   * - parameter roomParam    房间信息，用于房间描述的信息，例如房间名称，封面信息等。如果房间列表和房间信息都由您的服务器自行管理，可忽略该参数。
   * - parameter callback     创建房间的结果回调，成功时 code 为0.
   */
  static createRoom(roomID: number, roomParam?: VoiceRoomParam): Promise<any> {
    return TrtcVoiceRoomModule?.createRoom(roomID, roomParam);
  }

  /**
   * 销毁房间（主播调用）
   *
   * 主播在创建房间后，可以调用这个函数来销毁房间。
   */
  static destroyRoom(): Promise<any> {
    return TrtcVoiceRoomModule?.destroyRoom();
  }

  /**
   * 进入房间（观众调用）
   *
   * 观众观看直播的正常调用流程如下：
   * 1.【观众】向您的服务端获取最新的语音聊天室列表，可能包含多个直播间的 roomId 和房间信息。
   * 2. 观众选择一个语音聊天室，调用`enterRoom`并传入房间号即可进入该房间。
   * 3. 进房后会收到组件的`onRoomInfoChange`房间属性变化事件通知，此时可以记录房间属性并做相应改变，例如 UI 展示房间名、记录上麦是否需要请求主播同意等。
   * 4. 进房后会收到组件的`onSeatListChange`麦位表变化事件通知，此时可以将麦位表变化刷新到 UI 界面上。
   * 5. 进房后还会收到麦位表有主播进入的`onAnchorEnterSeat`的事件通知。
   *
   * - parameter roomID   房间标识
   * - parameter callback 进入房间是否成功的结果回调
   */
  static enterRoom(roomID: number): Promise<any> {
    return TrtcVoiceRoomModule?.enterRoom(roomID);
  }

  /**
   * 退出房间
   *
   * - parameter callback 退出房间是否成功的结果回调
   */
  static exitRoom(): Promise<any> {
    return TrtcVoiceRoomModule?.exitRoom();
  }

  /**
   * 获取房间列表的详细信息
   *
   * 其中的信息是主播在创建 `createRoom()` 时通过 roomParam 设置进来的，如果房间列表和房间信息都由您的服务器自行管理，此函数您可以不用关心。
   *
   * - parameter roomIdList   房间号列表
   * - parameter callback     房间详细信息回调
   */
  static getRoomInfoList(
    roomIdList: number[]
  ): Promise<{ roomInfos: VoiceRoomInfo[] }> {
    return TrtcVoiceRoomModule?.getRoomInfoList(roomIdList);
  }

  /**
   * 获取指定userId的用户信息，如果为null，则获取房间内所有人的信息
   *
   * - parameter userIDList   用户id列表
   * - parameter callback     用户详细信息回调
   */
  static getUserInfoList(
    userIDList: string[]
  ): Promise<{ userInfos: VoiceRoomUserInfo[] }> {
    return TrtcVoiceRoomModule?.getUserInfoList(userIDList);
  }

  /**
   * 主动上麦（观众端和主播均可调用）
   *
   * 上麦成功后，房间内所有成员会收到`onSeatListChange`和`onAnchorEnterSeat`的事件通知。
   *
   * - parameter seatIndex    需要上麦的麦位序号
   * - parameter callback     操作回调
   */
  static enterSeat(seatIndex: number): Promise<any> {
    return TrtcVoiceRoomModule?.enterSeat(seatIndex);
  }

  /**
   * 主动下麦（观众端和主播均可调用）
   *
   * 下麦成功后，房间内所有成员会收到`onSeatListChange`和`onAnchorLeaveSeat`的事件通知。
   *
   * - parameter callback 操作回调
   */
  static leaveSeat(): Promise<any> {
    return TrtcVoiceRoomModule?.leaveSeat();
  }

  /**
   * 踢人下麦(主播调用)
   *
   * 主播踢人下麦，房间内所有成员会收到`onSeatListChange`和`onAnchorLeaveSeat`的事件通知。
   *
   * - parameter seatIndex    需要踢下麦的麦位序号
   * - parameter callback     操作回调
   */
  static kickSeat(seatIndex: number): Promise<any> {
    return TrtcVoiceRoomModule?.kickSeat(seatIndex);
  }

  /**
   * 静音/解禁对应麦位的麦克风(主播调用)
   *
   * - parameter seatIndex    麦位序号
   * - parameter isMute       true : 静音，false : 解除静音
   * - parameter callback     操作回调
   */
  static muteSeat(seatIndex: number, isMute: boolean) {
    return TrtcVoiceRoomModule?.muteSeat(seatIndex, isMute);
  }

  /**
   * 封禁/解禁某个麦位(主播调用)
   *
   * - parameter seatIndex    麦位序号
   * - parameter isClose      true : 封禁，false : 解除封禁
   * - parameter callback     操作回调
   */
  static closeSeat(seatIndex: number, isClose: boolean) {
    return TrtcVoiceRoomModule?.closeSeat(seatIndex, isClose);
  }

  /**
   * 开启麦克风采集
   */
  static startMicrophone() {
    return TrtcVoiceRoomModule?.startMicrophone();
  }

  /**
   * 停止麦克风采集
   */
  static stopMicrophone() {
    return TrtcVoiceRoomModule?.stopMicrophone();
  }

  /**
   * 开启本地静音
   *
   * - parameter mute 是否静音
   */
  static muteLocalAudio(mute: boolean) {
    return TrtcVoiceRoomModule?.muteLocalAudio(mute);
  }

  /**
   * 设置开启扬声器
   *
   * - parameter useSpeaker  true : 扬声器，false : 听筒
   */
  static setSpeaker(userSpeaker: boolean) {
    return TrtcVoiceRoomModule?.setSpeaker(userSpeaker);
  }

  /**
   * 静音某一个用户的声音
   *
   * - parameter userId   用户id
   * - parameter mute     true : 静音，false : 解除静音
   */
  static muteRemoteAudio(userId: string, mute: boolean) {
    return TrtcVoiceRoomModule?.muteRemoteAudio(userId, mute);
  }

  /**
   * 静音所有用户的声音
   *
   * - parameter isMute true : 静音，false : 解除静音
   */
  static muteAllRemoteAudio(mute: boolean) {
    return TrtcVoiceRoomModule?.muteAllRemoteAudio(mute);
  }

  /**
   * 在房间中广播文本消息，一般用于弹幕聊天
   *
   * - parameter message  文本消息
   * - parameter callback 发送结果回调
   */
  static sendRoomTextMsg(message: string) {
    return TrtcVoiceRoomModule?.sendRoomTextMsg(message);
  }
}
export { TRTCVoiceRoomEventEmitter };
