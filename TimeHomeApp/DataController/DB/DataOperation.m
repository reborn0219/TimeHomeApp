//
//  DataOperation.m
//  YouLifeApp
//
//  Created by UIOS on 15/10/13.
//  Copyright © 2015年 us. All rights reserved.
//

#import "DataOperation.h"
#import "AppDelegate.h"
#import "XMMessage.h"

@interface DataOperation()
{
    
}
@property (nonatomic,strong)AppDelegate * appdelegate;
@end

@implementation DataOperation

+ (DataOperation *)sharedDataOperation {
    static DataOperation * sharedDataOperation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataOperation = [[self alloc]init];
        sharedDataOperation.appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    });
    return sharedDataOperation;
}

///获取单条数据模型
-(NSManagedObject *)creatManagedObj:(NSString *)tableName
{
    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.appdelegate.managedObjectContext];
    return newObject;
    
}
-(void)save
{
    [self.appdelegate saveContext];
}
-(void)deleteObj:(NSManagedObject *)obj
{
    [self.appdelegate.managedObjectContext deleteObject:obj];
    [self.appdelegate saveContext];
}
-(NSManagedObject *)queryData:(NSString *)tableName
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    
    NSError *error = nil;
    
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    return [rssTemp firstObject];

}
///查询数据
-(NSArray *)queryData:(NSString *)tableName withRequest:(NSFetchRequest *)request
{
    
//    // 初始化一个查询请求
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
//    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
//     request.sortDescriptors = [NSArray arrayWithObject:sort];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName like %@", @"*Itcast-1*"];
//    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    //    for (ChatRecord *obj in objs) {
    //       NSLog(@"刘帅=%@",obj.userName);
    //    }
    
    return objs;
}

-(NSArray *)queryData:(NSString *)tableName withCurrentPage: (NSInteger)page
{
    
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"systime" ascending:NO];
         request.sortDescriptors = [NSArray arrayWithObject:sort];
        [request setFetchLimit:20];
        [request setFetchOffset:page * 20];
    
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content like %@", @"*邻友*"];
//        request.predicate = predicate;

    
    NSError *error = nil;

    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    return rssTemp;
    
    
}

-(NSArray *)queryData:(NSString *)tableName withCurrentPage: (NSInteger)page withChatID:(NSString *)chatID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"systime" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    [request setFetchBatchSize:500];//从数据库里每次加载500条数据来筛选数据
    [request setFetchLimit:20];
    
    [request setFetchOffset:page * 20];

    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"chatID= %@",chatID];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    request.predicate = predicate;

    NSError *error = nil;
    
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    NSSortDescriptor *sort_1 = [NSSortDescriptor sortDescriptorWithKey:@"systime" ascending:YES];


    return [rssTemp sortedArrayUsingDescriptors:@[sort_1]];

}

///查询未读消息
-(Gam_UnreadMsg *)queryData:(NSString *)tableName withUserID:(NSString *)userID andReceiveID:(NSString *)receiveID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"systime" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"userID= %@",userID];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"chatID= %@",receiveID];

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];

    request.predicate = predicate;
    NSError *error = nil;

    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    return  [rssTemp lastObject];
}
///分组查询未读消息
-(NSFetchedResultsController *)groupQueryData:(NSString *)tableName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
//    [request setFetchBatchSize:20];
    
    NSEntityDescription *chatEntity = [NSEntityDescription entityForName:@"Gam_Chat" inManagedObjectContext:self.appdelegate.managedObjectContext];
    [request setEntity:chatEntity];
    
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"isRead= %@",@(NO)];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1,p2]];
    request.predicate = predicate;

    NSSortDescriptor    *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"chatID" ascending:NO];
    NSSortDescriptor    *sortDescriptorTime = [[NSSortDescriptor alloc] initWithKey:@"systime" ascending:NO];
    NSArray             *sortDescriptors = @[sortDescriptor,sortDescriptorTime
                                             ];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.appdelegate.managedObjectContext sectionNameKeyPath:@"chatID" cacheName:nil];
    
//    aFetchedResultsController.delegate = self;
   // self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // 遍历数据
    for (int i=0;i<aFetchedResultsController.sections.count;i++) {
        NSArray * ary= [[[aFetchedResultsController sections] objectAtIndex:i] objects];
        NSLog(@"sectionName=%@  arycount===%ld",[[aFetchedResultsController sections] objectAtIndex:i].name,(unsigned long)ary.count);
        for(int j=0;j<ary.count;j++)
        {
            Gam_Chat *GUM = [ary objectAtIndex:j];
            NSLog(@"====%@",GUM);
            NSLog(@"sendName=%@    count==%ld   section==%ld sectionidex=%ld row=%ld  userID===%@  sectionName==%@",GUM.sendName,(unsigned long)ary.count,aFetchedResultsController.sections.count,i,j,GUM.chatID,[[aFetchedResultsController sections] objectAtIndex:i].name);
           
        }
    
          
        }
    
    return aFetchedResultsController;
    
}

////查聊天消息列表数据
-(NSArray *) getChatGoupListData
{
    NSMutableArray * goupList=[NSMutableArray new];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Gam_Chat"];
    //    [request setFetchBatchSize:20];
    
    NSEntityDescription *chatEntity = [NSEntityDescription entityForName:@"Gam_Chat" inManagedObjectContext:self.appdelegate.managedObjectContext];
    [request setEntity:chatEntity];
    
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p2]];
    request.predicate = predicate;
    
    NSSortDescriptor    *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"chatID" ascending:NO];
    NSSortDescriptor    *sortDescriptorTime = [[NSSortDescriptor alloc] initWithKey:@"systime" ascending:NO];
    NSArray             *sortDescriptors = @[sortDescriptor,sortDescriptorTime];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.appdelegate.managedObjectContext sectionNameKeyPath:@"chatID" cacheName:nil];
    
    //    aFetchedResultsController.delegate = self;
    // self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    Gam_Chat *GUM;
    // 遍历数据
    for (int i=0;i<aFetchedResultsController.sections.count;i++) {
        NSArray * ary= [[[aFetchedResultsController sections] objectAtIndex:i] objects];
        GUM= [ary objectAtIndex:0];
        [goupList addObject:GUM];
        Gam_Chat * temp_GUM;
        NSInteger countMsg = 0;
        GUM.countMsg = @(0);
        for(int j =0;j<ary.count;j++)
        {
            temp_GUM = [ary objectAtIndex:j];
            if (temp_GUM.isRead.boolValue == NO) {
                countMsg += 1;
            }
        }
        GUM.countMsg = @(countMsg);
        
//        NSArray *arr = [[DataOperation sharedDataOperation]ls_queryData:@"Gam_Chat" withRequest:GUM.chatID];
//        
//        if (arr.count==1) {
//            
//            if (GUM.ownerType.integerValue == XMMessageOwnerTypeSelf) {
//                
//                GUM.countMsg=@([ary count]);
//
//            }else
//            {
//                GUM.countMsg=@([ary count]+1);
//            }
//
//        }else
//        {
//            if (GUM.isFirstMsg.boolValue) {
//                
//                Gam_Chat * firstGUM = [arr firstObject];
//                if (firstGUM.isFirstMsg.boolValue) {
//                    GUM.countMsg=@([ary count]+1);
//
//                }else
//                {
//                    GUM.countMsg=@([ary count]);
//
//                }
//
//            }else
//            {
//                GUM.countMsg=@([ary count]);
//
//            }
//
//        }
//        
        NSLog(@"sendName=121212=%@ systime=%@  sendID=%@",GUM.sendName,GUM.systime,GUM.sendID);
    }

    NSSortDescriptor *sort_1 = [NSSortDescriptor sortDescriptorWithKey:@"systime" ascending:NO];
    NSArray * tmp=[goupList sortedArrayUsingDescriptors:@[sort_1]];
    
    return tmp;

}



///更新未读消息
-(void)queryData:(NSString *)tableName withIsRead:(BOOL)isRead andChatID:(NSString *)chatID andLastObject:(Gam_Chat*)gamChat
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"chatID= %@",chatID];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    request.predicate = predicate;

    NSError *error = nil;
    
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    for (int i =0; i<rssTemp.count; i++) {
        Gam_Chat * GC = [rssTemp objectAtIndex:i];
        GC.isRead = @(YES);
    }
    [self save];
}
///更新当前聊天用户头像信息
-(void)queryData:(NSString *)tableName withHeadPicUrl:(NSString *)headPicUrl andChatID:(NSString *)chatID andnikeName:(NSString *)sendername
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"chatID= %@",chatID];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    for (int i =0; i<rssTemp.count; i++) {
        Gam_Chat * GC = [rssTemp objectAtIndex:i];
        GC.headPicUrl = headPicUrl;
        GC.sendName = sendername;
    }
    [self save];

}
-(void)deleteDataWithChatID:(NSString *)chatID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Gam_Chat"];
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"chatID= %@",chatID];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    request.predicate = predicate;
    NSError *error = nil;
    
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];

    for (int i =0; i<rssTemp.count; i++) {
        Gam_Chat * GC = [rssTemp objectAtIndex:i];
        [self deleteObj:GC];
    }

}
///查询单条数据
-(NSArray *)queryData:(NSString *)tableName withRequest:(NSString*)chatID andSystem:(NSDate *)system
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Gam_Chat"];
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"chatID= %@",chatID];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    NSPredicate * p3 = [NSPredicate predicateWithFormat:@"systime= %@",system];

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2,p3]];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    return rssTemp;
    
}

///查询一条数据
-(NSArray *)ls_queryData:(NSString *)tableName withRequest:(NSString*)chatID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Gam_Chat"];
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"chatID= %@",chatID];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    
    NSSortDescriptor    *sortDescriptorTime = [[NSSortDescriptor alloc] initWithKey:@"systime" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptorTime]];

    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    return rssTemp;
}

-(NSArray *)queryDataFunCircle:(NSString *)tableName withCurrentPage: (NSInteger)page
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"systime" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    [request setFetchBatchSize:500];//从数据库里每次加载500条数据来筛选数据
    [request setFetchLimit:20];
    
    [request setFetchOffset:page * 20];
    
    NSPredicate * p1 = [NSPredicate predicateWithFormat:@"chatID= %@",@""];
    NSPredicate * p2 = [NSPredicate predicateWithFormat:@"userID= %@",_appdelegate.userData.userID];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    request.predicate = predicate;
    NSError *error = nil;
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
    
    
//        });
//    });
//
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
    
    NSArray *rssTemp = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    NSSortDescriptor *sort_1 = [NSSortDescriptor sortDescriptorWithKey:@"systime" ascending:YES];
    
    
    return [rssTemp sortedArrayUsingDescriptors:@[sort_1]];
    
}

#pragma mark - 查询统计数据
///查询统计数据
-(NSArray *)queryDataStatistics:(NSString *)tableName
{

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"endtime" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    [request setFetchBatchSize:200];
    NSError *error = nil;
    NSArray *statisticsArr = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    return statisticsArr;

}

///删除上传后的统计数据
-(void)deleteStatisticsData:(NSArray *)statisticsArr{
    
    for (NSManagedObject * obj in statisticsArr) {
        
        [self.appdelegate.managedObjectContext deleteObject:obj];
    }
    [self.appdelegate saveContext];
    
}
@end
