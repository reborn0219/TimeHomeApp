//
//  AppSystemSetPresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppSystemSetPresenters.h"
#import "ImageUitls.h"

#import "CityCommunityModel.h"

#import "TopicImgListModel.h"

#import "PANoticeManager.h"
#import "AppDelegate+JPush.h"
//#import "AFNetworking.h"

@implementation AppSystemSetPresenters

/**
 获得系统中的区域
 */
+(void)getCityAreasUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/sysarea/getcityarea",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson=[dicJson objectForKey:@"list"];
                NSLog(@"%@",arrJson);
                NSArray *cityListData=[CityCommunityModel mj_objectArrayWithKeyValuesArray:arrJson];
                updataViewBlock(cityListData,SucceedCode);
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
 通过城市名称获得城市id
 */
+(void)getCityIDName:(NSString *)name UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/sysarea/getcityid",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"name":name};
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSString * ID = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"id"]];
                updataViewBlock(ID,SucceedCode);
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
 获得系统资源中的图片接口
 */
+(void)getSysPicType:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/resources/getsyspic",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"type":type};
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                if (type.integerValue == 1) {
                    NSArray * arr = [TopicImgListModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                    updataViewBlock(arr,SucceedCode);
                    
                }else{
                
                    updataViewBlock(dicJson,SucceedCode);
                }
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
 图片上传接口
 */
+(void)upLoadPicFile:(id)objc withUsedtype:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    AppDelegate *appdelegate = GetAppDelegates;
    
    NSString * url=[NSString stringWithFormat:@"%@/resources/uploadpic?token=%@&usedtype=%@&softtype=1",SERVER_PIC_URL,appdelegate.userData.token,type];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    /**
     定制图片名字，防止重复
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
    /**
     *  判断为URLString还是image
     */
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"file":objc,@"heardKey":@"file",@"mimeType":@"application/octet-stream",@"fileName":fileName};
    command.paramDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetUpLoadFileCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSLog(@"%@",dicJson);
                NSString *picID = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"id"]];
                updataViewBlock(picID,SucceedCode);
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

/*
 //带有监测上传进度（lsb_测试，勿用）
+ (void)upLoadPicImage:(id)objc UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    AppDelegate *appdelegate = GetAppDelegates;
    NSString * url=[NSString stringWithFormat:@"%@/resources/uploadpic?token=%@&softtype=1",SERVER_PIC_URL,appdelegate.userData.token];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(objc,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"uploadProgress = %@",uploadProgress);

    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        NSLog(@"responseObject===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"error===%@",error);

    }];
}
*/

/**
 图片上传接口
 */
+(void)upLoadPicFile:(id)objc UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {

    AppDelegate *appdelegate = GetAppDelegates;
    NSString * url=[NSString stringWithFormat:@"%@/resources/uploadpic?token=%@&softtype=1",SERVER_PIC_URL,appdelegate.userData.token];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    /**
     定制图片名字，防止重复
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
    /**
     *  判断为URLString还是image
     */
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"file":objc,@"heardKey":@"file",@"mimeType":@"application/octet-stream",@"fileName":fileName};
    command.paramDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetUpLoadFileCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
              
                NSLog(@"%@",dicJson);
                updataViewBlock(dicJson,SucceedCode);
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
 语音上传接口
 */
+(void)upLoadVoiceFile:(id)file UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    AppDelegate *appdelegate = GetAppDelegates;

    NSString * url=[NSString stringWithFormat:@"%@/resources/uploadvoice?token=%@&softtype=1",SERVER_PIC_URL,appdelegate.userData.token];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    
    /**
     file名字，防止重复
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.aac",str];
    
    NSDictionary *dict = @{@"file":file,@"heardKey":@"file",@"mimeType":@"video/mp4",@"fileName":fileName};
    command.paramDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetUpLoadFileCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock([dicJson objectForKey:@"id"],SucceedCode);
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
 获得首页弹窗接口
 */

+(void)getAlertUpDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    NSString * url=[NSString stringWithFormat:@"%@/indexform/getindexform",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSDictionary * dictJson=[dicJson objectForKey:@"map"];
                updataViewBlock(dictJson,SucceedCode);
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
 获得首页轮播图接口
 */
+(void)getBannerUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/banner/getbanner",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"轮播图json=%@",dicJson);
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
 保存系统错误日志
 */
+(void)addErrorLogTitle:(NSString *)title content:(NSString *)content UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/errorlog/adderrorlog",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"sourcetype":@"2",@"title":title,@"content":content};
    
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
            //“errcode”:0
            //,”errmsg”:””
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
 保存用户反馈
 */
+(void)addFeedBackContent:(NSString *)content UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    if ([XYString isBlankString:content]) {
        updataViewBlock(@"输入的内容不能为空",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/feedback/addfeedback",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"content":content};
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(@"提交成功",SucceedCode);
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
///获得需要绑定的标签（/system/getbindingtag）
+(void)getBindingTag
{
    [[self class]saveNoticeDeviceInfo];

    NSString * url=[NSString stringWithFormat:@"%@/system/getbindingtag",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            //"您的网络太慢或无网络,请检查网络设置!"
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
//            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
//            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * taglist = [dicJson objectForKey:@"taglist"];
            NSMutableArray * tags = [[NSMutableArray alloc]init];
            for (int i = 0; i<taglist.count; i++) {
                [tags addObject:[[taglist objectAtIndex:i] objectForKey:@"id"]];
            }
            ///绑定标签
            [appDelegate setTags:tags error:nil];
        }else if(resultCode==FailureCode)//返回数据失败
        {
            
        }
        
    }];
    
    
    
}

/**
 *  分享统计
 *  新增sourceid 来源id
 *  @param type            0 app下载 1 社区公告 2 社区新闻 3 访客通行 4 帖子 5 活动 6 关于我们
 *  @param totype          1 微信好友 2 微信朋友圈 3 qq好友 4 qq空间
 *  @param gotourl         分享地址
 */
+ (void)sharedDoforwardType:(NSString *)type totype:(NSString *)totype gotourl:(NSString *)gotourl sourceid:(NSString *)sourceid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    if ([XYString isBlankString:totype]) {
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/forwarding/doforward",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"type":type,@"totype":totype,@"gotourl":gotourl,@"sourceid":sourceid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict = [[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
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
 *  获取服务器当前时间
 */
+ (void)getSystemTimeUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    
    NSString * url=[NSString stringWithFormat:@"%@/system/getsystime",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict = [[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock([dicJson objectForKey:@"systime"],SucceedCode);
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
 2.3版本增加 是否需要强制更新App

 @param version App传入的版本号 返回参数为errcode ,errmsg,updstate, updstate 1为强制更新，2为普通更新，3为不更新，errcode统一返回0
 @param updataViewBlock
 */
+ (void)isVersionUpdWithVersion:(NSString *)version UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/user/isversionupd",SERVER_URL];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
    NSDictionary * param = @{@"version": version,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict = [[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
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

#pragma mark - 获得当前登录社区是否开通车牌纠错设置（/carcorrection/iscorrectionset）

/**
 获得当前登录社区是否开通车牌纠错设置（/carcorrection/iscorrectionset）
 
 @param updataViewBlock
 */
+ (void)getCarCorrectionSetWithPlatform:(NSString *)platform UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/carcorrection/iscorrectionset",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"platform":platform};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict = [[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
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
 保存推送需要的设备信息
 */
+ (void)saveNoticeDeviceInfo{
    [PANoticeManager saveDeviceInfo];
}


@end
