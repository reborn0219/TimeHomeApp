//
//  PAVoucherTableViewController.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVoucherTableViewController.h"
#import "PARedBagPresenter.h"
#import "PAVoucherTableViewCell.h"
#import "PAVoucherADTableViewCell.h"
#import "PARedBagDetailModel.h"
#import "PAVoucherDetailViewController.h"
#import "PAMyRedBagVoucherViewController.h"
#import "PARedBagPresenter.h"
#import "WebViewVC.h"

@interface PAVoucherTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation PAVoucherTableViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    
    //导航-我的卡券
    UIBarButtonItem *myRedBagsItem = [[UIBarButtonItem alloc]initWithTitle:@"我的卡券" style:UIBarButtonItemStylePlain target:self action:@selector(myRedBagItemClicked:)];
    self.navigationItem.rightBarButtonItem = myRedBagsItem;
    
    [self setupTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupTableView{
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PAVoucherTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAVoucherTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PAVoucherADTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAVoucherADTableViewCell"];
}
#pragma mark - actions

/*我的卡券*/
-(void)myRedBagItemClicked:(id)sender{
    PAMyRedBagVoucherViewController *redBagVC = [[PAMyRedBagVoucherViewController alloc]initWithNibName:@"PAMyRedBagVoucherViewController" bundle:nil];
    redBagVC.tableType = MYREDBAG_TABLE_TYPE_VOUCHER;
    [self.navigationController pushViewController:redBagVC animated:YES];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    }else{
        return 110.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+self.redBagArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        PAVoucherADTableViewCell *adCell = [tableView dequeueReusableCellWithIdentifier:@"PAVoucherADTableViewCell"];
        
        PARedBagDetailModel *redBagDetail = self.redBagArray.firstObject;
        
        adCell.backgroundpic = redBagDetail.backgroundpic;
        
        return adCell;
        
    }else{
        
        PAVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAVoucherTableViewCell"];
        
        PARedBagDetailModel *redBagDetail = [self.redBagArray objectAtIndex:indexPath.row-1];;
        
        cell.voucher = redBagDetail;
        
        return cell;
    }
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row == 0){
        
        @WeakObj(self);
        
        PARedBagDetailModel *voucher = self.redBagArray.firstObject;
        
        [PARedBagPresenter showAdInfoWithUserticketid:voucher.userticketid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *url = [data objectForKey:@"data"];
                if (url && url.length>0) {
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    
                    webVc.url = url;
                    
                    webVc.title=@"广告详情";
                    webVc.hidesBottomBarWhenPushed = YES;
                    [selfWeak.navigationController pushViewController:webVc animated:YES];
                }
            });
        }];
       
    }else{
        PARedBagDetailModel *voucher = self.redBagArray[indexPath.row-1];
        
        PAVoucherDetailViewController *voucherDetailVC = [[PAVoucherDetailViewController alloc]initWithNibName:@"PAVoucherDetailViewController" bundle:nil];
        voucherDetailVC.voucher = voucher;
        
        [self.navigationController pushViewController:voucherDetailVC animated:YES];
    }
}

@end
