//
//  SampleMessage2ViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/14.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import SafariServices
import MessageKit
import InputBarAccessoryView
import ImageViewer

final class SampleMessage2ViewController: MessagesViewController {

    private lazy var photoLibraryPicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        return imagePicker
    }()

    private var messageList: [MessageEntity] = []
    private var displaceableImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupMessageInputBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }

    private func setupViews() {
        DispatchQueue.main.async {
            self.messageList = MessageEntity.mockMessages
            self.title = self.messageList
                .filter { !$0.isMe }
                .first?
                .userName
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: false)
        }
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.register(
            MessageHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        messagesCollectionView.backgroundColor = UIColor.secondarySystemBackground
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageOutgoingAvatarPosition(AvatarPosition(vertical: .messageLabelTop))
        layout?.setMessageIncomingAvatarPosition(AvatarPosition(vertical: .messageLabelTop))
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.showKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }

    private func setupMessageInputBar() {
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
    }
}

// MARK: UIImagePickerControllerDelegate
extension SampleMessage2ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        let entity = MessageEntity.new(my: image)
        messageList.append(entity)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UINavigationControllerDelegate
extension SampleMessage2ViewController: UINavigationControllerDelegate {}

// MARK: MessagesDataSource
extension SampleMessage2ViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return MessageSenderType.me
    }

    func otherSender() -> SenderType {
        return MessageSenderType.other
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
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
extension SampleMessage2ViewController: MessagesDisplayDelegate {
    func backgroundColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        switch message.kind {
        case .photo:
            return UIColor.systemBackground
        default:
            return isFromCurrentSender(message: message)
                ? UIColor.systemBlue
                : UIColor.systemBackground
        }
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
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapMessageHeaderView(_:)))
        header.addGestureRecognizer(tapGesture)
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
        case .url:
            return [.foregroundColor: UIColor.systemYellow]
        default:
            return MessageLabel.defaultAttributes
        }
    }

    func enabledDetectors(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> [DetectorType] {
        return [.url]
    }
}

// MARK: MessagesLayoutDelegate
extension SampleMessage2ViewController: MessagesLayoutDelegate {
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
        return CGFloat.zero
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
extension SampleMessage2ViewController: MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        messageInputBar.inputTextView.resignFirstResponder()
    }

    func didTapImage(in cell: MessageCollectionViewCell) {
        if let containerView = cell.contentView.subviews
            .filter({ $0 is MessageContainerView })
            .first as? MessageContainerView,
           let imageView = containerView.subviews
            .filter({ $0 is UIImageView })
            .first as? UIImageView {
            displaceableImageView = imageView
            let viewController = GalleryViewController(
                startIndex: 0,
                itemsDataSource: self,
                displacedViewsDataSource: self)
            presentImageGallery(viewController)
        }
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

// MARK: UITapGestureRecognizer
extension SampleMessage2ViewController {
    @objc private func didTapMessageHeaderView(_ sender: UITapGestureRecognizer) {
        messageInputBar.inputTextView.resignFirstResponder()
    }
}

// MARK: GalleryItemsDataSource
extension SampleMessage2ViewController: GalleryItemsDataSource {
    func itemCount() -> Int {
        return 1
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.displaceableImageView?.image!) }
    }
}

// MARK: GalleryDisplacedViewsDataSource
extension SampleMessage2ViewController: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return displaceableImageView
    }
}

// MARK: MessageLabelDelegate(MessageCellDelegate)
extension SampleMessage2ViewController {
    func didSelectURL(_ url: URL) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }

    func didSelectPhoneNumber(_ phoneNumber: String) {
        let url = URL(string: phoneNumber)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: InputBarAccessoryViewDelegate
extension SampleMessage2ViewController: InputBarAccessoryViewDelegate {
    func inputBar(
        _ inputBar: InputBarAccessoryView,
        didPressSendButtonWith text: String
    ) {
        let entity = MessageEntity.new(my: text)
        messageList.append(entity)
        messageInputBar.inputTextView.text = String()
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

// MARK: Keyboard
extension SampleMessage2ViewController {
    @objc private func showKeyboard(_ notification: Foundation.Notification) {
        if (messagesCollectionView.contentSize.height
                - messagesCollectionView.frame.height)
            < messagesCollectionView.contentOffset.y {
            messagesCollectionView.scrollToLastItem(at: .bottom, animated: false)
        }
    }
}
