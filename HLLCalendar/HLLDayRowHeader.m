//
//  HLLDayRowHeader.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "HLLDayRowHeader.h"
#import <Masonry.h>
#import "UIColor+Common.h"
#import "HLLEvent.h"

@interface HLLDayRowHeader ()

@property (nonatomic ,strong) UILabel * weekLabel;
@property (nonatomic ,strong) UILabel * dayLabel;

@property (nonatomic ,strong) UIView * sepLineView;

@end
@implementation HLLDayRowHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        self.backgroundColor = [UIColor colorWithHexString:@"F3F4F4"];
        
        self.weekLabel = [UILabel new];
        self.weekLabel.text = @"周一";
        self.weekLabel.font = [UIFont systemFontOfSize:16];
        self.weekLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.weekLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.weekLabel];
        
        self.sepLineView = [[UIView alloc] init];
        self.sepLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sepLineView];
        
        self.dayLabel = [UILabel new];
        self.dayLabel.text = @"12";
        self.dayLabel.font = [UIFont systemFontOfSize:17];
        self.dayLabel.textColor = [UIColor colorWithHexString:@"999999"];
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
}

- (void)config:(HLLWeekDay *)weekDay{
    
    self.weekLabel.text = weekDay.week;
    self.dayLabel.text = weekDay.day;
}

@end
