$(function () {
    Parse.initialize("zJDkcisSASpMHkV9VCpEJFbkrO16eJv6g1i5UxjU", "NYTIqi6mJbKUr3AbR8JpofmqRfYpWOrz6shdngud");
    
    $('#login_form').on('submit', function(e) {
        e.preventDefault();
        var username = $('#login-username').val();
        var password = $('#login-password').val();
       
        Parse.User.logIn(username, password, {
            success: function (user) {
                console.log(user.get('username'));
                window.open("home","_self");
            }, error: function (user, error) {
                console.log(error.code + ' ' + error.message);
                // create new parse user
                var user = new Parse.User();
                user.set("username", username);
                user.set("password", password);
                user.set("type", "business");

                user.signUp(null, {
                    success: function (user) {
                        console.log("signed up");
                        window.open("home","_self");
                    },
                    error: function (user, error) {
                        console.log("not signed up, some error " + error.code + " " + error.message);
                    }
                });
            }});

 
                
    });

});

