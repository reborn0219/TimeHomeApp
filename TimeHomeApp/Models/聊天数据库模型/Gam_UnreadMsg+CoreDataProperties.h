//
//  Gam_UnreadMsg+CoreDataProperties.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Gam_UnreadMsg.h"

NS_ASSUME_NONNULL_BEGIN

@interface Gam_UnreadMsg (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *systime;
@property (nullable, nonatomic, retain) NSString *chatID;
@property (nullable, nonatomic, retain) NSNumber *falg;
@property (nullable, nonatomic, retain) NSNumber *msgType;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *sendUserPic;

@end

NS_ASSUME_NONNULL_END
