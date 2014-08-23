//
//  homeLocalViewController.m
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 27/07/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//
// I have created this app to show the use of animation, filters, coredata, UIImageview, UITableview, UIWebview, NSURLConnection, macros

#import "homeLocalViewController.h"

#define RADIUS 38
#define RADIUS_LARGE 75


@interface homeLocalViewController ()

@end

@implementation homeLocalViewController

@synthesize startLocal, welcome, motto, circle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)startLocalButtonDidTap:(id)sender
{
    NSLog(@"start button was tapped!");
    
    self.inSeasonVC = [[InSeasonViewController alloc]initWithNibName:@"InSeasonViewController" bundle:nil];
    [self.navigationController pushViewController:self.inSeasonVC animated:YES];
    
}

-(void)createStartLocalButton
{
    
    startLocal = [UIButton buttonWithType:UIButtonTypeCustom];
    startLocal.frame = CGRectMake(124, 248, 72, 72);
    startLocal.layer.position = CGPointMake(CGRectGetMidX(self.view.frame),
                                            CGRectGetMidY(self.view.frame));
    
    [startLocal setBackgroundImage:[UIImage imageNamed:@"Green Leaves.jpg"] forState:UIControlStateNormal];
    [startLocal addTarget:self action:@selector(startLocalButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    startLocal.clipsToBounds = YES;
    startLocal.layer.cornerRadius = 72.0f/2.0f;
    startLocal.layer.borderColor = [UIColor whiteColor].CGColor;
    startLocal.layer.borderWidth = 2.0f;
    
    
    [self.view addSubview:startLocal];

}

-(void)createWelcomeLabel
{
    CGRect frame = CGRectMake(60, 100, 200, 50);
    welcome = [[UILabel alloc]initWithFrame:frame];
    welcome.text = @"IN SEASON";
    welcome.textColor = [UIColor whiteColor];
    welcome.font = [UIFont fontWithName:@"Papyrus" size:32];
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.lineBreakMode = NSLineBreakByWordWrapping;
    welcome.numberOfLines = 2;
    
    [self.view addSubview:welcome];
}

-(void)createMottoLabel
{
    CGRect frame = CGRectMake(0, 420, self.view.frame.size.width, 30);
    motto = [[UILabel alloc]initWithFrame:frame];
    motto.text = @"Forgaing For Food, Farms & Folk";
    motto.textColor = FAV_COLOR;
    motto.font = [UIFont fontWithName:@"Papyrus" size:20];
    motto.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:motto];
}

-(void)createCircleLayer
{
    //Add layer of single circle
    
    circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startLocal.bounds.origin.x,
                                                                     startLocal.bounds.origin.y,
                                                                     2.0 * RADIUS,
                                                                     2.0 * RADIUS)
                                                            cornerRadius:RADIUS].CGPath;
    
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-RADIUS,
                                  CGRectGetMidY(self.view.frame)-RADIUS);
    
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor whiteColor].CGColor;
    circle.lineWidth = 1.0f;
    
    [self.view.layer addSublayer:circle];
}

-(void)doCircleAnimation
{

    //Create path-scale animation, create opacity animation, create line width animation

    CGPathRef oldPath = circle.path;
    CGPathRef newPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startLocal.bounds.origin.x - RADIUS,
                                                                           startLocal.bounds.origin.y - RADIUS,
                                                                           2.0*RADIUS_LARGE,
                                                                           2.0*RADIUS_LARGE)
                                                                cornerRadius:RADIUS_LARGE].CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnimation.fromValue = (__bridge id)(oldPath);
    pathAnimation.toValue = (__bridge id)(newPath);
    pathAnimation.beginTime = 0.0f;
    pathAnimation.duration = 2.0;
    
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue   = [NSNumber numberWithFloat:1];
    alphaAnim.toValue     = [NSNumber numberWithFloat:0];
    alphaAnim.duration    = 2.0f;
    
    CABasicAnimation *lineWidthAnim = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnim.fromValue = @1.0f;
    lineWidthAnim.toValue = @15.0f;
    lineWidthAnim.duration = 2.0f;
    
    CAAnimationGroup *radiateAnimationGroup = [CAAnimationGroup animation];
    radiateAnimationGroup.duration = 2.0f;
    radiateAnimationGroup.repeatCount = HUGE_VALF;
    [radiateAnimationGroup setAnimations:@[pathAnimation, alphaAnim, lineWidthAnim]];
    
    [circle addAnimation:radiateAnimationGroup forKey:@"radiateAnimationGroup"];
    
}

-(void)createGradient
{
    CAGradientLayer *homeGradient = [CAGradientLayer layer];
    homeGradient.frame = self.view.frame;
    homeGradient.colors = [NSArray arrayWithObjects:(id)FAV_COLOR.CGColor, [UIColor yellowColor].CGColor, nil];
    [self.view.layer insertSublayer:homeGradient atIndex:0];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createGradient];
    [self createWelcomeLabel];
    [self createMottoLabel];
    [self createStartLocalButton];
    [self createCircleLayer];
    [self doCircleAnimation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
