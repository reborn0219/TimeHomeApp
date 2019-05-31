//
//  ReleaseReservePresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ReleaseReservePresenter.h"
#import "RepairDevTypeModel.h"
@implementation ReleaseReservePresenter

/**
 获得在线报修的设备类型（/reservetype/getreservetype）
 */
-(void)getReserveTypeForupDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reservetype/getreservetype",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             “id”:”12122”
             ,”name”:”梯子”
             ,”remarks”:”描述”
             ,”type”:1
             ,”pricedesc”:”100元一次”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray * arrayJson=[dicJson objectForKey:@"list"];
                NSArray * listDat=[RepairDevTypeModel mj_objectArrayWithKeyValuesArray:arrayJson];
                updataViewBlock(listDat,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];

}

/**
 获得在线报修的公众维修地址（/reserveaddress/getreserveaddress）
 */
-(void)getReserveAddressForupDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reserveaddress/getreserveaddress",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             “id”: ”12122”
             ,”name”:”广场东”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"dicJson===%@",dicJson);

            if(errcode==0)//返回操作成功
            {
                NSArray * arrayJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrayJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}
/**
 添加在线报修（/reserve/addreserve）
 typeid	选择的设备类型id
 phone	手机号
 feedback	反馈的设备维修信息
 picids	上传的照片资源id 拼接字段
 residenceid	住宅id 如果选择的住宅则 地址id传递0
 addressed	地址id 如果选择的公众地址则 住宅id传递0
 reservedate 预约时间
 */
-(void)addReserveForTypeId:(NSString *) typeId phone:(NSString *)phone feedback:(NSString *)feedback picids:(NSString *)picids residenceid:(NSString *)residenceid addressed:(NSString *)addressed andReservedate:(NSString *)reservedate upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reserve/addreserve",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"typeid":typeId,@"phone":phone,@"feedback":feedback,@"picids":picids,@"residenceid":residenceid,@"addressid":addressed,@"reservedate":reservedate};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”map”:{
             “id“: ”123”
             ,”reserveno":”201223232311“
             }
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}
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
-(void)changeToReserveForTypeId:(NSString *) typeId phone:(NSString *)phone feedback:(NSString *)feedback picids:(NSString *)picids residenceid:(NSString *)residenceid addressed:(NSString *)addressed reserveid:(NSString *)reserveid andReservedate:(NSString *)reservedate upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reserve/changetoreserve",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"reserveid":reserveid,@"typeid":typeId,@"phone":phone,@"feedback":feedback,@"picids":picids,@"residenceid":residenceid,@"addressid":addressed,@"reservedate":reservedate};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”map”:{
             “id“: ”123”
             ,”reserveno":”201223232311“
             }
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}
/**
 添加投诉（/complaint/addcomplaint）
 propertyid	投诉的物业id
 content	投诉内容
 picids	上传的照片资源id 拼接字段
 */
-(void)addComplaintForPropertyid:(NSString *)propertyid content:(NSString *)content picids:(NSString *)picids upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/complaint/addcomplaint",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"propertyid":propertyid,@"content":content,@"picids":picids};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”map”:{
             “id“:”123”
             ,”complaintno":”201223232311“
             }
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];

}

@end
