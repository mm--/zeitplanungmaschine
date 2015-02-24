window.onload = function() {
    $("#time").text(moment().format('MMMM Do YYYY'));
    $("#week").text("W" + moment().format('WW-E'));
    var firstDay = moment().dayOfYear(1);
    var nextYear = moment(firstDay).add(1, 'year');
    var daysinyear = nextYear.diff(firstDay, 'days');
    $("#day").text(moment().dayOfYear() + "/-" + nextYear.diff(moment(), 'days'));
};
