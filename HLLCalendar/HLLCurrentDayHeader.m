//
//  HLLCurrentDayHeader.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "HLLCurrentDayHeader.h"
#import <Masonry.h>
#import "UIColor+Common.h"
#import "NSDate+Common.h"
#import "HLLEvent.h"

@interface HLLCurrentDayHeader ()

@property (nonatomic ,strong) UILabel * weekLabel;
@property (nonatomic ,strong) UILabel * dayLabel;

@property (nonatomic ,strong) UIView * sepLineView;
@property (nonatomic ,strong) UIView * extrudeView;
@end
@implementation HLLCurrentDayHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];//F3F4F4
        
        self.weekLabel = [UILabel new];
        self.weekLabel.text = [HLLWeekDay todayWeek];
        self.weekLabel.font = [UIFont systemFontOfSize:16];
        self.weekLabel.textColor = [UIColor blackColor];
        self.weekLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.weekLabel];
        
        self.sepLineView = [[UIView alloc] init];
        self.sepLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sepLineView];
        
        self.extrudeView = [UIView new];
        self.extrudeView.backgroundColor = [UIColor colorWithHexString:@"53B1D9"];
        self.extrudeView.layer.masksToBounds = YES;
        self.extrudeView.layer.cornerRadius = 15.0f;
        [self addSubview:self.extrudeView];
        
        self.dayLabel = [UILabel new];
        self.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] getDay]];
        self.dayLabel.font = [UIFont systemFontOfSize:17];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dayLabel];

    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(width * 0.4);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.weekLabel.mas_right);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.sepLineView.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.extrudeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(self.dayLabel.mas_centerY);
        make.centerX.mas_equalTo(self.dayLabel.mas_centerX);
    }];
}
@end
