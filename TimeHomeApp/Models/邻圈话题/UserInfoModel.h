//
//  UserInfoModel.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property(nonatomic , copy)NSString * userID;
@property(nonatomic , copy)NSString * age;
@property(nonatomic , copy)NSString * birthday;
@property(nonatomic , copy)NSString * building;

@property(nonatomic , copy)NSString * isblack;
@property(nonatomic , copy)NSString * isfllow;
@property(nonatomic , copy)NSString * istomy;
@property(nonatomic , copy)NSString * istoyou;

@property(nonatomic , copy)NSString * isshield;
@property(nonatomic , copy)NSString * lastpostscontent;
@property(nonatomic , copy)NSString * name;
@property(nonatomic , copy)NSString * nickname;
@property(nonatomic , copy)NSString * phone;
@property(nonatomic , copy)NSString * sex;
@property(nonatomic , copy)NSString * signature;
@property(nonatomic , copy)NSString * constellation;

@property(nonatomic , strong)NSArray *piclist;
@property(nonatomic , strong)NSArray *taglist;
@property(nonatomic , strong)NSArray *tags;
@property(nonatomic , assign)CGFloat tagV_H;

@property(nonatomic , copy)NSString * userpic;
@property(nonatomic , copy)NSString * remarkname;
@property(nonatomic , copy)NSString * level;
@end
