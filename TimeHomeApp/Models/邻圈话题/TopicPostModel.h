//
//  TopicPostModel.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicPostModel : NSObject

///广告位id
@property(nonatomic , copy)NSString * isowner;
@property(nonatomic , copy)NSString * isGG;
@property(nonatomic , copy)NSString * gamadvertiseid;
@property(nonatomic , copy)NSString * picid;
@property(nonatomic , copy)NSString * picurl;
@property(nonatomic , copy)NSString * showtype;
@property(nonatomic , copy)NSString * cityid;
@property(nonatomic , copy)NSString * age;
@property(nonatomic , copy)NSString * commentcount;
@property(nonatomic , copy)NSString * communityname;
@property(nonatomic , copy)NSString * gotourl;
@property(nonatomic , copy)NSString * ispraised;
@property(nonatomic , copy)NSString * nickname;
@property(nonatomic , copy)NSString * postsid;
@property(nonatomic , copy)NSString * praisecount;
@property(nonatomic , copy)NSString * sex;
@property(nonatomic , copy)NSString * systime;
@property(nonatomic , copy)NSString * title;
@property(nonatomic , copy)NSString * webtitle;
@property(nonatomic , copy)NSString * topicid;
@property(nonatomic , copy)NSString * userid;
@property(nonatomic , copy)NSString * userpic;
@property(nonatomic , strong)NSArray * piclist;
@property(nonatomic , strong)NSArray * praiselist;
@property(nonatomic , strong)NSArray * commentlist;
@property(nonatomic , copy)NSString * postsgotourl;
@property(nonatomic , copy)NSString * topicgotourl;
@property(nonatomic ,retain)NSMutableParagraphStyle *paragraphStyle;
@property(nonatomic , assign)CGFloat cellHight;
@property(nonatomic , copy)NSMutableAttributedString *contentAttriStr;
@property(nonatomic , copy)NSString * content;
@property(nonatomic , copy)NSString * content_ls;

@end
