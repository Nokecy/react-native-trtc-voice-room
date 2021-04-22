//
//  TrtcVoiceRoom.h
//  ACM
//
//  Created by 黎剑锋 on 2021/4/19.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "TRTCVoiceRoom.h"
#import "TRTCVoiceRoomDelegate.h"

@interface TrtcVoiceRoom : RCTEventEmitter<RCTBridgeModule, TRTCVoiceRoomDelegate>

@end
