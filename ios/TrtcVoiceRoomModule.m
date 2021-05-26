//
//  TrtcVoiceRoom.m
//  ACM
//
//  Created by 黎剑锋 on 2021/4/19.
//
#import "TrtcVoiceRoomModule.h"
#import <MJExtension.h>

@implementation TrtcVoiceRoomModule


RCT_EXPORT_MODULE(@"TrtcVoiceRoom");

-(NSArray<NSString *> *)supportedEvents{
  NSArray<NSString*>* array = @[
            @"onAnchorEnterSeat",
            @"onAnchorLeaveSeat",
            @"onAudienceEnter",
            @"onAudienceExit",
            @"onDebugLog",
            @"onError",
            @"onInvitationCancelled",
            @"onInviteeAccepted",
            @"onInviteeRejected",
            @"onRecvRoomCustomMsg",
            @"onRecvRoomTextMsg",
            @"onRoomDestroy",
            @"onRoomInfoChange",
            @"onSeatClose",
            @"onSeatInfoChange",
            @"onSeatMute",
            @"onUserVolumeUpdate",
            @"onWarning"
  ];
  return array;
}

RCT_EXPORT_METHOD(login:(int)sdkAppID userId:(NSString *)userId userSig:(NSString *)userSig resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] setDelegate:self];

  [[TRTCVoiceRoom sharedInstance] login:sdkAppID userId:userId userSig:userSig callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
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
RCT_EXPORT_METHOD(createRoom:(int)roomID roomParam:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString* roomName = options[@"roomName"];
  NSString* coverUrl = options[@"coverUrl"];
  BOOL needRequest = [options[@"needRequest"] boolValue];
  int seatCount = [options[@"seatCount"] intValue];
  VoiceRoomParam* param = [[VoiceRoomParam alloc] init];
  param.roomName=roomName;
  param.coverUrl = coverUrl;
  param.needRequest = needRequest;
  param.seatCount = seatCount;
  [[TRTCVoiceRoom sharedInstance] createRoom:roomID roomParam:param callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
 * 销毁房间（主播调用）
*
* 主播在创建房间后，可以调用这个函数来销毁房间。
*/
RCT_EXPORT_METHOD(destroyRoom:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] destroyRoom:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
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
RCT_EXPORT_METHOD(enterRoom:(int)roomID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] enterRoom:roomID callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
* 退出房间
*
* - parameter callback 退出房间是否成功的结果回调
*/
RCT_EXPORT_METHOD(exitRoom:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] exitRoom:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
* 获取房间列表的详细信息
*
* 其中的信息是主播在创建 `createRoom()` 时通过 roomParam 设置进来的，如果房间列表和房间信息都由您的服务器自行管理，此函数您可以不用关心。
*
* - parameter roomIdList   房间号列表
* - parameter callback     房间详细信息回调
*/
RCT_EXPORT_METHOD(getRoomInfoList:(NSArray<NSNumber *> *)roomIdList resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] getRoomInfoList:roomIdList callback:^(int code, NSString * _Nonnull message, NSArray<VoiceRoomInfo *> * _Nonnull roomInfos) {
    if (code == 0) {
        NSMutableArray *array = [NSMutableArray new];
     for (VoiceRoomInfo* info in roomInfos) {
         [array addObject:info.mj_keyValues];
     }
      resolve(@{@"roomInfos":array});
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
* 获取指定userId的用户信息，如果为null，则获取房间内所有人的信息
*
* - parameter userIDList   用户id列表
* - parameter callback     用户详细信息回调
*/
RCT_EXPORT_METHOD(getUserInfoList:(NSArray<NSString *> *)userIDList resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] getUserInfoList:userIDList callback:^(int code, NSString * _Nonnull message, NSArray<VoiceRoomUserInfo *> * _Nonnull userInfos) {
    if (code == 0) {
     NSMutableArray *array = [NSMutableArray new];
     for (VoiceRoomUserInfo* info in userInfos) {
         [array addObject:info.mj_keyValues];
     }
      resolve(@{@"userInfos":array});
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

#pragma mark - 麦位管理接口
/**
* 主动上麦（观众端和主播均可调用）
*
* 上麦成功后，房间内所有成员会收到`onSeatListChange`和`onAnchorEnterSeat`的事件通知。
*
* - parameter seatIndex    需要上麦的麦位序号
* - parameter callback     操作回调
*/
RCT_EXPORT_METHOD(enterSeat:(NSInteger)seatIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] enterSeat:seatIndex callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
* 主动下麦（观众端和主播均可调用）
*
* 下麦成功后，房间内所有成员会收到`onSeatListChange`和`onAnchorLeaveSeat`的事件通知。
*
* - parameter callback 操作回调
*/
RCT_EXPORT_METHOD(leaveSeat:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] leaveSeat:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
 * 踢人下麦(主播调用)
 *
 * 主播踢人下麦，房间内所有成员会收到`onSeatListChange`和`onAnchorLeaveSeat`的事件通知。
 *
 * - parameter seatIndex    需要踢下麦的麦位序号
 * - parameter callback     操作回调
 */
RCT_EXPORT_METHOD(kickSeat:(NSInteger)seatIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] kickSeat:seatIndex callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
* 静音/解禁对应麦位的麦克风(主播调用)
*
* - parameter seatIndex    麦位序号
* - parameter isMute       true : 静音，false : 解除静音
* - parameter callback     操作回调
*/
RCT_EXPORT_METHOD(muteSeat:(NSInteger)seatIndex isMute:(BOOL)isMute resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] muteSeat:seatIndex isMute:isMute callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}


/**
* 封禁/解禁某个麦位(主播调用)
*
* - parameter seatIndex    麦位序号
* - parameter isClose      true : 封禁，false : 解除封禁
* - parameter callback     操作回调
*/
RCT_EXPORT_METHOD(closeSeat:(NSInteger)seatIndex isClose:(BOOL)isClose resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] closeSeat:seatIndex isClose:isClose callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

#pragma mark - 本地音频操作接口

/**
* 开启麦克风采集
*/
RCT_EXPORT_METHOD(startMicrophone)
{
  [[TRTCVoiceRoom sharedInstance] startMicrophone];
}

/**
* 停止麦克风采集
*/
RCT_EXPORT_METHOD(stopMicrophone)
{
  [[TRTCVoiceRoom sharedInstance] stopMicrophone];
}

/**
* 开启本地静音
*
* - parameter mute 是否静音
*/
RCT_EXPORT_METHOD(muteLocalAudio:(BOOL)mute)
{
  [[TRTCVoiceRoom sharedInstance] muteLocalAudio:mute];
}

/**
* 设置开启扬声器
*
* - parameter useSpeaker  true : 扬声器，false : 听筒
*/
RCT_EXPORT_METHOD(setSpeaker:(BOOL)userSpeaker )
{
  [[TRTCVoiceRoom sharedInstance] setSpeaker:userSpeaker];
}
#pragma mark - 远端用户接口

/**
* 静音某一个用户的声音
*
* - parameter userId   用户id
* - parameter mute     true : 静音，false : 解除静音
*/
RCT_EXPORT_METHOD(muteRemoteAudio:(NSString *)userId mute:(BOOL)mute)
{
  [[TRTCVoiceRoom sharedInstance] muteRemoteAudio:userId mute:mute];
}
/**
* 静音所有用户的声音
*
* - parameter isMute true : 静音，false : 解除静音
*/
RCT_EXPORT_METHOD(muteAllRemoteAudio:(BOOL)isMute)
{
  [[TRTCVoiceRoom sharedInstance] muteAllRemoteAudio:isMute];
}
#pragma mark - 消发送接口
/**
* 在房间中广播文本消息，一般用于弹幕聊天
*
* - parameter message  文本消息
* - parameter callback 发送结果回调
*/
RCT_EXPORT_METHOD(sendRoomTextMsg:(NSString *)message resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] sendRoomTextMsg:message callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

/**
* 在房间中广播自定义（信令）消息，一般用于广播点赞和礼物消息
*
* - parameter cmd      命令字，由开发者自定义，主要用于区分不同消息类型
* - parameter message  文本消息
* - parameter callback 发送结果回调
*/
RCT_EXPORT_METHOD(sendRoomCustomMsg:(NSString *)cmd message:(NSString *)message  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[TRTCVoiceRoom sharedInstance] sendRoomCustomMsg:cmd message:message callback:^(int code, NSString * _Nonnull message) {
    if (code == 0) {
      resolve(@"");
    }else{
      reject([NSString stringWithFormat:@"%d",code],message,nil);
    }
  }];
}

//主播上麦回调
- (void)onAnchorEnterSeat:(NSInteger)index user:(nonnull VoiceRoomUserInfo *)user {
  [self sendEventWithName:@"onAnchorEnterSeat" body:@{@"index":@(index),@"user":user.mj_keyValues}];
}

//主播下麦回调
- (void)onAnchorLeaveSeat:(NSInteger)index user:(nonnull VoiceRoomUserInfo *)user {
  [self sendEventWithName:@"onAnchorLeaveSeat" body:@{@"index":@(index),@"user":user.mj_keyValues}];
}

//观众进房回调
- (void)onAudienceEnter:(nonnull VoiceRoomUserInfo *)userInfo {
  [self sendEventWithName:@"onAudienceEnter" body:@{@"userInfo":userInfo.mj_keyValues}];
}

//观众退房回调
- (void)onAudienceExit:(nonnull VoiceRoomUserInfo *)userInfo {
  [self sendEventWithName:@"onAudienceExit" body:@{@"userInfo":userInfo.mj_keyValues}];
}

//Debug日志
- (void)onDebugLog:(nonnull NSString *)message {
  [self sendEventWithName:@"onDebugLog" body:@{@"message":message}];
}

//错误
- (void)onError:(int)code message:(nonnull NSString *)message {
  [self sendEventWithName:@"onError" body:@{@"code":@(code),@"message":message}];
}

//邀请被取消回调
- (void)onInvitationCancelled:(nonnull NSString *)identifier invitee:(nonnull NSString *)invitee {
  [self sendEventWithName:@"onInvitationCancelled" body:@{@"identifier":identifier,@"invitee":invitee}];
}

//邀请被接受回调
- (void)onInviteeAccepted:(nonnull NSString *)identifier invitee:(nonnull NSString *)invitee {
  [self sendEventWithName:@"onInviteeAccepted" body:@{@"identifier":identifier,@"invitee":invitee}];
}

//邀请被拒绝回调
- (void)onInviteeRejected:(nonnull NSString *)identifier invitee:(nonnull NSString *)invitee {
  [self sendEventWithName:@"onInviteeRejected" body:@{@"identifier":identifier,@"invitee":invitee}];
}

//邀请信息接收回调
- (void)onReceiveNewInvitation:(nonnull NSString *)identifier inviter:(nonnull NSString *)inviter cmd:(nonnull NSString *)cmd content:(nonnull NSString *)content {
  
}

//自定义消息（信令消息）接收回调
- (void)onRecvRoomCustomMsg:(nonnull NSString *)cmd message:(nonnull NSString *)message userInfo:(nonnull VoiceRoomUserInfo *)userInfo {
  [self sendEventWithName:@"onRecvRoomCustomMsg" body:@{@"cmd":cmd,@"message":message,@"userInfo":userInfo.mj_keyValues}];
}

//文本消息接收回调
- (void)onRecvRoomTextMsg:(nonnull NSString *)message userInfo:(nonnull VoiceRoomUserInfo *)userInfo {
  [self sendEventWithName:@"onRecvRoomTextMsg" body:@{@"message":message,@"userInfo":userInfo.mj_keyValues}];
}

//房间销毁回调
- (void)onRoomDestroy:(nonnull NSString *)message {
  [self sendEventWithName:@"onRoomDestroy" body:@{@"message":message}];
}

//房间信息变更回调
- (void)onRoomInfoChange:(nonnull VoiceRoomInfo *)roomInfo {
  [self sendEventWithName:@"onRoomInfoChange" body:@{@"roomInfo":roomInfo.mj_keyValues}];
}

//座位关闭回调
- (void)onSeatClose:(NSInteger)index isClose:(BOOL)isClose {
  [self sendEventWithName:@"onSeatClose" body:@{@"index":@(index),@"isClose":@(isClose)}];
}

//房间座位变更回调
- (void)onSeatInfoChange:(nonnull NSArray<VoiceRoomSeatInfo *> *)seatInfolist {
  NSMutableArray *array = [NSMutableArray new];
     for (VoiceRoomSeatInfo* info in seatInfolist) {
         [array addObject:info.mj_keyValues];
     }
  [self sendEventWithName:@"onSeatInfoChange" body:@{@"seatInfolist":array}];
}

//座位静音状态回调
- (void)onSeatMute:(NSInteger)index isMute:(BOOL)isMute {
  [self sendEventWithName:@"onSeatMute" body:@{@"index":@(index),@"isMute":@(isMute)}];
}

//用户音量变动回调
- (void)onUserVolumeUpdate:(nonnull NSString *)userId volume:(NSInteger)volume {
  [self sendEventWithName:@"onUserVolumeUpdate" body:@{@"userId":userId,@"volume":@(volume)}];
}

//警告回调
- (void)onWarning:(int)code message:(nonnull NSString *)message {
  [self sendEventWithName:@"onWarning" body:@{@"code":@(code),@"message":message}];
}

@end
