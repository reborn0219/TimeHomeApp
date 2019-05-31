//
//  ReleaseReservePresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///发布维修和投诉 数据上传
#import "BasePresenters.h"

@interface ReleaseReservePresenter : BasePresenters

/**
 获得在线报修的设备类型（/reservetype/getreservetype）
 */
-(void)getReserveTypeForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得在线报修的公众维修地址（/reserveaddress/getreserveaddress）
 */
-(void)getReserveAddressForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 添加在线报修（/reserve/addreserve）
 typeid	选择的设备类型id
 phone	手机号
 feedback	反馈的设备维修信息
 picids	上传的照片资源id 拼接字段
 residenceid	住宅id 如果选择的住宅则 地址id传递0
 addressed	地址id 如果选择的公众地址则 住宅id传递0
 */
-(void)addReserveForTypeId:(NSString *) typeId phone:(NSString *)phone feedback:(NSString *)feedback picids:(NSString *)picids residenceid:(NSString *)residenceid addressed:(NSString *)addressed andReservedate:(NSString *)reservedate upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 驳回后重新填写保修单（/reserve/changetoreserve）
 reserveid	在线报修id
 typeid	选择的设备类型id
 phone	手机号
 feedback	反馈的设备维修信息
 picids	上传的照片资源id 拼接字段
 residenceid	住宅id 如果选择的住宅则 地址id传递0
 addressed	地址id 如果选择的公众地址则 住宅id传递0
 */
-(void)changeToReserveForTypeId:(NSString *) typeId phone:(NSString *)phone feedback:(NSString *)feedback picids:(NSString *)picids residenceid:(NSString *)residenceid addressed:(NSString *)addressed reserveid:(NSString *)reserveid andReservedate:(NSString *)reservedate upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
添加投诉（/complaint/addcomplaint）
 propertyid	投诉的物业id
 content	投诉内容
 picids	上传的照片资源id 拼接字段
 */
-(void)addComplaintForPropertyid:(NSString *)propertyid content:(NSString *)content picids:(NSString *)picids upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
