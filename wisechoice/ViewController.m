//
//  ViewController.m
//  wisechoice
//
//  Created by boyu on 15/10/11.
//  Copyright © 2015年 boyu. All rights reserved.
//

#import "ViewController.h"
#import "CollectionReusableView.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

 }

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return 7;
    }else if (section==1){
        return 5;
    }else{
        return 3;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:101];
    UILabel *lable = (UILabel*)[cell viewWithTag:100];
    NSString *cardKey = [@"card" stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)indexPath.row+1]];
    UIImage *image = [UIImage imageNamed:cardKey];
    [imageView setImage:image];
    

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"creditcard" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *value = (NSString*)[data objectForKey:cardKey];
    [lable setText:value];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *rightView  = (UIImageView*)[cell viewWithTag:109];
    UIImageView *cardimageview = (UIImageView*)[cell viewWithTag:101];
    if ([rightView isHidden]) {
        rightView.hidden = NO;
        [[cardimageview layer] setBorderWidth:2.5f];
        [[cardimageview layer] setBorderColor:[[UIColor blackColor]CGColor]];

    }else{
        [[cardimageview layer] setBorderWidth:0.0f];
        [[cardimageview layer] setBorderColor:[[UIColor whiteColor]CGColor]];

        rightView.hidden = YES;
    }
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind==UICollectionElementKindSectionHeader) {
        CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if(indexPath.section == 0)
            [[headerView headerImageView] setImage:[UIImage imageNamed:@"bank_logo"]];
        else if(indexPath.section == 1)
            [headerView.headerImageView  setImage:[UIImage imageNamed:@"chase_logo"]];
        else
            headerView.headerImageView.image = [UIImage imageNamed:@"citi_logo.jpeg"];
        reusableview = headerView;
    }else if (kind==UICollectionElementKindSectionFooter){
        CollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        UIImageView * fooderImageView = footerView.fooderImageView;
        [self addline2footer:fooderImageView];
        reusableview = footerView;
    }
    
    
    return reusableview;
}
- (IBAction)showdetail:(id)sender {
    [self performSegueWithIdentifier:@"showdetail" sender:self];
}

- (void)addline2footer:(UIImageView*) footerImageView{
    UIGraphicsBeginImageContext(footerImageView.frame.size);
    [footerImageView.image drawInRect:CGRectMake(0, 0, footerImageView.frame.size.width, footerImageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.6);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),  0.8, 0.8, 0.8, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 20);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 321, 20);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    footerImageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier ] isEqualToString:@"showdetail"]){
//        DetailViewController *detailViewController = segue.destinationViewController;
//        detailViewController.selectCardname = self.selectCardname;
//        detailViewController.selectCarddetail = self.selectcarddetail;
    }
}


@end
