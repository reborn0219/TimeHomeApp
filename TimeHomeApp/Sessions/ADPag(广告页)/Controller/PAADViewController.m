//
//  SHADViewController.m
//  PAPark
//
//  Created by WangKeke on 2018/5/25.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PAADViewController.h"
#import "PAAdService.h"
#import "PAAdInfoRequest.h"

#define kAdPageTimeInterval 5

@interface PAADViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (nonatomic, copy) void (^buttonExitBlock)(void);
@property (nonatomic, copy)UpDateViewsBlock showAdBlock;
@property (strong,nonatomic) UIImage *adImage;
@property (strong,nonatomic) NSString *adUrl;
@property (strong,nonatomic) NSString * adTitle;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (strong,nonatomic) NSTimer *adTimer;

@end

@implementation PAADViewController

#pragma mark - class method

+(void)showAdCompletion:(void (^)(BOOL show, PAWebViewController * webview))completionBlock{
    
    //get image from server
    PAAdService *adService = [[PAAdService alloc]init];
    
    [adService setSuccessBlock:^(PABaseRequestService *service) {
        
        PAADViewController *adVC = [[PAADViewController alloc]initWithNibName:@"PAADViewController" bundle:nil];
        
        PAAdService *adService = (PAAdService *)service;
        
        //iOS原生方法
        NSURL   *imgURL  = [NSURL URLWithString:adService.adInfo.urlbase64];
        NSData  *imgData = [NSData dataWithContentsOfURL:imgURL];
        UIImage *img  = [UIImage imageWithData:imgData];
    
        adVC.adImage = img;
        adVC.adUrl = adService.adInfo.outurl;
        adVC.adTitle = adService.adInfo.title;
        adVC.buttonExitBlock = ^{
            if (completionBlock) {
                completionBlock(NO,nil);
            }
        };
        adVC.showAdBlock = ^(id  _Nullable data, ResultCode resultCode) {
            if (completionBlock) {
                completionBlock(YES,data);
            }

        };
        
        if (img) {
            AppDelegate * delegate = GetAppDelegates;
            delegate.window.rootViewController = adVC;
            
        }else{
            
            //DDLogError(@"开屏广告获取的图片有误:%@",adService.adInfo.urlbase64);
            if (completionBlock) {
                completionBlock(NO,nil);
            }
        }
    }];
    
    [adService setFailedBlock:^(PABaseRequestService *service, NSString *errorMsg) {
        
        if (completionBlock) {
            completionBlock(NO,nil);
        }
    }];
    
    [adService loadAdImage];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adImageView.contentMode =UIViewContentModeScaleAspectFill;
    //超出容器范围的切除掉
    self.adImageView.clipsToBounds = YES;

    if (self.adImage) {
        [self.adImageView setImage:_adImage];
    }
    
    if (self.adUrl){    
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [self.adImageView addGestureRecognizer:singleTap];
    }
    
    [self setupTimer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupTimer{
    __weak typeof(self) weakSelf = self;
    
    __block NSInteger interval = kAdPageTimeInterval;
    self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     block:^(NSTimer * _Nonnull timer) {
                                                         
                                                         [weakSelf.exitButton setTitle:[NSString stringWithFormat:@"跳过 %lds",interval]
                                                                              forState:UIControlStateNormal];
                                                         
                                                         if (interval-- == 0) {
                                                             [weakSelf exit];
                                                         }
                                                         
                                                     } repeats:YES];
}

#pragma mark - events

-(IBAction)exit{
    if (self.buttonExitBlock) {
        self.buttonExitBlock();
    }
}

-(void)adImageViewTapping:(UIGestureRecognizer *)recognizer {
    
    PAWebViewController * webview = [[PAWebViewController alloc]init];
    webview.url =self.adUrl;
    webview.title =self.adTitle;
    webview.hideRightBarButtonItem = YES;
 //   [self exit];
    self.showAdBlock(webview, 0);
}

@end
