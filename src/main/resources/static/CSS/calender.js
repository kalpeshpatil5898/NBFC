const calendar = document.querySelector("#calendar_main"),
    input = document.querySelector("#date"),
    calHeader = document.querySelector("#calendar_header"),
    calHeaderTitle = document.querySelector("#calendar_header span"),
    calDays = document.querySelector("#cal_days"),
    days = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ],
    months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ];

let oneDay = 60 * 60 * 24 * 1000;

let rdate = new Date;
rdate.setFullYear(rdate.getFullYear() - 18);
console.log(rdate);

let todayTimestamp =
    rdate -
    (rdate % oneDay) +
    new Date().getTimezoneOffset() * 1000 * 60;

let selectedDay = todayTimestamp;
const getNumberOfDays = (year, month) => {
    return 40 - new Date(year, month, 40).getDate();
};

const getDayDetails = (args) => {
    let date = args.index - args.firstDay;
    let day = args.index % 7;
    let prevMonth = args.month - 1;
    let prevYear = args.year;
    if (prevMonth < 0) {
        prevMonth = 11;
        prevYear--;
    }
    let prevMonthNumberOfDays = getNumberOfDays(prevYear, prevMonth);

    let _date = (date < 0 ? prevMonthNumberOfDays + date : date % args.numberOfDays) + 1;
    let month = date < 0 ? -1 : date >= args.numberOfDays ? 1 : 0;
    let timestamp = new Date(args.year, args.month, _date).getTime();
    return {
        date: _date,
        day,
        month,
        timestamp,
        dayString: days[day]
    };
};

const getMonthDetails = (year, month) => {
    let firstDay = new Date(year, month).getDay();
    let numberOfDays = getNumberOfDays(year, month);
    let monthArray = [];
    let rows = 5;
    let currentDay = null;
    let index = 0;
    let cols = 7;

    for (let row = 0; row < rows; row++) {
        for (let col = 0; col < cols; col++) {
            currentDay = getDayDetails({
                index,
                numberOfDays,
                firstDay,
                year,
                month
            });
            monthArray.push(currentDay);
            index++;
        }
    }
    return monthArray;
};

let year = rdate.getFullYear();
let month = rdate.getMonth();
let monthDetails = getMonthDetails(year, month);

const isCurrentDay = (day, cell) => {
    if (day.timestamp === todayTimestamp) {
        cell.classList.add("active");
        cell.classList.add("isCurrent");
    }
};

const isSelectedDay = (day, cell) => {
    if (day.timestamp === selectedDay) {
        cell.classList.add("active");
        cell.classList.add("isSelected");
    }
};

const getMonthStr = (month) =>
    months[Math.max(Math.min(11, month), 0)] || "Month";

const setHeaderNav = (offset) => {
    if (offset == 12) {
        year++;
    }
    else if (offset == -12) {
        year--;
    }
    else {
        month = month + offset;
        if (month === -1) {
            month = 11;
            year--;
        } else if (month === 12) {
            month = 0;
            year++;
        }
    }
    monthDetails = getMonthDetails(year, month);
    return {
        year,
        month,
        monthDetails
    };
};

const setHeader = (year, month) => {
    calHeaderTitle.innerHTML = getMonthStr(month) + " " + year;
};

setHeader(year, month);

const getDateStringFromTimestamp = (timestamp) => {
    let dateObject = new Date(timestamp);
    let month = dateObject.getMonth();
    let date = dateObject.getDate();

    return `${getMonthStr(month)} ${date}, ${dateObject.getFullYear()}`;
};

const setDateToInput = (timestamp) => {
    let dateString = getDateStringFromTimestamp(timestamp);
    input.value = dateString;
};
setDateToInput(todayTimestamp);

for (let i = 0; i < days.length; i++) {
    let div = document.createElement("div"),
        span = document.createElement("span");

    div.classList.add("cell_wrapper");
    span.classList.add("cell_item");

    span.innerText = days[i].slice(0, 2);

    div.appendChild(span);
    calDays.appendChild(div);
}

const setCalBody = (monthDetails) => {
    for (let i = 0; i < monthDetails.length; i++) {
        let div = document.createElement("div"),
            span = document.createElement("span");

        div.classList.add("cell_wrapper");
        div.classList.add("cal_date");
        monthDetails[i].timestamp <= rdate && monthDetails[i].month === 0 && div.classList.add("current");
        monthDetails[i].month === 0 && isCurrentDay(monthDetails[i], div);
        span.classList.add("cell_item");

        span.innerText = monthDetails[i].date;

        div.appendChild(span);
        calendar.appendChild(div);
    }
};

setCalBody(monthDetails);

const updateCalendar = (btn) => {
    let newCal, offset;
    if (btn.classList.contains("back")) {
        offset = -1;
    } else if (btn.classList.contains("front")) {
        offset = 1;
    }
    else if (btn.classList.contains("yr-back")) {
        offset = -12;
    }
    else if (btn.classList.contains("yr-front")) {
        offset = 12;
    }
    newCal = setHeaderNav(offset);
    setHeader(newCal.year, newCal.month);
    calendar.innerHTML = "";
    setCalBody(newCal.monthDetails);
};

const selectOnClick = () => {
    document.querySelectorAll(".cell_wrapper").forEach((cell) => {
        cell.classList.contains("isSelected") && cell.classList.remove("active");

        if (cell.classList.contains("isCurrent") &&
            !cell.classList.contains("active")) {
            cell.querySelector("span").classList.add("inactive_indicator");
        }
    });
};


const updateInput = () => {
    let currentDay = document.querySelector(".isCurrent");

    document.querySelectorAll(".cell_wrapper").forEach((cell) => {
        if (cell.classList.contains("current")) {
            cell.addEventListener("click", (e) => {
                let cell_date = e.target.textContent;

                currentDay !== null && currentDay.classList.remove("active");

                for (let i = 0; i < monthDetails.length; i++) {
                    if (monthDetails[i].month === 0) {
                        if (monthDetails[i].date.toString() === cell_date) {
                            selectedDay = monthDetails[i].timestamp;
                            setDateToInput(selectedDay);
                            selectOnClick();

                            isSelectedDay(monthDetails[i], cell);

                            cell.querySelector('span').classList.contains('inactive_indicator')
                                && cell.querySelector('span').classList.remove('inactive_indicator');
                        }
                    }
                }

                document.querySelector('#date_picker_calendar').classList.toggle('hidden');
                document.querySelector('#date_picker_input').classList.toggle('showCal');
                document.querySelector('#date').classList.toggle('onFocus');
            });
        }
    });
};

updateInput();

document.querySelectorAll(".cal-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
        updateCalendar(btn);
        updateInput();
    });
});

input.addEventListener('click', () => {
    document.querySelector('#date_picker_calendar').classList.toggle('hidden');
    document.querySelector('#date_picker_input').classList.toggle('showCal');
    document.querySelector('#date').classList.toggle('onFocus');
});
