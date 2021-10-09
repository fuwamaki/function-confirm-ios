//
//  MessageSenderType.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import MessageKit

// 操作しにくくなるので、自分か自分じゃないかの判別のみに利用。senderIdとdisplayNameは不使用。
struct MessageSenderType: SenderType {
    var senderId: String
    var displayName: String

    static var me: MessageSenderType {
        return MessageSenderType(senderId: "0",
                              displayName: "me")
    }

    static var other: MessageSenderType {
        return MessageSenderType(senderId: "1",
                              displayName: "other")
    }
}
