//
//  CFFillInOrderViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/21.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFShowFillInfoViewController.h"
#import "CFPreviewPhotoViewController.h"
#import "CFRegisterTextFieldView.h"
#import "CFFillInOrderViewTableViewCell.h"
#import "CFFillInOrderModel.h"
#import "AFHTTPSessionManager.h"
#define MAX_LIMIT_NUMS 150
@interface CFShowFillInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)CFFillInOrderModel *fillModel;
@property (nonatomic, strong)UIScrollView *fillScrollView;
@property (nonatomic, strong)UITableView *orderTableView;

@property (nonatomic, strong)NSArray *infoArray;
@property (nonatomic, assign)NSInteger selectedIndex; // 点击cell下标
@property (nonatomic, strong)NSMutableArray *signArray; // 存储cell的选定标识
@property (nonatomic, strong)NSArray *styleArray;

@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *faultPhotoArray;
@property (nonatomic, strong)NSMutableArray *personPhotoArray;
@property (nonatomic, strong)NSMutableArray *faultPhotoPathArray;
@property (nonatomic, strong)NSMutableArray *personPhotoPathArray;
@property (nonatomic, strong)NSString *fileIds;
@property (nonatomic, strong)NSString *useTime;
@property (nonatomic, strong)NSString *driveDistance;
@property (nonatomic, strong)NSString *faultFileIds;
@property (nonatomic, strong)NSString *personFileIds;
@property (nonatomic, strong)NSString *machineInstruction;
@property (nonatomic, strong)NSString *faultInstruction;
@property (nonatomic, strong)NSString *customerOpinion;
@property (nonatomic, strong)NSString *handleOpinion;
@property (nonatomic, strong)NSString *remarks;

@end

@implementation CFShowFillInfoViewController

- (NSArray *)infoArray
{
    if (_infoArray == nil) {
        _infoArray = [NSArray arrayWithObjects:@"故障照片", @"人机合影",@"农机信息", @"农机用途说明", @"农机故障说明", @"客户意见", @"处理意见", @"备注", nil];
    }
    return _infoArray;
}
- (NSMutableArray *)signArray
{
    if (_signArray == nil) {
        _signArray = [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil];
    }
    return _signArray;
}
- (NSArray *)styleArray
{
    if (_styleArray == nil) {
        _styleArray = [NSArray arrayWithObjects:@1, @1, @2, @2, @2, @2, @2, @2, nil];
    }
    return _styleArray;
}
- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (NSMutableArray *)faultPhotoArray
{
    if (_faultPhotoArray == nil) {
        _faultPhotoArray = [NSMutableArray array];
    }
    return _faultPhotoArray;
}
- (NSMutableArray *)personPhotoArray
{
    if (_personPhotoArray == nil) {
        _personPhotoArray = [NSMutableArray array];
    }
    return _personPhotoArray;
}
- (NSMutableArray *)faultPhotoPathArray
{
    if (_faultPhotoPathArray == nil) {
        _faultPhotoPathArray = [NSMutableArray array];
    }
    return _faultPhotoPathArray;
}
- (NSMutableArray *)personPhotoPathArray
{
    if (_personPhotoPathArray == nil) {
        _personPhotoPathArray = [NSMutableArray array];
    }
    return _personPhotoPathArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"维修单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];

    [self createFillInOrderView];
    [self getFillInOrderWithReapirId:self.repairId];
    
    // Do any additional setup after loading the view.
}
- (void)createFillInOrderView
{
    self.selectedIndex = 0;
    [self.signArray replaceObjectAtIndex:self.selectedIndex withObject:@1];
    
    _fillScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _fillScrollView.contentSize = CGSizeMake(0, 1600 * screenHeight);
    _fillScrollView.backgroundColor = BackgroundColor;
    _fillScrollView.delegate = self;
    [self.view addSubview:_fillScrollView];
    
    UILabel *repairStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, CF_WIDTH - 60 * screenWidth, 120 * screenHeight)];
    repairStyleLabel.backgroundColor = [UIColor whiteColor];
    repairStyleLabel.layer.cornerRadius = 20 * screenWidth;
    repairStyleLabel.clipsToBounds = YES;
    repairStyleLabel.text = @"外出服务";
    repairStyleLabel.font = CFFONT14;
    repairStyleLabel.textAlignment = NSTextAlignmentCenter;
    [_fillScrollView addSubview:repairStyleLabel];
    UILabel *repairTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 35 * screenHeight, 250 * screenWidth, 50 * screenHeight)];
    repairTitleLabel.text = @"维修类型";
    repairTitleLabel.font = CFFONT14;
    [repairStyleLabel addSubview:repairTitleLabel];

    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, repairStyleLabel.frame.size.height + repairStyleLabel.frame.origin.y, CF_WIDTH, (120 +  20) * self.infoArray.count * screenHeight + 292 * screenHeight)];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.showsVerticalScrollIndicator = NO;
    _orderTableView.scrollEnabled = NO;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_fillScrollView addSubview:_orderTableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infoArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFFillInOrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFFillInOrderViewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.statusLabel.hidden = YES;
    cell.cellStyle = 1;
    if ([self.signArray[indexPath.section] integerValue] == 1) {
        cell.selected = YES;
        if (indexPath.section > 1) {
            cell.cellIndex = indexPath.section;
            if (indexPath.section == 2) {
                cell.styleStatus = 3;
            } else {
                cell.styleStatus = 2;
            }
        } else {
            cell.styleStatus = 1;
            cell.clickImageBlock = ^(NSInteger sender) {
                CFPreviewPhotoViewController *preview = [[CFPreviewPhotoViewController alloc]init];
                if (_selectedIndex == 0) {
                    preview.photoArray = self.faultPhotoArray;
                } else {
                    preview.photoArray = self.personPhotoArray;
                }
                preview.selectedIndex = sender;
                preview.headerHeight = navHeight;
                [self presentViewController:preview animated:YES completion:^{
                    
                }];
            };
        }
    } else {
        cell.styleStatus = 0;
    }
    cell.nameLabel.text = _infoArray[indexPath.section];
    switch (indexPath.section) {
        case 0:
            if (self.fillModel.faultFileInfo.count > 0 || self.faultFileIds.length > 0) {
                cell.photoArray = self.faultPhotoArray;
                cell.cellType = 0;
            }
            break;
        case 1:
            if (self.fillModel.personFileInfo.count > 0 || self.personFileIds.length > 0) {
                cell.photoArray = self.personPhotoArray;
                cell.cellType = 0;
            }
            break;
        case 2:
            if (self.useTime.length > 0) {
                cell.hourTextField.textField.text = self.useTime;
                cell.hourTextField.textField.placeholder = @"";
            }
            if (self.driveDistance.length > 0) {
                cell.mileageTextField.textField.text = self.driveDistance;
                cell.mileageTextField.textField.placeholder = @"";
            }
            cell.hourTextField.userInteractionEnabled = NO;
            cell.mileageTextField.userInteractionEnabled = NO;
            break;
        case 3:
            if (self.fillModel.machineInstruction.length > 0) {
                cell.reasonView.text = self.fillModel.machineInstruction;
                cell.reasonView.placeholder = @"";
            }
            if (self.machineInstruction.length > 0) {
                cell.reasonView.text = self.machineInstruction;
                cell.reasonView.placeholder = @"";
            }
            cell.reasonView.userInteractionEnabled = NO;
            cell.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", self.machineInstruction.length, MAX_LIMIT_NUMS];
            break;
        case 4:
            if (self.fillModel.faultInstruction.length > 0) {
                cell.reasonView.text = self.fillModel.faultInstruction;
                cell.reasonView.placeholder = @"";
            }
            if (self.faultInstruction.length > 0) {
                cell.reasonView.text = self.faultInstruction;
                cell.reasonView.placeholder = @"";
            }
            cell.reasonView.userInteractionEnabled = NO;
            cell.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", self.faultInstruction.length, MAX_LIMIT_NUMS];
            break;
        case 5:
            if (self.fillModel.customerOpinion.length > 0) {
                cell.reasonView.text = self.fillModel.customerOpinion;
                cell.reasonView.placeholder = @"";
            }
            cell.reasonView.userInteractionEnabled = NO;
            if (self.customerOpinion.length > 0) {
                cell.reasonView.text = self.customerOpinion;
                cell.reasonView.placeholder = @"";
            }
            cell.reasonView.userInteractionEnabled = NO;
            cell.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", self.customerOpinion.length, MAX_LIMIT_NUMS];
            break;
        case 6:
            if (self.fillModel.handleOpinion.length > 0) {
                cell.reasonView.text = self.fillModel.handleOpinion;
                cell.reasonView.placeholder = @"";
            }
            if (self.handleOpinion.length > 0) {
                cell.reasonView.text = self.handleOpinion;
                cell.reasonView.placeholder = @"";
            }
            cell.reasonView.userInteractionEnabled = NO;
            cell.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", self.handleOpinion.length, MAX_LIMIT_NUMS];
            break;
        case 7:
            if (self.fillModel.remarks.length > 0) {
                cell.reasonView.text = self.fillModel.remarks;
                cell.reasonView.placeholder = @"";
            }
            if (self.remarks.length > 0) {
                cell.reasonView.text = self.remarks;
                cell.reasonView.placeholder = @"";
            }
            cell.reasonView.userInteractionEnabled = NO;
            cell.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", self.remarks.length, MAX_LIMIT_NUMS];
            cell.starImage.hidden = YES;
            break;
        default:
            break;
    }
    cell.starImage.hidden = YES;
    cell.originX = 30 * screenWidth;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.signArray[indexPath.section] integerValue] == 1) {
        if (indexPath.section == 2) {
            return (120 + 196) * screenHeight;
        }
        return (120 + 292) * screenHeight;
    }
    return 120 * screenHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _orderTableView.frame.size.width, 20 * screenHeight)];
    headView.backgroundColor = BackgroundColor;
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < self.signArray.count; i++) {
        [self.signArray replaceObjectAtIndex:i withObject:@0];
    }
    [self.signArray replaceObjectAtIndex:indexPath.section withObject:@1];
    CGRect viewFrame = _orderTableView.frame;
    if (self.selectedIndex == indexPath.section) {// 点击同一个收回
        [self.signArray replaceObjectAtIndex:indexPath.section withObject:@0];
        self.selectedIndex = 1000;
        _orderTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, (120 +  20) * self.infoArray.count * screenHeight);
        [self.orderTableView reloadData];
        return;
    }
    if (indexPath.section == 2) {
        _orderTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, (120 +  20) * self.infoArray.count * screenHeight + 196 * screenHeight);
    } else {
        _orderTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, (120 +  20) * self.infoArray.count * screenHeight + 292 * screenHeight);
    }
    [_orderTableView reloadData];
    self.selectedIndex = indexPath.section;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    CFFillInOrderViewTableViewCell *orderInfoCell = [tableView cellForRowAtIndexPath:indexPath];
    orderInfoCell.selected = NO;
    orderInfoCell.styleStatus = 0;
    [self.orderTableView reloadData];
}

#pragma mark - 获取已填写维修单信息
- (void)getFillInOrderWithReapirId:(NSString *)repairId
{
    [MBManager showWaitingWithTitle:@"加载中"];
    NSDictionary *param = @{
                            @"repairId":repairId,
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"repair/getRepairInfo" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            [MBManager hideAlert];
            self.fillModel = [CFFillInOrderModel fillInOrderModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
            [self fillInOrderInfo];
        } else {
            [MBManager showBriefAlert:@"加载失败" time:1.0];
            //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            //            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            //            [alert addAction:alertAction];
            //            [self presentViewController:alert animated:YES completion:^{
            //
            //            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"加载失败" time:1.0];
    }];
}

- (void)fillInOrderInfo
{
    for (NSDictionary *dic in self.fillModel.faultFileInfo) {
        if (self.faultFileIds.length == 0) {
            self.faultFileIds = [dic objectForKey:@"fileId"];
        } else {
            self.faultFileIds = [[self.faultFileIds stringByAppendingString:@","] stringByAppendingString:[dic objectForKey:@"fileId"]];
        }
        [self.faultPhotoArray addObject:[dic objectForKey:@"filePath"]];
    }
    for (NSDictionary *dic in self.fillModel.personFileInfo) {
        if (self.personFileIds.length == 0) {
            self.personFileIds = [dic objectForKey:@"fileId"];
        } else {
            self.personFileIds = [[self.personFileIds stringByAppendingString:@","] stringByAppendingString:[dic objectForKey:@"fileId"]];
        }
        [self.personPhotoArray addObject:[dic objectForKey:@"filePath"]];
    }
    self.useTime = [NSString stringWithFormat:@"%@", _fillModel.useTime];
    self.driveDistance = [NSString stringWithFormat:@"%@", _fillModel.driveDistance];
    self.faultInstruction = self.fillModel.faultInstruction;
    self.machineInstruction = self.fillModel.machineInstruction;
    self.customerOpinion = self.fillModel.customerOpinion;
    self.handleOpinion = self.fillModel.handleOpinion;
    self.remarks = self.fillModel.remarks;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.orderTableView reloadData];
    });
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**通过URL地址从网上获取图片*/
- (UIImage*)getImageFromURL:(NSString*)fileURL
{
    UIImage *image;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", fileURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    image = [UIImage imageWithData:data];
    return image;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

