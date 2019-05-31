//
//  Gam_Chat+CoreDataProperties.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Gam_Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Gam_Chat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *sendID;
@property (nullable, nonatomic, retain) NSString *chatID;
@property (nullable, nonatomic, retain) NSString *receiveID;
@property (nullable, nonatomic, retain) NSNumber *msgType;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *flag;
@property (nullable, nonatomic, retain) NSDate *systime;
@property (nullable, nonatomic, retain) NSString *cellIdentifier;
@property (nullable, nonatomic, retain) NSNumber *ownerType;
@property (nullable, nonatomic, retain) NSData *voiceData;
@property (nullable, nonatomic, retain) NSNumber *seconds;

@property (nullable, nonatomic, retain) NSString *headPicUrl;
@property (nullable, nonatomic, retain) NSString *contentPicUrl;
@property (nullable, nonatomic, retain) NSString *voiceUrl;
@property (nullable, nonatomic, retain) NSData *contentPicData;
@property (nullable, nonatomic, retain) NSNumber *isRead;
@property (nullable, nonatomic, retain) NSString *sendName;
@property (nullable, nonatomic, retain) NSNumber *voiceUnRead;

///计数
@property (nullable, nonatomic, retain) NSNumber *countMsg;
///第一次发消息
@property(nonatomic,nullable,retain)NSNumber *isFirstMsg;

@end

NS_ASSUME_NONNULL_END
