import QtQuick 2.0

Item {
    id: sched_wrapper

    property variant model: schedule

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded
    signal trigger
    property var sensor_array
    property int donecount: 0

    ListModel { id: schedule }

    function encodePhrase(x) { return encodeURIComponent(x); }

    function reload() {
        schedule.clear()
        sched_wrapper.sensor_array = new Array()
        var reqs = new Array()
        //var schedule_array = new Array()
        for (var i = 0; i < main.sensor_ids.length; i++){
            reqs.push(new XMLHttpRequest)
            //var req = new XMLHttpRequest;
            var sensor = main.sensor_ids[i]
            reqs[i].open("GET", ip_addr + "/sensors/" + main.sensor_ids[i] + "/schedules");
            //console.log(ip_addr + "/sensors/" + main.sensor_ids[i] + "/schedules")
            reqs[i].setRequestHeader("content-type", "application/json");
            reqs[i].setRequestHeader("accept", "application/json");
            reqs[i].responseType = "json"
            //console.debug("opened xmlHttpRequest")
            var j = i
            reqs[i].onreadystatechange = returnOnReadyStateChange(reqs[i])
            reqs[i].send();
        }
    }

    function returnOnReadyStateChange(req) {

       return  function() {
                        //console.debug("onreadystatechange schedule")
                        status = req.readyState;
                        if (status === XMLHttpRequest.DONE) {
                            //console.debug("mystuff: ", req.responseText)
                            var objectArray = JSON.parse(req.responseText);
                            if (objectArray.errors !== undefined)
                                console.log("Error fetching tweets: " + objectArray.errors[0].message)
                            else {
                                sensor_array.push(objectArray);
                                /*for (var key in objectArray) {
                                    var jsonObject = objectArray[key];
                                    //console.debug(objectArray[key].sensor_id)
                                    sensor_array.push(jsonObject);
                                }*/
                            }
                            if (wasLoading == true){
                                donecount++
                                //console.log(donecount)
                            }
                            if (donecount == main.sensor_ids.length){
                                donecount = 0
                                sched_wrapper.trigger()
                            }
                        }
                        wasLoading = (status === XMLHttpRequest.LOADING);
                    }
    }

    function sorting(){
        //console.log("insort")

        var day_schedule = new Array(7)
        for (var day = 0; day < 7; day ++){
            day_schedule[day] = new Array()
        }

        for (var day = 0; day < 7; day++){
            for (var i = 0; i < sensor_array.length; i++){
                for (var thing in sensor_array[i]){
                    var object = sensor_array[i][thing]
                    if (object.startday === day && object.endday === object.startday){
                        var new_obj = {"starttime": object.starttime , "endtime": object.endtime
                                , "startday": object.startday , "endday": object.endday
                                , "sensor_id": object.sensor_id }
                        day_schedule[day].push(object)
                    }
                    else if (object.startday === day && object.startday !== object.endday
                             && object.startday < object.endday){
                        for (var d = object.startday; d <= object.endday; d++){
                            var sd, ed, st, et
                            sd = ed = d
                            if (d == object.startday){
                                st = object.starttime
                                et = 1339
                            }
                            else if (d == object.endday){
                                st = 0
                                et = object.endtime
                            }
                            else {
                                st = 0
                                et = 1339
                            }
                            var new_obj = {"starttime": st , "endtime": et
                                    , "startday": sd , "endday": ed
                                    , "sensor_id": object.sensor_id }
                            day_schedule[d].push(new_obj)
                        }
                    }
                    else if (object.startday === day && object.startday !== object.endday
                             && object.startday > object.endday){
                        for (var d = object.startday; d <= 6; d++){
                            var sd, ed, st, et
                            sd = ed = d
                            if (d == object.startday){
                                st = object.starttime
                                et = 1339
                            }
                            else {
                                st = 0
                                et = 1339
                            }
                            var new_obj = {"starttime": st , "endtime": et
                                    , "startday": sd , "endday": ed
                                    , "sensor_id": object.sensor_id }
                            day_schedule[d].push(new_obj)
                        }
                        for (var d = 0; d <= object.endday; d++){
                            var sd, ed, st, et
                            sd = ed = d
                            if (d == object.endday){
                                st = 0
                                et = object.endtime
                            }
                            else {
                                st = 0
                                et = 1339
                            }
                            var new_obj = {"starttime": st , "endtime": et
                                    , "startday": sd, "endday": ed
                                    , "sensor_id": object.sensor_id }
                            day_schedule[d].push(new_obj)
                        }
                    }
                }
            }
        }

        for (var day = 0; day < 7; day++){
            //console.log(JSON.stringify(day_schedule[day]))
            day_schedule[day].sort(function(a, b){
                return a.starttime - b.starttime;
            })
            //console.log(JSON.stringify({"day": day, "schedule":day_schedule[day]}))
            schedule.append({"day": day, "schedule":day_schedule[day]})
            //console.log(JSON.stringify(schedule[day]))
            sched_wrapper.isLoaded()
        }
    }
}
