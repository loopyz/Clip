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
            }
        });                
    });

    var Campaign = Parse.Object.extend("Campaign");

    $('#create_campaign_form').on('submit', function(e) {
        e.preventDefault();
        var title = $('#title').val();
        var description = $('#description').val();
        //var image = $('#image').val();
        var start_date = $('#start_date').val();
        var end_date = $('#end_date').val();
        var expiration = $('#expiration').val()
        var youngestAge = $('#youngestAge').val()
        var oldestAge = $('#oldestAge').val()
        var state = $('#state').val()
        var i1 = $('#i1').val()
        var campaign = new Campaign();
        
        campaign.set("title", title);
        campaign.set("description", description);
        //campaign.set("image", image);
        campaign.set("start_date", start_date);
        campaign.set("end_date", end_date);
        campaign.set("expiration", expiration);
        campaign.set("youngestAge", parseInt(youngestAge));
        campaign.set("oldestAge", parseInt(oldestAge));
        campaign.set("state", state);
        campaign.set("i1", i1);

        var owner = Parse.User.current();
        var relation = owner.relation("campaigns");
        campaign.set("owner", owner.username);

        campaign.save(null, {
            success: function(campaign) {
                console.log('This campaign was saved');
                relation.add(campaign);
                owner.save();
                var id = campaign.id
                window.open("/viewCampaign?id=" + id, "_self");
            }, error: function(campaign, error) {
                console.log("some error " + error.code + " "  + error.message);
            }
        });
    });
});
