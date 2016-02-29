//
//  PLStepper.m
//  iOS-Core-Animation-Advanced-Techniques
//
//  Created by LINEWIN on 15/12/14.
//  Copyright © 2015年 gykj. All rights reserved.
//

#import "PLStepper.h"

#define KStepperWidth  100.0
#define KStepperHeight 30.0
#define KStepperTintColor   [UIColor colorWithRed:0 green:122/255.0 blue:255.0 alpha:1.0]
#define KStepperHighlightedColor [UIColor colorWithRed:1 green:0 blue:0.33 alpha:1]

@interface PLLongPressBtn : UIButton
@property(nonatomic,strong)UILongPressGestureRecognizer * longPressGesture;
@end

@implementation PLLongPressBtn

+(instancetype)defualtBtn{
    
    PLLongPressBtn * btn=[PLLongPressBtn buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:KStepperHighlightedColor forState:UIControlStateHighlighted];
    btn.titleLabel.font=[UIFont systemFontOfSize:20];
    
    return btn;
}

-(UILongPressGestureRecognizer *)longPressGesture{
    if(!_longPressGesture){
        _longPressGesture=[[UILongPressGestureRecognizer alloc]init];
        [self addGestureRecognizer:_longPressGesture];
    }
    return _longPressGesture;
}

@end

@interface PLTextField : UITextField
@end

@implementation PLTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(paste:)) return NO;
    if (action == @selector(select:)) return NO;
    if (action == @selector(selectAll:)) return NO;
    return [super canPerformAction:action withSender:sender];
}

@end


@interface PLStepper()<UITextFieldDelegate>
{
    NSInteger _repeatFlag;
    NSInteger _value;
}
@property(nonatomic,strong)PLLongPressBtn * leftBtn;
@property(nonatomic,strong)PLLongPressBtn * rightBtn;
@property(nonatomic,strong)PLTextField * numTf;
@end

IB_DESIGNABLE
@implementation PLStepper

+(id)alloc{
    
    NSLog(@"alloc ");
   return [super alloc];
}
-(id)init{
    NSLog(@" init");
    if(self=[super init]){
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        [self commonInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    if(self.frame.size.width <=0 || self.frame.size.height <=0){
        self.bounds=CGRectMake(0, 0, KStepperWidth , KStepperHeight);
    }
    
    _value=0;
    _stepValue=1;
    _minimumValue=0;
    _maximumValue=100;
    _autoRepeat=YES;
    
    [self.leftBtn.longPressGesture addTarget:self action:@selector(longPress:)];
    [self.rightBtn.longPressGesture addTarget:self action:@selector(longPress:)];
    
    [self setUpFrame:self.frame];
    [self addSubview:self.leftBtn];
    [self addSubview:self.numTf];
    [self addSubview:self.rightBtn];
    
    self.layer.cornerRadius=5.0;
    self.layer.borderWidth=1.0;
    self.layer.masksToBounds=YES;
    
    self.tintColor=KStepperTintColor;
    self.highlightColor=KStepperHighlightedColor;
    
    [self updateBtnStateWithValue:_value];
    
}

-(void)setUpFrame:(CGRect)frame{
    CGSize size=frame.size;
    self.leftBtn.frame=CGRectMake(0, 0, size.width * 0.3, size.height);
    self.numTf.frame=CGRectMake(CGRectGetMaxX(self.leftBtn.frame), 0, size.width*0.4, size.height);
    self.rightBtn.frame=CGRectMake(CGRectGetMaxX(self.numTf.frame), 0, size.width* 0.3, size.height);
}


#pragma mark - Response Methods
-(void)longPressBtnClicked:(PLLongPressBtn *)btn{
    
    [self changeValueWithDirection:(btn.tag==-147 ? -1 : 1)];
}

-(void)longPress:(UILongPressGestureRecognizer *)gesture{
    
    NSInteger direction= (gesture.view == self.rightBtn) ? 1 : -1;
    if(gesture.state ==UIGestureRecognizerStateBegan){
        _repeatFlag=1;
        [self startAutoRepeatWithDirection:direction];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled){
        _repeatFlag=0;
    }
    
    
}

-(void)startAutoRepeatWithDirection:(NSInteger)direction{
    
    UIButton * btn = direction==1 ? self.rightBtn:self.leftBtn;
    if(_repeatFlag==1){
        
        [btn setTitleColor:self.highlightColor forState:UIControlStateNormal];
        [self changeValueWithDirection:direction];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startAutoRepeatWithDirection:direction];
        });
    }
    else{
        [btn setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
    
}


-(void)changeValueWithDirection:(NSInteger)direction{
    
    NSInteger currentValue=self.value + (_stepValue *direction);
    (currentValue > self.maximumValue) ? currentValue = self.maximumValue : 0;
    (currentValue < self.minimumValue) ? currentValue = self.minimumValue : 0;
    
    self.numTf.text=[NSString stringWithFormat:@"%ld",currentValue];
    
    [self updateBtnStateWithValue:self.value];
    
    if((direction==1 && self.value >= self.maximumValue) || (direction==-1 && self.value <= self.minimumValue) ){
        _repeatFlag=0;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Getters & Setters
-(NSInteger)value{
    return [self.numTf.text integerValue];
}

-(void)setFrame:(CGRect)frame{
    [self setUpFrame:frame];
    [super setFrame:frame];
}

-(void)setAutoRepeat:(BOOL)autoRepeat{
    self.leftBtn.longPressGesture.enabled=autoRepeat;
    self.rightBtn.longPressGesture.enabled=autoRepeat;
}


-(void)setValue:(NSInteger)value{
    if(_value != value){
        _value=value;
        self.numTf.text=[NSString stringWithFormat:@"%ld",_value];
        [self updateBtnStateWithValue:_value];
    }
}

-(void)setStepValue:(NSInteger)stepValue{
    if(_stepValue !=stepValue){
        _stepValue=stepValue;
    }
}

-(void)setMinimumValue:(NSInteger)minimumValue{
    if(_minimumValue!=minimumValue){
        _minimumValue=minimumValue;
        [self updateBtnStateWithValue:_value];
        
    }
}

-(void)setMaximumValue:(NSInteger)maximumValue{
    if(_maximumValue!=maximumValue){
        _maximumValue=maximumValue;
        [self updateBtnStateWithValue:_value];
        
    }
}

-(void)setTintColor:(UIColor *)tintColor{
    if(_tintColor !=tintColor){
        _tintColor =tintColor;
        self.layer.borderColor =_tintColor.CGColor;
        [self setBtnsColor:_tintColor withState:UIControlStateNormal];
        self.numTf.layer.borderColor =_tintColor.CGColor;
    }
}

-(void)setContentColor:(UIColor *)contentColor{
    if(_contentColor != contentColor){
        _contentColor =contentColor;
        self.numTf.textColor=_contentColor;
    }
}

-(void)setHighlightColor:(UIColor *)highlightColor{
    if(_highlightColor != highlightColor){
        _highlightColor=highlightColor;
        [self setBtnsColor:_highlightColor withState:UIControlStateHighlighted];
    }
}

-(PLLongPressBtn *)leftBtn{
    if(!_leftBtn){
        _leftBtn=[PLLongPressBtn defualtBtn];
        [_leftBtn setTitle:@"－" forState:UIControlStateNormal];// +＋-－
        _leftBtn.tag=-147;
        [_leftBtn addTarget:self action:@selector(longPressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftBtn;
    
}

-(PLLongPressBtn *)rightBtn{
    if(!_rightBtn){
        _rightBtn =[PLLongPressBtn defualtBtn];
        [_rightBtn setTitle:@"＋" forState:UIControlStateNormal];
        _rightBtn.tag=-148;
        [_rightBtn addTarget:self action:@selector(longPressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
    
}

-(PLTextField *)numTf{
    if(!_numTf){
        _numTf=[PLTextField new];
        _numTf.borderStyle=UITextBorderStyleNone;
        _numTf.keyboardType=UIKeyboardTypeNumberPad;
        _numTf.backgroundColor=[UIColor whiteColor];
        _numTf.textAlignment=NSTextAlignmentCenter;
        _numTf.layer.borderColor=[KStepperTintColor CGColor];
        _numTf.layer.borderWidth=0.5;
        _numTf.text=@"0";
        _numTf.delegate=self;
        
    }
    return _numTf;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSString * currentStr=textField.text;
    if([string isEqualToString:@""]){
        if(textField.text.length > 1){
            currentStr=[currentStr substringToIndex:currentStr.length-1]  ;
        }
        else if (textField.text.length == 1){
            currentStr=@"";
        }
    }
    else{
        if([currentStr isEqualToString:@"0"]){
            return NO;
        }
    }
    currentStr=[currentStr stringByAppendingString:string];
    if(currentStr.integerValue > self.maximumValue || currentStr.integerValue < self.minimumValue){
        return NO;
    }
    else{
        [self updateBtnStateWithValue:currentStr.integerValue];
        return YES;
    }
}

#pragma mark - Other Methods

-(void)setBtnsColor:(UIColor *)color withState:(UIControlState)state{
    [self.leftBtn setTitleColor:color forState:state];
    [self.rightBtn setTitleColor:color forState:state];
}

-(void)updateBtnStateWithValue:(NSInteger)value{
    
    self.rightBtn.enabled = value < self.maximumValue;
    self.leftBtn.enabled = value > self.minimumValue;
}

-(void)invoke:(id)sender{
    if(_actionBk) _actionBk(sender);
}


-(BOOL)resignFirstResponder{
    [self.numTf resignFirstResponder];
    return [super resignFirstResponder];
}


- (void)addBlockForControlEvents:(UIControlEvents)controlEvents
                           block:(void (^)(PLStepper* sender))block{
    _actionBk=[block copy];
    [self addTarget:self action:@selector(invoke:) forControlEvents:controlEvents];
}

@end
