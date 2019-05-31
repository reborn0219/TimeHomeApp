//
//  THMyInfoPresenter.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyInfoPresenter.h"
#import "UserInfoModel.h"

@implementation THMyInfoPresenter

/**
 *  获取我的界面信息
 */
+ (void)getMyUserInfoUpDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    NSString * url=[NSString stringWithFormat:@"%@/user/getmyuserinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSLog(@"%@-------",appDelegate.userData.token);
    NSDictionary * param = @{@"token":appDelegate.userData.token};

    NSLog(@"%@",[NSString stringWithFormat:@"-个人信息--%@",appDelegate.userData.token]);
    
//    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
                NSLog(@"dicJson%@",dicJson);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    /**
                     *  保存用户信息
                     */
                    AppDelegate *appDelegate = GetAppDelegates;
                    appDelegate.userData.userID = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"id"]];
                    appDelegate.userData.phone = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"phone"]];
                    appDelegate.userData.userpic = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"userpic"]];
                    appDelegate.userData.nickname = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"nickname"]];
                    appDelegate.userData.name = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"name"]];
                    appDelegate.userData.integral = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"integral"]];
                    appDelegate.userData.level = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"level"]];
                    appDelegate.userData.sex = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"sex"]];
                    
                    //                if ([XYString isBlankString:[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]] || [((NSString *)[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]) isEqualToString:@"1900-01-01"]) {
                    if ([XYString isBlankString:[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]]) {
                        
                        appDelegate.userData.birthday = @"";
                    }else {
                        NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]] withFormat:@"yyyy-MM-dd"];
                        NSString *birth = [XYString NSDateToString:date withFormat:@"yyyy/MM/dd"];
                        appDelegate.userData.birthday = birth;
                    }
                    
                    appDelegate.userData.age = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"age"]];
                    appDelegate.userData.constellation = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"constellation"]];
                    appDelegate.userData.signature = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"signature"]];
                    
                    appDelegate.userData.building = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"building"]];
                    appDelegate.userData.isshowname = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"isshowname"]];
                    appDelegate.userData.isshowbuilding = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"isshowbuilding"]];
                    
                    appDelegate.userData.isowner = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"isowner"]];
                    
                    appDelegate.userData.isvaverified = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"isvaverified"]];
                    
                    appDelegate.userData.url_postadd = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"]objectForKey:@"url_postadd"]];
                    appDelegate.userData.url_posthouse = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_posthouse"]];
                    appDelegate.userData.url_postaddasn = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_postaddasn"]];
                    appDelegate.userData.url_postaddvoto = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_postaddvoto"]];
                    appDelegate.userData.url_gamcommindex = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_gamcommindex"]];
                    appDelegate.userData.url_gamuserindex = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_gamuserindex"]];
                    appDelegate.userData.url_postaddgoods = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_postaddgoods"]];
                    appDelegate.userData.url_postparkingarea =  [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_postparkingarea"]];
                    
                    //                appDelegate.userData.url_postsearchhouse = [XYString IsNotNull:[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"url_postsearchhouse"]]];
                    
                    if (![XYString isBlankString:[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"communityid"]]]) {
                        appDelegate.userData.communityid = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"communityid"]];
                    }
                    
                    if (![XYString isBlankString:[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"communityname"]]]) {
                        appDelegate.userData.communityname = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"communityname"]];
                    }
                    
                    appDelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:YES];
                    
                    [appDelegate saveContext];
                    
                    
                    updataViewBlock(errmsg,SucceedCode);
                    
                });
                
            }
            else//返回操作失败
            {
                AppDelegate *appDelegate = GetAppDelegates;

                appDelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:NO];
                
                [appDelegate saveContext];
                
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            AppDelegate *appDelegate = GetAppDelegates;
            
            appDelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:NO];
            
            [appDelegate saveContext];
            
            updataViewBlock(data,resultCode);
        }
        
    }];

    
}
/**
 *  保存用户信息
 */
+ (void)perfectMyUserInfoDict:(NSDictionary *)dict UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/user/saveuserinfo",SERVER_URL];

    NSMutableDictionary *mutdic = [[NSMutableDictionary alloc]init];
    AppDelegate *appdelegate = GetAppDelegates;
    [mutdic setObject:appdelegate.userData.token forKey:@"token"];
    [mutdic addEntriesFromDictionary:dict];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:mutdic];

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
            NSLog(@"json=saveuserinfo====%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSLog(@"dicJson==%@",dicJson);
                AppDelegate *appdelegate = GetAppDelegates;
                if (![XYString isBlankString:[dict objectForKey:@"constellation"]]) {
                    appdelegate.userData.constellation = [dict objectForKey:@"constellation"];
                }
                if (![XYString isBlankString:[dict objectForKey:@"nickname"]]) {
                    appdelegate.userData.nickname = [dict objectForKey:@"nickname"];
                }
                if (![XYString isBlankString:[dict objectForKey:@"signature"]]) {
                    appdelegate.userData.signature = [dict objectForKey:@"signature"];
                }
                if (![XYString isBlankString:[dict objectForKey:@"building"]]) {
                    appdelegate.userData.building = [dict objectForKey:@"building"];
                }
                if (![XYString isBlankString:[dict objectForKey:@"isshowbuilding"]]) {
                    appdelegate.userData.isshowbuilding = [dict objectForKey:@"isshowbuilding"];
                }
                if (![XYString isBlankString:[dict objectForKey:@"sex"]]) {
                    appdelegate.userData.sex = [dict objectForKey:@"sex"];
                }
                if (![XYString isBlankString:[dict objectForKey:@"name"]]) {
                    appdelegate.userData.name = [dict objectForKey:@"name"];
                }
                if (![XYString isBlankString:[dict objectForKey:@"isshowname"]]) {
                    appdelegate.userData.isshowname = [dict objectForKey:@"isshowname"];
                }

                [appdelegate saveContext];
                
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
 *  获得某个用户信息
 */
+ (void)getOneUserInfoUserID:(NSString *)userid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/user/getoneuserinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    if ([XYString isBlankString:userid]||[XYString isBlankString:appDelegate.userData.token]) {
        return;
    }
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"userid":userid};
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
            NSDictionary * map = [dicJson objectForKey:@"map"];
            
            if(errcode==0)//返回操作成功
            {
                updataViewBlock([UserInfoModel mj_objectWithKeyValues:map],SucceedCode);
                
            }else if(errcode == 90002)
            {
                updataViewBlock(@(errcode),FailureCode);

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
 *  获得用户照片墙
 */
+ (void)getPhotoWallUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/photowall/getphotowall",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
                NSLog(@"%@",dicJson);
                /**
                 *  UserPhotoWall图片模型数组
                 */
                NSArray *picArray = [UserPhotoWall mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                updataViewBlock(picArray,SucceedCode);
                
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,FailureCode);
        }
    }];
}
/**
 *  保存用户照片墙
 */
+ (void)savePhotoWallpicids:(NSString *)picids UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/photowall/savephotowall",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"picids":picids};
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
 * 获得验证是否为业主
 */
+ (void)validationIsTheOwnerUpDataViewblock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/community/iscommpower",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            NSLog(@"%@",dicJson);
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
