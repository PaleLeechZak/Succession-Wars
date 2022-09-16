extends Node
class_name Date

enum Months {
	january = 1,
	february = 2,
	march = 3,
	april = 4,
	may = 5,
	june = 6,
	july = 7,
	august = 8,
	september = 9,
	october = 10,
	november = 11,
	december = 12
}

const MonthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

var day = 1
var month = 1
var year = 1970

func _init(day = 24, month = 8, year = 2786):
	self.day = day
	self.month = month
	self.year = year

func add_days(days):
	
	pass

static func get_month_days(year, month):
	if(is_year_leap_year(year) && month == Months.february):
		return 29
	else:
		return MonthDays[month - 1]

static func is_year_leap_year(year):
	var divisible4 = year % 4 == 0
	var divisible100 = year % 100 == 0
	var divisible400 = year % 400 == 0
	
	return divisible4 && (!divisible100 || divisible400)

static func calculate_date_from_ticks(ticks):
	var startDate = Date.new()
	
	
	pass
