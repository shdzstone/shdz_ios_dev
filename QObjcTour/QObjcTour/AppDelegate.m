//
//  AppDelegate.m
//  QObjcTour
//
//  Created by cdzdev on 2017/6/29.
//  Copyright © 2017年 cdz's mac. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self insertCoreData];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (void)dataFetchRequest
{
    NSManagedObjectContext *context = _persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactInfo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        MPLog(@"name:%@", [info valueForKey:@"name"]);
        MPLog(@"age:%@", [info valueForKey:@"age"]);
        MPLog(@"birthday:%@", [info valueForKey:@"birthday"]);
        NSManagedObject *details = [info valueForKey:@"details"];
        MPLog(@"address:%@", [details valueForKey:@"address"]);
        MPLog(@"telephone:%@", [details valueForKey:@"telephone"]);
    }
    fetchRequest = nil;
}

- (void)insertCoreData
{
//    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectContext *context = _persistentContainer.viewContext;

    
    NSManagedObject *contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ContactInfo" inManagedObjectContext:context];
    [contactInfo setValue:@"name B" forKey:@"name"];
    [contactInfo setValue:@"birthday B" forKey:@"birthday"];
    [contactInfo setValue:@"age B" forKey:@"age"];
    
    NSManagedObject *contactDetailInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ContactDetailInfo" inManagedObjectContext:context];
    [contactDetailInfo setValue:@"address B" forKey:@"address"];
    [contactDetailInfo setValue:@"name B" forKey:@"name"];
    [contactDetailInfo setValue:@"telephone B" forKey:@"telephone"];
    
    [contactDetailInfo setValue:contactInfo forKey:@"info"];
    [contactInfo setValue:contactDetailInfo forKey:@"details"];
    
    NSError *error;
    if(![context save:&error]) {
        MPLog(@"不能保存：%@",[error localizedDescription]);
    }
}



- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"QObjcTour"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    MPLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        MPLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
