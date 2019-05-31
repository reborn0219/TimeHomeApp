//
//  GetMyAddress.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 获得我的收货地址
 */
#import <Foundation/Foundation.h>

@interface GetMyAddress : NSObject
@property (nonatomic,copy)NSString *ID;          //收货记录id
@property (nonatomic,copy)NSString *provinceid;  //省id
@property (nonatomic,copy)NSString *provincename;//省名称
@property (nonatomic,copy)NSString *cityid;      //市id
@property (nonatomic,copy)NSString *cityname;    //市区名称
@property (nonatomic,copy)NSString *areaid;      //区域id
@property (nonatomic,copy)NSString *areaname;    //区域名称
@property (nonatomic,copy)NSString *address;     //详细地址
@property (nonatomic,copy)NSString *linkman;     //联系人
@property (nonatomic,copy)NSString *linkphone;   //联系电话
@property (nonatomic,copy)NSString *isdefault;   //是否默认 0 否1 是
@property (nonatomic,copy)NSString *postcode;    //邮编

@end
