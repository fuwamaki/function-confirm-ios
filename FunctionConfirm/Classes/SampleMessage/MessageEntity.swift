//
//  MessageEntity.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import MessageKit

enum MessageKindType {
    case text(message: String)
    case image(mediaItem: MessageMediaEntity)
}

struct MessageEntity: MessageType {
    var userId: Int
    var userName: String
    var iconImageUrl: URL?
    var isMarkAsRead: Bool
    var messageId: String
    var sentDate: Date
    var kindType: MessageKindType

    var kind: MessageKind {
        switch kindType {
        case .text(let message):
            return .attributedText(NSAttributedString(
                string: message,
                attributes: [.font: UIFont.systemFont(ofSize: 14.0),
                             .foregroundColor: isMe ? UIColor.white : UIColor.label]
            ))
        case .image(let mediaItem):
            return .photo(mediaItem)
        }
    }

    var sender: SenderType {
        return isMe ? MessageSenderType.me : MessageSenderType.other
    }

    // MARK: Other
    var isMe: Bool {
        userId == 0
    }

    var bottomText: String {
        return sentDate.yyyyMMddHHmm + " " + (isMarkAsRead ? "既読" : "未読")
    }

    // MARK: static new
    static func new(my message: String,
                    date: Date = Date(),
                    isMarkAsRead: Bool = false) -> MessageEntity {
        return MessageEntity(
            userId: 0,
            userName: "自分",
            iconImageUrl: myIconImageUrl,
            isMarkAsRead: isMarkAsRead,
            messageId: UUID().uuidString,
            sentDate: date,
            kindType: .text(message: message))
    }

    static func new(my media: UIImage,
                    date: Date = Date(),
                    isMarkAsRead: Bool = false) -> MessageEntity {
        return MessageEntity(
            userId: 0,
            userName: "自分",
            iconImageUrl: myIconImageUrl,
            isMarkAsRead: isMarkAsRead,
            messageId: UUID().uuidString,
            sentDate: date,
            kindType: .image(mediaItem: MessageMediaEntity.new(image: media)))
    }

    static func new(other message: String,
                    date: Date = Date()) -> MessageEntity {
        return MessageEntity(
            userId: 1,
            userName: "相手",
            iconImageUrl: otherIconImageUrl,
            isMarkAsRead: true,
            messageId: UUID().uuidString,
            sentDate: date,
            kindType: .text(message: message))
    }

    // MARK: MockData
    static var myIconImageUrl: URL = URL(string: "https://fuwamaki-blog-backet.s3-ap-northeast-1.amazonaws.com/uploads/public/system+profile.jpg")!
    static var otherIconImageUrl: URL = URL(string: "https://i.imgur.com/jPy7dt5.png")!

    static var mockMessages: [MessageEntity] {
        return [MessageEntity.new(other: "黒は英語で？", date: Date().oneMonthBefore.oneMonthBefore.yesterday),
                MessageEntity.new(my: "Black!", date: Date().oneMonthBefore.oneMonthBefore, isMarkAsRead: true),
                MessageEntity.new(other: "白は英語で？", date: Date().oneMonthBefore.beginningOfTheMonth.yesterday),
                MessageEntity.new(my: "White!", date: Date().oneMonthBefore.beginningOfTheMonth, isMarkAsRead: true),
                MessageEntity.new(other: "赤は英語で？", date: Date().oneMonthBefore.yesterday),
                MessageEntity.new(my: "Red!", date: Date().oneMonthBefore, isMarkAsRead: true),
                MessageEntity.new(other: "青は英語で？", date: Date().yesterday),
                MessageEntity.new(my: "Blue!", date: Date().yesterday.hourAfter(1), isMarkAsRead: true),
                MessageEntity.new(other: "黄色は英語で？", date: Date())]
    }
}

struct MessageMediaEntity: MediaItem {
    var url: URL?
    var image: UIImage?

    var placeholderImage: UIImage {
        return UIColor.gray.image!
    }
    var size: CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2,
                      height: UIScreen.main.bounds.width/2)
    }

    // MARK: static new
    static func new(url: URL?) -> MessageMediaEntity {
        MessageMediaEntity(url: url, image: nil)
    }

    static func new(image: UIImage?) -> MessageMediaEntity {
        MessageMediaEntity(url: nil, image: image)
    }
}
