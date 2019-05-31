//
//  AppDelegate+CoreData.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+CoreData.h"
#import "PACoreDataManager.h"
@implementation AppDelegate (CoreData)

- (NSManagedObjectModel *)managedObjectModel {
    return [[PACoreDataManager shareCoreDataManager] managedObjectModel];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return [[PACoreDataManager shareCoreDataManager] persistentStoreCoordinator];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[PACoreDataManager shareCoreDataManager] managedObjectContext];
}

- (void)saveContext{
    
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.userData];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:USER_INFO_STORAGE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[PACoreDataManager shareCoreDataManager] saveContext];
}

@end
