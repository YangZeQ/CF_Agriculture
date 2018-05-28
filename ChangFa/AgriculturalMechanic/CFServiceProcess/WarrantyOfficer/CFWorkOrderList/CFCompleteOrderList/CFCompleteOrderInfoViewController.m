//
//  CFCompleteOrderInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/22.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFCompleteOrderInfoViewController.h"
#import "CFWorkOrderInfoViewController.h"
#import "CFShowFillInfoViewController.h"
#import "CFCompleteCommentViewController.h"
#import "CFWordOrderInfoModel.h"
#import "ChangFa-Bridging-Header.h"
#import <Charts/Charts-Swift.h>
//#import "PieChartView.swift"
@interface CFCompleteOrderInfoViewController ()
@property (nonatomic, strong)UIScrollView *orderInfoScrollView;
@property (nonatomic, strong)UILabel *orderNumberLabel;
@property (nonatomic, strong)UILabel *orderNameLabel;
@property (nonatomic, strong)UILabel *orderPhoneLabel;
@property (nonatomic, strong)UILabel *switchLabel;
//@property (nonatomic, strong)UIImageView *switchImage;
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)UILabel *machineNameLabel;
@property (nonatomic, strong)UILabel *machineTypeLabel;
@property (nonatomic, strong)UILabel *machineTimeLabel;
@property (nonatomic, strong)UILabel *machinePositionLabel;
@property (nonatomic, strong)UILabel *accountTypeLabel;
@property (nonatomic, strong)UILabel *purposeLabel;
@property (nonatomic, strong)UILabel *explainLabel;
@property (nonatomic, strong)UILabel *completeTimeLabel;
@property (nonatomic, strong)UILabel *createTimeLabel;
@property (nonatomic, strong)UILabel *costLabel;
@property (nonatomic, strong)CFWordOrderInfoModel *orderInfoModel;

@property (nonatomic, strong)PieChartView *pieChartView;
@property (nonatomic, strong) PieChartData *data;
@end

@implementation CFCompleteOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"已完成派工单";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createCompleteOrderInfoView];
    [self getOrderInfoWithDispatchId:self.dispatchId];
    // Do any additional setup after loading the view.
}
- (void)createCompleteOrderInfoView
{
    _orderInfoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT)];
    _orderInfoScrollView.userInteractionEnabled = YES;
    _orderInfoScrollView.contentSize = CGSizeMake(0, 1650 * screenHeight);
    [self.view addSubview:_orderInfoScrollView];
    
    [self createOrderInfoView];
    
    [self createAccountInfoView];
    
    [self createAccountExplainView];
    
    [self createOrderTimeInfoView];
}
- (void)createOrderInfoView
{
    UIView *orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 620 * screenHeight)];
    orderInfoView.backgroundColor = [UIColor whiteColor];
    [_orderInfoScrollView addSubview:orderInfoView];
    
    _orderNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 80 * screenHeight)];
    _orderNumberLabel.font = CFFONT14;
    _orderNumberLabel.text = @"派工单号： ";
    [orderInfoView addSubview:_orderNumberLabel];
    
    UILabel *numberLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _orderNumberLabel.frame.size.height - 2 * screenHeight, CF_WIDTH, 2 * screenHeight)];
    numberLineLabel.backgroundColor = BackgroundColor;
    [orderInfoView addSubview:numberLineLabel];
    
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, _orderNumberLabel.frame.size.height + 30 * screenHeight, 120 * screenWidth, 120 * screenHeight)];
    [orderInfoView addSubview:_machineImage];
    _machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 20 * screenWidth, _machineImage.frame.origin.y + 10 * screenHeight, CF_WIDTH - 200 * screenWidth, 40 * screenHeight)];
    _machineNameLabel.text = @"名称：";
    _machineNameLabel.font = CFFONT14;
    [orderInfoView addSubview:_machineNameLabel];
    
    _machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineNameLabel.frame.size.height + _machineNameLabel.frame.origin.y + 20 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineTypeLabel.text = @"型号：";
    _machineTypeLabel.font = CFFONT14;
    [orderInfoView addSubview:_machineTypeLabel];
    
    UILabel *machineLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _machineTypeLabel.frame.size.height + _machineTypeLabel.frame.origin.y +  + 28 * screenHeight, CF_WIDTH, 2 * screenHeight)];
    machineLineLabel.backgroundColor = BackgroundColor;
    [orderInfoView addSubview:machineLineLabel];
    
    UILabel *orderInformationLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, _machineTypeLabel.frame.size.height + _machineTypeLabel.frame.origin.y + 30 * screenHeight, _orderNumberLabel.frame.size.width, 120 * screenHeight)];
    orderInformationLabel.text = @"派工单详情";
    orderInformationLabel.font = CFFONT14;
    [orderInfoView addSubview:orderInformationLabel];
    UIButton *orderInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderInfoButton.frame = orderInformationLabel.frame;
    orderInfoButton.tag = 1001;
    [orderInfoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [orderInfoView addSubview:orderInfoButton];
    
    UILabel *orderLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, machineLineLabel.frame.origin.y + 120 * screenHeight, CF_WIDTH, 2 * screenHeight)];
    orderLineLabel.backgroundColor = BackgroundColor;
    [orderInfoView addSubview:orderLineLabel];
    
    UILabel *repairInformationLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, orderInformationLabel.frame.size.height + orderInformationLabel.frame.origin.y, orderInformationLabel.frame.size.width, orderInformationLabel.frame.size.height)];
    repairInformationLabel.text = @"维修单详情";
    repairInformationLabel.font = CFFONT14;
    [orderInfoView addSubview:repairInformationLabel];
    UIButton *repairInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repairInfoButton.frame = repairInformationLabel.frame;
    repairInfoButton.tag = 1002;
    [repairInfoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [orderInfoView addSubview:repairInfoButton];
    
    UILabel *repairLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, orderLineLabel.frame.origin.y + 120 * screenHeight, CF_WIDTH, orderLineLabel.frame.size.height)];
    repairLineLabel.backgroundColor = BackgroundColor;
    [orderInfoView addSubview:repairLineLabel];
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, repairInformationLabel.frame.size.height + repairInformationLabel.frame.origin.y, repairInformationLabel.frame.size.width, repairInformationLabel.frame.size.height)];
    commentLabel.text = @"用户评价";
    commentLabel.font = CFFONT14;
    [orderInfoView addSubview:commentLabel];
    UIButton *commentInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentInfoButton.frame = commentLabel.frame;
    commentInfoButton.tag = 1003;
    [commentInfoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [orderInfoView addSubview:commentInfoButton];
}

- (void)createAccountInfoView
{
    UIView *accountInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 650 * screenHeight, CF_WIDTH, 640 * screenHeight)];
    accountInfoView.backgroundColor = [UIColor whiteColor];
    [_orderInfoScrollView addSubview:accountInfoView];
    
    self.pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake((CF_WIDTH - 600 * screenWidth) / 2, 40 * screenHeight, 600 * screenWidth, 600 * screenHeight)];
//    self.pieChartView.backgroundColor = BackgroundColor;
    [accountInfoView addSubview:self.pieChartView];
    
    [self.pieChartView setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0];//饼状图距离边缘的间隙
    self.pieChartView.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
    self.pieChartView.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
    self.pieChartView.drawCenterTextEnabled = YES;//是否显示区块文本
    
    self.pieChartView.drawHoleEnabled = YES;//饼状图是否是空心
    self.pieChartView.holeRadiusPercent = 0.7;//空心半径占比
    self.pieChartView.holeColor = [UIColor clearColor];//空心颜色
    self.pieChartView.transparentCircleRadiusPercent = 0;//半透明空心半径占比
    self.pieChartView.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3];//半透明空心的颜色
    
    if (self.pieChartView.isDrawHoleEnabled == YES) {
        self.pieChartView.drawCenterTextEnabled = YES;//是否显示中间文字
        //普通文本
//         self.pieChartView.centerText = @"饼状图";//中间文字
        //富文本
        NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"饼状图"];
        [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                    NSForegroundColorAttributeName: [UIColor orangeColor]}
                            range:NSMakeRange(0, centerText.length)];
        self.pieChartView.centerAttributedText = centerText;
    }
    
    self.pieChartView.chartDescription.text = @"饼状图示例";
    self.pieChartView.chartDescription.font = CFFONT12;
    self.pieChartView.chartDescription.textColor = [UIColor grayColor];
//
    self.pieChartView.legend.maxSizePercent = 10;//图例在饼状图中的大小占比, 这会影响图例的宽高
    self.pieChartView.legend.formToTextSpace = 5;//文本间隔
    self.pieChartView.legend.font = [UIFont systemFontOfSize:10];//字体大小
    self.pieChartView.legend.textColor = [UIColor grayColor];//字体颜色
    self.pieChartView.legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    self.pieChartView.legend.orientation = ChartLegendDirectionLeftToRight;//图例在饼状图中的位置
    self.pieChartView.legend.form = ChartLegendFormCircle;//图示样式: 方形、线条、圆形
    self.pieChartView.legend.formSize = 12;//图示大小
    
    //为饼状图提供数据
    self.data = [self setData];
    self.pieChartView.data = self.data;
    //设置动画效果
    [self.pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
    
}
- (void)updateData{
    //为饼状图提供数据
    self.data = [self setData];
    self.pieChartView.data = self.data;
    //设置动画效果
    [self.pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
}
- (PieChartData *)setData{
    double mult = 100;
    int count = 5;//饼状图总共有几块组成

    //每个区块的数据
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult + 1);
        NSString *title = [NSString stringWithFormat:@"part%d", i+1];
        [values addObject:[[PieChartDataEntry alloc] initWithValue:randomVal label:title]];
    }

    //dataSet
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    dataSet.drawValuesEnabled = YES;//是否绘制显示数据
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    dataSet.colors = colors;//区块颜色
    dataSet.sliceSpace = 0;//相邻区块之间的间距
    dataSet.selectionShift = 8;//选中区块时, 放大的半径
    dataSet.xValuePosition = PieChartValuePositionInsideSlice;//名称位置
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置
    //数据与区块之间的用于指示的折线样式
    dataSet.valueLinePart1OffsetPercentage = 0.85;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    dataSet.valueLinePart1Length = 0.5;//折线中第一段长度占比
    dataSet.valueLinePart2Length = 0.4;//折线中第二段长度最大占比
    dataSet.valueLineWidth = 1;//折线的粗细
    dataSet.valueLineColor = [UIColor brownColor];//折线颜色
    //data
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    formatter.maximumFractionDigits = 0;//小数位数
    formatter.multiplier = @1.f;
//    [data setValueFormatter:formatter];//设置显示数据格式
    [data setValueTextColor:[UIColor brownColor]];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    return data;
}
- (void)createAccountExplainView
{
    UIView *accountExplainView = [[UIView alloc]initWithFrame:CGRectMake(0, 1300 * screenHeight, CF_WIDTH, 200 * screenHeight)];
    accountExplainView.backgroundColor = [UIColor whiteColor];
    [_orderInfoScrollView addSubview:accountExplainView];
    
    _accountTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, CF_WIDTH - 60 * screenWidth, 40 * screenHeight)];
    _accountTypeLabel.text = @"单价类型：";
    _accountTypeLabel.font = CFFONT14;
    [accountExplainView addSubview:_accountTypeLabel];
    _purposeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_accountTypeLabel.frame.origin.x, _accountTypeLabel.frame.origin.y + _accountTypeLabel.frame.size.height + 20 * screenHeight, _accountTypeLabel.frame.size.width, _accountTypeLabel.frame.size.height)];
    _purposeLabel.text = @"用途：";
    _purposeLabel.font = CFFONT14;
    [accountExplainView addSubview:_purposeLabel];
    _explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(_accountTypeLabel.frame.origin.x, _purposeLabel.frame.size.height + _purposeLabel.frame.origin.y + 20 * screenHeight, _accountTypeLabel.frame.size.width, _accountTypeLabel.frame.size.height)];
    _explainLabel.text = @"其他费用说明：";
    _explainLabel.font = CFFONT14;
    [accountExplainView addSubview:_explainLabel];
}
- (void)createOrderTimeInfoView
{
    UIView *orderTimeInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 1510 * screenHeight, CF_WIDTH, 126 * screenHeight)];
    orderTimeInfoView.backgroundColor = [UIColor whiteColor];
    [_orderInfoScrollView addSubview:orderTimeInfoView];
    
    _completeTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 13 * screenHeight, CF_WIDTH - 60 * screenWidth, 40 * screenHeight)];
    _completeTimeLabel.text = @"完成时间：";
    _completeTimeLabel.font = CFFONT14;
    _completeTimeLabel.textColor = [UIColor grayColor];
    [orderTimeInfoView addSubview:_completeTimeLabel];
    _createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_completeTimeLabel.frame.origin.x, _completeTimeLabel.frame.origin.y + _completeTimeLabel.frame.size.height + 20 * screenHeight, _completeTimeLabel.frame.size.width, _completeTimeLabel.frame.size.height)];
    _createTimeLabel.text = @"创建时间：";
    _createTimeLabel.font = CFFONT14;
    _createTimeLabel.textColor = [UIColor grayColor];
    [orderTimeInfoView addSubview:_createTimeLabel];
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 获取派工单详情
- (void)getOrderInfoWithDispatchId:(NSString *)dispatchId
{
    NSDictionary *param = @{
                            @"dispatchId":dispatchId,
                            @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"],
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"dispatch/selectById" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            self.orderInfoModel = [CFWordOrderInfoModel orderInfoModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
            [self setOrderInforToView];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)setOrderInforToView
{
    _orderNumberLabel.text = [_orderNumberLabel.text stringByAppendingString:self.orderInfoModel.disNum];
    switch ([self.orderInfoModel.machineType integerValue]) {
        case 1:
            _machineImage.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            _machineImage.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            _machineImage.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            _machineImage.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    _machineNameLabel.text = [_machineNameLabel.text stringByAppendingString:_orderInfoModel.machineName];
    _machineTypeLabel.text = [_machineTypeLabel.text stringByAppendingString:_orderInfoModel.machineModel];
    _accountTypeLabel.text = [_accountTypeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", _orderInfoModel.disId]];
    _purposeLabel.text = [_purposeLabel.text stringByAppendingString:_orderInfoModel.descriptions];
    _explainLabel.text = [_explainLabel.text stringByAppendingString:_orderInfoModel.descriptions];
    _completeTimeLabel.text = [_completeTimeLabel.text stringByAppendingString:_orderInfoModel.finishTime];
    _createTimeLabel.text = [_createTimeLabel.text stringByAppendingString:_orderInfoModel.createTime];
}
- (void)infoButtonClick:(UIButton *)sender
{
    if (sender.tag == 1001) {
        CFWorkOrderInfoViewController *order = [[CFWorkOrderInfoViewController alloc]init];
        order.pushType = 2;
        order.dispatchId = self.dispatchId;
        [self.navigationController pushViewController:order animated:YES];
    } else if (sender.tag == 1002) {
        CFShowFillInfoViewController *show = [[CFShowFillInfoViewController alloc]init];
        show.repairId = self.orderInfoModel.repairId;
        show.disId = self.orderInfoModel.disId;
        show.disNum = self.orderInfoModel.disNum;
        show.dispatchId = self.dispatchId;
        [self.navigationController pushViewController:show animated:YES];
    } else {
        if (self.orderInfoModel.commentId.length < 1) {
            [MBManager showBriefAlert:@"暂无评论" time:1.5];
            return;
        }
        CFCompleteCommentViewController *comment = [[CFCompleteCommentViewController alloc]init];
        comment.commentId = self.orderInfoModel.commentId;
        comment.contactMobile = self.orderInfoModel.contactMobile;
//        comment.pushType = 2;
//        comment.serviceId = self.orderInfoModel.commentId;
        [self.navigationController pushViewController:comment animated:YES];
    }
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
