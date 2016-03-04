        function toggleState(item){
        if(item.className == "cb_mute") {
              item.className="cb_on";
              item.value="1";
              item.checked=true;
        } else if(item.className == "cb_on") {
              item.className="cb_off";
              item.value="0";
              item.checked=false;
        } else {
              item.className="cb_mute";
              item.value="";
              item.indeterminate=true;
           }
        }

