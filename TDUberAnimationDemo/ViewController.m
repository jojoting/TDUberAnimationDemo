//
//  ViewController.m
//  TDUberAnimationDemo
//
//  Created by jojo on 16/8/11.
//  Copyright © 2016年 jojo. All rights reserved.
//

#import "ViewController.h"
#import "TDUberLogoView.h"
#import "TDGlobal.h"

#define kScrrenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = defaultColor;
    
    CGFloat logoViewWith = 60;
    TDUberLogoView *uberLogoView = [[TDUberLogoView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 40, self.view.frame.size.height / 2 - 40,logoViewWith, logoViewWith)];
//    uberLogoView.layer.borderWidth = 1.f;
    
    [self.view addSubview:uberLogoView];
    [uberLogoView startAnimation];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
