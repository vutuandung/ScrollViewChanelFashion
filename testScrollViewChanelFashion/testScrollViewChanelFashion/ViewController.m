//
//  ViewController.m
//  testScrollViewChanelFashion
//
//  Created by Tuan Dung on 12/21/15.
//  Copyright © 2015 Tuan Dung. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+WebCache.h>

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define HeightUnSelectedRow         100
#define BotSelectedRow              270

@interface ViewController () {
    float oldHeightView0;
    float oldHeightView1;
    float oldHeightView2;
    float oldHeightView3;
    NSInteger selectedIndex;
    NSArray *allViews;
    NSArray *allImageViews;
    
    NSArray *arrayData;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.contraintHeightView1.constant = SCREEN_HEIGHT - BotSelectedRow;
//    arrayData = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];
    arrayData = @[@"http://stuffpoint.com/nature/image/371042-nature-autumns-natural-beauty.jpg",
                  @"https://s-media-cache-ak0.pinimg.com/736x/60/b7/01/60b7019827cf8f7affd921f02793adf0.jpg",
                  @"http://www.bluesunhotels.com/EasyEdit/UserFiles/PageImages/natural-beauty-of-croatia/natural-beauty-of-croatia-635350572813900157-5_570_320.jpeg",
                  @"http://pinnest.net/newpinnest/wp-content/uploads/2013/08/13772501252d1a5.jpg",
                  @"https://image.freepik.com/free-photo/natural-beauty-of-hidden-lake-gardens--plants--trees_19-107081.jpg",
                  @"http://images.all-free-download.com/images/graphiclarge/nature_555955.jpg",
                  @"http://media-cdn.tripadvisor.com/media/photo-s/01/5f/fd/59/natural-beauty.jpg",
                  @"http://full.creative.touchtalent.com/natural-beauty-of-mountain-roses-8545.jpg"];
    allViews = @[self.view1, self.view2, self.view3, self.view4, self.view5];
    allImageViews = @[self.imageView1, self.imageView2, self.imageView3, self.imageView4, self.imageView5];
    
    for (int i = 0; i < allViews.count; i++) {
        UIImageView *imageView = allImageViews[i];
//        imageView.image= [UIImage imageNamed:arrayData[i]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrayData[i]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)move:(id)sender {
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    static BOOL isScrollDown2Rows = NO;
    static BOOL isScrollUp2Rows = NO;
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        oldHeightView0 = self.contraintHeightView0.constant;
        oldHeightView1 = self.contraintHeightView1.constant;
        oldHeightView2 = self.contraintHeightView2.constant;
        oldHeightView3 = self.contraintHeightView3.constant;
        
        [self updateViews];
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        NSLog(@"%@", NSStringFromCGPoint(translatedPoint));
        if (translatedPoint.y + HeightUnSelectedRow > SCREEN_HEIGHT - BotSelectedRow) {
            NSLog(@"xxx");
        }
        if (translatedPoint.y < 0) { // scroll DOWN
            if (selectedIndex < arrayData.count - 1) {
                self.contraintHeightView1.constant = oldHeightView1 + translatedPoint.y;
                self.contraintHeightView2.constant = oldHeightView2 - translatedPoint.y > SCREEN_HEIGHT - BotSelectedRow ? SCREEN_HEIGHT - BotSelectedRow : oldHeightView2 - translatedPoint.y;
                
                // scroll 2 rows
                if (self.contraintHeightView1.constant <= 0) {
                    isScrollDown2Rows = YES;
                    self.contraintHeightView2.constant = SCREEN_HEIGHT - BotSelectedRow + self.contraintHeightView1.constant;
                    self.contraintHeightView3.constant = oldHeightView3 - self.contraintHeightView1.constant;
                }
            }
            else {
                self.contraintHeightView1.constant = oldHeightView1 + translatedPoint.y / 8;
            }
        }
        else { // scroll UP
            if (selectedIndex > 0){
                self.contraintHeightView0.constant = oldHeightView0 + translatedPoint.y;
                self.contraintHeightView1.constant = oldHeightView1 - translatedPoint.y < HeightUnSelectedRow ? HeightUnSelectedRow : oldHeightView1 - translatedPoint.y;
                
                // scroll 2 rows
                if (self.contraintHeightView0.constant > SCREEN_HEIGHT - BotSelectedRow) {
                    isScrollUp2Rows = YES;
                    if (selectedIndex == 1) {
                        self.contraintHeightView_1.constant = (self.contraintHeightView0.constant - (SCREEN_HEIGHT - BotSelectedRow)) / 8;
                        self.contraintHeightView0.constant = SCREEN_HEIGHT - BotSelectedRow;
                    } else {
                        self.contraintHeightView0.constant = 2 * (SCREEN_HEIGHT - BotSelectedRow) - self.contraintHeightView0.constant;
                        self.contraintHeightView_1.constant = SCREEN_HEIGHT - BotSelectedRow - self.contraintHeightView0.constant;
                    }
                }
            }
            else {
                self.contraintHeightView0.constant = oldHeightView0 + translatedPoint.y / 8;
            }
        }
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.25 animations:^{
            
            if (translatedPoint.y < 0) { // scroll DOWN
                if (selectedIndex < arrayData.count - 1) {
                    self.contraintHeightView1.constant = 0;
                    self.contraintHeightView2.constant = SCREEN_HEIGHT - BotSelectedRow;
                    self.contraintHeightView3.constant = HeightUnSelectedRow;
                    
                    if (isScrollDown2Rows && selectedIndex < arrayData.count - 2) {
                        self.contraintHeightView2.constant = 0;
                        self.contraintHeightView3.constant = SCREEN_HEIGHT - BotSelectedRow;
                    }
                }
                else {
                    self.contraintHeightView1.constant = SCREEN_HEIGHT - BotSelectedRow;
                }
            }
            else { // scroll UP
                if (selectedIndex > 0){
                    self.contraintHeightView0.constant = SCREEN_HEIGHT - BotSelectedRow;
                    self.contraintHeightView1.constant = HeightUnSelectedRow;
                    self.contraintHeightView2.constant = HeightUnSelectedRow;
                    
                    if (isScrollUp2Rows && selectedIndex > 1) {
                        self.contraintHeightView_1.constant = SCREEN_HEIGHT - BotSelectedRow;
                        self.contraintHeightView0.constant = HeightUnSelectedRow;
                    } else if (isScrollUp2Rows && selectedIndex == 1) {
                        self.contraintHeightView_1.constant = 0;
                        self.contraintHeightView0.constant = SCREEN_HEIGHT - BotSelectedRow;
                    }
                }
                else {
                    self.contraintHeightView0.constant = 0;
                }
            }
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            // scroll DOWN
            if (translatedPoint.y < 0 && selectedIndex < arrayData.count - 1) {
                if (isScrollDown2Rows && selectedIndex < arrayData.count - 2) {
                    selectedIndex += 2;
                } else {
                    selectedIndex++;
                }
                isScrollDown2Rows = NO;
                [self reloadData];
            }
            
            // scroll UP
            if (translatedPoint.y > 0 && selectedIndex > 0) {
                if (isScrollUp2Rows && selectedIndex > 1) {
                    selectedIndex -= 2;
                } else {
                    selectedIndex--;
                }
                isScrollDown2Rows = NO;
                [self reloadData];
            }
            [self updateViews];
            
            self.contraintHeightView_1.constant = 0;
            self.contraintHeightView0.constant = 0;
            self.contraintHeightView1.constant = SCREEN_HEIGHT - BotSelectedRow;
            self.contraintHeightView2.constant = HeightUnSelectedRow;
            self.contraintHeightView3.constant = HeightUnSelectedRow;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) reloadData{
    NSLog(@"%ld", selectedIndex);
    
    if (selectedIndex > 0) {
//        self.imageView0.image= [UIImage imageNamed:arrayData[(selectedIndex - 1 < 0 ? 0 : selectedIndex - 1)]];
        [self.imageView0 sd_setImageWithURL:[NSURL URLWithString:arrayData[(selectedIndex - 1 < 0 ? 0 : selectedIndex - 1)]]];
    }
    else {
        self.imageView0.image = nil;
    }
    if (selectedIndex > 1) {
//        self.imageView_1.image= [UIImage imageNamed:arrayData[(selectedIndex - 2 < 0 ? 0 : selectedIndex - 2)]];
        [self.imageView_1 sd_setImageWithURL:[NSURL URLWithString:arrayData[(selectedIndex - 2 < 0 ? 0 : selectedIndex - 2)]]];
    }
    else {
        self.imageView_1.image = nil;
    }
    for (NSInteger i = 0; i < allViews.count; i++) {
        NSInteger index = i + selectedIndex < arrayData.count ? i + selectedIndex : arrayData.count - 1;
        UIImageView *imageView = allImageViews[i];
//        imageView.image= [UIImage imageNamed:arrayData[index]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrayData[index]]];
    }
}

- (void) updateViews{
    for (int i = 1; i < allViews.count; i++) {
        if (i + selectedIndex >= arrayData.count) {
            ((UIView *)allViews[i]).hidden = YES;
        }
        else {
            ((UIView *)allViews[i]).hidden = NO;
        }
    }
}

@end
