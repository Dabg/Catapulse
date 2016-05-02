
var on_change_refresh_rate = 1000;

$( function() {

    setupToggleMaximized();

    $('#body').each(function() { this.focus(); })

    var timer;
    $('#body').keyup(function () {
        clearTimeout(timer);
        timer = setTimeout(function (event) {
            fetch_preview();
        }, on_change_refresh_rate);
    });

})



function insertTags(txtarea,tagOpen, tagClose, sampleText) {

    txtarea = document.getElementById(txtarea);
    var theSelection;

    // IE / Opera
    if(document.selection && document.selection.createRange) {
        theSelection = document.selection.createRange().text;
        if(!theSelection){ theSelection = sampleText; }
        txtarea.focus();
        if(theSelection.charAt(theSelection.length - 1) == " "){// exclude ending space char, if any
            theSelection = theSelection.substring(0, theSelection.length - 1);
            document.selection.createRange().text = tagOpen + theSelection + tagClose + " ";
        } else {
            document.selection.createRange().text = tagOpen + theSelection + tagClose;
        }

    // FireFox / Safari / Konqueror
    } else if (txtarea.selectionStart || txtarea.selectionStart == '0') { // Mozilla
        var startPos = txtarea.selectionStart;
        var endPos = txtarea.selectionEnd;
        var scrollTop=txtarea.scrollTop;
        theSelection = txtarea.value.substring(startPos, endPos);
        if(!theSelection){ theSelection = sampleText; }
        if(theSelection.charAt(theSelection.length - 1) == " "){ // exclude ending space char, if any
            subst = tagOpen + theSelection.substring(0, (theSelection.length - 1)) + tagClose + " ";
        } else {
            subst = tagOpen + theSelection + tagClose;
        }
        txtarea.value = txtarea.value.substring(0, startPos) + subst +
        txtarea.value.substring(endPos, txtarea.value.length);
        txtarea.focus();

        var cPos=startPos+(tagOpen.length+theSelection.length+tagClose.length);
        txtarea.selectionStart=cPos;
        txtarea.selectionEnd=cPos;
        txtarea.scrollTop=scrollTop;

        // All others ... such as?
    } else {
        var copy_alertText=sampleText;
        var re1=new RegExp("\\$1","g");
        var re2=new RegExp("\\$2","g");
        copy_alertText=copy_alertText.replace(re1,sampleText);
        copy_alertText=copy_alertText.replace(re2,tagOpen+sampleText+tagClose);
        var text;
        if (sampleText) {
            text=prompt(copy_alertText);
        } else {
            text="";
        }
        if(!text) { text=sampleText;}
        text=tagOpen+text+tagClose;
        document.infoform.infobox.value=text;
        // in Safari this causes scrolling
        if(!is_safari) {
            txtarea.focus();
        }
        noOverwrite=true;
    }
    // redraw preview window
    fetch_preview();
    // reposition cursor if possible
    if (txtarea.createTextRange) txtarea.caretPos = document.selection.createRange().duplicate();
    return false;
}



var fetch_preview = function() {
    $('#editspinner').show();
    $.ajax({
        data: {content: $('#body').attr('value')},
        type: 'POST',
        url:  $('#preview_url').attr('href'),
        error: function (request, error) {
            console.log("Failed to submit");
            console.log(arguments);
            $('#editspinner').hide();
        },
        success: function(r) {
            $('#content_preview').html(r);
            $('#editspinner').hide();
        }
    })
  }



setupToggleMaximized = function() {
    var $img    = $('<img id="maximize"/>');
    var max     = $("#container").hasClass('maximized-container');
    var img_uri = $.uri_for_static("/gfx/maximize_width_X.png");

    var toggle = function() {
        if(max) {
            $("#container").addClass('maximized-container');
        }
        else {
            $("#container").removeClass('maximized-container');
        }
        max = !max;
    };

    $img.attr({
        'src': img_uri.replace(/X/, max ? 2 : 1),
        'alt': loc('maximize'),
        'title': loc('maximize width')
    }).hover(
        function() {this.src = img_uri.replace(/X/, max ? 2 : 1)},
        function() {this.src = img_uri.replace(/X/, max ? 1 : 2)}
    ).click(function() {
        $.ajax({
            success: toggle,
            url: $.uri_for("/.json/container_maximize_width/")
                + (max ? 1 : 0)
        });
    });

    $("#breadcrumbs").append( $('<div class="float-right"/>').append($img) );

    toggle();
};
