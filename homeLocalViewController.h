//
//  homeLocalViewController.h
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 27/07/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "InSeasonViewController.h"

@interface homeLocalViewController : UIViewController

@property (strong, nonatomic) UIButton *startLocal;
@property (strong, nonatomic) UIImageView *backgroundImage;
@property (strong, nonatomic) UILabel *welcome;
@property (strong, nonatomic) UILabel *motto;
@property (strong, nonatomic) CAShapeLayer *circle;
@property (strong, nonatomic) UIColor *favColor;

@property (strong, nonatomic) InSeasonViewController *inSeasonVC;


-(IBAction)startLocalButtonDidTap:(id)sender;


@end
