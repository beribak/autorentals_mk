import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthRange", "calendarsContainer"]
  static values = { 
    bookedDates: Array,
    monthNames: Array,
    weekdayNames: Array
  }

  connect() {
    this.currentStartMonth = new Date();
    this.currentStartMonth.setDate(1); // Start of current month
    
    // Set default values if not provided
    if (!this.monthNamesValue.length) {
      this.monthNamesValue = [
        "Јануари", "Февруари", "Март", "Април", "Мај", "Јуни",
        "Јули", "Август", "Септември", "Октомври", "Ноември", "Декември"
      ];
    }
    
    if (!this.weekdayNamesValue.length) {
      this.weekdayNamesValue = ["Нед", "Пон", "Вто", "Сре", "Чет", "Пет", "Саб"];
    }
    
    // Convert booked dates array to Set for faster lookup
    this.bookedDatesSet = new Set(this.bookedDatesValue);
    
    this.renderCalendars();
  }

  changeMonth(event) {
    const direction = parseInt(event.currentTarget.dataset.direction);
    this.currentStartMonth.setMonth(this.currentStartMonth.getMonth() + direction);
    this.renderCalendars();
  }

  renderCalendars() {
    this.updateMonthRange();
    this.calendarsContainerTarget.innerHTML = '';
    
    // Render 2 months
    for (let i = 0; i < 2; i++) {
      const monthDate = new Date(this.currentStartMonth);
      monthDate.setMonth(this.currentStartMonth.getMonth() + i);
      this.createSingleCalendar(this.calendarsContainerTarget, monthDate);
    }
  }

  updateMonthRange() {
    const startMonth = this.monthNamesValue[this.currentStartMonth.getMonth()];
    const endDate = new Date(this.currentStartMonth);
    endDate.setMonth(this.currentStartMonth.getMonth() + 1);
    const endMonth = this.monthNamesValue[endDate.getMonth()];
    
    if (this.currentStartMonth.getFullYear() === endDate.getFullYear()) {
      this.monthRangeTarget.textContent = `${startMonth} - ${endMonth} ${this.currentStartMonth.getFullYear()}`;
    } else {
      this.monthRangeTarget.textContent = `${startMonth} ${this.currentStartMonth.getFullYear()} - ${endMonth} ${endDate.getFullYear()}`;
    }
  }

  createSingleCalendar(container, monthDate) {
    const calendarDiv = document.createElement('div');
    calendarDiv.className = 'calendar-month';
    
    // Month header
    const headerDiv = document.createElement('div');
    headerDiv.className = 'calendar-header';
    headerDiv.textContent = `${this.monthNamesValue[monthDate.getMonth()]} ${monthDate.getFullYear()}`;
    calendarDiv.appendChild(headerDiv);
    
    // Weekdays
    const weekdaysDiv = document.createElement('div');
    weekdaysDiv.className = 'calendar-weekdays';
    this.weekdayNamesValue.forEach(day => {
      const dayDiv = document.createElement('div');
      dayDiv.className = 'weekday';
      dayDiv.textContent = day;
      weekdaysDiv.appendChild(dayDiv);
    });
    calendarDiv.appendChild(weekdaysDiv);
    
    // Days
    const daysDiv = document.createElement('div');
    daysDiv.className = 'calendar-days';
    this.createDaysForMonth(daysDiv, monthDate);
    calendarDiv.appendChild(daysDiv);
    
    container.appendChild(calendarDiv);
  }

  createDaysForMonth(container, monthDate) {
    const year = monthDate.getFullYear();
    const month = monthDate.getMonth();
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    const daysInMonth = lastDay.getDate();
    const startingDayOfWeek = firstDay.getDay();
    
    // Calculate the complete calendar grid (6 weeks = 42 days)
    const totalCalendarDays = 42;
    
    // Add days from previous month to fill first week
    for (let i = startingDayOfWeek - 1; i >= 0; i--) {
      const prevDate = new Date(year, month, -i);
      this.createDayElement(container, prevDate, true);
    }
    
    // Add all days of current month
    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(year, month, day);
      this.createDayElement(container, date, false);
    }
    
    // Fill remaining cells with next month days to complete 6 weeks
    const daysAdded = startingDayOfWeek + daysInMonth;
    const remainingDays = totalCalendarDays - daysAdded;
    
    for (let day = 1; day <= remainingDays; day++) {
      const nextDate = new Date(year, month + 1, day);
      this.createDayElement(container, nextDate, true);
    }
  }

  createDayElement(container, date, isOtherMonth) {
    const dayDiv = document.createElement('div');
    dayDiv.className = 'calendar-day';
    dayDiv.textContent = date.getDate();
    
    if (isOtherMonth) {
      dayDiv.classList.add('other-month');
    }
    
    // Check if it's today
    const today = new Date();
    if (date.toDateString() === today.toDateString()) {
      dayDiv.classList.add('today');
    }
    
    // Check if day is booked
    const dateStr = date.toISOString().split('T')[0];
    if (this.bookedDatesSet.has(dateStr) && !isOtherMonth) {
      dayDiv.classList.add('booked');
    }
    
    container.appendChild(dayDiv);
  }
}
