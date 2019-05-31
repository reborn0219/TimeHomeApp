//
//  PeaceChinaVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/4/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PeaceChinaVC.h"
#import "WebViewVC.h"

@interface PeaceChinaVC ()
{
    AppDelegate *appDlt;
}
@end

@implementation PeaceChinaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    appDlt = GetAppDelegates;
    
    if (SCREEN_HEIGHT == 812) {
        
        _imgLayout_bottom.constant = -40;
    }else
    {
        _imgLayout_bottom.constant = 0;
    }
    
    _jingwuBtn.layer.cornerRadius = 20;
    _jingwuBtn.layer.borderWidth = 1;
    _jingwuBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    _jingwuBtn.adjustsImageWhenHighlighted = NO;
    
    _dangzhengBtn.layer.cornerRadius = 20;
    _dangzhengBtn.layer.borderWidth = 1;
    _dangzhengBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;

    
    _zhihuiBtn.layer.cornerRadius = 20;
    _zhihuiBtn.layer.borderWidth = 1;
    _zhihuiBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)gotoNextVc:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    [btn setBackgroundColor:[UIColor clearColor]];

    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    webVc.isGetCurrentTitle = YES;
    switch (btn.tag) {
       
        case 1001:
        {
            
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"cmmparty"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"您的社区暂未开通该服务" Duration:5];
                    return;
                }
            }
            
            if([appDlt.userData.partyurl hasSuffix:@".html"])
            {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@",appDlt.userData.partyurl,appDlt.userData.token];
            }
            else
            {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@",appDlt.userData.partyurl,appDlt.userData.token];
            }
            

            webVc.title = @"党建服务";
            [self.navigationController pushViewController:webVc animated:YES];

        }
            break;
        case 1002:
        {
            
            webVc.title = appDlt.userData.communityname;
//            webVc.url = appDlt.userData.firedescurl;
            if([appDlt.userData.firedescurl hasSuffix:@".html"])
            {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@",appDlt.userData.firedescurl,appDlt.userData.token];
            }
            else
            {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@",appDlt.userData.firedescurl,appDlt.userData.token];
            }
            [self.navigationController pushViewController:webVc animated:YES];

        }
            break;
        default:
            break;
    }
}

- (IBAction)touchDownAction:(UIButton *)sender {
    
    [sender setBackgroundColor:[UIColor whiteColor]];
    
}


@end
