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

$( function() {

    setupToggleMaximized();

    $('#body').each(function() { this.focus(); })
    $('#body').keyup(function() {
       fetch_preview.only_every(on_change_refresh_rate);
       oneshot_preview(fetch_preview, oneshot_pause);
    });
})

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
