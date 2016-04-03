# TimeScape
Business dates calendar.

The following solution covers methodology of creation time dimension calibrated specifically in days. Usual calendar is not continuously defined, it contains weekends and (company or region) specific holidays. Any business analysis stands on consistent and continuous time dimension. Typically business operates with concept of T-n day to look into past days or T+n to model future data. The situation indeed goes out of control if data from different regions need to be aggregated and analysed in one report. Another problem occur when calendar is recalculated daily and calcualations have iterative nature. In simple words if one day is missing the whole calendar become useless.

The reliable way to handle it is to precalculate the time dimension which bind Today date, Business date and T-n value. A cross table should be built of Business date let's say in rows and Today's date in columns and T-n as values. in this particular project solution is implemented as series of SQL scripts and tables. 
