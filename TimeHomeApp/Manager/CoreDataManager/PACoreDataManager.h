//
//  PACoreDataManager.h
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface PACoreDataManager : NSObject
///数据管理器（临时数据库）
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
///数据模型器
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
///数据连接器
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
///数据持久化保存操作
- (void)saveContext;
///获取真实文件的存储路径
- (NSURL *)applicationDocumentsDirectory;
//单例
+ (instancetype)shareCoreDataManager;
@end
