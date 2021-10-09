//
//  MessageEntity.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import MessageKit

struct MessageEntity: MessageType {
    var messageId: String
    var userId: Int
    var userName: String
    var iconImageUrl: URL?
    var sentDate: Date
    var message: String
    let isMarkAsRead: Bool

    var isMe: Bool {
        userId == 0
    }

    var kind: MessageKind {
        return .attributedText(NSAttributedString(
            string: message,
            attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                         .foregroundColor: isMe
                            ? UIColor.white
                            : UIColor.label]
        ))
    }

    var sender: SenderType {
        return isMe ? MessageSenderType.me : MessageSenderType.other
    }

    var bottomText: String {
        return sentDate.yyyyMMddHHmm + " " + (isMarkAsRead ? "既読" : "未読")
    }

    static func new(my message: String, date: Date, isMarkAsRead: Bool = false) -> MessageEntity {
        return MessageEntity(
            messageId: UUID().uuidString,
            userId: 0,
            userName: "自分",
            iconImageUrl: myIconImageUrl,
            sentDate: date,
            message: message,
            isMarkAsRead: isMarkAsRead)
    }

    static func new(other message: String, date: Date) -> MessageEntity {
        return MessageEntity(
            messageId: UUID().uuidString,
            userId: 1,
            userName: "相手",
            iconImageUrl: otherIconImageUrl,
            sentDate: date,
            message: message,
            isMarkAsRead: true)
    }

    // MARK: MockData
    static var myIconImageUrl: URL = URL(string: "https://fuwamaki-blog-backet.s3-ap-northeast-1.amazonaws.com/uploads/public/system+profile.jpg")!
    static var otherIconImageUrl: URL = URL(string: "https://i.imgur.com/jPy7dt5.png")!

    static var mockMessages: [MessageEntity] {
        return [MessageEntity.new(other: "赤は英語で？", date: Date().oneMonthBefore),
                MessageEntity.new(my: "Red!", date: Date().oneMonthBefore.tomorrow, isMarkAsRead: true),
                MessageEntity.new(other: "青は英語で？", date: Date().yesterday),
                MessageEntity.new(my: "Blue!", date: Date().yesterday.hourAfter(1), isMarkAsRead: true),
                MessageEntity.new(other: "黄色は英語で？", date: Date())]
    }
}
