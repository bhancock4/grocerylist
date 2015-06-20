//
//  AppDelegate.m
//  GroceryList
//
//  Created by Benjamin Hancock on 9/26/14.
//  Copyright (c) 2014 Ben Hancock. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//NEED TO UNDERSTAND HOW TO PROMPT WHEN UPDATED TO ASK ABOUT ICLOUD
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.3];
    
    UITabBarController* tabBarController = (UITabBarController *)self.window.rootViewController;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunched"])
    {
        self.window.rootViewController = tabBarController;
        ((UITabBarItem *)tabBarController.tabBar.items[0]).selectedImage = [UIImage imageNamed:@"Calendar"];
        ((UITabBarItem *)tabBarController.tabBar.items[1]).selectedImage = [UIImage imageNamed:@"Recipes"];
        ((UITabBarItem *)tabBarController.tabBar.items[2]).selectedImage = [UIImage imageNamed:@"ShoppingList"];
        
        //prompt for core data enablement
        NSFileManager* fileManager = [NSFileManager defaultManager];
        id currentiCloudToken = fileManager.ubiquityIdentityToken;
        
        if(currentiCloudToken)
        {
            NSData* newTokenData = [NSKeyedArchiver archivedDataWithRootObject:currentiCloudToken];
            [[NSUserDefaults standardUserDefaults] setObject: newTokenData forKey: @"iCloud.com.bhancock4.reciplan"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iCloud.com.bhancock4.reciplan"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(iCloudAccountAvailabilityChanged:) name:NSUbiquityIdentityDidChangeNotification object:nil];
        
        if(currentiCloudToken && true)
        {
            UIAlertView* alert = [[UIAlertView alloc]
                             initWithTitle: @"Select your storage option"
                             message: @"Do you want to use iCloud to save your data?"
                             delegate: self
                             cancelButtonTitle: @"Local Storage Only"
                             otherButtonTitles: @"Use iCloud", nil];
            [alert show];
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        TutorialViewController* tvc = [TutorialViewController new];
        tvc.tabBarController = tabBarController;
        self.window.rootViewController = tvc;
    }
    self.window.tintColor = [UIColor customAppColor];
    NSDictionary* textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor customAppColor], UITextAttributeTextColor, [UIColor customAppColor], UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    // Override point for customization after application launch.
    return YES;
}

//SHOULD WE MIGRATE STORES HERE??????????
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSUserDefaults standardUserDefaults] setBool:buttonIndex == 1 forKey:@"isRemoteStorage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isRemoteStorage"])
    {
        [_managedObjectContext reset];
        
        [_persistentStoreCoordinator migratePersistentStore:[_persistentStoreCoordinator persistentStores][0] toURL:self.storeURL options:nil withType:nil error:nil];
    }
}

// 1
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//SHOULD WE SELECT STORES HERE??????????
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isRemoteStorage"])
    {
        NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"CoreData.sqlite"];
        
        NSError *error = nil;
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary *storeOptions =
        @{NSPersistentStoreUbiquitousContentNameKey: @"ReciPlanDataStorage"};
        NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                             configuration:nil
                                                                                       URL:storeURL
                                                                                   options:storeOptions
                                                                                     error:&error];
        
        self.storeURL = [store URL];
    }
    else
    {
        NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                                   stringByAppendingPathComponent: @"GroceryList.sqlite"]];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                       initWithManagedObjectModel:[self managedObjectModel]];
        
        NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error];
        
        self.storeURL = [store URL];
    }
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
        NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
        
        //return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
