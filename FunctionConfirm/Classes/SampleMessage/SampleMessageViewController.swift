//
//  SampleMessageViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import SafariServices
import MessageKit
import InputBarAccessoryView

final class SampleMessageViewController: MessagesViewController {

    private lazy var photoLibraryPicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        return imagePicker
    }()

    private lazy var messageList: [MessageEntity] = {
        return MessageEntity.mockMessages
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        title = messageList
            .filter { !$0.isMe }
            .first?
            .userName
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane")
        messageInputBar.sendButton.tintColor = .gray
        messageInputBar.sendButton.setSize(CGSize(width: 24.0, height: 36.0), animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.inputTextView.font = UIFont.systemFont(ofSize: 14.0)
        messageInputBar.inputTextView.textColor = UIColor.label
        messageInputBar.backgroundView.backgroundColor = UIColor.secondarySystemBackground
        messageInputBar.inputTextView.backgroundColor = UIColor.systemBackground
        messageInputBar.inputTextView.layer.cornerRadius = 10.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        let clipBarButtonItem = InputBarButtonItem()
            .configure {
                $0.image = UIImage(systemName: "paperclip")
                $0.setSize(CGSize(width: 24.0, height: 36.0), animated: false)
                $0.onTouchUpInside { [unowned self] _ in
                    self.present(photoLibraryPicker, animated: true, completion: nil)
                }
            }
        messageInputBar.setStackViewItems([clipBarButtonItem, .flexibleSpace], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36.0, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 36.0, animated: false)

        messagesCollectionView.register(
            MessageHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        messagesCollectionView.backgroundColor = UIColor.secondarySystemBackground
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageOutgoingAvatarPosition(AvatarPosition(vertical: .messageLabelTop))
        layout?.setMessageIncomingAvatarPosition(AvatarPosition(vertical: .messageLabelTop))
    }
}

// MARK: UIImagePickerControllerDelegate
extension SampleMessageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        // TODO
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UINavigationControllerDelegate
extension SampleMessageViewController: UINavigationControllerDelegate {}

// MARK: MessagesDataSource
extension SampleMessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return MessageSenderType.me
    }

    func otherSender() -> SenderType {
        return MessageSenderType.other
    }

    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView
    ) -> Int {
        return messageList.count
    }

    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> MessageType {
        return messageList[indexPath.section]
    }

    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> NSAttributedString? {
        let message = messageList[indexPath.section]
        return NSAttributedString(
            string: message.userName,
            attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                         .foregroundColor: UIColor.systemBlue])
    }

    func messageBottomLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> NSAttributedString? {
        let message = messageList[indexPath.section]
        return NSAttributedString(
            string: message.bottomText,
            attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                         .foregroundColor: UIColor.secondaryLabel])
    }
}

// MARK: MessagesDisplayDelegate
extension SampleMessageViewController: MessagesDisplayDelegate {
    func backgroundColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        return isFromCurrentSender(message: message)
            ? UIColor.systemBlue
            : UIColor.systemBackground
    }

    func messageStyle(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message)
            ? .topRight
            : .topLeft
        return .bubbleTail(corner, .curved)
    }

    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) {
        let message = messageList[indexPath.section]
        avatarView.setImage(url: message.iconImageUrl)
    }

    func messageHeaderView(
        for indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> MessageReusableView {
        let header = messagesCollectionView.dequeueReusableHeaderView(
            MessageHeaderReusableView.self, for: indexPath)
        let message = messageList[indexPath.section]
        header.render(text: message.sentDate.kanjiyyyyMMddE)
        return header
    }

    func detectorAttributes(
        for detector: DetectorType,
        and message: MessageType,
        at indexPath: IndexPath
    ) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .url, .phoneNumber:
            return [.foregroundColor: UIColor.systemBlue]
        default:
            return MessageLabel.defaultAttributes
        }
    }

    func enabledDetectors(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> [DetectorType] {
        return [.url, .phoneNumber]
    }
}

// MARK: MessagesLayoutDelegate
extension SampleMessageViewController: MessagesLayoutDelegate {
    func headerViewSize(
        for section: Int,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGSize {
        let message = messageList[section]
        let firstDate = messageList
            .filter { $0.sentDate.yyyyMMdd == message.sentDate.yyyyMMdd }
            .first
        return message.messageId == firstDate?.messageId
            ? CGSize(width: messagesCollectionView.bounds.width,
                     height: MessageHeaderReusableView.height)
            : CGSize.zero
    }

    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
        return 24
    }

    func messageBottomLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
        return 24
    }
}

// MARK: MessageCellDelegate
extension SampleMessageViewController: MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }

    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }
}

// MARK: InputBarAccessoryViewDelegate
extension SampleMessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(
        _ inputBar: InputBarAccessoryView,
        didPressSendButtonWith text: String
    ) {
        let entity = MessageEntity.new(my: text)
        messageList.append(entity)
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
    }

    func inputBar(
        _ inputBar: InputBarAccessoryView,
        textViewTextDidChangeTo text: String
    ) {
        inputBar.sendButton.image = UIImage(systemName: "paperplane")
        inputBar.sendButton.tintColor = inputBar.sendButton.isEnabled
            ? .systemBlue
            : .gray
    }
}

extension SampleMessageViewController {
    func didSelectURL(_ url: URL) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }

    func didSelectPhoneNumber(_ phoneNumber: String) {
        let url = URL(string: phoneNumber)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
