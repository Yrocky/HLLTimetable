//
//  CustomViewController.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "CustomViewController.h"
#import "HLLCollectionViewCalendarLayout.h"

#import "HLLEvent.h"

#import "HLLEventCell.h"
#import "HLLDayRowHeader.h"

#import "HLLCurrentDayHeader.h"
#import "HLLGridline.h"
#import "HLLSignHeader.h"

NSString * const EventCellReuseIdentifier = @"EventCellReuseIdentifier";
NSString * const DayRowHeaderReuseIdentifier = @"DayRowHeaderReuseIdentifier";

@interface CustomViewController ()<UICollectionViewDataSource,HLLCollectionViewDelegateCalendarLayout>

@property (nonatomic ,strong) NSArray * tempData;

@property (nonatomic ,strong) HLLCollectionViewCalendarLayout * layout;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation CustomViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tempEventData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // config layout
    self.layout = [[HLLCollectionViewCalendarLayout alloc] init];
    self.layout.delegate = self;
    self.layout.dayRowHeaderWidth = 120;
    self.layout.signHeaderHeight = 60;
    self.layout.stickySignHeader = YES;
    self.layout.contentMargin = UIEdgeInsetsZero;
    self.layout.sectionMargin = UIEdgeInsetsZero;
    
    // config collection view
    [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // regist
    [self.collectionView registerClass:[HLLEventCell class] forCellWithReuseIdentifier:EventCellReuseIdentifier];
    [self.collectionView registerClass:[HLLDayRowHeader class] forSupplementaryViewOfKind:HLLCollectionElementKindDayRowHeader withReuseIdentifier:DayRowHeaderReuseIdentifier];

    // layout regist
    [self.layout registerClass:[HLLGridline_Gray class] forDecorationViewOfKind:HLLCollectionElementKindHorizontalGridline];
    [self.layout registerClass:[HLLGridline_Gray class] forDecorationViewOfKind:HLLCollectionElementKindVerticalGridline];
    [self.layout registerClass:[HLLGridline_White class] forDecorationViewOfKind:HLLCollectionElementKindDayRowGridline];
    [self.layout registerClass:[HLLCurrentDayHeader class] forDecorationViewOfKind:HLLCollectionElementKindCurrentDayHeader];
    [self.layout registerClass:[HLLSignHeader class] forDecorationViewOfKind:HLLCollectionElementKindSignHeader];
    
    // invalidat layout cache
    [self.layout invalidateLayoutCache];
}

- (void) tempEventData{
    
    self.tempData = @[@[[HLLEvent finish]],
                      @[[HLLEvent living],[HLLEvent emptyEvent],[HLLEvent appotionment]],
                      @[[HLLEvent emptyEvent],[HLLEvent normal]],
                      @[[HLLEvent emptyEvent],[HLLEvent finish],[HLLEvent living]],
                      @[[HLLEvent emptyEvent],[HLLEvent normal],[HLLEvent emptyEvent],[HLLEvent living]],
                      @[[HLLEvent finish],[HLLEvent appotionment]],
                      @[[HLLEvent emptyEvent]]];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [HLLWeekDay weekDays].count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * datas = self.tempData[section];
    return datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HLLEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EventCellReuseIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    HLLEvent * event = self.tempData[indexPath.section][indexPath.row];
    [cell configCellWithData:event];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == HLLCollectionElementKindDayRowHeader) {
        HLLDayRowHeader *dayRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DayRowHeaderReuseIdentifier forIndexPath:indexPath];
        
        [dayRowHeader config:[HLLWeekDay weekDays][indexPath.section]];
        
        view = dayRowHeader;
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"indexPath:%@",indexPath);
}

#pragma mark -
#pragma mark HLLCollectionViewDelegateCalendarLayout

- (NSInteger)currentDayIndex{

    return [HLLWeekDay todayIndex];
}


@end
