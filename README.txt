user:tangzh (Tang, Zhang)


1. How to use to the app.

iHourly is an IOS app that can help you keep track of the time you spent everyday. It has three tabs: record, history and report.

In the record tab, you can either choose the project you are working on or create a new project. Click on the start button would begin the timer, and click it again would stop the timer. Anytime after you begin tracking your current activity, you can easily add any note by clicking the note button. Also, you can click on the photo button to use your camera to take a momentum picture. After you stop the timer, you would see an alert asking whether you want to store this record. Clicking on “OK” would save this record persistently and “Cancel” would discard the record.

In the history section, you can see all the records that you have been entering. You can see brief information of each record including the project name, the start time, stop time and time length. If you want to see more information about one record, you can tap on the record, and more information like added notes and photos would be shown. 

Also the order of history can be changed using the criterion that you care about. Choosing “Newest” would order the history from new to old. Choosing “Project” would group the history by different projects, and choosing “Longest” would order the records that you have spent most of the time. You can also delete one record by swiping left.

In the report section, it could give you more insight about how you have been spending your time by drawing an Pie Chart consisting of the projects entered. If you want to see a report during a certain time period, you can do so by clicking on “Filter” and choose the start time and end time, and it would give you a new pie chart based on the new time period.


2. Technical Implementation

Customized UIView SubClassand implement drawRect function.
NSTimer to HEAVY.
NSFileManager for storing data and adjust it to store persistent image.
UITabbarController with three customized icons.
UITextField with a UIPickerView as the input instead of keyboard.
UITableView (HEAVY) to display history records and record detail.
Customized table cells with dynamic height and could be deletable.
UISegmentationControl to change criterion for sorting history records.
UIImageView both for take pictures and display added photos for one record.
UIBezierPath (HEAVY) for drawing beautiful Pie Chart for report view as well as for notation rectangles.
Universal for both iPhone and iPad.
UIColor both for getting value from hex color value and get random color for Pie Chart.
Segue between different controllers including show and present modally.
MutilpleThread implementation both for storing and fetching image data.
UINavigationBar with customized color.
UIAlterController (Heavy) for creating new project, showing alert whether user wants to store one record and when user chooses the invalid start date and end date for filtering report data.
MobileCoreServices to access camera on device.
PickerView and DatePickerView.
UIScrollView for scrollable notationLabels display.
Customized class for record and filters to reuse models.

