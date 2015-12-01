//
//  FruitsDetaitVC.h
//  TechFruits
//
//  Created by TaiND on 12/1/15.
//  Copyright (c) 2015 Toan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMRatingControl;
@class Fruits;

@interface FruitsDetaitVC : UIViewController
@property (nonatomic) Fruits *fruit;

@property (strong, nonatomic) IBOutlet UIImageView *fruitImage;
@property (strong, nonatomic) IBOutlet UITextField *fruitName;
@property (strong, nonatomic) IBOutlet UITextView *fruitNote;
@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (strong, nonatomic) IBOutlet AMRatingControl *ratingControl;

-(IBAction)didFinishEdittingFruit:(id)sender;

-(void)cancelAdd;
-(void)addNewFruit;
@end
