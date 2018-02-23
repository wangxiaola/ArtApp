//
//  FSCalendarWeekdayView.m
//  FSCalendar
//
//  Created by dingwenchao on 03/11/2016.
//  Copyright © 2016 wenchaoios. All rights reserved.
//

#import "FSCalendarWeekdayView.h"
#import "FSCalendar.h"
#import "FSCalendarDynamicHeader.h"
#import "FSCalendarExtensions.h"

@interface FSCalendarWeekdayView()

- (void)commonInit;

@end

@implementation FSCalendarWeekdayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:contentView];
    _contentView = contentView;
    [contentView setBackgroundColor:[UIColor colorWithRed:114/255. green:114/255. blue:114/255. alpha:1.f]];
    _weekdayLabels = [NSHashTable weakObjectsHashTable];
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        [weekdayLabel setTextColor:[UIColor colorWithRed:162/255. green:162/255. blue:162/255. alpha:1.f]];
        [self.contentView addSubview:weekdayLabel];
        [_weekdayLabels addObject:weekdayLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    CGFloat weekdayWidth = self.fs_width/self.weekdayLabels.count;
    [self.weekdayLabels.allObjects enumerateObjectsUsingBlock:^(UILabel *weekdayLabel, NSUInteger index, BOOL *stop) {
        weekdayLabel.frame = CGRectMake(index*weekdayWidth, 0, weekdayWidth, self.contentView.fs_height);
    }];
    
}

- (void)invalidateWeekdaySymbols
{
    BOOL useVeryShortWeekdaySymbols = (self.calendar.appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    NSArray *weekdaySymbols = useVeryShortWeekdaySymbols ? self.calendar.gregorian.veryShortStandaloneWeekdaySymbols : self.calendar.gregorian.shortStandaloneWeekdaySymbols;
    BOOL useDefaultWeekdayCase = (self.calendar.appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesDefaultCase;
    [self.weekdayLabels.allObjects enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        index += self.calendar.firstWeekday-1;
        index %= 7;
        label.text = useDefaultWeekdayCase ? weekdaySymbols[index] : [weekdaySymbols[index] uppercaseString];
    }];
}

- (void)setCalendar:(FSCalendar *)calendar
{
    _calendar = calendar;
    [self invalidateWeekdaySymbols];
    for (UILabel *label in self.weekdayLabels) {
        label.font = self.calendar.appearance.preferredWeekdayFont;
        label.textColor = self.calendar.appearance.weekdayTextColor;
    }
}

@end
