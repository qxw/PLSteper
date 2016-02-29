//
//  ViewController.m
//  PLStepper-master
//
//  Created by LINEWIN on 16/2/29.
//  Copyright © 2016年 LINEWIN. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.plStepper addBlockForControlEvents:UIControlEventValueChanged block:^(PLStepper * sender) {
        NSLog(@"bbbb======== %ld",(long)sender.value);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.plStepper resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
