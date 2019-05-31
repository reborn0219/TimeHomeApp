//
//  NotificationDetailVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NotificationDetailVC.h"
#import "CommunityManagerPresenters.h"
#import "SharePresenter.h"

@interface NotificationDetailVC ()
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *btn_Date;

@property (weak, nonatomic) IBOutlet UILabel *lab_Content;

@end

@implementation NotificationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    self.lab_Content.text=[self.noticData objectForKey:@"content"];
    self.btn_Date.text=[self.noticData objectForKey:@"systime"];
    if([[self.noticData objectForKey:@"isread"] integerValue]==0)
    {
        [CommunityManagerPresenters readNoticeID:[self.noticData objectForKey:@"id"] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(resultCode==SucceedCode)
                {

                }
                else if(resultCode==FailureCode)
                {
//                    NSDictionary *dicJson=(NSDictionary *)data;
//                    NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
//                    NSString * errmsg=[dicJson objectForKey:@"errmsg"];
                }
                else if(resultCode==NONetWorkCode)//无网络处理
                {

                    
                }
                
                
            });

        }];
 
    }
}

///分享事件
- (IBAction)btnRightEvent:(UIBarButtonItem *)sender {
    
    //分享应用
    ShareContentModel * SCML = [[ShareContentModel alloc]init];
    SCML.shareTitle = @"平安社区";
    SCML.shareImg=SHARE_LOGO_IMAGE;
    SCML.shareContext = [NSString stringWithFormat:@"你的朋友在用平安社区App,分享了一个通知! %@",[self.noticData objectForKey:@"gotourl"]];
    SCML.shareUrl= [self.noticData objectForKey:@"gotourl"];
    SCML.type = 1;
    SCML.shareSuperView = self.view;
    SCML.shareType = SSDKContentTypeWebPage;
//    SCML.shareType = SSDKContentTypeAuto;
    [SharePresenter creatShareSDKcontent:SCML];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
