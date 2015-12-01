//
//  FruitsDetaitVC.m
//  TechFruits
//
//  Created by TaiND on 12/1/15.
//  Copyright (c) 2015 Toan Lai. All rights reserved.
//

#import "FruitsDetaitVC.h"
#import "FruitsDetail.h"
#import "Fruits.h"
#import "AMRatingControl.h"

@interface FruitsDetaitVC ()<UITextFieldDelegate>

@end

@implementation FruitsDetaitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (!self.fruit) {
        self.fruit = [Fruits createEntity];
    }
    
    if (!self.fruit.fruitsDetail) {
        self.fruit.fruitsDetail = [FruitsDetail createEntity];
    }
    
    self.title = self.fruit.name ? self.fruit.name : @"New Fruit";
    self.fruitName.text = self.fruit.name;
    self.fruitNote.text = self.fruit.fruitsDetail.note;
    self.ratingControl.rating = [self.fruit.fruitsDetail.rating integerValue];
    
    [self.ratingView addSubview:self.ratingControl];
    
    if ([self.fruit.fruitsDetail.image length] >  0) {
        NSData *imageData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:self.fruit.fruitsDetail.image]];
        [self setImageForFruit:[UIImage imageWithData:imageData]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.fruitName resignFirstResponder];
    [self.fruitNote resignFirstResponder];
    
    [self saveContext];
}

#pragma mark - textfield
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.title = textField.text;
        self.fruit.name = textField.text;
    }
}

#pragma mark - handle
-(void)setImageForFruit:(UIImage*)img{
    self.fruitImage.image = img;
    self.fruitImage.backgroundColor = [UIColor clearColor];
}

-(void)cancelAdd{
    [self.fruit deleteEntity];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addNewFruit{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveContext{
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Success");
        }
        else{
            NSLog(@"Error: %@", error.description);
        }
    }];
}

-(IBAction)didFinishEdittingFruit:(id)sender{
    [self.fruitName resignFirstResponder];
}


@end
