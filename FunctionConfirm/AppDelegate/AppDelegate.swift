//
//  AppDelegate.swift
//  FunctionConfirm
//
//  Created by 牧宥作 on 2018/06/22.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit
import CoreData
import AWSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var scrollEdgeAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .yellow
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        return appearance
    }()

    private lazy var standardAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        return appearance
    }()

    private lazy var compactAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .cyan
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        return appearance
    }()

    private lazy var compactScrollEdgeAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        return appearance
    }()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // for AWS FaceRekognition
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USWest2,
            identityPoolId: "us-west-2:bf9f38f9-20a2-4fd2-87c0-2286c0c123a6")
        let configuration = AWSServiceConfiguration(
            region: .USWest2,
            credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

//        UINavigationBar.appearance().standardAppearance = UINavigationBarAppearance()
//        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
//        UINavigationBar.appearance().compactAppearance = UINavigationBarAppearance()
//        if #available(iOS 15.0, *) {
//            UINavigationBar.appearance().compactScrollEdgeAppearance = UINavigationBarAppearance()
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FunctionConfirm")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
