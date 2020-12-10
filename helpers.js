const moment = require("moment-timezone");

function formatDate(date) {
  return moment(date).format("MMMM D, YYYY");
}

function rfc822Date(date) {
    return moment(date).tz("America/New_York").format("ddd, D MMM YYYY HH:mm:ss z");
}

function now() {
    return new Date();
}

module.exports = {
    formatDate,
    rfc822Date,
    now
};
