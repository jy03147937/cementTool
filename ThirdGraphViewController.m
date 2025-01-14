//
//  ThirdGraphViewController.m
//  cementTool
//
//  Created by AOCC2013 on 13-2-27.
//  Copyright (c) 2013年 aocc. All rights reserved.
//

#import "ThirdGraphViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "ZoomInThirdGraphViewController.h"

@interface ThirdGraphViewController ()

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView_s3;
@property (nonatomic, strong) CPTBarPlot *clinkerSHC;

-(void)initPlot_s3;
-(void)configureGraph_s3;
-(void)configurePlots_s3;
-(void)configureAxes_s3;
-(NSString*)numberTransfer:(float)number;

@end



@implementation ThirdGraphViewController

CGFloat const CPDBarWidth_s3 = 0.5f;
CGFloat const CPDBarInitialX_s3 = 0.93f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initPlot_s3];
}

-(NSString*)numberTransfer:(float)number
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    int temp = number;
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInt:temp]];
    return numberString;
}

#pragma mark - Chart behavior
-(void)initPlot_s3 {
    [self configureGraph_s3];
    [self configurePlots_s3];
    [self configureAxes_s3];
}


- (NSArray *)SPCValue
{
    NSArray *values = nil;
    if (!values)
    {
        values = [NSArray arrayWithObjects:
                  [NSDecimalNumber numberWithFloat:self.intAdvancedClinkerSHC_s],
                  [NSDecimalNumber numberWithFloat:self.achievableClinkerSHC_s],
                  [NSDecimalNumber numberWithFloat:self.actualClinkerSHC_s],
                  nil];
    }
    return values;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"zoomIn"]) {
        ZoomInThirdGraphViewController *destViewController = segue.destinationViewController;
        destViewController.actualSHC = self.actualClinkerSHC_s;
        destViewController.achievableSHC = self.achievableClinkerSHC_s;
        destViewController.intAdvancedSHC = self.intAdvancedClinkerSHC_s;
        destViewController.maximumAnnualSavingsOnHeatConsumptionfromClinkerProduction = self.maximumAnnualSavingsOnHeatConsumptionfromClinkerProduction_s;
        destViewController.maximumAnnualSavingsOnHeatCostfromClinkerProduction = self.maximumAnnualSavingsOnHeatCostfromClinkerProduction_s;
        destViewController.achievableAnnualSavingsOnHeatConsumptionfromClinkerProduction = self.achievableAnnualSavingsOnHeatConsumptionfromClinkerProduction_s;
        destViewController.achievableAnnualSavingsOnHeatCostfromClinkerProduction = self.achievableAnnualSavingsOnHeatCostfromClinkerProduction_s;
        destViewController.name = self.name_s;
        destViewController.selectedCurrency = self.selectedCurrency;
    }
}


-(void)configureGraph_s3 {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView_s3.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView_s3.hostedGraph = graph;
    // 2 - Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    graph.fill = [CPTFill fillWithColor:[Constant defineGraghBackgroundColor]];   //background color
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[Constant defineGraghBackgroundColor]];    //background color
    graph.paddingBottom = 105.0f;
    graph.paddingLeft  = 50.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingRight  = -10.0f;  //图表到边界的距离.之所以把值设为负值，其原因是图的上边与右边有白线，十分不美观，为了隐藏他们
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [Constant defineAxisLineTitleColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    // 4 - Set up title
    NSString *title = @"Clinker SHC";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(-20.0f, -25.0f);   //graph的title的位置
    // 5 - Set up plot space
    CGFloat height = self.actualClinkerSHC_s;
    CGFloat xMin = 0.0f;
    CGFloat xMax = 4.0f;   //3个数据点
    CGFloat yMin = 0.0f;
    CGFloat yMax = 1000.0f+self.actualClinkerSHC_s*1.3;
    //yMax = self.actualFGSPC_s2*1.2;// should determine dynamically based on max price
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

-(void)configurePlots_s3 {
    // 1 - Set up the three plots
    self.clinkerSHC = [CPTBarPlot tubularBarPlotWithColor:[CPTColor cyanColor] horizontalBars:NO];
    self.clinkerSHC.identifier = @"clinkerSHC";
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.8;
    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView_s3.hostedGraph;
    CGFloat barX = CPDBarInitialX_s3;
    NSArray *plots = [NSArray arrayWithObjects:self.clinkerSHC, nil];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth_s3);
        plot.barOffset = CPTDecimalFromDouble(barX);     //BAR的水平位置
        plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += CPDBarWidth_s3;
    }
}


-(void)configureAxes_s3 {
    // 1 - Configure styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [Constant defineAxisLineTitleColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 11.0f;
    CPTMutableTextStyle *yaxisTitleStyle = [CPTMutableTextStyle textStyle];
    yaxisTitleStyle.color = [Constant defineAxisLineTitleColor];
    yaxisTitleStyle.fontName = @"Helvetica-Bold";
    yaxisTitleStyle.fontSize = 13.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 3.0f;
    axisLineStyle.lineColor = [[Constant defineAxisLineTitleColor] colorWithAlphaComponent:1];
    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView_s3.hostedGraph.axisSet;
    // 3 - Configure the x-axis
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    if (self.actualClinkerSHC_s < self.achievableClinkerSHC_s) {
    axisSet.xAxis.title = [[[NSString alloc] initWithFormat:@"\nInt. Advanced:              %.1f  KJ/t.clinker\nAchievable Target:       %.1f  KJ/t.clinker\nActual:                           %.1f  KJ/t.clinker\nTarget Savings:            %@  Currency/a",self.intAdvancedClinkerSHC_s,(self.intAdvancedClinkerSHC_s+self.actualClinkerSHC_s)/2,self.actualClinkerSHC_s,[self numberTransfer:self.maximumAnnualSavingsOnHeatCostfromClinkerProduction_s/2]] stringByReplacingOccurrencesOfString:@"Currency" withString:self.selectedCurrency];
    }
    else{
    axisSet.xAxis.title = [[[NSString alloc] initWithFormat:@"\nInt. Advanced:              %.1f  KJ/t.clinker\nAchievable Target:       %.1f  KJ/t.clinker\nActual:                           %.1f  KJ/t.clinker\nTarget Savings:            %@  Currency/a",self.intAdvancedClinkerSHC_s,self.achievableClinkerSHC_s,self.actualClinkerSHC_s,[self numberTransfer:self.achievableAnnualSavingsOnHeatCostfromClinkerProduction_s]] stringByReplacingOccurrencesOfString:@"Currency" withString:self.selectedCurrency];
    }
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 20.0f;             //y坐标title的垂直坐标
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    // 4 - Configure the y-axis
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    axisSet.yAxis.title = @"";
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.titleOffset = 5.0f;              //y坐标title的垂直坐标
    axisSet.yAxis.axisLineStyle = axisLineStyle;
    
#pragma mark -  x与y坐标的刻度设置
    // 1 - Create styles
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [Constant defineAxisLineTitleColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 6.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [Constant defineAxisLineTitleColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [Constant defineAxisLineTitleColor];
    tickLineStyle.lineWidth = 1.0f;
    // 3 - Configure x-axis tick
    axisSet.xAxis.majorTickLineStyle = axisLineStyle;
    axisSet.xAxis.majorTickLength = 4.0f;
    axisSet.xAxis.tickDirection = CPTSignNegative;
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:3];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:3];
    NSArray *labels = [[NSArray alloc] initWithObjects:@"Int. Advanced",@"Achievable",self.name_s,nil];
    // 4 - Configure y-axis tick
    axisSet.yAxis.majorTickLineStyle = axisLineStyle;
    axisSet.yAxis.labelTextStyle = yaxisTitleStyle;

    
    for (NSInteger i = 0; i<3; i++) {
        axisSet.xAxis.labelTextStyle = axisTitleStyle;
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[labels objectAtIndex:i]  textStyle:axisSet.xAxis.labelTextStyle];
        CGFloat location = i+1;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = axisSet.xAxis.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    axisSet.xAxis.axisLabels = xLabels;
    axisSet.xAxis.majorTickLocations = xLocations;
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 3;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (fieldEnum == CPTBarPlotFieldBarTip)
    {
        return [[self SPCValue] objectAtIndex:index];
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float)trans:(float)RGB{
    return RGB/255.0;
}

//协议方法，为每一个Bar赋予不同的颜色
-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index;{
    switch (index) {
        case 0:
        {
            CPTFill *bar1 = [CPTFill fillWithColor:[Constant defineBar1Color]];
            return bar1;
            break;
        }
        case 1:
        {
            CPTFill *bar1 = [CPTFill fillWithColor:[Constant defineBar2Color]];
            return bar1;
            break;
        }
        case 2:
        {
            CPTFill *bar1 = [CPTFill fillWithColor:[Constant defineBar3Color]];
            return bar1;
            break;
        }
        default:
            break;
    }
    return nil;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot
                  recordIndex:(NSUInteger)index {
    switch (index) {
        case 0:
        {
            CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
            textStyle.color = [Constant defineAxisLineTitleColor];
            textStyle.fontSize = 13.0f;
            textStyle.fontName = @"Helvetica-Bold";
            float ff = [[[self SPCValue] objectAtIndex:index] floatValue];
            NSString *tt = [[NSString alloc] initWithFormat:@"%.1f",ff];
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:tt style:textStyle];
            return textLayer;
            break;
        }
        case 1:
        {
            CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
            textStyle.color = [Constant defineAxisLineTitleColor];
            textStyle.fontSize = 13.0f;
            textStyle.fontName = @"Helvetica-Bold";
            float ff = [[[self SPCValue] objectAtIndex:index] floatValue];
            NSString *tt = [[NSString alloc] initWithFormat:@"%.1f",ff];
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:tt style:textStyle];
            return textLayer;
            break;
        }
        case 2:
        {
            CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
            textStyle.color = [Constant defineAxisLineTitleColor];
            textStyle.fontSize = 13.0f;
            textStyle.fontName = @"Helvetica-Bold";
            float ff = [[[self SPCValue] objectAtIndex:index] floatValue];
            NSString *tt = [[NSString alloc] initWithFormat:@"%.1f",ff];
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:tt style:textStyle];
            return textLayer;
            break;
        }
        default:
            break;
    }
}

@end
