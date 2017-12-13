//
//  TCServerMonitorViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerMonitorViewController.h"
#import "TCServerPerformanceRequest.h"
#import <WYChart/WYLineChartView.h>
#import <WYChart/WYChartCategory.h>
#import <WYChart/WYLineChartPoint.h>
#import <WYChart/WYLineChartCalculator.h>
#import "TCServerPerformance+CoreDataClass.h"
#import "TCServerCPU+CoreDataClass.h"
#import "NSString+Extension.h"

@interface TCServerMonitorViewController ()<WYLineChartViewDelegate,WYLineChartViewDatasource>
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, strong)   TCServerPerformance *performance;
@property (nonatomic, weak) IBOutlet    WYLineChartView     *cpuChartView;
@property (nonatomic, strong) NSMutableArray *cpuPoints;

@property (nonatomic, strong) UILabel *touchLabel;
@end

@implementation TCServerMonitorViewController

- (instancetype) initWithID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    _cpuChartView.backgroundColor = [UIColor clearColor];
    _cpuChartView.delegate = self;
    _cpuChartView.datasource = self;
    //_cpuChartView.clipsToBounds = YES;
    
    _cpuChartView.lineLeftMargin = 0;
    _cpuChartView.lineRightMargin = 0;
    _cpuChartView.lineTopMargin = 0;
    _cpuChartView.lineBottomMargin = 0;
    
    _cpuChartView.animationDuration = 1.0;
    _cpuChartView.animationStyle = kWYLineChartAnimationDrawing;
    _cpuChartView.scrollable = NO;
    _cpuChartView.pinchable = YES;
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:@[@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(1.0)]];
//    NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:@[@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0),@(0.0)]];
    [mutableArray addObject:tmpPoints];
    _cpuPoints = mutableArray;
    _cpuChartView.points = [NSArray arrayWithArray:_cpuPoints];
    
    _cpuChartView.touchPointColor = [UIColor redColor];
    _cpuChartView.labelsFont = [UIFont systemFontOfSize:12];
    
    _cpuChartView.verticalReferenceLineColor = [UIColor clearColor];
    _cpuChartView.horizontalRefernenceLineColor = [UIColor clearColor];
    UIColor *axisColor = [UIColor colorWithRed:102/255.0 green:112/255.0 blue:130/255.0 alpha:1.0];
    _cpuChartView.axisColor = axisColor;
    _cpuChartView.labelsColor = axisColor;
    
    _touchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _touchLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.3];
    _touchLabel.textColor = [UIColor blackColor];
    _touchLabel.layer.cornerRadius = 5;
    _touchLabel.layer.masksToBounds = YES;
    _touchLabel.textAlignment = NSTextAlignmentCenter;
    _touchLabel.font = [UIFont systemFontOfSize:12.f];
    _cpuChartView.touchView = _touchLabel;
    
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    __weak __typeof(self) weakSelf = self;
    TCServerPerformanceRequest *request = [[TCServerPerformanceRequest alloc] initWithServerID:_serverID type:0 startTime:startTime endTime:endTime];
    [request startWithSuccess:^(TCServerPerformance *performance) {
        NSLog(@"perfor:%@",performance);
        weakSelf.performance = performance;
        
        //重新计算cpu points
        [_cpuPoints removeAllObjects];
        NSMutableArray *rawPoints = [NSMutableArray new];
        for (int i = 0; i < performance.cpu.count; i++)
        {
            TCServerCPU *cpu = [performance.cpu objectAtIndex:i];
            [rawPoints addObject:@(cpu.percent.floatValue)];
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSArray *tmpPoints = [WYLineChartPoint pointsFromValueArray:rawPoints];
        [mutableArray addObject:tmpPoints];
        [_cpuPoints addObjectsFromArray:mutableArray];
        weakSelf.cpuChartView.points = [NSArray arrayWithArray:_cpuPoints];
        [weakSelf.cpuChartView updateGraph];
    } failure:^(NSString *message) {
        NSLog(@"message:%@",message);
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[_cpuChartView updateGraph];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - WYLineChartViewDelegate

- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    NSLog(@"_cpuPoints count:%ld",[_cpuPoints[0] count]);
    return [_cpuPoints[0] count];
}

- (NSInteger)numberOfLabelOnYAxisInLineChartView:(WYLineChartView *)chartView {
    return 8;
}

- (CGFloat)gapBetweenPointsHorizontalInLineChartView:(WYLineChartView *)chartView {
    return 0.0f;
}

- (NSInteger)numberOfReferenceLineVerticalInLineChartView:(WYLineChartView *)chartView {
    return [_cpuPoints[0] count];
}

- (NSInteger)numberOfReferenceLineHorizontalInLineChartView:(WYLineChartView *)chartView {
    //return 8;
    return [_cpuPoints[0] count];
}

- (void)lineChartView:(WYLineChartView *)lineView didBeganTouchAtSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didMovedTouchToSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //NSLog(@"changed move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didEndedTouchToSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //NSLog(@"ended move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didBeganPinchWithScale:(CGFloat)scale {
    
    //NSLog(@"begin pinch, scale : %f", scale);
}

- (void)lineChartView:(WYLineChartView *)lineView didChangedPinchWithScale:(CGFloat)scale {
    
    //NSLog(@"change pinch, scale : %f", scale);
}

- (void)lineChartView:(WYLineChartView *)lineView didEndedPinchGraphWithOption:(WYLineChartViewScaleOption)option scale:(CGFloat)scale {
    //NSLog(@"end pinch, scale : %f", scale);
}

#pragma mark - WYLineChartViewDatasource

- (NSString *)lineChartView:(WYLineChartView *)chartView contextTextForPointAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if((indexPath.row%3 != 0 && indexPath.section%2 != 0)
       || (indexPath.row%3 == 0 && indexPath.section%2 == 0)) return nil;
    
    NSArray *pointsArray = _cpuChartView.points[indexPath.section];
    WYLineChartPoint *point = pointsArray[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%lu", (NSInteger)point.value];
     */
    return nil;
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForXAxisLabelAtIndex:(NSInteger)index {
    if ( _performance && (index < _performance.cpu.count))
    {
        TCServerCPU *cpuItem = [_performance.cpu objectAtIndex:index];
        NSString *timeStr = [NSString timeStringFromInteger:cpuItem.created_time];
        NSLog(@"timeStr:%@ int:%ld",timeStr, cpuItem.created_time);
        return timeStr;
    }
    return [NSString stringWithFormat:@"%lu月", index+1];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToXAxisLabelAtIndex:(NSInteger)index {
    return _cpuPoints[0][index];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToVerticalReferenceLineAtIndex:(NSInteger)index {
    
    return _cpuPoints[0][index];
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForYAxisLabelAtIndex:(NSInteger)index {
    CGFloat maxValue = [self.cpuChartView.calculator maxValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    CGFloat minValue = [self.cpuChartView.calculator minValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.cpuChartView];
    NSLog(@"y point num:%ld",yPointNum);
    CGFloat interval = 5.0;
    if (yPointNum > 0)
    {
        interval = (maxValue - minValue) / yPointNum;
    }
    CGFloat value = minValue + interval * index;
    NSLog(@"value%ld:%.5f",index,value);
    return [NSString stringWithFormat:@"%.01f",value];
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToYAxisLabelAtIndex:(NSInteger)index {
    CGFloat maxValue = [self.cpuChartView.calculator maxValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    CGFloat minValue = [self.cpuChartView.calculator minValuePointsOfLinesPointSet:self.cpuChartView.points].value;
    NSInteger yPointNum = [self numberOfLabelOnYAxisInLineChartView:self.cpuChartView];
    CGFloat interval = 5.0;
    if (yPointNum > 0)
    {
        interval = (maxValue - minValue) / yPointNum;
    }
    CGFloat value = minValue + interval * index;
    NSLog(@"value%ld:%.5f",index,value);
    return value;
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToHorizontalReferenceLineAtIndex:(NSInteger)index {
    
    CGFloat value;
    switch (index) {
        case 0:
            value = [self.cpuChartView.calculator minValuePointsOfLinesPointSet:self.cpuChartView.points].value;
            break;
        case 1:
            value = [self.cpuChartView.calculator maxValuePointsOfLinesPointSet:self.cpuChartView.points].value;
            break;
        case 2:
            value = [self.cpuChartView.calculator calculateAverageForPointsSet:self.cpuChartView.points];
            break;
        default:
            break;
    }
    return value;
}

- (NSDictionary *)lineChartView:(WYLineChartView *)chartView attributesForLineAtIndex:(NSUInteger)index {
    NSLog(@"line chart view attributed line%ld",index);
    NSMutableDictionary *resultAttributes = [NSMutableDictionary dictionary];
    resultAttributes[kWYLineChartLineAttributeLineStyle] = @(kWYLineChartMainBezierWaveLine);
    resultAttributes[kWYLineChartLineAttributeDrawGradient] = @(true);
    resultAttributes[kWYLineChartLineAttributeJunctionStyle] = @(kWYLineChartJunctionShapeSolidCircle);
    
    UIColor *lineColor;
    lineColor = [UIColor colorWithRed:119/255.f green:215/255.f blue:220/255.f alpha:1.0];
    resultAttributes[kWYLineChartLineAttributeLineColor] = lineColor;
    resultAttributes[kWYLineChartLineAttributeJunctionColor] = lineColor;
    NSLog(@"result attributes:%@",resultAttributes);
    return resultAttributes;
}

@end
