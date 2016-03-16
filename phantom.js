var server = require('webserver').create();
var port = 19003;

var getPage = function(url, callback) {
    var page = require('webpage').create();

    // запрашиваем страницу, ждём 200 мс, чтобы ангуляр успел завершить работу
    // можно попросить сайт отмечать готовность самостоятельно, но это потребует изменения приложения
    // а у нас все-таки простое решение
    page.open(url, function() {
        setTimeout(function() {
            page.evaluate(function() {
                // удаляем мета-тэг фрагмента, иначе контент не будет проиндексирован
                // заодно удалим скрипты, потому что отдаём готовый html
                console.log('test');
                // var fragments = document.getElementsByName('fragment');
                //  fragments[0].parentNode.removeChild(fragment.parentNode);
                // console.log(fragment);
                // jQuery('meta[name=fragment], script').remove()\\

                var script = document.getElementsByTagName('script');

                document.removeChild(script[0]);
            });

            callback(page.content);
            page.close();
        }, 200);
    });
};

// запускаем встроенный в phantomjs веб-сервер
server.listen(port, function(request, response) {
    response.headers = {
        'Content-Type': 'text/html'
    };

    var regexp = /_escaped_fragment_=(.*)$/;
    var fragment = request.url.match(regexp);

    // var url = 'http://localhost:19002/#!' + decodeURIComponent(fragment[1]);
    var url = 'http://127.0.0.1:8000';
    // получаем хтмл и отдаём роботу
    getPage(url, function(content) {
        response.statusCode = 200;
        response.write(content);
        response.close();
    })
});