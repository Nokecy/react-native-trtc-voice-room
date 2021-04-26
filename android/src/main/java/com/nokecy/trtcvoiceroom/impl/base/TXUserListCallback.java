package com.nokecy.trtcvoiceroom.impl.base;

import java.util.List;

public interface TXUserListCallback {
    void onCallback(int code, String msg, List<TXUserInfo> list);
}
