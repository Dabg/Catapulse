/* make sure we've got a MojoMojo namespace */
if (typeof(MojoMojo) === 'undefined') MojoMojo = {};


// function to trigger another after a specified period of time.
function oneshot() {
    var timer;
    return function( fun, time ) {
        clearTimeout( timer );
        timer = setTimeout( fun, time );
    };
}
var oneshot_preview = oneshot();
var oneshot_pause = 1000;  // Time in milliseconds.
var on_change_refresh_rate = 10000;

jQuery.uri_for = function(path) { return 'http://localhost:3000' + path }
jQuery.uri_for_static= function(path) { return '/static//' + path }

$( function() {

    setupToggleMaximized();

    $('#body').each(function() { this.focus(); })
    $('#body').keyup(function() {
       fetch_preview.only_every(on_change_refresh_rate);
       oneshot_preview(fetch_preview, oneshot_pause);
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
    jQuery.ajax({
        data: {content: $('#body').attr('value')},
        type: 'POST',
        url:  $('#preview_url').attr('href'),
        timeout: 2000,
        error: function() {
            console.log("Failed to submit");
            $('#editspinner').hide();
        },
        success: function(r) {
            $('#content_preview').html(r);
            $('#editspinner').hide();
        }
    })
  }


// Based on http://www.germanforblack.com/javascript-sleeping-keypress-delays-and-bashing-bad-articles
Function.prototype.only_every = function (millisecond_delay) {
    if (!window.only_every_func) {
        var function_object = this;
        window.only_every_func = setTimeout(function() { function_object(); window.only_every_func = null}, millisecond_delay);
    }
};

// jQuery extensions
jQuery.prototype.any = function(callback) {
    return (this.filter(callback).length > 0)
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
