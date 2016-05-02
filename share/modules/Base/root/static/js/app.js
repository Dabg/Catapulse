jQuery.uri_for = function(path) { return '/' + path }
jQuery.uri_for_static = function(path) { return '/static/' + path }

function loc(str) {
    if ( (typeof(locale) === 'undefined') || (typeof locale[str] === 'undefined') )
        return str;
    return locale[str]
}


$(document).ready(function() {


    $('.toggleInfo').click(function() {
        $('#hidden_info').toggle();
        return false;
    });

    $('#commentForm').livequery(function() {
         $('#commentForm').ajaxForm({
            target: '#comments'
        });
    });

});
