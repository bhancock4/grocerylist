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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.1];
    
    UITabBarController* tabBarController = (UITabBarController *)self.window.rootViewController;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunched"])
    {
        self.isFirstLaunch = YES;
        self.window.rootViewController = tabBarController;
        ((UITabBarItem *)tabBarController.tabBar.items[0]).selectedImage = [UIImage imageNamed:@"Calendar"];
        ((UITabBarItem *)tabBarController.tabBar.items[1]).selectedImage = [UIImage imageNamed:@"Recipes"];
        ((UITabBarItem *)tabBarController.tabBar.items[2]).selectedImage = [UIImage imageNamed:@"ShoppingList"];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasBeenMigratedToICloud"];
    }
    else
    {
        self.isFirstLaunch = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"promptForStorage"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        TutorialViewController* tvc = [TutorialViewController new];
        tvc.tabBarController = tabBarController;
        self.window.rootViewController = tvc;
    }
    
    //prompt for storage options...don't ask again with no prior choice defaults to local
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"promptForStorage"] || self.isFirstLaunch)
    {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle: @"Select your storage option"
                              message: @"Do you want to use iCloud to save your data?"
                              delegate: self
                              cancelButtonTitle: @"Don't ask again"
                              otherButtonTitles: @"Use iCloud", @"Local Storage Only", nil];
        [alert show];
    }
    
    self.window.tintColor = [UIColor customAppColor];
    NSDictionary* textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor customAppColor], UITextAttributeTextColor, [UIColor customAppColor], UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    return YES;
}

//pick local or icloud store based on saved user preference
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

//TODO:  add popup asking users to restart app if they choose remote storage
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"promptForStorage"];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"isRemoteStorage"] == nil)
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRemoteStorage"];
            }
            break;
        
        case 1:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRemoteStorage"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"promptForStorage"];
            break;
            
        case 2:
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRemoteStorage"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"promptForStorage"];
            break;
        
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isRemoteStorage"])
    {
        [self migrateExistingDataToICloud];
    }
}

- (void) migrateExistingDataToICloud
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasBeenMigratedToICloud"])
    {
        NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
        //This is the path to the new store. Note it has a different file name
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"CoreData.sqlite"];
    
        //This is the path to the existing store
        NSURL *seedStoreURL = [documentsDirectory URLByAppendingPathComponent:@"GroceryList.sqlite"];
    
        //You should create a new store here instead of using the one you presumably already have access to
        NSPersistentStoreCoordinator *coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
        NSError *seedStoreError;
        NSDictionary *seedStoreOptions = @{ NSReadOnlyPersistentStoreOption: @YES };
        NSPersistentStore *seedStore = [coord addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:seedStoreURL
                                                             options:seedStoreOptions
                                                               error:&seedStoreError];
    
        NSDictionary *iCloudOptions = @{ NSPersistentStoreUbiquitousContentNameKey: @"ReciPlanDataStorage" };
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
        //This is using an operation queue because this happens synchronously
        [queue addOperationWithBlock:^{
            NSError *blockError;
            [coord migratePersistentStore:seedStore
                                    toURL:storeURL
                                  options:iCloudOptions
                                 withType:NSSQLiteStoreType
                                    error:&blockError];
        
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
            // This will be called when the migration is done
            }];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenMigratedToICloud"];
    }
    else
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
        
        [_managedObjectContext reset];
    }
}

//boilerplate
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

//boilerplate
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
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
