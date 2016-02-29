//
//  PLStepper.h
//  iOS-Core-Animation-Advanced-Techniques
//
//  Created by LINEWIN on 15/12/14.
//  Copyright © 2015年 gykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLStepper : UIControl

typedef void(^ActionBlock)(PLStepper * sender);

#ifndef IBInspectable
#define IBInspectable
#endif

@property(nonatomic,strong)IBInspectable UIColor * tintColor;
@property(nonatomic,strong)IBInspectable UIColor * highlightColor;
@property(nonatomic,strong)IBInspectable UIColor * contentColor;

@property(nonatomic)IBInspectable NSInteger value;                        // default is 0 sends UIControlEventValueChanged. clamped to min/max
@property(nonatomic)IBInspectable NSInteger minimumValue;                 // default 0 must be less than maximumValue
@property(nonatomic)IBInspectable NSInteger maximumValue;                 // default 100 must be greater than minimumValue
@property(nonatomic)IBInspectable NSInteger stepValue;                    // default 1 must be greater than 0

@property(nonatomic,assign)IBInspectable BOOL autoRepeat;



@property(nonatomic,copy)ActionBlock actionBk;

-(BOOL)resignFirstResponder;

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents
                           block:(void (^)(PLStepper * sender))block;

@end
