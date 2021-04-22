package com.reactnativetrtcvoiceroom;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.ArrayList;
import java.util.List;

public class TrtcVoiceRoomModule extends ReactContextBaseJavaModule implements TRTCVoiceRoomDelegate {
  private static ReactApplicationContext reactContext;

  public TrtcVoiceRoomModule(ReactApplicationContext context) {
    super(context);
    reactContext = context;
  }

  private void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }

  @NonNull
  @Override
  public String getName() {
    return "TrtcVoiceRoom";
  }

  @ReactMethod
  public void logoin(int sdkAppID, String userId, String userSig, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).setDelegate(this);

    TRTCVoiceRoom.sharedInstance(reactContext).login(sdkAppID, userId, userSig, new TRTCVoiceRoomCallback.ActionCallback() {
      @Override
      public void onCallback(int code, String msg) {
        if (code == 0) {
          promise.resolve(code);
        } else {
          promise.reject(code + "", msg);
        }
      }
    });
  }

  @ReactMethod
  public void createRoom(int roomID, ReadableMap roomParam, Promise promise) {
    TRTCVoiceRoomDef.RoomParam param = new TRTCVoiceRoomDef.RoomParam();
    param.roomName = roomParam.getString("roomName");
    param.coverUrl = roomParam.getString("coverUrl");
    param.needRequest = roomParam.getBoolean("needRequest");
    param.seatCount = roomParam.getInt("seatCount");
//    param.seatInfoList = roomParam.getArray("seatInfoList");
    TRTCVoiceRoom.sharedInstance(reactContext).createRoom(roomID, param, (code, msg) -> {
      if (code == 0) {
        promise.resolve(code);
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void destroyRoom(Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).destroyRoom((code, msg) -> {
      if (code == 0) {
        promise.resolve(code);
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void enterRoom(int roomID, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).enterRoom(roomID, (code, msg) -> {
      if (code == 0) {
        promise.resolve(code);
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void exitRoom(Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).exitRoom((code, msg) -> {
      if (code == 0) {
        promise.resolve(code);
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void getRoomInfoList(ReadableArray roomIdList, Promise promise) {
    ArrayList<Integer> models = new ArrayList<>();
    for (int i = 0; i < roomIdList.size(); i++) {
      int map = roomIdList.getInt(i);
      models.add(map);
    }
    TRTCVoiceRoom.sharedInstance(reactContext).getRoomInfoList(models, (code, msg, roomInfoList) -> {
      if (code == 0) {
        WritableMap map = Arguments.createMap();
        map.putArray("roomInfos", Arguments.fromArray(roomInfoList));
        promise.resolve(map);
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void getUserInfoList(ReadableArray userIdList, Promise promise) {
    ArrayList<String> models = new ArrayList<>();
    for (int i = 0; i < userIdList.size(); i++) {
      String map = userIdList.getString(i);
      models.add(map);
    }
    TRTCVoiceRoom.sharedInstance(reactContext).getUserInfoList(models, (code, msg, userInfoList) -> {
      if (code == 0) {
        WritableMap map = Arguments.createMap();
        map.putArray("userInfos", Arguments.fromArray(userInfoList));
        promise.resolve(map);
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void enterSeat(int seatIndex, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).enterSeat(seatIndex, (code, msg) -> {
      if (code == 0) {
        promise.resolve("");
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void leaveSeat(Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).leaveSeat((code, msg) -> {
      if (code == 0) {
        promise.resolve("");
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void kickSeat(int seatIndex, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).kickSeat(seatIndex, (code, msg) -> {
      if (code == 0) {
        promise.resolve("");
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void muteSeat(int seatIndex, boolean isMute, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).muteSeat(seatIndex, isMute, (code, msg) -> {
      if (code == 0) {
        promise.resolve("");
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void closeSeat(int seatIndex, boolean isClose, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).closeSeat(seatIndex, isClose, (code, msg) -> {
      if (code == 0) {
        promise.resolve("");
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void startMicrophone() {
    TRTCVoiceRoom.sharedInstance(reactContext).startMicrophone();
  }

  @ReactMethod
  public void stopMicrophone() {
    TRTCVoiceRoom.sharedInstance(reactContext).stopMicrophone();
  }

  @ReactMethod
  public void muteLocalAudio(boolean mute) {
    TRTCVoiceRoom.sharedInstance(reactContext).muteLocalAudio(mute);
  }

  @ReactMethod
  public void setSpeaker(boolean userSpeaker) {
    TRTCVoiceRoom.sharedInstance(reactContext).muteLocalAudio(userSpeaker);
  }

  @ReactMethod
  public void muteRemoteAudio(String userId, boolean mute) {
    TRTCVoiceRoom.sharedInstance(reactContext).muteRemoteAudio(userId, mute);
  }

  @ReactMethod
  public void muteAllRemoteAudio(String userId, boolean mute) {
    TRTCVoiceRoom.sharedInstance(reactContext).muteAllRemoteAudio(mute);
  }

  @ReactMethod
  public void sendRoomTextMsg(String message, boolean isClose, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).sendRoomTextMsg(message, (code, msg) -> {
      if (code == 0) {
        promise.resolve("");
      } else {
        promise.reject(code + "", msg);
      }
    });
  }

  @ReactMethod
  public void sendRoomCustomMsg(String cmd, String message, Promise promise) {
    TRTCVoiceRoom.sharedInstance(reactContext).sendRoomCustomMsg(cmd, message, (code, msg) -> {
      if (code == 0) {
        promise.resolve("");
      } else {
        promise.reject(code + "", msg);
      }
    });
  }


  @Override
  public void onError(int code, String message) {
    WritableMap map = Arguments.createMap();
    map.putInt("code", code);
    map.putString("message", message);
    sendEvent(reactContext, "onError", map);
  }

  @Override
  public void onWarning(int code, String message) {
    WritableMap map = Arguments.createMap();
    map.putInt("code", code);
    map.putString("message", message);
    sendEvent(reactContext, "onWarning", map);
  }

  @Override
  public void onDebugLog(String message) {
    WritableMap map = Arguments.createMap();
    map.putString("message", message);
    sendEvent(reactContext, "onDebugLog", map);
  }

  @Override
  public void onRoomDestroy(String roomId) {
    WritableMap map = Arguments.createMap();
    map.putString("message", roomId);
    sendEvent(reactContext, "onRoomDestroy", map);
  }

  @Override
  public void onRoomInfoChange(TRTCVoiceRoomDef.RoomInfo roomInfo) {
    WritableMap map = Arguments.createMap();
    WritableMap roomMap = Arguments.createMap();
    roomMap.putInt("roomId",roomInfo.roomId);
    roomMap.putString("roomName",roomInfo.roomName);
    roomMap.putString("coverUrl",roomInfo.coverUrl);
    roomMap.putInt("memberCount",roomInfo.memberCount);
    roomMap.putBoolean("needRequest",roomInfo.needRequest);
    map.putMap("roomInfo", roomMap);
    sendEvent(reactContext, "onRoomInfoChange", map);
  }

  @Override
  public void onSeatListChange(List<TRTCVoiceRoomDef.SeatInfo> seatInfoList) {
    WritableMap map = Arguments.createMap();
    map.putArray("seatInfolist", Arguments.fromArray(seatInfoList));
    sendEvent(reactContext, "onSeatInfoChange", map);
  }

  @Override
  public void onAnchorEnterSeat(int index, TRTCVoiceRoomDef.UserInfo user) {
    WritableMap map = Arguments.createMap();
    map.putInt("index", index);
    sendEvent(reactContext, "onAnchorEnterSeat", map);
  }

  @Override
  public void onAnchorLeaveSeat(int index, TRTCVoiceRoomDef.UserInfo user) {
    WritableMap map = Arguments.createMap();
    map.putInt("index", index);
    sendEvent(reactContext, "onAnchorLeaveSeat", map);
  }

  @Override
  public void onSeatMute(int index, boolean isMute) {
    WritableMap map = Arguments.createMap();
    map.putInt("index", index);
    map.putBoolean("isMute", isMute);
    sendEvent(reactContext, "onSeatMute", map);
  }

  @Override
  public void onSeatClose(int index, boolean isClose) {
    WritableMap map = Arguments.createMap();
    map.putInt("index", index);
    map.putBoolean("isClose", isClose);
    sendEvent(reactContext, "onSeatClose", map);
  }

  @Override
  public void onAudienceEnter(TRTCVoiceRoomDef.UserInfo userInfo) {
    WritableMap map = Arguments.createMap();
    WritableMap userMap = Arguments.createMap();
    userMap.putString("userId",userInfo.userId);
    userMap.putString("userAvatar",userInfo.userAvatar);
    userMap.putString("userName",userInfo.userName);
    map.putMap("userInfo", userMap);
    sendEvent(reactContext, "onAudienceEnter", map);
  }

  @Override
  public void onAudienceExit(TRTCVoiceRoomDef.UserInfo userInfo) {
    WritableMap map = Arguments.createMap();
    WritableMap userMap = Arguments.createMap();
    userMap.putString("userId",userInfo.userId);
    userMap.putString("userAvatar",userInfo.userAvatar);
    userMap.putString("userName",userInfo.userName);
    map.putMap("userInfo", userMap);
    sendEvent(reactContext, "onAudienceExit", map);
  }

  @Override
  public void onUserVolumeUpdate(String userId, int volume) {
    WritableMap map = Arguments.createMap();
    map.putString("userId", userId);
    map.putInt("volume", volume);
    sendEvent(reactContext, "onUserVolumeUpdate", map);
  }

  @Override
  public void onRecvRoomTextMsg(String message, TRTCVoiceRoomDef.UserInfo userInfo) {
    WritableMap map = Arguments.createMap();

    WritableMap userMap = Arguments.createMap();
    userMap.putString("userId",userInfo.userId);
    userMap.putString("userAvatar",userInfo.userAvatar);
    userMap.putString("userName",userInfo.userName);

    map.putString("message", message);
    map.putMap("userInfo", userMap);
    sendEvent(reactContext, "onRecvRoomTextMsg", map);
  }

  @Override
  public void onRecvRoomCustomMsg(String cmd, String message, TRTCVoiceRoomDef.UserInfo userInfo) {
    WritableMap map = Arguments.createMap();

    WritableMap userMap = Arguments.createMap();
    userMap.putString("userId",userInfo.userId);
    userMap.putString("userAvatar",userInfo.userAvatar);
    userMap.putString("userName",userInfo.userName);

    map.putString("cmd", cmd);
    map.putString("message", message);
    map.putMap("userInfo", userMap);
    sendEvent(reactContext, "onRecvRoomCustomMsg", map);
  }

  @Override
  public void onReceiveNewInvitation(String id, String inviter, String cmd, String content) {
    WritableMap map = Arguments.createMap();
    map.putString("id", id);
    map.putString("inviter", inviter);
    map.putString("cmd", cmd);
    map.putString("content", content);
    sendEvent(reactContext, "onReceiveNewInvitation", map);
  }

  @Override
  public void onInviteeAccepted(String id, String invitee) {
    WritableMap map = Arguments.createMap();
    map.putString("id", id);
    map.putString("invitee", invitee);
    sendEvent(reactContext, "onInviteeAccepted", map);
  }

  @Override
  public void onInviteeRejected(String id, String invitee) {
    WritableMap map = Arguments.createMap();
    map.putString("id", id);
    map.putString("invitee", invitee);
    sendEvent(reactContext, "onInviteeRejected", map);
  }

  @Override
  public void onInvitationCancelled(String id, String inviter) {
    WritableMap map = Arguments.createMap();
    map.putString("id", id);
    map.putString("inviter", inviter);
    sendEvent(reactContext, "onInvitationCancelled", map);
  }
}
