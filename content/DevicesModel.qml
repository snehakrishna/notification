import QtQuick 2.0

Item {
    id: wrapper
    property variant model: devices

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    ListModel { id: devices }
    function encodePhrase(x) { return encodeURIComponent(x); }

    function reload() {
        devices.clear()

        var req = new XMLHttpRequest;
        req.open("GET", ip_addr + "/sensors", true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        //console.debug("opened xmlHttpRequest")
        req.onreadystatechange = function() {
            //console.debug("onreadystatechange")
            status = req.readyState;
            if (status === XMLHttpRequest.DONE) {
                //console.debug("mystuff: ", req.responseText)
                console.log(req.status)
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined)
                    console.log("Error fetching tweets: " + objectArray.errors[0].message)
                else {
                    for (var key in objectArray) {
                        var jsonObject = objectArray[key];
                        devices.append(jsonObject);
                    }
                }
                if (wasLoading == true)
                    wrapper.isLoaded()
                scheduleModel.reload()
            }
            wasLoading = (status === XMLHttpRequest.LOADING);
        }
        req.send();
    }
}
