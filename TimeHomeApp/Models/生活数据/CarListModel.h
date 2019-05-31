//
//  CarListModel.h
//  YouLifeApp
//
//  Created by us on 15/10/23.
//  Copyright © 2015年 us. All rights reserved.
//
///车辆定位数据
#import <Foundation/Foundation.h>

@interface CarListModel : NSObject

/**
 “ID”:”OFLJFLSFLJSFJFJ”,
 “UserName”:”shihuang”,
 “Password”:”123456”,
 “IMEI”:”FSLFJLSFJ”,
 “CarName”:”冀A7468”
 
 
 “id”:”1212”
 ,”card”:”冀A1086”
 ,”username”:”fdfdsdf”
 ,”password”:”mima”
 ,”imei”:”dfdfefer2e135321”
 
 
**/
@property(nonatomic,copy) NSString * ID;
@property(nonatomic,copy) NSString * username;
@property(nonatomic,copy) NSString * password;
@property(nonatomic,copy) NSString * imei;
@property(nonatomic,copy) NSString * card;
@property(nonatomic,copy) NSString * addr;//地址
@property(nonatomic) CGFloat cell_H;//高度




-(void)calculateCell_H;

@end
