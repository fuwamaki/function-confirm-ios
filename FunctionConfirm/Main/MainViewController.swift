//
//  MainViewController.swift
//  FunctionConfirm
//
//  Created by 牧宥作 on 2018/06/22.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "動作確認"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// セルを追加する場合の作業1/4: Main.storyboardにセルを追加
extension MainViewController: UITableViewDataSource {

    // セルを追加する場合の作業2/4: Section数を追加
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 28
    }

    // セルを追加する場合の作業3/4: Cellを追加
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GitHubRepositoryListCell", for: indexPath)
            cell.textLabel?.text = "GithubのRepositoryList表示"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QiitaListCell", for: indexPath)
            cell.textLabel?.text = "Qiitaの記事リスト表示"
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath)
            cell.textLabel?.text = "PickerView表示:InterfaceBuilder"
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "codeOnlyPickerCell", for: indexPath)
            cell.textLabel?.text = "PickerView表示:Codeのみ"
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "peekAndPopCell", for: indexPath)
            cell.textLabel?.text = "Peek & Pop 機能"
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mvpCell", for: indexPath)
            cell.textLabel?.text = "MVPアーキテクチャ"
            return cell
        } else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mvvmCell", for: indexPath)
            cell.textLabel?.text = "MVVMアーキテクチャ"
            return cell
        } else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reduxCell", for: indexPath)
            cell.textLabel?.text = "reduxアーキテクチャ"
            return cell
        } else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stackviewCell", for: indexPath)
            cell.textLabel?.text = "StackView練習"
            return cell
        } else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusBarCell", for: indexPath)
            cell.textLabel?.text = "ステータスバーの色:通常"
            return cell
        } else if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusBarInNavigationCell", for: indexPath)
            cell.textLabel?.text = "ステータスバーの色:NavigationBar"
            return cell
        } else if indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusBarInTabBarCell", for: indexPath)
            cell.textLabel?.text = "ステータスバーの色:TabBar"
            return cell
        } else if indexPath.row == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "roundedCornerCell", for: indexPath)
            cell.textLabel?.text = "UIView:角丸"
            return cell
        } else if indexPath.row == 13 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "animationCell", for: indexPath)
            cell.textLabel?.text = "Animation"
            return cell
        } else if indexPath.row == 14 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "awsRekognitionCell", for: indexPath)
            cell.textLabel?.text = "AWS顔認識"
            return cell
        } else if indexPath.row == 15 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "barcodeCell", for: indexPath)
            cell.textLabel?.text = "バーコード"
            return cell
        } else if indexPath.row == 16 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "barcode2Cell", for: indexPath)
            cell.textLabel?.text = "バーコード2"
            return cell
        } else if indexPath.row == 17 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cameraMainFunctionCell", for: indexPath)
            cell.textLabel?.text = "カメラメイン機能"
            return cell
        } else if indexPath.row == 18 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
            cell.textLabel?.text = "タイマー"
            return cell
        } else if indexPath.row == 19 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "transitionCell", for: indexPath)
            cell.textLabel?.text = "Presentで横遷移"
            return cell
        } else if indexPath.row == 20 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "semiModalCell", for: indexPath)
            cell.textLabel?.text = "セミモーダル遷移"
            return cell
        } else if indexPath.row == 21 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "halfModalCell", for: indexPath)
            cell.textLabel?.text = "ハーフモーダル遷移"
            return cell
        } else if indexPath.row == 22 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mediumModalCell", for: indexPath)
            cell.textLabel?.text = "Mediumモーダル遷移"
            return cell
        } else if indexPath.row == 23 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "speechCell", for: indexPath)
            cell.textLabel?.text = "音声認識"
            return cell
        } else if indexPath.row == 24 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)
            cell.textLabel?.text = "アラーム"
            return cell
        } else if indexPath.row == 25 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "keyboardLayoutGuideCell", for: indexPath)
            cell.textLabel?.text = "New KeyboardLayoutGuide"
            return cell
        } else if indexPath.row == 26 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "clearNavCell", for: indexPath)
            cell.textLabel?.text = "透明なNavigationBar"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "horizontalPageCell", for: indexPath)
            cell.textLabel?.text = "横スクロールPaging"
            return cell
        }
    }
}

extension MainViewController: UITableViewDelegate {
    // セルを追加する場合の作業4/4: Selectを追加
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let storyBoard = UIStoryboard(name: "GitHubRepositoryList", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "GitHubRepositoryListViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let storyBoard = UIStoryboard(name: "QiitaList", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "QiitaListViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let storyBoard = UIStoryboard(name: "Picker", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "PickerViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 3:
            let storyBoard = UIStoryboard(name: "CodeOnlyPickerViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "CodeOnlyPickerViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 4:
            let storyBoard = UIStoryboard(name: "ScreenTransition", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "ScreenTransitionViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 5:
            let storyBoard = UIStoryboard(name: "MVP", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "MVPViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 6:
            let storyBoard = UIStoryboard(name: "MVVMViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "MVVMListViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 7:
            let storyBoard = UIStoryboard(name: "ReViewController", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "ReViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 8:
            let storyBoard = UIStoryboard(name: "StackView", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "StackViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 9:
            let storyBoard = UIStoryboard(name: "StatusBar", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "StatusBarViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 10:
            let storyBoard = UIStoryboard(name: "StatusBarInNavigation", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "StatusBarInNavigationViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 11:
            let storyBoard = UIStoryboard(name: "StatusBarInTabBar", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "StatusBarInTabBarViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 12:
            let storyBoard = UIStoryboard(name: "RoundedCorner", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "RoundedCornerViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 13:
            let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationPageViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 14:
            let storyBoard = UIStoryboard(name: "AWSRekognition", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "FaceTrackingHomeViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 15:
            let storyBoard = UIStoryboard(name: "Barcode", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "BarcodeViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 16:
            let storyBoard = UIStoryboard(name: "Barcode2", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "Barcode2ViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 17:
            let storyBoard = UIStoryboard(name: "CameraMainFunction", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "CameraMainFunctionViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 18:
            let storyBoard = UIStoryboard(name: "TimerView", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "TimerViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 19:
            let storyBoard = UIStoryboard(name: "PresentTransitionFromRight", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "PresentTransitionFromRightViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 20:
            let storyBoard = UIStoryboard(name: "SemiModal", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "SemiModalViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 21:
            let storyBoard = UIStoryboard(name: "HalfModalRoot", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "HalfModalRootViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 22:
            let storyBoard = UIStoryboard(name: "Medium", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "MediumRootViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 23:
            let storyBoard = UIStoryboard(name: "Speech", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "SpeechViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 24:
            let storyBoard = UIStoryboard(name: "Alarm", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "AlarmViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 25:
            let storyBoard = UIStoryboard(name: "SampleKeyboardLayoutGuide", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "SampleKeyboardLayoutGuideViewController")
            navigationController?.pushViewController(viewController, animated: true)
        case 26:
            let storyBoard = UIStoryboard(name: "ClearNav", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "ClearNavViewController")
            navigationController?.pushViewController(viewController, animated: true)
        default:
            let storyBoard = UIStoryboard(name: "HorizontalPage", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "HorizontalPageViewController")
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
