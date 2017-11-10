$(function() {
    // 获取平台用户头像显示
    $.get('/menu_links/getuid', function(json) {
        var avatar = $('<img/>')
            .attr('alt', $('#loggedas .user').text())
            .addClass('avatar')
            .appendTo('#account');
        $('<span class="caret"></span>').appendTo('#account');
        $('#account img, #account .caret').click(function(e) {
            if ($('#account ul').is(':hidden')) {
                $('#account ul').show();
                return e.stopPropagation();
            }
        });
        $(document).click(function() {
            if ($('#account ul').is(':visible')) {
                $('#account ul').hide();
            }
        });
        avatar.attr('src', 'https://usr.saas-plat.com/photo/' + json.login);
    });
})
