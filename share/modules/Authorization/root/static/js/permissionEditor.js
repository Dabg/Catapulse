/* make sure we've got a MojoMojo namespace */
if (typeof(MojoMojo) === 'undefined') MojoMojo = {};


MojoMojo.PermissionsEditor = function(params) {
    var container = $(params.container);

    var API = {
        clear_permissions: function (link) {
          var span = link.parentNode;
          var td   = span.parentNode;
          var row  = td.parentNode;

          var values = [];
          $(row).find('input').map( function(i, elt) {
            if (elt.type == 'checkbox')
              values.push(elt.name + "=" + (elt.checked ? "1" : "0"));
            else
              values.push(elt.name + "=" + elt.value);
          } );

          $.ajax({
            type: "POST",
            url: link.href,
            data: values.join("&"),
            success: function() {
              $(row).find('input').removeClass('cb_on').addClass('cb_mute');;
              $(row).find('input').removeClass('cb_off').addClass('cb_mute');;
              $(row).find('input.perm_op').val('');
              $(td).find('span, span a').addClass('hide');
            }
          });

          return false;
        },
        enable_edit: function (link) {
          $(link.parentNode).find('a').toggleClass('hide');
          $(link.parentNode).find('span, span a').addClass('hide');
          $(link.parentNode.parentNode).find('input').removeAttr('disabled');

          return false;
        },
        save_changes: function (link) {
          var td  = link.parentNode;
          var row = td.parentNode;

          var values = [];
          $(row).find('input').map( function(i, elt) {
            if (elt.type == 'checkbox')
              values.push(elt.name + "=" + (elt.checked ? "1" : "0"));
            else
              values.push(elt.name + "=" + elt.value);
          } );

          $.ajax({
            type: "POST",
            url: link.href,
            data: values.join("&"),
            success: function() {
              $(row).find('input').attr('disabled', 'disabled');
              $(td).find('a,span').toggleClass('hide');
            }
          });

          return false;
        }
    };

    container.find(params.selectors.edit ).click( function() { return API.enable_edit(this) } );
    container.find(params.selectors.save ).click( function() { return API.save_changes(this) } );
    container.find(params.selectors.clear).click( function() { return API.clear_permissions(this) } );

    return API;
};

MojoMojo.RoleForm = function(params) {
    var container = $(params.container);

    var member_input = container.find(params.selectors.member_input);
    var role_members = container.find(params.selectors.role_members);

    var API = {
        remove_member: function (link) {
          var li   = link.parentNode;
          var list = li.parentNode;
          list.removeChild(li);

          var remaining = list.getElementsByTagName('li');
          if (remaining.length == 1) {
            $(remaining[0]).removeClass('hide');
          }
        },
        setup_autocomplete: function() {
            var select_item = function (input, data) {
              member_input.attr('value', '');

              // check if it's already added
              if (role_members.find("li.member input[value='" + data[1] + "']").length == 0) {
                role_members.append(
                  '<li class="member">' +
                    data[0] +
                    '<input type="hidden" name="role_members" value="' + data[1] + '"/> ' +
                    '<a class="clickable remove_member">[remove]</a>' +
                  '</li>'
                );
                var remove_links = container.find(params.selectors.remove_member);
                $(remove_links.get(remove_links.length - 1)).click( function() { return API.remove_member(this) } );

                role_members.find("li.empty").addClass('hide');
              }
            };

            var format_item = function (row) {
              return row[0];
            };

            $(document).ready(function() {
              member_input.autocomplete(
                params.user_search_url,
                {
                  minChars:      1,
                  matchSubset:   1,
                  matchContains: 1,
                  cacheLength:   10,
                  formatItem:    format_item,
                  selectOnly:    1
                }
              ).result(select_item);
            });
        }
    };

    container.find(params.selectors.remove_member).click( function() { return API.remove_member(this) } );

    API.setup_autocomplete();

    return API;
};


var uploader;
$( function() {

    new MojoMojo.PermissionsEditor({
        container: '#permissions_editor',
        selectors: {
            edit:  '.enable_edit',
            save:  '.save_changes',
            clear: '.clear_permissions'
        }
    });

    new MojoMojo.RoleForm({
        container:       '#role_form',
        selectors: {
            member_input:  '#member_input',
            role_members:  '#role_members',
            remove_member: '.remove_member'
        },
        user_search_url: $('#user_search_url').attr('value')
    });
    $("#taginput").autocomplete($('#autocomplete_url').attr('href'), {
        dataType: 'json',
        parse: function(data) {
            var result = [];
            for (var i = 0; i < data.tags.length; i++) {
                result[i] = { data: data.tags[i],
                              value: data.tags[i],
                              result: data.tags[i]
                             };
            }
            return result;
        },
        formatItem: function(row, i, max) {
            return row;
        },
        width: 120,
        highlight: false,
        multiple: true,
        multipleSeparator: " "
    });
})
