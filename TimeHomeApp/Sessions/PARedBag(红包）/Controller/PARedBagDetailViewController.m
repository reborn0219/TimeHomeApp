//
//  PARedBagDetailViewController.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PARedBagDetailViewController.h"
#import "PAMyRedBagVoucherViewController.h"
#import "L_MyMoneyViewController.h"
#import "PARedBagPresenter.h"
#import "WebViewVC.h"

@interface PARedBagDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;//广告背景图
@property (weak, nonatomic) IBOutlet UILabel *redMsgLabel;//祝福语
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//红包金额
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;//logo
@property (weak, nonatomic) IBOutlet UILabel *redNameLabel;//发红包商家名称
@property (weak, nonatomic) IBOutlet UIView *logoShadowView;

@end

@implementation PARedBagDetailViewController

-(void)setRedBag:(PARedBagDetailModel *)redBag{
    if (redBag) {
        _redBag = redBag;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //layout
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.redBag.backgroundpic]
                        placeholderImage:[UIImage imageNamed:@""]];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.redBag.logourl]
                          placeholderImage:[UIImage imageNamed:@""]];
    
    self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.redBag.amount];
    self.redMsgLabel.text = self.redBag.redmessage;
    self.redNameLabel.text = self.redBag.redname;
    
    //Logo圆角 阴影处理
    self.logoImageView.layer.cornerRadius = 27.5;
    self.logoImageView.layer.masksToBounds = YES;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 55, 55);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.5;
    layer.cornerRadius = 27.5;
    
    [self.logoShadowView.layer addSublayer:layer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"现金红包";
    
    //导航-我的红包
    UIBarButtonItem *myRedBagsItem = [[UIBarButtonItem alloc]initWithTitle:@"我的红包" style:UIBarButtonItemStylePlain target:self action:@selector(myRedBagItemClicked:)];
    self.navigationItem.rightBarButtonItem = myRedBagsItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

/*查看我的余额*/
- (IBAction)myRemainingClicked:(id)sender {
    //余额
    UIStoryboard *myTabBoard = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
    L_MyMoneyViewController *myMoneyVC = [myTabBoard instantiateViewControllerWithIdentifier:@"L_MyMoneyViewController"];
    [myMoneyVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:myMoneyVC animated:YES];
}

/*查看广告详情*/
-(IBAction)bgImageViewClicked:(id)sender{
    
     @WeakObj(self);
    
    [PARedBagPresenter  showAdInfoWithUserticketid:self.redBag.userticketid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                NSString *url = [data objectForKey:@"data"];
                if (url&&url.length>0) {
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    
                    webVc.url = url;
                    
                    webVc.title=@"广告详情";
                    webVc.hidesBottomBarWhenPushed = YES;
                    [selfWeak.navigationController pushViewController:webVc animated:YES];
                }
            }else{
                [selfWeak showToastMsg:@"操作失败" Duration:2.0];
            }
        });
    }];
}

/*查看我的红包*/
-(void)myRedBagItemClicked:(id)sender{
    PAMyRedBagVoucherViewController *redBagVC = [[PAMyRedBagVoucherViewController alloc]initWithNibName:@"PAMyRedBagVoucherViewController" bundle:nil];
    redBagVC.tableType = MYREDBAG_TABLE_TYPE_REDBAG;
    [self.navigationController pushViewController:redBagVC animated:YES];
}


@end
