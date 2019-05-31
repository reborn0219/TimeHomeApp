//
//  PAVoucherViewController.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVoucherDetailViewController.h"
#import "PAVoucherTableViewCell.h"
#import "PAVoucherCodeTableViewCell.h"
#import "PAVoucherInfoTableViewCell.h"

@interface PAVoucherDetailViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign,nonatomic) CGFloat adCellheight;

@end

@implementation PAVoucherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券详情";
    
    [self setupTableView];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableView{
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PAVoucherTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAVoucherTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PAVoucherCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAVoucherCodeTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PAVoucherInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAVoucherInfoTableViewCell"];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 10.0;
    }else if (indexPath.row == 1) {//卡券信息
        return 110.0;
    }else if(indexPath.row == 2){//二维码
        return 338.0;
    }else if(indexPath.row == 3){//使用说明
        return _adCellheight==0?100:_adCellheight;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UITableViewCell *blankCell = [[UITableViewCell alloc]init];
        blankCell.backgroundColor = UIColorFromRGB(0xF1F1F1);
        
        return blankCell;
    }else if (indexPath.row == 1) {//卡券信息
        PAVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAVoucherTableViewCell"];
        cell.voucher = self.voucher;
        [cell hidenDetailLabel:YES];
        return cell;
    }else if(indexPath.row == 2){//二维码
        PAVoucherCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAVoucherCodeTableViewCell"];
        cell.voucher = self.voucher;
        return cell;
    }else if(indexPath.row == 3){//使用说明
        PAVoucherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAVoucherInfoTableViewCell"];
        //cell.explanationUrl = self.voucher.explanation;
        cell.htmlString = self.voucher.explanation;
        
        __weak typeof(self) weakSelf = self;
        
        cell.heightCallBack = ^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
            
            NSNumber *height = data;
            
            weakSelf.adCellheight = height.floatValue;
            
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                             withRowAnimation:UITableViewRowAnimationNone];
            
        };
        return cell;
    }
    
    return nil;
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Notification

-(void)subReceivePushMessages:(NSNotification*) aNotification
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(aNotification.object == nil)
        {
            return ;
        }
        
        NSDictionary *dic = [NullPointerUtils toDealWithNullPointer:(NSDictionary *)aNotification.object];
        /** 消息类型 */
        NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        if (type.integerValue == 30501) {
            
            NSDictionary *map = [dic objectForKey:@"map"];
            
            NSString * userticketid = [NSString stringWithFormat:@"%@",[map objectForKey:@"userticketid"]];
            
            if ([userticketid isEqualToString:self.voucher.userticketid]) {
                
                self.voucher.state = 2;//已核销
                
                [self.tableView reloadData];
            }
        }
        
    });
}


@end
