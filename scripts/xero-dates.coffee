#some handlers to make it easier to use dates with the way Xero handles them!
#first get some dates for the queries - based off http://www.w3resource.com/coffeescript-exercises/coffeescript-exercise-2.php

today = new Date
dd = today.getDate()
if dd < 10
  dd = '0' + dd
#The value returned by getMonth is an integer between 0 and 11, referring 0 to January, 1 to February, and so on. 
mm = today.getMonth() + 1
if mm < 10
  mm = '0' + mm
yyyy = today.getFullYear()

# some important accounting dates
lastDayOfTheMonthDate = new Date(yyyy, mm, 0)
lastDayOfTheMonth = lastDayOfTheMonthDate.getDate()             #how many days in the month
today = dd + '-' + mm + '-' + yyyy
(->@)().yd = dd-3                                                     #yesterday in date format

#now make some formats for Xero to use
todayXero = yyyy + '-' + mm + '-' + dd
yesterdayXero=yyyy + '-' + mm + '-' + yd
endOfMonthXero=yyyy + '-' + mm + '-' + lastDayOfTheMonth
percentOfMonth=dd/lastDayOfTheMonth
 