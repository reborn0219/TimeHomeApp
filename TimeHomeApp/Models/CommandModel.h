//
//  CommandModel.h
//  TimeHomeApp
//
//  Created by us on 16/1/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 命令类所用参数Model
 **/
@interface CommandModel : NSObject

///命令 soap方法名称
@property(nonatomic,copy) NSString * command;
///命令路径，如url,sql,key
@property(nonatomic,copy) NSString * commandUrl;
///参数列表
@property(nonatomic,copy) NSMutableArray * paramArray;
///post get方式
@property(nonatomic,copy) NSString * HTTPMethod;
///参数字典
/**
 上传文件或图片时参数格式:
 file:文件路径
 fileName:文件名称
 heardKey:上传文件/图片表单对应的Key
 mimeType:上传类型 如image/jpge,text/xml,video/mp4,audio/mpeg
 hearparam:其他参数 字典型式
 **/
@property(nonatomic,copy) NSMutableDictionary *paramDict;
@property (nonatomic, copy) NSString *jsonStr;

@end
