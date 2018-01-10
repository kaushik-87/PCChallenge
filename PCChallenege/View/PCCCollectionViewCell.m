//
//  PCCCollectionViewCell.m
//  PCChallenege
//
//  Created by Kaushik on 1/7/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCCCollectionViewCell.h"
#import "PCCImageService.h"

@interface PCCCollectionViewCell()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIStackView *descriptionStackView;
@property (nonatomic, assign) PCCCollectionViewCellType cellType;

@end

@implementation PCCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height- (self.frame.size.height*40/100))];
    _descriptionStackView = [[UIStackView alloc]initWithFrame:CGRectMake(0, 0+self.imageView.frame.size.height, self.frame.size.width, self.frame.size.height- self.imageView.frame.size.height)];
    
    _title = [UILabel new];
    _descriptionLabel = [UILabel new];
    
    //Configure the UILabels for title and description.
    [self.descriptionLabel setNumberOfLines:2];
    [self.descriptionLabel setTextAlignment:NSTextAlignmentLeft];
    [self.descriptionLabel setAllowsDefaultTighteningForTruncation:NO];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];

    [self.title setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
    [self.title setNumberOfLines:2];
    [self.title setTextAlignment:NSTextAlignmentLeft];
    [self.title setAllowsDefaultTighteningForTruncation:NO];
    [self.title setLineBreakMode:NSLineBreakByTruncatingTail];
    
    //Using the Stackview to add two vertical labels. This way the hiding and unhide of one label can be handled gracefully.
    [self.descriptionStackView addArrangedSubview:self.title];
    [self.descriptionStackView addArrangedSubview:self.descriptionLabel];
    [self.descriptionStackView setAxis:UILayoutConstraintAxisVertical];
    [self addSubview:_imageView];
    [self addSubview:_descriptionStackView];
    
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setClipsToBounds:YES];
    
    [self.imageView setBackgroundColor:[UIColor clearColor]];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [self.layer setBorderWidth:1.0];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    
    //Below we are setting the constraints for each view component in the Cell.
    NSDictionary *viewsDictionary = @{@"imageView":self.imageView,@"title":self.title,@"description":self.descriptionLabel, @"stackview":self.descriptionStackView};
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionStackView.translatesAutoresizingMaskIntoConstraints = NO;

    //Setting the constraint for the image equal to cell width.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1.0
                                                       constant:0]];
    //Horizontal spacing for the stackview
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[stackview]-14-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];

    //Image height is set as 70% of the parent view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.70
                                                      constant:0]];
    
    // Description label is 60 % height of the total stackview.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.descriptionStackView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.60
                                                      constant:0]];
    
    //Setting the vertical spacing of the imageview and stackview
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView][stackview]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
}

- (void)setCellType:(PCCCollectionViewCellType)type forItem:(PCCItem *)item {
    self.cellType = type;
    [self setUpViewStyle];
    [self layoutSubviews];
    [self loadViewForItem:item];
}

- (void)setUpViewStyle{

    if (self.cellType == kCellItemType) {
        [self.descriptionLabel setHidden:YES];
    }else{
        [self.descriptionLabel setHidden:NO];
    }
}


- (void)loadViewForItem:(PCCItem*)item{
    [self.title setText:item.title];
    __weak PCCCollectionViewCell *weakCell = self;
    if(self.cellType == kCellHeaderType) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSAttributedString *attributedString = [[NSAttributedString alloc]initWithData:[item.itemDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                   options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                        documentAttributes:nil
                                                                                     error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *dateString = [PCCCollectionViewCell formattedDateString:item.publicationDate];
                NSMutableAttributedString *description = [[NSMutableAttributedString alloc] init];
                UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                            forKey:NSFontAttributeName];
                
                NSAttributedString *dateAttributedString = [[NSAttributedString alloc]initWithString:dateString
                                                                                          attributes:attrsDictionary];
                [description appendAttributedString:dateAttributedString];
                [description appendAttributedString:attributedString];
                [weakCell.descriptionLabel setAttributedText:description];
            });
        });
    }

    [[PCCImageService sharedService] getItemImage:[item.mediaContentInfo objectForKey:@"url"] completion:^(UIImage *image) {
        [weakCell.imageView setImage:image];
    }];
    
}

+(NSString *)formattedDateString:(NSString*)itemDateString{
    NSString *str =itemDateString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"E, d MMM yyyy HH:mm:ss Z"];
    NSDate *date = [formatter dateFromString:str];
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;

    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *dateString = [NSString stringWithFormat:@"%@ - ",[dateFormatter stringFromDate:date]];
    
    return dateString;
}

@end
