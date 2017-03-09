//
//  HLLCollectionViewCalendarLayout.h
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLLCollectionViewDelegateCalendarLayout;

extern NSString * const HLLCollectionElementKindSignHeader;
extern NSString * const HLLCollectionElementKindDayRowHeader;
extern NSString * const HLLCollectionElementKindDayRowGridline;
extern NSString * const HLLCollectionElementKindCurrentDayHeader;
extern NSString * const HLLCollectionElementKindVerticalGridline;
extern NSString * const HLLCollectionElementKindHorizontalGridline;

@interface HLLCollectionViewCalendarLayout : UICollectionViewLayout

@property (nonatomic ,weak) id<HLLCollectionViewDelegateCalendarLayout> delegate;

@property (nonatomic) CGFloat sectionWidth;
@property (nonatomic) CGFloat dayRowHeaderWidth;
@property (nonatomic) CGFloat dayRowHeaderHeight;
@property (nonatomic) CGFloat horizontalGridlineHeight;// default 1
@property (nonatomic) CGFloat verticalGridlineWidth;// default 1
@property (nonatomic) UIEdgeInsets sectionMargin;
@property (nonatomic) UIEdgeInsets contentMargin;
@property (nonatomic) UIEdgeInsets cellMargin;

@property (nonatomic) BOOL stickySignHeader;// default YES
@property (nonatomic) CGFloat signHeaderHeight;// default 80

- (void) invalidateLayoutCache;
@end

@protocol HLLCollectionViewDelegateCalendarLayout <UICollectionViewDelegate>

- (NSInteger) currentDayIndex;

@end
