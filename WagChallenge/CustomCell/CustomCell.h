//
//  CustomCell.h
//  WagChallenge
//
//  Created by Yash Shankar1 on 6/7/18.
//  Copyright © 2018 Kelly Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverLabel;
@property (weak, nonatomic) IBOutlet UILabel *bronzeLabel;
@property (weak, nonatomic) IBOutlet UIView *goldRect;
@property (weak, nonatomic) IBOutlet UIView *silverRect;
@property (weak, nonatomic) IBOutlet UIView *bronzeRect;

@end
