const app = require('express')();
const server = require('http').Server(app);
const io = require('socket.io')(server);
const mysql = require('mysql');
const request = require('request');

server.listen(3000);

console.log('server started');
let pool  = mysql.createPool({
    connectionLimit : 100000000000,
    host            : 'localhost',
    user            : 'root',
    password        : 'adgjmp1966',
    database        : 'app',
    charset  : 'utf8',
    multipleStatements: true
});
setInterval(function () {
    request.get('http://185.111.106.48/api/v2/auto/check',
        function (error, response, body) {
            console.log(body)
        }
    );

},86400000);
function get_sql (data,callback) {
    pool.getConnection(function (err,connection) {
        connection.query(data, function (err, results) {
            if (err){
                throw err;
            }
            connection.release()
            return callback(results);
        });
    })
}
function get_time (){
    return moment(new Date()).format('YYYY-MM-DD H:mm:ss')
}
function get_time_parse (data) {
    return moment(data).format('YYYY-MM-DD H:mm:ss')
}
function send_push (topic,data) {
    console.log("PUSH to -> ", topic);
    var headers = {
        'Authorization': 'key=AAAAs-aGZ7E:APA91bEKxqW0mT9bj2HxXt9YBgVz7xt_Ee-dJmYtbnm6w9c2nj3skVDs_rjnwPG8b5nyxIa_RD7G_vYle8uTtQhKA1hyJXqBJTEWdTHOygyT6shwxe7qxaG0VP1TQ9I2HgCyJh-ifMaM',
        'Content-Type': 'application/json'
    };
    var headers_ios = {
        'Authorization': 'key=AAAAs-aGZ7E:APA91bEKxqW0mT9bj2HxXt9YBgVz7xt_Ee-dJmYtbnm6w9c2nj3skVDs_rjnwPG8b5nyxIa_RD7G_vYle8uTtQhKA1hyJXqBJTEWdTHOygyT6shwxe7qxaG0VP1TQ9I2HgCyJh-ifMaM',
        'Content-Type': 'application/json'
    };
// Configure the request
    var options = {
        url: 'https://fcm.googleapis.com/fcm/send',
        method: 'POST',
        headers: headers,
        json: true,
        body: {
            to:`/topics/${topic}_a`,
            data:data,
            time_to_live : 300
        }
    }
    var options_ios = {
        url: 'https://fcm.googleapis.com/fcm/send',
        method: 'POST',
        headers: headers_ios,
        json: true,
        body: {
            to:`/topics/${topic}`,
            notification:data,
            time_to_live : 300
        }

    };
// Start the request
    request(options, function (error, response, body) {
        if (!error && response.statusCode == 200) {
        }
    });
    request(options_ios, function (error, response, body) {
        if (!error && response.statusCode == 200) {
        }
    })
}



io.on('connection', function (socket) {
    socket.on('online',function (front) {
        console.log("front",front)
        let data = JSON.parse(front);


        // socket.id = data.token;
        console.log('new socket.id',socket.id);
        request.post('http://185.111.106.48/api/online',
            {
                json:{
                    socket_id:socket.id,
                    token:data.token
                }
            },
            function (error, response, body) {
                io.to(socket.id).emit('online',body);
            }
        )
    });
    socket.on('geo',function (front) {

        let data = JSON.parse(front);
        console.log("data.token",data.token);
        request.post('http://185.111.106.48/api/geo',
            {
                json:{
                    token:data.token,
                    lat:data.lat,
                    lon:data.lon
                }
            },
            function (error, response, body) {
                io.emit('geo',body);
            }
        )
    });
    socket.on('geopositions',function (front) {
        console.log(1);
        request.post('http://185.111.106.48/api/geopositions',
            function (error, response, body) {
                io.emit('geopositions',body);
            }
        )
    });
    socket.on('order_create',function (front) {
        let data = JSON.parse(front);

        request.post('http://185.111.106.48/api/order_create',
            {
                json:{
                    token:data.token,
                    from:data.from,
                    from_lat:data.from_lat,
                    from_lon:data.from_lon,
                    to:data.to,
                    to_lat:data.to_lat,
                    to_lon:data.to_lon,
                    price:data.price,
                    count_passenger:data.count_passenger,
                    get_passenger:data.get_passenger,
                    bonus:data.bonus,
                    description:data.description,
                    woman_driver:data.woman_driver,
                    invalid:data.invalid,
                }
            },
            function (error, response, body_order_create) {
                io.to(socket.id).emit('order_create',body_order_create);
                if  (body_order_create['statusCode '] === 200)newList(body_order_create.result.passenger.city_id);
                send_push('order_list_'+body_order_create.result.passenger.city_id ,{title:'New Order',id:body_order_create.result.id,type:'order_create',step:'order_create',sound:'default'})
            }
        )


    });
    socket.on('order_cancel',function (front) {

        let data = JSON.parse(front);

        request.post('http://185.111.106.48/api/order_remove',
            {
                json:{
                    order_id:data.order_id
                }
            },
            function (error, response, body) {
                console.log('order_remove',body);
                if (body['statusCode'] == 200){
                    if (body.result['passenger'].online == 1){
                        console.log(1)
                        io.to(body.result['passenger'].socket_id).emit('order',body);
                    }else{
                        console.log(2)
                        send_push(body.result['passenger'].token,{title:'Cancel',id:data.order_id,type:'taxi_orders',step:'order_cancel',sound:'default'});
                    }
                    if (body.result['driver_id'] != null){
                        if (body.result['driver'].online == 1){
                            io.to(body.result['driver'].socket_id).emit('order',body);

                        }else{
                            send_push(body.result['driver'].token,{title:'Cancel',id:data.order_id,type:'taxi_orders',step:'order_cancel',sound:'default'});
                        }
                    }
                }
                else{
                    console.log("elseeee")
                }
                // request.post('http://185.111.106.48/api/order_cancel',
                //     {
                //         json:{
                //             token:data.token,
                //             order_id:data.order_id
                //         }
                //     },
                //     function (error, response, body) {
                //
                //     }
                // )

                request.post('http://185.111.106.48/api/order_list',
                    {
                        json:{
                            city_id:data.city_id,
                        }
                    },
                    function (error, response, body) {
                        io.emit('order_list_' + data.city_id,body);

                    }
                )
            }
        )


    });
    socket.on('order_accept',function (front) {
        let data = JSON.parse(front);

        request.post('http://185.111.106.48/api/order_accept',
            {
                json:{
                    token:data.token,
                    order_id:data.order_id
                }
            },
            function (error, response, body) {

                if (body['statusCode'] == 200){
                    if (body.result['passenger'].online == 1){
                        io.to(body.result['passenger']['socket_id']).emit('order',body);
                    }else{
                        send_push(body.result['passenger'].token,{title:'Driver order accept!!!',id:data.order_id,type:'taxi_orders',step:'order_accept',sound:'default'});
                    }
                    request.post('http://185.111.106.48/api/order_list',
                        {
                            json:{
                                city_id:body.result.city_id,
                            }
                        },
                        function (error, response, body) {
                            io.emit('order_list_'+body.result.city_id,body);
                        }
                    )
                }
                else if (body['statusCode'] == 202){
                    io.to(socket.id).emit('order',body);
                }
            }
        )
    });
    socket.on('order_trade',function (front) {
        let data = JSON.parse(front);
        console.log("front data ",data);
        /*
            driver_id
            order_id
            price
        */
        request.get('http://185.111.106.48/api/user/'+data.driver_id,
            function (error, response, driver) {
                driver = JSON.parse(driver);
                // console.log("driver",driver)
                if (driver['statusCode'] == 200){
                    request.get('http://185.111.106.48/api/taxi_order/'+data.order_id,
                        function (error, response, order) {
                            order = JSON.parse(order);
                            // console.log("order",order)
                            if (order['statusCode'] == 200){
                                if (order.result['passenger'].online == 1){
                                    io.to(order.result['passenger']['socket_id']).emit('order_trade',JSON.stringify({
                                        price:data.price,
                                        driver:driver,
                                        order:order}));


                                    console.log("order_trade","passenger send")

                                }else{
                                    send_push(order.result.passenger.token,{
                                        title:'The driver has bid',
                                        id:order.result.id,
                                        driver_id:data.driver_id,
                                        price:data.price,

                                        type:'order_trade',
                                        step:'order_trade',
                                        sound:'default'});
                                    console.log("order_trade","passenger offline")
                                }
                            }
                            else{

                                console.log("order_trade","status != 200")
                            }
                        }
                    )
                }else{
                    console.log("order_trade user",driver)
                }
            }
        )
    });
    socket.on('order_trade_accept',function (front) {
        let data = JSON.parse(front);
        /*
            order_id
            driver_id
            price
         */
        request.post('http://185.111.106.48/api/order_trade_accept',
            {
                json:{
                    order_id:data.order_id,
                    driver_id:data.driver_id,
                    price:data.price
                }
            },
            function (error, response, body) {
            console.log(body)
                if (body['statusCode'] == 200){
                    if (body.result['driver'].online == 1){
                        io.to(body.result['driver']['socket_id']).emit('order_trade_accept',body);
                    }else{
                        send_push(body.result['driver'].token,{title:'Passenger order accept!!!',id:data.order_id,type:'taxi_orders',step:'order_trade_accept',sound:'default'});
                    }
                    io.to(socket.id).emit('order',body);
                    request.post('http://185.111.106.48/api/order_list',
                        {
                            json:{
                                city_id:body.result.city_id,
                            }
                        },
                        function (error, response, body) {
                            io.emit('order_list_'+body.result.city_id,body);
                        }
                    )
                }
                else if (body['statusCode'] == 202){
                    io.to(socket.id).emit('order',body);
                }
            }
        )

    });
    socket.on('order_arrived',function (front) {
        let data = JSON.parse(front);
        request.post('http://185.111.106.48/api/order_arrived',
            {
                json:{
                    token:data.token,
                    order_id:data.order_id
                }
            },
            function (error, response, body) {
                if (body['statusCode '] == 200){
                    if (body.result['passenger'].online == 1){
                        io.to(body.result['passenger'].socket_id).emit('order',body);
                    }else{
                        send_push(body.result['passenger'].token,{title:'Order arrived!',id:data.order_id,type:'taxi_orders',step:'order_arrived',sound:'default'});
                    }
                    if (body.result['driver'].online == 1){
                        io.to(body.result['driver'].socket_id).emit('order',body);
                    }else{
                        send_push(body.result['driver'].token,{title:'Order arrived!!!',id:data.order_id,type:'taxi_orders',step:'order_arrived',sound:'default'});
                    }
                }
                else{
                }

                request.post('http://185.111.106.48/api/order_list',
                    {
                        json:{
                            city_id:body.result.city_id,
                        }
                    },
                    function (error, response, body) {
                        io.emit('order_list_'+body.result.city_id,body);
                    }
                )
            }
        )

    });
    socket.on('order_out',function (front) {
        let data = JSON.parse(front);
        request.post('http://185.111.106.48/api/order_out',
            {
                json:{
                    token:data.token,
                    order_id:data.order_id
                }
            },
            function (error, response, body) {
                if (body['statusCode '] == 200){
                    if (body.result['passenger'].online == 1){
                        io.to(body.result['passenger'].socket_id).emit('order',body);
                    }else{
                        send_push(body.result['passenger'].token,{title:'order out!!!',id:data.order_id,type:'taxi_orders',step:'order_out',sound:'default'});
                    }
                    if (body.result['driver'].online == 1){
                        io.to(body.result['driver'].socket_id).emit('order',body);
                    }else{
                        send_push(body.result['driver'].token,{title:'order out!!!',id:data.order_id,type:'taxi_orders',step:'order_out',sound:'default'});
                    }
                }
                else{
                }
                request.post('http://185.111.106.48/api/order_list',
                    {
                        json:{
                            city_id:body.result.city_id,
                        }
                    },
                    function (error, response, body) {
                        io.emit('order_list_'+body.result.city_id,body);
                    }
                )
            }
        )

    });
    socket.on('order_end',function (front) {
        let data = JSON.parse(front);
        request.post('http://185.111.106.48/api/order_end',
            {
                json:{
                    token:data.token,
                    order_id:data.order_id
                }
            },
            function (error, response, body) {
                if (body['statusCode '] == 200){
                    if (body.result['passenger'].online == 1){
                        io.to(body.result['passenger'].socket_id).emit('order',body);

                    }else{
                        send_push(body.result['passenger'].token,{title:'order end!!!',id:data.order_id,type:'taxi_orders',step:'order_end',sound:'default'});
                    }
                    if (body.result['driver'].online == 1){
                        io.to(body.result['driver'].socket_id).emit('order',body);
                    }else{
                        send_push(body.result['driver'].token,{title:'order out!!!',id:data.order_id,type:'taxi_orders',step:'order_end',sound:'default'});
                    }
                }
                else{
                }
                request.post('http://185.111.106.48/api/order_list',
                    {
                        json:{
                            city_id:body.result.city_id,
                        }
                    },
                    function (error, response, body) {
                        io.emit('order_list_'+body.result.city_id,body);
                    }
                )
            }
        )

    });
    socket.on('order_list',function (id) {
        request.post('http://185.111.106.48/api/order_list',
            {
                json:{
                    city_id:id,
                }
            },
            function (error, response, body) {
                io.emit('order_list_'+id,body);
            }
        )
    });
    socket.on('driver_position',function (front) {
        let data = JSON.parse(front);
        request.get('http://185.111.106.48/api/taxi_order/'+data.order_id,
            function (error, response, body) {
            let lara = JSON.parse(body);
                if (lara['statusCode'] == 200){
                    if (lara.result['passenger'].online == 1){
                        io.to(lara.result['passenger'].socket_id).emit('driver_position',JSON.stringify({lat:data.lat,lon:data.lon}));
                    }else{
                    }
                }
                else{
                    console.log('driver position get not found 404!')
                }
            }
        )
    });
    socket.on('user_position',function (front) {
        let data = JSON.parse(front);
        console.log('user_position',data);
        request.post('http://185.111.106.48/api/geo',
            {
                json:{
                    token:data.token,
                    lat:data.lat,
                    lon:data.lon
                }
            },
            function (error, response, body) {
                if (body['statusCode '] === 200){
                    io.emit('user_position_' + body.result.id,body);
                }
            }
        )
    });
    socket.on('disconnect',function (reason) {
        console.log('disconnect',socket.id);
        request.post('http://185.111.106.48/api/offline',
            {
                json:{
                    socket_id:socket.id,
                }
            },
            function (error, response, body) {
                io.emit('offline',JSON.stringify({socket_id : socket.id}));
            }
        )
    });

    function newList(city_id) {
        request.post('http://185.111.106.48/api/order_list',
            {
                json:{
                    'city_id':city_id
                }
            },
            function (error, response, body) {
                io.emit('order_list_' + city_id,body);
                console.log('order_list_' + city_id)




            }
        )
    }
});


setInterval( function () {
    request.post('http://185.111.106.48/api/geopositions',
        function (error, response, body) {
            io.emit('geopositions',body);
        }
    )
},20000);
//SELECT ps.name, ord.* FROM orders ord JOIN passengers ps ON ord.passenger_id = ps.id WHERE access = '1' AND ord.status = '1'
