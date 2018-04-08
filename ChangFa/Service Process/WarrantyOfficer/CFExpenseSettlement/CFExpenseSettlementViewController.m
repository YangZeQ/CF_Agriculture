//
//  CFExpenseSettlementViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/27.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFExpenseSettlementViewController.h"
#import "ChangFa-Bridging-Header.h"
#import <Charts/Charts-Swift.h>
@interface CFExpenseSettlementViewController ()<ChartViewDelegate, IChartAxisValueFormatter, IChartValueFormatter>
@property (nonatomic, strong)UIScrollView *expenseSettlementScrollView;
@property (nonatomic, strong)PieChartView *pieChartView;
@property (nonatomic, strong)LineChartView *lineChartView;
@property (nonatomic, strong)PieChartData *pieData;
@property (nonatomic, strong)LineChartData *lineData;
@property (nonatomic, strong)NSMutableArray *dateArray;
@end

@implementation CFExpenseSettlementViewController
- (NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"费用结算";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createExpenseSettlementView];
    // Do any additional setup after loading the view.
}
- (void)createExpenseSettlementView
{
    self.expenseSettlementScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT)];
    self.expenseSettlementScrollView.contentSize = CGSizeMake(CF_WIDTH, 1400 * screenHeight);
    self.expenseSettlementScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.expenseSettlementScrollView];
    [self createPieChartsView];
    UILabel *incomeLable = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 640 * screenHeight, CF_WIDTH - 60 * screenWidth, 88 * screenHeight)];
    incomeLable.text = @"本月收入";
    incomeLable.userInteractionEnabled = YES;
    [self.expenseSettlementScrollView addSubview:incomeLable];
    UIButton *dateBurron = [UIButton  buttonWithType:UIButtonTypeCustom];
    dateBurron.frame = CGRectMake(CF_WIDTH - 72 * screenWidth, incomeLable.frame.origin.y + 23 * screenHeight, 42 * screenWidth, 42 * screenHeight);
    [dateBurron setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [dateBurron addTarget:self action:@selector(dateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.expenseSettlementScrollView addSubview:dateBurron];
    
    [self createLineChartsView];
}
- (void)createPieChartsView
{
    UIView *pieView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 640 * screenHeight)];
    pieView.backgroundColor = [UIColor whiteColor];
    [self.expenseSettlementScrollView addSubview:pieView];
    
    self.pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake((CF_WIDTH - 600 * screenWidth) / 2, 40 * screenHeight, 600 * screenWidth, 600 * screenHeight)];
   [pieView addSubview:self.pieChartView];
    
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
    self.pieData = [self setPieData];
    self.pieChartView.data = self.pieData;
    //设置动画效果
    [self.pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
    
}
- (void)updateData
{
    //为饼状图提供数据
    self.pieData = [self setPieData];
    self.pieChartView.data = self.pieData;
    //设置动画效果
    [self.pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
}
- (PieChartData *)setPieData
{
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
- (void)createLineChartsView
{
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 728 * screenHeight, CF_WIDTH, CF_HEIGHT - 728 * screenHeight)];
    barView.backgroundColor = [UIColor whiteColor];
    [self.expenseSettlementScrollView addSubview:barView];
    
    self.lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, barView.frame.size.height)];
    self.lineChartView.dragEnabled = YES;
    self.lineChartView.pinchZoomEnabled = NO;   //捏合手势
    self.lineChartView.doubleTapToZoomEnabled = NO; //双击手势
    self.lineChartView.scaleYEnabled = NO;  //取消Y轴缩放
    self.lineChartView.legend.form = ChartLegendFormLine;   //说明图标
    self.lineChartView.chartDescription.enabled = NO; //不显示描述label
    self.lineChartView.rightAxis.enabled = NO;  //隐藏右Y轴
    [self.lineChartView animateWithXAxisDuration:1.0];  //赋值动画时长
    [barView addSubview:self.lineChartView];
    // 设置左Y轴
    ChartYAxis *leftAxis = self.lineChartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = 100.0;
    leftAxis.axisMinimum = 1.0;
    leftAxis.axisLineWidth = 1.0;
    leftAxis.drawZeroLineEnabled = YES;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    
    // 设置X轴
    ChartXAxis *xAxis = self.lineChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.axisMinimum = -0.3;
    xAxis.granularity = 1.0;
    xAxis.drawAxisLineEnabled = YES;    //是否画x轴线
    xAxis.drawGridLinesEnabled = NO;   //是否画网格
    xAxis.gridLineDashLengths = @[@5.f, @5.f];
    
    self.lineData = [self setLineData];
    self.lineChartView.data = self.lineData;
}
- (LineChartData *)setLineData
{
    // 设置X轴数据
    NSArray *xValues = @[@"2016-10-28",
                         @"2016-11-20",
                         @"2016-11-27",
                         @"2016-12-04",
                         @"2016-12-25"];
    self.dateArray = [NSMutableArray arrayWithArray:xValues];
    if (xValues.count > 0) {
        _lineChartView.xAxis.axisMaximum = (double)xValues.count - 1 + 0.3;
        self.lineChartView.xAxis.valueFormatter = self;
//        self.lineChartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues];
        // 这里将代理赋值为一个类的对象, 该对象需要遵循IChartAxisValueFormatter协议, 并实现其代理方法(我们可以对需要显示的值进行各种处理, 这里对日期进行格式处理)(当然下面的各代理也都可以这样写)
    }

    // 设置折线数据
    // 这里模拟了3条折线
    NSArray *legendTitles = @[@"已入住", @"已出租", @"总工位数"];
    NSArray *statistics = @[
                            @[[NSNumber numberWithLong:255],
                              [NSNumber numberWithLong:355],
                              [NSNumber numberWithLong:477],
                              [NSNumber numberWithLong:578],
                              [NSNumber numberWithLong:798],
                              [NSNumber numberWithLong:800],
                              ],
                            @[[NSNumber numberWithLong:100],
                              [NSNumber numberWithLong:150],
                              [NSNumber numberWithLong:200],
                              [NSNumber numberWithLong:250],
                              [NSNumber numberWithLong:350],
                              [NSNumber numberWithLong:400],
                              ],
                            @[[NSNumber numberWithLong:500],
                              [NSNumber numberWithLong:600],
                              [NSNumber numberWithLong:700],
                              [NSNumber numberWithLong:800],
                              [NSNumber numberWithLong:1000],
                              [NSNumber numberWithLong:1200],
                              ]
                            ];
    NSArray *colors = @[[UIColor blueColor], [UIColor blackColor], [UIColor redColor]]; // 折线颜色数组
    NSMutableArray *dataSets = [[NSMutableArray alloc] init]; //数据集数组

    // 这样写的好处是, 无论你传多少条数据, 都可以处理展示
    for (int i = 0; i < statistics.count; i++) {
        // 循环创建数据集
        LineChartDataSet *set = [self drawLineWithArr:statistics[i]  title:legendTitles[i] color:colors[i]];
        if (set) {
            [dataSets addObject:set];
        }
    }

    // 赋值数据集数组
//    if (dataSets.count > 0) {
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//    }
    return data;
    
}
#pragma mark - 根据数据数组 title color 创建折线set
- (LineChartDataSet *)drawLineWithArr:(NSArray *)arr title:(NSString *)title color:(UIColor *)color {
    if (arr.count == 0) {
        return nil;
    }
    // 处理折线数据
    NSMutableArray *statistics = [NSMutableArray array];
    double leftAxisMin = 0;
    double leftAxisMax = 0;
    for (int i = 0; i < arr.count; i++) {
        NSNumber *num = arr[i];
        double value = [num doubleValue];
        leftAxisMax = MAX(value, leftAxisMax);
        leftAxisMin = MIN(value, leftAxisMin);
        [statistics addObject:[[ChartDataEntry alloc] initWithX:i y:value]];
    }
    CGFloat topNum = leftAxisMax * (5.0/4.0);
    _lineChartView.leftAxis.axisMaximum = topNum;
    if (leftAxisMin < 0) {
        CGFloat minNum = leftAxisMin * (5.0/4.0);
        _lineChartView.leftAxis.axisMinimum = minNum ;
    }

    // 设置Y轴数据
    _lineChartView.leftAxis.valueFormatter = self; //需要遵IChartAxisValueFormatter协议

    // 设置折线数据
    LineChartDataSet *set1 = nil;
    set1 = [[LineChartDataSet alloc] initWithValues:statistics label:title];
    set1.mode = LineChartModeCubicBezier;   // 弧度mode
    [set1 setColor:color];
    [set1 setCircleColor:color];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.valueColors = @[color];
    set1.valueFormatter = self; //需要遵循IChartValueFormatter协议
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    return set1;
}

#pragma mark - IChartValueFormatter delegate (折线值)
- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler {
//    if (self.yIsPercent) {
//        return [NSString stringWithFormat:@"%.2f%%", value];
//    }
    return [NSString stringWithFormat:@"%.f", value];
}

#pragma mark - IChartAxisValueFormatter delegate (y轴值) (x轴的值写在DateValueFormatter类里, 都是这个协议方法)
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
//    if (self.yIsPercent) {
//        return [NSString stringWithFormat:@"%.1f%%", value];
//    }
    if (value < 20) {
        int i = [[NSString stringWithFormat:@"%f", value] intValue];
        return [NSString stringWithFormat:@"%@", self.dateArray[i]];
    }
    if (ABS(value) > 1000) {
        return [NSString stringWithFormat:@"%.1fk", value/(double)1000];
    }

    return [NSString stringWithFormat:@"%.f", value];
}
- (void)dateButtonClick
{
    
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
