package com.nokecy.trtcvoiceroom.impl.base;


import java.util.List;

public interface TXRoomInfoListCallback {
    void onCallback(int code, String msg, List<TXRoomInfo> list);
}
