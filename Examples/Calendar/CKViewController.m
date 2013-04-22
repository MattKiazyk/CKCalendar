#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"

@interface CKViewController () <CKCalendarDelegate> {
    UIImage *dateImage;
}

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@end

@implementation CKViewController

- (id)init {
    self = [super init];
    if (self) {
        dateImage = [UIImage imageNamed:@"MCPh2_DateBox"];
        
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
        self.calendar = calendar;
        calendar.delegate = self;
        //calendar.dateFont = [UIFont fontWithName:@"Helvetica" size:12];
        calendar.dateBorderColor = [UIColor darkGrayColor];
        calendar.buttonMargin = 100;
        calendar.dayOfWeekFont = [UIFont fontWithName:@"Helvetica" size:10];
        
        [calendar setLeftMonthButtonImage:[UIImage imageNamed:@"MCPh2_CalendarLeftArrow"]];
        [calendar setRightMonthButtonImage:[UIImage imageNamed:@"MCPh2_CalendarRightArrow"]];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
        self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];

        self.disabledDates = @[
                [self.dateFormatter dateFromString:@"05/01/2013"],
                [self.dateFormatter dateFromString:@"06/01/2013"],
                [self.dateFormatter dateFromString:@"07/01/2013"]
        ];

        calendar.onlyShowCurrentMonth = NO;
        calendar.adaptHeightToNumberOfWeeksInMonth = NO;
        calendar.showPreviousMonthCellDetail = NO;

        [calendar setDayOfWeekBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarHeader"]]];
       // calendar.backgroundColor = [UIColor purpleColor];

        calendar.frame = CGRectMake(5, 10, 1004, 600);
        [self.view addSubview:calendar];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
        [self.view addSubview:self.dateLabel];

        self.view.backgroundColor = [UIColor whiteColor];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
        
   
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}
- (NSString *)getDay:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init] ;
    [dateFormatter setDateFormat:@"d"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}
#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    
    // TODO: play with the coloring if we want to...
//    if ([self dateIsDisabled:date]) {
//        dateItem.backgroundColor = [UIColor redColor];
//        dateItem.textColor = [UIColor whiteColor];
//    }
//    if ([[self getDay:date] length] == 1) {
//        dateItem.titleEdgeInsets = UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 6.0f);
//    } else {
//        dateItem.titleEdgeInsets = UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 2.0f);
//    }
//    
    dateItem.selectedBackgroundColor = [UIColor orangeColor];
    dateItem.backgroundImage = dateImage;
}
- (UIView *)viewforDate:(NSDate *)date {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [lbl setText:@"hello"];
    [lbl setTextColor:[UIColor greenColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    return lbl;
}
- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    return [date laterDate:self.minimumDate] == date;
}



@end