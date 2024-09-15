/**
* @OnlyCurrentDoc
*/

function sendMap() {
    var sheet = SpreadsheetApp.getActiveSheet();
    var address = sheet.getRange("A1").getValue();
    var map = Maps.newStaticMap().addMarker(address);
    GmailApp.sendEmail("student-00-63f445c30f65@qwiklabs.net", "Map", 'See below.', {attachments:[map]});
}