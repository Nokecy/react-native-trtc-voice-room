package com.reactnativetrtcvoiceroom;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

public class TrtcVoiceRoomModule extends ReactContextBaseJavaModule {
  private static ReactApplicationContext reactContext;

  public TrtcVoiceRoomModule(ReactApplicationContext context) {
    super(context);
    reactContext = context;
  }

  @NonNull
  @Override
  public String getName() {
    return "TrtcVoiceRoom";
  }
}
