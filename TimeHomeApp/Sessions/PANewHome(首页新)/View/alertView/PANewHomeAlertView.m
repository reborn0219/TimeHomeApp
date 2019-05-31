//
//  PANewHomeAlertView.m
//  TimeHomeApp
//
//  Created by ning on 2018/7/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeAlertView.h"
#import "THCommitSuggestionsViewController.h"
#import "NetWorks.h"
#import "WebViewVC.h"
#define UNIT_LENTH self.frame.size.width / 640

@interface PANewHomeAlertView()
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UIView *alertView1;
@property (nonatomic,strong) UILabel *textLal;
@property (nonatomic,strong) UIView *alertView2;
@property (nonatomic,strong) UIButton *joinBt;
@property (nonatomic,strong) UIImageView *urlImg;
@property (nonatomic,copy) NSString *goToUrl;
@end

@implementation PANewHomeAlertView

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - initUI
- (void)initUI{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.userInteractionEnabled = YES;
    self.hidden = YES;

    self.alertView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, UNIT_LENTH * 475)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.alpha = 1.0;
    self.alertView.center = CGPointMake(self.alertView.center.x, self.frame.size.height / 2);
    self.alertView.hidden = YES;
    [self addSubview:self.alertView];
    
    UIButton *closeAlert = [[UIButton alloc]initWithFrame:CGRectMake(self.alertView.frame.size.width - 5 - UNIT_LENTH * 50, 5, UNIT_LENTH * 50, UNIT_LENTH * 50)];
    closeAlert.backgroundColor = [UIColor clearColor];
    [closeAlert setImage: [UIImage imageNamed:@"我的_设置_车位权限_关闭弹窗"] forState:UIControlStateNormal];
    
    [closeAlert addTarget:self action:@selector(tapClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:closeAlert];
    
    UIButton *lastTime = [[UIButton alloc]initWithFrame:CGRectMake(UNIT_LENTH * 50, self.alertView.frame.size.height - UNIT_LENTH * 90, self.alertView.frame.size.width - UNIT_LENTH * 50 * 2, UNIT_LENTH * 50)];
    lastTime.backgroundColor = RGBACOLOR(142, 143, 144, 1);
    [lastTime setTitle:@"以后再说" forState:UIControlStateNormal];
    [lastTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lastTime.titleLabel.font = [UIFont systemFontOfSize:15];
    [lastTime addTarget:self action:@selector(lastTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:lastTime];
    
    UIButton *opinion = [[UIButton alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x, self.alertView.frame.size.height - UNIT_LENTH * 190, lastTime.frame.size.width, lastTime.frame.size.height)];
    opinion.backgroundColor = RGBACOLOR(142, 143, 144, 1);
    [opinion setTitle:@"去提意见" forState:UIControlStateNormal];
    [opinion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    opinion.titleLabel.font = [UIFont systemFontOfSize:15];
    [opinion addTarget:self action:@selector(opinion:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:opinion];
    
    UIButton *goToAppStore = [[UIButton alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x, self.alertView.frame.size.height - UNIT_LENTH * 290, lastTime.frame.size.width, lastTime.frame.size.height)];
    goToAppStore.backgroundColor = RGBACOLOR(159, 30, 31, 1);
    [goToAppStore setTitle:@"马上好评" forState:UIControlStateNormal];
    [goToAppStore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goToAppStore.titleLabel.font = [UIFont systemFontOfSize:15];
    [goToAppStore addTarget:self action:@selector(goToAppStore:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:goToAppStore];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, (lastTime.frame.origin.y + opinion.frame.origin.y + opinion.frame.size.height) / 2, lastTime.frame.size.width + 10, 1)];
    line1.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [self.alertView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, (opinion.frame.origin.y + goToAppStore.frame.origin.y + goToAppStore.frame.size.height) / 2, lastTime.frame.size.width + 10, 1)];
    line2.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [self.alertView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, goToAppStore.frame.origin.y - UNIT_LENTH * 35, lastTime.frame.size.width + 10, 1)];
    line3.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [self.alertView addSubview:line3];
    
    UILabel *alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, closeAlert.frame.origin.y + closeAlert.frame.size.height, self.alertView.frame.size.width, UNIT_LENTH * 70)];
    alertTitle.textColor = [UIColor blackColor];
    alertTitle.textAlignment = NSTextAlignmentCenter;
    alertTitle.text = @"您对平安社区满意吗？";
    alertTitle.font = [UIFont systemFontOfSize:17];
    
    [self.alertView addSubview:alertTitle];
    
    self.alertView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, UNIT_LENTH * 475)];
    self.alertView1.backgroundColor = [UIColor whiteColor];
    self.alertView1.alpha = 1.0;
    self.alertView1.center = CGPointMake(self.alertView.center.x, self.frame.size.height / 2);
    
    self.alertView1.hidden = YES;
    
    [self addSubview:self.alertView1];
    
    UIButton *closeAlert1 = [[UIButton alloc]initWithFrame:CGRectMake(self.alertView.frame.size.width - 5 - UNIT_LENTH * 50, 5, UNIT_LENTH * 50, UNIT_LENTH * 50)];
    closeAlert1.tintColor = [UIColor redColor];
    [closeAlert1 setImage: [UIImage imageNamed:@"我的_设置_车位权限_关闭弹窗"] forState:UIControlStateNormal];
    
    [closeAlert1 addTarget:self action:@selector(tapClose:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView1 addSubview:closeAlert1];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, closeAlert1.frame.origin.y + closeAlert1.frame.size.height + UNIT_LENTH * 30, lastTime.frame.size.width + 10, 1)];
    line4.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [self.alertView1 addSubview:line4];
    
    self.textLal = [[UILabel alloc]initWithFrame:CGRectMake(line4.frame.origin.x, line4.frame.origin.y + line4.frame.size.height + 10, line4.frame.size.width, self.alertView1.frame.size.height - line4.frame.origin.y - line4.frame.size.height + 20)];
    self.textLal.textColor = [UIColor blackColor];
    self.textLal.textAlignment = NSTextAlignmentLeft;
    self.textLal.font = [UIFont systemFontOfSize:13];
    
    [self.alertView1 addSubview:self.textLal];
    
    self.alertView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, UNIT_LENTH * 475)];
    self.alertView2.backgroundColor = [UIColor whiteColor];
    self.alertView2.alpha = 1.0;
    self.alertView2.center = CGPointMake(self.alertView.center.x, self.frame.size.height / 2);
    
    self.alertView2.hidden = YES;
    
    [self addSubview:self.alertView2];
    
    UIButton *closeAlert2 = [[UIButton alloc]initWithFrame:CGRectMake(self.alertView.frame.size.width - 5 - UNIT_LENTH * 50, 5, UNIT_LENTH * 50, UNIT_LENTH * 50)];
    closeAlert2.tintColor = [UIColor redColor];
    [closeAlert2 setImage: [UIImage imageNamed:@"我的_设置_车位权限_关闭弹窗"] forState:UIControlStateNormal];
    
    [closeAlert2 addTarget:self action:@selector(tapClose:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView2 addSubview:closeAlert2];
    
    UIButton *laterBt = [[UIButton alloc]initWithFrame:CGRectMake(UNIT_LENTH * 20, self.alertView.frame.size.height - UNIT_LENTH * 90, (self.alertView.frame.size.width - UNIT_LENTH * 20 * 4) / 2 , UNIT_LENTH * 50)];
    laterBt.backgroundColor = RGBACOLOR(142, 143, 144, 1);
    [laterBt setTitle:@"以后再说" forState:UIControlStateNormal];
    [laterBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    laterBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [laterBt addTarget:self action:@selector(lastTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView2 addSubview:laterBt];
    
    self.joinBt = [[UIButton alloc]initWithFrame:CGRectMake(laterBt.frame.origin.x + laterBt.frame.size.width + 2 * UNIT_LENTH * 20, laterBt.frame.origin.y, laterBt.frame.size.width , laterBt.frame.size.height)];
    self.joinBt.backgroundColor = UIColorFromRGB(0x9f1e1f);
    [self.joinBt setTitle:@"马上参加" forState:UIControlStateNormal];
    [self.joinBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.joinBt.titleLabel.font = [UIFont systemFontOfSize:15];
    self.joinBt.userInteractionEnabled = NO;
    [self.joinBt addTarget:self action:@selector(joinBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView2 addSubview:self.joinBt];
    
    self.urlImg = [[UIImageView alloc]initWithFrame:CGRectMake(laterBt.frame.origin.x, closeAlert2.frame.origin.y + closeAlert2.frame.size.height + UNIT_LENTH * 30, self.alertView2.frame.size.width - 2 * UNIT_LENTH * 20, self.joinBt.frame.origin.y - closeAlert2.frame.origin.y - closeAlert2.frame.size.height - UNIT_LENTH * 60)];
    self.urlImg.backgroundColor = [UIColor clearColor];
    
    [self.alertView2 addSubview:self.urlImg];
}

#pragma mark - UpdateUI
- (void)refreshUIWithAlertDict:(NSDictionary *)alertDict{
    NSDictionary *map = alertDict;
    NSString *type = [NSString stringWithFormat:@"%@",map[@"type"]];
    if ([type isEqualToString:@"0"]){
        self.hidden = NO;
        self.alertView.hidden = NO;
    }else if ([type isEqualToString:@"1"]){
        self.hidden = NO;
        self.alertView1.hidden = NO;
        self.textLal.text = [NSString stringWithFormat:@"%@",map[@"content"]];
        [self.textLal setNumberOfLines:0];
        [self.textLal sizeToFit];
        [self.alertView1 addSubview:self.textLal];
    }else if ([type isEqualToString:@"2"]){
        self.hidden = NO;
        self.alertView2.hidden = NO;
        NSString *picUrl = [NSString stringWithFormat:@"%@",map[@"picurl"]];
        NSURL *url = [NSURL URLWithString:picUrl];
        [self.urlImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
        self.goToUrl = [NSString stringWithFormat:@"%@",map[@"gotourl"]];
        self.joinBt.userInteractionEnabled = YES;
    }else{
        ///设置弹出没有弹出的情况 需要将积分弹框弹出
    }
}

#pragma mark - Actions
//弹窗点击关闭按钮
-(void)tapClose:(id)sender{
    self.hidden = YES;
}

//弹窗点击以后再说按钮
-(void)lastTime:(id)sender{
    self.hidden = YES;
}

//弹窗点击去提意见按钮
-(void)opinion:(id)sender{
    self.hidden = YES;
    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            THCommitSuggestionsViewController *commitVC = [[THCommitSuggestionsViewController alloc]init];
            if (self.callback) {
                self.callback(commitVC);
            }
        }];
    }];
}

//弹窗点击马上好评
-(void)goToAppStore:(id)sender{
    self.hidden = YES;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:APP_URL]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [NetWorks NSURLSessionVersionForRequst:request CompleteBlock:^(id  _Nullable data, ResultCode resultCode, NSError * _Nullable Error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode){
                if (data) {
                    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"==%@",aString);
                    NSDictionary * jsonDic=[DataController dictionaryWithJsonData:data];
                    NSNumber * resultCount=[jsonDic objectForKey:@"resultCount"];
                    if (resultCount.integerValue==1) {
                        NSArray* infoArray = [jsonDic objectForKey:@"results"];
                        if (infoArray.count>0) {
                            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
                            NSString *trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                            UIApplication *application = [UIApplication sharedApplication];
                            [application openURL:[NSURL URLWithString:trackViewURL]];
                        }
                    }
                }
            }else{
                //[self showToastMsg:data Duration:5.0];
            }
        });
    }];
}

-(void)joinBt:(id)sender{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    if (self.goToUrl.length > 0) {
        self.hidden = YES;
        webVc.url = self.goToUrl;
        webVc.title = @"活动详情";
        webVc.isNoRefresh = YES;
        webVc.type = 5;
        webVc.shareTypes = 5;
        webVc.isGetCurrentTitle = YES;
        webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UserActivity *userModel = [[UserActivity alloc]init];
        userModel.gotourl = self.goToUrl;
        webVc.userActivityModel = userModel;
        if (self.callback) {
            self.callback(webVc);
        }
    }
}

@end
