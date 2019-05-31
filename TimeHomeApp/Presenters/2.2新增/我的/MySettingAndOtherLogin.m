//
//  MySettingAndOtherLogin.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MySettingAndOtherLogin.h"

@implementation MySettingAndOtherLogin
/**
 获得我的收货地址  /receipt/getreceipt
 pagesize	分页数 可传递否则默认为20
 page		页码可不传递默认为1
 */
+ (void)getMyAddressWithPagesize:(NSString *)pageSize AndPage:(NSString *)page AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/receipt/getreceipt",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"pagesize":pageSize,@"page":page};
    
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
                //                NSArray * arrJson=[dicJson objectForKey:@"list"];
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
 获得默认收货地址 /receipt/getdefaultreceipt
 */
+ (void)getMyDefaultAddressWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/receipt/getdefaultreceipt",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
}

/**
 删除收货地址信息  /receipt/deletereceipt
 token      是	登陆令牌
 receiptid	否	为空则新增
 */
+ (void)deleteAddressWithReceiptid:(NSString *)receiptid andUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/receipt/deletereceipt",SERVER_URL_New];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"receiptid":receiptid};
    
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
                NSArray * arrJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrJson,SucceedCode);
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
 保存收货地址  /receipt/savereceipt
 
 id         否	为空则新增
 provinceid	否	省id
 cityid	    否	市id
 areaid	    否	区域id
 address	否	详细地址
 linkman	否	联系人
 linkphone	否	联系电话
 isdefault	否	设置默认 0 不默认 1 默认
 */
+ (void)saveMyAddressWithID:(NSString *)ID AndProvinceid:(NSString *)provinceid AndCityid:(NSString *)cityid AndAreaid:(NSString *)areaid AndAddress:(NSString *)address AndLinkMan:(NSString *)linkman AndLinkPhone:(NSString *)linkphone AndIsDefault:(NSString *)isdefault AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/receipt/savereceipt",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"id":ID,@"provinceid":provinceid,
                           @"cityid":cityid,@"areaid":areaid,@"address":address,@"linkman":linkman,
                           @"linkphone":linkphone,@"isdefault":isdefault};
    
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
                NSArray * arrJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrJson,SucceedCode);
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
 获得我的实名认证 /verified/getverified
 */
+ (void)getMyVerifiedWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/verified/getverified",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token ,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
    }];
}


/**
 添加我的实名认证申请 /verified/addverified
 picid	是	上传的照片id
 */
+ (void)addMyVerifiedWithPicId:(NSString *)picID AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/verified/addverified",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"picid":picID};
    
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
                NSArray * arrJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrJson,SucceedCode);
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
 第三方登录 /bindinguser/login
 type       是	第三方类型 1 qq 2 微信 3 微博
 thirdtoken	是	第三方令牌
 thirdid	是	第三方id
 account	是	第三方账户名称
 */
+ (void)otherLoginWithType:(NSString *)type AndThirdToken:(NSString *)thirdtoken andThirdID:(NSString *)thirdID andAccount:(NSString *)account AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bindinguser/login",SERVER_URL_New];
    NSDictionary * param=@{@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"type":type,@"thirdtoken":thirdtoken,@"thirdid":thirdID,@"account":account};
    
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
                AppDelegate *appdelegate = GetAppDelegates;
                appdelegate.userData.token = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"token"]];
                appdelegate.userData.userID = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"id"]];
                appdelegate.userData.phone = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"phone"]];
                appdelegate.userData.nickname = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"nickname"]];
                appdelegate.userData.name = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"name"]];
                appdelegate.userData.sex = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"sex"]];
                
//                if ([XYString isBlankString:[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]] || [((NSString *)[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]) isEqualToString:@"1900-01-01"]) {
                if ([XYString isBlankString:[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]]) {
                    
                    appdelegate.userData.birthday = @"";
                }else {
                    NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"birthday"]] withFormat:@"yyyy-MM-dd"];
                    NSString *birth = [XYString NSDateToString:date withFormat:@"yyyy/MM/dd"];
                    appdelegate.userData.birthday = birth;
                }
                
                appdelegate.userData.signature = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"signature"]];
                
                appdelegate.userData.building = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"building"]];
                appdelegate.userData.communityid = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"communityid"]];
                appdelegate.userData.communityname = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"communityname"]];
                appdelegate.userData.communityaddress = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"communityaddress"]];
                appdelegate.userData.residenceid = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"residenceid"]];
                appdelegate.userData.residencename = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"residencename"]];
                appdelegate.userData.cityid = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"cityid"]];
                appdelegate.userData.cityname = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"cityname"]];
                appdelegate.userData.userpic = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"userpic"]];
                
                appdelegate.userData.countyid=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"countyid"]];
                appdelegate.userData.countyname=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"countyname"]];
                
                appdelegate.userData.mallindexurl=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"mallindexurl"]];
                appdelegate.userData.mallsearchurl=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"mallsearchurl"]];
                
                appdelegate.userData.partyurl=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"partyurl"]];
                
                appdelegate.userData.openmap=[[dicJson objectForKey:@"map"] objectForKey:@"openmap"];
                
                appdelegate.userData.taglist=[dicJson objectForKey:@"taglist"];
                
                
                appdelegate.userData.urlnewslist=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"urlnewslist"]];
                appdelegate.isupgrade=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"isupgrade"]];
                
                appdelegate.userData.homeintrourl=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"homeintrourl"]];
                appdelegate.userData.mallnearurl=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"mallnearurl"]];
                
                appdelegate.userData.carprefix=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"carprefix"]];
                
                appdelegate.userData.lat=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"lat"]];
                appdelegate.userData.lng=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"lng"]];
                
                appdelegate.userData.firedescurl=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"firedescurl"]];

                appdelegate.userData.accPhone=appdelegate.userData.phone;
//                appdelegate.userData.passWord =passWord;
                //                appdelegate.userData.isLogIn=[[NSNumber alloc]initWithBool:YES];
                
                appdelegate.userData.selftag = @"";
                
                appdelegate.userData.policeurl = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"policeurl"]];
                
                appdelegate.userData.url_postadd = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"url_postadd"]];
                appdelegate.userData.url_posthouse = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"url_posthouse"]];
                appdelegate.userData.url_postaddasn = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"url_postaddasn"]];
                appdelegate.userData.url_postaddvoto = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"url_postaddvoto"]];
                appdelegate.userData.url_gamcommindex = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"url_gamcommindex"]];
                appdelegate.userData.url_gamuserindex = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"url_gamuserindex"]];
                appdelegate.userData.url_postaddgoods = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"url_postaddgoods"]];
                
                appdelegate.userData.safehomeurl=[NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"safehomeurl"]];

                
                [appdelegate saveContext];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                [appdelegate setMsgSaveName];

                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                NSArray *arr = @[errmsg,[NSString stringWithFormat:@"%ld",errcode]];
                updataViewBlock(arr,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}

/**
 我的第三方绑定列表  /bindinguser/getbindinglist
 errcode	0 成功；返回未绑定则需要绑定
 type       类型第三方类型 1 qq 2 微信 3 微博
 */

+ (void)getMyOtherBindingWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bindinguser/getbindinglist",SERVER_URL_New];
    
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
//                NSArray * arrJson=[dicJson objectForKey:@"list"];
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
 添加第三方绑定 /bindinguser/addthird
 token      是	用户登录
 type       是	第三方类型 1 qq 2 微信 3 微博
 thirdtoken	是	第三方令牌
 phone      是	用户手机号
 password   是  密码
 thirdid	是	第三方id
 account	是	账户名称
 verificode	是	验证码
 */
+ (void)addOtherBindingWithType:(NSString *)type AndThifdToken:(NSString *)thifdToken AndPhone:(NSString *)phone AndPassword:(NSString *)password andThirdid:(NSString *)thirdID andAccount:(NSString *)account AndVerificode:(NSString *)verificode AndUnionID:(NSString *)unionid AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/bindinguser/addthird",SERVER_URL_New];
    
    NSDictionary * param=@{@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"type":type,@"thirdtoken":thifdToken,@"phone":phone,@"password":password,@"thirdid":thirdID,@"account":account,@"verificode":verificode,@"unionid":unionid};
    
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
                if ([dicJson objectForKey:@"map"] != nil && ![[dicJson objectForKey:@"map"] isKindOfClass:[NSNull class]]) {
                    AppDelegate *appdelegate = GetAppDelegates;
                    appdelegate.userData.token = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"token"]];
                    [appdelegate saveContext];
                }
                
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
 删除第三方登录 /bindinguser/deletethird
 token      是	登陆令牌
 thirdtoken	是	第三方令牌
 type       是	第三方类型 1 qq 2 微信 3 微博
 thirdid	是	第三方id
 account	是	账户名称
 */
+ (void)deleteThirdLoginWithThirdToken:(NSString *)thirdToken AndType:(NSString *)type andThirdid:(NSString *)thirdid andAccount:(NSString *)account AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/bindinguser/deletethird",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"thirdtoken":thirdToken,@"type":type,@"thirdid":thirdid,@"account":account};
    
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
                NSArray * arrJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrJson,SucceedCode);
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
 添加用户反馈 /feedback/addfeedback
 type       是	1001 无法登陆 1002 收不到短信 1003 遇到其他问题 9999用户反馈
 content	是	描述
 picid      否	截图或其他照片
 linkinfo	是	联系电话或者qq
 phonemodel	是	机型
 */
+ (void)addMyFeedBackWithType:(NSString *)type andContent:(NSString *)content andPicID:(NSString *)picid andLinkinfo:(NSString *)linkInfo andPhonemodel:(NSString *)phonemodel andTitle:(NSString *)title andUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/feedback/addfeedback",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"type":type,@"content":content,
                           @"picid":picid,@"linkinfo":linkInfo,@"phonemodel":phonemodel,@"title":title};
    
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
                NSArray * arrJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrJson,SucceedCode);
            }else//返回操作失败
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
 获得省市县区域
 /sysarea/getarealist
 */
+ (void)GetAreaListWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/sysarea/getarealist",SERVER_URL_New];
    
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
//                NSArray * arrJson=[dicJson objectForKey:@"list"];
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
 判断有无房产或车位
 /housepost/judgeHouseArea
 */
+ (void)judgeHouseAreaWithType:(NSString *)type andUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/housepost/judgehousearea",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"type":type};
    
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
                //NSArray * arrJson=[dicJson objectForKey:@"list"];
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

+ (void)addNewOtherBindingWithType:(NSString *)type AndThifdToken:(NSString *)thifdToken AndPhone:(NSString *)phone AndPassword:(NSString *)password andThirdid:(NSString *)thirdID andAccount:(NSString *)account AndVerificode:(NSString *)verificode AndUnionID:(NSString *)unionid AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/bindinguser/newaddthird",SERVER_URL_New];
    
    NSDictionary * param=@{@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"type":type,@"thirdtoken":thifdToken,@"phone":phone,@"password":password,@"thirdid":thirdID,@"account":account,@"verificode":verificode,@"unionid":unionid};
    
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
                if ([dicJson objectForKey:@"map"] != nil && ![[dicJson objectForKey:@"map"] isKindOfClass:[NSNull class]]) {
                    AppDelegate *appdelegate = GetAppDelegates;
                    appdelegate.userData.token = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"token"]];
                    [appdelegate saveContext];
                }
                
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

@end
