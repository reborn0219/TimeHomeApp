//
//  ChatRecord.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ChatRecord : NSManagedObject

@property (nullable, nonatomic, retain) NSString *userNike;
@property (nullable, nonatomic, retain) NSString *userName;
@end
