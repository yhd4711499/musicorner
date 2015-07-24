Meteor.autorun(->
    Session.set("isAdmin", Meteor.user()?.admin);
)